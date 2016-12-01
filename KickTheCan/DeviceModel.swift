//
//  DeviceModel.swift
//  KickTheCan
//
//  Created by AtsuyaSato on 2016/11/25.
//  Copyright © 2016年 AtsuyaSato. All rights reserved.
//

import UIKit

enum ServerError : Error {
    case NotFound
    case Unconnect
}
enum DeviceType{
    case Sphero
    case Mio
}
enum ScopeType : String{
    case DriveController = "driveController"
    case Light = "light"
    case Health = "health"
    
}

protocol MIOControllDelegate {
    func trackingHeartrate(heartrate:Int)
}
class DeviceModel: NSObject {
    var data = DeviceData()
    var delegate: MIOControllDelegate!
    var timer:Timer!
    
    class var sharedInstance : DeviceModel {
        struct Singleton {
            static var instance = DeviceModel()
        }
        return Singleton.instance
    }
    ///デバイス探索用関数
    ///- parameter device: SpheroかMioか
    ///- parameter  completion: CallBack用引数
    func findDevice(device: DeviceType, completion: ((Array<Dictionary<String, String>>) -> Void)?) {
        if let server = self.data.serverIP {
            
            let URL = NSURL(string: "\("http://" + server + ":4035/gotapi/servicediscovery")")
            let req = NSURLRequest(url: URL as! URL)
            
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 10
            configuration.timeoutIntervalForResource = 60
            
            let session = URLSession(configuration: configuration, delegate:nil, delegateQueue:OperationQueue.main)
            
            var result:Array<Dictionary<String, String>> = []

            let task = session.dataTask(with: req as URLRequest, completionHandler: {
                (data, response, error) -> Void in
                do {
                    if (data == nil) {
                        throw error!
                    }
                    let json = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments ) as! Dictionary<String, Any>
                    let services = json["services"] as! Array<Dictionary<String, Any>>!
                    
                    for service in services! {
                        if(service["online"] as! Bool == true){
                            if(device == DeviceType.Sphero){
                                if((service["scopes"] as! Array<String>).contains(ScopeType.DriveController.rawValue) && (service["scopes"] as! Array<String>).contains(ScopeType.Light.rawValue)){
                                    //DriveControllerAPIとLightAPIの両方を提供するデバイス
                                    result.append(["name":service["name"] as! String,"id":service["id"] as! String])
                                }
                            }else if(device == DeviceType.Mio){
                                if(service["online"] as! Bool == true){
                                    if((service["scopes"] as! Array<String>).contains(ScopeType.Health.rawValue)){
                                        //HealthAPIを提供するデバイス
                                        result.append(["name":service["name"] as! String,"id":service["id"] as! String])
                                    }
                                }
                            }
                        }
                    }
                    completion!(result)
                } catch {
                    
                }
            })
            task.resume()
        }
    }
    ///缶蹴りで使用するデバイスのセット
    ///- parameter device: SpheroかMioか
    ///- parameter  serviceId: 使用するデバイスのServiceId
    func setDevice(device : DeviceType, serviceId : String){
        if(device == DeviceType.Sphero){
            self.data.SpheroServiceID = serviceId
        }else if(device == DeviceType.Mio){
            self.data.MioServiceID = serviceId
        }
    }
    /// サーバを探す
    ///- parameter completion: CallBack用引数
    func findServer(completion: ((Error?) -> Void)?) {
        var isFound = false
        if let address = getWiFiAddress() {
            print(address) //自身のアドレス
            
            let arr = address.components(separatedBy: ".")
            
            //第3オクテットまでを結合
            let network = arr[0..<3].joined(separator: ".")
            var count = 0
            
            //サブネットマスク/24(255.255.255.0)として同一LANに存在するサーバを探索
            for i in 1..<255 {
                self.isServerRunning(IP: network + "." + String(i), completion:{ (isRunning,IP) -> Void in
                    count+=1
                    if isRunning {
                        // okの処理
                        print(IP + " connected")
                        self.data.serverIP = IP
                        completion!(nil)
                        isFound = true
                    }else{
                        if(count==254 && !isFound){completion!(ServerError.NotFound)}
                    }
                })
            }
        }else{
            print("wi-fiに接続されていません")
            completion!(ServerError.Unconnect)
        }
    }
    ///心拍計デバイスのトラッキング開始
    public func startTracking(){
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.tracking), userInfo: nil, repeats: true)
        timer.fire()
    }
    ///心拍計から一定間隔でトラッキングしてdelegate
    @objc private func tracking(){
        if let server = self.data.serverIP {
            if let MIO = self.data.MioServiceID {
                let URL = NSURL(string: "\("http://" + server + ":4035/gotapi/health/heartrate?serviceId=" + MIO + "&accessToken=null")")
                let req = NSURLRequest(url: URL as! URL)
                let configuration = URLSessionConfiguration.default
                configuration.timeoutIntervalForRequest = 10
                configuration.timeoutIntervalForResource = 60
                
                let session = URLSession(configuration: configuration, delegate:nil, delegateQueue:OperationQueue.main)
                
                let task = session.dataTask(with: req as URLRequest, completionHandler: {
                    (data, response, error) -> Void in
                    do {
                        if (data == nil) {
                            throw error!
                        }
                        let json = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments ) as! Dictionary<String, Any>
                        print(json)
                        self.delegate.trackingHeartrate(heartrate:json["heartRate"] as! Int)
                    } catch {
                        //エラー処理
                    }
                })
                task.resume()
   
            }
        }
    
    }
    ///心拍計デバイスのトラッキング終了
    public func exitTracking(){
        timer.invalidate()
    }
    
    ///スフィロを動かす関数
    ///- parameter angle: 角度[0,360]
    ///- parameter speed: 速度[0,1]
    public func moveSphero(angle:Int,speed:Float){
        if let server = self.data.serverIP {
            if let Sphero = self.data.SpheroServiceID {
                let URL = NSURL(string: "\("http://" + server + ":4035/gotapi/drive_controller/move?serviceId=" + Sphero + "&accessToken=null&angle=" + String(angle) + "&speed=" + String(speed))")
                let req = NSURLRequest(url: URL as! URL)
                
                let configuration = URLSessionConfiguration.default
                configuration.timeoutIntervalForRequest = 10
                configuration.timeoutIntervalForResource = 60
                
                let session = URLSession(configuration: configuration, delegate:nil, delegateQueue:OperationQueue.main)
                
                let task = session.dataTask(with: req as URLRequest, completionHandler: {
                    (data, response, error) -> Void in
                    do {
                        if (data == nil) {
                            throw error!
                        }
                    } catch {
                        //エラー処理
                    }
                })
                task.resume()
            }
        }
    }
    ///スフィロを光らせる関数
    ///- parameter colorCode: カラーコードを16進数
    ///- parameter brightness: 明るさ[0,1]
    public func lightSphero(colorCode:String,brightness:Float){
        if let server = self.data.serverIP {
            if let Sphero = self.data.SpheroServiceID {
                let color = colorCode.replacingOccurrences(of: "#", with: "")
                
                let URL = NSURL(string: "\("http://" + server + ":4035/gotapi/light?serviceId=" + Sphero + "&accessToken=null&lightId=1&name=Sphero%20LED&color=" + color + "&brightness=" + String(brightness))")
                
                let req = NSMutableURLRequest(url: URL as! URL)
                req.httpMethod = "POST"
                let configuration = URLSessionConfiguration.default
                configuration.timeoutIntervalForRequest = 10
                configuration.timeoutIntervalForResource = 60
                
                let session = URLSession(configuration: configuration, delegate:nil, delegateQueue:OperationQueue.main)
                
                let task = session.dataTask(with: req as URLRequest, completionHandler: {
                    (data, response, error) -> Void in
                    do {
                        if (data == nil) {
                            throw error!
                        }
                    } catch {
                        //エラー処理
                    }
                })
                task.resume()
            }
        }
    }
    
    ///対象のサーバが動作しているかどうか
    ///- parameter IP: 調査対象のIPアドレス(IPv4)
    ///- parameter completion: CallBack用引数
    private func isServerRunning(IP : String,completion: ((Bool,String) -> Void)?) {
        let URL = NSURL(string: "\("http://" + IP + ":4035/gotapi/availability")")
        let req = NSURLRequest(url: URL as! URL)
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 60
        
        let session = URLSession(configuration: configuration, delegate:nil, delegateQueue:OperationQueue.main)
        
        let task = session.dataTask(with: req as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            do {
                if (data == nil) {
                    throw error!
                }
                let json = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments ) as! Dictionary<String, Any>
                print(json)
                completion!(true,IP)
            } catch {
                //エラー処理
                completion!(false,IP)
            }
        })
        task.resume()
    }

    /// IPアドレスを返す
    /// - returns: IPアドレス(IPv4)
    private func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var addr = interface.ifa_addr.pointee
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }

}

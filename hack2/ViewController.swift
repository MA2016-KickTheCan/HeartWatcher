
import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    var player:AVAudioPlayer!
    
    /*音声を読み込み*/
    let url = Bundle.main.bundleURL.appendingPathComponent("hito_ge_shinzo06.mp3")
    //let url = Bundle.main.bundleURL.appendingPathComponent("heartbeat01 (1).mp3")
    
    /*音量を心拍数に合わせて変化させる関数*/
    
    var a=0
    func vol(){
        if(a<91){//心拍数が100以下ならば
            player.volume = 0//音量0
        }else{
            let b=a-90
            let c=(a-90)/10
            player.volume = Float(b)//値に合わせた音量
            
            /*再生速度*/
            //rateの変更を許可する。
            player.enableRate = true
            
            //○倍速にする。
            player.rate = 1+Float(c)
            
        }
    }
    
    @IBOutlet weak var aa: UILabel!
    
 
    
    var okashiList :[(maker:String, name:String, link:String, image:String)] = []
    
    
    func searchOkashi(){
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate:nil, delegateQueue:OperationQueue.main)
        
        let task = session.dataTask(with: URLRequest(url: Foundation.URL(string: "http://192.168.1.43:4035/gotapi/health/heartrate?serviceId=F3%3A3B%3A15%3A7E%3A29%3ABB.e9484eb5107adfef1af6a0dc65c03232.localhost.deviceconnect.org&accessToken=null")!), completionHandler: {
            (data, response, error) in
            
            do {
                
                // 受け取ったJSONデータをパース（解析）して格納します。
                let json = try JSONSerialization.jsonObject(with: data!) as! [String: AnyObject]
                
                self.okashiList.removeAll()
                
                print("####################¥n")
                print(json)
                let tmp = json["heartRate"]!
                print(tmp)

                print("####################¥n")
                
                self.a = tmp as! Int
                
                self.aa.text = String(self.a)
                
            } catch {
                // エラー
            }
            
        })
        task.resume()
    }
 
    var myTimer: Timer!//Timerを使います宣言
    func Mtimer(){
        myTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.Mtimer), userInfo: nil, repeats: true)
    }

    
    /*メイン関数*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        do {
            try player = AVAudioPlayer(contentsOf:url)
            
            //音楽をバッファに読み込んでおく
            player.prepareToPlay()
            
            player.play()
            player.numberOfLoops = -1

        } catch {
            /*失敗したら*/
            print(error)
        }
    }
    
    var timer: Timer!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer.invalidate()
    }
    
    func update(tm: Timer) {
        // do something
        searchOkashi()
        vol()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

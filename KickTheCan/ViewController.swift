//
//  ViewController.swift
//  KickTheCan
//
//  Created by AtsuyaSato on 2016/11/15.
//  Copyright © 2016年 AtsuyaSato. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController, MIOControllDelegate {
    var heartView:HeartView!
    var audioPlayer:AVAudioPlayer!
    var debug_heartrate = 70
    var isExciting = false
    @IBOutlet weak var debugLeftButton: UIButton!
    @IBOutlet weak var debugRightButton: UIButton!
    @IBOutlet weak var heartrateLabel: UILabel!
    @IBOutlet weak var spheroButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let radarView = RadarView(frame: CGRect(x: self.view.frame.size.width / 3 * 2, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.width / 3))
//            self.view.addSubview(radarView)
//
        heartView = HeartView(frame: CGRect(x: 0, y: self.view.frame.size.width / 2, width: self.view.frame.size.width, height: self.view.frame.size.width / 2))
        self.view.addSubview(heartView)

        heartrateLabel.text = ""
        spheroButton.isHidden = true

        do {
            // 音楽ファイルが"sample.mp3"の場合
            let filePath = Bundle.main.path(forResource: "heartbeat", ofType: "mp4")
            let audioPath = NSURL(fileURLWithPath: filePath!)
            audioPlayer = try AVAudioPlayer(contentsOf: audioPath as URL)
            audioPlayer.prepareToPlay()
            audioPlayer.numberOfLoops = -1
            audioPlayer.volume = 0
            audioPlayer.play()
        } catch {
            print("Error")
        }
        
        if UserModel.sharedInstance.debugMode(flg: nil) {
            debugLeftButton.isHidden = false
            debugRightButton.isHidden = false

            let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.sendHeartrate), userInfo: nil, repeats: true)
            timer.fire()
        }else{
            DeviceModel.sharedInstance.delegate = self
            DeviceModel.sharedInstance.startTracking()
        }
        if UserModel.sharedInstance.getUserRole() == RoleType.Demon {
            spheroButton.isHidden = false
            heartrateLabel.isHidden = true
            heartView.isHidden = true
            debugLeftButton.isHidden = true
            debugRightButton.isHidden = true
        }
    }
    @IBAction func spheroMover(_ sender: Any) {
        DeviceModel.sharedInstance.moveSphero(angle:Int(arc4random() % 360) , speed: 0.5) //スフィロの移動
    }
    override func viewWillDisappear(_ animated: Bool) {
        audioPlayer.stop()
    }
    func sendHeartrate(){
        self.trackingHeartrate(heartrate: self.debug_heartrate)
    }
    func trackingHeartrate(heartrate: Int) {
        heartView.heart = heartrate
        heartrateLabel.text = "\(heartrate)"
        if(heartrate >= 90 && isExciting == false){
            self.view.backgroundColor = UIColor.red;
            isExciting = true
            audioPlayer.volume = 0.3
            DeviceModel.sharedInstance.moveSphero(angle:Int(arc4random() % 360) , speed: 0.5) //スフィロの移動
            let colorCode = ["FF0000","00FF00","0000FF"]
            let colorNumber:Int = Int(arc4random() % UInt32(colorCode.count))
            DeviceModel.sharedInstance.lightSphero(colorCode:colorCode[colorNumber] , brightness:1.0) //スフィロの色
        }
        if(heartrate < 90 && isExciting == true){
            self.view.backgroundColor = UIColor(red: 26/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)

            isExciting = false
            audioPlayer.volume = 0
        }
        
        if(isExciting){
            audioPlayer.volume = min(Float((heartrate - 90) / 30) + 0.3,1.0)
        }
    }
    @IBAction func upperHeartrate(_ sender: Any) {
        debug_heartrate+=1
    }
    @IBAction func downerHeartrate(_ sender: Any) {
        debug_heartrate-=1
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


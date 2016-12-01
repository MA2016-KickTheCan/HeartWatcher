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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let radarView = RadarView(frame: CGRect(x: self.view.frame.size.width / 3 * 2, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.width / 3))
//            self.view.addSubview(radarView)
//
        heartView = HeartView(frame: CGRect(x: 0, y: self.view.frame.size.width / 2, width: self.view.frame.size.width, height: self.view.frame.size.width / 2))
        self.view.addSubview(heartView)

        heartrateLabel.text = ""

        do {
            // 音楽ファイルが"sample.mp3"の場合
            let filePath = Bundle.main.path(forResource: "hito_ge_shinzo06", ofType: "mp3")
            let audioPath = NSURL(fileURLWithPath: filePath!)
            audioPlayer = try AVAudioPlayer(contentsOf: audioPath as URL)
            audioPlayer.prepareToPlay()
        } catch {
            print("Error")
        }
        
        if UserModel.sharedInstance.debugMode(flg: nil) {
            debugLeftButton.isHidden = false
            debugRightButton.isHidden = false
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
                self.trackingHeartrate(heartrate: self.debug_heartrate)
            })
        }else{
            DeviceModel.sharedInstance.delegate = self
            DeviceModel.sharedInstance.startTracking()
        }
    }
    func trackingHeartrate(heartrate: Int) {
        heartView.heart = heartrate
        heartrateLabel.text = "\(heartrate)"
        if(heartrate >= 90 && isExciting == false){
            isExciting = true
            audioPlayer.play()
            audioPlayer.volume = 0.1
            DeviceModel.sharedInstance.moveSphero(angle:Int(arc4random() % 360) , speed: 0.5) //スフィロの移動
            let colorCode = ["FF0000","00FF00","0000FF"]
            let colorNumber:Int = Int(arc4random() % UInt32(colorCode.count))
            DeviceModel.sharedInstance.lightSphero(colorCode:colorCode[colorNumber] , brightness:1.0) //スフィロの色
        }
        if(heartrate < 90 && isExciting == true){
            isExciting = false
            audioPlayer.stop()
        }
        
        if(isExciting){
            audioPlayer.volume = min(Float((heartrate - 90) / 30),1.0)
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


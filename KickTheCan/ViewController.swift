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
    @IBOutlet weak var heartrateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let radarView = RadarView(frame: CGRect(x: self.view.frame.size.width / 3 * 2, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.width / 3))
//            self.view.addSubview(radarView)
//
        heartView = HeartView(frame: CGRect(x: 0, y: self.view.frame.size.width / 2, width: self.view.frame.size.width, height: self.view.frame.size.width / 2))
        self.view.addSubview(heartView)

        heartrateLabel.text = "\(0)"

        do {
            // 音楽ファイルが"sample.mp3"の場合
            let filePath = Bundle.main.path(forResource: "hito_ge_shinzo06", ofType: "mp3")
            let audioPath = NSURL(fileURLWithPath: filePath!)
            audioPlayer = try AVAudioPlayer(contentsOf: audioPath as URL)
            audioPlayer.prepareToPlay()
        } catch {
            print("Error")
        }
        
        DeviceModel.sharedInstance.delegate = self
        DeviceModel.sharedInstance.startTracking()
    }
    func trackingHeartrate(heartrate: Int) {
        heartView.heart = heartrate
        heartrateLabel.text = "\(heartrate)"
        //audioPlayer.play() // 音楽の再生
        //audioPlayer.stop() // 音楽の停止
        //audioPlayer.volume //ボリューム
        //DeviceModel.sharedInstance.moveSphero(angle: , speed: ) //スフィロの移動
        //DeviceModel.sharedInstance.lightSphero(colorCode: , brightness: ) //スフィロの色
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


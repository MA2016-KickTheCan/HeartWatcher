//
//  ViewController.swift
//  KickTheCan
//
//  Created by AtsuyaSato on 2016/11/15.
//  Copyright © 2016年 AtsuyaSato. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MIOControllDelegate {
    var heartView:HeartView!
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

        DeviceModel.sharedInstance.delegate = self
        DeviceModel.sharedInstance.startTracking()
    }
    func trackingHeartrate(heartrate: Int) {
        heartView.heart = heartrate
        heartrateLabel.text = "\(heartrate)"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


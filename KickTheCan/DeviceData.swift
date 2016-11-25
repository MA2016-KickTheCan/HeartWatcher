//
//  DeviceData.swift
//  KickTheCan
//
//  Created by AtsuyaSato on 2016/11/25.
//  Copyright © 2016年 AtsuyaSato. All rights reserved.
//

import UIKit

class DeviceData: NSObject {
    var serverIP:String = ""
    var SpheroServiceID:String = ""
    var MioServiceID:String = ""
    
    override init() {
        super.init()
        self.setDevice(device: ["serverIP":"","SpheroServiceID":"","MioServiceID":""])
    }
    
    func setDevice(device:Dictionary<String,String>){
        serverIP = device["serverIP"]!
        SpheroServiceID = device["SpheroServiceID"]!
        MioServiceID = device["MioServiceID"]!
    }
}

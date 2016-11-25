//
//  DeviceData.swift
//  KickTheCan
//
//  Created by AtsuyaSato on 2016/11/25.
//  Copyright © 2016年 AtsuyaSato. All rights reserved.
//

import UIKit

class DeviceData: NSObject {
    var serverIP:String? = nil
    var SpheroServiceID:String? = nil
    var MioServiceID:String? = nil
    
    override init() {
        super.init()
    }
    
    func setDevice(device:Dictionary<String,String>){
        serverIP = device["serverIP"]!
        SpheroServiceID = device["SpheroServiceID"]!
        MioServiceID = device["MioServiceID"]!
    }
}

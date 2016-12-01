//
//  UserData.swift
//  KickTheCan
//
//  Created by AtsuyaSato on 2016/12/01.
//  Copyright © 2016年 AtsuyaSato. All rights reserved.
//

import UIKit
enum RoleType{
    case Demon
    case Player
}
class UserData: NSObject {
    var userRole : RoleType? = nil
    
    override init() {
        super.init()
    }
}

//
//  UserModel.swift
//  KickTheCan
//
//  Created by AtsuyaSato on 2016/12/01.
//  Copyright © 2016年 AtsuyaSato. All rights reserved.
//

import UIKit

class UserModel: NSObject {
     var data = UserData()
    class var sharedInstance : UserModel {
        struct Singleton {
            static var instance = UserModel()
        }
        return Singleton.instance
    }
    ///ユーザロール設定用関数
    ///- parameter role: 鬼か通常プレイヤーか
    func setUserRole(role : RoleType){
            data.userRole = role
    }
    ///ユーザロール設定用関数
    ///- parameter role: 鬼か通常プレイヤーか
    func getUserRole()->RoleType{
        return data.userRole!
    }

}

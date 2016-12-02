//
//  RoleSelectViewController.swift
//  KickTheCan
//
//  Created by AtsuyaSato on 2016/12/01.
//  Copyright © 2016年 AtsuyaSato. All rights reserved.
//

import UIKit

class RoleSelectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectPlayer(_ sender: Any) {
        UserModel.sharedInstance.setUserRole(role: RoleType.Player)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.navigationController?.pushViewController(storyboard.instantiateViewController(withIdentifier: "SpheroSelectViewController"), animated: true)

    }
    @IBAction func selectDemon(_ sender: Any) {
        UserModel.sharedInstance.setUserRole(role: RoleType.Demon)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.navigationController?.pushViewController(storyboard.instantiateViewController(withIdentifier: "SpheroSelectViewController"), animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

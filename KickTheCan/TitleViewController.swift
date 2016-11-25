//
//  TitleViewController.swift
//  KickTheCan
//
//  Created by AtsuyaSato on 2016/11/25.
//  Copyright © 2016年 AtsuyaSato. All rights reserved.
//

import UIKit

class TitleViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var alertLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertLabel.isHidden = true
        activityIndicator.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func connect2server(_ sender: Any) {
        //ローディング表示
        alertLabel.text = "サーバを検索しています"
        alertLabel.isHidden = false
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        DeviceModel.sharedInstance.findServer(completion:{ (error) -> Void in
            //ローディング終了
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true

            if error != nil{
                print(error!)
                if(error! as! ServerError == ServerError.NotFound){
                    self.alertLabel.text = "サーバが見つかりませんでした"
                }else if(error! as! ServerError == ServerError.Unconnect){
                    self.alertLabel.text = "WiFiに接続してください"
                }
            }else{
                self.alertLabel.isHidden = true
                //サーバに接続完了
                self.performSegue(withIdentifier: "connectServer", sender: nil)
            }
        })
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

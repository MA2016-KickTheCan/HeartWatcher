//
//  ViewController.swift
//  KickTheCan
//
//  Created by AtsuyaSato on 2016/11/15.
//  Copyright © 2016年 AtsuyaSato. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {

    let locationManager:CLLocationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let radarView = RadarView(frame: CGRect(x: self.view.frame.size.width / 3 * 2, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.width / 3))
            self.view.addSubview(radarView)

        let heartView = HeartView(frame: CGRect(x: 0, y: self.view.frame.size.width / 2, width: self.view.frame.size.width, height: self.view.frame.size.width / 2))
        self.view.addSubview(heartView)

    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            return
        }
        let centerCoordinate = newLocation.coordinate
        let coordinateSpan = MKCoordinateSpanMake(0.005, 0.005)
        let newRegion = MKCoordinateRegionMake(centerCoordinate, coordinateSpan)        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


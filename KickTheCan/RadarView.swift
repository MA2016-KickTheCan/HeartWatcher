//
//  RadarView.swift
//  KickTheCan
//
//  Created by AtsuyaSato on 2016/11/15.
//  Copyright © 2016年 AtsuyaSato. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class RadarView: UIView,CLLocationManagerDelegate {
    var rad = 0
    let locationManager:CLLocationManager = CLLocationManager()

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        //描画の中心点
        let cx = Double(self.bounds.size.width/2)
        let cy = Double(self.bounds.size.height/2)
        
        //円の線を描画
        context!.setStrokeColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5);
        context!.setLineWidth(2.0);

        //円の半径
        let R = Double(self.bounds.size.width/2)
        var rectEllipse = CGRect(x: cx - R * 0.9, y: cy - R * 0.9, width: R*1.8, height: R*1.8)
        context!.strokeEllipse(in: rectEllipse)
        
        for var i in 0..<5{
            let i = Double(i)
            rectEllipse = CGRect(x: cx - R * (0.9 - 0.2 * i), y: cy - R * (0.9 - 0.2 * i), width: R*(1.8 - 0.4 * i), height: R*(1.8 - 0.4 * i))
            context!.strokeEllipse(in: rectEllipse)
        }
        //縦線
        context!.strokeLineSegments(between: [CGPoint(x:self.bounds.size.width / 2, y: self.bounds.size.height*0.05),CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height*0.95)])
        //横線
        context!.strokeLineSegments(between: [CGPoint(x:self.bounds.size.width * 0.05, y: self.bounds.size.height / 2),CGPoint(x: self.bounds.size.width * 0.95, y: self.bounds.size.height / 2)])
        
        //レーダー
        let x2 = Double(self.bounds.size.width / 2) + Double(self.bounds.size.width / 2 * 0.9) * cos(M_PI * Double(rad) / 180)
        let y2 = Double(self.bounds.size.height / 2) + Double(self.bounds.size.height / 2 * 0.9) * sin(M_PI * Double(rad) / 180)
        
        context!.strokeLineSegments(between: [CGPoint(x:self.bounds.size.width / 2, y: self.bounds.size.height / 2),CGPoint(x:x2 , y:y2)])

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        let timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
    }
    func update(tm: Timer) {
        // do something
        rad += 2
        rad %= 360
        self.setNeedsDisplay()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}

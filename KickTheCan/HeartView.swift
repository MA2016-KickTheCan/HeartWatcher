//
//  HeartView.swift
//  KickTheCan
//
//  Created by AtsuyaSato on 2016/11/15.
//  Copyright © 2016年 AtsuyaSato. All rights reserved.
//

import UIKit

class HeartView: UIView {
    var spacer:CGFloat = 0.0
    let imageView:UIImageView = UIImageView()
    var esc_transform:CGAffineTransform = CGAffineTransform()
    var heart:Int!
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        //描画の中心点
        //円の線を描画
        context!.setStrokeColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5);
        context!.setLineWidth(5.0);
        
       //横線
        context!.strokeLineSegments(between: [
            CGPoint(x:0, y: self.bounds.size.height / 2),
            CGPoint(x:spacer, y: self.bounds.size.height / 2)])
        
        context!.strokeLineSegments(between: [
            CGPoint(x:spacer, y: self.bounds.size.height / 2),
             CGPoint(x:spacer + 5, y: self.bounds.size.height / 2 - 10)])

        context!.strokeLineSegments(between: [
            CGPoint(x:spacer + 5, y: self.bounds.size.height / 2 - 10),
            CGPoint(x:spacer + 10, y: self.bounds.size.height / 2)])

        context!.strokeLineSegments(between: [
            CGPoint(x:spacer + 10, y: self.bounds.size.height / 2),
            CGPoint(x:spacer + 15, y: self.bounds.size.height / 2 + 20)])

        context!.strokeLineSegments(between: [
            CGPoint(x:spacer + 15, y: self.bounds.size.height / 2 + 20),
            CGPoint(x:spacer + 20, y: self.bounds.size.height / 2)])

        context!.strokeLineSegments(between: [
            CGPoint(x:spacer + 20, y: self.bounds.size.height / 2),
            CGPoint(x:spacer + 30, y: self.bounds.size.height / 2 - 50)])

        context!.strokeLineSegments(between: [
            CGPoint(x:spacer + 30, y: self.bounds.size.height / 2 - 50),
            CGPoint(x:spacer + 40, y: self.bounds.size.height / 2)])

        context!.strokeLineSegments(between: [
            CGPoint(x:spacer + 40, y: self.bounds.size.height / 2),
            CGPoint(x: self.bounds.size.width, y: self.bounds.size.height / 2)])
        
        if(spacer > self.frame.size.width / 2 - self.frame.size.height * 0.4 && spacer < self.frame.size.width / 2 + self.frame.size.height * 0.4){
            imageView.transform =  esc_transform.scaledBy(x: 1.2, y: 1.2);
        }else{
            imageView.transform =  esc_transform
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.height * 0.8, height: self.frame.size.height * 0.8)
        imageView.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        imageView.image = UIImage(named: "heart.png")
        self.addSubview(imageView)
        esc_transform = imageView.transform
        heart = 0
        let timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
    }
    func update(tm: Timer) {
        spacer += CGFloat(heart) / 10
        if spacer >= self.frame.size.width {
            spacer = 0
        }
        // do something
        self.setNeedsDisplay()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//
//  QRRecordStatusView.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/5/6.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class QRRecordStatusView: UIView {

    var contentLevelView : UIView!
    var duplicator : CAReplicatorLayer!
    var levelLayer : CAShapeLayer!
    var levelPath : UIBezierPath!
    var currentLevels = [2,5,2,5,2,5,2,5,2,5,2,5,2,5]
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.colorWithHexString(hex: "#f2f2f2")
        
        self.setUpUI()
    }
    override func layoutSubviews() {
        contentLevelView.frame = self.bounds
    }
    func setUpUI(){
        let contentV = UIView(frame: self.bounds)
        self.addSubview(contentV)
        contentLevelView = contentV
        //创建复制器
        let rep = CAReplicatorLayer()
        rep.frame = self.layer.bounds
//        rep.instanceCount = 2
//        rep.instanceTransform = CATransform3DMakeRotation(CGFloat(M_PI), 0, 0, 1)
        self.contentLevelView.layer.addSublayer(rep)
        self.duplicator = rep
        //levelLayer
        
        let level = CAShapeLayer()
        level.frame =  CGRect(x: (kWidth-(14*12))/2, y: 10, width: (14*12), height: self.bounds.size.height-20)
        level.strokeColor = kBlueC.cgColor
        level.lineWidth = 6
        self.levelLayer = level
        self.contentLevelView.layer.addSublayer(level)
       // rep.addSublayer(level)
       self.startAnimation(voice: 2)
    }
    
    func startAnimation(voice:Int){

        self.levelPath = UIBezierPath()
        self.currentLevels.removeLast()
        self.currentLevels.insert(voice, at: 0)
        
       //let height = CGRectGetHeight(self.levelLayer.frame);
//        for (int i = 0; i < self.currentLevels.count; i++) {
//            CGFloat x = i * (levelWidth + levelMargin) + 5;
//            CGFloat pathH = [self.currentLevels[i] floatValue] * height;
//            CGFloat startY = height / 2.0 - pathH / 2.0;
//            CGFloat endY = height / 2.0 + pathH / 2.0;
//            [_levelPath moveToPoint:CGPointMake(x, startY)];
//            [_levelPath addLineToPoint:CGPointMake(x, endY)];
//        }
//
        let height = Int(self.levelLayer.frame.height)
        for (index,value) in self.currentLevels.enumerated(){
            let x = index * (6+6)+6
            let pathH = height/10 * value
            let startY = height/2 - pathH/2 - 5
            let endY = height/2 + pathH/2 - 5
            levelPath.move(to: CGPoint(x: x, y: startY))
            levelPath.addLine(to: CGPoint(x: x, y: endY))
        }
        
        
        self.levelLayer.path = levelPath.cgPath;
        
        
    }
    
    func endAnimation(){
        
    }
}

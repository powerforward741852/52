//
//  CQScheduleSelectView.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/10.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit
protocol CQScheduleSelectDelegate : NSObjectProtocol{
    func pushToDetailThroughType(btn:UIButton)
}

class CQScheduleSelectView: UIView {

    weak var cqSelectDelegate:CQScheduleSelectDelegate?
    
    
    lazy var bgImg: UIImageView = {
        let bgImg = UIImageView.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 99), y: SafeAreaTopHeight, width: AutoGetWidth(width: 89), height: AutoGetHeight(height: 135)))
        bgImg.image = UIImage.init(named: "CQScheduleSelect")
        return bgImg
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp()  {
        self.addSubview(self.bgImg)
        self.bgImg.isUserInteractionEnabled = true
        let titleArr = ["日程","会议","任务"]
        for i in 0..<3 {
            let btn = UIButton.init(type: .custom)
            btn.frame =  CGRect.init(x: 2, y: AutoGetHeight(height: 15) + AutoGetHeight(height: 40) * CGFloat(i), width: AutoGetWidth(width: 89) - 2, height: AutoGetHeight(height: 40))
            btn.setTitle(titleArr[i], for: .normal)
            btn.titleLabel?.font = kFontSize15
            btn.setTitleColor(kLyGrayColor, for: .normal)
            btn.tag = 400+i
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            self.bgImg.addSubview(btn)
        }
    }
    
    @objc func btnClick(btn:UIButton) {
        DLog("1111111")
        
        if self.cqSelectDelegate != nil {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }) { (finished:Bool) in
                self.removeFromSuperview()
                self.cqSelectDelegate?.pushToDetailThroughType(btn: btn)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        let point = touch.location(in: self)
        if point.x < self.bgImg.frame.origin.x || point.x > self.bgImg.frame.origin.x || point.y < self.bgImg.frame.origin.y || point.y > self.bgImg.frame.origin.y {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }) { (finished:Bool) in
                self.removeFromSuperview()
            }
        }
    }

}

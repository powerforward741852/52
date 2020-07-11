//
//  CQBussinessSelectV.swift
//  52WorkHelper
//
//  Created by chenqihang on 2019/1/14.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

protocol CQBussinessCardListSelectDelegate : NSObjectProtocol{
    func pushToDetailThroughType(btn:UIButton)
}

class CQBussinessSelectV: UIView {

   weak var cqSelectDelegate:CQBussinessCardListSelectDelegate?
    
    
    lazy var bgImg: UIImageView = {
        let bgImg = UIImageView.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 149)-10, y: SafeAreaTopHeight, width: AutoGetWidth(width: 149), height: AutoGetHeight(height: 135)))
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
        let titleArr = [" 扫描名片        "," 手动输入名片"," 从相册中导入"]
        let imageArr = ["smmp","sdsrmp","xcxz"]
        for i in 0..<3 {
            let btn = UIButton.init(type: .custom)
            btn.frame =  CGRect.init(x: 10, y: AutoGetHeight(height: 15) + AutoGetHeight(height: 40) * CGFloat(i), width: AutoGetWidth(width: 149) - 20, height: AutoGetHeight(height: 40))
            btn.setTitle(titleArr[i], for: .normal)
            btn.titleLabel?.font = kFontSize15
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.setImage(UIImage.init(named: imageArr[i]), for: .normal)
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

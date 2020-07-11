//
//  CQActionView.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/7/24.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol CQCurretMonthClickDelegate : NSObjectProtocol{
    func currentMonthAction(btn:UIButton)
}

protocol CQLastMonthClickDelegate : NSObjectProtocol{
    func lastMonthAction(btn:UIButton)
}

protocol CQActionVIconDelegate : NSObjectProtocol{
    func iconAction()
}

class CQActionView: UIImageView,UIGestureRecognizerDelegate {

    weak var currentDelegate:CQCurretMonthClickDelegate?
    weak var lastDelegate:CQLastMonthClickDelegate?
    weak var iconDelegate:CQActionVIconDelegate?
    var iconImg:UIImageView?
    var currentMonthBtn:UIButton?
    var lastMonthBtn:UIButton?
    var deleteBtn:UIButton?
    
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.initView()
        self.layer.cornerRadius = AutoGetWidth(width: 40.5)
        self.clipsToBounds = true
        self.image = UIImage.init(named: "xfcIcon")
//        self.ww_getKeyWindow().addSubview(self)
//        self.ww_getKeyWindow().bringSubview(toFront: self)
        self.isUserInteractionEnabled = true
        //跟随手指拖动
        let moveGes:UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(self.dragBallView))
        self.addGestureRecognizer(moveGes)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeImage(notif:)), name: NSNotification.Name.init("changeActionVImage"), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        self.addSubview(self.getIconImage())
        self.addSubview(self.getCurrentMonthBtn())
        self.addSubview(self.getLastMonthBtn())
        self.addSubview(self.getDeleteBtn())
    }
    
    //接收到后执行的方法
    @objc func changeImage(notif: NSNotification) {
   
        guard let imageStr: String = notif.object as! String? else { return }
        self.iconImg?.sd_setImage(with: URL(string: imageStr), placeholderImage:UIImage.init(named: "CQIndexPersonDefault"))
    }
    
    @objc func currentMonthClick(btn:UIButton)  {
        if self.currentDelegate != nil{
            self.currentDelegate?.currentMonthAction(btn: btn)
        }
    }
    
    @objc func lastMonthClick(btn:UIButton)  {
        if self.lastDelegate != nil{
            self.lastDelegate?.lastMonthAction(btn: btn)
        }
    }
    
    @objc func iconClick()  {
        if self.iconDelegate != nil{
            self.iconDelegate?.iconAction()
        }
    }
    
    @objc func deleteClick(btn:UIButton)  {
        self.removeAllSubviews()
        self.removeFromSuperview()
    }
    
    
    
    //跟随手指拖动
    @objc func dragBallView(panGes:UIPanGestureRecognizer) {
        let translation:CGPoint = panGes.translation(in: self.ww_getKeyWindow())
        let center:CGPoint = self.center
        self.center = CGPoint.init(x:center.x+translation.x , y:  center.y+translation.y)
        if self.sd_x < 0{
            self.center = CGPoint.init(x: AutoGetWidth(width: 81)/2, y: center.y+translation.y)
        }else if self.sd_x > kWidth - AutoGetHeight(height: 81){
            self.center = CGPoint.init(x: (kWidth - AutoGetWidth(width: 81)/2), y: center.y+translation.y)
        }else if self.sd_y < 0{
            self.center = CGPoint.init(x:center.x+translation.x , y: AutoGetHeight(height: 152)/2 )
        }else if self.sd_y > kHeight - AutoGetHeight(height: 152){
            self.center = CGPoint.init(x:center.x+translation.x , y: kHeight - AutoGetHeight(height: 152)/2 )
        }
        
        
        panGes.setTranslation(CGPoint.init(x: 0, y: 0), in: self.ww_getKeyWindow())
        if panGes.state == UIGestureRecognizerState.ended{
//            self.caculateBallCenter()
        }
    }
    
    
    func getIconImage() -> UIImageView {
        if iconImg == nil{
            iconImg = UIImageView.init(frame: CGRect.init(x: AutoGetWidth(width: 18), y: AutoGetHeight(height:16), width: AutoGetWidth(width: 45), height: AutoGetWidth(width: 45)))
            iconImg?.sd_setImage(with: URL(string: STUserTool.account().headImage), placeholderImage:UIImage.init(named: "CQIndexPersonDefault"))
            iconImg?.layer.cornerRadius = AutoGetWidth(width: 22.5)
            iconImg?.clipsToBounds = true
            iconImg?.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(iconClick))
            iconImg?.addGestureRecognizer(tap)
        }
        return iconImg!
    }
    
    func getCurrentMonthBtn() -> UIButton {
        if currentMonthBtn == nil{
            currentMonthBtn = UIButton.init(type: .custom)
            currentMonthBtn?.frame = CGRect.init(x: 0, y: (self.iconImg?.bottom)! + AutoGetHeight(height: 5), width: AutoGetWidth(width: 81), height: AutoGetHeight(height: 30))
            currentMonthBtn?.setTitle("本月", for: .normal)
            currentMonthBtn?.setTitleColor(kLyGrayColor, for: .normal)
            currentMonthBtn?.titleLabel?.font = kFontSize15
            currentMonthBtn?.addTarget(self, action: #selector(currentMonthClick(btn:)), for: .touchUpInside)
        }
        return currentMonthBtn!
    }
 
    func getLastMonthBtn() -> UIButton {
        if lastMonthBtn == nil{
            lastMonthBtn = UIButton.init(type: .custom)
            lastMonthBtn?.frame = CGRect.init(x: 0, y: (self.currentMonthBtn?.bottom)! + AutoGetHeight(height: 0), width: AutoGetWidth(width: 81), height: AutoGetHeight(height: 30))
            lastMonthBtn?.setTitle("上月", for: .normal)
            lastMonthBtn?.setTitleColor(kLyGrayColor, for: .normal)
            lastMonthBtn?.titleLabel?.font = kFontSize15
            lastMonthBtn?.addTarget(self, action: #selector(lastMonthClick(btn:)), for: .touchUpInside)
        }
        return lastMonthBtn!
    }
    
    func getDeleteBtn() -> UIButton{
        if deleteBtn == nil{
            deleteBtn = UIButton.init(type: .custom)
            deleteBtn?.frame = CGRect.init(x: AutoGetWidth(width: 53.5), y:  AutoGetHeight(height: 13.5), width: AutoGetWidth(width: 13), height: AutoGetWidth(width: 13))
            deleteBtn?.addTarget(self, action: #selector(deleteClick(btn:)), for: .touchUpInside)
            deleteBtn?.setBackgroundImage(UIImage.init(named: "CQIndexDelete"), for: .normal)
            self.bringSubview(toFront: deleteBtn!)
        }
        return deleteBtn!
    }
    
    //MARK:- private utility
    func ww_getKeyWindow() -> UIWindow {
        if UIApplication.shared.keyWindow == nil {
            return ((UIApplication.shared.delegate?.window)!)!
        }else{
            return UIApplication.shared.keyWindow!
        }
    }
}

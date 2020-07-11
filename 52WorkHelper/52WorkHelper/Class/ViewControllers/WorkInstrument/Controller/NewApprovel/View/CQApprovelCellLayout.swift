//
//  CQApprovelCellLayout.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/10/28.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit

class CQApprovelCellLayout: TGLinearLayout {

    var realName = ""
    var headImage = ""
    var approveTime = ""
    var approvalResultRemark = ""
    var approvalResult = ""
    
    convenience init(orientation: TGOrientation,realName:String,headImage:String,approveTime:String,approvalResultRemark:String,approvalResult:String) {
        self.init(frame: CGRect.zero, orientation: orientation, realName: realName, headImage: headImage, approveTime: approveTime, approvalResultRemark: approvalResultRemark, approvalResult: approvalResult)
        
    }
    
    init(frame: CGRect, orientation: TGOrientation,realName:String,headImage:String,approveTime:String,approvalResultRemark:String,approvalResult:String) {
        super.init(frame: frame, orientation: orientation)
        self.tg_height.equal(.wrap)
        self.tg_width.equal(kWidth)
        self.realName = realName
        self.headImage = headImage
        self.approveTime = approveTime
        self.approvalResult = approvalResult
        self.approvalResultRemark = approvalResultRemark
        
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()  {
        self.addSubview(self.addLineView())
        self.addSubview(self.addIconImageView(image: self.headImage))
        self.addSubview(self.addNameLable(title: self.realName))
        if self.approvalResult.isEmpty{
            self.addSubview(self.addTitleLable(title: self.approvalResultRemark))
        }else{
            self.addSubview(self.addTitleLable(title: self.approvalResult))
        }
        
        self.addSubview(self.addSelectBtn(title: self.approveTime))
    }
    
    
}



// Mark 整个界面可能用到的控件
extension CQApprovelCellLayout{
    
    @objc internal func addLineView() -> UIView {
        
        let line = UIView.init()
        line.tg_width.equal(1)
        line.tg_left.equal(AutoGetWidth(width: 33) - 0.5)
        line.tg_height.equal(AutoGetHeight(height: 8))
        line.backgroundColor = UIColor.clear
        return line
    }
    
    @objc internal func addIconImageView(image:String) -> UIImageView {
        
        let img = UIImageView.init()
        img.tg_top.equal(AutoGetHeight(height: 9))
        img.tg_left.equal(-AutoGetWidth(width: 18))
        img.layer.cornerRadius = AutoGetWidth(width: 18)
        img.clipsToBounds = true
        img.tag = tag
        img.tg_width.equal(AutoGetWidth(width: 36))
        img.tg_height.equal(AutoGetWidth(width: 36))
        img.sd_setImage(with: URL(string:image), placeholderImage:UIImage.init(named: "personDefaultIcon"))
        
        return img
    }
    
    @objc internal func addNameLable(title:String) -> UILabel{
        let lab = UILabel.init()
        
//        if title == STUserTool.account().realName{
//            lab.text = "我"
//        }else{
            lab.text = " " + title
//        }
        lab.font = kFontSize13
        lab.textAlignment = .left
        lab.textColor = UIColor.black
        lab.tg_width.equal(AutoGetWidth(width: 80))
        lab.tg_left.equal(AutoGetWidth(width: 0))
        lab.tg_height.equal(AutoGetHeight(height: 55))
        return lab
    }
    
    @objc internal func addTitleLable(title:String) -> UILabel{
        let lab = UILabel.init()
        lab.text = title
        lab.font = kFontSize13
        lab.textAlignment = .left
        lab.textColor = UIColor.black
        lab.tag = 1002
        lab.tg_width.equal(AutoGetWidth(width: 95))
        lab.tg_height.equal(AutoGetHeight(height: 55))
        return lab
    }
    
    @objc internal func addSelectBtn(title:String) -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(title ,for:.normal)
        btn.titleLabel!.font = kFontSize13
        btn.setTitleColor(kLyGrayColor, for: .normal)
        btn.contentHorizontalAlignment = .right
        btn.tag = 200
        btn.tg_height.equal(AutoGetHeight(height: 55))
        btn.tg_width.equal(kWidth - AutoGetWidth(width: 258))
        return btn
    }
    
    
}

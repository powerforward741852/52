//
//  CQCopyToMeBeginLayout.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/10/29.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit

class CQCopyToMeBeginLayout: TGLinearLayout {

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
        self.addSubview(self.addTitleLable(title: self.approvalResult))
        self.addSubview(self.addSelectBtn(title: self.approveTime))
    }
    
    
}



// Mark 整个界面可能用到的控件
extension CQCopyToMeBeginLayout{
    
    
    @objc internal func addTitleLable(title:String) -> UILabel{
        let lab = UILabel.init()
        lab.text = title
        lab.font = kFontSize13
        lab.textAlignment = .left
        lab.textColor = UIColor.black
        //        let labWidth = getTexWidth(textStr: title, font: kFontSize15, height: AutoGetHeight(height: 15))
        lab.tg_width.equal(AutoGetWidth(width: 120))
        lab.tg_left.equal(AutoGetWidth(width: 20))
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
        //        btn.tg_left.equal(AutoGetWidth(width: 15))
        btn.tg_height.equal(AutoGetHeight(height: 55))
        btn.tg_width.equal(kWidth - AutoGetWidth(width: 173))
        return btn
    }
    
}

//
//  CQApprovelDetailHeaderLayout.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/10/28.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit

class CQApprovelDetailHeaderLayout: TGLinearLayout {

    var curName = ""
    var type = ""
    var curTitle = ""
    var prompt = ""
    var required = false
    var content = ""
    var viewHeight:CGFloat = 0
    var actionLayout:TGLinearLayout!
    var imageUrl = ""
    var statusStr = ""
    
    
    convenience init(orientation: TGOrientation,name:String,type:String,title:String,prompt:String,require:Bool,content:String,imageUrl:String,statusStr:String) {
        self.init(frame: CGRect.zero, orientation: orientation, name: name, type: type, title: title, prompt: prompt, require: require,content:content,imageUrl:imageUrl,statusStr:statusStr)
        
    }
    
    init(frame: CGRect, orientation: TGOrientation,name:String,type:String,title:String,prompt:String,require:Bool,content:String,imageUrl:String,statusStr:String) {
        super.init(frame: frame, orientation: orientation)
        self.actionLayout = TGLinearLayout(.vert)
        actionLayout.tg_width.equal(.wrap)
        actionLayout.tg_height.equal(.wrap)
        self.addSubview(actionLayout)
        
        self.tg_height.equal(.wrap)
        self.tg_width.equal(kWidth)
        self.curName = name
        self.type = type
        self.curTitle = title
        self.prompt = prompt
        self.required = require
        self.content = content
        self.imageUrl = imageUrl
        self.statusStr = statusStr
        self.initView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()  {
        self.actionLayout.addSubview(self.addIconImageLayout(image: self.imageUrl))
        if self.curTitle == "" || self.curTitle == STUserTool.account().realName{
            self.actionLayout.addSubview(self.addNameLabLayout(name: "我"))
        }else{
            self.actionLayout.addSubview(self.addNameLabLayout(name: self.curTitle))
        }
        
        self.actionLayout.addSubview(self.addTimeLabLayout(time: self.statusStr))
        self.actionLayout.addSubview(self.addLineLayout())
    }
    
    
}

//layout
extension CQApprovelDetailHeaderLayout{
    //生成头像
    internal func addIconImageLayout(image:String) -> TGLinearLayout{
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        
        wrapContentLayout.addSubview(self.addIconImageView(image: image))
        
        return wrapContentLayout
    }
    
    //生成用户名
    internal func addNameLabLayout(name:String) -> TGLinearLayout{
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        
        wrapContentLayout.addSubview(self.addNameLab(title: name))
        wrapContentLayout.addSubview(self.addSubTimeLab(time: self.curName))
        return wrapContentLayout
    }
    
    //生成时间
    internal func addTimeLabLayout(time:String) -> TGLinearLayout{
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        
        wrapContentLayout.addSubview(self.addTimeLab(time: time))
        
        return wrapContentLayout
    }
    
    //生成线条
    internal func addLineLayout() -> TGLinearLayout{
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        
        wrapContentLayout.addSubview(self.addLineView())
        
        return wrapContentLayout
    }
}


// Mark 整个界面可能用到的控件
extension CQApprovelDetailHeaderLayout{
    
    @objc internal func addNameLab(title:String) -> UILabel {
        
        let nameLab = UILabel.init()
        nameLab.tg_top.equal(-AutoGetHeight(height: 33.5))
        nameLab.tg_left.equal( AutoGetWidth(width: 63))
        nameLab.tg_width.equal(kWidth - AutoGetWidth(width: 178))
        nameLab.tg_height.equal(AutoGetHeight(height: 16))
        nameLab.text = title
        nameLab.textColor = UIColor.black
        nameLab.textAlignment = .left
        nameLab.font = kFontSize16
        return nameLab
    }
    
    @objc internal func addSubTimeLab(time:String) -> UILabel {
        
        let timeLab = UILabel.init()
        timeLab.tg_top.equal(-AutoGetHeight(height: 33.5))
        timeLab.tg_width.equal( AutoGetWidth(width: 85))
        timeLab.tg_height.equal(AutoGetHeight(height: 11))
        timeLab.text = time
        timeLab.textColor = kLyGrayColor
        timeLab.textAlignment = .right
        timeLab.font = kFontSize11
        return timeLab
    }
    
    
    @objc internal func addIconImageView(image:String) -> UIImageView {
        
        let img = UIImageView.init()
        img.tg_top.equal(AutoGetHeight(height: 18))
        img.tg_left.equal(kLeftDis)
        img.layer.cornerRadius = AutoGetWidth(width: 18)
        img.clipsToBounds = true
        img.tag = tag
        img.tg_width.equal(AutoGetWidth(width: 36))
        img.tg_height.equal(AutoGetWidth(width: 36))
        img.sd_setImage(with: URL(string:image), placeholderImage:UIImage.init(named: "personDefaultIcon"))
        
        return img
    }
    
    @objc internal func addTimeLab(time:String) -> UILabel {
        
        let timeLab = UILabel.init()
        timeLab.tg_top.equal(-AutoGetHeight(height: 13))
        timeLab.tg_left.equal(AutoGetWidth(width: 63))
        timeLab.tg_width.equal(kWidth - AutoGetWidth(width: 78))
        timeLab.tg_height.equal(AutoGetHeight(height: 11))
        timeLab.text = time
        timeLab.textColor = kGoldYellowColor
        timeLab.textAlignment = .left
        timeLab.font = kFontSize11
        return timeLab
    }
    
    
    @objc internal func addLineView() -> UIView {
        
        let lineView = UIView.init()
        lineView.tg_top.equal(AutoGetHeight(height: 13))
        lineView.tg_left.equal(AutoGetWidth(width: 15))
        lineView.tg_width.equal(kWidth - AutoGetWidth(width: 15))
        lineView.tg_height.equal(0.5)
        lineView.backgroundColor = kLineColor
        return lineView
    }
}

//
//  CQMyVocationBalanceLayout.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/10/25.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit

protocol LeaveBalanceDelegate : NSObjectProtocol {
    func myLeaveClick()
}

class CQMyVocationBalanceLayout: TGLinearLayout {
    var curName = ""
    var type = ""
    var curTitle = ""
    var prompt = ""
    var required = false

    var year = "0"
    var xiu = "0"
    weak var leaveDeleagte:LeaveBalanceDelegate?
    convenience init(orientation: TGOrientation,name:String,type:String,title:String,prompt:String,require:Bool) {
        self.init(frame: CGRect.zero, orientation: orientation, name: name, type: type, title: title, prompt: prompt, require: require)
        
    }
    
    init(frame: CGRect, orientation: TGOrientation,name:String,type:String,title:String,prompt:String,require:Bool) {
        super.init(frame: frame, orientation: orientation)
        self.tg_height.equal(.wrap)
        self.tg_width.equal(kWidth)
        self.curName = name
        self.type = type
        self.curTitle = title
        self.prompt = prompt
        self.required = require
        self.backgroundColor = UIColor.colorWithHexString(hex: "#f2f6fc")
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()  {
        self.addSubview(self.addVocationLable(year: self.year, xiu: self.xiu))
        self.addSubview(self.addMyVocationButton())
    }
    
    @objc func myVocationClick()  {
        if self.leaveDeleagte != nil{
            self.leaveDeleagte?.myLeaveClick()
        }
    }
    
}



// Mark 整个界面可能用到的控件
extension CQMyVocationBalanceLayout{
    
    @objc internal func addVocationLable(year:String,xiu:String) -> UILabel{
        let lab = UILabel.init()
        lab.text = "年假: 剩余" + year + "天" + "   调休: 剩余" + xiu + "小时"
        lab.font = kFontSize13
        lab.textAlignment = .left
        lab.textColor = kLyGrayColor
        lab.tag = 100
        lab.tg_left.equal(AutoGetWidth(width: 30))
        lab.tg_height.equal(AutoGetHeight(height: 40))
        lab.tg_width.equal(kWidth - AutoGetWidth(width: 50) - AutoGetWidth(width: 60))
        return lab
    }
    
    func addMyVocationButton() -> UIButton {
        let btn = UIButton.init(type: .custom)
       // btn.addTarget(self ,action:#selector(myVocationClick), for:.touchUpInside)
        btn.titleLabel!.font = kFontSize13
        btn.setTitleColor(kLightBlueColor, for: .normal)
       // btn.setTitle(" 我的假期", for: .normal)
        btn.tg_height.equal(AutoGetHeight(height: 40))
        btn.tg_width.equal(AutoGetHeight(height: 60))
        
        
        
       // btn.tg_trailing.equal(AutoGetWidth(width: -15))
        return btn
    }
    
}



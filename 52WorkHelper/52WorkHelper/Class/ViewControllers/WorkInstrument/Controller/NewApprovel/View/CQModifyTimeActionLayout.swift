//
//  CQModifyTimeActionLayout.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/10/26.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit

protocol CQModifyDelegate : NSObjectProtocol{
    func goToModifyVC()
}

class CQModifyTimeActionLayout: TGLinearLayout {

    var curName = ""
    var type = ""
    var curTitle = ""
    var prompt = ""
    var required = false
    weak var modifyDelegate:CQModifyDelegate?
    
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
        
        
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()  {
        self.addSubview(self.addSelectBtn(title: self.prompt))
        self.addSubview(self.addArrowBtn())
    }
    
    
    @objc func handleAction()  {
        NotificationCenter.default.post(name: NSNotification.Name.init("cancelKeyBoard"), object: nil)
        if self.modifyDelegate != nil{
            self.modifyDelegate?.goToModifyVC()
        }
    }
}

// Mark 整个界面可能用到的控件
extension CQModifyTimeActionLayout{
    
    @objc internal func addSelectBtn(title:String) -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.addTarget(self ,action:#selector(handleAction), for:.touchUpInside)
        btn.setTitle(title ,for:.normal)
        btn.titleLabel!.font = kFontSize15
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.tag = 200
        btn.tg_height.equal(AutoGetHeight(height: 55))
        btn.tg_left.equal(AutoGetWidth(width: 30))
        btn.tg_width.equal(kWidth - AutoGetWidth(width: 60))
        return btn
    }
    
    @objc internal func addArrowBtn() -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "PersonAddressArrow"), for: .normal)
        btn.tg_height.equal(AutoGetHeight(height: 55))
        btn.tg_width.equal(AutoGetWidth(width: 12.5))
        return btn
    }
}


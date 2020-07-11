//
//  CQTranSportLayout.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/10/29.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit

class CQTranSportLayout: TGLinearLayout {

    var curName = ""
    var type = ""
    var curTitle = ""
    var prompt = ""
    var required = false
    var content = ""
    var viewHeight:CGFloat = 0
    var traficArray = [NCQApprovelDetailModel]()
    
    
    convenience init(orientation: TGOrientation,name:String,type:String,title:String,prompt:String,require:Bool,content:String,traficArray:[NCQApprovelDetailModel]) {
        self.init(frame: CGRect.zero, orientation: orientation, name: name, type: type, title: title, prompt: prompt, require: require,content:content,traficArray:traficArray)
        
    }
    
    init(frame: CGRect, orientation: TGOrientation,name:String,type:String,title:String,prompt:String,require:Bool,content:String,traficArray:[NCQApprovelDetailModel]) {
        super.init(frame: frame, orientation: orientation)
        self.tg_height.equal(.wrap)
        self.tg_width.equal(kWidth)
        self.curName = name
        self.type = type
        self.curTitle = title
        self.prompt = prompt
        self.required = require
        self.content = content
        self.traficArray = traficArray
        self.initView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()  {
        self.addSubview(self.addxingLable())
        var value = ""
        for model in self.traficArray{
            if model.value == self.content{
                value = model.text
            }
        }
        self.addSubview(self.addTitleLable(title: value))
        
    }
    
    
}


// Mark 整个界面可能用到的控件
extension CQTranSportLayout{
    
    
    //*号 在非必填时 隐藏
    @objc internal func addxingLable() -> UILabel{
        let lab = UILabel.init()
        lab.font = kFontSize15
        lab.textAlignment = .left
        lab.textColor = kLyGrayColor
        lab.tg_height.equal(.wrap)
        lab.tg_width.equal(AutoGetWidth(width: 100))
        lab.tg_left.equal(AutoGetWidth(width: 15))
        lab.tg_top.equal(AutoGetHeight(height: 15))
        lab.text = self.curTitle
        return lab
    }
    
    @objc internal func addTitleLable(title:String) -> UILabel{
        let lab = UILabel.init()
        lab.text = title
        lab.font = kFontSize15
        lab.textAlignment = .left
        lab.textColor = UIColor.black
        lab.tg_width.equal(kWidth - AutoGetWidth(width: 150))
        lab.tg_left.equal(AutoGetWidth(width: 20))
        lab.numberOfLines = 0
        lab.contentMode = .topLeft
        let labHeight = getTextHeight(text: self.content, font: kFontSize15, width: kWidth - AutoGetWidth(width: 150)) + AutoGetHeight(height: 10)
        lab.tg_height.equal(labHeight)
        lab.tg_top.equal(AutoGetHeight(height: 10))
        self.viewHeight = labHeight + AutoGetHeight(height: 10)
        return lab
    }
    
}

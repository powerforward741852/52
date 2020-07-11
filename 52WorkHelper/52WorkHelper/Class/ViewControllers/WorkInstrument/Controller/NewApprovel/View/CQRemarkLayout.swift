//
//  CQRemarkLayout.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/11/13.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit

class CQRemarkLayout: TGLinearLayout {

    var curName = ""
    var type = ""
    var curTitle = ""
    var prompt = ""
    var vHeight:CGFloat = AutoGetHeight(height: 20)
    
    convenience init(orientation: TGOrientation,name:String,type:String,title:String,prompt:String) {
        self.init(frame: CGRect.zero, orientation: orientation, name: name, type: type, title: title,prompt:prompt)
        
    }
    
    init(frame: CGRect, orientation: TGOrientation,name:String,type:String,title:String,prompt:String) {
        super.init(frame: frame, orientation: orientation)
        self.tg_height.equal(.wrap)
        self.tg_width.equal(kWidth)
        self.curName = name
        self.prompt = prompt
        self.type = type
        self.curTitle = title
        self.backgroundColor = UIColor.white
        
        let labHeight = getTextHeight(text: self.prompt, font: kFontSize15, width: kWidth - AutoGetWidth(width: 60))
        self.vHeight = AutoGetHeight(height: 20) + labHeight
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()  {
        self.addSubview(self.addTitleLable(title: self.prompt))
    }
}

// Mark 整个界面可能用到的控件
extension CQRemarkLayout{
    @objc internal func addTitleLable(title:String) -> UIView{
        let bgV = UIView.init()
        let labHeight = getTextHeight(text: title, font: kFontSize15, width: kWidth - AutoGetWidth(width: 60))
        bgV.tg_width.equal(kWidth - AutoGetWidth(width: 40))
        bgV.tg_left.equal(AutoGetWidth(width: 20))
        bgV.tg_height.equal(labHeight + AutoGetHeight(height: 20))
        bgV.backgroundColor = kColorRGB(r: 242, g: 246, b: 252)
        bgV.layer.cornerRadius = 3
        
        let lab = UILabel.init(frame: CGRect.init(x: AutoGetWidth(width: 10), y: 0, width: kWidth - AutoGetWidth(width: 60), height: labHeight + AutoGetHeight(height: 20)))
        lab.text = title
        lab.font = kFontSize15
        lab.textAlignment = .left
        lab.textColor = kLyGrayColor
        lab.numberOfLines = 0
        bgV.addSubview(lab)
        return bgV
    }
}

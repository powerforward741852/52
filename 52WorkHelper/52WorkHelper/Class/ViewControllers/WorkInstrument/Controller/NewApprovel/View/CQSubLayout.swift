//
//  CQSubLayout.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/10/26.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit

class CQSubLayout: TGLinearLayout {

    var curName = ""
    var type = ""
    var curTitle = ""
    
    
    convenience init(orientation: TGOrientation,name:String,type:String,title:String) {
        self.init(frame: CGRect.zero, orientation: orientation, name: name, type: type, title: title)
        
    }
    
    init(frame: CGRect, orientation: TGOrientation,name:String,type:String,title:String) {
        super.init(frame: frame, orientation: orientation)
        self.tg_height.equal(.wrap)
        self.tg_width.equal(kWidth)
        self.curName = name
        self.type = type
        self.curTitle = title
        self.backgroundColor = kProjectBgColor
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()  {
        self.addSubview(self.addTitleLable(title: self.curTitle))
    }
}

// Mark 整个界面可能用到的控件
extension CQSubLayout{
    @objc internal func addTitleLable(title:String) -> UILabel{
        let lab = UILabel.init()
        lab.text = title
        lab.font = kFontSize14
        lab.textAlignment = .left
        lab.textColor = kLyGrayColor
//        let labWidth = getTexWidth(textStr: title, font: kFontSize15, height: AutoGetHeight(height: 15))
        lab.tg_width.equal(AutoGetWidth(width: 80))
        lab.tg_left.equal(AutoGetWidth(width: 15))
        lab.tg_height.equal(AutoGetHeight(height: 15))
        return lab
    }
}

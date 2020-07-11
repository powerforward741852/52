//
//  UIButton+extension.swift
//  SSHweibo
//
//  Created by 秦榕 on 2018/8/30.
//  Copyright © 2018年 秦榕. All rights reserved.
//

import UIKit
//遍历构造器
extension UIButton {
    convenience init(title:String,
                     imgName:String? = nil,
                     backgroundImage:String? = nil,
                     titleColor:UIColor = UIColor.darkGray,
                     fontSize:CGFloat = 14,
                     target: AnyObject? = nil,
                     action: String? = nil,
                     event: UIControlEvents = .touchUpInside
        ){
        self.init()
       //文字
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
       //图片
        if let imgName = imgName {
        self.setImage(UIImage(named:imgName), for: .normal)
        self.setImage(UIImage(named:"\(imgName)_highlighted"), for: .normal)
        }
        //背景图片
        if let backgroundImage = backgroundImage {
            self.setBackgroundImage(UIImage(named: backgroundImage), for: .normal)
            self.setBackgroundImage(UIImage(named: "\(backgroundImage)_highlighted"), for: .highlighted)
        }
        
        //时间和target目标
        if let target = target , let action = action {
        self.addTarget(target, action: Selector(action), for: event)
        }
        sizeToFit()
    }
    
    
    
}

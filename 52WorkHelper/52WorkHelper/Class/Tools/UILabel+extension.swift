//
//  UILabel+extension.swift
//  SSHweibo
//
//  Created by 秦榕 on 2018/8/30.
//  Copyright © 2018年 秦榕. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(title:String,
                     textColor: UIColor = UIColor.darkGray,
                     fontSize: CGFloat = 13,
                     alignment: NSTextAlignment = .left,
                     numberOfLines: Int = 0){
        self.init()
        self.text = title
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.textAlignment = alignment
        self.numberOfLines = numberOfLines
        
        
    }
   

}

//
//  UIViewExt.swift
//  LSByCQH
//
//  Created by chenqihang on 2017/11/7.
//  Copyright © 2017年 chenqihang. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    
    
    var bottom : CGFloat{return self.frame.origin.y + self.frame.size.height}
    var top :CGFloat{return self.frame.origin.y}
    
    var bottomRight :CGPoint{return CGPoint.init(x: self.frame.origin.x + self.frame.size.width, y: self.frame.origin.y + self.frame.size.height)}
    
    var left :CGFloat{return self.frame.origin.x}
    var right :CGFloat{return self.frame.origin.x + self.frame.size.width}
    
    
    var width: CGFloat{return self.frame.size.width}
    
    /// 中心点X
    var st_centerX: CGFloat {
        get{
            return self.center.x
        }
        set{
            var r = self.center
            r.x = newValue
            self.center = r
        }
        
    }
}

//
//  UITabbarBadge.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/6.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

extension UITabBar {
    //添加小红点
    func showBadgeOnItemIndex(index: Int) {
        
        let bageView = UIImageView()
        bageView.image = #imageLiteral(resourceName: "diandian")
        bageView.tag = 100 + index
        let tabbarFrame = self.frame
        
        let count = Double(index)
        let percentX = (count + 0.6) / 5
        let x = ceilf(Float(CGFloat(percentX) * tabbarFrame.size.width))
        let y = ceilf(Float(0.1 * tabbarFrame.size.height))
        bageView.frame = CGRect(x: Double(x), y: Double(y), width: Double(10.0), height: Double(10.0))
        self.addSubview(bageView)
    }
    
    //移除小红点
    func removeBadgeOnItemIndex(index: Int) {
        let bageView = self.viewWithTag(100 + index)
        bageView?.removeFromSuperview()
    }
}

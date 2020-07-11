//
//  QRDecorateView.swift
//  test
//
//  Created by 秦榕 on 2018/12/4.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit

class QRDecorateView: UICollectionReusableView {
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
//        self.layer.shadowOpacity = 0.2;// 阴影透明度
//        self.layer.shadowColor = UIColor.black.cgColor;// 阴影的颜色
//        self.layer.shadowRadius = 0.3;// 阴影扩散的范围控制
//        self.layer.shadowOffset  = CGSize(width: 0.2, height: 0.2)// 阴影的范围
//
//        self.layer.borderColor = kProjectDarkBgColor.cgColor
//        self.layer.borderWidth = 0.7
       
        
        
        self.clipsToBounds = false
        let upView = UIView(frame:  CGRect(x: 0, y: 0, width: self.width, height: 30))
        upView.backgroundColor = UIColor.white
//        upView.layer.borderColor = UIColor.white.cgColor
//        upView.layer.borderWidth = 0.7
        self.addSubview(upView)
    }
}

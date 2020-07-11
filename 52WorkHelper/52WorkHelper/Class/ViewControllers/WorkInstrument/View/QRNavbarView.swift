//
//  QRNavbarView.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/4/24.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit
enum clickType {
    case back
    case rightClick
}
class QRNavbarView: UIView {
    
    //声明闭包
    typealias clickBtnClosure = (_ clickType: clickType) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    @IBOutlet weak var backBut: UIButton!
    
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var rightBut: UIButton!
    @IBOutlet weak var jianTouIma: UIImageView!
    
    @IBOutlet weak var jtCenterY: NSLayoutConstraint!
    
    @IBOutlet weak var butCenterY: NSLayoutConstraint!
    
    @IBOutlet weak var rightCenterY: NSLayoutConstraint!
    @IBOutlet weak var titleCenterY: NSLayoutConstraint!
    
    
    
    @IBAction func backClick(_ sender: Any) {
        if let bibao = clickClosure{
            bibao(.back)
        }
    }
    
    @IBAction func rightClick(_ sender: Any) {
        if let bibao = clickClosure{
            bibao(.rightClick)
        }
    }
    
    
    override func awakeFromNib() {
        backBut.setTitleColor(kBlueColor, for: UIControlState.normal)
        jianTouIma.tintColor = kBlueColor
        if SafeAreaStateTopHeight > 20{
            jtCenterY.constant = 20
            butCenterY.constant = 20
            rightCenterY.constant = 20
            titleCenterY.constant = 20
        }
    }
}

//
//  QREditView.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/19.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QREditView: UIView {

    
    lazy var lab1 :UILabel = {
        let lab = UILabel(title: "编辑联系人", textColor: UIColor.black, fontSize: 14)
        return lab
    }()
    lazy var lab2 :UILabel = {
        let lab = UILabel(title: "阿萨德南十多年", textColor: UIColor.lightGray, fontSize: 14)
        lab.numberOfLines = 0
        return lab
    }()
    lazy var grey :UIView = {
        let grey = UIView()
        grey.backgroundColor = kProjectBgColor
        return grey
    }()
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        setupUI()
    }
    func setupUI(){
        
        self.addSubview(lab1)
        self.addSubview(lab2)
        self.addSubview(grey)
        lab1.mas_makeConstraints { (make) in
         //   make?.top.mas_equalTo()(self)
            make?.left.mas_equalTo()(kLeftDis)
            make?.centerY.mas_equalTo()(self)
           // make?.bottom.mas_equalTo()(self)
        }
        lab2.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(lab1.mas_right)?.setOffset(kLeftDis)
            make?.centerY.mas_equalTo()(self)
            make?.right.mas_equalTo()(self)?.setOffset(-AutoGetWidth(width: 15))
        }
        grey.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(kLeftDis)
            make?.width.mas_equalTo()(kWidth-kLeftDis)
            make?.top.mas_equalTo()(lab1.mas_bottom)?.setOffset(10)
            make?.height.mas_equalTo()(0.5)
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

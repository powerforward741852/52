//
//  QRStatusView.swift
//  test
//
//  Created by 秦榕 on 2018/9/11.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit

class QRStatusView: UIView {

    /// 头像
    let iconImageView: UIImageView = UIImageView(image: UIImage(named: "CQIndexPersonDefault"))
    /// 用户名
    let userName: UILabel = UILabel(title: "小明爱睡觉", fontSize: 15 )
    /// 发布时间
    let creatTime: UILabel = UILabel(title: "五分钟前", textColor: UIColor.gray, fontSize: 11)
    /// 微博的正文
   // let statusText: UILabel = UILabel(title: "asjdhkjsahdk", textColor: kColorRGB(r: 132, g: 131, b: 132), fontSize: 14,alignment: NSTextAlignment.left, numberOfLines: 0)
    let statusText : MLLinkLabel =  {
        let lab = MLLinkLabel()
        lab.text = ""
        lab.textColor =  kColorRGB(r: 132, g: 131, b: 132)
        lab.font = kFontSize14
        lab.textAlignment = .left
        lab.numberOfLines = 0
        return lab
    }()
    
  
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        setupUi()
    }
    
    func setupUi()  {
        //添加子视图
        addSubview(iconImageView)
        addSubview(userName)
        addSubview(creatTime)
        addSubview(statusText)
        iconImageView.layer.cornerRadius = AutoGetWidth(width: 18)
        iconImageView.clipsToBounds = true
        userName.font = kFontBoldSize15
        
        iconImageView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(self)?.setOffset(kLeftDis)
            make?.top.mas_equalTo()(self)?.setOffset(18)
            make?.width.mas_equalTo()(AutoGetWidth(width: 36))
            make?.height.mas_equalTo()(AutoGetWidth(width: 36))
        }
        userName.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(iconImageView.mas_right)?.setOffset(kLeftDis)
            make?.top.mas_equalTo()(iconImageView)
        }
        creatTime.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(iconImageView.mas_right)?.setOffset(kLeftDis)
            make?.top.mas_equalTo()(userName.mas_bottom)?.setOffset(5)
        }
        statusText.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(iconImageView)
            make?.top.mas_equalTo()(iconImageView.mas_bottom)?.setOffset(12)
            make?.right.mas_equalTo()(self)?.setOffset(-kLeftDis)
            make?.bottom.mas_equalTo()(self)?.setOffset(0)
        }
    
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

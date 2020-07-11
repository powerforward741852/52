//
//  QRBusinessDetailHeadVeiw.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/12.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRBusinessDetailHeadVeiw: UIView {

    lazy var bigView :UIView = {
        let big = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: 150))
        big.backgroundColor = UIColor.red
        return big
    }()
    lazy var title :UILabel = {
        let big = UILabel(title: "商机名称商机", textColor: UIColor.black, fontSize: 18)
        return big
    }()
    lazy var jinger :UILabel = {
        let big = UILabel(title: "商机金额:", textColor: klightGreyColor, fontSize: 15)
        return big
    }()
    lazy var end :UILabel = {
        let big = UILabel(title: "预计结单时间:", textColor: klightGreyColor, fontSize: 15)
        return big
    }()
    
    lazy var yang :UILabel = {
        let big = UILabel(title: "羊", textColor: korgColor, fontSize: 15)
        return big
    }()
    lazy var money :UILabel = {
        let big = UILabel(title: "2000:", textColor: korgColor, fontSize: 15)
        return big
    }()
    lazy var endTime :UILabel = {
        let big = UILabel(title: "2018-01-02", textColor: klightGreyColor, fontSize: 15)
        return big
    }()
    
    lazy var contractBut :UIButton = {
        let big = UIButton(title: "合同")
        big.setBackgroundImage(imageWithColor(color: klightBlueColor, size: CGSize(width: 60, height: 36)), for: .normal)
        return big
    }()
    lazy var lianxiren :UIButton = {
        let big = UIButton(title:"联系人")
        big.setBackgroundImage(imageWithColor(color: klightBlueColor, size: CGSize(width: 60, height: 36)), for: .normal)
        return big
    }()
    
    lazy var saleStage :UILabel = {
        let big = UILabel(title: "审核谈判80%", textColor: klightBlueColor, fontSize: 15)
        return big
    }()
    lazy var jiantou :UIImageView = {
        let big = UIImageView(image: UIImage(named:"roomClose"))
        return big
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
         addSubview(bigView)
    }
    
    init() {
      super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
       
//        bigView.addSubview(title)
//        bigView.addSubview(jinger)
//        bigView.addSubview(end)
//        bigView.addSubview(yang)
//        bigView.addSubview(money)
//        bigView.addSubview(jiantou)
//        bigView.addSubview(endTime)
//        bigView.addSubview(contractBut)
//        bigView.addSubview(lianxiren)
//        bigView.addSubview(saleStage)
        
        bigView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(self)?.setOffset(15)
            make?.right.mas_equalTo()(self)?.setOffset(-15)
            make?.top.mas_equalTo()(self)?.setOffset(15)
            make?.height.mas_equalTo()(150)
            make?.width.mas_equalTo()(kWidth)
            make?.bottom.mas_equalTo()(-15)
        }
        title.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(15)
            make?.top.mas_equalTo()(15)
        }
        jinger.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(title)
            make?.top.mas_equalTo()(10)
        }
        yang.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(jinger.mas_right)
            make?.centerY.mas_equalTo()(jinger.mas_centerY)
        }
        money.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(yang.mas_right)
            make?.centerY.mas_equalTo()(jinger.mas_centerY)
        }
        end.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(jinger)
            make?.top.mas_equalTo()(jinger.mas_bottom)?.setOffset(10)
        }
        endTime.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(endTime.mas_right)
            make?.centerY.mas_equalTo()(end.mas_centerY)
        }

        contractBut.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(end)
            make?.top.mas_equalTo()(end.mas_bottom)?.setOffset(15)
        }
        lianxiren.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contractBut.mas_right)?.setOffset(10)
            make?.centerY.mas_equalTo()(contractBut.mas_centerY)
        }
        saleStage.mas_makeConstraints { (make) in

        }

        
        
        
    }
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

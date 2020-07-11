//
//  QRContrectDetailCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/6.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRContrectDetailCell: UITableViewCell {

    //属性观察器
    var model: QRGoodListModel? {
        didSet {
            self.name.text = model?.commodityName
            self.number.text = model?.number
            self.money.text = model?.total
            self.tai.text = model?.commodityUnitName
        }
    }
    
    lazy var name :UILabel = {
        let nan = UILabel(title: "打印机:", textColor: klightGreyColor, fontSize: 15)
        return nan
    }()
    lazy var number :UILabel = {
        let nan = UILabel(title: "111", textColor: klightGreyColor, fontSize: 15)
        return nan
    }()
    lazy var tai :UILabel = {
        let nan = UILabel(title: "台", textColor: klightGreyColor, fontSize: 15)
        return nan
    }()
    lazy var yang :UILabel = {
        let nan = UILabel(title: "￥", textColor: korgColor, fontSize: 15)
        return nan
    }()
    lazy var money :UILabel = {
        let nan = UILabel(title: "2555", textColor: korgColor, fontSize: 15)
        return nan
    }()
    
    lazy var leftWiteV :UIView = {
        let nan = UIView()
        nan.backgroundColor = UIColor.white
        return nan
    }()
    lazy var rightWiteV :UIView = {
        let nan = UIView()
        nan.backgroundColor = UIColor.white
        return nan
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(name)
        contentView.addSubview(number)
        contentView.addSubview(tai)
        contentView.addSubview(yang)
        contentView.addSubview(money)
        contentView.addSubview(leftWiteV)
        contentView.addSubview(rightWiteV)
       
        self.backgroundColor = kColorRGB(r: 242, g: 242, b: 242)
        
        leftWiteV.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)
            make?.top.mas_equalTo()(contentView)
            make?.bottom.mas_equalTo()(contentView)
            make?.width.mas_equalTo()(kLeftDis)
        }
        rightWiteV.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(contentView)
            make?.top.mas_equalTo()(contentView)
            make?.bottom.mas_equalTo()(contentView)
            make?.width.mas_equalTo()(kLeftDis)
        }
        
        name.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(AutoGetHeight(height: 23))
            make?.top.mas_equalTo()(AutoGetHeight(height: 16))
        }
        number.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(name.mas_right)?.setOffset(AutoGetHeight(height: 17))
            make?.centerY.mas_equalTo()(name)
        }
        tai.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(number.mas_right)
            make?.centerY.mas_equalTo()(name)
        }
        money.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(-AutoGetWidth(width: 23))
            make?.centerY.mas_equalTo()(name)
        }
        yang.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(money.mas_left)
            make?.centerY.mas_equalTo()(name)
        }
//        contentView.mas_makeConstraints { (make) in
//            make?.left.mas_equalTo()(15)
//            make?.right.mas_equalTo()(-15)
//        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  QRGoodsCell.swift
//  test
//
//  Created by 秦榕 on 2018/9/8.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit

class QRGoodsCell: UITableViewCell {
    
    var model:QRGoodsModel?{
        didSet{
            
            if model?.commodityName == nil {
                Name.text = ""
            }else{
                Name.text = model?.commodityName
            }
            
            if model?.commodityPrice == nil {
                money.text = ""
            }else{
                money.text = model?.commodityPrice
            }
            
            if model?.commodityUnitName == nil {
                danwei.text = ""
            }else{
                danwei.text = model?.commodityUnitName
            }
            if model?.commodityCategoryName == nil {
                cate.text = ""
            }else{
                cate.text = model?.commodityCategoryName
            }
            
            
        }
    }
    
    
    lazy var Name:UILabel = {
        let tips = UILabel(title: "打印机:", textColor: UIColor.black, fontSize: 16)
        return tips
    }()
    lazy var xiaoshoujia:UILabel = {
        let tips = UILabel(title: "销售价:", textColor: kLyGrayColor, fontSize: 13)
        return tips
    }()
    lazy var fenlei:UILabel = {
        let tips = UILabel(title: "分类:", textColor: kLyGrayColor, fontSize: 13)
        return tips
    }()
    lazy var money:UILabel = {
        let tips = UILabel(title: "55", textColor: kLyGrayColor, fontSize: 13)
        return tips
    }()
    lazy var danwei:UILabel = {
        let tips = UILabel(title: "元/件", textColor: kLyGrayColor, fontSize: 13)
        return tips
    }()
    
    
    lazy var cate:UILabel = {
        let tips = UILabel(title: "办公用品", textColor: kLyGrayColor, fontSize: 13)
        return tips
    }()
    
    lazy var greyLine:UIView = {
        let tips = UIView()
        tips.backgroundColor = kLyGrayColor
        return tips
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(Name)
        contentView.addSubview(xiaoshoujia)
        contentView.addSubview(money)
        contentView.addSubview(danwei)
        contentView.addSubview(cate)
        contentView.addSubview(fenlei)
        contentView.addSubview(greyLine)
        Name.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(contentView)?.setOffset(AutoGetWidth(width: 18))
            make?.left.mas_equalTo()(contentView)?.setOffset(AutoGetWidth(width: 15))
        
        }
        xiaoshoujia.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(Name.mas_bottom)?.setOffset(AutoGetWidth(width: 9))
            make?.left.mas_equalTo()(contentView)?.setOffset(AutoGetWidth(width: 15))
            
        }
        money.mas_makeConstraints { (make) in
            make?.centerY.mas_equalTo()(xiaoshoujia)
            make?.left.mas_equalTo()(xiaoshoujia.mas_right)?.setOffset(AutoGetWidth(width: 15))
            
        }
        danwei.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(money.mas_right)
            make?.centerY.mas_equalTo()(xiaoshoujia)
        }
        fenlei.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(xiaoshoujia.mas_bottom)?.setOffset(AutoGetWidth(width: 7))
            make?.left.mas_equalTo()(contentView)?.setOffset(AutoGetWidth(width: 15))
            
        }
        cate.mas_makeConstraints { (make) in
            make?.centerY.mas_equalTo()(fenlei)
            make?.left.mas_equalTo()(fenlei.mas_right)?.setOffset(AutoGetWidth(width: 15))
            make?.bottom.mas_equalTo()(contentView.mas_bottom)?.setOffset(-AutoGetWidth(width: 20))
            
        }
        greyLine.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)?.setOffset(AutoGetWidth(width: 15 ))
            make?.width.mas_equalTo()(kWidth-AutoGetWidth(width: 15))
            make?.height.mas_equalTo()(0.5)
            make?.bottom.mas_equalTo()(contentView)?.setOffset(-1)
        }
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

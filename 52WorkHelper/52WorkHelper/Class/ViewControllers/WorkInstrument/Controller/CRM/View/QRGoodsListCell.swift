//
//  GoodsListCell.swift
//  test
//
//  Created by 秦榕 on 2018/9/4.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit

class QRGoodsListCell: UITableViewCell {
    
    var model: QRBiaoModel? {
        didSet {
//            var commodityId = ""
//            var commodityName = ""
//            var commodityPrice = ""
//            var commodityUnitName = ""
//            var number = ""
//            var total = ""
            //赋值
           // goods.text = model?.commodityId
            name.text = model?.commodityName
            perMoney.text = "元/" + (model?.commodityUnitName)!
            price1.text = model?.commodityPrice
            num.text = model?.number
            price2.text = model?.total
        }
    }
    
    
    //商品1
    let goods : UILabel = {
        let peo = UILabel(title: "商品", textColor: UIColor.black, fontSize: 15, alignment:.center, numberOfLines: 0)
        return peo
    }()
    let price1 : UILabel = {
        let peo = UILabel(title: "521", textColor: UIColor.orange, fontSize: 15, alignment:.center, numberOfLines: 0)
        return peo
    }()
    let price2 : UILabel = {
        let peo = UILabel(title: "元", textColor: UIColor.orange, fontSize: 15, alignment:.center, numberOfLines: 0)
        return peo
    }()
    
    //打印机
    let name : UILabel = {
        let peo = UILabel(title: "打印机", textColor: klightGreyColor, fontSize: 15, alignment:.center, numberOfLines: 0)
        return peo
    }()

    //数量
    let count : UILabel = {
        let peo = UILabel(title: "数量", textColor: klightGreyColor, fontSize: 15, alignment:.center, numberOfLines: 0)
        return peo
    }()

    //金额
    let money : UILabel = {
        let peo = UILabel(title: "金额", textColor: klightGreyColor, fontSize: 15, alignment:.center, numberOfLines: 0)
        return peo
    }()

    //单价
    let perMoney : UILabel = {
        let peo = UILabel(title: "元/件", textColor: klightGreyColor, fontSize: 15, alignment:.center, numberOfLines: 0)
        return peo
    }()

    //数量
    let num : UILabel = {
        let peo = UILabel(title: "2", textColor: UIColor.black, fontSize: 15, alignment:.center, numberOfLines: 0)
        return peo
    }()

    //总价
    let zhongjia : UILabel = {
        let peo = UILabel(title: "元", textColor: klightGreyColor, fontSize: 15, alignment:.center, numberOfLines: 0)
        return peo
    }()
    
    let greyLine  : UIView = {
        let peo = UIView()
        peo.backgroundColor = kAlpaRGB(r: 247, g: 247, b: 247, a: 1)
        return peo
    }()
    
    let bigView  : UIView = {
        let peo = UIView()
        peo.backgroundColor = UIColor.white
        peo.layer.cornerRadius = 5
        peo.clipsToBounds = true
        return peo
    }()
    
    func kColorRGB (r: CGFloat,g:CGFloat,b:CGFloat) -> UIColor{
        return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = kColorRGB(r: 245, g: 245, b: 245)
        
       contentView.addSubview(bigView)
       bigView.addSubview(goods)
       bigView.addSubview(name)
       bigView.addSubview(count)
       bigView.addSubview(num)
       bigView.addSubview(money)
       bigView.addSubview(greyLine)
       bigView.addSubview(zhongjia)
       bigView.addSubview(perMoney)
       bigView.addSubview(price1)
       bigView.addSubview(price2)

        
        goods.mas_makeConstraints { (make) in
        make?.left.mas_equalTo()(bigView)?.setOffset(AutoGetWidth(width: 14))
        make?.top.mas_equalTo()(bigView)?.setOffset(AutoGetWidth(width: 12.5))
        }
        
        greyLine.mas_makeConstraints { (make) in
        make?.left.mas_equalTo()(bigView)?.setOffset(0)
        make?.top.mas_equalTo()(goods.mas_bottom)?.setOffset(AutoGetWidth(width: 12.5))
        make?.height.mas_equalTo()(AutoGetWidth(width: 0.8))
        make?.width.mas_equalTo()(kWidth)
        }
        
        name.mas_makeConstraints { (make) in
        make?.top.mas_equalTo()(greyLine.mas_bottom)?.setOffset(AutoGetWidth(width: 21))
        make?.left.mas_equalTo()(bigView.mas_left)?.setOffset(AutoGetWidth(width: 14))
        }

        count.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(name.mas_bottom)?.setOffset(AutoGetWidth(width: 14))
            make?.left.mas_equalTo()(bigView.mas_left)?.setOffset(AutoGetWidth(width: 14))
        }
        
        money.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(count.mas_bottom)?.setOffset(AutoGetWidth(width: 14))
            make?.left.mas_equalTo()(bigView.mas_left)?.setOffset(AutoGetWidth(width: 14))
            make?.bottom.mas_equalTo()(bigView)?.setOffset(-AutoGetWidth(width: 20))
        }

        num.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(count)
            make?.right.mas_equalTo()(bigView.mas_right)?.setOffset(-AutoGetWidth(width: 14))
        }

        zhongjia.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(money)
            make?.right.mas_equalTo()(bigView.mas_right)?.setOffset(-AutoGetWidth(width: 14))
        }

        perMoney.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(name)
            make?.right.mas_equalTo()(bigView.mas_right)?.setOffset(-AutoGetWidth(width: 14))
        }

        bigView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView.mas_left)?.setOffset(kLeftDis)
            make?.top.mas_equalTo()(contentView.mas_top)?.setOffset(AutoGetWidth(width: 10))
            make?.width.mas_equalTo()(kWidth-AutoGetWidth(width: 30))
            make?.bottom.mas_equalTo()(contentView.mas_bottom)?.setOffset(-AutoGetWidth(width: 10))
        }

        price1.mas_makeConstraints { (make) in
          make?.top.mas_equalTo()(perMoney)
          make?.right.mas_equalTo()(perMoney.mas_left)
        }
        price2.mas_makeConstraints { (make) in
          make?.top.mas_equalTo()(zhongjia)
          make?.right.mas_equalTo()(zhongjia.mas_left)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

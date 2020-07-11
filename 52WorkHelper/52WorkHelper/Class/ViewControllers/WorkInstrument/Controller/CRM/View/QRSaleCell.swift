//
//  QRSaleCell.swift
//  test
//
//  Created by 秦榕 on 2018/9/8.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit

class QRSaleCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model : QRGoodSaleModel? {
        didSet{
            if let name = model?.commodityName{
                mingcheng.text = name
            }else{
                mingcheng.text = ""
            }
            
            if let name = model?.customerName{
                kehuming.text = name
            }else{
                kehuming.text = ""
            }
            
            if let name = model?.commodityCode{
                bianhao.text = name
            }else{
                bianhao.text = ""
            }
            
            if let name = model?.startDate{
                shijian.text = name
            }else{
                shijian.text = ""
            }
            
            if let name = model?.saleNumber{
                num.text = name
            }else{
                num.text = ""
            }
        
    
        }
    }
    
    lazy var big :UIView = {
        let lab = UIView()
        lab.backgroundColor = UIColor.white
        lab.layer.borderColor = UIColor.lightGray.cgColor
        lab.layer.borderWidth = 0.5
        lab.layer.shadowOffset = CGSize(width: 1, height: 1)
        lab.layer.shadowColor = UIColor.lightGray.cgColor
        lab.layer.cornerRadius = 10
        lab.clipsToBounds = true
        return lab
    }()
    
    lazy var shangpingmincheng :UILabel = {
        let lab = UILabel(title: "商品名称", textColor: kLyGrayColor, fontSize: 15)
        return lab
    }()
    lazy var mingcheng :UILabel = {
        let lab = UILabel(title: "打印机", textColor: UIColor.black, fontSize: 15)
        return lab
    }()
    lazy var kehu :UILabel = {
        let lab = UILabel(title: "客户", textColor: kLyGrayColor, fontSize: 15)
        return lab
    }()
    lazy var kehuming :UILabel = {
        let lab = UILabel(title: "思美达科技有限公司", textColor: UIColor.black, fontSize: 15)
        return lab
    }()
    lazy var shaoppinbianhao :UILabel = {
        let lab = UILabel(title: "商品编号", textColor: kLyGrayColor, fontSize: 15)
        return lab
    }()
    lazy var bianhao :UILabel = {
        let lab = UILabel(title: "adkdhkakdjsahd", textColor: UIColor.black, fontSize: 15)
        return lab
    }()
    lazy var xiadanshijian :UILabel = {
        let lab = UILabel(title: "下单时间", textColor: kLyGrayColor, fontSize: 15)
        return lab
    }()
    lazy var shijian :UILabel = {
        let lab = UILabel(title: "2018-3-3", textColor: UIColor.black, fontSize: 15)
        return lab
    }()
    lazy var xiadanshuliang :UILabel = {
        let lab = UILabel(title: "下单数量", textColor: kLyGrayColor, fontSize: 15)
        return lab
    }()
    lazy var num :UILabel = {
        let lab = UILabel(title: "2", textColor: UIColor.black, fontSize: 15)
        return lab
    }()
   
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(big)
        big.addSubview(shangpingmincheng)
        big.addSubview(mingcheng)
        big.addSubview(kehu)
        big.addSubview(kehuming)
        big.addSubview(shaoppinbianhao)
        big.addSubview(bianhao)
        big.addSubview(xiadanshijian)
        big.addSubview(shijian)
        big.addSubview(xiadanshuliang)
        big.addSubview(num)
        self.backgroundColor = kProjectBgColor
        big.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)?.setOffset(kLeftDis)
            make?.right.mas_equalTo()(contentView)?.setOffset(-kLeftDis)
            make?.top.mas_equalTo()(contentView)?.setOffset(kLeftDis)
            make?.bottom.mas_equalTo()(contentView)?.setOffset(-AutoGetWidth(width: 13))
        }
        shangpingmincheng.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(big)?.setOffset(kLeftDis)
            make?.left.mas_equalTo()(big)?.setOffset(kLeftDis)
        }
        kehu.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(shangpingmincheng.mas_bottom)?.setOffset(AutoGetWidth(width: 12))
            make?.left.mas_equalTo()(big)?.setOffset(kLeftDis)
        }
        shaoppinbianhao.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(kehu.mas_bottom)?.setOffset(AutoGetWidth(width: 12))
            make?.left.mas_equalTo()(big)?.setOffset(kLeftDis)
        }
        xiadanshijian.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(shaoppinbianhao.mas_bottom)?.setOffset(AutoGetWidth(width: 12))
            make?.left.mas_equalTo()(big)?.setOffset(kLeftDis)
        }
        xiadanshuliang.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(xiadanshijian.mas_bottom)?.setOffset(AutoGetWidth(width: 12))
            make?.left.mas_equalTo()(big)?.setOffset(kLeftDis)
            make?.bottom.mas_equalTo()(big.mas_bottom)?.setOffset(-kLeftDis)
        }
        
        mingcheng.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(big)?.setOffset(-kLeftDis)
            make?.centerY.mas_equalTo()(shangpingmincheng)
        }
        kehuming.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(big)?.setOffset(-kLeftDis)
            make?.centerY.mas_equalTo()(kehu)
        }
        bianhao.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(big)?.setOffset(-kLeftDis)
            make?.centerY.mas_equalTo()(shaoppinbianhao)
        }
        shijian.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(big)?.setOffset(-kLeftDis)
            make?.centerY.mas_equalTo()(xiadanshijian)
        }
        num.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(big)?.setOffset(-kLeftDis)
            make?.centerY.mas_equalTo()(xiadanshuliang)
        }
        
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

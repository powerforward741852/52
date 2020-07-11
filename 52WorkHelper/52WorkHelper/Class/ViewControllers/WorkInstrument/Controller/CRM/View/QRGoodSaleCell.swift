//
//  QRGoodSaleCell.swift
//  test
//
//  Created by 秦榕 on 2018/9/8.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit

class QRGoodSaleCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    
    var model :QRSaleModel?{
        didSet{
            labNum.text = model?.monthSaleNumber
         //   print(<#T##items: Any...##Any#>)
            labName.text = model?.monthSales
        }
    }
    
    
    
    lazy var topView :UIView = {
       let img = UIView()
        img.backgroundColor = kBlueColor
        return img
    }()
    
    lazy var cir :UIView = {
         let imgs = UIView()
        imgs.frame = CGRect(x: 1, y: 1, width: 13, height: 13)
        imgs.backgroundColor = UIColor.white
        imgs.layer.cornerRadius = 6.5
        imgs.clipsToBounds = true
        return imgs
    }()
    lazy var circle :UIView = {
        let img = UIView()
        img.backgroundColor = kBlueColor
        img.layer.cornerRadius = 7.5
        img.clipsToBounds = true
        let imgs = cir
        img.addSubview(imgs)
       
        
        
        
        return img
    }()
    lazy var bottomView :UIView = {
        let img = UIView()
        img.backgroundColor = kBlueColor
        return img
    }()
    
    lazy var ima1 :UIImageView = {
        let img = UIImageView(image: UIImage(named: "PersonAddressArrow"))
        return img
    }()
    lazy var labName :UILabel = {
        let lab = UILabel(title: "全部销售", textColor: UIColor.black, fontSize: 15)
        return lab
    }()
    lazy var labNum :UILabel = {
        let lab = UILabel(title: "100", textColor: UIColor.lightGray, fontSize: 15)
        return lab
    }()
    lazy var greyLine :UIView = {
        let lab = UIView()
        lab.backgroundColor = kProjectBgColor
        return lab
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        contentView.addSubview(topView)
        contentView.addSubview(circle)
        contentView.addSubview(bottomView)
        contentView.addSubview(ima1)
        contentView.addSubview(labNum)
        contentView.addSubview(labName)
        contentView.addSubview(greyLine)
        
        topView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)?.setOffset(AutoGetWidth(width: 22))
            make?.top.mas_equalTo()(contentView)
            make?.height.mas_equalTo()(20)
            make?.width.mas_equalTo()(1)
        }
        circle.mas_makeConstraints { (make) in
            make?.centerX.mas_equalTo()(topView)
            make?.centerY.mas_equalTo()(contentView)
            make?.height.mas_equalTo()(15)
            make?.width.mas_equalTo()(15)
        }
        
        bottomView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)?.setOffset(AutoGetWidth(width: 22))
            make?.bottom.mas_equalTo()(contentView)
            make?.height.mas_equalTo()(20)
            make?.width.mas_equalTo()(1)
        }
        
        
        ima1.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(contentView)?.setOffset(-kLeftDis)
            make?.centerY.mas_equalTo()(contentView)
        }
        labName.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)?.setOffset(AutoGetWidth(width: 40))
            make?.centerY.mas_equalTo()(contentView)
        }
        labNum.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(ima1.mas_left)?.setOffset(-AutoGetWidth(width: 10))
            make?.centerY.mas_equalTo()(contentView)
        }
        greyLine.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)?.setOffset(AutoGetWidth(width: 40))
            make?.bottom.mas_equalTo()(contentView)?.setOffset(-0.5)
            make?.height.mas_equalTo()(0.5)
            make?.right.mas_equalTo()(contentView)
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

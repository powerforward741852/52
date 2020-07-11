//
//  QRGoodDtailCell.swift
//  test
//
//  Created by 秦榕 on 2018/9/8.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit

class QRGoodDtailCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    lazy var lab1 :UILabel = {
        let lab = UILabel(title: "商品名称", textColor: kLyGrayColor, fontSize: 17)
        return lab
    }()
    lazy var lab2 :UILabel = {
        let lab = UILabel(title: "详情", textColor: kLyGrayColor, fontSize: 17)
        return lab
    }()
    lazy var line :UIView = {
        let lab = UIView()
        lab.backgroundColor = kLyGrayColor
        return lab
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(lab1)
        contentView.addSubview(lab2)
        contentView.addSubview(line)
        lab1.mas_makeConstraints { (make) in
            make?.centerY.mas_equalTo()(contentView)
            make?.left.mas_equalTo()(contentView)?.setOffset(15)
        }
        lab2.mas_makeConstraints { (make) in
            make?.centerY.mas_equalTo()(contentView)
            make?.right.mas_equalTo()(contentView)?.setOffset(-15)
        }
        line.mas_makeConstraints { (make) in
            make?.bottom.mas_equalTo()(contentView)
            make?.left.mas_equalTo()(contentView)?.setOffset(20)
            make?.right.mas_equalTo()(contentView)
            make?.height.mas_equalTo()(0.5)
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

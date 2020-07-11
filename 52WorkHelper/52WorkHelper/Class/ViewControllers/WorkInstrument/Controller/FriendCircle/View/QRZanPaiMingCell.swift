//
//  QRZanPaiMingCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/18.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRZanPaiMingCell: UITableViewCell {

    lazy var iconImg : UIImageView = {
        let iconImg = UIImageView(frame:  CGRect(x: 0, y: 0, width: AutoGetWidth(width: 45), height: AutoGetWidth(width: 45)))
        iconImg.layer.cornerRadius = AutoGetWidth(width: 45)/2
        iconImg.clipsToBounds = true
        iconImg.image = UIImage(named: "GroupChatSet")
        return iconImg
    }()
    lazy var paiMingLable :UILabel = {
        let paiMingLable = UILabel(title: "", textColor: UIColor.black, fontSize: 14)
        paiMingLable.numberOfLines = 1
        paiMingLable.textAlignment = .center
        return paiMingLable
    }()
    lazy var nameLable :UILabel = {
        let nameLable = UILabel(title: " ", textColor: UIColor.black, fontSize: 14)
        nameLable.numberOfLines = 1
        nameLable.textAlignment = .center
        return nameLable
    }()
    lazy var zanLable :UILabel = {
        let zanLable = UILabel(title: "0", textColor: UIColor.black, fontSize: 14)
        zanLable.numberOfLines = 1
        zanLable.textAlignment = .center
        return zanLable
    }()
    var model : QRZanlistModel?{
        didSet{
             // if model?.admirNum
             nameLable.text = model?.realName
             zanLable.text = model?.admirNum
             paiMingLable.text = model?.number
            
            iconImg.sd_setImage(with: URL(string: model?.headImage ?? ""), placeholderImage: UIImage(named: "CQIndexPersonDefault"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
            
        }
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(iconImg)
        self.contentView.addSubview(nameLable)
        self.contentView.addSubview(zanLable)
        self.contentView.addSubview(paiMingLable)
       
        paiMingLable.mas_makeConstraints { (make) in
            make?.centerY.mas_equalTo()(self.contentView.mas_centerY)
            make?.centerX.mas_equalTo()(contentView.mas_centerX)?.setOffset(-kWidth/8*3)
//            make?.left.mas_equalTo()(self.contentView.mas_left)?.setOffset(kLeftDis)
            make?.width.mas_equalTo()(AutoGetWidth(width: 40))
        }
        
        iconImg.mas_makeConstraints { (make) in
            make?.centerY.mas_equalTo()(self.contentView.mas_centerY)
            make?.centerX.mas_equalTo()(contentView.mas_centerX)?.setOffset(-kWidth/8)
            make?.width.mas_equalTo()(AutoGetWidth(width: 45))
            make?.height.mas_equalTo()(AutoGetWidth(width: 45))
            
        }
        nameLable.mas_makeConstraints { (make) in
            make?.centerY.mas_equalTo()(self.contentView.mas_centerY)
            make?.centerX.mas_equalTo()(contentView.mas_centerX)?.setOffset(kWidth/8)
        }
        zanLable.mas_makeConstraints { (make) in
            make?.centerY.mas_equalTo()(self.contentView.mas_centerY)
            make?.centerX.mas_equalTo()(contentView.mas_centerX)?.setOffset(kWidth/8*3)

        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

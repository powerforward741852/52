//
//  QRWishPersonCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/15.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRWishPersonCell: UICollectionViewCell {
    
    lazy var iconImg : UIImageView = {
        let iconImg = UIImageView(frame:  CGRect(x: 0, y: 0, width: 36, height: 36))
        iconImg.image = UIImage(named: "CQIndexPersonDefault")
        iconImg.layer.cornerRadius = self.contentView.width/4
        iconImg.clipsToBounds = true
        return iconImg
    }()
   
    
    
    lazy var nameLable :UILabel = {
        let nameLable = UILabel(title: "xxx", textColor: UIColor.white, fontSize: 14)
        nameLable.numberOfLines = 1
        nameLable.textAlignment = .center
        return nameLable
    }()
    
    var model :CQDepartMentAttenceModel?{
        didSet{
             iconImg.sd_setImage(with: URL(string: model?.headImage ?? ""), placeholderImage: UIImage(named: "CQIndexPersonDefault"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
            nameLable.text = model?.realName
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentView.addSubview(iconImg)
        self.contentView.addSubview(nameLable)
       
        iconImg.mas_makeConstraints { (make) in
            make?.centerX.mas_equalTo()(self.contentView.mas_centerX)
           // make?.centerY.mas_equalTo()(self.contentView.mas_centerY)?.setOffset(-10)
            make?.top.mas_equalTo()(self.contentView.top)
            make?.width.mas_equalTo()(self.contentView.width/2)
            make?.height.mas_equalTo()(self.contentView.width/2)
            
        }
  
        nameLable.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(self.contentView.mas_left)
            make?.top.mas_equalTo()(self.iconImg.mas_bottom)?.setOffset(5)
            make?.right.mas_equalTo()(self.contentView.mas_right)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

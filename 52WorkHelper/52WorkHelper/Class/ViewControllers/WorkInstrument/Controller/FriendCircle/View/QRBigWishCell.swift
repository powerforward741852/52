//
//  QRBigWishCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/15.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRBigWishCell: UICollectionViewCell {
    
    weak var rootVc : QRBirthDayParterVC?
    
    lazy var iconImg : UIImageView = {
        let iconImg = UIImageView(frame:  CGRect(x: 0, y: 0, width: 36, height: 36))
        iconImg.image = UIImage(named: "tx")
        iconImg.layer.cornerRadius = kWidth/12
        iconImg.clipsToBounds = true
        return iconImg
    }()
    
    lazy var nameLable :UILabel = {
        let nameLable = UILabel(title: "小米", textColor: UIColor.colorWithHexString(hex: "#1b1b1b"), fontSize: 15)
        nameLable.numberOfLines = 1
        nameLable.textAlignment = .center
        return nameLable
    }()
    
    lazy var wishBut :UIButton = {
        let wishBut = UIButton(frame:  CGRect(x: 0, y: 0, width: 80, height: 28))
        //wishBut.setTitle("送祝福", for: UIControlState.normal)
       // wishBut.setTitleColor(UIColor.black, for: UIControlState.normal)
        wishBut.setBackgroundImage(UIImage(named: "zufu"), for: UIControlState.normal)
        wishBut.addTarget(self, action: #selector(sendWish), for: UIControlEvents.touchUpInside)
        return wishBut
    }()
    
    var model :CQDepartMentAttenceModel?{
        didSet{
            iconImg.sd_setImage(with: URL(string: model?.headImage ?? ""), placeholderImage: UIImage(named: "CQIndexPersonDefault"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
            nameLable.text = model?.realName
        }
        
    }
    
    lazy var selectImg : UIImageView = {
        let selectImg = UIImageView(frame:  CGRect(x: 0, y: 0, width: 19, height: 19))
        selectImg.image = UIImage(named: "MessageGroupNotSelect")
        //MessageGroupSelect  绿
        //MessageGroupNotSelect
        //        selectImg.layer.cornerRadius = self.contentView.width/4
        //        selectImg.clipsToBounds = true
        return selectImg
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(iconImg)
        self.contentView.addSubview(nameLable)
          self.contentView.addSubview(selectImg)
        self.contentView.addSubview(wishBut)
        iconImg.mas_makeConstraints { (make) in
            make?.centerX.mas_equalTo()(self.contentView.mas_centerX)
            make?.centerY.mas_equalTo()(self.contentView.mas_centerY)?.setOffset(AutoGetWidth(width: -kWidth/3/2/2)+AutoGetHeight(height: 10))
            make?.width.mas_equalTo()(kWidth/3/2)
            make?.height.mas_equalTo()(kWidth/3/2 )
            
        }
        nameLable.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(self.contentView.mas_left)
            make?.top.mas_equalTo()(self.iconImg.mas_bottom)?.setOffset(5)
            make?.right.mas_equalTo()(self.contentView.mas_right)
        }
      
        selectImg.mas_makeConstraints { (make) in
            make?.width.mas_equalTo()(19)
            make?.height.mas_equalTo()(19)
            make?.right.mas_equalTo()(self.iconImg.mas_right)?.setOffset(AutoGetHeight(height: 5))
            make?.bottom.mas_equalTo()(self.iconImg.mas_bottom)?.setOffset(AutoGetHeight(height: 5))
        }
        wishBut.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(self.nameLable.mas_bottom)?.setOffset(5)
             make?.centerX.mas_equalTo()(self.contentView.mas_centerX)
        }
    }
    
    @objc func sendWish(){
        let vc = QRSendWishVC()
       // vc.singleModel = model
        vc.dataModel = [model] as! [CQDepartMentAttenceModel]
        rootVc?.navigationController?.pushViewController(vc, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

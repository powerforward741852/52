//
//  GroupSettingCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/14.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class GroupSettingCell: UICollectionViewCell {
    lazy var img: UIImageView = {
        let img = UIImageView.init(frame: CGRect.init(x: (kHaveLeftWidth/5 - AutoGetWidth(width: 36))/2, y: AutoGetWidth(width: 9), width: AutoGetWidth(width: 36), height:  AutoGetWidth(width: 36)))
        img.image = UIImage.init(named: "")
        img.layer.cornerRadius = AutoGetWidth(width: 18)
        img.clipsToBounds = true
        return img
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: 0, y: self.img.bottom + AutoGetHeight(height: 7), width: kHaveLeftWidth/5, height: AutoGetHeight(height: 14)))
        nameLab.textAlignment = .center
        nameLab.textColor = UIColor.black
        nameLab.text = ""
        nameLab.font = UIFont.systemFont(ofSize: 14)
        return nameLab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.setup()
        
    }
    
    func setup()  {
        addSubview(self.img)
        addSubview(self.nameLab)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //定义模型属性
    var model: CQGroupSettingModel? {
        didSet {
            self.img.sd_setImage(with: URL(string: model?.headImage ?? "personDefaultIcon"), placeholderImage:UIImage.init(named: "personDefaultIcon") )
            self.nameLab.text = model?.realName
        }
    }
}

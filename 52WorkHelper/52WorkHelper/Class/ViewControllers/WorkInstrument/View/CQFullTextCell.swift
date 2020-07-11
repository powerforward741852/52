//
//  CQFullTextCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/9.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQFullTextCell: UICollectionViewCell {
    
    lazy var img: UIImageView = {
        let img = UIImageView.init(frame: CGRect.init(x: (kHaveLeftWidth/4 - AutoGetWidth(width: 36))/2, y: AutoGetHeight(height: 9), width: AutoGetWidth(width: 36), height: AutoGetWidth(width: 36)))
        img.layer.cornerRadius = AutoGetWidth(width: 18)
        img.clipsToBounds = true
        img.image = UIImage.init(named: "personDefaultIcon")
        return img
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: 0, y: self.img.bottom + AutoGetHeight(height: 7), width: kHaveLeftWidth/4, height: AutoGetHeight(height: 14)))
        nameLab.textAlignment = .center
        nameLab.textColor = kLyGrayColor
        nameLab.text = "李明"
        nameLab.font = kFontSize14
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
    var model: CQFullTextModel? {
        didSet {
            self.img.sd_setImage(with: URL(string: model?.headImage ?? "" ), placeholderImage:UIImage.init(named: "personDefaultIcon") )
            self.nameLab.text = model?.realName
        }
    }
    
}

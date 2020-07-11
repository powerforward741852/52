//
//  CQShareCollectionCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/5.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQShareCollectionCell: UICollectionViewCell {
    
    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView.init(frame: CGRect.init(x: (kWidth/4 - AutoGetWidth(width: 34))/2, y: AutoGetWidth(width: 5), width: AutoGetWidth(width: 34), height:AutoGetWidth(width: 34)))
        iconImg.image = UIImage.init(named: "personDefaultIcon")
        iconImg.layer.cornerRadius = AutoGetWidth(width: 17)
        iconImg.clipsToBounds = true
        return iconImg
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: 0, y: self.iconImg.bottom + AutoGetHeight(height: 5), width: kWidth/4, height: AutoGetHeight(height: 15)))
        nameLab.font = kFontSize15
        nameLab.textColor = UIColor.black
        nameLab.textAlignment = .center
        nameLab.text = "alien"
        return nameLab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.setup()
        
    }
    
    func setup()  {
        addSubview(self.iconImg)
        addSubview(self.nameLab)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

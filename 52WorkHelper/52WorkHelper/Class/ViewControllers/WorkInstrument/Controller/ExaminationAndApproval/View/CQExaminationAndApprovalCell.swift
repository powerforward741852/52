//
//  CQExaminationAndApprovalCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/28.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQExaminationAndApprovalCell: UICollectionViewCell {
    
    lazy var img: UIImageView = {
        let img = UIImageView.init(frame: CGRect.init(x: (kHaveLeftWidth/4 - AutoGetWidth(width: 40))/2, y: AutoGetWidth(width: 15), width: kHaveLeftWidth/4 - AutoGetWidth(width: 40), height: kHaveLeftWidth/4 - AutoGetWidth(width: 40)))
        img.image = UIImage.init(named: "")
        
        return img
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: 0, y: self.img.bottom + AutoGetHeight(height: 7), width: kHaveLeftWidth/4, height: AutoGetHeight(height: 11)))
        nameLab.textAlignment = .center
        nameLab.textColor = UIColor.colorWithHexString(hex: "#6a6a6a")
        nameLab.text = ""
        nameLab.font = UIFont.systemFont(ofSize: 11)
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
}

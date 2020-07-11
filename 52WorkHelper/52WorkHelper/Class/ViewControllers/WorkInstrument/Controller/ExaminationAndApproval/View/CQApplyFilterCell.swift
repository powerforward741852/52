//
//  CQApplyFilterCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/7/9.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQApplyFilterCell: UICollectionViewCell {
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: (kHaveLeftWidth - AutoGetWidth(width: 25))/3, height: AutoGetHeight(height: 30)))
        nameLab.textAlignment = .center
        nameLab.textColor = UIColor.black
        nameLab.text = "李明"
        nameLab.font = kFontSize13
        return nameLab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kfilterBackColor
        self.layer.cornerRadius = 3
        self.setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup()  {
        addSubview(self.nameLab)
    }
}

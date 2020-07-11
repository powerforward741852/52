//
//  QRfilterCell.swift
//  test
//
//  Created by 秦榕 on 2018/9/5.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit

class QRfilterCell: UICollectionViewCell {
    
    
    var label = UILabel()
    var isSelect :Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel.init(frame: self.bounds)
        label.textAlignment = NSTextAlignment.center
        self.addSubview(label)
        contentView.layer.cornerRadius = 4
        contentView.clipsToBounds = true
        label.textColor = UIColor.black
        contentView.backgroundColor = kfilterBackColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

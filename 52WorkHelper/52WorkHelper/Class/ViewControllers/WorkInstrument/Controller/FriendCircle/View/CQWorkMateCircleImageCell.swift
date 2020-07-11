//
//  CQWorkMateCircleImageCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/19.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQWorkMateCircleImageCell: UICollectionViewCell {
    
    lazy var img: UIImageView = {
        let img = UIImageView.init(frame: CGRect.init(x: AutoGetWidth(width: 0), y: AutoGetWidth(width: 0), width: self.frame.size.width, height: self.frame.size.width))
        img.image = UIImage.init(named: "personDefaultIcon")
        
        return img
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.setup()
        
    }
    
    func setup()  {
        addSubview(self.img)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

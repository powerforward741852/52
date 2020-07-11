//
//  CQWorkOutReasonCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/6.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQWorkOutReasonCell: UICollectionViewCell {
    
    lazy var img: UIImageView = {
        let img = UIImageView.init(frame: CGRect.init(x: 0, y: AutoGetWidth(width: 0), width: (kHaveLeftWidth - AutoGetWidth(width: 30))/3, height:(kHaveLeftWidth - AutoGetWidth(width: 30))/3))
        img.image = UIImage.init(named: "demo")
        
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

//
//  File.swift
//  test
//
//  Created by 秦榕 on 2018/9/5.
//  Copyright © 2018年 qq. All rights reserved.
//

import Foundation
import UIKit
class QRheadcell: UICollectionReusableView {
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label = UILabel(frame: CGRect(x: 15, y: 4, width: 150, height: 36))
        label.font = kFontSize17
        self.addSubview(label)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

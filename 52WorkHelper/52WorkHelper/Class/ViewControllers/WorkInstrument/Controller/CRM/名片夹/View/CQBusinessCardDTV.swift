//
//  CQBusinessCardDTV.swift
//  52WorkHelper
//
//  Created by chenqihang on 2019/1/14.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class CQBusinessCardDTV: UIView {

    var dataArray = [String]()
    var curTitle = ""
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: AutoGetWidth(width: 32) , y: 0, width: AutoGetWidth(width: 60), height:AutoGetHeight(height: 55)))
        nameLab.textColor = UIColor.colorWithHexString(hex: "#737373")
        nameLab.textAlignment = .left
        nameLab.font = kFontSize15
        return nameLab
    }()
    
    lazy var contentLab: UILabel = {
        let contentLab = UILabel.init(frame: CGRect.init(x:self.nameLab.right + AutoGetWidth(width: 22) , y: 0, width: AutoGetWidth(width: 200), height:AutoGetHeight(height: 55)))
        contentLab.textColor = UIColor.black
        contentLab.textAlignment = .left
        contentLab.font = kFontSize15
        return contentLab
    }()
    
    init(frame:CGRect,dataArray:[String],title:String) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.curTitle = title
        self.dataArray = dataArray
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp()  {
        
        self.addSubview(self.nameLab)
        self.nameLab.text = self.curTitle
        for i in 0..<self.dataArray.count{
            let contentLab = UILabel.init(frame: CGRect.init(x:self.nameLab.right + AutoGetWidth(width: 22) , y: CGFloat(i) * AutoGetHeight(height: 55), width: AutoGetWidth(width: 200), height:AutoGetHeight(height: 55)))
            contentLab.textColor = UIColor.black
            contentLab.textAlignment = .left
            contentLab.font = kFontSize15
            contentLab.text = self.dataArray[i]
            if (i != (self.dataArray.count - 1)) || (i != 0) {
                let lineV = UIView.init(frame: CGRect.init(x: AutoGetWidth(width: 114), y: AutoGetHeight(height: 55) * CGFloat(i) - 0.5, width: kWidth - AutoGetWidth(width: 114), height: 0.5))
                lineV.backgroundColor = kLineColor
                self.addSubview(lineV)
            }
            self.addSubview(contentLab)
        }
    }
    

}

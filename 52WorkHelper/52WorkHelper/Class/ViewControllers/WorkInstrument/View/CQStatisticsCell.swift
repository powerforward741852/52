//
//  CQStatisticsCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/4/27.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQStatisticsCell: UITableViewCell {

    lazy var dateLab: UILabel = {
        let dateLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 10), width: kWidth - AutoGetWidth(width: 30), height: AutoGetHeight(height: 15)))
        dateLab.text = "2018-04-24（星期二）18:00"
        dateLab.textAlignment = .left
        dateLab.textColor = UIColor.black
        dateLab.font = kFontSize15
        return dateLab
    }()
    
    lazy var descLab: UILabel = {
        let descLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.dateLab.bottom + AutoGetHeight(height: 8), width: kWidth - AutoGetWidth(width: 30), height: AutoGetHeight(height: 12)))
        descLab.text = "下班早退4小时"
        descLab.textAlignment = .left
        descLab.textColor = UIColor.colorWithHexString(hex: "#a0a0a0")
        descLab.font = kFontSize12
        return descLab
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = kProjectBgColor
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setUp()  {
        
        self.addSubview(self.dateLab)
        self.addSubview(self.descLab)
    }
}

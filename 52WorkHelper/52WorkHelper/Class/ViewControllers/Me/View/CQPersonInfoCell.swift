//
//  CQPersonInfoCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/3.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQPersonInfoCell: UITableViewCell {

    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kWidth/2, height: AutoGetHeight(height: 100)))
        nameLab.font = kFontSize15
        nameLab.textColor = UIColor.black
        nameLab.textAlignment = .left
        nameLab.text = "头像"
        return nameLab
    }()
    
    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 110), y: AutoGetHeight(height: 14), width: AutoGetWidth(width: 72), height: AutoGetWidth(width: 72)))
        iconImg.image = UIImage.init(named: "personDefaultIcon")
        iconImg.layer.cornerRadius = AutoGetWidth(width: 36)
        iconImg.clipsToBounds = true
        return iconImg
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        self.addSubview(self.nameLab)
        self.addSubview(self.iconImg)
    }
}

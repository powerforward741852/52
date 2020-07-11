//
//  CQTransferGroupCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/15.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQTransferGroupCell: UITableViewCell {

    
    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 7.5), width: AutoGetWidth(width: 40), height: AutoGetWidth(width: 40)))
        iconImg.image = UIImage.init(named: "personDefaultIcon")
        iconImg.layer.cornerRadius = AutoGetWidth(width: 20)
        iconImg.clipsToBounds = true
        return iconImg
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + kLeftDis, y: AutoGetHeight(height: 0), width: kWidth/2, height: AutoGetHeight(height: 55)))
        nameLab.text = "Alans"
        nameLab.textAlignment = .left
        nameLab.textColor = UIColor.black
        nameLab.font = kFontSize16
        return nameLab
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
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func setUp() {
        
        
        self.addSubview(iconImg)
        self.addSubview(nameLab)
    }
    
   
    
  
    
    //定义模型属性
    var model: CQGroupSettingModel? {
        didSet {
            self.iconImg.sd_setImage(with: URL(string: model?.headImage ?? ""), placeholderImage:UIImage.init(named: "personDefaultIcon") )
            self.nameLab.text = model?.realName
        }
    }
    
    
}

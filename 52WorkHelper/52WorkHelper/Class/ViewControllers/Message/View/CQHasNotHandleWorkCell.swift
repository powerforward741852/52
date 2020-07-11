//
//  CQHasNotHandleWorkCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/6.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQHasNotHandleWorkCell: UITableViewCell {

    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 10), width: AutoGetWidth(width: 44), height: AutoGetWidth(width: 44)))
        iconImg.image = UIImage.init(named: "personDefaultIcon")
        iconImg.layer.cornerRadius = AutoGetWidth(width: 22)
        iconImg.clipsToBounds = true
        return iconImg
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + kLeftDis, y: AutoGetHeight(height: 0), width: AutoGetWidth(width: 220), height: AutoGetHeight(height: 64)))
        nameLab.text = "Alans"
        nameLab.textAlignment = .left
        nameLab.textColor = UIColor.black
        nameLab.font = kFontSize16
        return nameLab
    }()
    
    lazy var timeLab: UILabel = {
        let timeLab = UILabel.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 100), y: AutoGetHeight(height: 18), width: AutoGetWidth(width: 85), height: AutoGetHeight(height: 64)))
        timeLab.text = "Alans"
        timeLab.textAlignment = .right
        timeLab.textColor = kLyGrayColor
        timeLab.font = kFontSize12
        return timeLab
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
        self.addSubview(self.timeLab)
    }
    
    //定义模型属性
    var model: CQHasNotHandleModel? {
        didSet {
            self.iconImg.sd_setImage(with: URL(string: model?.headImage ?? ""), placeholderImage:UIImage.init(named: "personDefaultIcon") )
            self.nameLab.text = model?.workName
            self.timeLab.text = model?.differTime
            
           
        }
    }

}

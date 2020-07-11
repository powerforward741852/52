//
//  CQNeedMeAgreeCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/28.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQNeedMeAgreeCell: UITableViewCell {

    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView.init(frame: CGRect.init(x: AutoGetWidth(width: 17), y: AutoGetWidth(width: 16.5), width: AutoGetWidth(width: 32), height:AutoGetWidth(width: 32)))
        iconImg.image = UIImage.init(named: "personDefaultIcon")
        iconImg.layer.cornerRadius = AutoGetWidth(width: 16)
        iconImg.clipsToBounds = true
        return iconImg
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 11), y: AutoGetHeight(height: 16.5), width: kHaveLeftWidth/3 * 2, height: AutoGetHeight(height: 15)))
        nameLab.font = kFontSize15
        nameLab.textColor = UIColor.black
        nameLab.textAlignment = .left
        nameLab.text = "小明的请假申请"
        return nameLab
    }()
    
    lazy var statusLab: UILabel = {
        let statusLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 11), y:self.nameLab.bottom + AutoGetHeight(height: 5), width: kHaveLeftWidth/3 * 2, height: AutoGetHeight(height: 12)))
        statusLab.font = kFontSize12
        statusLab.textColor = kColorRGB(r: 238, g: 167, b: 40)
        statusLab.textAlignment = .left
        statusLab.text = "待审批..."
        return statusLab
    }()
    
    lazy var timeLab: UILabel = {
        let timeLab = UILabel.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 151), y:AutoGetHeight(height: 0), width: AutoGetWidth(width: 136), height: AutoGetHeight(height: 65)))
        timeLab.font = kFontSize13
        timeLab.textColor = kLyGrayColor
        timeLab.textAlignment = .right
        timeLab.text = "15:00"
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

    func setUp()  {
        self.addSubview(self.iconImg)
        self.addSubview(self.nameLab)
        self.addSubview(self.statusLab)
        self.addSubview(self.timeLab)
    }
    
    
    //定义模型属性
    var model: CQNeedMeAgreeModel? {
        didSet {
            self.iconImg.sd_setImage(with: URL(string: model?.headImage ?? ""), placeholderImage:UIImage.init(named: "personDefaultIcon") )
            self.nameLab.text = model?.nameApply
            self.statusLab.text = model?.approvalResultDesc
            
            let str = model!.updateDate as NSString
            let subStr = str.replacingOccurrences(of: "-", with: ".") as NSString
            let finalStr = subStr.substring(with: NSRange.init(location: 0, length: 16))
            self.timeLab.text = finalStr
        }
    }
    
}

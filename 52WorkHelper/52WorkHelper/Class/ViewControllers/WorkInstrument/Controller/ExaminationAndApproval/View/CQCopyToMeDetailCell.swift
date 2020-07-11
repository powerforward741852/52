//
//  CQCopyToMeDetailCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/20.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQCopyToMeDetailCell: UITableViewCell {

    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView.init(frame: CGRect.init(x: AutoGetWidth(width: 15), y: AutoGetWidth(width: 20), width: AutoGetWidth(width: 32), height:AutoGetWidth(width: 32)))
        iconImg.image = UIImage.init(named: "personDefaultIcon")
        iconImg.layer.cornerRadius = AutoGetWidth(width: 16)
        iconImg.clipsToBounds = true
        return iconImg
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView.init(frame: CGRect.init(x: AutoGetWidth(width: 30.5), y: AutoGetHeight(height: 4), width: AutoGetWidth(width: 1), height: AutoGetHeight(height: 14)))
        lineView.backgroundColor = kLyGrayColor
        return lineView
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 11), y: AutoGetHeight(height: 20), width: AutoGetWidth(width: 75), height: AutoGetHeight(height: 32)))
        nameLab.font = kFontSize15
        nameLab.textColor = UIColor.black
        nameLab.textAlignment = .left
        nameLab.text = "小明"
        return nameLab
    }()
    
    lazy var statueLab: UILabel = {
        let statueLab = UILabel.init(frame: CGRect.init(x: self.nameLab.right + AutoGetWidth(width: 11), y: AutoGetHeight(height: 20), width: AutoGetWidth(width: 140), height: AutoGetHeight(height: 32)))
        statueLab.font = kFontSize15
        statueLab.textColor = UIColor.black
        statueLab.textAlignment = .left
        statueLab.text = "已同意"
        return statueLab
    }()
    
    lazy var timeLab: UILabel = {
        let timeLab = UILabel.init(frame: CGRect.init(x: kWidth/2, y: AutoGetHeight(height: 20), width: kWidth/2 - kLeftDis, height: AutoGetHeight(height: 32)))
        timeLab.font = kFontSize15
        timeLab.textColor = kLyGrayColor
        timeLab.textAlignment = .right
        timeLab.text = "2018-05-06"
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
        self.addSubview(self.lineView)
        self.addSubview(self.nameLab)
        self.addSubview(self.statueLab)
        self.addSubview(self.timeLab)
    }
    
    //定义模型属性
    var model: CQCopyToMeApproverlistModel? {
        didSet {
            self.iconImg.sd_setImage(with: URL(string: model?.headImage ?? "" ), placeholderImage:UIImage.init(named: "personDefaultIcon") )
            self.nameLab.text = model?.realName
            self.statueLab.text = model?.approvalResult
            if model?.approvalResult == "等待我审批"{
                self.statueLab.textColor = kGoldYellowColor
            }
            self.timeLab.text = model?.approveTime
        }
    }
}

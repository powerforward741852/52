//
//  QRAddressBookCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/10/25.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRAddressBookCell: UITableViewCell {
    
    var selectStatus:Bool = false
    
    lazy var selectBtn: UIImageView = {
        let selectBtn = UIImageView()
        selectBtn.frame = CGRect.init(x: AutoGetWidth(width: 15), y: AutoGetHeight(height: 55)/3, width: AutoGetWidth(width: 55)/3, height: AutoGetHeight(height: 55)/3)
       // selectBtn.setImage(UIImage.init(named: ""), for: .normal)
       // selectBtn.addTarget(self, action: #selector(selectUser(sender:)), for: .touchUpInside)
        selectBtn.isHidden = true
        return selectBtn
    }()
    
    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 7.5), width: AutoGetWidth(width: 40), height: AutoGetWidth(width: 40)))
        iconImg.image = UIImage.init(named: "personDefaultIcon")
        iconImg.layer.cornerRadius = AutoGetWidth(width: 20)
        iconImg.clipsToBounds = true
        return iconImg
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + kLeftDis, y: AutoGetHeight(height: 11), width: kWidth/2, height: AutoGetHeight(height: 16)))
        nameLab.text = "Alans"
        nameLab.textAlignment = .left
        nameLab.textColor = UIColor.black
        nameLab.font = kFontSize16
        return nameLab
    }()
    
    lazy var jobLab: UILabel = {
        let jobLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + kLeftDis, y:self.nameLab.bottom + AutoGetHeight(height: 5), width: kWidth/2, height: AutoGetHeight(height: 12)))
        jobLab.text = "战略研发部"
        jobLab.textAlignment = .left
        jobLab.textColor = kLyGrayColor
        jobLab.font = kFontSize12
        return jobLab
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if selectStatus == true{
            self.selectBtn.image = UIImage(named: "MessageGroupSelect")
        }else{
            self.selectBtn.image = UIImage.init(named: "MessageGroupNotSelect")
        }
    }
    
    func setUp() {
        self.addSubview(selectBtn)
        self.addSubview(iconImg)
        self.addSubview(nameLab)
        self.addSubview(jobLab)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUp()
    }
    
    //定义模型属性
    var model: CQDepartMentUserListModel? {
        didSet {
            self.iconImg.sd_setImage(with: URL(string: model?.headImage ?? ""), placeholderImage:UIImage.init(named: "personDefaultIcon") )
            self.nameLab.text = model?.realName
            self.jobLab.text = model?.positionName//model?.departmentName
        }
    }
    
    //定义模型属性
    var contactModel: CQTopContactModel? {
        didSet {
            self.iconImg.sd_setImage(with: URL(string: model?.headImage ?? ""), placeholderImage:UIImage.init(named: "personDefaultIcon") )
            self.nameLab.text = model?.realName
            self.jobLab.text = model?.positionName
        }
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

}

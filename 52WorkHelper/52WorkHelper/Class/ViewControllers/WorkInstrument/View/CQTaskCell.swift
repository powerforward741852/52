//
//  CQTaskCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/29.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQTaskCell: UITableViewCell {

    lazy var img: UIImageView = {
        let img = UIImageView.init(frame: CGRect.init(x: kLeftDis , y: AutoGetHeight(height: 17.5), width: AutoGetWidth(width: 36), height: AutoGetWidth(width: 36)))
        img.image = UIImage.init(named: "personDefaultIcon")
        img.layer.cornerRadius = AutoGetWidth(width: 18)
        img.clipsToBounds = true
        return img
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: self.img.right + AutoGetWidth(width: 10), y:  AutoGetHeight(height: 19), width: kWidth/2, height: AutoGetHeight(height: 15)))
        nameLab.textAlignment = .left
        nameLab.textColor = UIColor.black
        nameLab.text = "李明"
        nameLab.font = kFontSize15
        return nameLab
    }()
    
    lazy var timeLab: UILabel = {
        let timeLab = UILabel.init(frame: CGRect.init(x: self.img.right + AutoGetWidth(width: 10), y:self.nameLab.bottom +  AutoGetHeight(height: 7), width: kWidth/2, height: AutoGetHeight(height: 11)))
        timeLab.textAlignment = .left
        timeLab.textColor = kLyGrayColor
        timeLab.text = "李明"
        timeLab.font = kFontSize11
        return timeLab
    }()
    
    lazy var statusImg: UIImageView = {
        let statusImg = UIImageView.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 36), y: (AutoGetHeight(height: 75 - AutoGetWidth(width: 21)))/2, width: AutoGetWidth(width: 21), height: AutoGetWidth(width: 21)))
        statusImg.layer.cornerRadius = AutoGetWidth(width: 10.5)
        statusImg.clipsToBounds = true
        
        return statusImg
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    func setup()  {
        addSubview(self.img)
        addSubview(self.nameLab)
        addSubview(self.timeLab)
        addSubview(self.statusImg)
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
    
    //定义模型属性
    var model: CQTaskModel? {
        didSet {
            self.img.sd_setImage(with: URL(string: model?.createUserHeadImage ?? "" ), placeholderImage:UIImage.init(named: "personDefaultIcon") )
            self.nameLab.text = model?.taskName
            self.timeLab.text = model?.deadLine
            
            if "1" == model?.priorityLevel{
                statusImg.image = UIImage.init(named: "TaskSerrier")
            }else if "2" == model?.priorityLevel{
                statusImg.image = UIImage.init(named: "TaskSoSo")
            }
        }
    }

}

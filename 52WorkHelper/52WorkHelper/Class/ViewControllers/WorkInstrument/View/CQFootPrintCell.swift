//
//  CQFootPrintCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/4/27.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQFootPrintCell: UITableViewCell {

    lazy var timeLab: UILabel = {
        let timeLab = UILabel.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 15), width: AutoGetWidth(width: 95), height: AutoGetHeight(height: 20)))
        timeLab.font = kFontBoldSize20
        timeLab.textColor = UIColor.black
        timeLab.text = "09:43"
        timeLab.textAlignment = .center
        return timeLab
    }()
    
    lazy var wayForSignLab: UILabel = {
        let wayForSignLab = UILabel.init(frame: CGRect.init(x: self.timeLab.right, y: AutoGetHeight(height: 17.5), width: kWidth/2, height: AutoGetHeight(height: 15)))
        wayForSignLab.font = kFontSize15
        wayForSignLab.textColor = UIColor.black
        wayForSignLab.text = "外勤签到"
        wayForSignLab.textAlignment = .left
        return wayForSignLab
    }()
    
    lazy var locationImg: UIImageView = {
        let locationImg = UIImageView.init(frame: CGRect.init(x: self.timeLab.right , y: self.wayForSignLab.bottom + AutoGetHeight(height: 10), width: AutoGetWidth(width: 11), height: AutoGetHeight(height: 13.5)))
        locationImg.image = UIImage.init(named: "footPrintLocation")
        return locationImg
    }()
    
    lazy var locationLab: UILabel = {
        let locationLab = UILabel.init(frame: CGRect.init(x: self.locationImg.right + AutoGetWidth(width: 8), y: self.wayForSignLab.bottom + AutoGetHeight(height: 10), width: kWidth - AutoGetWidth(width: 129), height: AutoGetHeight(height: 14)))
        locationLab.font = kFontSize14
        locationLab.textColor = kLyGrayColor
        locationLab.text = "厦门市湖里区金山街道万达广场"
        locationLab.textAlignment = .left
        return locationLab
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
        self.backgroundColor = UIColor.white
        self.addSubview(self.timeLab)
        self.addSubview(self.wayForSignLab)
        self.addSubview(self.locationImg)
        self.addSubview(self.locationLab)
    }
    
    //定义模型属性
    var model: CQFieldPersonalModel? {
        didSet {
            self.timeLab.text = (model!.punchTime as NSString).substring(with: NSRange.init(location: 0, length: 5))
            self.wayForSignLab.text = model?.punchMsg
            self.locationLab.text = model?.addressRemark
        }
    }


}

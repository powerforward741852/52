//
//  CQScheduleCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/10.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQScheduleCell: UITableViewCell {

    lazy var startTimeLab: UILabel = {
        let startTimeLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 18), width: AutoGetWidth(width: 82), height: AutoGetHeight(height: 20)))
        startTimeLab.font = kFontSize17
        startTimeLab.textColor = UIColor.black
        startTimeLab.textAlignment = .left
        startTimeLab.text = "10:11"
        return startTimeLab
    }()
    
    lazy var detailLab: UILabel = {
        let detailLab = UILabel.init(frame: CGRect.init(x: self.startTimeLab.right, y: AutoGetHeight(height: 18), width: kWidth - AutoGetWidth(width: 310)  , height: AutoGetHeight(height: 15)))
        detailLab.font = kFontSize15
        detailLab.textColor = UIColor.black
        detailLab.textAlignment = .left
        detailLab.text = "见客户"
        return detailLab
    }()
    
    lazy var contentLab: UILabel = {
        let contentLab = UILabel.init(frame: CGRect.init(x: self.startTimeLab.right, y:self.startTimeLab.bottom + AutoGetHeight(height: 9), width: kWidth - AutoGetWidth(width: 112)  , height: AutoGetHeight(height: 13)))
        contentLab.font = kFontSize13
        contentLab.textColor = kLyGrayColor
        contentLab.textAlignment = .left
        contentLab.text = "见客户"
        return contentLab
    }()
    
    lazy var statueLab: UILabel = {
        let statueLab = UILabel.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 65), y: AutoGetHeight(height: 18), width: AutoGetWidth(width: 50)  , height: AutoGetHeight(height: 15)))
        statueLab.font = kFontSize12
        statueLab.textColor = kLightBlueColor
        statueLab.layer.borderColor = kLightBlueColor.cgColor
        statueLab.layer.borderWidth = 1
        statueLab.layer.cornerRadius = 2
        statueLab.textAlignment = .center
        statueLab.text = "已完成"
        return statueLab
    }()
    
    lazy var endTimeLab: UILabel = {
        let endTimeLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.startTimeLab.bottom + AutoGetHeight(height: 11), width: AutoGetWidth(width: 97), height: AutoGetHeight(height: 15)))
        endTimeLab.font = kFontSize15
        endTimeLab.textColor = UIColor.black
        endTimeLab.textAlignment = .left
        endTimeLab.text = "10:41"
        return endTimeLab
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
        self.addSubview(self.startTimeLab)
        self.addSubview(self.detailLab)
        self.addSubview(self.contentLab)
        self.addSubview(self.statueLab)
        self.addSubview(self.endTimeLab)
    }
    
    //定义模型属性
    var model: CQScheduleModel? {
        didSet {
            self.startTimeLab.text = model?.startDate
            self.startTimeLab.sizeToFit()
//            var width = self.getTexWidth(textStr: (model?.planTitle)!, font: kFontSize15, height: AutoGetHeight(height: 15))
//            if width > (kWidth - AutoGetWidth(width: 197)) {
//                width = (kWidth - AutoGetWidth(width: 217))
//            }
//            self.detailLab.frame =  CGRect.init(x: self.startTimeLab.right, y: AutoGetHeight(height: 18), width: width , height: AutoGetHeight(height: 15))
            detailLab.numberOfLines = 1
            self.detailLab.text = model?.planTitle
            self.contentLab.text = model?.planContent
//            self.statueLab.frame = CGRect.init(x: self.detailLab.right + AutoGetWidth(width: 10), y: AutoGetHeight(height: 18), width: AutoGetWidth(width: 50)  , height: AutoGetHeight(height: 15))
            if model?.finishStatus == "1" {
                self.statueLab.text = "进行中"
                self.statueLab.layer.borderColor = kGoldYellowColor.cgColor
                self.statueLab.textColor = kGoldYellowColor
            }else if model?.finishStatus == "2"{
                self.statueLab.text = "未完成"
                self.statueLab.layer.borderColor = UIColor.red.cgColor
                self.statueLab.textColor = UIColor.red
            }else{
                statueLab.textColor = kLightBlueColor
                statueLab.layer.borderColor = kLightBlueColor.cgColor
                statueLab.text = "已完成"
            }
            
            self.endTimeLab.text = model?.endDate
        }
    }
    
    

}

extension CQScheduleCell{
    //计算宽度
    func getTexWidth(textStr:String,font:UIFont,height:CGFloat) -> CGFloat {
        
        let normalText: String = textStr
        
        let size = CGSize.init(width: 1000, height: height)
        
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context:nil).size
        
        return stringSize.width
        
    }
}

//
//  QRScheduleDetailCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/6/3.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class QRScheduleDetailCell: UITableViewCell {
    
    @IBOutlet weak var startTime: UILabel!
    
    @IBOutlet weak var endTime: UILabel!
    
   
    @IBOutlet weak var widthContant: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLbel: UILabel!
    
    @IBOutlet weak var doneBut: UILabel!
    //定义模型属性
    var model: CQScheduleModel? {
        didSet {
            if  (model?.startDate.count)! > 8{
                widthContant.constant = 130
            }else{
                widthContant.constant = 50
            }
            startTime.text = model?.startDate
            
           // startTime.sizeToFit()
            endTime.text = model?.endDate
            //endTime.sizeToFit()
            titleLabel.numberOfLines = 1
            titleLabel.text = model?.planTitle
            //titleLabel.sizeToFit()
            contentLbel.text = model?.planContent
          //  contentLbel.sizeToFit()
            
//            if (model?.finishStatus.count)! > 2{
//                if model?.finishStatus == "进行中" {
//                    self.doneBut.text = "进行中"
//                    self.doneBut.layer.borderColor = kGoldYellowColor.cgColor
//                    self.doneBut.textColor = kGoldYellowColor
//                }else if model?.finishStatus == "未完成"{
//                    self.doneBut.text = "未完成"
//                    self.doneBut.layer.borderColor =  UIColor.red.cgColor
//                    self.doneBut.textColor = UIColor.red
//                }else{
//                    self.doneBut.text = "已完成"
//                    self.doneBut.layer.borderColor =  kLightBlueColor.cgColor
//                    self.doneBut.textColor = kLightBlueColor
//                }
//            }else{
            
//             if model?.finishStatus == "1" {
            //                    self.doneBut.text = "进行中"
            //                    self.doneBut.layer.borderColor = kGoldYellowColor.cgColor
            //                    self.doneBut.textColor = kGoldYellowColor
//                            }else
                if model?.finishStatus == "1"{
                    self.doneBut.text = "未完成"
                    self.doneBut.layer.borderColor =  UIColor.red.cgColor
                    self.doneBut.textColor = UIColor.red
                }else{
                    self.doneBut.text = "已完成"
                    self.doneBut.layer.borderColor =  kLightBlueColor.cgColor
                    self.doneBut.textColor = kLightBlueColor
                    
                }
           // }
            
           
            
            
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        doneBut.font = kFontSize12
        doneBut.textColor = kLightBlueColor
        doneBut.layer.borderColor = kLightBlueColor.cgColor
        doneBut.layer.borderWidth = 1
        doneBut.layer.cornerRadius = 2
        doneBut.textAlignment = .center
        doneBut.text = "已完成"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

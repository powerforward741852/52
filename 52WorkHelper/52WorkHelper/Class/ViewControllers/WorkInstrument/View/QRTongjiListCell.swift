//
//  QRTongjiListCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/4/24.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRTongjiListCell: UITableViewCell {

    @IBOutlet weak var doneBut: UIButton!
    @IBOutlet weak var downLable: UILabel!
    @IBOutlet weak var upLable: UILabel!
    @IBOutlet weak var nameLab: UILabel!
    override func awakeFromNib() {
    
    super.awakeFromNib()
        downLable.textColor = UIColor.colorWithHexString(hex: "#8b8b8b")
        nameLab.font = kFontSize15
        upLable.font = kFontSize15
        downLable.font = kFontSize13
        doneBut.titleLabel?.font = kFontSize15
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    var model : CQMyCustomerModel?{
        didSet{
//            if model?.countSum == "0" {
//
//            }else{
//
//
//            }
            
            var start = model!.startDate
            var end = model!.endDate
            start!.removeLast(9)
            end!.removeLast(9)
            
            nameLab.text = model?.creater
            upLable.text = model?.title
            downLable.text = start! + "-" + end!
                
            doneBut.layer.cornerRadius = 15
            doneBut.clipsToBounds = true
            if model?.status == "1"{
                doneBut.setTitle("未完成", for: .normal)
                doneBut.setTitleColor(UIColor.colorWithHexString(hex: "#4b4b4b"), for: .normal)
                doneBut.backgroundColor = UIColor.colorWithHexString(hex: "#f2f2f2")
            }else{
                doneBut.setTitle("完成", for: .normal)
                doneBut.setTitleColor(kBlueC, for: .normal)
                doneBut.backgroundColor = UIColor.colorWithHexString(hex: "#f2f2f2")
                
            }
            
            
          
            
          
        }
    }
}

//
//  CQMyLeaveDTCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/9/12.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQMyLeaveDTCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var restLab: UILabel!
    @IBOutlet weak var ruleLab: UILabel!
    @IBOutlet weak var countWayLab: UILabel!
    @IBOutlet weak var payWayLab: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.white
        self.bgView.layer.shadowOpacity = 0.1;// 阴影透明度
        self.bgView.layer.shadowColor = UIColor.black.cgColor;// 阴影的颜色
        self.bgView.layer.shadowRadius = 1.3;// 阴影扩散的范围控制
        self.bgView.layer.shadowOffset  = CGSize(width: 0, height: 0)// 阴影的范围
        
        self.bgView.layer.borderColor = kProjectDarkBgColor.cgColor
        self.bgView.layer.borderWidth = 0.7
        self.bgView.layer.cornerRadius = 4
//        self.bgView.layer.cornerRadius = 2
//        self.bgView.layer.borderColor = kLineColor.cgColor
//        self.bgView.layer.borderWidth =  1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //定义模型属性
    var model: CQMyLeaveListModel? {
        didSet {
            var unitStr = ""
            if model?.vacationUnit == "1"{
                unitStr = "小时"
            }else if model?.vacationUnit == "2"{
                unitStr = "半天"
            }else if model?.vacationUnit == "3"{
                unitStr = "天"
            }
            self.restLab.text = (model?.text)! + ": 剩余" + (model?.balanceNumber)! + unitStr
            
            self.ruleLab.text = model?.vacationUnitName
            
            self.countWayLab.text = model?.timeModeName
            
            self.payWayLab.text = model?.balanceRuleName
        }
    }
    
}

//
//  CQDepartmentAttendanceCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/9/11.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQDepartmentAttendanceCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var departmentLab: UILabel!
    @IBOutlet weak var blueV: UIView!
    @IBOutlet weak var yellowView: UIView!
    @IBOutlet weak var bTimeLab: UILabel!
    @IBOutlet weak var eTimeLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = kProjectBgColor
        self.bgView.layer.cornerRadius = 2
        self.bgView.layer.borderColor = kLineColor.cgColor
        self.bgView.layer.borderWidth =  1
        self.blueV.layer.cornerRadius = 3
        self.yellowView.layer.cornerRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //定义模型属性
    var model: CQDepartMentAttenceModel? {
        didSet {
            self.departmentLab.text = model?.departmentName
            if (model?.amEnd.isEmpty)!{
                self.bTimeLab.text = (model!.amStart as NSString).substring(with: NSRange.init(location: 0, length: 5))
            }else{
                self.bTimeLab.text = (model!.amStart as NSString).substring(with: NSRange.init(location: 0, length: 5)) + "   上午下班 " + (model!.amEnd as NSString).substring(with: NSRange.init(location: 0, length: 5))
            }
            if (model?.pmEnd.isEmpty)!{
                self.eTimeLab.text =  (model!.pmStart as NSString).substring(with: NSRange.init(location: 0, length: 5)) + "   下午下班 " + (model!.pmEnd as NSString).substring(with: NSRange.init(location: 0, length: 5))
            }else{
                self.eTimeLab.text = (model!.pmEnd as NSString).substring(with: NSRange.init(location: 0, length: 5))
            }
            
        }
    }
    
}

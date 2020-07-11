//
//  CQLocationNearCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/9/26.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQLocationNearCell: UITableViewCell {

    
    @IBOutlet weak var iconImg: UIImageView!
    
    @IBOutlet weak var nameLab: UILabel!
    
    @IBOutlet weak var departLab: UILabel!
    
    @IBOutlet weak var distanceLab: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.iconImg.layer.cornerRadius = 36
        self.iconImg.clipsToBounds = true
        self.distanceLab.backgroundColor = kLineColor
        self.distanceLab.layer.cornerRadius = 3
        self.distanceLab.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //定义模型属性
    var model: CQDepartMentAttenceModel? {
        didSet {
            self.iconImg.sd_setImage(with: URL(string: model?.createUserHeadImage ?? "" ), placeholderImage:UIImage.init(named: "personDefaultIcon") )
            self.nameLab.text = "姓名: " + (model?.createUserRealName)!
            self.departLab.text = "部门: " + (model?.departmentName)! + " 职位: " + (model?.positionName)!
            self.distanceLab.text =  (model?.distance)! + "  更新时间: " + model!.updateDate
        }
    }
}

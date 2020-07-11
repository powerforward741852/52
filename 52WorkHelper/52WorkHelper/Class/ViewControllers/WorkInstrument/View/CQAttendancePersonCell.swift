//
//  CQAttendancePersonCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/9/11.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQAttendancePersonCell: UITableViewCell {

    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var statusImg: UIImageView!
    @IBOutlet weak var statusLab: UILabel!
    @IBOutlet weak var bTimeLab: UILabel!
    @IBOutlet weak var eTimeLab: UILabel!
    @IBOutlet weak var nameLab: UILabel!
    
    @IBOutlet weak var statusHeight: NSLayoutConstraint!
    
    @IBOutlet weak var statusTop: NSLayoutConstraint!
    lazy var lab: UILabel = {
        let lab = UILabel.init(frame:CGRect.init(x: 0, y: 0, width: 40, height: 18) )
        lab.text = ""
        lab.textAlignment = .center
        lab.textColor = UIColor.white
        lab.font = kFontSize10
        return lab
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.iconImg.layer.cornerRadius = 18
        self.iconImg.clipsToBounds = true
        self.statusImg.addSubview(self.lab)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //定义模型属性
    var model: CQDepartMentAttenceModel? {
        didSet {
            self.iconImg.sd_setImage(with: URL(string: model?.headImage ?? "" ), placeholderImage:UIImage.init(named: "personDefaultIcon") )
            self.statusLab.text = model?.typeNameRemark
            self.statusHeight.constant = 14
            self.statusTop.constant = 14
            if model?.typeName == "迟到"{
                self.statusImg.image = UIImage.init(named: "statusIcon0")
                self.statusImg.isHidden = false
                self.lab.text = "迟到"
            }
            else if model?.typeName == "旷工"{
                self.statusImg.image = UIImage.init(named: "statusIcon1")
                self.statusImg.isHidden = false
                self.lab.text = "旷工"
            }
            else if model?.typeName == "早退"{
                self.statusImg.image = UIImage.init(named: "statusIcon2")
                self.statusImg.isHidden = false
                self.lab.text = "早退"
            }
            else if model?.typeName == "未签"{
                self.statusImg.image = UIImage.init(named: "statusIcon3")
                self.statusImg.isHidden = false
                self.lab.text = "未签"
            }
            else if model?.typeName == "外出"{
                self.statusImg.image = UIImage.init(named: "statusIcon5")
                self.statusImg.isHidden = false
                self.lab.text = "外出"
            }
            else if model?.typeName == "出差"{
                self.statusImg.image = UIImage.init(named: "statusIcon6")
                self.statusImg.isHidden = false
                self.lab.text = "出差"
            }else if model!.leaveData.count > 0 {
                self.statusImg.image = UIImage.init(named: "statusIcon4")
                self.lab.text = "请假"
                let cou = model!.leaveData.count
                self.statusTop.constant = 0
                self.statusHeight.constant += CGFloat(cou * 40)
                
                for index in 0..<model!.leaveData.count{
                    let secModel = CQDepartMentAttenceModel(jsonData: model!.leaveData[index])
                    self.statusLab.text = secModel!.typeNameRemark + "\n" + secModel!.startTime + "\n"  + secModel!.endTime
                    self.statusLab.numberOfLines = 0
                }
            }
            else{
                self.statusImg.isHidden = true
            }
            
            
            
            if model?.typeName == "出差"{
                self.eTimeLab.text = "签到时间 " + (model?.signDate)!
            }else{
                if (model?.amEnd.isEmpty)!{
                    self.bTimeLab.text = "上班时间 " + (model?.amStart)!
                    if model!.amStart.isEmpty{
                        self.bTimeLab.isHidden = true
                    }else{
                        self.bTimeLab.isHidden = false
                    }
                }else{
                    self.bTimeLab.text = "上午上班 " + (model?.amStart)! + "   上午下班 " + (model?.amEnd)!
                }
                if (model?.pmStart.isEmpty)!{
                    self.eTimeLab.text = "下班时间 " + (model?.pmEnd)!
                    if model!.pmEnd.isEmpty{
                        self.eTimeLab.isHidden = true
                    }else{
                        self.eTimeLab.isHidden = false
                    }
                }else{
                    self.eTimeLab.text = "下午上班 " + (model?.pmStart)! + "   下午下班 " + (model?.pmEnd)!
                }
            }
            
//            if (model?.typeName.isEmpty)! {
//
//            }
            
            self.nameLab.text = model?.realName
            
            
            
        }
    }
}

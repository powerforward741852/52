//
//  NCQAttendancePersonCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/10/19.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit

class NCQAttendancePersonCell: UITableViewCell {
    
    var cellHeight:CGFloat = 25.0

    lazy var line1: UIView = {
        let line1 = UIView.init(frame: CGRect.init(x: AutoGetWidth(width: 39) - 1, y: 0, width: 2, height: AutoGetHeight(height: 25)))
        line1.backgroundColor = kLineColor
        return line1
    }()
    
    lazy var img: UIImageView = {
        let img = UIImageView.init(frame: CGRect.init(x: AutoGetWidth(width: 21) , y: self.line1.bottom + AutoGetHeight(height: 6), width: AutoGetWidth(width: 36), height: AutoGetWidth(width: 36)))
        img.image = UIImage.init(named: "personDefaultIcon")
        img.layer.cornerRadius = AutoGetWidth(width: 18)
        img.clipsToBounds = true
        return img
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: AutoGetWidth(width: 21), y:  self.img.bottom + AutoGetHeight(height: 6), width: AutoGetWidth(width: 36), height: AutoGetHeight(height: 11)))
        nameLab.textAlignment = .center
        nameLab.textColor = UIColor.black
        nameLab.text = "李明"
        nameLab.font = kFontSize11
        return nameLab
    }()
    
    lazy var line2: UIView = {
        let line2 = UIView.init(frame: CGRect.init(x: AutoGetWidth(width: 39) - 1, y: self.nameLab.bottom + AutoGetHeight(height: 6), width: 2, height: AutoGetHeight(height: 37)))
        line2.backgroundColor = kLineColor
        return line2
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    func setup()  {
        self.addSubview(self.line1)
        self.addSubview(self.img)
        self.addSubview(self.nameLab)
        self.addSubview(self.line2)
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

    func refreshCellWithModel(model:CQDepartMentAttenceModel?,index:IndexPath) -> CGFloat {
        
        for modelJson in (model?.statisticData)!{

            let statistModel = CQDepartMentAttenceModel(jsonData: modelJson)

            if !statistModel!.typeName.isEmpty{

                self.cellHeight += AutoGetHeight(height: 29)

            }


            if !statistModel!.amStart.isEmpty {
                self.cellHeight += AutoGetHeight(height: 20)
            }


            if !statistModel!.amEnd.isEmpty {
                self.cellHeight += AutoGetHeight(height: 35)
            }


            if !statistModel!.pmStart.isEmpty {
                self.cellHeight += AutoGetHeight(height: 20)
            }

            if !statistModel!.pmEnd.isEmpty {
                self.cellHeight += AutoGetHeight(height: 35)
            }
            
            if !statistModel!.startTime.isEmpty {
                self.cellHeight += AutoGetHeight(height: 20)
            }
            
            if !statistModel!.endTime.isEmpty {
                self.cellHeight += AutoGetHeight(height: 35)
            }

            if !statistModel!.signDate.isEmpty{
                self.cellHeight += AutoGetHeight(height: 20)
            }
            
        }

        self.cellHeight += 19

        if self.cellHeight > AutoGetHeight(height: 127){
            self.line2.frame = CGRect.init(x: AutoGetWidth(width: 39) - 1, y: self.nameLab.bottom + AutoGetHeight(height: 6), width: 2, height: self.cellHeight - AutoGetHeight(height: 90))
        }else{
            self.cellHeight = AutoGetHeight(height: 127)
        }

        
        
        return cellHeight
    }
    
    
    //定义模型属性
    var model: CQDepartMentAttenceModel? {
        didSet {
            self.img.sd_setImage(with: URL(string: model?.headImage ?? "" ), placeholderImage:UIImage.init(named: "personDefaultIcon") )
            
            self.nameLab.text = model?.realName
            
            for modelJson in (model?.statisticData)!{
                
                guard let statistModel = CQDepartMentAttenceModel(jsonData: modelJson) else {
                    return
                }
                
                if !statistModel.typeName.isEmpty{
                    let statusImg = UIImageView.init(frame: CGRect.init(x: self.img.right + AutoGetWidth(width: 16), y:self.cellHeight, width: AutoGetWidth(width: 40), height: AutoGetWidth(width: 18)))
                    self.addSubview(statusImg)
                    let lab = UILabel.init(frame:CGRect.init(x: 0, y: 0, width: 40, height: 18) )
                    lab.textAlignment = .center
                    lab.textColor = UIColor.white
                    lab.font = kFontSize10
                    statusImg.addSubview(lab)
                    
                    if statistModel.typeName == "迟到"{
                        statusImg.image = UIImage.init(named: "statusIcon0")
                        lab.text = "迟到"
                    }else if statistModel.typeName == "旷工"{
                        statusImg.image = UIImage.init(named: "statusIcon1")
                        lab.text = "旷工"
                    }
                    else if statistModel.typeName == "早退"{
                        statusImg.image = UIImage.init(named: "statusIcon2")
                        lab.text = "早退"
                    }
                    else if statistModel.typeName == "未签"{
                        statusImg.image = UIImage.init(named: "statusIcon3")
                        lab.text = "未签"
                    }
                    else if statistModel.typeName == "外出"{
                        statusImg.image = UIImage.init(named: "statusIcon5")
                        lab.text = "外出"
                    }
                    else if statistModel.typeName == "出差"{
                        statusImg.image = UIImage.init(named: "statusIcon6")
                        lab.text = "出差"
                    }else if statistModel.typeName == "请假" {
                        statusImg.image = UIImage.init(named: "statusIcon4")
                        lab.text = "请假"
                    }
                    
                    if !statistModel.typeNameRemark.isEmpty{
                        let statusLab = UILabel.init(frame: CGRect.init(x: statusImg.right + AutoGetWidth(width: 10), y:cellHeight + AutoGetHeight(height: 3), width: kWidth/3 * 2, height: AutoGetHeight(height: 12)))
                        statusLab.textAlignment = .left
                        statusLab.textColor = UIColor.black
                        statusLab.text = statistModel.typeNameRemark
                        statusLab.font = kFontSize12
                        self.addSubview(statusLab)
                    }
                    
                    self.cellHeight += AutoGetHeight(height: 29)
                
                }
                
                
                if !statistModel.signDate.isEmpty{
                    let amStartLab = UILabel.init(frame: CGRect.init(x: self.img.right + AutoGetWidth(width: 16), y:cellHeight , width: (kWidth - AutoGetWidth(width: 94)), height: AutoGetHeight(height: 14)))
                    amStartLab.textAlignment = .left
                    amStartLab.textColor = UIColor.black
                    amStartLab.text = "出差签到: " +  statistModel.signDate
                    amStartLab.font = kFontSize14
                    self.addSubview(amStartLab)
                    
                    self.cellHeight += AutoGetHeight(height: 20)
                }
                
                
                
                if !statistModel.amStart.isEmpty {
                    let amStartLab = UILabel.init(frame: CGRect.init(x: self.img.right + AutoGetWidth(width: 16), y:cellHeight , width: (kWidth - AutoGetWidth(width: 94)), height: AutoGetHeight(height: 14)))
                    amStartLab.textAlignment = .left
                    amStartLab.textColor = UIColor.black
                    amStartLab.text = "上午上班: " +  statistModel.amStart
                    amStartLab.font = kFontSize14
                    self.addSubview(amStartLab)
                    
                    self.cellHeight += AutoGetHeight(height: 20)
                }
                
                
                if !statistModel.amEnd.isEmpty {
                    let amEndLab = UILabel.init(frame: CGRect.init(x: self.img.right + AutoGetWidth(width: 16), y:cellHeight , width: (kWidth - AutoGetWidth(width: 94)), height: AutoGetHeight(height: 14)))
                    amEndLab.textAlignment = .left
                    amEndLab.textColor = UIColor.black
                    amEndLab.text = "上午下班: " +  statistModel.amEnd
                    amEndLab.font = kFontSize14
                    self.addSubview(amEndLab)
                    
                    self.cellHeight += AutoGetHeight(height: 35)
                }
                
                
                if !statistModel.pmStart.isEmpty {
                    let pmStartLab = UILabel.init(frame: CGRect.init(x: self.img.right + AutoGetWidth(width: 16), y:cellHeight , width: (kWidth - AutoGetWidth(width: 94)), height: AutoGetHeight(height: 14)))
                    pmStartLab.textAlignment = .left
                    pmStartLab.textColor = UIColor.black
                    pmStartLab.text = "下午上班: " +  statistModel.pmStart
                    pmStartLab.font = kFontSize14
                    self.addSubview(pmStartLab)
                    
                    self.cellHeight += AutoGetHeight(height: 20)
                }
                
                if !statistModel.pmEnd.isEmpty {
                    let pmEndLab = UILabel.init(frame: CGRect.init(x: self.img.right + AutoGetWidth(width: 16), y:cellHeight , width: (kWidth - AutoGetWidth(width: 94)), height: AutoGetHeight(height: 14)))
                    pmEndLab.textAlignment = .left
                    pmEndLab.textColor = UIColor.black
                    pmEndLab.text = "下午下班: " +  statistModel.pmEnd
                    pmEndLab.font = kFontSize14
                    self.addSubview(pmEndLab)
                    
                    self.cellHeight += AutoGetHeight(height: 35)
                }
                
                if !statistModel.startTime.isEmpty {
                    let pmStartLab = UILabel.init(frame: CGRect.init(x: self.img.right + AutoGetWidth(width: 16), y:cellHeight , width: (kWidth - AutoGetWidth(width: 94)), height: AutoGetHeight(height: 14)))
                    pmStartLab.textAlignment = .left
                    pmStartLab.textColor = UIColor.black
                    pmStartLab.text = "开始时间: " +  statistModel.startTime
                    pmStartLab.font = kFontSize14
                    self.addSubview(pmStartLab)
                    
                    self.cellHeight += AutoGetHeight(height: 20)
                }
                
                if !statistModel.endTime.isEmpty {
                    let pmEndLab = UILabel.init(frame: CGRect.init(x: self.img.right + AutoGetWidth(width: 16), y:cellHeight , width: (kWidth - AutoGetWidth(width: 94)), height: AutoGetHeight(height: 14)))
                    pmEndLab.textAlignment = .left
                    pmEndLab.textColor = UIColor.black
                    pmEndLab.text = "结束时间: " +  statistModel.endTime
                    pmEndLab.font = kFontSize14
                    self.addSubview(pmEndLab)
                    
                    self.cellHeight += AutoGetHeight(height: 35)
                }
                
                
            }
            
            self.cellHeight += 19
            
            if self.cellHeight > AutoGetHeight(height: 127){
                self.line2.frame = CGRect.init(x: AutoGetWidth(width: 39) - 1, y: self.nameLab.bottom + AutoGetHeight(height: 6), width: 2, height: self.cellHeight - AutoGetHeight(height: 90))
            }else{
                self.cellHeight = AutoGetHeight(height: 127)
            }
            
        }
    }
}

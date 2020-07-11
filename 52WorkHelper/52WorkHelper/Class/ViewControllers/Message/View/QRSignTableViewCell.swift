//
//  QRSignTableViewCell.swift
//  test
//
//  Created by 秦榕 on 2018/12/17.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit

class QRSignTableViewCell: UITableViewCell {
    
    var rootVc : QRSignVC?
    var dateStr = ""
    lazy var PicView :UIImageView = {
        let PicView =  UIImageView()
        PicView.image = UIImage(named: "sj")
        return PicView
    }()
    
    lazy var Morning : UILabel = {
        let Morning = UILabel()
        Morning.textAlignment = .center
        Morning.text = ""
        Morning.textColor = UIColor.black
        Morning.font = UIFont.systemFont(ofSize: 16)
        Morning.sizeToFit()
        return Morning
    }()
    
    lazy var dataBgView : UIView = {
        let dataBgView =  UIView()
        dataBgView.backgroundColor = kSignBlueColor
        return dataBgView
    }()
    lazy var dotView : UIView = {
        let dotView =  UIView()
        dotView.backgroundColor = kSignGreyTextColor
        return dotView
    }()
    lazy var MorningTime : UILabel = {
        let MorningTime = UILabel()
        MorningTime.textAlignment = .center
        MorningTime.text = "上班时间08:30"
        MorningTime.textColor = kSignGreyTextColor
        MorningTime.font = UIFont.systemFont(ofSize: 14)
        MorningTime.sizeToFit()
        return MorningTime
    }()
    lazy var SignTime : UILabel = {
        let MorningTime = UILabel()
        MorningTime.textAlignment = .center
        MorningTime.text = "打卡时间08:30"
        MorningTime.textColor = UIColor.black
        MorningTime.font = UIFont.systemFont(ofSize: 16)
        MorningTime.sizeToFit()
        return MorningTime
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(PicView)
        contentView.addSubview(Morning)
        contentView.addSubview(dataBgView)
        dataBgView.addSubview(dotView)
        dataBgView.addSubview(MorningTime)
        dataBgView.addSubview(SignTime)
        setUpUi()
        
    }
    
    func setUpUi(){
        
        PicView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)?.setOffset(AutoGetWidth(width: 15))
            make?.top.mas_equalTo()(contentView)?.setOffset(AutoGetHeight(height: 10))
            make?.width.mas_equalTo()(AutoGetWidth(width: 20))
            make?.height.mas_equalTo()(AutoGetWidth(width: 20))
           
        }
        Morning.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(PicView.mas_right)?.setOffset(AutoGetWidth(width: 10))
            make?.centerY.mas_equalTo()(PicView.mas_centerY)
            
        }
        dataBgView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)?.setOffset(AutoGetWidth(width: 15))
            make?.right.mas_equalTo()(contentView)?.setOffset(-AutoGetWidth(width: 15))
       //     make?.height.mas_equalTo()(70)
            make?.top.mas_equalTo()(Morning.mas_bottom)?.setOffset(10)
            make?.bottom.mas_equalTo()(contentView.mas_bottom)?.setOffset(-10)
        }
       
        MorningTime.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(dataBgView)?.setOffset(14)
            make?.left.mas_equalTo()(dataBgView)?.setOffset(20)
          //  make?.centerY.mas_equalTo()(dotView.mas_centerY)
        }
        dotView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(dataBgView)?.setOffset(7.5)
            make?.centerY.mas_equalTo()(MorningTime)
            make?.width.mas_equalTo()(5)
            make?.height.mas_equalTo()(5)
            dotView.layer.cornerRadius = 2.5
            
        }
        SignTime.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(MorningTime)
            make?.top.mas_equalTo()(MorningTime.mas_bottom)?.setOffset(20)
            make?.bottom.mas_equalTo()(dataBgView.mas_bottom)?.setOffset(-10)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //定义模型属性
    var model: CQCheckInstanceModel? {
        didSet {
            dataBgView.isUserInteractionEnabled = false
           
            var str = ""
            if  (model?.attendanceTime.count)! < 7{
                str = ""
            }else{
                str = "打卡时间: " + (model?.attendanceTime)!
            }
            //富文本处理
            let attributeText = NSMutableAttributedString.init(string: str)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            paragraphStyle.alignment = .left
            attributeText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributeText.length))
            //异常处理
            if let xx = model?.abnormalDesc {
                if xx == "旷工"{
                    let textAttachment = NSTextAttachment()
                    textAttachment.image = UIImage(named: "skg")
                    textAttachment.bounds =  CGRect(x: 0, y: -3, width: 40, height: 17)
                    let attributeString = NSAttributedString(attachment: textAttachment)
                    let attributeSpace = NSMutableAttributedString.init(string: "  " )
                    attributeText.append(attributeSpace)
                    attributeText.append(attributeString)
                    SignTime.attributedText = attributeText
                    
                }else if xx == "迟到" {
                    let textAttachment = NSTextAttachment()
                    textAttachment.image = UIImage(named: "scd")
                    textAttachment.bounds =  CGRect(x: 0, y: -3, width: 40, height: 17)
                    let attributeString = NSAttributedString(attachment: textAttachment)
                    let attributeSpace = NSMutableAttributedString.init(string: "  " )
                    attributeText.append(attributeSpace)
                    attributeText.append(attributeString)
                    SignTime.attributedText = attributeText
                }else if xx == "早退" {
                    let textAttachment = NSTextAttachment()
                    textAttachment.image = UIImage(named: "szt")
                    textAttachment.bounds =  CGRect(x: 0, y: -3, width: 40, height: 17)
                    let attributeString = NSAttributedString(attachment: textAttachment)
                    let attributeSpace = NSMutableAttributedString.init(string: "  " )
                    attributeText.append(attributeSpace)
                    attributeText.append(attributeString)
                    SignTime.attributedText = attributeText
                }else if xx == "缺卡" {
                    let bukaText = NSMutableAttributedString.init(string: "补卡 >")
                    let tintcolorDict = [NSAttributedStringKey.foregroundColor:kSignBlueTextColor]
                    bukaText.addAttributes(tintcolorDict, range: NSMakeRange(0, bukaText.length))
                    let textAttachment = NSTextAttachment()
                    textAttachment.image = UIImage(named: "sqk")
                    textAttachment.bounds =  CGRect(x: 0, y: -3, width: 40, height: 17)
                    let attributeString = NSAttributedString(attachment: textAttachment)
                    let attributeSpace = NSMutableAttributedString.init(string: "  " )
                    bukaText.append(attributeSpace)
                    bukaText.append(attributeString)
                    SignTime.attributedText = bukaText
                    
                    dataBgView.isUserInteractionEnabled = true
                    let ges = UITapGestureRecognizer(target: self, action: #selector(buka))
                    dataBgView.addGestureRecognizer(ges)
                }else{
                    SignTime.attributedText = attributeText
                }
                
                if  "缺勤" == model?.prompt {
                    
                    if true == model?.isModifyApply{
                        let bukaText = NSMutableAttributedString.init(string: "补卡 >")
                        let tintcolorDict = [NSAttributedStringKey.foregroundColor:kSignBlueTextColor]
                        bukaText.addAttributes(tintcolorDict, range: NSMakeRange(0, bukaText.length))
                        let textAttachment = NSTextAttachment()
                        textAttachment.image = UIImage(named: "sqk")
                        textAttachment.bounds =  CGRect(x: 0, y: -3, width: 40, height: 17)
                        let attributeString = NSAttributedString(attachment: textAttachment)
                        let attributeSpace = NSMutableAttributedString.init(string: "  " )
                        bukaText.append(attributeSpace)
                        bukaText.append(attributeString)
                        SignTime.attributedText = bukaText
                        
                        dataBgView.isUserInteractionEnabled = true
                        let ges = UITapGestureRecognizer(target: self, action: #selector(buka))
                        dataBgView.addGestureRecognizer(ges)
                        
                    }else{
                        let bukaText = NSMutableAttributedString.init(string: "已申请补卡")
                        let tintcolorDict = [NSAttributedStringKey.foregroundColor:UIColor.black]
                        bukaText.addAttributes(tintcolorDict, range: NSMakeRange(0, bukaText.length))
                        let textAttachment = NSTextAttachment()
                        textAttachment.image = UIImage(named: "sqk")
                        textAttachment.bounds =  CGRect(x: 0, y: -3, width: 40, height: 17)
                        let attributeString = NSAttributedString(attachment: textAttachment)
                        let attributeSpace = NSMutableAttributedString.init(string: "  " )
                        bukaText.append(attributeSpace)
                        bukaText.append(attributeString)
                        SignTime.attributedText = bukaText
                        
//                        dataBgView.isUserInteractionEnabled = true
//                        let ges = UITapGestureRecognizer(target: self, action: #selector(buka))
//                        dataBgView.addGestureRecognizer(ges)
                    }
                }else{
                    
                }
                
            }else{
               
                
            }
            
            
            
        }
    }
    @objc func buka(){
        print("补卡")
        let vc = NCQApprovelVC()
        vc.businessCode = "B_BK"
        vc.modifyTime = dateStr + " " + (model?.ruleTime)!
        rootVc!.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }

}

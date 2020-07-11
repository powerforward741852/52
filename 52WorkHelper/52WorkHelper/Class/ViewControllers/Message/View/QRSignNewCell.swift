//
//  QRSignNewCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/12/26.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol  QRSignNewCelldelegate : NSObjectProtocol{
    
    func signAction()
}
protocol  QRLocationNewCelldelegate : NSObjectProtocol {
    func locationUpdataAction()
    
}

class QRSignNewCell : UITableViewCell {
    //计时器
    var time : Timer?
    weak var rootVc : QRSignVC?
    var dateStr = ""
    weak var lDelegate:QRLocationNewCelldelegate?
    weak var sDelegate:QRSignNewCelldelegate?
    ////底部视图
    lazy var footView : UIView = {
        let footView = UIView(frame:  CGRect(x: kLeftDis, y:0, width: kHaveLeftWidth, height: AutoGetHeight(height: 230)))
        footView.addSubview(signBut)
        footView.addSubview(remarkLab)
        footView.addSubview(remarkImg)
        footView.addSubview(LocationBut)
        footView.addSubview(clockLab)
        return footView
    }()
    //签到按钮
    lazy var signBut : UIButton = {
        let signBut = UIButton(frame:  CGRect(x: (kWidth-AutoGetWidth(width: 170))/2, y: AutoGetHeight(height: 25), width: AutoGetWidth(width: 140), height: AutoGetWidth(width: 140)))
        signBut.setBackgroundImage(UIImage(named: "ann"), for: UIControlState.normal)
        signBut.setTitle("打卡", for: UIControlState.normal)
        signBut.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        signBut.titleEdgeInsets = UIEdgeInsets(top: -15, left: 0, bottom: 0, right: 0)
        signBut.addTarget(self, action: #selector(signClick), for: UIControlEvents.touchUpInside)
        return signBut
    }()
    //地址
    lazy var remarkLab : UILabel = {
        let remarkLab = UILabel()
        remarkLab.text = "未进入考勤范围"
        remarkLab.numberOfLines = 1
        remarkLab.textColor = UIColor.black
        remarkLab.font = UIFont.systemFont(ofSize: 13)
        remarkLab.textAlignment = .center
        return remarkLab
    }()
    
    //对称图片
    lazy var remarkImg : UIImageView = {
        let remarkImg = UIImageView(frame:  CGRect(x: kWidth-AutoGetWidth(width: 15)-6.6, y: (AutoGetWidth(width: 55)-12)/2, width: 12, height: 12))
        remarkImg.image = UIImage(named: "c")
        return remarkImg
    }()
    //定位but
    lazy var LocationBut : UIButton = {
        let LocationBut = UIButton(frame:  CGRect(x: kWidth/3, y: AutoGetWidth(width: 25), width: 40, height: kWidth/3))
        LocationBut.setTitle("去重新定位", for: UIControlState.normal)
        LocationBut.addTarget(self, action: #selector(LocationClick), for: UIControlEvents.touchUpInside)
        LocationBut.setTitleColor(kSignLocationbtnColor, for: UIControlState.normal)
        LocationBut.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        LocationBut.sizeToFit()
        return LocationBut
    }()
    
    //时钟Lab
    lazy var clockLab : UILabel = {
        let clockLab = UILabel()
        clockLab.text = "  "
        clockLab.numberOfLines = 1
        clockLab.textColor = UIColor.white
        clockLab.font = UIFont.systemFont(ofSize: 14)
        clockLab.textAlignment = .center
        clockLab.sizeToFit()
        return clockLab
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

        contentView.addSubview(dataBgView)
        dataBgView.addSubview(dotView)
        dataBgView.addSubview(MorningTime)
        dataBgView.addSubview(SignTime)
        contentView.addSubview(footView)
        setUpUi()
        
    }
    
    func setUpUi(){
        

        dataBgView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)?.setOffset(AutoGetWidth(width: 15))
            make?.right.mas_equalTo()(contentView)?.setOffset(-AutoGetWidth(width: 15))
            make?.top.mas_equalTo()(contentView)?.setOffset(10)
            // make?.bottom.mas_equalTo()(contentView.mas_bottom)?.setOffset(0)
        }
        
        MorningTime.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(dataBgView)?.setOffset(14)
            make?.left.mas_equalTo()(dataBgView)?.setOffset(20)
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
            make?.top.mas_equalTo()(MorningTime.mas_bottom)?.setOffset(15)
            make?.bottom.mas_equalTo()(dataBgView.mas_bottom)?.setOffset(-10)
        }
        footView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(dataBgView.mas_left)
            make?.right.mas_equalTo()(dataBgView.mas_right)
            make?.height.mas_equalTo()(AutoGetHeight(height: 215))
            make?.top.mas_equalTo()(dataBgView.mas_bottom)?.setOffset(0)
            make?.bottom.mas_equalTo()(contentView.mas_bottom)?.setOffset(-10)
        }
        
        
        remarkLab.mas_makeConstraints { (make) in
            make?.centerX.mas_equalTo()(footView)?.setOffset(-23)
            make?.top.mas_equalTo()(signBut.mas_bottom)?.setOffset(AutoGetHeight(height: 18))
            make?.width.lessThanOrEqualTo()(kWidth*0.6)
        }
        remarkImg.mas_makeConstraints { (make) in
            make?.centerY.mas_equalTo()(remarkLab)
            make?.right.mas_equalTo()(remarkLab.mas_left)?.setOffset(-4)
            make?.width.mas_equalTo()(12)
            make?.height.mas_equalTo()(12)
        }
        LocationBut.mas_makeConstraints { (make) in
            make?.centerY.mas_equalTo()(remarkLab)
            make?.left.mas_equalTo()(remarkLab.mas_right)
            
        }
        clockLab.mas_makeConstraints { (make) in
            make?.centerX.mas_equalTo()(signBut)
            make?.centerY.mas_equalTo()(signBut)?.setOffset(20)
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
                SignTime.mas_updateConstraints { (make) in
                    make?.top.mas_equalTo()(MorningTime.mas_bottom)?.setOffset(15)
                }
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
                    //1app 2面板机 3 2维码
 
                    if model?.sourceType == "1"{
                        
                    }else if model?.sourceType == "2"{
                        let textAttachment = NSTextAttachment()
                        textAttachment.image = UIImage(named: "sbdk")
                        textAttachment.bounds =  CGRect(x: 0, y: -3, width: 15, height: 15)
                        let attributeString = NSAttributedString(attachment: textAttachment)
                        let attributeSpace = NSMutableAttributedString.init(string: "  " )
                        attributeText.append(attributeSpace)
                        attributeText.append(attributeString)
                    }else if model?.sourceType == "3"{
                        
                    }else{
                        
                    }
                    
                    
                    SignTime.attributedText = attributeText
                    if attributeText.length>0{
                        SignTime.mas_updateConstraints { (make) in
                            make?.top.mas_equalTo()(MorningTime.mas_bottom)?.setOffset(15)
                        }
                    }else{
                        SignTime.mas_updateConstraints { (make) in
                            make?.top.mas_equalTo()(MorningTime.mas_bottom)?.setOffset(0)
                        }
                    }
                    
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
                    SignTime.mas_updateConstraints { (make) in
                        make?.top.mas_equalTo()(MorningTime.mas_bottom)?.setOffset(15)
                    }
                }else{
                    
                }
                
            }else{
                
                
            }
            
            
            if false == model?.isAttendance  {
                self.time?.invalidate()
                self.time = nil
                footView.isHidden = true
                footView.mas_updateConstraints { (make) in
                    make?.height.mas_equalTo()(0)
                    make?.bottom.mas_equalTo()(contentView.mas_bottom)?.setOffset(0)
                }
            }else{
                updateTime()
                let timer = Timer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
                RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
                self.time = timer
                footView.isHidden = false
                footView.mas_updateConstraints { (make) in
                    make?.height.mas_equalTo()(AutoGetHeight(height: 215))
                    make?.bottom.mas_equalTo()(contentView.mas_bottom)?.setOffset(-10)
                }
            }
            
        }
    }
    
    @objc func updateTime(){
        let currentDate = NSDate();
        let dateformate = DateFormatter()
        dateformate.dateFormat = "hh:mm:ss"
        let dateString = dateformate.string(from: currentDate as Date)
        clockLab.text = dateString

    }
    @objc func buka(){
        print("补卡")
        let vc = NCQApprovelVC()
        vc.titleStr = "补卡"
        vc.businessCode = "B_BK"
        vc.modifyTime = dateStr + " " + (model?.ruleTime)!
        rootVc!.navigationController?.pushViewController(vc, animated: true)
    }
    func clearTimes(){
        self.time?.invalidate()
    }
    @objc func signClick(){
        self.sDelegate?.signAction()
    }
    @objc func LocationClick(){
        self.lDelegate?.locationUpdataAction()
    }
    
//    deinit {
//        self.time?.invalidate()
//        self.time=nil
//        
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
}

//
//  QRKaoQingJiLuTableViewCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/10/23.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRKaoQingJiLuTableViewCell: UITableViewCell {
    var rootVc : CQAttendancePersonVC!
    lazy var line1: UIView = {
        let line1 = UIView.init()
        line1.backgroundColor = kLineColor
        line1.isHidden = true
        return line1
    }()
    
    lazy var img: UIImageView = {
        let img = UIImageView.init()
        img.image = UIImage.init(named: "personDefaultIcon")
        img.layer.cornerRadius = AutoGetWidth(width: 18)
        img.clipsToBounds = true
        return img
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel(title: "李明", textColor: UIColor.black, fontSize: 12, alignment: .center, numberOfLines: 1)
        nameLab.isUserInteractionEnabled = true
        return nameLab
    }()
    
    lazy var line2: UIView = {
        let line2 = UIView.init()
        line2.backgroundColor = kLineColor
        line2.isHidden = true
        return line2
    }()
    lazy var line3: UIView = {
        let line3 = UIView.init()
        line3.backgroundColor = kLineColor
        return line3
    }()
    lazy var statusText: UILabel = {
        let statusText = UILabel(title: "", textColor: UIColor.black, fontSize: 12, alignment: .left, numberOfLines: 0)
        statusText.isUserInteractionEnabled = true
       // statusText.backgroundColor = kLineColor
        return statusText
    }()
    //外出but
    lazy var waichuBtn: UIButton = {
        let waichuBtn = UIButton(frame:  CGRect(x: kWidth, y: 22, width: AutoGetWidth(width: 17), height: AutoGetWidth(width: 22)))
        waichuBtn.setBackgroundImage(UIImage(named: "waichuxiangq"), for: UIControlState.normal)
        waichuBtn.addTarget(self, action: #selector(waichu), for: UIControlEvents.touchUpInside)
        waichuBtn.isHidden = true
        return waichuBtn
    }()
    lazy var statusTextView: UITextView = {
        let statusTextView = UITextView()
        statusTextView.isScrollEnabled = false
        statusTextView.isEditable = false
        //statusTextView.isSelectable = false
       // statusTextView.isUserInteractionEnabled = true
        statusTextView.delegate = self
        
        return statusTextView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(line1)
        self.contentView.addSubview(img)
        self.contentView.addSubview(nameLab)
      //  self.contentView.addSubview(statusText)
        self.contentView.addSubview(statusTextView)
        self.contentView.addSubview(line2)
        self.contentView.addSubview(line3)
      //  self.statusTextView.addSubview(waichuBtn)
       // self.contentView.addSubview(waichuBtn)
        setupUI()
        
    }
    
    func setupUI()  {
        img.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(AutoGetWidth(width: 15))
            make?.centerY.mas_equalTo()(self.contentView.mas_centerY)?.setOffset(-AutoGetWidth(width: 7))
            make?.width.mas_equalTo()(AutoGetWidth(width: 36))
            make?.height.mas_equalTo()(AutoGetWidth(width: 36))
        }
        
        line1.mas_makeConstraints { (make) in
            make?.centerX.mas_equalTo()(self.img.mas_centerX)
            make?.top.mas_equalTo()(self.contentView.mas_top)
            make?.bottom.mas_equalTo()(self.img.mas_top)?.setOffset(-6)
            make?.width.mas_equalTo()(1)
            make?.height.mas_greaterThanOrEqualTo()(AutoGetWidth(width: 30))
        }
        line2.mas_makeConstraints { (make) in
            make?.centerX.mas_equalTo()(self.img.mas_centerX)
            make?.top.mas_equalTo()(self.nameLab.mas_bottom)?.setOffset(6)
            make?.bottom.mas_equalTo()(self.contentView.mas_bottom)
            make?.width.mas_equalTo()(1)
            make?.height.mas_greaterThanOrEqualTo()(AutoGetWidth(width: 30))
        }
        
        nameLab.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(self.img.mas_bottom)
            make?.centerX.mas_equalTo()(self.img.mas_centerX)
            make?.height.mas_equalTo()(15)
        }

        statusTextView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(self.img.mas_right)?.setOffset(15)
            make?.right.mas_equalTo()(self.contentView.mas_right)?.setOffset(-AutoGetWidth(width: 20))
            make?.centerY.mas_equalTo()(self.contentView.mas_centerY)
            make?.top.mas_greaterThanOrEqualTo()(self.contentView.mas_top)?.setOffset(AutoGetWidth(width: 20))
            make?.bottom.mas_greaterThanOrEqualTo()(self.contentView.mas_bottom)?.setOffset(-AutoGetWidth(width: 20))
        }
    

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    @objc func waichu(entitiID:String)  {
        print("外出")
        let vc = QRWaiQinDetailVc()
        vc.dataStr = rootVc.statisticalDate
        vc.userId = model!.userId
        vc.entityId = entitiID
        self.rootVc.navigationController?.pushViewController(vc, animated: true)
        
    }
    //定义模型属性
    var model: CQDepartMentAttenceModel? {
        didSet {
            self.contentView.isUserInteractionEnabled = true
           // self.waichuBtn.isHidden = true
            
            self.img.sd_setImage(with: URL(string: model?.headImage ?? "" ), placeholderImage:UIImage.init(named: "personDefaultIcon") )
            
            self.nameLab.text = model?.realName
            let statusText = NSMutableAttributedString.init(string: "")
            for modelJson in (model?.statisticData)!{
                
                guard let statistModel = CQDepartMentAttenceModel(jsonData: modelJson) else {
                    return
                }
                
                
                
                
                if !statistModel.typeName.isEmpty{
                    
                 //   标记迟到,未签,图片的标记
                    // 创建NSMutableAttributedString对象
                    let textAttachment = NSTextAttachment()
                    //设置textAttachment的大小和属性
                    textAttachment.bounds =  CGRect(x: 0, y: -4, width: (39.5), height: 17.5)
                    
                    print("xxxxx"+statistModel.typeName)
                    if statistModel.typeName == "迟到"{
                       textAttachment.image = UIImage(named: "cd")
                    }else if statistModel.typeName == "旷工"{
                         textAttachment.image = UIImage(named: "kg")
                    }
                    else if statistModel.typeName == "早退"{
                       textAttachment.image = UIImage(named: "zt")
                    }
                    else if statistModel.typeName == "缺勤"{
                        textAttachment.image = UIImage(named: "wq")
                    }
                    else if statistModel.typeName == "外出"{
                        textAttachment.image = UIImage(named: "wc")
                    }
                    else if statistModel.typeName == "出差"{
                        textAttachment.image = UIImage(named: "cc")
                    }else if statistModel.typeName == "请假" {
                        textAttachment.image = UIImage(named: "qj")
                    }
                    let ss = "\n"
                    let attribute = NSMutableAttributedString.init(string: ss)
                    statusText.append(attribute)
                    
                    let attributeString = NSAttributedString(attachment: textAttachment)
                    statusText.append(attributeString)
                    
                    if !statistModel.typeNameRemark.isEmpty || !statistModel.typeNameTotal.isEmpty{
                      //文字
                        if !statistModel.typeNameRemark.isEmpty{
                            let str = "   "+statistModel.typeNameRemark + "\n"
                            let attributeText = NSMutableAttributedString.init(string: str)
                            statusText.append(attributeText)
                        }
                        if !statistModel.typeNameTotal.isEmpty{
                            let str = "   "+statistModel.typeNameTotal + "\n"
//                            let mstr = NSMutableAttributedString(string: str)
//                            let dic = [NSAttributedStringKey.backgroundColor:UIColor.black,NSAttributedStringKey.link : "to"] as [NSAttributedStringKey : Any]
//                            mstr.setAttributes(dic, range: (str as NSString).range(of:str))
//
                            let attributeText = NSMutableAttributedString.init(string: str)
                            statusText.append(attributeText)
                        }
                    }else{
                        let str = "\n"
                        let attributeText = NSMutableAttributedString.init(string: str)
                        statusText.append(attributeText)
                       
                    }
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 6
                    paragraphStyle.alignment = .left
                    // 4.行间距
                    statusText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, statusText.length))
    
                    
                }else{
                    let str = "\n"
                    let attributeText = NSMutableAttributedString.init(string: str)
                    statusText.append(attributeText)
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 6
                    paragraphStyle.alignment = .left
                    // 4.行间距
                    statusText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, statusText.length))
                }

                
                if !statistModel.signDate.isEmpty{
                   let str = "出差签到: " +  statistModel.signDate + "\n"
                    let attributeText = NSMutableAttributedString.init(string: str)
                    statusText.append(attributeText)
                
                }
                
                if !statistModel.amStart.isEmpty {
                    
                    var str = ""
                    let attributeText = NSMutableAttributedString.init(string: str)
                    
                    if statistModel.typeName == "外出"{
                         str = "外出上班: " +  statistModel.amStart + "    "
                        let atts = NSMutableAttributedString.init(string: str)
                        attributeText.append(atts)
                    }else{
                        let strt = "上午上班: " +  statistModel.amStart
                        let strtText = NSMutableAttributedString.init(string: strt)
                        attributeText.append(strtText)
                        //1app 2面板机 3 2维码
                        if statistModel.amStartSource == "1"{
                            let attributeNext = NSMutableAttributedString.init(string: "\n" )
                            attributeText.append(attributeNext)
                        }else if statistModel.amStartSource == "2"{
                            let textAttachment = NSTextAttachment()
                            textAttachment.image = UIImage(named: "sbdk")
                            textAttachment.bounds =  CGRect(x: 0, y: -3, width: 15, height: 15)
                            let attributeString = NSAttributedString(attachment: textAttachment)
                            let attributeSpace = NSMutableAttributedString.init(string: "  " )
                             let attributeNext = NSMutableAttributedString.init(string: "\n" )
                            attributeText.append(attributeSpace)
                            attributeText.append(attributeString)
                            attributeText.append(attributeNext)
                        }else if statistModel.amStartSource == "3"{
                            let attributeNext = NSMutableAttributedString.init(string: "\n" )
                            attributeText.append(attributeNext)
                        }else{
                            let attributeNext = NSMutableAttributedString.init(string: "\n" )
                            attributeText.append(attributeNext)
                        }
                        
                    }
                    
                   
                    statusText.append(attributeText)
                    
                    if statistModel.typeName == "外出"{
                        let textAttachment = NSTextAttachment()
                        //设置textAttachment的大小和属性
                        textAttachment.bounds =  CGRect(x: 0, y: -AutoGetWidth(width: 10), width: (AutoGetWidth(width: 17)), height: AutoGetWidth(width: 22))
                        textAttachment.image = UIImage(named: "waichuxiangq")
                        let attributeString = NSAttributedString(attachment: textAttachment)
                        let mutab = NSMutableAttributedString(attributedString: attributeString)
                        let entityid = statistModel.entityId
                        mutab.addAttribute(NSAttributedStringKey.link, value: entityid+"://", range: NSMakeRange(0, attributeString.length))
                        statusText.append(mutab)
                        self.statusTextView.delegate = self
                        let str = "\n"
                        let attributeText = NSMutableAttributedString.init(string: str)
                        statusText.append(attributeText)
                        
                    }else{
                       
                    }
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 6
                    paragraphStyle.alignment = .left
                    // 4.行间距
                    statusText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, statusText.length))
                }
                
                
                if !statistModel.amEnd.isEmpty {
                    
                    var str = ""
                    let attributeText = NSMutableAttributedString.init(string: str)
                    if statistModel.typeName == "外出"{
                       // str = "外出下班: " +  statistModel.amEnd + "\n"
                        str = "外出下班: " +  statistModel.amEnd + "\n"
                        let atts = NSMutableAttributedString.init(string: str)
                        attributeText.append(atts)
                    }else{
                        let strt = "上午下班: " +  statistModel.amEnd + "\n"
                        let strtText = NSMutableAttributedString.init(string: strt)
                        attributeText.append(strtText)
                        //1app 2面板机 3 2维码
                        if statistModel.amEndSource == "1"{
                            let attributeNext = NSMutableAttributedString.init(string: "\n" )
                            attributeText.append(attributeNext)
                        }else if statistModel.amEndSource == "2"{
                            let textAttachment = NSTextAttachment()
                            textAttachment.image = UIImage(named: "sbdk")
                            textAttachment.bounds =  CGRect(x: 0, y: -3, width: 15, height: 15)
                            let attributeString = NSAttributedString(attachment: textAttachment)
                            let attributeSpace = NSMutableAttributedString.init(string: "  " )
                            let attributeNext = NSMutableAttributedString.init(string: "\n" )
                            attributeText.append(attributeSpace)
                            attributeText.append(attributeString)
                            attributeText.append(attributeNext)
                        }else if statistModel.amEndSource == "3"{
                            let attributeNext = NSMutableAttributedString.init(string: "\n" )
                            attributeText.append(attributeNext)
                        }else{
                            let attributeNext = NSMutableAttributedString.init(string: "\n" )
                            attributeText.append(attributeNext)
                        }
                    }
                    
                    statusText.append(attributeText)
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 6
                    paragraphStyle.alignment = .left
                    // 4.行间距
                    statusText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, statusText.length))
                }
                
                
                if !statistModel.pmStart.isEmpty {

                    var str = ""
                    let attributeText = NSMutableAttributedString.init(string: str)
                    
                    if statistModel.typeName == "外出"{
                        str = "外出上班: " +  statistModel.pmStart + "\n"
                        let atts = NSMutableAttributedString.init(string: str)
                        attributeText.append(atts)
                    }else{
                        let strt = "下午上班: " +  statistModel.pmStart
                        let strtText = NSMutableAttributedString.init(string: strt)
                        attributeText.append(strtText)
                        //1app 2面板机 3 2维码
                        if statistModel.pmStartSource == "1"{
                            let attributeNext = NSMutableAttributedString.init(string: "\n" )
                            attributeText.append(attributeNext)
                        }else if statistModel.pmStartSource == "2"{
                            let textAttachment = NSTextAttachment()
                            textAttachment.image = UIImage(named: "sbdk")
                            textAttachment.bounds =  CGRect(x: 0, y: -3, width: 15, height: 15)
                            let attributeString = NSAttributedString(attachment: textAttachment)
                            let attributeSpace = NSMutableAttributedString.init(string: "  " )
                            let attributeNext = NSMutableAttributedString.init(string: "\n" )
                            attributeText.append(attributeSpace)
                            attributeText.append(attributeString)
                            attributeText.append(attributeNext)
                        }else if statistModel.pmStartSource == "3"{
                            let attributeNext = NSMutableAttributedString.init(string: "\n" )
                            attributeText.append(attributeNext)
                        }else{
                            let attributeNext = NSMutableAttributedString.init(string: "\n" )
                            attributeText.append(attributeNext)
                        }
                        
                    }
              
                    statusText.append(attributeText)
                  
        
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 6
                    paragraphStyle.alignment = .left
                    // 4.行间距
                    statusText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, statusText.length))
                 
                }
                
                if !statistModel.pmEnd.isEmpty {
                    
                    
                    var str = ""
                     let attributeText = NSMutableAttributedString.init(string: str)
                    if statistModel.typeName == "外出"{
                        str = "外出下班: " +  statistModel.pmEnd + "\n"
                        let atts = NSMutableAttributedString.init(string: str)
                        attributeText.append(atts)
                        
                    }else{
                        let strt = "下午下班: " +  statistModel.pmEnd
                        let strtText = NSMutableAttributedString.init(string: strt)
                        attributeText.append(strtText)
                        //1app 2面板机 3 2维码
                        if statistModel.pmEndSource == "1"{
                            let attributeNext = NSMutableAttributedString.init(string: "\n" )
                            attributeText.append(attributeNext)
                        }else if statistModel.pmEndSource == "2"{
                            let textAttachment = NSTextAttachment()
                            textAttachment.image = UIImage(named: "sbdk")
                            textAttachment.bounds =  CGRect(x: 0, y: -3, width: 15, height: 15)
                            let attributeString = NSAttributedString(attachment: textAttachment)
                            let attributeSpace = NSMutableAttributedString.init(string: "  " )
                            let attributeNext = NSMutableAttributedString.init(string: "\n" )
                            attributeText.append(attributeSpace)
                            attributeText.append(attributeString)
                            attributeText.append(attributeNext)
                        }else if statistModel.pmEndSource == "3"{
                            let attributeNext = NSMutableAttributedString.init(string: "\n" )
                            attributeText.append(attributeNext)
                        }else{
                            let attributeNext = NSMutableAttributedString.init(string: "\n" )
                            attributeText.append(attributeNext)
                        }
                        
                    }
                    statusText.append(attributeText)
                    
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 6
                    paragraphStyle.alignment = .left
                    // 4.行间距
                    statusText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, statusText.length))
                }
                
                if !statistModel.startTime.isEmpty {
                    
                   let str = "开始时间: " +  statistModel.startTime + "\n"
                   print("开始时间"+str)
                    let attributeText = NSMutableAttributedString.init(string: str)
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 6
                    paragraphStyle.alignment = .left
                    // 4.行间距
                    statusText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, statusText.length))
                    
                   statusText.append(attributeText)
                    
                  
                }
                
                if !statistModel.endTime.isEmpty {
                    
                    let str = "结束时间: " +  statistModel.endTime + "\n"
                    print("结束时间"+str)
                    let attributeText = NSMutableAttributedString.init(string: str)
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 6
                    paragraphStyle.alignment = .left
                    // 4.行间距
                    statusText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, statusText.length))
                    statusText.append(attributeText)
                    
            
                }
               
            }
            

            self.statusTextView.attributedText = statusText

        }
    }
    
  
}
extension QRKaoQingJiLuTableViewCell:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.scheme == "weixin"{
            //self.rootVc.navigationController?.popViewController(animated: true)

             return false
        }else{
             return false
        }

    }
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        var utl = URL.absoluteString
        utl.removeLast()
        utl.removeLast()
        utl.removeLast()
        waichu(entitiID: utl)
            return false


    }


}

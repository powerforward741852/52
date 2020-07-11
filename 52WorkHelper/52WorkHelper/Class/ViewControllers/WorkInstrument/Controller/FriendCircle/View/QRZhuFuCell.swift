//
//  QRZhuFuCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/14.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRZhuFuCell: UITableViewCell {

    
    @IBOutlet weak var bigImage: UIImageView!
    
    @IBOutlet weak var contentLabel: MLLinkLabel!
    
    
    @IBOutlet weak var dateLabel: MLLinkLabel!
    
    lazy var icon : UIImageView = {
        let icon = UIImageView(image: UIImage(named: "birthImg"))
        icon.layer.cornerRadius = 5
        return icon
    }()
    
    //评论
    lazy var commentText : MLLinkLabel = {
        let Text = MLLinkLabel()
        Text.isUserInteractionEnabled = true
        Text.lineBreakMode = NSLineBreakMode.byCharWrapping
        Text.font = kFontSize14
        //Text.delegate = self
        Text.numberOfLines = 0
        //        let dic = [NSAttributedStringKey.:UIColor.black] as [NSAttributedStringKey : Any]
        //        mao.setAttributes(dic, range:(":" as NSString).range(of:":"))
        let linkDict = [NSAttributedStringKey.foregroundColor:UIColor.colorWithHexString(hex: "#1e5f91")]
        let activeLinkDict = [NSAttributedStringKey.backgroundColor : kProjectBgColor,NSAttributedStringKey.foregroundColor:klightGreyColor]
        Text.linkTextAttributes = linkDict
        Text.activeLinkTextAttributes = activeLinkDict
        Text.text = ""
        return Text
    }()
    
    lazy var dateText : MLLinkLabel = {
        let Text = MLLinkLabel()
        Text.isUserInteractionEnabled = true
        Text.lineBreakMode = NSLineBreakMode.byCharWrapping
        Text.font = kFontSize14
        Text.textAlignment = NSTextAlignment.right
        //Text.delegate = self
        Text.numberOfLines = 0
        //        let dic = [NSAttributedStringKey.:UIColor.black] as [NSAttributedStringKey : Any]
        //        mao.setAttributes(dic, range:(":" as NSString).range(of:":"))
        let linkDict = [NSAttributedStringKey.foregroundColor:UIColor.colorWithHexString(hex: "#1e5f91")]
        let activeLinkDict = [NSAttributedStringKey.backgroundColor : kProjectBgColor,NSAttributedStringKey.foregroundColor:klightGreyColor]
        Text.linkTextAttributes = linkDict
        Text.activeLinkTextAttributes = activeLinkDict
        Text.text = ""
        return Text
    }()
    
    
    
    var model : QRBirthModel?{
        didSet{
            
//            if model?.countSum == "0" {
//                commentText.text = "本月份无人过生日"
//            }else{
//                let year = getYear()
//                let tempAtt = NSMutableAttributedString(string: "\(year)" + "年" + (model?.month)! + "月份" + "\n")
//                let personstr = (model?.name)! + "等"
//                let personAtt = NSMutableAttributedString(string: personstr)
//                let dic = [NSAttributedStringKey.foregroundColor:kBlueC] as [NSAttributedStringKey : Any]
//                personAtt.setAttributes(dic, range: (personstr as NSString).range(of: personstr))
//
//                let birthstr = (model?.countSum)! + "位员工生日"
//                let birthAtt = NSMutableAttributedString(string: birthstr)
//                let dic1 = [NSAttributedStringKey.foregroundColor:UIColor.colorWithHexString(hex: "#9d9d9d")] as [NSAttributedStringKey : Any]
//                birthAtt.setAttributes(dic1, range: (birthstr as NSString).range(of: birthstr))
//
//                tempAtt.append(personAtt)
//                tempAtt.append(birthAtt)
//                commentText.attributedText = tempAtt
//
//            }
            
            if model?.contentId == "0"{
               
                if model?.countSum == "0"{
                     contentLabel.text = "无人过生日"
                }else{
                    let year = getYear()
                    //"\(year)" + "年" + (model?.month)! + "月份" + "\n"
                    let tempAtt = NSMutableAttributedString(string: "")
                    let personstr = (model?.name)! + "等"
                    let personAtt = NSMutableAttributedString(string: personstr)
                    let dic = [NSAttributedStringKey.foregroundColor:kBlueC] as [NSAttributedStringKey : Any]
                    personAtt.setAttributes(dic, range: (personstr as NSString).range(of: personstr))
                    
                    let birthstr = (model?.countSum)! + "位员工生日"
                    let birthAtt = NSMutableAttributedString(string: birthstr)
                    let dic1 = [NSAttributedStringKey.foregroundColor:UIColor.colorWithHexString(hex: "#9d9d9d")] as [NSAttributedStringKey : Any]
                    birthAtt.setAttributes(dic1, range: (birthstr as NSString).range(of: birthstr))
                    
                    tempAtt.append(personAtt)
                    tempAtt.append(birthAtt)
                    contentLabel.attributedText = tempAtt
                }
               
                
                bigImage.image = UIImage(named: "birthImg")
        
                let date = Date(dateString: model!.date, format: "yyyy-MM-dd")
                let dateFormart = DateFormatter()
                dateFormart.dateFormat = "yyyy年MM月dd日"
                if date.isToday {
                    dateLabel.text = "今天"
                }else{
                    dateLabel.text = dateFormart.string(from: date)
                }
                
            }else{
                bigImage.image = UIImage(named: "birthImg")
                
                if let textStr = model?.content{
                    var str = textStr
                    if textStr.hasSuffix("\n"){
                        str.removeLast()
                        if str.fromBase64() == nil{
                            str =  str.replacingOccurrences(of: "\n", with: "").fromBase64()!
                        }else{
                            str = str.fromBase64()!
                        }
                    }else{
                        str = textStr
                    }
                    contentLabel.text = str
                }
              
                
                if model!.name == ""{
                   dateLabel.text = "  "
                }else{
                    dateLabel.text = "来自: " + model!.name
                }
                
            }
            
            
          
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = kProjectBgColor
 
        contentLabel.isUserInteractionEnabled = true
        contentLabel.lineBreakMode = NSLineBreakMode.byCharWrapping
        contentLabel.font = kFontSize14
        contentLabel.textAlignment = NSTextAlignment.left
        //Text.delegate = self
        contentLabel.numberOfLines = 0
        //        let dic = [NSAttributedStringKey.:UIColor.black] as [NSAttributedStringKey : Any]
        //        mao.setAttributes(dic, range:(":" as NSString).range(of:":"))
        let linkDict = [NSAttributedStringKey.foregroundColor:UIColor.colorWithHexString(hex: "#1e5f91")]
        let activeLinkDict = [NSAttributedStringKey.backgroundColor : kProjectBgColor,NSAttributedStringKey.foregroundColor:klightGreyColor]
        contentLabel.linkTextAttributes = linkDict
        contentLabel.activeLinkTextAttributes = activeLinkDict
       
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    


}

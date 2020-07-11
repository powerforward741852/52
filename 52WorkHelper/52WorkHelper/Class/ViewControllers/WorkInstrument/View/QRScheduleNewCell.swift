//
//  QRScheduleNewCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2020/3/25.
//  Copyright © 2020 chenqihang. All rights reserved.
//

import UIKit

class QRScheduleNewCell: UITableViewCell {

        var indexP : IndexPath?
        //声明闭包
        typealias clickBtnClosure = (_ index: IndexPath?) -> Void
        //把申明的闭包设置成属性
        var clickClosure: clickBtnClosure?
        
        var model: CQScheduleModel? {
                didSet {
                    
                    startTimeLabel.text = model?.startDate
                    endTimeLabel.text = model?.endDate
                    startTitleLabel.numberOfLines = 1
                    startTitleLabel.text = model?.planTitle
                    //富文本
                    let statusText = NSMutableAttributedString.init(string: "")
                    for (index,mod) in (model?.planItemData)!.enumerated(){
                    //   标记迟到,未签,图片的标记
                // 创建NSMutableAttributedString对象//设置textAttachment的大小和属性
                   let textAttachment = NSTextAttachment()
                    
                    textAttachment.bounds =  CGRect(x: 0, y: -4, width: (17.5), height: 17.5)
                   
                   if mod.finishStatus == true{
                      textAttachment.image = UIImage(named: "CQScheduleFinish")
                   }else if mod.finishStatus == false{
                      textAttachment.image = UIImage(named: "MessageGroupNotSelect")
                   }
                   let attributeString = NSAttributedString(attachment: textAttachment)
                   statusText.append(attributeString)
                            
                    if (model?.planItemData)!.count-1 == index{
                        let ss = "  " + mod.planItemContent
                        let attribute = NSMutableAttributedString.init(string: ss)
                        statusText.append(attribute)
                    }else{
                        let ss = "  " + mod.planItemContent + "\n"
                        let attribute = NSMutableAttributedString.init(string: ss)
                        statusText.append(attribute)
                    }
  
                }
                let paragraphStyle = NSMutableParagraphStyle()
                                       paragraphStyle.lineSpacing = 6
                                       paragraphStyle.alignment = .left
                    paragraphStyle.lineBreakMode = .byCharWrapping
                                       // 4.行间距
               statusText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, statusText.length))

                    
                    self.textV.attributedText = statusText
                    let sizes = textV.sizeThatFits(CGSize(width: textV.tz_width, height: CGFloat.greatestFiniteMagnitude))
                                 print(sizes.height)
                     textV.frame =  CGRect(x: endTimeLabel.right, y: startTitleLabel.bottom + 10 , width: kWidth - startTimeLabel.width - 60, height: sizes.height)
                    model?.rowHeight = sizes.height + 55
                    
            }
        }

    
        lazy var startTimeLabel: UILabel = {
            let startTimeLabel = UILabel()
            startTimeLabel.frame = CGRect.init(x: 15, y: 10, width: 80, height: 25)
            startTimeLabel.font = kFontSize16
            startTimeLabel.textColor = UIColor.black
            startTimeLabel.textAlignment = .left
            startTimeLabel.text = "08:30"
            
            return startTimeLabel
        }()
    
        lazy var startTitleLabel: UILabel = {
                   let startTitleLabel = UILabel()
            startTitleLabel.frame = CGRect.init(x:startTimeLabel.right+5 , y: 10, width:kWidth - startTimeLabel.width - 60 , height: 25)
                   startTitleLabel.font = kFontSize16
                   startTitleLabel.textColor = UIColor.black
                   startTitleLabel.textAlignment = .left
                   startTitleLabel.text = "拜访客户"
            
                    startTitleLabel.numberOfLines = 1
                   return startTitleLabel
               }()
        
        lazy var endTimeLabel: UILabel = {
            let endTimeLabel = UILabel()
            endTimeLabel.frame = CGRect.init(x: 15, y:startTimeLabel.bottom+10 , width: 80, height: 25)
            endTimeLabel.font = kFontSize15
            endTimeLabel.textColor = UIColor.black
            endTimeLabel.textAlignment = .left
            endTimeLabel.text = "18:00"
            return endTimeLabel
        }()
        
        lazy var textV: UITextView = {
             let textV = UITextView()
            textV.frame =  CGRect(x: endTimeLabel.right, y: startTitleLabel.bottom + 10 , width: kWidth - startTimeLabel.width - 60, height: 45)
                textV.textColor = UIColor.black
                textV.font = kFontSize15
                textV.textAlignment = .left
                textV.text = ""
                textV.font  = kFontSize15
                textV.isEditable = false
            textV.isUserInteractionEnabled = true
//               textV.delegate = self
                textV.textContainerInset = UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7)
            
                textV.isScrollEnabled = false
                textV.backgroundColor = UIColor.colorWithHexString(hex: "#f5f9fd")
                
              return textV
        }()
        
        
     
          func setUp() {
                self.addSubview(startTimeLabel)
                self.addSubview(startTitleLabel)
                self.addSubview(endTimeLabel)
                self.addSubview(textV)
            
            }

        
        override func layoutSubviews() {
            super.layoutSubviews()
//            if self.model!.finishStatus == true{
//                self.selectBtn.image = UIImage(named: "MessageGroupSelect")
//            }else{
//                self.selectBtn.image = UIImage.init(named: "MessageGroupNotSelect")
//            }
        }
        
      
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.setUp()
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func awakeFromNib() {
            super.awakeFromNib()
          
        }
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }

    }


    extension QRScheduleNewCell: YYTextViewDelegate{

        func textViewDidChange(_ textView: YYTextView) {
           
    
//              let sizes = textView.sizeThatFits(CGSize(width: textView.tz_width, height: CGFloat.greatestFiniteMagnitude))
//              print(sizes.height)
//              if sizes.height > 45{
//
//
//              }else{
//
//
//
//              }
            
//            let height = self.table?.contentSize.height
//            self.table?.frame.size = CGSize(width: kWidth, height: height!)
//
//            let userDic = ["height":height]
          
          }


    }

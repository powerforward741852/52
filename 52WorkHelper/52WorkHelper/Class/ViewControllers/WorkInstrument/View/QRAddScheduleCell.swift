//
//  QRAddScheduleCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2020/3/23.
//  Copyright © 2020 chenqihang. All rights reserved.
//

import UIKit

class QRAddScheduleCell: UITableViewCell {

    
    var selectStatus:Bool = false
    var indexP : IndexPath?
    var content = ""
    var rootV : QRAddScheduleView?
    var isAdd = false
    var isDetail = false
    //声明闭包
    typealias clickBtnClosure = (_ index: IndexPath?) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    
    //声明闭包
    typealias clickFinish = (_ index: IndexPath?) -> Void
    //把申明的闭包设置成属性
    var clickFini : clickFinish?
    
    var table : UITableView?
    
    
    
    var model: QRSecheduleModel? {
           didSet {
            
            textV.isEditable = !isDetail
            
            if isDetail{
                 textV.textContainerInset = UIEdgeInsets(top: 12, left: 10, bottom: 0, right: 15)
                deleteBtn.isHidden = true
            }else{
                 textV.textContainerInset = UIEdgeInsets(top: 12, left: 10, bottom: 0, right: 35)
                deleteBtn.isHidden = false
            }
            
            
            if isAdd{
                self.selectBtn.isHidden = true
                table?.beginUpdates()
                textV.mj_x = selectBtn.left
                textV.mj_w = kWidth-30
                table?.endUpdates()
            }else{
                self.selectBtn.isHidden = false
                table?.beginUpdates()
                textV.mj_x = selectBtn.right+10
                textV.mj_w = kWidth-selectBtn.right-10-15
                table?.endUpdates()
            }
             
             textV.text = model?.planItemContent
            
            let sizes = textV.sizeThatFits(CGSize(width: textV.tz_width, height: CGFloat.greatestFiniteMagnitude))
                     if sizes.height > 45{
                        self.model!.rowHeight = sizes.height + 10 + 10
                       self.table?.beginUpdates()
                           self.textV.height = sizes.height + 10
                           
                       self.deleteBtn.frame =   CGRect.init(x:kWidth-25-15-5, y:self.model!.rowHeight/2-11.5 , width:23, height:23)
                       self.table?.endUpdates()
                     }else{
                         
                        self.model!.rowHeight = 55
                       self.table?.beginUpdates()
                           self.textV.height = 45
                          
                           self.deleteBtn.frame =   CGRect.init(x:kWidth-25-15-5, y:self.model!.rowHeight/2-11.5 , width:23, height:23)
                       self.table?.endUpdates()
                     }
                   
                   let heights = self.rootV?.calculateHeight()
//            self.table?.frame.size = CGSize(width: kWidth, height: heights!)
             self.table?.frame =  CGRect(x: 0, y: 0, width: kWidth, height:  heights!) //CGSize(width: kWidth, height: height!)
            
                   let userDic = ["height":heights]
                   NotificationCenter.default.post(name: NSNotification.Name.init("scheduleUpdateHeight"), object: self, userInfo:userDic as [AnyHashable : Any])
           }
       }
    
    lazy var selectBtn: UIImageView = {
        let selectBtn = UIImageView()
        selectBtn.isUserInteractionEnabled = true
        selectBtn.frame = CGRect.init(x: 15, y: 55/3, width: 55/3, height: 55/3)
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapTouchIn))
        selectBtn.addGestureRecognizer(tapGes)
        selectBtn.isHidden = false
        return selectBtn
    }()
    
    lazy var textV: YYTextView = {
         let textV = YYTextView()
            textV.frame =  CGRect(x: selectBtn.right+10, y:  5, width: kWidth-selectBtn.right-10-15, height: 45)
           textV.placeholderTextColor = UIColor.colorWithHexString(hex: "#a6a6a6")
           textV.placeholderFont = kFontSize16
           textV.placeholderText = "请输入日程内容"
           textV.font  = kFontSize16
           textV.delegate = self
           textV.textContainerInset = UIEdgeInsets(top: 12, left: 10, bottom: 0, right: 35)
            
         textV.isScrollEnabled = false
      
          textV.backgroundColor = UIColor.colorWithHexString(hex: "#f5f9fd")
          return textV
    }()
    
    
    lazy var deleteBtn: UIImageView = {
           let deleteBtn = UIImageView()
        deleteBtn.image = UIImage(named: "shanchu")
           deleteBtn.isUserInteractionEnabled = true
           deleteBtn.frame = CGRect.init(x:kWidth-25-15-5, y:16 , width:23, height:23)
           let tapGes = UITapGestureRecognizer(target: self, action: #selector(deleteTouchIn))
           deleteBtn.addGestureRecognizer(tapGes)
           deleteBtn.isHidden = false
           return deleteBtn
       }()
    
    
    @objc func tapTouchIn(){
       
//        self.model?.finishStatus = !(self.model!.finishStatus)
        let userDic = ["index":self.indexP]
        NotificationCenter.default.post(name: NSNotification.Name.init("scheduleUpdateSelectIndexStatus"), object: self, userInfo:userDic as [AnyHashable : Any])
        self.layoutSubviews()
    }
    
    @objc func deleteTouchIn(){
        self.clickClosure!(indexP)
    }
      func setUp() {
            self.addSubview(selectBtn)
            self.addSubview(textV)
            self.addSubview(deleteBtn)
        }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.model!.finishStatus == true{
            self.selectBtn.image = UIImage(named: "CQScheduleFinish")
        }else{
            self.selectBtn.image = UIImage.init(named: "MessageGroupNotSelect")
        }
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

extension QRAddScheduleCell: YYTextViewDelegate{

    func textViewDidEndEditing(_ textView: YYTextView) {
        print("xxx")
    }
    
    
    func textViewDidChange(_ textView: YYTextView) {
          model?.planItemContent = textView.text
          let sizes = textView.sizeThatFits(CGSize(width: textView.tz_width, height: CGFloat.greatestFiniteMagnitude))
          if sizes.height > 45{
             self.model!.rowHeight = sizes.height + 10 + 10
            self.rootV?.table.beginUpdates()
                self.textV.height = sizes.height + 10
            self.deleteBtn.frame =   CGRect.init(x:kWidth-25-15-5, y:self.model!.rowHeight/2-11.5 , width:23, height:23)
             self.rootV?.table.endUpdates()
          }else{
              
             self.model!.rowHeight = 55
             self.rootV?.table.beginUpdates()
                self.textV.height = 45
                self.deleteBtn.frame = CGRect.init(x:kWidth-25-15-5, y:self.model!.rowHeight/2-11.5 , width:23, height:23)
             self.rootV?.table.endUpdates()
          }
        
        let height = self.rootV?.calculateHeight() //self.table?.contentSize.height
        self.table?.frame =  CGRect(x: 0, y: 0, width: kWidth, height:  height!) //CGSize(width: kWidth, height: height!)
        let userDic = ["height":height]
        NotificationCenter.default.post(name: NSNotification.Name.init("scheduleUpdateHeight"), object: self, userInfo:userDic as [AnyHashable : Any])
      }
}


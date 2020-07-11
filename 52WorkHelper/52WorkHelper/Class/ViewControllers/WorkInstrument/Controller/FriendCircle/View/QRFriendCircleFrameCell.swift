//
//  QRFriendCircleFrameCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/22.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

struct friendCircleLayout {
    var kPadding : CGFloat = AutoGetHeight(height: 8)
    var kTextWidth : CGFloat = kWidth - AutoGetWidth(width: 36 + 30 + 10 + 15+30)
    init() {
        
    }
}
let friendCircle = friendCircleLayout.init()

protocol flashSingleLineDelegete : NSObjectProtocol {
    func  QRFriendCircleFrameCellReflashSingleLine(index:IndexPath)
}

class QRFriendCircleFrameCell: UITableViewCell {
    weak var vDelegate:flashSingleLineDelegete?
    weak var rootVc : QRWorkmateCircleVC?
    weak var MrootVc : QRManageDetailVc?
    var index : IndexPath?
    //声明闭包
    typealias clickBtnClosure = (_ InPath:IndexPath) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    
    var model :QRWorkMateCircleModel?{
        didSet{
            iconImg.sd_setImage(with: URL(string: model?.headImg ?? ""), placeholderImage: UIImage(named: "CQIndexPersonDefault"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
           
//            if model?.manageType == 0{
//                if model?.type == 2{
//                    let realName = (model?.realName)!+" "
//                    let realNameA = NSMutableAttributedString(string: realName)
//                    let dic = [NSAttributedStringKey.foregroundColor:kBlueC] as [NSAttributedStringKey : Any]
//                    realNameA.setAttributes(dic, range: (realName as NSString).range(of: realName))
//
//                    let attach = NSTextAttachment()
//                    attach.image = UIImage(named: "dianzh")
//                    attach.bounds =  CGRect(x: 0, y: -1, width: (attach.image?.size.width)!, height: (attach.image?.size.height)!)
//                    var tempAtt = NSMutableAttributedString(string: "")
//                    let img = NSAttributedString(attachment: attach)
//                    let zan = NSMutableAttributedString(string: " 我 棒棒棒!")
//                    tempAtt.append(realNameA)
//                    tempAtt.append(img)
//                    tempAtt.append(zan)
//                    nameText.attributedText = tempAtt
//                }else if model?.type == 1 {
//                    var tempAtt = NSMutableAttributedString(string: "")
//                    let song = NSMutableAttributedString(string: "送 ")
//                    let realName = (model?.realName)!+" "
//                    // let realName = "我"
//                    let realNameA = NSMutableAttributedString(string: realName)
//                    let dic = [NSAttributedStringKey.foregroundColor:kBlueC] as [NSAttributedStringKey : Any]
//                    realNameA.setAttributes(dic, range: (realName as NSString).range(of: realName))
//
//                    let wo = NSMutableAttributedString(string: "我")
//                    let zhuf = NSMutableAttributedString(string: " 祝福")
//
//                    tempAtt.append(realNameA)
//                     tempAtt.append(song)
//                     tempAtt.append(wo)
//                    tempAtt.append(zhuf)
//                    nameText.attributedText = tempAtt
//                }else{
//                     nameText.text = model?.realName ?? ""
//                }
//
//            }else if model?.manageType == 1{
//                if model?.type == 2{
//                    let realName = " "+(model?.admirRealName)!
//                    let realNameA = NSMutableAttributedString(string: realName)
//                    let dic = [NSAttributedStringKey.foregroundColor:kBlueC] as [NSAttributedStringKey : Any]
//                    realNameA.setAttributes(dic, range: (realName as NSString).range(of: realName))
//
//                    let attach = NSTextAttachment()
//                    attach.image = UIImage(named: "dianzh")
//                    attach.bounds =  CGRect(x: 0, y: -1, width: (attach.image?.size.width)!, height: (attach.image?.size.height)!)
//                    var tempAtt = NSMutableAttributedString(string: "")
//                    let img = NSAttributedString(attachment: attach)
//                    let zan = NSMutableAttributedString(string: " 棒棒棒!")
//                    let wo = NSMutableAttributedString(string: "我 ")
//                    tempAtt.append(wo)
//                    tempAtt.append(img)
//                    tempAtt.append(realNameA)
//                    tempAtt.append(zan)
//                    nameText.attributedText = tempAtt
//                }else if model?.type == 1 {
//                    var tempAtt = NSMutableAttributedString(string: "")
//                    let song = NSMutableAttributedString(string: "送 ")
//                    let realName = (model?.admirRealName)!+" "
//                    let realNameA = NSMutableAttributedString(string: realName)
//                    let dic = [NSAttributedStringKey.foregroundColor:kBlueC] as [NSAttributedStringKey : Any]
//                    realNameA.setAttributes(dic, range: (realName as NSString).range(of: realName))
//                    let zhuf = NSMutableAttributedString(string: " 祝福")
//                    tempAtt.append(song)
//                    tempAtt.append(realNameA)
//                    tempAtt.append(zhuf)
//                    nameText.attributedText = tempAtt
//                }else{
//                    nameText.text = model?.realName ?? ""
//                }
//            }else if model?.manageType == 2{
//                nameText.text = model?.realName ?? ""
//            }else{
//               nameText.text = model?.realName ?? ""
//            }
            
            
            if model?.createUserId == "0" {
                var str = model?.realName
                niBut.isHidden = false
                if str!.hasPrefix("匿名"){
                    str?.removeFirst()
                    str?.removeFirst()
                    str?.removeFirst()
                    let deleStr = recursive(urlstr: str ?? "")
                    nameText.text = deleStr
                    nameText.sizeToFit()
                    niBut.frame =  CGRect(x: nameText.right+8, y: nameText.top, width: 45, height: 22)
                    niBut.center.y = nameText.center.y
                }else{
                    let str = model?.realName ?? ""
                    let deleStr = recursive(urlstr: str)
                    nameText.text = deleStr
                    
                }
                
            }else{
                 niBut.isHidden = true
                nameText.text = model?.realName ?? ""
            }
            
            // nameText.text = model?.realName ?? ""
            timeText.text = model?.differTime ?? ""
            
            var bottoms = timeText.bottom + friendCircle.kPadding
            var rowheights:CGFloat = 0
          
            //正文
            if let textStr =  model?.articleContent{
               //转emoji
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
                let contentA = NSMutableAttributedString(string: str)
               //点赞判断
              //  if model?.manageType == 3{
                    if model?.type == 2{
                        let attach = NSTextAttachment()
                        attach.image = UIImage(named: "dianzh")
                        attach.bounds =  CGRect(x: 0, y: -1, width: (attach.image?.size.width)!, height: (attach.image?.size.height)!)
                        let tempAtt = NSMutableAttributedString(string: "")
                        let img = NSAttributedString(attachment: attach)
                        let wo = NSMutableAttributedString(string: " 我为")
                        let str = " @"+(model?.admirRealName)!
                        let name = NSMutableAttributedString(string:str )
                        let dic = [NSAttributedStringKey.foregroundColor:kBlueC] as [NSAttributedStringKey : Any]
                        name.setAttributes(dic, range: (str as NSString).range(of: str))
                        let zan = NSMutableAttributedString(string: " 点赞")
                        tempAtt.append(img)
                        tempAtt.append(wo)
                        tempAtt.append(name)
                        tempAtt.append(zan)
                        if textStr == ""{

                        }else{
                             tempAtt.append(NSAttributedString(string: "\n"))
                        }
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.lineSpacing = 6
                        paragraphStyle.alignment = .left
                        tempAtt.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, tempAtt.length))
                        

//                        if textStr == ""{
//
//                        }else{
                            let paragraphStyleContent = NSMutableParagraphStyle()
                            paragraphStyleContent.lineSpacing = 3
                            paragraphStyleContent.alignment = .left
                            contentA.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyleContent, range: NSMakeRange(0, contentA.length))
                            tempAtt.append(contentA)
                       // }
                       
                        TextLab.attributedText = tempAtt
                    }else{
                        let paragraphStyleContent = NSMutableParagraphStyle()
                        paragraphStyleContent.lineSpacing = 3
                        paragraphStyleContent.alignment = .left
                        contentA.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyleContent, range: NSMakeRange(0, contentA.length))
                        TextLab.attributedText = contentA
                    }
//                }else{
//                     TextLab.attributedText = contentA
//                }
                
                
                TextLab.isHidden = false
                let textSize = TextLab.preferredSize(withMaxWidth: friendCircle.kTextWidth-5)
                TextLab.frame =  CGRect(x: nameText.left, y: bottoms, width:textSize.width , height: textSize.height)
                if textStr == ""{
                    bottoms = TextLab.bottom + friendCircle.kPadding
                }else{
                    bottoms = TextLab.bottom + friendCircle.kPadding
                }
            }else{
                TextLab.isHidden = true
                 bottoms = TextLab.bottom
            }
            
            //图片
            let imgs = model?.picurlData
            let count = imgs!.count
            if count>0{
                picView.isHidden = false
                picView.imags = imgs
                let rowNum = (count - 1)/(cellLayout.numOfPerRow) + 1
                let pictureViewHeight = CGFloat(rowNum) * cellLayout.imageHeight + cellLayout.margin * (CGFloat(rowNum)-1)
                picView.frame =  CGRect(x: timeText.left, y: bottoms, width: picView.pictureViewWidth, height: pictureViewHeight)
                bottoms = picView.bottom + friendCircle.kPadding
            }else{
                picView.frame =  CGRect(x: timeText.left, y: bottoms, width: picView.pictureViewWidth, height: 0)
                bottoms = picView.bottom 
                picView.isHidden = true
            }
            //祝福view
            zhufuView.isHidden = true
            if model?.type == 1 {
                zhufuView.isHidden = false
                let imgss = model?.childJson
                //  picView.imags = imgs
                if let count = imgss?.count, count > 0 {
                    zhufuView.iconImg.sd_setImage(with: URL(string: model!.headImg ?? ""), placeholderImage: UIImage(named: "CQIndexPersonDefault"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
                    zhufuView.nameLalel.text = "来自:"+(model?.realName)!
                    zhufuView.setDataSource(data: (model?.childJson)!)
                    zhufuView.frame = CGRect(x: timeText.left, y: bottoms, width: zhufuView.pictureViewWidth, height: zhufuView.pictureViewHeight)
                    //更新UI
                    bottoms = zhufuView.bottom + friendCircle.kPadding
                }else{
                    zhufuView.frame = CGRect(x: timeText.left, y: bottoms, width: zhufuView.pictureViewWidth, height:0)
                    bottoms = zhufuView.bottom
                    zhufuView.isHidden = true
                }
                
            }

            //评论按钮和赞按钮
            zanBut.frame =  CGRect(x: kWidth-kLeftDis-40-kLeftDis*2, y: bottoms, width: 40, height: 25)
            evaluateBut.frame =  CGRect(x: kWidth-kLeftDis-80-10-kLeftDis*2, y: bottoms, width: 40, height: 25)
            bottoms = zanBut.bottom+friendCircle.kPadding
        
            //赞图变换
            if (model?.laudStatus)! {
//                if model?.type == 1 || model?.type == 2{
                    zanBut.setImage(UIImage.init(named: "dianzh"), for: .normal)
//                }else{
 //                   zanBut.setImage(UIImage.init(named: "CQWorkCircleZan"), for: .normal)
//                }
            }else{
//                if model?.type == 1 || model?.type == 2{
                    zanBut.setImage(UIImage.init(named: "dianzan"), for: .normal)
//                }else{
   //                 zanBut.setImage(UIImage.init(named: "CQWorkCircleCancelZan"), for: .normal)
  //              }
            }
            
            
//            if model?.laudNum == "0"{
//                zanBut.setTitle("", for: UIControlState.normal)
//            }else{
//                zanBut.setTitle(model?.laudNum, for: UIControlState.normal)
//            }
            
             //背景高度
            evaluateBg.frame = CGRect.zero
            var backGroundtop : CGFloat = 0;
            let bgwidth = kWidth-nameText.left-AutoGetWidth(width: 15)*3
            evaluateBg.removeAllSubviews()
            //点赞
            if model?.laudNum == "0"{

            }else{
                let zanUsers = model?.laudUserData
                //富文本处理
                let attach = NSTextAttachment()
                attach.image = UIImage(named: "CQWorkMateCircleHasZan")
                attach.bounds =  CGRect(x: 0, y: -1, width: (attach.image?.size.width)!, height: (attach.image?.size.height)!)
                
                let all = NSMutableAttributedString(string: "")
                let img = NSAttributedString(attachment: attach)
                let space = NSMutableAttributedString(string: "  ")
                
                let att = NSMutableAttributedString(string: "")
                for (index,zanPeople) in zanUsers!.enumerated() {
                    //添加链接
                    let tempatt = NSMutableAttributedString(string: zanPeople)
                    let dic = [NSAttributedStringKey.foregroundColor:kBlueC,NSAttributedStringKey.link : "xxx"] as [NSAttributedStringKey : Any]
                    tempatt.setAttributes(dic, range:(zanPeople as NSString).range(of: zanPeople))
                    if index == (zanUsers?.count)!-1{
                        
                    }else{
                        tempatt.append(NSAttributedString(string: ","))
                    }
                    att.append(tempatt)
                }

                all.append(img)
                all.append(space)
                all.append(att)
        
                let zanPeopleText = MLLinkLabel()
                zanPeopleText.font = kFontSize14
                zanPeopleText.lineBreakMode = NSLineBreakMode.byCharWrapping
                zanPeopleText.delegate = self
                zanPeopleText.numberOfLines = 0
                let linkDict = [NSAttributedStringKey.foregroundColor:UIColor.colorWithHexString(hex: "#1e5f91")]
                let activeLinkDict = [NSAttributedStringKey.backgroundColor : kProjectBgColor,NSAttributedStringKey.foregroundColor:klightGreyColor]
                zanPeopleText.linkTextAttributes = linkDict
                zanPeopleText.activeLinkTextAttributes = activeLinkDict
                zanPeopleText.attributedText = all
                zanPeopleText.isHidden = false
                evaluateBg.addSubview(zanPeopleText)
                
                let labSize = zanPeopleText.preferredSize(withMaxWidth: bgwidth - AutoGetWidth(width: 5) - friendCircle.kPadding - 5)
                zanPeopleText.frame = CGRect(x: AutoGetWidth(width: 5)+friendCircle.kPadding, y: 7, width:  bgwidth - AutoGetWidth(width: 5) - friendCircle.kPadding - 5, height: labSize.height)
                //线
                let line = UIView(frame:  CGRect(x: 0, y: zanPeopleText.bottom+8, width: bgwidth, height: 0.5))
                line.backgroundColor = kLineColor
                evaluateBg.addSubview(line)
                line.isHidden = true
                self.evaluateBgLineView = line
                backGroundtop = labSize.height+15
            }
           
            
            //评论
            if (model?.commentData.count)!>0{
                if model?.laudNum != "0"{
                    self.evaluateBgLineView?.isHidden = false
                }
                
                backGroundtop = backGroundtop + 5
                for (_,value) in (model?.commentData.enumerated())!{
                    let lab = creatLable(width: bgwidth, top: backGroundtop, commentData: value)
                    backGroundtop = backGroundtop + lab.height
                    evaluateBg.addSubview(lab)
                }
                backGroundtop = backGroundtop + 5
            }
            
           
            if backGroundtop>0{
                evaluateBg.frame =  CGRect(x: nameText.left, y: bottoms,width: bgwidth, height: backGroundtop)
               
                rowheights = evaluateBg.bottom + 15
            }else{
                rowheights = evaluateBut.bottom + 15
            }
            bottomLine.frame =  CGRect(x: 0, y: rowheights, width: kWidth, height: 10)
            rowheights = rowheights + 10
            
         //   BGview.height = rowheights
            model?.rowHeight = rowheights
        }
    }
    
    func creatLable(width:CGFloat,top:CGFloat,commentData:QRCommentDataModel)->CommentLabel  {
        let Text = CommentLabel(frame:  CGRect(x: 0, y: top, width: width, height: 0))
        Text.setModel(mod: commentData, width: width)
        Text.clickText = {mod in
            print(mod.circleCommentId)
            let  ewenTextView = EwenTextView.init(frame: CGRect.init(x: 0, y: kHeight - 49, width: kWidth, height: 49))
            ewenTextView.backgroundColor = UIColor(white: 0, alpha: 0.3)
            ewenTextView.setPlaceholderText("请输入文字")
            ewenTextView.tag = 10099
            if self.model?.manageType == 3{

                let win = UIApplication.shared.keyWindow
                if let input = win?.viewWithTag(10099){
                    input.resignFirstResponder()
                    input.removeFromSuperview()
                }else{
                    
                }
                win?.addSubview(ewenTextView)
                ewenTextView.textView.becomeFirstResponder()
                ewenTextView.ewenTextViewBlock = {(test) -> Void in
                    /*输入的内容在上方显示*/
                    self.CommentToOtherRequest(uId: mod.circleCommentId, text: test!)
                    /*移除*/
                    ewenTextView.resignFirstResponder()
                    ewenTextView.removeFromSuperview()
                }
            }else{
                
                let win = UIApplication.shared.keyWindow
                if let input = win?.viewWithTag(10099){
                    input.resignFirstResponder()
                    input.removeFromSuperview()
                }else{
                }
                win?.addSubview(ewenTextView)
                
                ewenTextView.textView.becomeFirstResponder()
                ewenTextView.ewenTextViewBlock = {(test) -> Void in
                    /*输入的内容在上方显示*/
                    self.CommentToOtherRequest(uId: mod.circleCommentId, text: test!)
                    /*移除*/
                    ewenTextView.resignFirstResponder()
                    ewenTextView.removeFromSuperview()
                }
            }
            
        }
        Text.clickLinkName = {mod in
            print(mod.circleCommentId)
        }
        return Text

    }
    lazy var niBut : UIButton = {
        let niBut = UIButton()
        niBut.setTitle("匿名", for: UIControlState.normal)
        //  niBut.setImage(UIImage(named:"pinglun"), for: .normal)
        //  niBut.addTarget(self, action: #selector(pingLun), for:.touchUpInside)
        niBut.backgroundColor = kfilterBlueColor
        niBut.setTitleColor(kBlueC, for: .normal)
        niBut.isHidden = true
        niBut.layer.cornerRadius = 12.5
        niBut.titleLabel?.font = kFontSize12
        return niBut
    }()
    lazy var BGview : UIView = {
        let BGview = UIView(frame:  CGRect(x: kLeftDis, y: AutoGetHeight(height: 10), width: kHaveLeftWidth-100, height: 200))
        BGview.backgroundColor = UIColor.yellow
        return BGview
    }()
    lazy var iconImg : UIImageView = {
        let iconImg =  UIImageView(frame:  CGRect(x: kLeftDis, y:AutoGetWidth(width: 15) , width: AutoGetWidth(width: 42), height:  AutoGetWidth(width: 42)))
        iconImg.layer.cornerRadius = AutoGetWidth(width: 21)
        iconImg.clipsToBounds = true
        iconImg.image = UIImage(named: "CQIndexPersonDefault")
        iconImg.isUserInteractionEnabled = true
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapTouchIn))
        iconImg.addGestureRecognizer(tapGes)
        return iconImg
    }()
    
    @objc func tapTouchIn(){
        if self.model?.manageType == 3{
            //同事圈
            if  nil == model?.createUserId || model?.createUserId == "0" {
                
            }else {
                //同事圈
                let vc = CQWorkInstrumentPersonInfoVC.init()
                vc.userId = (model?.createUserId)!
                vc.chatName = model!.realName
                vc.userModel =  CQDepartMentUserListModel.init(uId: model!.createUserId, realN: model!.realName, headImag: model!.headImg)
                 self.rootVc!.navigationController?.pushViewController(vc, animated: true)
            }

        }else{
            
            if  nil == model?.createUserId || model?.createUserId == "0" {
                
            }else {
                //同事圈
                let vc = CQWorkInstrumentPersonInfoVC.init()
                vc.userId = (model?.createUserId)!
                vc.chatName = model!.realName
                vc.userModel =  CQDepartMentUserListModel.init(uId: model!.createUserId, realN: model!.realName, headImag: model!.headImg)
                self.MrootVc!.rootNav!.navigationController?.pushViewController(vc, animated: true)
            }
          
        }
       
    }
    
    lazy var nameText : MLLinkLabel = {
        let Text = MLLinkLabel(frame:  CGRect(x: iconImg.right+friendCircle.kPadding, y: iconImg.top, width: 200, height: AutoGetHeight(height: 24)))
        Text.lineBreakMode = NSLineBreakMode.byCharWrapping
        Text.font = kFontSize14
        Text.delegate = self
        Text.numberOfLines = 1
        let linkDict = [NSAttributedStringKey.foregroundColor:UIColor.colorWithHexString(hex: "#1e5f91")]
        let activeLinkDict = [NSAttributedStringKey.backgroundColor : kProjectBgColor,NSAttributedStringKey.foregroundColor:klightGreyColor]
        Text.linkTextAttributes = linkDict
        Text.activeLinkTextAttributes = activeLinkDict
        Text.text = "小米"
        return Text
    }()
    
    lazy var timeText : MLLinkLabel = {
        let Text = MLLinkLabel(frame:  CGRect(x:  iconImg.right+friendCircle.kPadding, y: nameText.bottom, width: 200, height: AutoGetHeight(height: 18)))
        Text.font = kFontSize13
        Text.delegate = self
        Text.numberOfLines = 0
         Text.lineBreakMode = NSLineBreakMode.byCharWrapping
        let linkDict = [NSAttributedStringKey.foregroundColor:UIColor.colorWithHexString(hex: "#1e5f91")]
        let activeLinkDict = [NSAttributedStringKey.backgroundColor : kProjectBgColor,NSAttributedStringKey.foregroundColor:klightGreyColor]
        Text.linkTextAttributes = linkDict
        Text.activeLinkTextAttributes = activeLinkDict
        Text.textColor = UIColor.gray
        Text.text = "2019/02/04"
        return Text
    }()
    
    lazy var TextLab : MLLinkLabel = {
        let Text = MLLinkLabel(frame:  CGRect(x:  iconImg.right+AutoGetWidth(width: 10), y: nameText.bottom, width: 200, height: AutoGetHeight(height: 18)))
        Text.font = kFontSize15
        Text.delegate = self
        Text.numberOfLines = 0
         Text.lineBreakMode = NSLineBreakMode.byCharWrapping
        let linkDict = [NSAttributedStringKey.foregroundColor:UIColor.colorWithHexString(hex: "#1e5f91")]
        let activeLinkDict = [NSAttributedStringKey.backgroundColor : kProjectBgColor,NSAttributedStringKey.foregroundColor:klightGreyColor]
        Text.linkTextAttributes = linkDict
        Text.activeLinkTextAttributes = activeLinkDict
        Text.text = ""
        //Text.dataDetectorTypes =  MLDataDetectorTypes.attributedLink
       // MLLinkType
        Text.dataDetectorTypesOfAttributedLinkValue.remove(MLDataDetectorTypes.phoneNumber)
        Text.invalidateDisplayForLinks()
        return Text
    }()
    
//
    lazy var picView :QRNetImgPicView = {
        let pic =  QRNetImgPicView(width: kWidth-AutoGetWidth(width: 30+36+8+40))
        return pic
    }()
    lazy var zhufuView :QRZhufuView = {
        let zhufuView =  QRZhufuView(width: kWidth/3*2, numberOfRow: 4)
        zhufuView.isHidden = true
        return zhufuView
    }()
    
    lazy var evaluateBut : UIButton = {
        let but = UIButton()
        but.setImage(UIImage(named:"pinglun"), for: .normal)
        but.addTarget(self, action: #selector(pingLun), for:.touchUpInside)
        but.setTitleColor(UIColor.black, for: .normal)
        return but
    }()
    lazy var zanBut : UIButton = {
        let but = UIButton()
        but.setImage(UIImage(named:"CQWorkCircleCancelZan"), for: .normal)
        but.addTarget(self, action: #selector(zan), for:.touchUpInside)
        but.titleLabel?.font = kFontSize14
        but.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        but.setTitleColor(UIColor.black, for: .normal)
        return but
    }()
    //评论和点赞人明细

    lazy var evaluateBg : UIView = {
        let evaluateBg =  UIView(frame: CGRect.zero)
        evaluateBg.backgroundColor = UIColor.colorWithHexString(hex: "#f2f6fc")
        return evaluateBg
    }()

    //点赞人
    lazy var zanPeopleText : MLLinkLabel = {
        let Text = MLLinkLabel()
        Text.font = kFontSize14
         Text.lineBreakMode = NSLineBreakMode.byCharWrapping
        Text.delegate = self
        Text.numberOfLines = 0
        let linkDict = [NSAttributedStringKey.foregroundColor:UIColor.colorWithHexString(hex: "#1e5f91")]
        let activeLinkDict = [NSAttributedStringKey.backgroundColor : kProjectBgColor,NSAttributedStringKey.foregroundColor:klightGreyColor]
        Text.linkTextAttributes = linkDict
        Text.activeLinkTextAttributes = activeLinkDict
        Text.text = ""
        Text.isHidden = true
        return Text
    }()
    
    //线
     var evaluateBgLineView : UIView?


    lazy var bottomLine : UIView = {
        let bottomLine =  UIView(frame:  CGRect(x: 0, y: 0, width: kWidth, height: AutoGetWidth(width: 10)))
        bottomLine.backgroundColor = kProjectBgColor

        return bottomLine
    }()

    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.frame =  CGRect(x: kLeftDis, y: kLeftDis, width: kHaveLeftWidth, height: 80)
        
        contentView.backgroundColor = UIColor.white
       // contentView.addSubview(BGview)
        contentView.addSubview(iconImg)
        contentView.addSubview(nameText)
        contentView.addSubview(niBut)
        contentView.addSubview(timeText)
        contentView.addSubview(TextLab)
        contentView.addSubview(picView)
        contentView.addSubview(zhufuView)
        contentView.addSubview(zanBut)
        contentView.addSubview(evaluateBut)
        contentView.addSubview(evaluateBg)
        contentView.addSubview(bottomLine)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func pingLun(){
        print("评论")
        let  ewenTextView = EwenTextView.init(frame: CGRect.init(x: 0, y: kHeight - 49, width: kWidth, height: 49))
        ewenTextView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        ewenTextView.setPlaceholderText("请输入文字")
        ewenTextView.tag = 10099
        if self.model?.manageType == 3{

            let win = UIApplication.shared.keyWindow
            if let input = win?.viewWithTag(10099){
                input.resignFirstResponder()
                input.removeFromSuperview()
            }else{
                
            }
            win?.addSubview(ewenTextView)
            
        }else{

            let win = UIApplication.shared.keyWindow
            if let input = win?.viewWithTag(10099){
                input.resignFirstResponder()
                input.removeFromSuperview()
            }else{
                
            }
            win?.addSubview(ewenTextView)
        }
       
        
        
        ewenTextView.textView.becomeFirstResponder()
        ewenTextView.ewenTextViewBlock = {(test) -> Void in
            /*输入的内容在上方显示*/
            self.childCommentRequest(uId: (self.model?.circleArticleId)!, text: test!)
            /*移除*/
            ewenTextView.resignFirstResponder()
            ewenTextView.removeFromSuperview()

        }

    }
    
    
    //评论
    func childCommentRequest(uId:String,text:String) {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/circle/saveCircleComment",
            type: .post,
            param: ["userId":userID,
                    "circleArticleId":uId,
                    "commentContent":text],
            successCallBack: { (result) in
           
                if self.model?.manageType == 3{
                    self.loadSigleLineDatas(moreData: false, page: (self.model?.page)!)
                }else{
                    self.loadManageSigleLineDatas(moreData: false, page: (self.model?.page)!)
                }
        }) { (error) in
            
        }
    }
    
    //子评论
    func CommentToOtherRequest(uId:String,text:String) {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/circle/saveCircleChildComment",
            type: .post,
            param: ["userId":userID,
                    "circleCommentId":uId,
                    "commentContent":text],
            successCallBack: { (result) in
                
                if self.model?.manageType == 3{
                    self.loadSigleLineDatas(moreData: false, page: (self.model?.page)!)
                }else{
                    self.loadManageSigleLineDatas(moreData: false, page: (self.model?.page)!)
                }
        }) { (error) in
            
        }
    }
    
    @objc func zan(){
        self.zanRequest()
    }
    
    //点赞
    func zanRequest(){
        zanBut.isUserInteractionEnabled = false
        var laudMode = ""
        if model!.laudStatus {
            laudMode = "0"
        }else{
            laudMode = "1"
        }
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/circle/saveCircleLaud",
            type: .post,
            param: ["userId":userID,
                    "circleArticleId":(model?.circleArticleId)!,
                    "laudMode":laudMode],
            successCallBack: { (result) in
                
                if self.model?.manageType == 3{
                   self.loadSigleLineDatas(moreData: false, page: (self.model?.page)!)
                }else{
                   self.loadManageSigleLineDatas(moreData: false, page: (self.model?.page)!)
                }
                SVProgressHUD.showInfo(withStatus: result["message"].stringValue)
                self.zanBut.isUserInteractionEnabled = true
                
        }) { (error) in
             self.zanBut.isUserInteractionEnabled = true
        }
    }
    
    func loadManageSigleLineDatas(moreData:Bool,page:Int) {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/circle/getCircleManagerByType" ,
            type: .get,
            param: ["userId":userID,
                    "currentPage":page,
                    "rows":"10","type":self.model!.manageType],
            successCallBack: { (result) in
                var tempArray = [QRWorkMateCircleModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = QRWorkMateCircleModel(jsonData: modalJson) else {
                        return
                    }
                    modal.page = result["page"].intValue
                    tempArray.append(modal)
                }
                
                for (_,mod) in tempArray.enumerated(){
                    if  self.model?.circleArticleId == mod.circleArticleId{
                        mod.manageType = (self.model?.manageType)!
                        self.model = mod
                        
                        if self.model?.manageType == 3{
                            self.rootVc?.dataArray[self.index!.row] = self.model!
                            self.clickClosure!(self.index!)
                        }else{
                            self.MrootVc?.dataArray[self.index!.row] = self.model!
                            self.clickClosure!(self.index!)
                        }
                   
                        
                    }
                }
                
        }) { (error) in
            
        }
    }
    
    func loadSigleLineDatas(moreData:Bool,page:Int) {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/circle/getCircleArticleByPage" ,
            type: .get,
            param: ["userId":userID,
                    "currentPage":page,
                    "rows":"10"],
            successCallBack: { (result) in
                var tempArray = [QRWorkMateCircleModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = QRWorkMateCircleModel(jsonData: modalJson) else {
                        return
                    }
                    modal.page = result["page"].intValue
                    tempArray.append(modal)
                }
                
                for (_,mod) in tempArray.enumerated(){
                    if  self.model?.circleArticleId == mod.circleArticleId{
                        mod.manageType = (self.model?.manageType)!
                            self.model = mod
                        
                        if self.model?.manageType == 3{
                            self.rootVc?.dataArray[self.index!.row] = self.model!
                            self.clickClosure!(self.index!)
                        }else{
                            self.MrootVc?.dataArray[self.index!.row] = self.model!
                            self.clickClosure!(self.index!)
                        }
   
                    }
                }
                
        }) { (error) in
            
        }
    }
    
    
    
}
extension QRFriendCircleFrameCell : MLLinkLabelDelegate {
    func didClick(_ link: MLLink!, linkText: String!, linkLabel: MLLinkLabel!) {
//        //print(link.linkValue!)
//        let linkVal = link.linkValue!
//        let arr = linkVal.components(separatedBy: "|")
//        print(arr)
//        if arr.first == "dToken"{
//            print("点击在评论上面")
//            let  ewenTextView = EwenTextView.init(frame: CGRect.init(x: 0, y: kHeight - 49, width: kWidth, height: 49))
//            ewenTextView.backgroundColor = UIColor(white: 0, alpha: 0.3)
//            ewenTextView.setPlaceholderText("请输入文字")
//            if let input = rootVc?.inputViewEW{
//                input.resignFirstResponder()
//                input.removeFromSuperview()
//            }else{
//
//            }
//            rootVc!.view.addSubview(ewenTextView)
//            rootVc?.inputViewEW = ewenTextView
//            ewenTextView.textView.becomeFirstResponder()
//            ewenTextView.ewenTextViewBlock = {(test) -> Void in
//                /*输入的内容在上方显示*/
//                self.CommentToOtherRequest(uId: arr[1], text: test!)
//                /*移除*/
//                ewenTextView.resignFirstResponder()
//                ewenTextView.removeFromSuperview()
//            }
//        }else{
//            print("名字上面")
//        }
    }
    
}

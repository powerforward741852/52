//
//  QRZanDetailCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/19.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRZanDetailCell: UITableViewCell {
    var evaluateBgLineView : UIView?
    weak var rootVc : QRZanVC?
    var index : IndexPath?
    //声明闭包
    typealias clickBtnClosure = (_ InPath:IndexPath) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    
    lazy var BGview : UIView = {
        let BGview = UIView(frame:  CGRect(x: kLeftDis, y: AutoGetHeight(height: 10), width: kHaveLeftWidth, height: 200))
        BGview.backgroundColor = UIColor.white
        return BGview
    }()
    
    lazy var iconImg : UIImageView = {
        let iconImg = UIImageView(frame:  CGRect(x: (kWidth-AutoGetWidth(width: 36))/2, y: AutoGetHeight(height: 15), width: AutoGetWidth(width: 36), height: AutoGetWidth(width: 36)))
        iconImg.image = UIImage(named: "personDefaultIcon")
        iconImg.layer.cornerRadius = AutoGetWidth(width: 18)
        iconImg.clipsToBounds = true
        
        iconImg.isUserInteractionEnabled = true
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapTouchIn))
        iconImg.addGestureRecognizer(tapGes)
        return iconImg
    }()
    


    @objc func tapTouchIn(){
        
        let vc = CQWorkInstrumentPersonInfoVC.init()
        //vc.userId = (modelc?.toUserId)!
        vc.userId = (modelc?.toUserId)!
        vc.chatName = modelc!.realName
        vc.userModel =  CQDepartMentUserListModel.init(uId: modelc!.toUserId, realN: modelc!.realName, headImag: modelc!.headImg)
        self.rootVc!.navigationController?.pushViewController(vc, animated: true)
    }
   
    
    lazy var nameLable :MLLinkLabel = {
        let nameLable = MLLinkLabel()
        nameLable.frame =  CGRect(x: kLeftDis, y: iconImg.bottom, width: kHaveLeftWidth, height: AutoGetHeight(height: 20))
        nameLable.font = kFontSize14
        nameLable.delegate = self
        nameLable.numberOfLines = 0
        nameLable.textAlignment = .center
        nameLable.textColor = UIColor.black
        let linkDict = [NSAttributedStringKey.foregroundColor:UIColor.colorWithHexString(hex: "#1e5f91")]
        let activeLinkDict = [NSAttributedStringKey.backgroundColor : kProjectBgColor,NSAttributedStringKey.foregroundColor:klightGreyColor]
        nameLable.linkTextAttributes = linkDict
        nameLable.activeLinkTextAttributes = activeLinkDict
        nameLable.text = ""
        return nameLable
    }()
    lazy var textLable : MLLinkLabel = {
        let textLable = MLLinkLabel()
        textLable.font = kFontSize15
        textLable.delegate = self
         nameLable.textColor = UIColor.black
        textLable.numberOfLines = 0
        textLable.lineBreakMode = NSLineBreakMode.byCharWrapping
        let linkDict = [NSAttributedStringKey.foregroundColor:UIColor.colorWithHexString(hex: "#1e5f91")]
        let activeLinkDict = [NSAttributedStringKey.backgroundColor : kProjectBgColor,NSAttributedStringKey.foregroundColor:klightGreyColor]
        textLable.linkTextAttributes = linkDict
        textLable.activeLinkTextAttributes = activeLinkDict
        textLable.text = "teteteashjkdalskdjalkdjasljaslkajdskjslaslsajlsadjsdalaksdj"
        return textLable
    }()
    
    lazy var lineView : UIView = {
        let lineView = UIView(frame:  CGRect(x: kLeftDis, y: 0, width: kHaveLeftWidth, height: 1))
        lineView.backgroundColor = kLineColor
        return lineView
    }()
    
    lazy var picView :QRNetImgPicView = {
        let pic =  QRNetImgPicView(width: kWidth/3*2)
        return pic
    }()
    
    lazy var jingLiLable :UILabel = {
        let jingLiLable = UILabel(title: "经理", textColor: UIColor.black, fontSize: 15)
        jingLiLable.numberOfLines = 1
        jingLiLable.textAlignment = .left
        return jingLiLable
    }()
    lazy var positionLable :UILabel = {
        let positionLable = UILabel(title: "项目经理", textColor: UIColor.colorWithHexString(hex: "#c1c1c1"), fontSize: 12)
        positionLable.numberOfLines = 1
        positionLable.textAlignment = .left
        return positionLable
    }()
    lazy var timeLable :UILabel = {
        let timeLable = UILabel(title: "2019.03.19", textColor:  UIColor.colorWithHexString(hex: "#c1c1c1"), fontSize: 12)
        timeLable.numberOfLines = 1
        timeLable.textAlignment = .left
        return timeLable
    }()
    lazy var zanBut : UUButton = {
        let zanBut = UUButton(frame:  CGRect(x: 0, y: 0, width: 60, height: 25))
        zanBut.contentAlignment = UUContentAlignment.normal
        zanBut.setImage(UIImage(named: "dianzh"), for: UIControlState.normal)
        zanBut.setTitleColor(UIColor.black, for: UIControlState.normal)
        //zanBut.setTitle("2", for: UIControlState.normal)
        zanBut.addTarget(self, action: #selector(zanClick), for: UIControlEvents.touchUpInside)
        return zanBut
    }()
    lazy var evaluateBut : UIButton = {
        let but = UIButton()
        but.setImage(UIImage(named:"pinglun"), for: .normal)
        but.addTarget(self, action: #selector(pingLun), for:.touchUpInside)
        but.setTitleColor(UIColor.black, for: .normal)
        return but
    }()
    lazy var evaluateBg : UIView = {
        let evaluateBg =  UIView(frame: CGRect.zero)
        evaluateBg.backgroundColor = UIColor.colorWithHexString(hex: "#f2f6fc")
        return evaluateBg
    }()
//    var model :QRZanModel?{
//        didSet{
//
//            if model?.laudStatus == true{
//                zanBut.setTitle(model?.admireNum, for: UIControlState.normal)
//                zanBut.setImage(UIImage(named: "dianzh"), for: UIControlState.normal)
//            }else{
//                zanBut.setImage(UIImage(named: "dianzan"), for: UIControlState.normal)
//                zanBut.setTitle(model?.admireNum, for: UIControlState.normal)
//            }
//
//           iconImg.sd_setImage(with: URL(string: model?.headImg ?? ""), placeholderImage: UIImage(named: "CQIndexPersonDefault"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
//            nameLable.text = model?.createName
//
//            //富文本
//            let contentA = NSMutableAttributedString(string:"")
//            if let cont = model?.content{
//                contentA.append(NSMutableAttributedString(string:cont))
//            }else{
//
//            }
//            let attach = NSTextAttachment()
//            attach.image = UIImage(named: "dianzh")
//            attach.bounds =  CGRect(x: 0, y: -1, width: (attach.image?.size.width)!, height: (attach.image?.size.height)!)
//            var tempAtt = NSMutableAttributedString(string: "")
//            let img = NSAttributedString(attachment: attach)
//            let wo = NSMutableAttributedString(string: " 我为")
//
//             var str = " @"
//            if let realn = model?.realName{
//                str = str + realn
//            }else{
//
//            }
//
//            let name = NSMutableAttributedString(string:str )
//            let dic = [NSAttributedStringKey.foregroundColor:kBlueC] as [NSAttributedStringKey : Any]
//            name.setAttributes(dic, range: (str as NSString).range(of: str))
//
//
//            let zan = NSMutableAttributedString(string: " 点赞\n")
//            tempAtt.append(img)
//            tempAtt.append(wo)
//            tempAtt.append(name)
//            tempAtt.append(zan)
//
//          //间距
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.lineSpacing = 6
//            paragraphStyle.alignment = .left
//            tempAtt.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, tempAtt.length))
//
//            tempAtt.append(contentA)
//            textLable.attributedText = tempAtt
//
//            //图片
//            let imgs = model?.picurlData
//            picView.imags = imgs
//            if let count = imgs?.count, count > 0 {
//                let rowNum = (count - 1)/(picView.numOfPerRow) + 1
//                let pictureViewHeight = CGFloat(rowNum) * picView.imageHeight + picView.margin * (CGFloat(rowNum)-1)
//                //更新UI
//                picView.mas_updateConstraints({ (make) in
//                    make?.left.mas_equalTo()(contentView)?.setOffset(AutoGetWidth(width: 71))
//                    make?.right.mas_equalTo()(contentView)?.setOffset(-AutoGetWidth(width: 30))
//                    make?.top.mas_equalTo()(textLable.mas_bottom)?.setOffset(10)
//                    make?.height.mas_equalTo()(pictureViewHeight)
//                })
//            }else{
//                picView.mas_updateConstraints({ (make) in
//                    make?.left.mas_equalTo()(contentView)?.setOffset(AutoGetWidth(width: 71))
//                    make?.right.mas_equalTo()(contentView)?.setOffset(-AutoGetWidth(width: 30))
//                    make?.top.mas_equalTo()(textLable.mas_bottom)?.setOffset(0)
//                    make?.height.mas_equalTo()(0)
//                })
//            }
//            jingLiLable.text = model?.createName
//            jingLiLable.sizeToFit()
//            positionLable.text = model?.positionName
//
//            timeLable.text = model?.createDate
//        }
//
//    }
    
    
    var modelc : QRZanModel?{
        didSet{
            
            iconImg.sd_setImage(with: URL(string: modelc?.headImg ?? ""), placeholderImage: UIImage(named: "CQIndexPersonDefault"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
            nameLable.text = modelc?.realName
            
            var bottoms = nameLable.bottom + friendCircle.kPadding
            var rowheights:CGFloat = 0
            //正文 //富文本
            let contentA = NSMutableAttributedString(string:"")
            if let cont = modelc?.content{
                var str = cont
                if cont.hasSuffix("\n"){
                  //  str.removeLast()
//                    str = str.fromBase64()!
                    str.removeLast()
                    if str.fromBase64() == nil{
                        str =  str.replacingOccurrences(of: "\n", with: "").fromBase64()!
                    }else{
                        str = str.fromBase64()!
                    }
                }else{
                   
                }
                
                
                contentA.append(NSMutableAttributedString(string:str))
            }else{
            }
            let attach = NSTextAttachment()
            attach.image = UIImage(named: "dianzh")
            attach.bounds =  CGRect(x: 0, y: -1, width: (attach.image?.size.width)!, height: (attach.image?.size.height)!)
            let tempAtt = NSMutableAttributedString(string: "")
            let img = NSAttributedString(attachment: attach)
            let wo = NSMutableAttributedString(string: " 为")
            
            var str = " @"
            if let realn = modelc?.realName{
                str = str + realn
            }else{
                
            }
            
            let name = NSMutableAttributedString(string:str )
            let dic = [NSAttributedStringKey.foregroundColor:kBlueC] as [NSAttributedStringKey : Any]
            name.setAttributes(dic, range: (str as NSString).range(of: str))
            
            
            let zan = NSMutableAttributedString(string: " 点赞")
            
            tempAtt.append(img)
            tempAtt.append(wo)
            tempAtt.append(name)
            tempAtt.append(zan)
            if modelc?.content == ""{
                
            }else{
                tempAtt.append(NSAttributedString(string: "\n"))
            }
            //间距
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            paragraphStyle.alignment = .left
            tempAtt.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, tempAtt.length))
            
            
            let paragraphStylecontent = NSMutableParagraphStyle()
            paragraphStylecontent.lineSpacing = 4
            paragraphStylecontent.alignment = .left
            contentA.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStylecontent, range: NSMakeRange(0, contentA.length))
            tempAtt.append(contentA)
            textLable.attributedText = tempAtt
               
            textLable.isHidden = false
            let textSize = textLable.preferredSize(withMaxWidth: kWidth-kLeftDis*4-10)
            textLable.frame =  CGRect(x: kLeftDis*2, y: bottoms, width:kWidth-kLeftDis*4 , height: textSize.height)
            if tempAtt.length == 0{
                bottoms = textLable.bottom
            }else{
                bottoms = textLable.bottom + friendCircle.kPadding
            }
            
            //图片
            let imgs = modelc?.picurlData
            picView.imags = imgs
            if let count = imgs?.count, count > 0 {
                let rowNum = (count - 1)/(picView.numOfPerRow) + 1
                let pictureViewHeight = CGFloat(rowNum) * picView.imageHeight + picView.margin * (CGFloat(rowNum)-1)
                //更新UI
                picView.isHidden = false
                picView.frame =  CGRect(x: kLeftDis*2, y: bottoms, width: picView.pictureViewWidth, height: pictureViewHeight)
                bottoms = picView.bottom + friendCircle.kPadding
               
            }else{
                picView.frame =  CGRect(x: kLeftDis*2, y: bottoms, width: picView.pictureViewWidth, height: 0)
                bottoms = picView.bottom
                picView.isHidden = true
            }
            //线
            lineView.frame =  CGRect(x: kLeftDis, y: bottoms+AutoGetHeight(height: 10), width: kHaveLeftWidth, height: AutoGetHeight(height: 1))
            bottoms = lineView.bottom
           //经理
            jingLiLable.frame =  CGRect(x: kLeftDis*2, y: bottoms+AutoGetHeight(height: 12), width: 40, height: AutoGetHeight(height: 20))
            jingLiLable.text = modelc?.createName
            jingLiLable.sizeToFit()
            //职位
            positionLable.frame =  CGRect(x: jingLiLable.right+5, y: bottoms+AutoGetHeight(height: 15), width: kHaveLeftWidth, height: AutoGetHeight(height: 1))
            positionLable.text = modelc?.positionName
            positionLable.sizeToFit()
            bottoms = jingLiLable.bottom
            //时间
            timeLable.frame =  CGRect(x: kLeftDis*2, y: bottoms+AutoGetHeight(height: 12), width: kHaveLeftWidth, height: AutoGetHeight(height: 1))
            timeLable.text = modelc?.createDate
            timeLable.sizeToFit()
            bottoms = timeLable.bottom + AutoGetHeight(height: 10)
            
            //时间
            zanBut.frame =  CGRect(x: kWidth-kLeftDis-40-kLeftDis, y: positionLable.bottom-AutoGetHeight(height: 5), width: 40, height: 25)
            //赞图变换
            if (modelc?.laudStatus)! {
                zanBut.setImage(UIImage.init(named: "dianzh"), for: .normal)
            }else{
                zanBut.setImage(UIImage.init(named: "dianzan"), for: .normal)
            }
            
            evaluateBut.frame =  CGRect(x: kWidth-kLeftDis-80-10-kLeftDis, y: zanBut.top, width: 40, height: 25)
         
         //评论和点赞
            //背景高度
            evaluateBg.frame = CGRect.zero
            var backGroundtop : CGFloat = 0;
            let bgwidth = kWidth-AutoGetWidth(width: 15)*4
            evaluateBg.removeAllSubviews()
            //点赞
            if modelc?.laudUserData.count == 0{
                
            }else{
                let zanUsers = modelc?.laudUserData
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
            if (modelc?.commentData.count)!>0{
                if modelc?.laudNum != "0"{
                    self.evaluateBgLineView?.isHidden = false
                }
                
                backGroundtop = backGroundtop + 5
                for (_,value) in (modelc?.commentData.enumerated())!{
                    let lab = creatLable(width: bgwidth, top: backGroundtop, commentData: value)
                    backGroundtop = backGroundtop + lab.height
                    evaluateBg.addSubview(lab)
                }
                backGroundtop = backGroundtop + 5
            }
            
            
            if backGroundtop>0{
                evaluateBg.frame =  CGRect(x: AutoGetWidth(width: 15)*2, y: bottoms,width: bgwidth, height: backGroundtop)
                
                rowheights = evaluateBg.bottom + 5
            }else{
                rowheights = evaluateBut.bottom + 5
            }
            
            
            
            
            
            BGview.height = rowheights
            bottoms = BGview.bottom
            modelc?.rowHeight = bottoms
                
            
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

//            if let input = self.rootVc?.inputViewEW{
//                input.resignFirstResponder()
//                input.removeFromSuperview()
//            }else{
//
//            }
//            self.rootVc!.view.addSubview(ewenTextView)
//            self.rootVc?.inputViewEW = ewenTextView
            ewenTextView.tag = 10099
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
//                /*移除*/
                ewenTextView.resignFirstResponder()
                ewenTextView.removeFromSuperview()
            }
            


        }
        Text.clickLinkName = {mod in
            print(mod.circleCommentId)
        }
        return Text
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = kProjectBgColor
         self.contentView.addSubview(BGview)
        self.contentView.addSubview(iconImg)
        self.contentView.addSubview(nameLable)
        self.contentView.addSubview(textLable)
        self.contentView.addSubview(picView)
        self.contentView.addSubview(lineView)
        self.contentView.addSubview(jingLiLable)
        self.contentView.addSubview(positionLable)
        self.contentView.addSubview(timeLable)
        self.contentView.addSubview(zanBut)
        self.contentView.addSubview(evaluateBut)
        self.contentView.addSubview(evaluateBg)
//        BGview.mas_makeConstraints { (make) in
//            make?.left.mas_equalTo()(self.contentView.mas_left)?.setOffset(kLeftDis)
//            make?.top.mas_equalTo()(self.contentView.mas_top)?.setOffset(AutoGetHeight(height: 10))
//            make?.right.mas_equalTo()(self.contentView.mas_right)?.setOffset(-kLeftDis)
//        }
//
//        iconImg.mas_makeConstraints { (make) in
//            make?.left.mas_equalTo()(BGview.mas_left)?.setOffset(AutoGetWidth(width: 15))
//            make?.top.mas_equalTo()(BGview.mas_top)?.setOffset(AutoGetWidth(width: 10))
//            make?.width.mas_equalTo()(AutoGetWidth(width: 36))
//            make?.height.mas_equalTo()(AutoGetWidth(width: 36))
//        }
//
//        nameLable.mas_makeConstraints { (make) in
//            make?.centerY.mas_equalTo()(iconImg.mas_centerY)
//            make?.left.mas_equalTo()(self.iconImg.mas_right)?.setOffset(5)
//            make?.right.mas_equalTo()(BGview.mas_right)?.setOffset(-10)
//           // make?.bottom.mas_equalTo()(contentView.mas_bottom)?.setOffset(-10)
//        }
//        textLable.mas_makeConstraints { (make) in
//            make?.top.mas_equalTo()(nameLable.mas_bottom)?.setOffset(15)
//            make?.left.mas_equalTo()(nameLable.mas_left)
//            make?.right.mas_equalTo()(BGview.mas_right)?.setOffset(-10)
//           // make?.bottom.mas_equalTo()(contentView.mas_bottom)?.setOffset(-10)
//        }
//        picView.mas_makeConstraints { (make) in
//            make?.left.mas_equalTo()(contentView.mas_left)?.setOffset(AutoGetWidth(width: 71))
//            make?.right.mas_equalTo()(contentView.mas_right)?.setOffset(-AutoGetWidth(width: 30))
//            make?.top.mas_equalTo()(textLable.mas_bottom)?.setOffset(8)
//           // make?.height.mas_equalTo()(100)
//        }
//        lineView.mas_makeConstraints { (make) in
//            make?.top.mas_equalTo()(self.picView.mas_bottom)?.setOffset(AutoGetWidth(width: 20))
//            make?.left.mas_equalTo()(BGview.mas_left)
//            make?.right.mas_equalTo()(BGview.mas_right)
//            make?.height.mas_equalTo()(1)
//        }
//
//        jingLiLable.mas_makeConstraints { (make) in
//            make?.top.mas_equalTo()(lineView.mas_bottom)?.setOffset(12)
//            make?.left.mas_equalTo()(BGview.mas_left)?.setOffset(10)
//           // make?.right.mas_equalTo()(BGview.mas_right)?.setOffset(-10)
//            make?.height.mas_equalTo()(AutoGetWidth(width: 20))
//            //make?.width.mas_equalTo()(AutoGetWidth(width: 60))
//        }
//        positionLable.mas_makeConstraints { (make) in
//            make?.top.mas_equalTo()(lineView.mas_bottom)?.setOffset(12)
//            make?.left.mas_equalTo()(jingLiLable.mas_right)?.setOffset(5)
//            make?.right.mas_equalTo()(BGview.mas_right)?.setOffset(-10)
//            make?.height.mas_equalTo()(20)
//        }
//        timeLable.mas_makeConstraints { (make) in
//            make?.top.mas_equalTo()(jingLiLable.mas_bottom)?.setOffset(5)
//            make?.left.mas_equalTo()(BGview.mas_left)?.setOffset(10)
//            make?.right.mas_equalTo()(BGview.mas_right)?.setOffset(-10)
//            make?.height.mas_equalTo()(20)
//            make?.bottom.mas_equalTo()(contentView.mas_bottom)?.setOffset(-10)
//        }
//
//        zanBut.mas_makeConstraints { (make) in
//            make?.top.mas_equalTo()(lineView.mas_bottom)?.setOffset(15)
//            make?.right.mas_equalTo()(BGview.mas_right)?.setOffset(-10)
//            make?.width.mas_equalTo()(60)
//            make?.height.mas_equalTo()(25)
//           // make?.right.mas_equalTo()(BGview.mas_right)?.setOffset(-10)
//        }
//
//        BGview.mas_updateConstraints { (make) in
//            make?.bottom.mas_equalTo()(timeLable.mas_bottom)?.setOffset(10)
//        }

       
    }
    
    //点赞
   @objc func zanClick(){
        zanBut.isUserInteractionEnabled = false
        var laudMode = ""
        if modelc!.laudStatus {
            laudMode = "0"
        }else{
            laudMode = "1"
        }
//        self.modelc?.laudUserData.append("阿萨德爸爸"+"\(self.modelc!.laudUserData.count)")
//        self.rootVc?.dataArr[(index?.row)!] = self.modelc!
//        self.clickClosure!(self.index!)
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/circle/saveCircleLaud",
            type: .post,
            param: ["userId":userID,
                    "circleArticleId":(modelc?.id)!,
                    "laudMode":laudMode],
            successCallBack: { (result) in
                
               
                self.loadSigleLineDatas(moreData: false, page: (self.modelc?.page)!)
//                self.modelc?.laudStatus = !(self.modelc?.laudStatus)!
//                self.modelc?.laudUserData.append(userName)
//                self.rootVc?.dataArr[self.index!.row] = self.modelc!
//                self.clickClosure!(self.index!)
                SVProgressHUD.showInfo(withStatus: result["message"].stringValue)
                self.zanBut.isUserInteractionEnabled = true
                
        }) { (error) in
             self.zanBut.isUserInteractionEnabled = true
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    
    
    @objc func pingLun(){
        print("评论")
//        let mod = QRCommentDataModel()
//        mod.commentContent = "pin1"+"\(self.modelc!.commentData.count)"
//        mod.commentUserFrom = ""
//        mod.commentUserTo = ""
//        self.modelc?.commentData.append(mod)
//        self.rootVc?.dataArr[(index?.row)!] = self.modelc!
//        self.clickClosure!(self.index!)
            let  ewenTextView = EwenTextView.init(frame: CGRect.init(x: 0, y: kHeight - 49, width: kWidth, height: 49))
            ewenTextView.backgroundColor = UIColor(white: 0, alpha: 0.3)
            ewenTextView.setPlaceholderText("请输入文字")
    
//            if let input = rootVc?.inputViewEW{
//                input.resignFirstResponder()
//                input.removeFromSuperview()
//            }else{
//
//            }
//            rootVc!.view.addSubview(ewenTextView)
//            rootVc?.inputViewEW = ewenTextView
            ewenTextView.tag = 10099
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
                self.childCommentRequest(uId: (self.modelc?.id)!, text: test!)
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
                // self.loadDatas(page: Int((self.currentCount! + 1)/10))
                //  self.loadSigleLineDatas(moreData: false, page: (self.model?.page)!)
                
                self.loadSigleLineDatas(moreData: false, page: (self.modelc?.page)!)
               
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
                // self.loadDatas(page: Int((self.currentCount! + 1)/10))
                //   self.loadSigleLineDatas(moreData: false, page: (self.model?.page)!)
              
                 self.loadSigleLineDatas(moreData: false, page: (self.modelc?.page)!)
                
        }) { (error) in
            
        }
    }
    
  
    func loadSigleLineDatas(moreData:Bool,page:Int) {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/admir/getAdmirByPage" ,
            type: .get,
            param: ["userId":userID,
                    "currentPage":page,
                    "rows":"10"],
            successCallBack: { (result) in

                var tempArray = [QRZanModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = QRZanModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                    modal.page = result["page"].intValue
                }
                
                for (_,mod) in tempArray.enumerated(){
                    if  self.modelc?.id == mod.id{
                        self.modelc = mod
                        self.rootVc?.dataArr[self.index!.row] = self.modelc!
                        self.clickClosure!(self.index!)

                    }
                }

        }) { (error) in

        }
    }
    
}
extension QRZanDetailCell : MLLinkLabelDelegate{
    func didClick(_ link: MLLink!, linkText: String!, linkLabel: MLLinkLabel!) {
        
    }
}

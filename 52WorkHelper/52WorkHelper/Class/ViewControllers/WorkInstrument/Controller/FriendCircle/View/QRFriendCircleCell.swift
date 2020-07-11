//
//  QRFriendCircleCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/11/1.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRFriendCircleCell: UITableViewCell {
    var rootVc : QRWorkmateCircleVC?
    var index : IndexPath?
    //声明闭包
    typealias clickBtnClosure = (_ InPath:IndexPath) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    
    var model :QRWorkMateCircleModel?{
        didSet{
            //固定不动 .//头像
            if let name = model?.headImg {
                statusView.iconImageView.sd_setImage(with: URL(string: name), placeholderImage:UIImage(named:"CQIndexPersonDefault") , options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
            }else{
                statusView.iconImageView.sd_setImage(with: URL(string: ""), placeholderImage:UIImage(named:"CQIndexPersonDefault") , options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
            }
            
            
            
            if let personName = model?.realName {
                statusView.userName.text = personName
            }else{
                statusView.creatTime.text = ""
            }
            //时间
            
            if let followNametime = model?.differTime {
                statusView.creatTime.text = followNametime
            }else{
                statusView.creatTime.text = ""
            }
            
            //发布内容
            if let content = model?.articleContent {
                
                let contentA = NSMutableAttributedString(string: content)
               // let dic = [NSAttributedStringKey.foregroundColor:kBlueC] as [NSAttributedStringKey : Any]
               // tempAtt.setAttributes(dic, range: (personstr as NSString).range(of: personstr))
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
                    let zan = NSMutableAttributedString(string: " 点赞\n\n")
                    tempAtt.append(img)
                    tempAtt.append(wo)
                    tempAtt.append(name)
                    tempAtt.append(zan)
                    tempAtt.append(contentA)
                     statusView.statusText.attributedText = tempAtt
                }else{
                    statusView.statusText.attributedText = contentA
                }
                
            }else{
               // statusView.statusText.text = ""
                statusView.statusText.attributedText = NSMutableAttributedString(string: "")
            }
           
            statusView.statusText.mas_updateConstraints { (make) in
                make?.left.mas_equalTo()(statusView.mas_left)?.setOffset(AutoGetWidth(width: 36+15+15))
            }
            
            //根据数组的图片数量来处理图片的高度
            /// 计算配图视图的大小
            let imgs = model?.picurlData
            picView.imags = imgs
            if let count = imgs?.count, count > 0 {
                let rowNum = (count - 1)/(cellLayout.numOfPerRow) + 1
                let pictureViewHeight = CGFloat(rowNum) * cellLayout.imageHeight + cellLayout.margin * (CGFloat(rowNum)-1)
                //   pictureViewSize = CGSizeMake(cellLayout.pictureViewWith, pictureViewHeight)
                //更新UI
                picView.mas_updateConstraints({ (make) in
                    make?.left.mas_equalTo()(contentView)?.setOffset(AutoGetWidth(width: 15))
                    make?.right.mas_equalTo()(contentView)?.setOffset(-AutoGetWidth(width: 15))
                    make?.top.mas_equalTo()(statusView.mas_bottom)?.setOffset(10)
                    make?.height.mas_equalTo()(pictureViewHeight)
                    make?.width.mas_equalTo()(cellLayout.pictureViewWith)
                    // make?.bottom.mas_equalTo()(contentView)?.setOffset(-10)
                })
            }else{
                picView.mas_updateConstraints({ (make) in
                    make?.left.mas_equalTo()(contentView)?.setOffset(AutoGetWidth(width: 15))
                    make?.right.mas_equalTo()(contentView)?.setOffset(-AutoGetWidth(width: 15))
                    make?.top.mas_equalTo()(statusView.mas_bottom)?.setOffset(10)
                    make?.height.mas_equalTo()(0)
                })
            }

           
            
            if (model?.laudStatus)! {
                if model?.type == 1 || model?.type == 2{
                   zanBut.setImage(UIImage.init(named: "dianzh"), for: .normal)
                }else{
                  zanBut.setImage(UIImage.init(named: "CQWorkCircleZan"), for: .normal)
                }
            }else{
                if model?.type == 1 || model?.type == 2{
                     zanBut.setImage(UIImage.init(named: "dianzan"), for: .normal)
                }else{
                    zanBut.setImage(UIImage.init(named: "CQWorkCircleCancelZan"), for: .normal)
                }
            }
          
            // 取出数据,转换成String,判断点赞人数和评论人数,如果都为0的话更新布局为按钮最下面,否则a布局不变
            //点赞人
            if model?.laudNum == "0"{
                zanPeopleText.text = ""
                zanPeopleText.mas_updateConstraints { (make) in
                    make?.top.mas_equalTo()(evaluateBg.mas_top)?.setOffset(0)
                }
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

                zanPeopleText.attributedText = all
                
                zanPeopleText.mas_updateConstraints { (make) in
                    make?.top.mas_equalTo()(evaluateBg.mas_top)?.setOffset(5)
                }
              //  zanPeopleText.sizeToFit()
            }
            

          
            //评论
            if (model?.commentData.count)! == 0 {
                self.evaluateBgLineView.isHidden = true
                commentText.text = ""
//                commentText.mas_updateConstraints { (make) in
//                    make?.top.mas_equalTo()(zanPeopleText.mas_bottom)?.setOffset(0)
//                }
                if model?.laudNum == "0"{
                    commentText.mas_updateConstraints { (make) in
                        make?.top.mas_equalTo()(zanPeopleText.mas_bottom)?.setOffset(0)
                        make?.bottom.mas_equalTo()(evaluateBg.mas_bottom)?.setOffset(0)
                    }
                }else{
                    commentText.mas_updateConstraints { (make) in
                        make?.top.mas_equalTo()(zanPeopleText.mas_bottom)?.setOffset(5)
                        make?.bottom.mas_equalTo()(evaluateBg.mas_bottom)?.setOffset(0)
                    }
                }
            }else{
                if model?.laudNum == "0"{
                    self.evaluateBgLineView.isHidden = true
                    commentText.mas_updateConstraints { (make) in
                        make?.top.mas_equalTo()(zanPeopleText.mas_bottom)?.setOffset(5)
                        make?.bottom.mas_equalTo()(evaluateBg.mas_bottom)?.setOffset(-5)
                    }
                }else{
                    self.evaluateBgLineView.isHidden = false
                    commentText.mas_updateConstraints { (make) in
                        make?.top.mas_equalTo()(zanPeopleText.mas_bottom)?.setOffset(10)
                        make?.bottom.mas_equalTo()(evaluateBg.mas_bottom)?.setOffset(-5)
                    }
                }

                let evaluates = (model?.commentData)!
                let attComment = NSMutableAttributedString(string: "")
                for (index,value) in evaluates.enumerated(){
                    var tempComment = value.commentUserFrom
                    let token = value.circleCommentId+"|"+value.commentUserFrom+"|"+value.commentUserTo


                    let tempCommentUserFrom = NSMutableAttributedString(string: value.commentUserFrom)
                    //第一人
                    let dic = [NSAttributedStringKey.foregroundColor:UIColor.black,NSAttributedStringKey.link : token] as [NSAttributedStringKey : Any]
                    tempCommentUserFrom.setAttributes(dic, range:(value.commentUserFrom as NSString).range(of: value.commentUserFrom))
                    if value.commentUserTo == ""{
                        tempComment = tempComment! + ":"
                        let mao = NSMutableAttributedString(string: ":")
                     //冒号
                        let dic = [NSAttributedStringKey.foregroundColor:UIColor.black,NSAttributedStringKey.link : token] as [NSAttributedStringKey : Any]
                        mao.setAttributes(dic, range:(":" as NSString).range(of:":"))
                        tempCommentUserFrom.append(mao)
                    }else{
                        tempComment = tempComment! + "回复"
                        tempCommentUserFrom.append(NSAttributedString(string: "回复"))

                        //第2人
                        let tempTo = NSMutableAttributedString(string: value.commentUserTo+":")
                        let dic = [NSAttributedStringKey.foregroundColor:UIColor.black,NSAttributedStringKey.link : token] as [NSAttributedStringKey : Any]
                        tempComment = tempComment! + value.commentUserTo + ":"
                        tempTo.setAttributes(dic, range:(value.commentUserTo+":" as NSString).range(of:value.commentUserTo+":"))
                        tempCommentUserFrom.append(tempTo)
                    }

                    let tempCommentData = NSMutableAttributedString(string: value.commentContent)
                    tempComment = tempComment! + value.commentContent
                    //datatoken
                    let dataToken = "dToken|" + value.circleCommentId + "|" + value.commentUserFrom
                    tempCommentData.addAttributes([NSAttributedStringKey.link : dataToken], range: (value.commentContent as NSString).range(of:value.commentContent))
                    commentText.beforeAddLinkBlock = {link in
                        if link!.linkValue.hasPrefix("dToken"){
                            link!.linkTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black]
                            link!.activeLinkTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black]
                        }
                    }
                    
                    
                    tempCommentUserFrom.append(tempCommentData)


                    //空位补齐空格键
                     let widthspace =  getTexWidth(textStr: " ", font: kFontSize14, height: 20)
                    print(widthspace)
                    let widths =  getTexWidth(textStr: tempComment!, font: kFontSize14, height: 20)
                    print(widths)

                    let tempStrS = NSMutableAttributedString(string: "")
                    var temps = ""
                   // if commentText.width > widths{
                    if (kWidth-AutoGetWidth(width: 101)) > widths{
                        let i = ((kWidth-AutoGetWidth(width: 101)-widths))/widthspace
                        for _ in 0...Int(i){
                            tempStrS.append(NSAttributedString(string: " "))
                            temps.append(" ")
                        }
                    }else{
                       
                    }

                    tempStrS.addAttributes([NSAttributedStringKey.link : dataToken], range: (temps as NSString).range(of:temps))

                    if index == evaluates.count-1{
                         tempCommentUserFrom.append(tempStrS)
                    }else{
                        tempCommentUserFrom.append(tempStrS)
                        tempCommentUserFrom.append(NSAttributedString(string: "\n"))
                    }
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 5
                    paragraphStyle.alignment = .left
                    // 4.行间距
                    tempCommentUserFrom.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, tempCommentUserFrom.length))
                    attComment.append(tempCommentUserFrom)
   
                }
                    commentText.attributedText = attComment

       
            }
     ///       print(commentText.frame)
//            evaluateBg.mas_updateConstraints { (make) in
//                make?.bottom.mas_equalTo()(commentText.mas_bottom)?.setOffset(10)
//            }
            
//            self.setNeedsUpdateConstraints()
//            self.updateFocusIfNeeded()
//            self.setNeedsLayout()
//            self.layoutIfNeeded()
//            print(evaluateBg.frame)
//
//            model?.rowHeight = evaluateBg.frame.maxY+10
            
        }
        
    }
    

    
    lazy var statusView :QRStatusView = {
        let status =  QRStatusView()
        status.statusText.textColor = UIColor.black
        return status
    }()
    lazy var picView :QRPictureView = {
        let pic =  QRPictureView(leftMargin: AutoGetWidth(width: 36+15))
        return pic
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
        but.setTitleColor(UIColor.black, for: .normal)
        return but
    }()
    //评论和点赞人明细
    lazy var statusText : UILabel = {
        let status =  UILabel(title: "sadasdasjkdhaksjd")
        status.backgroundColor = kfilterBlueColor
        
        return status
    }()
    
    lazy var evaluateBg : UIView = {
        let evaluateBg =  UIView(frame: CGRect.zero)
        evaluateBg.backgroundColor = UIColor.colorWithHexString(hex: "#f2f6fc")

        return evaluateBg
    }()
    @objc func tapTouchIn(){
       print("tap")
    }
    
    lazy var evaluateBgLineView : UIView = {
        let evaluateBgLineView =  UIView(frame: CGRect.zero)
        evaluateBgLineView.backgroundColor = kLineColor
        evaluateBgLineView.isHidden = true
        return evaluateBgLineView
    }()
    
    //点赞人
    lazy var zanPeopleText : MLLinkLabel = {
        let Text = MLLinkLabel()
        Text.font = kFontSize14
        Text.delegate = self
        Text.numberOfLines = 0
        let linkDict = [NSAttributedStringKey.foregroundColor:UIColor.colorWithHexString(hex: "#1e5f91")]
        let activeLinkDict = [NSAttributedStringKey.backgroundColor : kProjectBgColor,NSAttributedStringKey.foregroundColor:klightGreyColor]
        Text.linkTextAttributes = linkDict
        Text.activeLinkTextAttributes = activeLinkDict
        Text.text = ""
        
        return Text
    }()
    lazy var bottomLine : UIView = {
        let bottomLine =  UIView(frame:  CGRect(x: 0, y: 0, width: kWidth, height: AutoGetWidth(width: 10)))
        bottomLine.backgroundColor = kProjectBgColor
        
        return bottomLine
    }()
    //评论
    lazy var commentText : MLLinkLabel = {
        let Text = MLLinkLabel()
        Text.isUserInteractionEnabled = true
        Text.lineBreakMode = NSLineBreakMode.byCharWrapping
        Text.font = kFontSize14
        Text.delegate = self
        Text.numberOfLines = 0
//        let dic = [NSAttributedStringKey.:UIColor.black] as [NSAttributedStringKey : Any]
//        mao.setAttributes(dic, range:(":" as NSString).range(of:":"))
        let linkDict = [NSAttributedStringKey.foregroundColor:UIColor.colorWithHexString(hex: "#1e5f91")]
        let activeLinkDict = [NSAttributedStringKey.backgroundColor : kProjectBgColor,NSAttributedStringKey.foregroundColor:klightGreyColor]
        Text.linkTextAttributes = linkDict
        Text.activeLinkTextAttributes = activeLinkDict
        Text.text = " "
        return Text
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(statusView)
        contentView.addSubview(picView)
        contentView.addSubview(evaluateBut)
        contentView.addSubview(zanBut)
        contentView.addSubview(statusText)
        contentView.addSubview(evaluateBg)
        contentView.addSubview(evaluateBgLineView)
        contentView.addSubview(zanPeopleText)
        contentView.addSubview(commentText)
        contentView.addSubview(bottomLine)
//        contentView.mas_makeConstraints { (make) in
//            make?.left.mas_equalTo()(self)?.setOffset(AutoGetWidth(width: 10))
//            make?.right.mas_equalTo()(self)?.setOffset(AutoGetWidth(width: -10))
//
//        }
        statusView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)
            make?.right.mas_equalTo()(contentView)
            make?.top.mas_equalTo()(contentView)
            
        }
        picView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)
            make?.right.mas_equalTo()(contentView)
            make?.top.mas_equalTo()(statusView.mas_bottom)?.setOffset(8)
        }
        
        zanBut.mas_makeConstraints { (make) in
            make?.width.mas_equalTo()(AutoGetWidth(width: 29))
            make?.height.mas_equalTo()(AutoGetWidth(width: 25))
            make?.right.mas_equalTo()(contentView.mas_right)?.setOffset(-AutoGetWidth(width: 25))
            make?.top.mas_equalTo()(picView.mas_bottom)?.setOffset(5)
         //   make?.bottom.mas_equalTo()(contentView.mas_bottom)?.setOffset(-10)
        }
        
        evaluateBut.mas_makeConstraints { (make) in
            make?.width.mas_equalTo()(AutoGetWidth(width: 29))
            make?.height.mas_equalTo()(AutoGetWidth(width: 25))
            make?.right.mas_equalTo()(zanBut.mas_left)?.setOffset(AutoGetWidth(width: -25))
            make?.top.mas_equalTo()(picView.mas_bottom)?.setOffset(5)
          //  make?.bottom.mas_equalTo()(contentView)?.setOffset(-10)
        }
        
        evaluateBg.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView.mas_left)?.setOffset(AutoGetWidth(width: 15+36+15))
            make?.right.mas_equalTo()(contentView.mas_right)?.setOffset(AutoGetWidth(width: -15))
            make?.top.mas_equalTo()(evaluateBut.mas_bottom)?.setOffset(5)
           // make?.height.mas_equalTo()(AutoGetWidth(width: 15))
            make?.bottom.mas_equalTo()(contentView)?.setOffset(-10)
        }
        
        zanPeopleText.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(evaluateBg.mas_left)?.setOffset(10)
            make?.right.mas_equalTo()(evaluateBg.mas_right)?.setOffset(-10)
            make?.top.mas_equalTo()(evaluateBg.mas_top)?.setOffset(5)
            //make?.bottom.mas_equalTo()(evaluateBg.mas_bottom)
        }
        
        evaluateBgLineView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(evaluateBg.mas_left)
            make?.right.mas_equalTo()(evaluateBg.mas_right)
            make?.top.mas_equalTo()(zanPeopleText.mas_bottom)?.setOffset(5)
            make?.height.mas_equalTo()(AutoGetWidth(width: 1))
        }
        
        commentText.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(evaluateBg.mas_left)?.setOffset(10)
            make?.right.mas_equalTo()(evaluateBg.mas_right)?.setOffset(-10)
            make?.top.mas_equalTo()(zanPeopleText.mas_bottom)?.setOffset(10)
            make?.bottom.mas_equalTo()(evaluateBg.mas_bottom)?.setOffset(-10)
        }
        bottomLine.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView.mas_left)
            make?.right.mas_equalTo()(contentView.mas_right)
            make?.top.mas_equalTo()(commentText.mas_bottom)?.setOffset(AutoGetHeight(height: 5))
            make?.height.mas_equalTo()(AutoGetHeight(height: 10))
           // make?.bottom.mas_equalTo()(evaluateBg.mas_bottom)?.setOffset(-10)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    @objc func pingLun(){
        print("评论")
        let  ewenTextView = EwenTextView.init(frame: CGRect.init(x: 0, y: kHeight - 49, width: kWidth, height: 49))
        ewenTextView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        ewenTextView.setPlaceholderText("请输入文字")
        if let input = rootVc?.inputViewEW{
            input.resignFirstResponder()
            input.removeFromSuperview()
        }else{
            
        }
        rootVc!.view.addSubview(ewenTextView)
        rootVc?.inputViewEW = ewenTextView
        ewenTextView.textView.becomeFirstResponder()
        ewenTextView.ewenTextViewBlock = {(test) -> Void in
            /*输入的内容在上方显示*/
            self.childCommentRequest(uId: (self.model?.circleArticleId)!, text: test!)
            /*移除*/
            ewenTextView.resignFirstResponder()
            ewenTextView.removeFromSuperview()
            
        }
        
    }
    @objc func zan(){
        self.zanRequest()
    }
}
extension QRFriendCircleCell{
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
                self.loadSigleLineDatas(moreData: false, page: (self.model?.page)!)
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
                self.loadSigleLineDatas(moreData: false, page: (self.model?.page)!)
        }) { (error) in
            
        }
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
                
//                if self.model!.laudStatus{
//                    self.zanBut.setImage(UIImage.init(named: "CQWorkCircleCancelZan"), for: .normal)
//                    self.model!.laudStatus = false
//                }else {
//                    self.zanBut.setImage(UIImage.init(named: "CQWorkCircleZan"), for: .normal)
//                    self.model!.laudStatus = true
//                }
               
               // self.rootVc?.loadSigleLineDatas(moreData: false, page: (self.model?.page)!)
                self.loadSigleLineDatas(moreData: false, page: (self.model?.page)!)
                self.zanBut.isUserInteractionEnabled = true
                
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
                        self.model = mod
                        self.rootVc?.dataArray[self.index!.row] = mod

                            self.clickClosure!(self.index!)
                      
                        

                    }
                }
              
        }) { (error) in
            
        }
    }
    
}


extension QRFriendCircleCell : MLLinkLabelDelegate {
    func didClick(_ link: MLLink!, linkText: String!, linkLabel: MLLinkLabel!) {
       //print(link.linkValue!)
        let linkVal = link.linkValue!
        let arr = linkVal.components(separatedBy: "|")
        print(arr)
        if arr.first == "dToken"{
            print("点击在评论上面")
            let  ewenTextView = EwenTextView.init(frame: CGRect.init(x: 0, y: kHeight - 49, width: kWidth, height: 49))
            ewenTextView.backgroundColor = UIColor(white: 0, alpha: 0.3)
            ewenTextView.setPlaceholderText("请输入文字")
            if let input = rootVc?.inputViewEW{
                input.resignFirstResponder()
                input.removeFromSuperview()
            }else{
                
            }
            rootVc!.view.addSubview(ewenTextView)
            rootVc?.inputViewEW = ewenTextView
            ewenTextView.textView.becomeFirstResponder()
            ewenTextView.ewenTextViewBlock = {(test) -> Void in
                /*输入的内容在上方显示*/
                
                self.CommentToOtherRequest(uId: arr[1], text: test!)
                /*移除*/
                ewenTextView.resignFirstResponder()
                ewenTextView.removeFromSuperview()
            }
        }else{
            print("名字上面")
        }
    }
    

    
}

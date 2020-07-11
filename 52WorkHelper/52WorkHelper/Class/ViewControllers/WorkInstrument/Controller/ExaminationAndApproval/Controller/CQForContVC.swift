//
//  CQForContVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/7/27.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQForContVC: SuperVC {

    weak var rootLayout :TGLinearLayout!
    
    var businessCode = ""
    var approvalBusinessId = ""
    //抄送人id和名字
    var userIdArr = [String]()
    var userNameArr = [String]()
    
    //从我提交的详情进
    var isFromApplyDetail = false
    
    var dataArray = [CQSupplyModel]()
    var supplyArray = [CQCopyForModel]() //审核列表
    var copyArray = [CQDepartMentUserListModel]() //抄送人列表
    var toghterArray = [CQDepartMentUserListModel]() //同行人列表
    //补卡时间数组
    var checkModifyTimeArray = [String]()
    //当前页面子控件起始tag值
    var currentPageTag = 100
    //当前页面是什么类型  请假 出差 等等
    var curType = ""
    //加班申请是否可以为同事代为申请 false：不可，true可以
    var isReplace:Bool?

    
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - AutoGetHeight(height: 64)), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight))
        headView.backgroundColor = UIColor.white
        return headView
    }()
    
    lazy var footView: UIView = {
        let footView = UIView.init(frame: CGRect.init(x: 0, y: kHeight - AutoGetHeight(height: 64), width: kWidth, height:  AutoGetHeight(height: 64)))
        footView.backgroundColor = UIColor.white
        return footView
    }()
    
    lazy var submitBtn: UIButton = {
        let submitBtn = UIButton.init(type: .custom)
        submitBtn.frame = CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 8), width: kHaveLeftWidth, height: AutoGetHeight(height: 48))
        submitBtn.backgroundColor = kLightBlueColor
        submitBtn.setTitle("提 交", for: .normal)
        submitBtn.setTitleColor(UIColor.white, for: .normal)
        submitBtn.layer.cornerRadius = 3
        submitBtn.addTarget(self, action: #selector(submitClick), for: .touchUpInside)
        return submitBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.isFromApplyDetail{
//            self.loadSubmitDetailData()
        }else{
            self.setUpRefresh()
        }
        
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
        
        self.view.addSubview(self.footView)
        self.footView.addSubview(self.submitBtn)
        
        
        self.headView.tg_width.equal(.wrap)
        self.headView.tg_height.equal(.wrap)
        //如果一个非布局父视图里面有布局子视图，那么这个非布局父视图也是可以将高度和宽度设置为.wrap的，他表示的意义是这个非布局父视图的尺寸由里面的布局子视图的尺寸来决定的。还有一个场景是非布局父视图是一个UIScrollView。他是左右滚动的，但是滚动视图的高度是由里面的布局子视图确定的，而宽度则是和窗口保持一致。这样只需要将滚动视图的宽度设置为和屏幕保持一致，高度设置为.wrap，并且把一个水平线性布局添加到滚动视图即可。
        let rootLayout = TGLinearLayout(.vert)
        rootLayout.tg_height.equal(.wrap)
        rootLayout.tg_width.equal(.wrap)
        //        rootLayout.tg_padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        rootLayout.tg_zeroPadding = false   //这个属性设置为false时表示当布局视图的尺寸是wrap也就是由子视图决定时并且在没有任何子视图是不会参与布局视图高度的计算的。您可以在这个DEMO的测试中将所有子视图都删除掉，看看效果，然后注释掉这句代码看看效果。
        //        rootLayout.tg_vspace = 5
        self.headView.addSubview(rootLayout)
        self.rootLayout = rootLayout
    }

    @objc func submitClick()  {
        
    }
    
}

extension CQForContVC{
    fileprivate func setUpRefresh() {
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/businessForApply" ,
            type: .get,
            param: ["businessCode":self.businessCode,
                    "emyeId":userID,
                    "approvalBusinessId":self.approvalBusinessId],
            successCallBack: { (result) in
                guard let model = CQSupplyModel.init(jsonData: result["data"]) else {
                    return
                }
                
                let str = model.formContent
                
                if !str.isEmpty {
                    let formData:Data = str.data(using: String.Encoding.utf8)!
                    guard let array = JSON(formData).arrayObject as? [[String: AnyObject]] else {
                        return
                    }
                    
                    for i in 0..<array.count{
                        let arr = array[i]
                        let dic = arr["widget"]
                        DLog(dic)
                        
                        
                        if 0 == i{
                            self.curType = (dic!["type"] as? String)!
                            if self.curType == "leave"{
                                self.title = "请假"
//                                self.getVocationTypeRequest()
                            }else if self.curType == "business" || self.curType == "outWork" || self.curType == "modify" || self.curType == "overtime" {
                                self.title = dic!["title"] as? String
                            }else{
                                self.title = "金额合同"
                            }
                            
                            
                            self.isReplace = dic!["isReplace"] as? Bool
                            if self.isReplace == nil{
                                self.isReplace = false
                            }
                            DLog(self.isReplace)
                            let formArr = dic?["subWidget"]
                            let a = formArr as? NSArray
                            if a != nil {
                                if  (a?.count)! > 0{
                                    for forDict in a! {
                                        let formDict = forDict as! NSDictionary
                                        let formName = formDict["name"] as! String
                                        let formType = formDict["type"] as! String
                                        var formRequire:Bool?
                                        formRequire = formDict["required"] as? Bool
                                        
                                        DLog(formName)
                                        
                                        self.currentPageTag = self.currentPageTag + 1
                                        if formType == "select"{
                                            if formRequire! {
                                                self.rootLayout.addSubview(self.addRequirtChooseLayout(tag: self.currentPageTag, title: formDict["title"] as! String, promot: formDict["prompt"] as! String, btnTag: 200))
                                            }else{
                                                self.rootLayout.addSubview(self.addNotRequirtChooseLayout(tag: self.currentPageTag, title: formDict["title"] as! String, promot: formDict["prompt"] as! String, btnTag: 200))
                                            }
                                            
                                        }else if formType == "date" && formName == "startTime"{
                                            if  formRequire!{
                                                self.rootLayout.addSubview(self.addRequirtChooseLayout(tag: self.currentPageTag, title: formDict["title"] as! String, promot: formDict["prompt"] as! String, btnTag: 201))
                                            }else{
                                                self.rootLayout.addSubview(self.addNotRequirtChooseLayout(tag: self.currentPageTag, title: formDict["title"] as! String, promot: formDict["prompt"] as! String, btnTag: 201))
                                            }
                                            
                                        }else if formType == "date" && formName == "endTime"{
                                            if  formRequire!{
                                                self.rootLayout.addSubview(self.addRequirtChooseLayout(tag: self.currentPageTag, title: formDict["title"] as! String, promot: formDict["prompt"] as! String, btnTag: 202))
                                            }else{
                                                self.rootLayout.addSubview(self.addNotRequirtChooseLayout(tag: self.currentPageTag, title: formDict["title"] as! String, promot: formDict["prompt"] as! String, btnTag: 202))
                                            }
                                        }else if formType == "date" {
                                            
                                        }
                                        
                                        
                                    }
                                }
                            }
                        }
                        
                        
                        
                    }
                    
                }
                self.getApprovalPersonsRequest()
                self.table.reloadData()
        }) { (error) in
            self.table.reloadData()
            
        }
    }
    
    //提交
    func applySubmitRequest(data:String) {
        let userId = STUserTool.account().userID
        var userIdStr = ""
        if self.userIdArr.count > 0 {
            for i in 0..<self.userIdArr.count{
                if 0 == i{
                    userIdStr = self.userIdArr[i]
                }else{
                    userIdStr = userIdStr + "," + self.userIdArr[i]
                }
            }
        }
        var aId = ""
        if self.isFromApplyDetail{
//            aId = self.detailBid
        }else{
            aId = self.approvalBusinessId
        }
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/applySubmit" ,
            type: .post,
            param: ["approvalBusinessId":aId,
                    "businessApplyId":"",
                    "businessCode":self.businessCode,
                    "copyPersonIds":userIdStr,
                    "emyeId":userId,
                    "formData":data],
            successCallBack: { (result) in
                SVProgressHUD.showSuccess(withStatus: "发布成功")
                self.navigationController?.popViewController(animated: true)
        }) { (error) in
            
        }
    }
    
    //查询补卡申请时间列表
    func checkModifyTimeRequest() {
        let userId = STUserTool.account().userID
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/checkModifyTime" ,
            type: .get,
            param: ["emyeId":userId],
            successCallBack: { (result) in
                //            let leaveArr = formDict["dataSource"] as! NSArray
                //            for dic in leaveArr{
                //                let leaveDic = dic as! NSDictionary
                //                self.leaveDataArray.append(leaveDic["text"] as! String)
                //                self.leaveIdArray.append(leaveDic["value"] as! Int)
                //            }
                var tempArray = [String]()
                for modalJson in result["data"].arrayValue {
                    let modal = modalJson.stringValue
                    tempArray.append(modal)
                }
                self.checkModifyTimeArray = tempArray
                if self.checkModifyTimeArray.count <= 0 {
                    SVProgressHUD.showInfo(withStatus: "您没有需要补卡的时间")
                }else{
                }
                
        }) { (error) in
            
        }
    }
    
    //获得审批人
    func getApprovalPersonsRequest() {
        let userId = STUserTool.account().userID
        var aId = ""
        if isFromApplyDetail {
//            aId = self.detailBid
        }else{
            aId = self.approvalBusinessId
        }
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getApplyApprovalPersons" ,
            type: .post,
            param: ["approvalBusinessId":aId,
                    "businessCode":self.businessCode,
                    "emyeId":userId,
                    "vacationTypeId":""],
            successCallBack: { (result) in
                self.copyArray.removeAll()
                self.userIdArr.removeAll()
                //审核人列表
                var approvalArr = [CQCopyForModel]()
                for modalJson in result["data"]["approvalFlowPersonUnitJsonList"].arrayValue  {
                    guard let modal = CQCopyForModel(jsonData: JSON(modalJson)) else {
                        return
                    }
                    approvalArr.append(modal)
                }
                self.supplyArray = approvalArr
                
                //抄送人列表
                var copyToArr = [CQDepartMentUserListModel]()
                for modalJson in result["data"]["copyFlowPersonUnitJsonList"].arrayValue  {
                    guard let modal = CQDepartMentUserListModel(jsonData: JSON(modalJson)) else {
                        return
                    }
                    copyToArr.append(modal)
                }
                
                for model in copyToArr{
                    self.copyArray.append(CQDepartMentUserListModel.init(uId: model.approverId, realN: model.realName, headImag: model.headImage))
                }
                
                for model in self.copyArray {
                    self.userIdArr.append(model.userId)
                }
                
                
        }) { (error) in
            
        }
    }

}

extension CQForContVC{
    
    //必填 水平选择 每个tag都是从当前页面初始的currentPageTag = 100 开始往上+
    internal func addRequirtChooseLayout(tag:Int,title:String,promot:String,btnTag:Int) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addxingLable())
        wrapContentLayout.addSubview(self.didRequirtTitleLab(text: title))
        wrapContentLayout.addSubview(self.addChooseTypeBtn(title: promot, tag: btnTag))
        wrapContentLayout.addSubview(self.addArrowBtn())
        return wrapContentLayout
    }
    
    //选填 水平选择 每个tag都是从当前页面初始的currentPageTag = 100 开始往上+
    internal func addNotRequirtChooseLayout(tag:Int,title:String,promot:String,btnTag:Int) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.didNotRequirtTitleLab(text: title))
        wrapContentLayout.addSubview(self.addChooseTypeBtn(title: promot, tag: btnTag))
        wrapContentLayout.addSubview(self.addArrowBtn())
        return wrapContentLayout
    }
    
}

extension CQForContVC{
    //必填
    @objc internal func addxingLable() -> UILabel{
        let lab = UILabel.init()
        lab.text = "*"
        lab.font = kFontSize15
        lab.textAlignment = .center
        lab.textColor = UIColor.red
        lab.tag = 1
        lab.tg_height.equal(AutoGetHeight(height: 55))
        lab.tg_width.equal(AutoGetWidth(width: 30))
        return lab
    }
    
    //必填标题
    @objc internal func didRequirtTitleLab(text:String) -> UILabel{
        let lab = UILabel.init()
        lab.text = text
        lab.tag = 2
        lab.font = kFontSize15
        lab.textAlignment = .left
        lab.textColor = UIColor.black
        lab.tg_height.equal(AutoGetHeight(height: 55))
        lab.tg_width.equal(AutoGetWidth(width: 90))
        return lab
    }
    
    //非必填标题
    @objc internal func didNotRequirtTitleLab(text:String) -> UILabel{
        let lab = UILabel.init()
        lab.text = text
        lab.tag = 3
        lab.font = kFontSize15
        lab.textAlignment = .left
        lab.textColor = UIColor.black
        lab.tg_height.equal(AutoGetHeight(height: 55))
        lab.tg_width.equal(AutoGetWidth(width: 105))
        lab.tg_left.equal(kLeftDis)
        return lab
    }
    
    
    
    @objc internal func addChooseTypeBtn(title:String,tag:NSInteger) -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.addTarget(self ,action:#selector(handleAction), for:.touchUpInside)
        btn.setTitle(title ,for:.normal)
        //        btn.titleLabel!.adjustsFontSizeToFitWidth = true
        btn.titleLabel!.font = kFontSize15
        btn.setTitleColor(kLyGrayColor, for: .normal)
        btn.tag = tag
//        btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 145))
        btn.tg_height.equal(AutoGetHeight(height: 55))
        btn.titleLabel?.textAlignment = .right
        btn.tg_width.equal(kWidth - AutoGetWidth(width: 126.5))
        return btn
    }
    //箭头
    @objc internal func addArrowBtn() -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "PersonAddressArrow"), for: .normal)
        btn.tg_height.equal(AutoGetHeight(height: 55))
        btn.tg_width.equal(AutoGetWidth(width: 6.5))
        btn.tag = 4
        return btn
    }
    //单位
    @objc internal func addUnitLable(_ title:String, tag:NSInteger) -> UILabel{
        let lab = UILabel.init()
        lab.text = title
        lab.font = kFontSize15
        lab.textAlignment = .right
        lab.textColor = UIColor.black
        lab.tag = tag
        //        lab.adjustsFontSizeToFitWidth =  true
        lab.tg_right.equal(kLeftDis)
        lab.tg_width.equal(AutoGetWidth(width: 15))
        lab.tg_height.equal(AutoGetHeight(height: 55))
        return lab
    }
    //单行输入框
    @objc internal func addFieldInput(tag:Int,placeHolder:String,text:String) -> MyTextField {
        let textField = MyTextField.init()
        textField.tg_width.equal(kWidth - AutoGetWidth(width: 120))
        textField.tg_right.equal(kLeftDis)
        textField.tg_height.equal(AutoGetHeight(height: 55))
        textField.placeholder = placeHolder
        textField.keyboardType = .default
        textField.delegate = self
        textField.keyBoardDelegate = self
        textField.clearButtonMode = .never
        textField.font = kFontSize15
        textField.tag = tag
        textField.textColor = UIColor.black
        textField.tintColor = UIColor.black
        textField.text = text
        return textField
    }
    
    //多行输入框(包含各种描述)
    @objc internal func addtextContentView(leftDis:CGFloat,placeHolder:String,tag:Int,pretext:String) -> CBTextView {
        let textView = CBTextView.init()
        textView.backgroundColor = UIColor.white
        //        contentV.tg_centerX.equal(kWidth/2)
        textView.tg_left.equal(leftDis)
        textView.tg_width.equal(kWidth - 2*leftDis)
        textView.tg_height.equal(AutoGetHeight(height: 109))
        textView.aDelegate = self
        textView.textView.backgroundColor = UIColor.white
        textView.textView.font = kFontSize15
        textView.textView.textColor = UIColor.black
        textView.layer.borderColor = kLyGrayColor.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 2
        textView.tag = tag
        textView.placeHolder = "请输入" + placeHolder
        textView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        //        textView.textView.text = pretext
        if !pretext.isEmpty {
            textView.prevText = pretext
        }
        
        return textView
    }
    
    //collectionView
    @objc internal func addCollectionView(leftDis:CGFloat,tag:Int,height:CGFloat,collectionArr:[CQDepartMentUserListModel]) -> UICollectionView {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width:kHaveLeftWidth/4, height:AutoGetHeight(height: 75))
        layOut.minimumLineSpacing = 10
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        
        let collectionView = CQApprollerCollection.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kHaveLeftWidth, height:height), collectionViewLayout: layOut)
        collectionView.tg_left.equal(leftDis)
        collectionView.tg_width.equal(kWidth - 2*leftDis)
        collectionView.tag = tag
        collectionView.tg_height.equal(.wrap)
        collectionView.tg_top.equal(AutoGetHeight(height: 13))
        collectionView.collectDataArray = collectionArr
        
        return collectionView
    }
    //部门按钮 就是选个人
    func addDepartMentButton(tag:Int,title:String,isReplace:Bool) -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.addTarget(self ,action:#selector(handleAction), for:.touchUpInside)
        btn.setTitle(title ,for:.normal)
        btn.titleLabel!.font = kFontSize11
        btn.titleLabel?.numberOfLines = 0
        btn.backgroundColor = kLineColor
        btn.layer.cornerRadius = 4
        btn.setTitleColor(kLyGrayColor, for: .normal)
        btn.setTitle(title, for: .normal)
        //        btn.setImage(UIImage.init(named: "CQDeleteBtn"), for: .normal)
        btn.tag = tag
        let img = UIImageView.init(frame: CGRect.init(x: kWidth/4 - AutoGetWidth(width: 7), y: -AutoGetWidth(width: 7), width: AutoGetWidth(width: 14), height: AutoGetWidth(width: 14)))
        img.image = UIImage.init(named: "CQDeleteBtn")
        btn.addSubview(img)
        //        btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -AutoGetWidth(width: 10), bottom: 0, right:0)
        //        btn.imageEdgeInsets = UIEdgeInsets.init(top: -AutoGetHeight(height: 35), left: 0, bottom: 0, right: -AutoGetWidth(width: 255))
        if !isReplace{
            btn.isUserInteractionEnabled = false
        }else{
            btn.isUserInteractionEnabled = true
        }
        btn.tg_left.equal(kLeftDis)
        btn.tg_height.equal(AutoGetHeight(height: 40))
        btn.tg_width.equal(kWidth/4)
        btn.tg_bottom.equal(AutoGetHeight(height: 10))
        return btn
    }
    //补卡申请
    func addCardApplyButton(tag:Int) -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.addTarget(self ,action:#selector(handleAction), for:.touchUpInside)
        btn.setTitle(title ,for:.normal)
        //        btn.titleLabel!.adjustsFontSizeToFitWidth = true
        btn.titleLabel!.font = kFontSize15
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitle("补卡申请", for: .normal)
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = kLyGrayColor.cgColor
        btn.setImage(UIImage.init(named: "PersonAddressArrow"), for: .normal)
        btn.tag = tag
        btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: AutoGetWidth(width: 280))
        btn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 400))
        btn.tg_height.equal(AutoGetHeight(height: 55))
        btn.tg_width.equal(kWidth )
        return btn
    }
}

//MARK: - Handle Method
extension CQForContVC
{
    @objc internal func handleAction(_ sender :UIButton){
        
    }
}



extension CQForContVC:UITextFieldDelegate,KeyBoardDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if self.isInputRuleNotBlank(str: string) || string == ""{
            return true
        }else{
            SVProgressHUD.showInfo(withStatus: "不支持emoji表情")
            return false
        }
    }
    
    func isInputRuleNotBlank(str:String)->Bool{
        let pattern = "^[a-zA-Z\\u4E00-\\u9FA5\\d]*$"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch = pred.evaluate(with: str)
        if !isMatch{
            let other = "➋➌➍➎➏➐➑➒"
            let len = str.count
            for i in 0..<len{
                let tmpStr = str as NSString
                let tmpOther = other as NSString
                let c = tmpStr.character(at: i)
                
                if !((isalpha(Int32(c))) > 0 || (isalnum(Int32(c))) > 0 || ((Int(c) == "_".hashValue)) || (Int(c) == "-".hashValue) || ((c >= 0x4e00 && c <= 0x9fa6)) || (tmpOther.range(of: str).location != NSNotFound)) {
                    return false
                }
                return true
            }
        }
        return isMatch
    }
    
    func isInputRuleAndBlank(str:String)->Bool{
        let pattern = "^[a-zA-Z\\u4E00-\\u9FA5\\d\\s]*$"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch = pred.evaluate(with: str)
        return isMatch
    }
    
    func disable_emoji(str:String)->String{
        let regex = try!NSRegularExpression.init(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]", options: .caseInsensitive)
        
        let modifiedString = regex.stringByReplacingMatches(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange.init(location: 0, length: str.count), withTemplate: "")
        return modifiedString
    }
    
    
    
    func getSubString(str:String) -> String{
        if str.count>120{
            SVProgressHUD.showInfo(withStatus: "最多输入120个字")
//            return str[0..<(120)]
            return (str as NSString).substring(with: NSRange.init(location: 0, length: 120))
        }
        return str
    }
    
    @objc func textFieldEditChanged(obj:Notification)  {
        
    }
    
}


//  MARK:textViewDelegate
extension CQForContVC:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
}

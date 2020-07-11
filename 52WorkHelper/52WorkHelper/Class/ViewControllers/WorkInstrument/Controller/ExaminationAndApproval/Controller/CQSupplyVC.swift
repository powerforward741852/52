//
//  CQSupplyVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/30.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQSupplyVC: SuperVC {

    weak var rootLayout :TGLinearLayout!
    var titleStr = ""
    var businessCode = ""
    var approvalBusinessId = ""
    var dataArray = [CQSupplyModel]()
    var supplyArray = [CQCopyForModel]() //审核列表
    var copyArray = [CQDepartMentUserListModel]() //抄送人列表
    var toghterArray = [CQDepartMentUserListModel]() //同行人列表
    //datepicker一系列控件及参数
    var bgView = UIButton()
    var startTime = "" //开始时间
    var endTime = ""  //结束时间
    var startDate:Date?
    var endDate:Date?
    var timeCount:Double?  //时差
    var timeInter = "小时" //时差
    var travalDay:Double = 0.00 //出差时间
    
    var curType = ""  //当前界面类型
    var trafic = "" //交通工具
    var isBack:Bool! //是否往返
    //公共picker
    var pickView:UIPickerView?
    
    //所有地址数据集合
    var addressArray = [[String: AnyObject]]()
    
    //选择的省索引
    var provinceIndex = 0
    //选择的市索引
    var cityIndex = 0
    //选择的县索引
    var areaIndex = 0
    
    //请假类型数组
    var leaveDataArray = [String]()
    var leaveIdArray = [Int]() //请假类型id数组
    //补卡时间数组
    var checkModifyTimeArray = [String]()
    //交通工具数组
    var transportArray = [String]()
    //单程往返数组
    var checkboxArray = [String]()
    
    //出发地
    var fromAdd = ""
    //目的地
    var toAdd = ""
    
    //审批人数组
    var exameArray = [String]()
    
    //抄送人id和名字
    var userIdArr = [String]()
    var userNameArr = [String]()
   
    
    //提交表单
    var formStr = ""
    
    //请假类型
    var leaveMessage = ""
    
    //请假id
    var leaveId:Int?
    //加班申请人是否可以替别人申请加班
    var isReplace:Bool?
    //选中加班人model
    var overTimeModel:CQDepartMentUserListModel?
    //从我提交的详情进
    var isFromApplyDetail = false
    //假期类型主键
    var vocationType:NSNumber?
    //请假时间间隔
    var vocationDuration = ""
    //请假单位
    var vocationUnit = ""
    //当前显示的行程tag
    var curTravalPage = 0
    //当前有几个count
    var curTravalCount = 0
    
    //选中交通工具数组
    var selectTraficArr = [String]()
    //选中往返数组
    var selectIsBackArr = [Bool]()
    //选中出发城市数组
    var selectFromCityArr = [String]()
    //选中到达城市数组
    var selectToCityArr = [String]()
    //选中开始时间数组
    var selectStartTimeArr = [String]()
    //选中结束时间数组
    var selectEndTimeArr = [String]()
    //计算后时长数组
    var durationArr = [Double]()
    
    //value交通工具
    var valueTransportArray = [String]()
    //出差详情数组去1个后数
    var businessDetailCount = 0
    //审批人抄送人申请id
    var detailBid = ""
    //时长
    var businessDuration = ""
    //单位
    var businessUnit = ""
    //金额临界值数组
    var moneyRangeArray = [String]()
    //金额临界值value数组
    var moneyRangeValueArray = [NSNumber]()
    //是否生成人员选择
    var hasNew = false
    //是否生成部门选择
    var newDeparment = false
    //选中部门
    var selectPartmentStr = ""
    //金融临界值id
    var selectMoneyValue:NSNumber?
    //是否更换请假(加班，外出)审批人
    var isChangeApproveler = false
  
    var isFromSubmitDetail = false
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - AutoGetHeight(height: 0)), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight + AutoGetHeight(height: 560)))
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

//        self.edgesForExtendedLayout = UIRectEdge(rawValue:0) //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。
        
        if self.isFromApplyDetail{
            self.loadSubmitDetailData()
        }else{
            self.setUpRefresh()
        }
        
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
        
//        self.view.addSubview(self.footView)
//        self.footView.addSubview(self.submitBtn)
        
//        self.headView.tg_width.equal(.wrap)
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

        self.title = self.titleStr
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 44))
        rightBtn.setTitle("提交", for: .normal)
        rightBtn.sizeToFit()
        rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5)
        rightBtn.setTitleColor(UIColor.colorWithHexString(hex: "#20afff"), for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        rightBtn.addTarget(self, action: #selector(submitClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        let NotifMycation = NSNotification.Name(rawValue:"refreshSupplyCell")
        NotificationCenter.default.addObserver(self, selector: #selector(upDataChange(notif:)), name: NotifMycation, object: nil)
        
        let NotifMycation1 = NSNotification.Name(rawValue:"refreshTogherCell")
        NotificationCenter.default.addObserver(self, selector: #selector(togherDataChange(notif:)), name: NotifMycation1, object: nil)
        
        let NotifMycation2 = NSNotification.Name(rawValue:"refreshOverTimeMan")
        NotificationCenter.default.addObserver(self, selector: #selector(overChange(notif:)), name: NotifMycation2, object: nil)
    }
    
    //接收到后执行的方法
    @objc func upDataChange(notif: NSNotification) {
        
//        self.userIdArr.removeAll()
//        self.userNameArr.removeAll()
//        self.copyArray.removeAll()
        
        
        
        guard let arr: [CQDepartMentUserListModel] = notif.object as! [CQDepartMentUserListModel]? else { return }
        for i in 0..<arr.count {
            let hasNum = self.userIdArr.contains(arr[i].userId)
            if !hasNum{
                self.userIdArr.append(arr[i].userId)
                self.userNameArr.append(arr[i].realName)
                self.copyArray.append(arr[i])
            }
            
        }
       
        
        for wrap in self.rootLayout.subviews{
            if 120 == wrap.tag {
                for c in wrap.subviews{
                    if 801 == c.tag{
                        let collect:UICollectionView = c as! UICollectionView
                        collect.tg_height.equal(CGFloat(self.copyArray.count/4 + 1) * AutoGetHeight(height: 75) + AutoGetHeight(height: 50))
                        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: self.headView.sd_height + CGFloat(self.copyArray.count/4 + 1) * AutoGetHeight(height: 75) + AutoGetHeight(height: 20))
                        collect.reloadData()
                        self.table.reloadData()
                    }
                }
            }
        }
    }
    
    //接收同行人
    @objc func togherDataChange(notif: NSNotification) {
        guard let arr: [CQDepartMentUserListModel] = notif.object as! [CQDepartMentUserListModel]? else { return }
        for model in arr {
            
            self.toghterArray.append(model)
        }
        
        
        for wrap in self.rootLayout.subviews{
            if 121 == wrap.tag {
                for c in wrap.subviews{
                    if 802 == c.tag{
                        let collect:UICollectionView = c as! UICollectionView
                        collect.tg_height.equal(CGFloat(self.toghterArray.count/4 + 1) * AutoGetHeight(height: 75) + AutoGetHeight(height: 20))
                        collect.reloadData()
                    }
                }
            }
        }
    }
    
    //接收加班人
    @objc func overChange(notif: NSNotification) {
        guard let model: CQDepartMentUserListModel = notif.object as? CQDepartMentUserListModel else { return }
        
        self.overTimeModel = model
        
        if !self.hasNew{
            for wrap in self.rootLayout.subviews{
                if 134 == wrap.tag{
                    for vrap in wrap.subviews{
                        if vrap.tag == 101{
                            self.isReplace = true
                            self.hasNew = true
                            vrap.addSubview(self.addCollectionViewContentLayout(tag: 127, height: AutoGetHeight(height: 0), collectionTag: 803))
                        }
                    }
                    
                }
            }
        }else{
            for wrap in self.rootLayout.subviews{
                if 134 == wrap.tag{
                    for vrap in wrap.subviews{
                        if vrap.tag == 101{
                            for c in vrap.subviews{
                                if 127 == c.tag{
                                    for co in c.subviews{
                                        if 803 == co.tag{
                                            let collect:UICollectionView = co as! UICollectionView
                                            collect.reloadData()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }
        }
        
        
        for wrap in self.rootLayout.subviews{
            if 127 == wrap.tag {
                for c in wrap.subviews{
                    if 803 == c.tag{
                        let collect:UICollectionView = c as! UICollectionView
                        collect.reloadData()
                    }
                }
            }
        }
    }
    
    @objc func submitClick()  {
        //请假
        if self.curType == "leave" {
            
            
            var txtL = ""
            for wrap in self.rootLayout.subviews{
                if 114 == wrap.tag {
                    for c in wrap.subviews{
                        if 1201 == c.tag{
                            let textView:CBTextView = c as! CBTextView
                            txtL = textView.textView.text
                            if txtL == textView.placeHolder {
                                txtL = ""
                            }
                        }
                    }
                }
            }
            
            
            
            let dic = ["businessApplyDatas":[["vacationType":self.leaveId ?? 0,
                                             "startTime":self.startTime,
                                             "endTime":self.endTime,
                                             "duration":self.vocationDuration ,
                                             "leaveReason":txtL,
                                             "leavePerson":["entityId":STUserTool.account().userID,
                                                            "name":STUserTool.account().realName,
                                                            "url":STUserTool.account().headImage]]]]
            
            // 数字判断
            guard   self.leaveMessage.count > 0,
                    self.startTime.count > 0,
                    self.endTime.count > 0,
                    self.timeInter.count > 0,
                txtL.count > 0 else {
                    SVProgressHUD.showInfo(withStatus: "带*为必填项，请输入完整")
                    return
            }
            
            self.formStr = self.getJSONStringFromDictionary(dictionary: dic as NSDictionary)
            self.loadingPlay()
            self.applySubmitRequest(data: self.formStr)
            
        }else if self.curType == "overtime" { //加班
            var txtL = ""
            for wrap in self.rootLayout.subviews{
                if 126 == wrap.tag {
                    for c in wrap.subviews{
                        if 1203 == c.tag{
                            let textView:CBTextView = c as! CBTextView
                            txtL = textView.textView.text
                            if txtL == textView.placeHolder {
                                txtL = ""
                            }
                        }
                    }
                }
            }
            let dic = ["businessApplyDatas":[["endTime":self.endTime,
                                             "startTime":self.startTime,
                                             "duration":self.timeInter,
                                             "text1":txtL,
                                             "extraPerson":["entityId":self.overTimeModel?.userId,
                                                            "name":self.overTimeModel?.realName,
                                                            "url":self.overTimeModel?.headImage]]]]
            // 数字判断
            guard   self.startTime.count > 0,
                self.endTime.count > 0,
                self.timeInter.count > 0,
                self.overTimeModel != nil  else {
                    SVProgressHUD.showInfo(withStatus: "带*为必填项，请输入完整")
                    return
            }
            
            self.formStr = self.getJSONStringFromDictionary(dictionary: dic as NSDictionary)
            self.loadingPlay()
            self.applySubmitRequest(data: self.formStr)
            
        }else if self.curType == "outWork" {//外出
            
            var txtL = ""
            for wrap in self.rootLayout.subviews{
                if 126 == wrap.tag {
                    for c in wrap.subviews{
                        if 1203 == c.tag{
                            let textView:CBTextView = c as! CBTextView
                            txtL = textView.textView.text
                            if txtL == textView.placeHolder {
                                txtL = ""
                            }
                        }
                    }
                }
            }
            
            var txtL2 = ""
            for wrap in self.rootLayout.subviews{
                if 127 == wrap.tag {
                    for c in wrap.subviews{
                        if 1203 == c.tag{
                            let textView:CBTextView = c as! CBTextView
                            txtL2 = textView.textView.text
                            if txtL2 == textView.placeHolder {
                                txtL2 = ""
                            }
                        }
                    }
                }
            }
            
            let dic = ["businessApplyDatas":[["endTime":self.endTime,
                                             "startTime":self.startTime,
                                             "duration":self.timeInter,
                                             "text1":txtL,
                                             "text2":txtL2]]]
            // 数字判断
            guard   self.startTime.count > 0,
                self.endTime.count > 0,
                self.timeInter.count > 0 else {
                    SVProgressHUD.showInfo(withStatus: "带*为必填项，请输入完整")
                    return
            }
            self.formStr = self.getJSONStringFromDictionary(dictionary: dic as NSDictionary)
            self.loadingPlay()
            self.applySubmitRequest(data: self.formStr)
            
        }else if self.curType == "business" {//出差
            var travelReason = ""
            for wrap in self.rootLayout.subviews{
                if 124 == wrap.tag {
                    for c in wrap.subviews{
                        if 1202 == c.tag{
                            let textView:CBTextView = c as! CBTextView
                            travelReason = textView.textView.text
                            if travelReason == textView.placeHolder {
                                travelReason = ""
                            }
                        }
                    }
                }
            }
            
            var remark = ""
            for wrap in self.rootLayout.subviews{
                if 126 == wrap.tag {
                    for c in wrap.subviews{
                        if 1203 == c.tag{
                            let textView:CBTextView = c as! CBTextView
                            remark = textView.textView.text
                            if remark == textView.placeHolder {
                                remark = ""
                            }
                        }
                    }
                }
            }
            
            var dicArr = [NSMutableDictionary]()
            
            for model in self.toghterArray{
                let contentDic:NSMutableDictionary = NSMutableDictionary.init()
                contentDic.setValue(model.userId, forKey: "entityId")
                contentDic.setValue(model.realName, forKey: "name")
                contentDic.setValue(model.headImage, forKey: "url")
                dicArr.append(contentDic)
            }
            
            
            var detailArr = [NSMutableDictionary]()
            if self.curTravalCount == 0{
                let contentDic:NSMutableDictionary = NSMutableDictionary.init()
                contentDic.setValue(self.selectTraficArr[0], forKey: "transport")
                contentDic.setValue(self.selectIsBackArr[0], forKey: "isBack")
                contentDic.setValue(self.selectFromCityArr[0], forKey: "fromCity")
                contentDic.setValue(self.selectToCityArr[0], forKey: "toCity")
                contentDic.setValue(self.selectStartTimeArr[0], forKey: "startTime")
                contentDic.setValue(self.selectEndTimeArr[0], forKey: "endTime")
                contentDic.setValue(String.init(format: "%0.2f",self.durationArr[0]), forKey: "duration")
                detailArr.append(contentDic)
            }else{
                for i in 0..<self.curTravalCount{
                    let contentDic:NSMutableDictionary = NSMutableDictionary.init()
                    contentDic.setValue(self.selectTraficArr[i], forKey: "transport")
                    contentDic.setValue(self.selectIsBackArr[i], forKey: "isBack")
                    contentDic.setValue(self.selectFromCityArr[i], forKey: "fromCity")
                    contentDic.setValue(self.selectToCityArr[i], forKey: "toCity")
                    contentDic.setValue(self.selectStartTimeArr[i], forKey: "startTime")
                    contentDic.setValue(self.selectEndTimeArr[i], forKey: "endTime")
                    contentDic.setValue(String.init(format: "%0.2f",self.durationArr[i]), forKey: "duration")
                    detailArr.append(contentDic)
                }
            }
            
            DLog(detailArr)
            
            let dic = ["businessApplyDatas":[["travelReason":travelReason,
                                              "businessDetail":detailArr,
                                              "travelDays":"\(self.travalDay)" ,
                                              "togetherPerson":dicArr,
                                              "remark":remark,
                                              "attach0":["flieUrl":""],
                                              "travelPerson":["entityId":STUserTool.account().userID,
                                                              "name":STUserTool.account().realName,
                                                              "url":STUserTool.account().headImage]]]]
            
            for traf in self.selectTraficArr{
                if traf.isEmpty{
                    SVProgressHUD.showInfo(withStatus: "带*为必填项，请输入完整")
                }
            }
            for fromC in self.selectFromCityArr{
                if fromC.isEmpty {
                    SVProgressHUD.showInfo(withStatus: "带*为必填项，请输入完整")
                }
            }
            for toC in self.selectToCityArr{
                if toC.isEmpty {
                    SVProgressHUD.showInfo(withStatus: "带*为必填项，请输入完整")
                }
            }
            for startT in self.selectStartTimeArr{
                if startT.isEmpty {
                    SVProgressHUD.showInfo(withStatus: "带*为必填项，请输入完整")
                }
            }
            for endT in self.selectEndTimeArr{
                if endT.isEmpty {
                    SVProgressHUD.showInfo(withStatus: "带*为必填项，请输入完整")
                }
            }
            for dur in self.durationArr{
                if dur == 0.00 {
                    SVProgressHUD.showInfo(withStatus: "带*为必填项，请输入完整")
                }
            }
            
            // 数字判断
            guard travelReason.count>0,
                "\(self.travalDay)".count > 0 else {
                    SVProgressHUD.showInfo(withStatus: "带*为必填项，请输入完整")
                    return
            }
            self.formStr = self.getJSONStringFromDictionary(dictionary: dic as NSDictionary)
            self.loadingPlay()
            self.applySubmitRequest(data: self.formStr)
            
        }else if self.curType == "modify" {//补卡
            
            var txtL = ""
            for wrap in self.rootLayout.subviews{
                if 105 == wrap.tag {
                    for c in wrap.subviews{
                        if 1200 == c.tag{
                            let textView:CBTextView = c as! CBTextView
                            txtL = textView.textView.text
                            if txtL == textView.placeHolder {
                                txtL = ""
                            }
                        }
                    }
                }
            }
            
            let dic = ["businessApplyDatas":[["modifyTime":self.endTime,
                                              "modifyReason":txtL]]]
            // 数字判断
            guard   self.endTime.count > 0,
                txtL.count > 0 else {
                    SVProgressHUD.showInfo(withStatus: "带*为必填项，请输入完整")
                    return
            }
            self.formStr = self.getJSONStringFromDictionary(dictionary: dic as NSDictionary)
            self.loadingPlay()
            self.applySubmitRequest(data: self.formStr)
            
        }else if self.curType == "phnoeNum" {
            var telTxt = ""
            for wrap in self.rootLayout.subviews{
                if 132 == wrap.tag{
                    for sub in wrap.subviews{
                        if 88 == sub.tag{
                            let field:MyTextField = sub as! MyTextField
                            telTxt = field.text!
                            DLog(telTxt)
                        }
                    }
                }
            }
            var moneyText = ""
            for wrap in self.rootLayout.subviews{
                if 133 == wrap.tag{
                    for sub in wrap.subviews{
                        if 88 == sub.tag{
                            let field:MyTextField = sub as! MyTextField
                            moneyText = field.text!
                        }
                    }
                }
            }
            var bigMoneyText = ""
            for wrap in self.rootLayout.subviews{
                if 138 == wrap.tag{
                    for sub in wrap.subviews{
                        if 88 == sub.tag{
                            let field:MyTextField = sub as! MyTextField
                            bigMoneyText = field.text!
                        }
                    }
                }
            }
            let dic = ["businessApplyDatas":[["phnoeNum1":telTxt,
                                              "numText0":moneyText,
                                              "person3":["entityId":self.overTimeModel?.userId,
                                                         "name":self.overTimeModel?.realName,
                                                         "url":self.overTimeModel?.headImage],
                                              "department5":["entityId":"",
                                                             "name":self.selectPartmentStr],
                                              "select7":self.selectMoneyValue ?? 0,
                                              "upperMoney0":bigMoneyText,
                                              "attach0":["flieUrl":"",
                                                         "name":""]]]]
//            if self.cherkPhoneNum(num: telTxt){
                self.formStr = self.getJSONStringFromDictionary(dictionary: dic as NSDictionary)
            self.loadingPlay()
                self.applySubmitRequest(data: self.formStr)
//            }else{
//                SVProgressHUD.showInfo(withStatus: "请输入正确的手机号码")
//            }
        }
        
        
        
    }
    
    
    /**
     字典转换为JSONString
     
     - parameter dictionary: 字典参数
     
     - returns: JSONString
     */
    func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
        
    }
    
    /// 验证是否为手机
    ///
    /// - Parameter num: 输入的号码
    /// - Returns: 是否为手机bool值
    func cherkPhoneNum(num: String) -> Bool {
        do {
            let pattern = "^1[0-9]{10}$|^400[0-9]{7}$|^800[0-9]{7}$|0[0-9]{9,11}"
            let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: num, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, num.count))
            return matches.count > 0
        }
        catch {
            return false
        }
    }
    
    //获取请假申请总时长
    func getLeaveTimeRequest() {
        let userID = STUserTool.account().userID
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getLeaveDuration" ,
            type: .get,
            param: ["emyeId":userID,
                    "startTime":self.startTime,
                    "endTime":self.endTime,
                    "vacationTypeId":self.leaveId ?? 0],
            successCallBack: { (result) in
                self.vocationDuration = result["data"]["duration"].stringValue
                self.vocationUnit = result["data"]["unit"].stringValue
                self.timeInter = self.vocationDuration + self.vocationUnit
                
                for wrap in self.rootLayout.subviews{
                    if 103 == wrap.tag {
                        for lab in wrap.subviews{
                            if 54 == lab.tag{
                                let curLab:UILabel = lab as! UILabel
                                curLab.text = self.timeInter
                            }
                        }
                    }
                }
        }) { (error) in
            
        }
    }
    
    func getTimeForMyVocation() {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getAllVacationType" ,
            type: .get,
            param: ["emyeId":userID],
            successCallBack: { (result) in
                var tempArray = [CQMyLeaveListModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQMyLeaveListModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                
                var yearTime = "0"
                var tiaoxiu = "0"
                for mod in tempArray{
                    if mod.text == "年假"{
                        yearTime = mod.balanceNumber
                    }else if mod.text == "调休"{
                        tiaoxiu = mod.balanceNumber
                    }
                }
                
                for wrap in self.rootLayout.subviews{
                    if 12341 == wrap.tag {
                        for lab in wrap.subviews{
                            if 100 == lab.tag{
                                let curLab:UILabel = lab as! UILabel
                                
                                curLab.text = "年假: 剩余" + yearTime + "天" + "   调休: 剩余" + tiaoxiu + "小时"
                            }
                        }
                    }
                }
                
        }) { (error) in
            
        }
    }
    
    //获取请假类型
    func getVocationTypeRequest() {
        let userID = STUserTool.account().userID
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getAllVacationType" ,
            type: .get,
            param: ["emyeId":userID],
            successCallBack: { (result) in
                let arr = result["data"].arrayValue
                for dic in arr {
                    let leaveDic = dic.dictionaryValue
                    self.leaveDataArray.append((leaveDic["text"]?.stringValue)!)
                    self.leaveIdArray.append((leaveDic["value"]?.intValue)!)
                }
        }) { (error) in
            
        }
    }
}

extension CQSupplyVC{
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
                        
                        
                        if (dic!["type"] as! String) == "phnoeNum"{
                            self.curType = "phnoeNum"
                            if dic!["type"] as! String == "phnoeNum"{
                                self.rootLayout.addSubview(self.addContentLayout(tag:132,title: dic!["title"] as! String, str:dic!["prompt"] as! String, text: ""))
                            }
                        }else if dic!["type"] as! String == "numText"{
                            self.rootLayout.addSubview(self.addMoneyContentLayout(tag: 133, title: dic!["title"] as! String, str: dic!["prompt"] as! String, unit: dic!["unit"] as! String, text: ""))
                            
                        }else if  dic!["type"] as! String == "person"{
                            self.rootLayout.addSubview(self.addChoosePersonContentLayout(tag:134,title: dic!["title"] as! String,BtnTag:210))
                        }
                        else if  dic!["type"] as! String == "department"{
                            self.rootLayout.addSubview(self.addChoosePersonContentLayout(tag:135,title: dic!["title"] as! String,BtnTag:219))
                        }else if  dic!["type"] as! String == "sub"{
                            self.rootLayout.addSubview(self.addGrayLabContentLayout(tag:136,title: dic!["title"] as! String))
                        }else if  dic!["type"] as! String == "select"{
                            let transportArr = dic!["dataSource"] as! NSArray
                            for dic in transportArr{
                                let transportDic = dic as! NSDictionary
                                self.moneyRangeArray.append(transportDic["text"] as! String)
                                self.moneyRangeValueArray.append(transportDic["value"] as! NSNumber)
                            }
                            self.rootLayout.addSubview(self.addMoneyRangeContentLayout(tag: 137, title: dic!["title"] as! String, prompt: dic!["prompt"] as! String))
                        }else if dic!["type"] as! String == "upperMoney"{
                            self.rootLayout.addSubview(self.addContentLayout(tag:138,title: dic!["title"] as! String, str:dic!["prompt"] as! String, text: ""))
                            self.rootLayout.addSubview(self.addGrayViewContentLayout(tag: 139, height: AutoGetHeight(height: 13)))
                        }else if dic!["name"] as! String == "upperMoney0"{
                            self.rootLayout.addSubview(self.addContentLayout(tag:139,title: dic!["title"] as! String, str:dic!["prompt"] as! String, text: ""))
                            self.rootLayout.addSubview(self.addGrayViewContentLayout(tag: 140, height: AutoGetHeight(height: 13)))
                        }else if dic!["name"] as! String == "text2"{
                            self.rootLayout.addSubview(self.addDonotAskLabContentLayout(tag: 124, title: dic!["title"] as! String))
                            self.rootLayout.addSubview(self.addLevingReasonContentLayout(tag:127,placeHolder: dic!["prompt"] as! String,textTag: 1203, preText: ""))
                        }else if dic!["type"] as! String == "text"{
                            self.rootLayout.addSubview(self.addDonotAskLabContentLayout(tag: 124, title: dic!["title"] as! String))
                            self.rootLayout.addSubview(self.addLevingReasonContentLayout(tag:126,placeHolder: dic!["prompt"] as! String,textTag: 1203, preText: ""))
                        }else if (dic!["type"] as! String) == "email"{
                            if dic!["type"] as! String == "email"{
                                self.rootLayout.addSubview(self.addContentLayout(tag:132,title: dic!["title"] as! String, str:dic!["prompt"] as! String, text: ""))
                            }
                        }else if (dic!["type"] as! String) == "certificate"{
                            if dic!["type"] as! String == "certificate"{
                                self.rootLayout.addSubview(self.addContentLayout(tag:132,title: dic!["title"] as! String, str:dic!["prompt"] as! String, text: ""))
                            }
                        }else if (dic!["type"] as! String) == "date"{
                            self.rootLayout.addSubview(self.addEndTimeContentLayout(tag:102,title: dic!["title"] as! String, prompt: dic!["prompt"] as! String))
                        }else if (dic!["type"] as! String) == "area"{
                            self.rootLayout.addSubview(self.addFromCityContentLayout(tag:109,title: dic!["title"] as! String, prompt: dic!["prompt"] as! String))
                        }else if dic!["type"] as! String == "remark"{
                            self.rootLayout.addSubview(self.addDonotAskLabContentLayout(tag: 124, title: dic!["title"] as! String))
                            self.rootLayout.addSubview(self.addLevingReasonContentLayout(tag:129,placeHolder: dic!["prompt"] as! String,textTag: 1203, preText: ""))
                        }else if dic!["type"] as! String == "money"{
                            self.rootLayout.addSubview(self.addContentLayout(tag:149,title: dic!["title"] as! String, str:dic!["prompt"] as! String, text: ""))
                            self.rootLayout.addSubview(self.addGrayViewContentLayout(tag: 150, height: AutoGetHeight(height: 13)))
                        }
                        
                        if 0 == i{
                            self.curType = (dic!["type"] as? String)!
                            if self.curType == "leave"{
                                self.getVocationTypeRequest()
                            }
                            
                            
                            if self.curType == "business"{
                                self.selectTraficArr.append("")
                                self.selectIsBackArr.append(false)
                                self.selectFromCityArr.append("")
                                self.selectToCityArr.append("")
                                self.selectStartTimeArr.append("")
                                self.selectEndTimeArr.append("")
                                self.durationArr.append(0.00)
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
                                        DLog(formName)
                                        let subFormType = formDict["type"] as! String
                                        if formName == "vacationType" || subFormType == "person"  {
                                            
                                            if subFormType == "person" {
                                                if formName == "togetherPerson"{
                                                        if self.curType == "business"{
                                                            self.rootLayout.addSubview(self.addDonotAskLabContentLayout(tag: 111, title: formDict["title"] as! String))
                                                        }else{
                                                            self.rootLayout.addSubview(self.addXingLabContentLayout(tag: 111, title: formDict["title"] as! String))
                                                        }
                                                        self.rootLayout.addSubview(self.addCollectionViewContentLayout(tag: 121,height: AutoGetHeight(height: 76),collectionTag: 802))
                                                }else{
                                                    if !(self.isReplace)!{
                                                        self.rootLayout.addSubview(self.addHolidayTypeContentLayout(tag:100,title: formDict["title"] as! String, prompt: ""))
                                                        let btn = (self.rootLayout.viewWithTag(100))?.viewWithTag(200) as! UIButton
                                                        let arrowbtn = (self.rootLayout.viewWithTag(100))?.viewWithTag(4000) as! UIButton
                                                        btn.isUserInteractionEnabled = false
                                                        arrowbtn.isUserInteractionEnabled = false
                                                        arrowbtn.isHidden = true
                                                        self.overTimeModel = CQDepartMentUserListModel.init(uId: STUserTool.account().userID, realN: STUserTool.account().realName, headImag: STUserTool.account().headImage)
                                                    }else{
                                                        self.rootLayout.addSubview(self.addHolidayTypeContentLayout(tag:100,title: formDict["title"] as! String, prompt: formDict["prompt"] as! String))
                                                    }
                                                }
                                                
                                            }else {
                                                self.rootLayout.addSubview(self.addHolidayTypeContentLayout(tag:100,title: formDict["title"] as! String, prompt: formDict["prompt"] as! String))
                                                self.rootLayout.addSubview(self.addMyVocationBalance(tag: 12341, year: "", xiuString: ""))
                                            
                                                self.getTimeForMyVocation()
                                            }
                                            
                                            if subFormType == "person"{
                                                if formName == "togetherPerson"{
                                                    
                                                }else{
                                                   self.rootLayout.addSubview(self.addCollectionViewContentLayout(tag: 127, height: AutoGetHeight(height: 0), collectionTag: 803))
                                                }
                                            }
                                        }else if formName == "startTime"{
                                            self.rootLayout.addSubview(self.addStartTimeContentLayout(tag:101,title: formDict["title"] as! String, prompt: formDict["prompt"] as! String))
                                            
                                                self.rootLayout.addSubview(self.addGreyLineLayout())
                                        }else if formName == "endTime"{
                                            self.rootLayout.addSubview(self.addEndTimeContentLayout(tag:102,title: formDict["title"] as! String, prompt: formDict["prompt"] as! String))
                                                 self.rootLayout.addSubview(self.addGreyLineLayout())
                                        }else if formName == "duration"  {
                                            
                                            self.rootLayout.addSubview(self.addXingWithtwoLabContentLayout(tag:103,title: formDict["title"] as! String, time: self.timeInter))
                                                 self.rootLayout.addSubview(self.addGreyLineLayout())
                                        }else if formName == "modifyReason"  {
                                            self.rootLayout.addSubview(self.addXingLabContentLayout(tag:104,title: formDict["title"] as! String))
                                            self.rootLayout.addSubview(self.addLevingReasonContentLayout(tag:105,placeHolder: formDict["title"] as! String,textTag: 1200, preText: ""))
                                        }else if subFormType == "sub" {
                                            self.rootLayout.addSubview(self.addGrayLabContentLayout(tag:106,title: formDict["title"] as! String))
                                        }else if formName == "transport" {
                                            let transportArr = formDict["dataSource"] as! NSArray
                                            for dic in transportArr{
                                                let transportDic = dic as! NSDictionary
                                                self.transportArray.append(transportDic["text"] as! String)
                                                self.valueTransportArray.append(transportDic["value"] as! String)
                                            }
                                            self.rootLayout.addSubview(self.addTransportTypeContentLayout(tag:107,title: formDict["title"] as! String, prompt: formDict["prompt"] as! String))
                                        }else if formName == "isBack" {
                                            let checkboxArr = formDict["dataSource"] as! NSArray
                                            for dic in checkboxArr{
                                                let checkBoxDic = dic as! NSDictionary
                                                self.checkboxArray.append(checkBoxDic["text"] as! String)
                                            }
                                            self.rootLayout.addSubview(self.addIsBackContentLayout(tag:108,title: formDict["title"] as! String, prompt: formDict["prompt"] as! String))
                                        }else if formName == "fromCity" {
                                            
                                            self.rootLayout.addSubview(self.addFromCityContentLayout(tag:109,title: formDict["title"] as! String, prompt: formDict["prompt"] as! String))
                                        }else if formName == "toCity" {
                                            
                                            self.rootLayout.addSubview(self.addToCityContentLayout(tag:110,title: formDict["title"] as! String, prompt: formDict["prompt"] as! String))
                                        }else if formName == "leaveReason"{
                                            self.rootLayout.addSubview(self.addXingLabContentLayout(tag:113,title: formDict["title"] as! String ))
                                            self.rootLayout.addSubview(self.addLevingReasonContentLayout(tag:114,placeHolder: formDict["title"] as! String,textTag: 1201, preText: "" ))
                                        }else if  formName == "modifyTime"{
                                            self.rootLayout.addSubview(self.addEndTimeContentLayout(tag:121,title: formDict["title"] as! String, prompt: formDict["prompt"] as! String))
                                        }else if formName == "travelDays"{
                                            self.rootLayout.addSubview(self.addXingWithtwoLabContentLayout(tag:122,title: formDict["title"] as! String, time: "\(self.travalDay)" + "天"))
                                        }else if formName == "travelReason"{
                                            self.rootLayout.addSubview(self.addXingLabContentLayout(tag:123,title: formDict["title"] as! String))
                                            self.rootLayout.addSubview(self.addLevingReasonContentLayout(tag:124,placeHolder: formDict["title"] as! String,textTag: 1202, preText: ""))
                                        }else if formName == "remark"{
                                            if self.curType == "business"{
                                                self.rootLayout.addSubview(self.addDonotAskLabContentLayout(tag: 125, title: formDict["title"] as! String))
                                                self.rootLayout.addSubview(self.addLevingReasonContentLayout(tag:126,placeHolder: formDict["title"] as! String,textTag: 1203, preText: ""))
                                            }else{
                                                self.rootLayout.addSubview(self.addXingLabContentLayout(tag:125,title: formDict["title"] as! String))
                                                self.rootLayout.addSubview(self.addLevingReasonContentLayout(tag:126,placeHolder: formDict["title"] as! String,textTag: 1203, preText: ""))
                                            }
                                            
                                        }else if formName == "addDetail"{
                                            self.rootLayout.addSubview(self.addBussinessTraval(tag: 130))
                                            self.rootLayout.addSubview(self.addGrayViewContentLayout(tag: 131, height: AutoGetHeight(height: 13)))
                                        }else if (dic!["type"] as! String) == "email"{
                                            if dic!["type"] as! String == "email"{
                                                self.rootLayout.addSubview(self.addContentLayout(tag:132,title: formDict["title"] as! String, str:formDict["prompt"] as! String, text: ""))
                                            }
                                        }else if (dic!["type"] as! String) == "certificate"{
                                            if dic!["type"] as! String == "certificate"{
                                                self.rootLayout.addSubview(self.addContentLayout(tag:132,title: formDict["title"] as! String, str:formDict["prompt"] as! String, text: ""))
                                            }
                                        }else if dic!["type"] as! String == "upperMoney"{
                                            self.rootLayout.addSubview(self.addContentLayout(tag:138,title: formDict["title"] as! String, str:formDict["prompt"] as! String, text: ""))
                                            self.rootLayout.addSubview(self.addGrayViewContentLayout(tag: 139, height: AutoGetHeight(height: 13)))
                                        }else if (dic!["type"] as! String) == "phnoeNum"{
                                            self.curType = "phnoeNum"
                                            if dic!["type"] as! String == "phnoeNum"{
                                                self.rootLayout.addSubview(self.addContentLayout(tag:132,title: formDict["title"] as! String, str:formDict["prompt"] as! String, text: ""))
                                            }
                                        }else if dic!["type"] as! String == "upperMoney"{
                                            self.rootLayout.addSubview(self.addContentLayout(tag:138,title: formDict["title"] as! String, str:formDict["prompt"] as! String, text: ""))
                                            self.rootLayout.addSubview(self.addGrayViewContentLayout(tag: 139, height: AutoGetHeight(height: 13)))
                                        }else if  dic!["type"] as! String == "department"{
                                            self.rootLayout.addSubview(self.addChoosePersonContentLayout(tag:135,title: formDict["title"] as! String,BtnTag:219))
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
            aId = self.detailBid
        }else{
            aId = self.approvalBusinessId
        }
        var businessId = ""
        if self.isFromSubmitDetail{
            businessId = self.approvalBusinessId
        }else{
            businessId = ""
        }
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/applySubmit" ,
            type: .post,
            param: ["approvalBusinessId":aId,
                    "businessApplyId":businessId,
                    "businessCode":self.businessCode,
                    "copyPersonIds":userIdStr,
                    "emyeId":userId,
                    "formData":data],
            successCallBack: { (result) in
                self.loadingSuccess()
                SVProgressHUD.showSuccess(withStatus: "发布成功")
                self.navigationController?.popViewController(animated: true)
        }) { (error) in
            self.loadingSuccess()
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
                    self.initPickView(tag: 202)
                }
                
        }) { (error) in
            
        }
    }
    
    //获得审批人
    func getApprovalPersonsRequest() {
        let userId = STUserTool.account().userID
        var aId = ""
        if isFromApplyDetail {
            aId = self.detailBid
        }else{
            aId = self.approvalBusinessId
        }
        
        var formData = ""
        if self.isChangeApproveler{
            if self.curType == "leave"{
                let dic = ["businessApplyDatas":[["startTime":self.startTime,
                                                  "vacationType":self.leaveId ?? 0,
                                                  "duration":self.vocationDuration,
                                                  "endTime":self.endTime,
                                                  "leavePerson":["entityId":userId]]]]
                formData = self.getJSONStringFromDictionary(dictionary: dic as NSDictionary)
            }else if self.curType == "overtime" {
                let dic = ["businessApplyDatas":[["startTime":self.startTime,
                                                  "duration":self.vocationDuration,
                                                  "endTime":self.endTime,
                                                  "extraPerson":["entityId":userId]]]]
                formData = self.getJSONStringFromDictionary(dictionary: dic as NSDictionary)
            }else if self.curType == "outWork" {
                let dic = ["businessApplyDatas":[["startTime":self.startTime,
                                                  "duration":self.vocationDuration,
                                                  "endTime":self.endTime,
                                                  "outPerson":["entityId":userId]]]]
                formData = self.getJSONStringFromDictionary(dictionary: dic as NSDictionary)
            }
            
        }
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getApplyApprovalPersons" ,
            type: .post,
            param: ["approvalBusinessId":aId,
                    "businessCode":self.businessCode,
                    "emyeId":userId,
                    "formData":formData],
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
                
                if !self.isChangeApproveler{
                    self.rootLayout.addSubview(self.addGrayViewContentLayout(tag: 115, height: AutoGetHeight(height: 13)))
                    self.rootLayout.addSubview(self.addXingLabContentLayout(tag: 116, title: "审批人"))
                    self.rootLayout.addSubview(self.addCollectionViewContentLayout(tag: 117,height: AutoGetHeight(height: 76),collectionTag: 800))
                    self.rootLayout.addSubview(self.addGrayViewContentLayout(tag: 118, height: AutoGetHeight(height: 13)))
                    self.rootLayout.addSubview(self.addCopyViewContentLayout(tag: 119))
                    self.rootLayout.addSubview(self.addCollectionViewContentLayout(tag: 120,height: AutoGetHeight(height: 76),collectionTag: 801))
                    
                    if self.curType == "leave"{
                        self.headView.frame =  CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight + AutoGetHeight(height: 100))
                    }else if self.curType == "overtime"{
                        self.headView.frame =  CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - AutoGetHeight(height: 60) + AutoGetHeight(height: 240))
                    }else if self.curType == "outWork"{
                        self.headView.frame =  CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - AutoGetHeight(height: 120) + AutoGetHeight(height: 260))
                    }else if self.curType == "business"{
                        self.headView.frame =  CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight + AutoGetHeight(height: 800) + AutoGetHeight(height: 100))
                    }else if self.curType == "modify"{
                        self.headView.frame =  CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - AutoGetHeight(height: 60) + AutoGetHeight(height: 100))
                        self.rootLayout.addSubview(self.addGrayViewContentLayout(tag: 128, height: AutoGetHeight(height: 13)))
                        self.rootLayout.addSubview(self.addCardApplyContentLayout(tag: 129, BtnTag: 208))
                    }else {
                        self.headView.frame =  CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight + AutoGetHeight(height: 300))
                    }
                }
                
                
                self.table.tableHeaderView = self.headView
                self.table.reloadData()
        }) { (error) in
            if !self.isChangeApproveler{
                self.rootLayout.addSubview(self.addGrayViewContentLayout(tag: 115, height: AutoGetHeight(height: 13)))
                self.rootLayout.addSubview(self.addXingLabContentLayout(tag: 116, title: "审批人"))
                self.rootLayout.addSubview(self.addCollectionViewContentLayout(tag: 117,height: AutoGetHeight(height: 76),collectionTag: 800))
                self.rootLayout.addSubview(self.addGrayViewContentLayout(tag: 118, height: AutoGetHeight(height: 13)))
                self.rootLayout.addSubview(self.addCopyViewContentLayout(tag: 119))
                self.rootLayout.addSubview(self.addCollectionViewContentLayout(tag: 120,height: AutoGetHeight(height: 76),collectionTag: 801))
                
                if self.curType == "leave"{
                    self.headView.frame =  CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight + AutoGetHeight(height: 100))
                }else if self.curType == "overtime"{
                    self.headView.frame =  CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - AutoGetHeight(height: 60) + AutoGetHeight(height: 240))
                }else if self.curType == "outWork"{
                    self.headView.frame =  CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - AutoGetHeight(height: 120) + AutoGetHeight(height: 100))
                }else if self.curType == "business"{
                    self.headView.frame =  CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight + AutoGetHeight(height: 800) + AutoGetHeight(height: 100))
                }else if self.curType == "modify"{
                    self.headView.frame =  CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - AutoGetHeight(height: 60) + AutoGetHeight(height: 100))
                    self.rootLayout.addSubview(self.addGrayViewContentLayout(tag: 128, height: AutoGetHeight(height: 13)))
                    self.rootLayout.addSubview(self.addCardApplyContentLayout(tag: 129, BtnTag: 208))
                }
            }
            
            self.table.tableHeaderView = self.headView
            self.table.reloadData()
        }
    }
}

//从我的提交详情进入
extension CQSupplyVC{
    // MARK:request
    fileprivate func loadSubmitDetailData() {
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/approval/getMyApplyDetail",
            type: .get,
            param: ["emyeId":userID,
                    "businessApplyId":self.approvalBusinessId],
            successCallBack: { (result) in
                guard let model = CQMyApplyFormatModel(jsonData: result["data"]) else {
                    return
                }
                
                let contentStr = model.formContent
                let resultStr = model.formData
                let resultDic = self.getDictionaryFromJSONString(jsonString: resultStr)
                //                                    DLog(resultDic)
                let resultArr = resultDic["businessApplyDatas"] as! NSArray
                //                                    DLog(resultArr)
                
                
                if !contentStr.isEmpty{
                    let formData:Data = contentStr.data(using: String.Encoding.utf8)!
                    guard let array = JSON(formData).arrayObject as? [[String: AnyObject]] else {
                        return
                    }
                    for i in 0..<array.count{
                        let arr = array[i]
                        let dic = arr["widget"]
                        
                        if (dic!["type"] as! String) == "phnoeNum"{
                            self.curType = "phnoeNum"
                            if dic!["type"] as! String == "phnoeNum"{
                                self.rootLayout.addSubview(self.addContentLayout(tag:132,title: dic!["title"] as! String, str:dic!["prompt"] as! String, text: ""))
                            }
                        }else if dic!["type"] as! String == "numText"{
                            self.rootLayout.addSubview(self.addMoneyContentLayout(tag: 133, title: dic!["title"] as! String, str: dic!["prompt"] as! String, unit: dic!["unit"] as! String, text: ""))
                            
                        }else if  dic!["type"] as! String == "person"{
                            self.rootLayout.addSubview(self.addChoosePersonContentLayout(tag:134,title: dic!["title"] as! String,BtnTag:210))
                        }
                        else if  dic!["type"] as! String == "department"{
                            self.rootLayout.addSubview(self.addChoosePersonContentLayout(tag:135,title: dic!["title"] as! String,BtnTag:219))
                        }else if  dic!["type"] as! String == "sub"{
                            self.rootLayout.addSubview(self.addGrayLabContentLayout(tag:136,title: dic!["title"] as! String))
                        }else if  dic!["type"] as! String == "select"{
                            let transportArr = dic!["dataSource"] as! NSArray
                            for dic in transportArr{
                                let transportDic = dic as! NSDictionary
                                self.moneyRangeArray.append(transportDic["text"] as! String)
                                self.moneyRangeValueArray.append(transportDic["value"] as! NSNumber)
                            }
                            self.rootLayout.addSubview(self.addMoneyRangeContentLayout(tag: 137, title: dic!["title"] as! String, prompt: dic!["prompt"] as! String))
                        }else if dic!["type"] as! String == "upperMoney"{
                            self.rootLayout.addSubview(self.addContentLayout(tag:138,title: dic!["title"] as! String, str:dic!["prompt"] as! String, text: ""))
                            self.rootLayout.addSubview(self.addGrayViewContentLayout(tag: 139, height: AutoGetHeight(height: 13)))
                        }else if dic!["name"] as! String == "upperMoney0"{
                            self.rootLayout.addSubview(self.addContentLayout(tag:139,title: dic!["title"] as! String, str:dic!["prompt"] as! String, text: ""))
                            self.rootLayout.addSubview(self.addGrayViewContentLayout(tag: 140, height: AutoGetHeight(height: 13)))
                        }else if dic!["type"] as! String == "text"{
                            self.rootLayout.addSubview(self.addDonotAskLabContentLayout(tag: 124, title: dic!["title"] as! String))
                            self.rootLayout.addSubview(self.addLevingReasonContentLayout(tag:126,placeHolder: "",textTag: 1203, preText:""))
                        }else if (dic!["type"] as! String) == "email"{
                            if dic!["type"] as! String == "email"{
                                self.rootLayout.addSubview(self.addContentLayout(tag:132,title: dic!["title"] as! String, str:dic!["prompt"] as! String, text: ""))
                            }
                        }else if (dic!["type"] as! String) == "certificate"{
                            if dic!["type"] as! String == "certificate"{
                                self.rootLayout.addSubview(self.addContentLayout(tag:132,title: dic!["title"] as! String, str:dic!["prompt"] as! String, text: ""))
                            }
                        }else if (dic!["type"] as! String) == "date"{
                            self.rootLayout.addSubview(self.addEndTimeContentLayout(tag:102,title: dic!["title"] as! String, prompt: dic!["prompt"] as! String))
                        }else if (dic!["type"] as! String) == "area"{
                            self.rootLayout.addSubview(self.addFromCityContentLayout(tag:109,title: dic!["title"] as! String, prompt: dic!["prompt"] as! String))
                        }else if dic!["type"] as! String == "remark"{
                            self.rootLayout.addSubview(self.addDonotAskLabContentLayout(tag: 124, title: dic!["title"] as! String))
                            self.rootLayout.addSubview(self.addLevingReasonContentLayout(tag:129,placeHolder: dic!["prompt"] as! String,textTag: 1203, preText: ""))
                        }else if dic!["type"] as! String == "money"{
                            self.rootLayout.addSubview(self.addContentLayout(tag:149,title: dic!["title"] as! String, str:dic!["prompt"] as! String, text: ""))
                            self.rootLayout.addSubview(self.addGrayViewContentLayout(tag: 150, height: AutoGetHeight(height: 13)))
                        }
                        
                        
                        if 0 == i{
                            self.title = dic!["title"] as? String
                            self.curType = (dic!["type"] as? String)!
                            DLog(self.curType)
                            let resultFormDict = resultArr[i] as! NSDictionary
                            if self.curType == "leave" || self.curType == "outWork" || self.curType == "business" || self.curType == "overtime" || self.curType == "modify"{
                                
                                let formArr = dic!["subWidget"]
                                self.isReplace = dic!["isReplace"] as? Bool
                                let a = formArr as! NSArray
                                var leaveStr = ""
                                
                                var businessDetail:NSMutableArray = NSMutableArray.init()
                                if self.curType == "business"{
                                    businessDetail = resultFormDict["businessDetail"] as! NSMutableArray
                                    for dic in businessDetail{
                                        self.selectStartTimeArr.append((dic as! NSDictionary)["startTime"] as! String)
                                        self.selectEndTimeArr.append((dic as! NSDictionary)["endTime"] as! String)
                                        self.selectIsBackArr.append((dic as! NSDictionary)["isBack"] as! Bool)
                                        self.selectTraficArr.append((dic as! NSDictionary)["transport"] as! String)
                                        self.selectFromCityArr.append((dic as! NSDictionary)["fromCity"] as! String)
                                        self.selectToCityArr.append((dic as! NSDictionary)["toCity"] as! String)
                                        self.durationArr.append(Double((dic as! NSDictionary)["duration"] as! String)!)
                                    }
                                }
                                
                                if self.curType == "leave" {
                                    if resultArr.count > 0{
                                        let leaveType = resultFormDict["vacationType"] as? Int
                                        if leaveType == 1 {
                                            leaveStr = "婚假"
                                        }else if leaveType == 2 {
                                            leaveStr = "事假"
                                        }else if leaveType == 3 {
                                            leaveStr = "病假"
                                        }else if leaveType == 4 {
                                            leaveStr = "产假"
                                        }else if leaveType == 5 {
                                            leaveStr = "陪产假"
                                        }else if leaveType == 6 {
                                            leaveStr = "调休"
                                        }else if leaveType == 7 {
                                            leaveStr = "年假"
                                        }else if leaveType == 8 {
                                            leaveStr = "丧假"
                                        }else if leaveType == 9 {
                                            leaveStr = "测试"
                                        }
                                        DLog(leaveType)
                                        
                                    }
                                }
                                
                                if a.count > 0{
                                    for forDict in a {
                                        let formDict = forDict as! NSDictionary
                                        let formName = formDict["name"] as! String
                                        DLog(formName)
                                        self.isReplace = dic!["isReplace"] as? Bool
                                        if self.isReplace == nil{
                                            self.isReplace = false
                                        }
                                        
                                        if formName == "vacationType" || formName == "extraPerson"  {
                                            if formName == "vacationType" {
                                                let leaveArr = formDict["dataSource"] as! NSArray
                                                for dic in leaveArr{
                                                    let leaveDic = dic as! NSDictionary
                                                    self.leaveDataArray.append(leaveDic["text"] as! String)
                                                    self.leaveIdArray.append(leaveDic["value"] as! Int)
                                                }
                                                DLog(self.leaveDataArray)
                                            }
                                            if formName == "extraPerson" {
                                                if !(self.isReplace)!{
                                                    self.rootLayout.addSubview(self.addHolidayTypeContentLayout(tag:100,title: formDict["title"] as! String, prompt: ""))
                                                    let btn = (self.rootLayout.viewWithTag(100))?.viewWithTag(200) as! UIButton
                                                    let arrowbtn = (self.rootLayout.viewWithTag(100))?.viewWithTag(4000) as! UIButton
                                                    btn.isUserInteractionEnabled = false
                                                    arrowbtn.isUserInteractionEnabled = false
                                                    arrowbtn.isHidden = true
                                                    self.overTimeModel = CQDepartMentUserListModel.init(uId: STUserTool.account().userID, realN: STUserTool.account().realName, headImag: STUserTool.account().headImage)
                                                }else{
                                                    self.rootLayout.addSubview(self.addHolidayTypeContentLayout(tag:100,title: formDict["title"] as! String, prompt: (resultFormDict["extraPerson"] as! NSDictionary)["name"] as! String ))
                                                    self.overTimeModel = CQDepartMentUserListModel.init(uId:"\((resultFormDict["extraPerson"] as! NSDictionary)["entityId"] as! NSNumber)", realN: (resultFormDict["extraPerson"] as! NSDictionary)["name"] as! String, headImag: (resultFormDict["extraPerson"] as! NSDictionary)["url"] as! String)
                                                }
                                            }else {
                                                self.rootLayout.addSubview(self.addHolidayTypeContentLayout(tag:100,title: formDict["title"] as! String, prompt: leaveStr))
                                            }
                                            
                                            if formName == "extraPerson"{
                                                self.rootLayout.addSubview(self.addCollectionViewContentLayout(tag: 127, height: AutoGetHeight(height: 0), collectionTag: 803))
                                            }
                                        }else if formName == "startTime"{
                                            if self.curType == "business"{
                                                self.rootLayout.addSubview(self.addStartTimeContentLayout(tag:101,title: formDict["title"] as! String, prompt: (businessDetail[0] as! NSDictionary)["startTime"] as! String))
                                            }else{
                                                self.rootLayout.addSubview(self.addStartTimeContentLayout(tag:101,title: formDict["title"] as! String, prompt: resultFormDict["startTime"] as! String))
                                            }
                                            let displayBtn:UIButton = self.view.viewWithTag(201) as! UIButton
                                            displayBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 90))
                                        }else if formName == "endTime"{
                                            if self.curType == "business"{
                                                self.rootLayout.addSubview(self.addEndTimeContentLayout(tag:102,title: formDict["title"] as! String, prompt: (businessDetail[0] as! NSDictionary)["endTime"] as! String))
                                            }else{
                                                self.rootLayout.addSubview(self.addEndTimeContentLayout(tag:102,title: formDict["title"] as! String, prompt: resultFormDict["endTime"] as! String))
                                            }
                                            let displayBtn:UIButton = self.view.viewWithTag(202) as! UIButton
                                            displayBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 90))
                                        }else if formName == "duration"  {
                                            if self.curType == "business"{
                                                self.rootLayout.addSubview(self.addXingWithtwoLabContentLayout(tag:103,title: formDict["title"] as! String, time: (businessDetail[0] as! NSDictionary)["duration"] as! String + "天"))
                                            }else{
                                                self.rootLayout.addSubview(self.addXingWithtwoLabContentLayout(tag:103,title: formDict["title"] as! String, time: resultFormDict["duration"] as! String + (formDict["unit"] as! String)))
                                            }
                                        }else if formName == "modifyReason"  {
                                            self.rootLayout.addSubview(self.addXingLabContentLayout(tag:104,title: formDict["title"] as! String))
                                            self.rootLayout.addSubview(self.addLevingReasonContentLayout(tag:105,placeHolder: "",textTag: 1200, preText: resultFormDict["modifyReason"] as! String))
                                        }else if formName == "sub" {
                                            if self.curType == "business"{
                                                self.rootLayout.addSubview(self.addGrayLabContentLayout(tag:106,title: formDict["title"] as! String + " 0"))
                                            }else{
                                                self.rootLayout.addSubview(self.addGrayLabContentLayout(tag:106,title: formDict["title"] as! String))
                                            }
                                        }else if formName == "transport" {
                                            let transportArr = formDict["dataSource"] as! NSArray
                                            for dic in transportArr{
                                                let transportDic = dic as! NSDictionary
                                                self.transportArray.append(transportDic["text"] as! String)
                                                self.valueTransportArray.append(transportDic["value"] as! String)
                                            }
                                            if self.curType == "business"{
                                                var tranStr = ""
                                                if ((businessDetail[0] as! NSDictionary)["transport"] as! String) == "plan"{
                                                    tranStr = "飞机"
                                                }else if ((businessDetail[0] as! NSDictionary)["transport"] as! String) == "subway"{
                                                    tranStr = "货车"
                                                }else if ((businessDetail[0] as! NSDictionary)["transport"] as! String) == "bus"{
                                                    tranStr = "汽车"
                                                }else{
                                                    tranStr = "其他"
                                                }
                                                self.rootLayout.addSubview(self.addTransportTypeContentLayout(tag:107,title: formDict["title"] as! String, prompt: tranStr))
                                            }
                                        }else if formName == "isBack" {
                                            let checkboxArr = formDict["dataSource"] as! NSArray
                                            for dic in checkboxArr{
                                                let checkBoxDic = dic as! NSDictionary
                                                self.checkboxArray.append(checkBoxDic["text"] as! String)
                                            }
                                            
                                            var isback = ""
                                            if self.curType == "business"{
                                                if (businessDetail[0] as! NSDictionary)["isBack"] as! Bool{
                                                    isback = "往返"
                                                }else{
                                                    isback = "单程"
                                                }
                                                self.rootLayout.addSubview(self.addIsBackContentLayout(tag:108,title: formDict["title"] as! String, prompt: isback))
                                            }
                                        }else if formName == "fromCity" {
                                            if self.curType == "business"{
                                                self.rootLayout.addSubview(self.addFromCityContentLayout(tag:109,title: formDict["title"] as! String, prompt: (businessDetail[0] as! NSDictionary)["fromCity"] as! String))
                                            }
                                            
                                        }else if formName == "toCity" {
                                            if self.curType == "business"{
                                                self.rootLayout.addSubview(self.addToCityContentLayout(tag:110,title: formDict["title"] as! String, prompt: (businessDetail[0] as! NSDictionary)["toCity"] as! String))
                                            }
                                        }else if formName == "togetherPerson" {//111
                                            if self.curType == "business"{
                                                self.rootLayout.addSubview(self.addDonotAskLabContentLayout(tag: 111, title: formDict["title"] as! String))
                                            }else{
                                                self.rootLayout.addSubview(self.addXingLabContentLayout(tag: 111, title: formDict["title"] as! String))
                                            }
                                            
                                            self.rootLayout.addSubview(self.addCollectionViewContentLayout(tag: 121,height: AutoGetHeight(height: 76),collectionTag: 802))
                                            let arr = resultFormDict["togetherPerson"] as! NSArray
                                            for i in 0..<arr.count{
                                                self.toghterArray.append(CQDepartMentUserListModel.init(uId: (arr[i] as! NSDictionary)["entityId"] as! String, realN: (arr[i] as! NSDictionary)["name"] as! String, headImag: (arr[i] as! NSDictionary)["url"] as! String))
                                            }
                                        }else if formName == "leaveReason"{
                                            self.rootLayout.addSubview(self.addXingLabContentLayout(tag:113,title: formDict["title"] as! String ))
                                            self.rootLayout.addSubview(self.addLevingReasonContentLayout(tag:114,placeHolder: "",textTag: 1201, preText: resultFormDict["leaveReason"] as! String ))
                                        }else if  formName == "modifyTime"{
                                            self.rootLayout.addSubview(self.addEndTimeContentLayout(tag:121,title: formDict["title"] as! String, prompt: resultFormDict["modifyTime"] as! String))
                                        }else if formName == "travelDays"{
                                            if self.curType == "business"{
                                                self.rootLayout.addSubview(self.addXingWithtwoLabContentLayout(tag:122,title: formDict["title"] as! String, time: "\(resultFormDict["travelDays"] as! String)" + "天"))
                                            }
                                        }else if formName == "travelReason"{
                                            self.rootLayout.addSubview(self.addXingLabContentLayout(tag:123,title: formDict["title"] as! String))
                                            if self.curType == "business"{
                                                self.rootLayout.addSubview(self.addLevingReasonContentLayout(tag:124,placeHolder: "",textTag: 1202, preText:resultFormDict["travelReason"] as! String ))
                                            }
                                        }else if formName == "remark"{
                                            
                                            if self.curType == "business"{
                                                self.rootLayout.addSubview(self.addDonotAskLabContentLayout(tag: 111, title: formDict["title"] as! String))
                                                self.rootLayout.addSubview(self.addLevingReasonContentLayout(tag:126,placeHolder: "",textTag: 1203, preText: resultFormDict["remark"] as! String))
                                            }else{
                                                self.rootLayout.addSubview(self.addXingLabContentLayout(tag:125,title: formDict["title"] as! String))
                                                self.rootLayout.addSubview(self.addLevingReasonContentLayout(tag:126,placeHolder: "",textTag: 1203, preText: resultFormDict["remark"] as! String))
                                            }
                                        }else if formName == "addDetail"{
                                            if businessDetail.count > 1 {
                                                businessDetail.removeObject(at: 0)
                                                self.businessDetailCount = businessDetail.count
                                                //下一个按钮的tag值是当前按钮tag  因为当前按钮点击时被移除
                                                //控件从5000+1 + curTralPag
                                                self.curTravalPage = self.curTravalPage + 100
                                                self.curTravalCount = self.curTravalPage/100 + 1
                                                let num = self.curTravalPage/100
                                                
                                                for i in 0..<businessDetail.count{
                                                    self.rootLayout.addSubview(self.addGrayLabWithDeleteLayout(tag: 5000+1 + (self.curTravalPage - 100), title: "行程" + "\(num)", btnTag: 11111 + num))
                                                    var tranStr = ""
                                                    if ((businessDetail[i] as! NSDictionary)["transport"] as! String) == "plan"{
                                                        tranStr = "飞机"
                                                    }else if ((businessDetail[i] as! NSDictionary)["transport"] as! String) == "subway"{
                                                        tranStr = "货车"
                                                    }else if ((businessDetail[i] as! NSDictionary)["transport"] as! String) == "bus"{
                                                        tranStr = "汽车"
                                                    }else{
                                                        tranStr = "其他"
                                                    }
                                                    self.rootLayout.addSubview(self.addTransportTypeContentLayout(tag:5000+2 + (self.curTravalPage - 100),title: "交通工具", prompt: tranStr))
                                                    var isback = ""
                                                    if (businessDetail[i] as! NSDictionary)["isBack"] as! Bool{
                                                        isback = "往返"
                                                    }else{
                                                        isback = "单程"
                                                    }
                                                    self.rootLayout.addSubview(self.addIsBackContentLayout(tag:5003 + (self.curTravalPage - 100),title: "往返单程", prompt: isback))
                                                    self.rootLayout.addSubview(self.addFromCityContentLayout(tag:5004 + (self.curTravalPage - 100),title:"出发城市", prompt: (businessDetail[i] as! NSDictionary)["fromCity"] as! String))
                                                    self.rootLayout.addSubview(self.addToCityContentLayout(tag:5005 + (self.curTravalPage - 100),title:"目的城市", prompt: (businessDetail[i] as! NSDictionary)["toCity"] as! String))
                                                    self.rootLayout.addSubview(self.addStartTimeContentLayout(tag:5006 + (self.curTravalPage - 100),title:"开始时间", prompt: (businessDetail[i] as! NSDictionary)["startTime"] as! String))
                                                    let displayBtn:UIButton = self.view.viewWithTag(201 + 201 * self.curTravalPage) as! UIButton
                                                    displayBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 90))
                                                    self.rootLayout.addSubview(self.addEndTimeContentLayout(tag:5007 + (self.curTravalPage - 100),title:"结束时间", prompt: (businessDetail[i] as! NSDictionary)["endTime"] as! String))
                                                    let displayBtn1:UIButton = self.view.viewWithTag(202 + 201 * self.curTravalPage) as! UIButton
                                                    displayBtn1.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 90))
                                                    self.rootLayout.addSubview(self.addXingWithtwoLabContentLayout(tag:5008 + (self.curTravalPage - 100),title: "时长", time: (businessDetail[i] as! NSDictionary)["duration"] as! String + "天"))
                                                    for v in self.rootLayout.subviews{
                                                        if v.tag == 5000{
                                                            v.removeFromSuperview()
                                                        }
                                                    }
                                                    self.rootLayout.addSubview(self.addTravalButton(tag: 5000))
                                                    self.rootLayout.addSubview(self.addGrayViewContentLayout(tag: 5000+9 + (self.curTravalPage - 100), height: AutoGetHeight(height: 13)))
                                                    self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight + AutoGetHeight(height: 800) + AutoGetHeight(height: 466) * CGFloat(num))
                                                    self.table.tableHeaderView = self.headView
                                                    self.table.reloadData()
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        if (dic!["type"] as! String) == "phnoeNum"{
                            self.curType = "phnoeNum"
                            if dic!["name"] as! String == "phnoeNum1"{
                                self.rootLayout.addSubview(self.addContentLayout(tag:132,title: dic!["title"] as! String, str:"", text: dic!["prompt"] as! String))
                            }
                        }else if dic!["name"] as! String == "numText0"{
                            self.rootLayout.addSubview(self.addMoneyContentLayout(tag: 133, title: dic!["title"] as! String, str: "", unit: dic!["unit"] as! String, text: dic!["prompt"] as! String))
                            
                        }else if  dic!["name"] as! String == "person3"{
                            self.rootLayout.addSubview(self.addChoosePersonContentLayout(tag:134,title: dic!["title"] as! String,BtnTag:210))
                        }
                        else if  dic!["name"] as! String == "department5"{
                            self.rootLayout.addSubview(self.addChoosePersonContentLayout(tag:135,title: dic!["title"] as! String,BtnTag:219))
                        }else if  dic!["name"] as! String == "sub6"{
                            self.rootLayout.addSubview(self.addGrayLabContentLayout(tag:136,title: dic!["title"] as! String))
                        }else if  dic!["name"] as! String == "select7"{
                            let transportArr = dic!["dataSource"] as! NSArray
                            for dic in transportArr{
                                let transportDic = dic as! NSDictionary
                                self.moneyRangeArray.append(transportDic["text"] as! String)
                                self.moneyRangeValueArray.append(transportDic["value"] as! NSNumber)
                            }
                            self.rootLayout.addSubview(self.addMoneyRangeContentLayout(tag: 137, title: dic!["title"] as! String, prompt: dic!["prompt"] as! String))
                        }else if dic!["name"] as! String == "upperMoney0"{
                            self.rootLayout.addSubview(self.addContentLayout(tag:138,title: dic!["title"] as! String, str:"", text: dic!["prompt"] as! String))
                            self.rootLayout.addSubview(self.addGrayViewContentLayout(tag: 139, height: AutoGetHeight(height: 13)))
                        }
                    
                    }
                }
                
                
                self.getApprovalPersonsRequest()
                self.table.reloadData()
        }) { (error) in
        }
    }
    
    /// JSONString转换为字典
    ///
    /// - Parameter jsonString:
    /// - Returns:
    func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        
        let jsonData:Data = jsonString.data(using: .utf8)!
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
        
        
    }
    
    //获取出差外出时长
    func calculateDurationRequest(type:String,start:String,end:String,i:Int) {
        
        let userId = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/calculateDuration" ,
            type: .get,
            param: ["emyeId":userId,
                    "endTime":end,
                    "startTime":start,
                    "type":type],
            successCallBack: { (result) in
                if type == "businessTravel"{
                    self.businessDuration = result["data"]["duration"].stringValue
                    self.businessUnit = result["data"]["unit"].stringValue
                    self.travalDay = result["data"]["duration"].doubleValue
                    
                    self.durationArr.replaceSubrange(Range(i..<i+1), with: [self.travalDay])
                    self.travalDay = 0
                    for time in self.durationArr{
                        self.travalDay += time
                    }
                    
                    for wrap in self.rootLayout.subviews{
                        if 122 == wrap.tag {
                            for lab in wrap.subviews{
                                if 54 == lab.tag{
                                    let curLab:UILabel = lab as! UILabel
                                    curLab.text = String.init(format: "%.1f", self.travalDay) + "天"
                                }
                            }
                        }
                    }
                    
                    
                    if i == 0{
                        for wrap in self.rootLayout.subviews{
                            if 103 == wrap.tag {
                                for lab in wrap.subviews{
                                    if 54 == lab.tag{
                                        let curLab:UILabel = lab as! UILabel
                                        curLab.text = self.businessDuration + self.businessUnit
                                    }
                                }
                            }
                        }
                    }else{
                        for wrap in self.rootLayout.subviews{
                            if 130 == wrap.tag{
                                for subWrap in wrap.subviews{
                                    if 10000 == subWrap.tag {
                                        for DSubWrap in subWrap.subviews{
                                            if (i-1)*100 + 5008 == DSubWrap.tag{
                                                for lab in DSubWrap.subviews{
                                                    if 54 == lab.tag{
                                                        let curLab:UILabel = lab as! UILabel
                                                        curLab.text = self.businessDuration + self.businessUnit
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }else if type == "outWork" || type == "extra"{
                    self.vocationDuration = result["data"]["duration"].stringValue
                    self.vocationUnit = result["data"]["unit"].stringValue
                    self.timeInter = self.vocationDuration + self.vocationUnit
                    for wrap in self.rootLayout.subviews{
                        if 103 == wrap.tag {
                            for lab in wrap.subviews{
                                if 54 == lab.tag{
                                    let curLab:UILabel = lab as! UILabel
                                    curLab.text = self.timeInter
                                }
                            }
                        }
                    }
                }
                
                
        }) { (error) in
            
        }
    }
}

//Mark 各个水平模块

extension CQSupplyVC{
    //选择请假类型
    internal func addHolidayTypeContentLayout(tag:Int,title:String,prompt:String) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
//        let actionLayout = TGLinearLayout(.vert)//竖直
//        actionLayout.tg_width.equal(.wrap)
//        actionLayout.tg_height.equal(.wrap)
//        wrapContentLayout.addSubview(actionLayout)
        
        wrapContentLayout.addSubview(self.addxingLable())
        wrapContentLayout.addSubview(self.addLable(title, tag: 50,labWidth: AutoGetWidth(width: 75)))
        wrapContentLayout.addSubview(self.addChooseHolidayTypeBtn(title: prompt, tag: 200 + (self.curTravalPage * 201)))
        wrapContentLayout.addSubview(self.addArrowBtn(tag: 4000))
        return wrapContentLayout
    }
    
    //选择开始时间
    internal func addStartTimeContentLayout(tag:Int,title:String,prompt:String) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addxingLable())
        wrapContentLayout.addSubview(self.addLable(title, tag: 51,labWidth: AutoGetWidth(width: 75)))
        wrapContentLayout.addSubview(self.addChooseHolidayTypeBtn(title: prompt, tag: 201 + (self.curTravalPage * 201)))
        wrapContentLayout.addSubview(self.addArrowBtn(tag: 4000))
        return wrapContentLayout
    }
  
    internal func addGreyLineLayout()->TGLinearLayout{
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        
        let greyLine = UIView()
        greyLine.backgroundColor = kfilterBackColor
        greyLine.tg_height.equal(AutoGetWidth(width: 0.6))
        greyLine.tg_width.equal(kWidth)
        wrapContentLayout.addSubview(greyLine)

        return wrapContentLayout
    }
    
    //选择结束时间
    internal func addEndTimeContentLayout(tag:Int,title:String,prompt:String) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addxingLable())
        wrapContentLayout.addSubview(self.addLable(title, tag: 52,labWidth: AutoGetWidth(width: 75)))
        wrapContentLayout.addSubview(self.addChooseHolidayTypeBtn(title: prompt, tag: 202 + (self.curTravalPage * 201)))
        wrapContentLayout.addSubview(self.addArrowBtn(tag:4000))
        return wrapContentLayout
    }
    
    //金额合同人员选择
    internal func addChoosePersonContentLayout(tag:Int,title:String,BtnTag:Int) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        
        let actionLayout = TGLinearLayout(.vert)//竖直
        actionLayout.tg_width.equal(.wrap)
        actionLayout.tg_height.equal(.wrap)
        actionLayout.tag = 101
        wrapContentLayout.tag = tag
        wrapContentLayout.addSubview(actionLayout)
        
        actionLayout.addSubview(self.addPersonChooseHorzContentLayout(tag: 102, title: title, BtnTag: BtnTag))
        
        return wrapContentLayout
    }
    
    //人员选择空间
    internal func addPersonChooseHorzContentLayout(tag:Int,title:String,BtnTag:Int) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addLable(title, tag: 52,labWidth: AutoGetWidth(width: 90)))
        let lab0:UILabel = wrapContentLayout.viewWithTag(52) as! UILabel
        lab0.tg_left.equal(kLeftDis)
        wrapContentLayout.addSubview(self.addChooseHolidayTypeBtn(title: "", tag: BtnTag))
        wrapContentLayout.addSubview(self.addArrowBtn(tag:4000))
       
        return wrapContentLayout
    }
    
    
    //请假时长（带星双Lab）
    internal func addXingWithtwoLabContentLayout(tag:Int,title:String,time:String) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addxingLable())
        wrapContentLayout.addSubview(self.addLable(title, tag: 53,labWidth: AutoGetWidth(width: 75)))
        wrapContentLayout.addSubview(self.addLable(time, tag: 54,labWidth: kWidth - AutoGetWidth(width: 120)))
        let lab:UILabel = wrapContentLayout.viewWithTag(54) as! UILabel
        lab.textAlignment = .right
        return wrapContentLayout
    }
    
    //出差时长（带星双Lab）
    internal func addTravalDaysLabContentLayout(tag:Int,title:String) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addxingLable())
        wrapContentLayout.addSubview(self.addLable(title, tag: 55,labWidth: AutoGetWidth(width: 75)))
        wrapContentLayout.addSubview(self.addLable("2小时", tag: 56,labWidth: kWidth - AutoGetWidth(width: 120)))
        let lab:UILabel = wrapContentLayout.viewWithTag(56) as! UILabel
        lab.textAlignment = .right
        return wrapContentLayout
    }
    
    //非必填标题
    internal func addDonotAskLabContentLayout(tag:Int,title:String) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addLable(title, tag: 53,labWidth:AutoGetWidth(width: 75) ))
        let lab0:UILabel = wrapContentLayout.viewWithTag(53) as! UILabel
        lab0.tg_left.equal(kLeftDis)
        return wrapContentLayout
    }
    
    //带*标题 无选择
    internal func addXingLabContentLayout(tag:Int,title:String) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addxingLable())
        wrapContentLayout.addSubview(self.addLable(title, tag: 57,labWidth:AutoGetWidth(width: 75) ))
        return wrapContentLayout
    }
    
    //非必填
    internal func addContentLayout(tag:Int,title:String,str:String,text:String) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addLable(title, tag: 53,labWidth: AutoGetWidth(width: 75)))
        let lab0:UILabel = wrapContentLayout.viewWithTag(53) as! UILabel
        lab0.tg_left.equal(kLeftDis)
        wrapContentLayout.addSubview(self.addFieldInput(tag: 88, placeHolder: str, text:text ))
        return wrapContentLayout
    }
    
    //非必填之金额
    internal func addMoneyContentLayout(tag:Int,title:String,str:String,unit:String,text:String) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addLable(title, tag: 53,labWidth: AutoGetWidth(width: 75)))
        let lab0:UILabel = wrapContentLayout.viewWithTag(53) as! UILabel
        lab0.tg_left.equal(kLeftDis)
        wrapContentLayout.addSubview(self.addFieldInput(tag: 88, placeHolder: str, text: text))
        let txt:MyTextField = wrapContentLayout.viewWithTag(88) as! MyTextField
        txt.tg_width.equal(kWidth - AutoGetWidth(width: 135))
        wrapContentLayout.addSubview(self.addUnitLable(unit, tag: 89))
        return wrapContentLayout
    }
    
    //请假事由
    internal func addLevingReasonContentLayout(tag:Int,placeHolder:String,textTag:Int,preText:String) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        
        wrapContentLayout.addSubview(self.addtextContentView(leftDis: AutoGetWidth(width: 30),placeHolder:placeHolder,tag:textTag, pretext: preText ))
        
        return wrapContentLayout
    }
    
    //灰色留白（行程）
    internal func addGrayLabContentLayout(tag:Int,title:String) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(kWidth)
        wrapContentLayout.backgroundColor = kProjectBgColor
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addHaveLeftDisLable(title, tag: 58))
        let lab = wrapContentLayout.viewWithTag(58) as! UILabel
        lab.tg_height.equal(AutoGetHeight(height: 20))
        lab.font = kFontSize13
        lab.textColor = kLyGrayColor
        return wrapContentLayout
    }
    
    //选择交通工具类型
    internal func addTransportTypeContentLayout(tag:Int,title:String,prompt:String) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addxingLable())
        wrapContentLayout.addSubview(self.addLable(title, tag: 59,labWidth: AutoGetWidth(width: 75)))
        wrapContentLayout.addSubview(self.addChooseHolidayTypeBtn(title: prompt, tag: 203 + (self.curTravalPage * 201)))
        wrapContentLayout.addSubview(self.addArrowBtn(tag: 4000))
        return wrapContentLayout
    }
    
    //选择往返
    internal func addIsBackContentLayout(tag:Int,title:String,prompt:String) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addxingLable())
        wrapContentLayout.addSubview(self.addLable(title, tag: 60,labWidth: AutoGetWidth(width: 75)))
        wrapContentLayout.addSubview(self.addChooseHolidayTypeBtn(title: prompt, tag: 204 + (self.curTravalPage * 201)))
        wrapContentLayout.addSubview(self.addArrowBtn(tag: 4000))
        return wrapContentLayout
    }
    
    //选择出发城市
    internal func addFromCityContentLayout(tag:Int,title:String,prompt:String) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addxingLable())
        wrapContentLayout.addSubview(self.addLable(title, tag: 61,labWidth: AutoGetWidth(width: 75)))
        wrapContentLayout.addSubview(self.addChooseHolidayTypeBtn(title: prompt, tag: 205 + (self.curTravalPage * 201)))
        let btn = wrapContentLayout.viewWithTag(205 + (self.curTravalPage * 201)) as! UIButton
        btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 125))
        wrapContentLayout.addSubview(self.addArrowBtn(tag: 4000))
        return wrapContentLayout
    }
    
    //选择到达城市
    internal func addToCityContentLayout(tag:Int,title:String,prompt:String) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addxingLable())
        wrapContentLayout.addSubview(self.addLable(title, tag: 62,labWidth: AutoGetWidth(width: 75)))
        wrapContentLayout.addSubview(self.addChooseHolidayTypeBtn(title: prompt, tag: 206 + (self.curTravalPage * 201)))
        let btn = wrapContentLayout.viewWithTag(206 + (self.curTravalPage * 201)) as! UIButton
        btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 125))
        wrapContentLayout.addSubview(self.addArrowBtn(tag: 4000))
        return wrapContentLayout
    }
    
    //选择同行人
    internal func addTogetherPersonContentLayout(tag:Int,title:String,prompt:String) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addxingLable())
        wrapContentLayout.addSubview(self.addLable(title, tag: 63,labWidth: AutoGetWidth(width: 75)))
        wrapContentLayout.addSubview(self.addChooseHolidayTypeBtn(title: prompt, tag: 207 + (self.curTravalPage * 201)))
        wrapContentLayout.addSubview(self.addArrowBtn(tag: 4000))
        return wrapContentLayout
    }
    
    //选择金额临界值
    internal func addMoneyRangeContentLayout(tag:Int,title:String,prompt:String) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addLable(title, tag: 59,labWidth: AutoGetWidth(width: 90)))
        let lab0:UILabel = wrapContentLayout.viewWithTag(59) as! UILabel
        lab0.tg_left.equal(kLeftDis)
        wrapContentLayout.addSubview(self.addChooseHolidayTypeBtn(title: prompt, tag: 220 ))
        wrapContentLayout.addSubview(self.addArrowBtn(tag: 4000))
        return wrapContentLayout
    }
    
    //选择部门UI
    internal func addDepartMentContentLayout(tag:Int,title:String,btnTag:Int) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addDepartMentButton(tag: btnTag, title: title))
        return wrapContentLayout
    }
    
    //collectionView
    internal func addCollectionViewContentLayout(tag:Int,height:CGFloat,collectionTag:Int) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        
        wrapContentLayout.addSubview(self.addCollectionView(leftDis: kLeftDis, delegate: self, dataSource: self, tag: collectionTag,height:height))
        return wrapContentLayout
    }
    
    //灰色区域
    internal func addGrayViewContentLayout(tag:Int,height:CGFloat) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(height)
        wrapContentLayout.tg_width.equal(kWidth)
        wrapContentLayout.backgroundColor = kProjectBgColor
        wrapContentLayout.tag = tag
        
        return wrapContentLayout
    }
    
    //抄送人
    internal func addCopyViewContentLayout(tag:Int) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addLable("抄送人", tag: 64,labWidth: AutoGetWidth(width: 75)))
        let lab:UILabel = wrapContentLayout.viewWithTag(64) as! UILabel
        lab.tg_left.equal(kLeftDis)
        wrapContentLayout.addSubview(self.addLable("审批通过后,通知抄送人", tag: 65,labWidth: kWidth - AutoGetWidth(width: 90)))
        let lab1:UILabel = wrapContentLayout.viewWithTag(65) as! UILabel
        lab1.textColor = kLyGrayColor
        return wrapContentLayout
    }
    
    //补卡申请
    internal func addCardApplyContentLayout(tag:Int,BtnTag:Int) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(kWidth)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addCardApplyButton(tag: BtnTag))
        
        return wrapContentLayout
    }
    
    //灰色留白（行程）带删除
    internal func addGrayLabWithDeleteLayout(tag:Int,title:String,btnTag:Int) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(kWidth)
        wrapContentLayout.backgroundColor = kProjectBgColor
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addHaveLeftDisLable(title, tag: 58))
        let lab = wrapContentLayout.viewWithTag(58) as! UILabel
        lab.tg_height.equal(AutoGetHeight(height: 20))
        lab.tg_width.equal(kWidth - AutoGetWidth(width: 70))
        lab.textColor = kLyGrayColor
        wrapContentLayout.addSubview(self.addDeleteButton(tag: btnTag))
        return wrapContentLayout
    }
    
    //增加行程
    internal func addBussinessTraval(tag:Int) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        let actionLayout = TGLinearLayout(.vert)//竖直
        actionLayout.tg_width.equal(.wrap)
        actionLayout.tg_height.equal(.wrap)
        actionLayout.tag = (self.curTravalPage + 1) * 10000
        wrapContentLayout.addSubview(actionLayout)
        
        actionLayout.addSubview(self.addTravalButton(tag: 5000))
        
        return wrapContentLayout
    }
    
    //增加行程内容
    internal func addClickTraval(tag:Int,superV:TGLinearLayout) -> TGLinearLayout
    {
        //下一个按钮的tag值是当前按钮tag  因为当前按钮点击时被移除
        //控件从5000+1 + curTralPag
        self.curTravalPage = self.curTravalPage + 100
        self.curTravalCount = self.curTravalPage/100 + 1
        let num = self.curTravalPage/100
        self.selectTraficArr.append("")
        self.selectIsBackArr.append(false)
        self.selectFromCityArr.append("")
        self.selectToCityArr.append("")
        self.selectStartTimeArr.append("")
        self.selectEndTimeArr.append("")
        self.durationArr.append(0.00)
        superV.addSubview(self.addGrayLabWithDeleteLayout(tag: tag+1 + (self.curTravalPage - 100), title: "行程" + "\(num)", btnTag: 11111 + num))
        superV.addSubview(self.addTransportTypeContentLayout(tag:tag+2 + (self.curTravalPage - 100),title: "交通工具", prompt: "(必填)"))
        superV.addSubview(self.addIsBackContentLayout(tag:tag+3 + (self.curTravalPage - 100),title: "单程往返", prompt: "(必填)"))
        superV.addSubview(self.addFromCityContentLayout(tag:tag+4 + (self.curTravalPage - 100),title: "出发城市", prompt: "(必填)"))
        superV.addSubview(self.addToCityContentLayout(tag:tag+5 + (self.curTravalPage - 100),title: "目的城市", prompt: "(必填)"))
        superV.addSubview(self.addStartTimeContentLayout(tag:tag+6 + (self.curTravalPage - 100),title: "开始时间", prompt: "(必填)"))
        superV.addSubview(self.addEndTimeContentLayout(tag:tag+7 + (self.curTravalPage - 100),title: "结束时间", prompt: "(必填)"))
        superV.addSubview(self.addXingWithtwoLabContentLayout(tag:tag+8 + (self.curTravalPage - 100),title: "时长(天)", time: self.timeInter))
        for v in superV.subviews{
            if v.tag == 5000{
                v.removeFromSuperview()
            }
        }
        superV.addSubview(self.addTravalButton(tag: 5000))
        superV.addSubview(self.addGrayViewContentLayout(tag: tag+9 + (self.curTravalPage - 100), height: AutoGetHeight(height: 13)))
        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight + AutoGetHeight(height: 800) + AutoGetHeight(height: 466) * CGFloat(num))
        self.table.tableHeaderView = self.headView
        self.table.reloadData()
        return superV
    }
    
    //我的假期
    internal func addMyVocationBalance(tag:Int,year:String,xiuString:String) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(kWidth)
        wrapContentLayout.backgroundColor = UIColor.colorWithHexString(hex: "#f2f6fc")
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addVocationLable(year: year, xiu: xiuString))
        wrapContentLayout.addSubview(self.addMyVocationButton())
        return wrapContentLayout
    }
}

// Mark 整个界面可能用到的控件
extension CQSupplyVC {
    @objc internal func addContentView() -> UIView {
        let contentV = UIView.init()
        contentV.backgroundColor = UIColor.white
        return contentV
    }

    @objc internal func addxingLable() -> UILabel{
        let lab = UILabel.init()
        lab.text = "*"
        lab.font = kFontSize15
        lab.textAlignment = .center
        lab.textColor = UIColor.red
        lab.tg_height.equal(AutoGetHeight(height: 55))
        lab.tg_width.equal(AutoGetWidth(width: 30))
        return lab
    }
    
    @objc internal func addVocationLable(year:String,xiu:String) -> UILabel{
        let lab = UILabel.init()
        lab.text = "年假: 剩余" + year + "天" + "   调休: 剩余" + xiu + "小时"
        lab.font = kFontSize13
        lab.textAlignment = .left
        lab.textColor = kLyGrayColor
        lab.tag = 100
        lab.tg_left.equal(AutoGetWidth(width: 30))
        lab.tg_height.equal(AutoGetHeight(height: 55))
        lab.tg_width.equal(kWidth - AutoGetWidth(width: 45) - AutoGetWidth(width: 70) )
        return lab
    }
    
    
    @objc internal func addLable(_ title:String, tag:NSInteger,labWidth:CGFloat) -> UILabel{
        let lab = UILabel.init()
        lab.text = title
        lab.font = kFontSize15
        lab.textAlignment = .left
        lab.textColor = UIColor.black
        lab.tag = tag
//        lab.adjustsFontSizeToFitWidth =  true
        lab.tg_width.equal(labWidth)
        lab.tg_height.equal(AutoGetHeight(height: 55))
        return lab
    }
    
    @objc internal func addChooseHolidayTypeBtn(title:String,tag:NSInteger) -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.addTarget(self ,action:#selector(handleAction), for:.touchUpInside)
        btn.setTitle(title ,for:.normal)
//        btn.titleLabel!.adjustsFontSizeToFitWidth = true
        btn.titleLabel!.font = kFontSize15
        btn.setTitleColor(kLyGrayColor, for: .normal)
        btn.tag = tag
        btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 145))
        btn.tg_height.equal(AutoGetHeight(height: 55))
        btn.tg_width.equal(kWidth - AutoGetWidth(width: 126.5))
        return btn
    }
    
    @objc internal func addArrowBtn(tag:Int) -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "PersonAddressArrow"), for: .normal)
        btn.tg_height.equal(AutoGetHeight(height: 55))
        btn.tg_width.equal(AutoGetWidth(width: 6.5))
        btn.tag = tag
        return btn
    }
    
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
    
    @objc internal func addLeftDisContentView() -> UIView {
        let contentV = UIView.init()
        contentV.backgroundColor = UIColor.white
        contentV.tg_width.equal(AutoGetWidth(width: 15))
        contentV.tg_height.equal(AutoGetHeight(height: 55))
        return contentV
    }
    //有左边距的lab
    @objc internal func addHaveLeftDisLable(_ title:String, tag:NSInteger) -> UILabel{
        let lab = UILabel.init()
        lab.text = title
        lab.font = kFontSize15
        lab.textAlignment = .left
        lab.textColor = UIColor.black
        lab.tag = tag
        //        lab.adjustsFontSizeToFitWidth =  true
        lab.tg_left.equal(kLeftDis)
        lab.tg_width.equal(AutoGetWidth(width: 75))
        lab.tg_height.equal(AutoGetHeight(height: 55))
        return lab
    }
    
    //请假事由(包含各种描述)
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
//        textView.layer.borderWidth = 0.5
//        textView.layer.cornerRadius = 2
        textView.tag = tag
        textView.placeHolder = "请输入" + placeHolder + "..."
        textView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
//        textView.textView.text = pretext
        if !pretext.isEmpty {
            textView.prevText = pretext
        }
        
        return textView
    }
    
    //collectionView
    @objc internal func addCollectionView(leftDis:CGFloat,delegate:UICollectionViewDelegate,dataSource:UICollectionViewDataSource,tag:Int,height:CGFloat) -> UICollectionView {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width:kHaveLeftWidth/4, height:AutoGetHeight(height: 75))
        layOut.minimumLineSpacing = 10
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kHaveLeftWidth, height:height), collectionViewLayout: layOut)
        collectionView.tg_left.equal(leftDis)
        collectionView.tg_width.equal(kWidth - 2*leftDis)
        collectionView.tg_height.equal((kHaveLeftWidth-AutoGetWidth(width: 30))/4 )
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        collectionView.tag = tag
        
        collectionView.register(CQWriteReportCell.self, forCellWithReuseIdentifier: "CQWriteReportCellId")
        
        return collectionView
    }
    
    func addDepartMentButton(tag:Int,title:String) -> UIButton {
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
        btn.tg_left.equal(kLeftDis)
        btn.tg_height.equal(AutoGetHeight(height: 40))
        btn.tg_width.equal(kWidth/4)
        btn.tg_bottom.equal(AutoGetHeight(height: 10))
        return btn
    }
    
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
        btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: AutoGetWidth(width: 250))
        btn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 320))
        btn.tg_height.equal(AutoGetHeight(height: 55))
        btn.tg_width.equal(kWidth )
        return btn
    }
    
    func addTravalButton(tag:Int) -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.addTarget(self ,action:#selector(handleAction), for:.touchUpInside)
        btn.setTitle(title ,for:.normal)
        btn.titleLabel!.font = kFontSize15
        btn.setTitleColor(kLightBlueColor, for: .normal)
        btn.setTitle(" 增加行程", for: .normal)
        btn.setImage(UIImage.init(named: "PersonAddressAdd"), for: .normal)
        btn.tag = tag
//        btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: AutoGetWidth(width: 280))
//        btn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 400))
        btn.tg_height.equal(AutoGetHeight(height: 55))
        btn.tg_width.equal(kWidth)
        return btn
    }
    
    func addDeleteButton(tag:Int) -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.addTarget(self ,action:#selector(handleAction), for:.touchUpInside)
        btn.setTitle(title ,for:.normal)
        btn.titleLabel!.font = kFontSize13
        btn.setTitleColor(kLightBlueColor, for: .normal)
        btn.setTitle("删除", for: .normal)
        btn.tag = tag
        //        btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: AutoGetWidth(width: 280))
        //        btn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 400))
        btn.tg_height.equal(AutoGetHeight(height: 20))
        btn.tg_width.equal(AutoGetWidth(width: 55))
        btn.tg_right.equal(kLeftDis)
        return btn
    }
    
    func addMyVocationButton() -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.addTarget(self ,action:#selector(myVocationClick), for:.touchUpInside)
        btn.titleLabel!.font = kFontSize13
        btn.setTitleColor(kLightBlueColor, for: .normal)
        btn.setTitle(" 我的假期", for: .normal)
        //btn.tg_right.equal(AutoGetHeight(height: 15))
        btn.tg_height.equal(AutoGetHeight(height: 55))
        btn.tg_width.equal(AutoGetWidth(width: 70))
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: AutoGetWidth(width: 9), bottom: 0, right: -AutoGetWidth(width: 9))
        return btn
    }
}

//MARK: - Handle Method
extension CQSupplyVC
{
    @objc internal func handleAction(_ sender :UIButton)
    {
        if self.curTravalCount > 0{
            for i in 0..<self.curTravalCount {
                //选择请假类型
                if sender.tag == (100 * 201) * i + 200
                {
                    if self.curType == "overtime" {
                        if self.isReplace! {
                            let vc = AddressBookVC.init()
                            vc.toType = .fromOverTime
                            if self.overTimeModel != nil{
                                vc.hasSelectModelArr = [self.overTimeModel] as! [CQDepartMentUserListModel]
                            }
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else{
                            self.overTimeModel?.headImage = STUserTool.account().headImage
                            self.overTimeModel?.realName = STUserTool.account().realName
                            self.overTimeModel?.userId = STUserTool.account().userID
                        }
                    }else{
                        self.initPickView(tag: sender.tag)
                        
                    }
                }
                    //选择开始时间
                else if sender.tag == (100 * 201) * i + 201
                {
                    self.initDatePickView(tag: sender.tag)
                }
                    //选择结束时间
                else if sender.tag == (100 * 201) * i + 202
                {
                    if self.curType == "modify"{
                        self.checkModifyTimeRequest()
                    }else{
                        self.initDatePickView(tag: sender.tag)
                    }
                }
                    //选择交通工具
                else if sender.tag == (100 * 201) * i + 203
                {
                    self.initPickView(tag: sender.tag)
                }
                    //选择往返
                else if sender.tag == (100 * 201) * i + 204
                {
                    self.initPickView(tag: sender.tag)
                }
                    //选择出发城市
                else if sender.tag == (100 * 201) * i + 205
                {
                    self.initAddressPickView(tag: sender.tag)
                }
                    //选择到达城市
                else if sender.tag == (100 * 201) * i + 206
                {
                    self.initAddressPickView(tag: sender.tag)
                }
                    //选择同行人
                else if (sender.tag == 207)
                {
                    
                }
                    //补卡申请
                else if (sender.tag == 208)
                {
                    let vc = CQCardApplyVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                    //增加行程
                else if (sender.tag == 5000)
                {
                    
                    sender.superview?.superview!.addSubview(self.addClickTraval(tag: sender.tag, superV: sender.superview! as! TGLinearLayout))
                }
                    //金额合同选择人员
                else if (sender.tag == 210)
                {
                    
                    
                }
                else if (sender.tag == 11111 + i )
                {
                    /*
                     self.curTravalPage -= 100
                     self.curTravalCount = self.curTravalCount - 1
                     let num = i - 1
                     self.selectTraficArr.remove(at: i)
                     self.selectIsBackArr.remove(at: i)
                     self.selectFromCityArr.remove(at: i)
                     self.selectToCityArr.remove(at: i)
                     self.selectStartTimeArr.remove(at: i)
                     self.selectEndTimeArr.remove(at: i)
                     self.durationArr.remove(at: i)
                     let v = self.rootLayout.viewWithTag(130)
                     for subV in (v?.subviews)!{
                     if subV.tag == 10000{
                     for dV in subV.subviews{
                     if dV.tag == 5000 + (i-1) * 100 + 1 {
                     dV.removeFromSuperview()
                     }else if dV.tag == 5000 + (i-1) * 100 + 2 {
                     dV.removeFromSuperview()
                     }else if dV.tag == 5000 + (i-1) * 100 + 3 {
                     dV.removeFromSuperview()
                     }else if dV.tag == 5000 + (i-1) * 100 + 4 {
                     dV.removeFromSuperview()
                     }else if dV.tag == 5000 + (i-1) * 100 + 5 {
                     dV.removeFromSuperview()
                     }else if dV.tag == 5000 + (i-1) * 100 + 6 {
                     dV.removeFromSuperview()
                     }else if dV.tag == 5000 + (i-1) * 100 + 7 {
                     dV.removeFromSuperview()
                     }else if dV.tag == 5000 + (i-1) * 100 + 8 {
                     dV.removeFromSuperview()
                     }else if dV.tag == 5000 + (i-1) * 100 + 9 {
                     dV.removeFromSuperview()
                     }
                     }
                     }
                     }
                     
                     for subV in (v?.subviews)!{
                     if subV.tag == 10000{
                     for dV in subV.subviews{
                     if dV.tag == 5000 + (i-1) * 100 + 1 {
                     for sdv in dV.subviews{
                     if sdv is UIButton{
                     sdv.tag = 11112 + (i-1)
                     }
                     }
                     }
                     }
                     }
                     }
                     
                     self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight + AutoGetHeight(height: 800) + AutoGetHeight(height: 466) * CGFloat(num))
                     self.table.tableHeaderView = self.headView
                     self.table.reloadData()
                     */
                    SVProgressHUD.showInfo(withStatus: "目前暂不支持删除功能！")
                }
            }
        }else{
            //选择请假类型
            if (sender.tag == 200)
            {
                if self.curType == "overtime" {
                    if self.isReplace! {
                        let vc = AddressBookVC.init()
                        vc.toType = .fromOverTime
                        if self.overTimeModel != nil{
                            vc.hasSelectModelArr = [self.overTimeModel] as! [CQDepartMentUserListModel]
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        self.overTimeModel?.headImage = STUserTool.account().headImage
                        self.overTimeModel?.realName = STUserTool.account().realName
                        self.overTimeModel?.userId = STUserTool.account().userID
                    }
                }else{
                    self.initPickView(tag: sender.tag)
                    
                }
            }
                //选择开始时间
            else if (sender.tag == 201)
            {
                self.initDatePickView(tag: sender.tag)
            }
                //选择结束时间
            else if (sender.tag == 202)
            {
                if self.curType == "modify"{
                    self.checkModifyTimeRequest()
                }else{
                    self.initDatePickView(tag: sender.tag)
                }
            }
                //选择交通工具
            else if (sender.tag == 203)
            {
                self.initPickView(tag: sender.tag)
            }
                //选择往返
            else if (sender.tag == 204)
            {
                self.initPickView(tag: sender.tag)
            }
                //选择出发城市
            else if (sender.tag == 205)
            {
                self.initAddressPickView(tag: sender.tag)
            }
                //选择到达城市
            else if (sender.tag == 206)
            {
                self.initAddressPickView(tag: sender.tag)
            }
                //选择同行人
            else if (sender.tag == 207)
            {
                
            }
                //补卡申请
            else if (sender.tag == 208)
            {
                let vc = CQCardApplyVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
                //增加行程
            else if (sender.tag == 5000)
            {
                sender.superview?.superview!.addSubview(self.addClickTraval(tag: sender.tag, superV: sender.superview! as! TGLinearLayout))
            }else if (sender.tag == 210)
            {
                let vc = AddressBookVC.init()
                vc.toType = .fromOverTime
                if self.overTimeModel != nil{
                    vc.hasSelectModelArr = [self.overTimeModel] as! [CQDepartMentUserListModel]
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }else if (sender.tag == 219)
            {
                let vc = AddressBookVC.init()
                vc.toType = .fromChooseDepart
                vc.selectDelegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            } //选择金额临界值
            else if (sender.tag == 220)
            {
                self.initPickView(tag: sender.tag)
            }//删除按钮
            else if (sender.tag == 221)
            {
                DLog("1111111111")
                self.newDeparment = false
                sender.removeFromSuperview()
            }
        }
    }
    
    @objc func myVocationClick()  {
        let vc = CQMyLeaveListVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK:datapicker构造及点击事件
extension CQSupplyVC{
    func initDatePickView(tag:Int)  {
        let currentTag = tag - 200
        self.view.endEditing(true)
        bgView.frame = CGRect(x: 0, y: 64, width: kWidth, height: kHeight - 64)
        bgView.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
        self.view.addSubview(bgView)
        bgView.addTarget(self, action: #selector(removeBgView), for: .touchUpInside)
        
        let colorBgV = UIView.init(frame: CGRect.init(x: 0, y: bgView.tz_height - 260, width: kWidth, height: 260))
        colorBgV.backgroundColor = UIColor.white
        bgView.addSubview(colorBgV)
        
        let sureBtn = UIButton()
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(.black, for: .normal)
        sureBtn.frame = CGRect(x: kWidth - 60, y: 0, width: 60, height: 60)
        sureBtn.tag = 700 + currentTag
        colorBgV.addSubview(sureBtn)
        sureBtn.addTarget(self, action: #selector(sureClick(btn:)), for: .touchUpInside)
        
        let cancelBtn = UIButton()
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(.black, for: .normal)
        cancelBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        colorBgV.addSubview(cancelBtn)
        cancelBtn.addTarget(self, action: #selector(removeBgView(sender:)), for: .touchUpInside)
        
        //创建日期选择器
        let datePicker = UIDatePicker(frame: CGRect(x:0, y: 60, width:kWidth, height:200))
        //将日期选择器区域设置为中文，则选择器日期显示为中文
        datePicker.locale = Locale(identifier: "zh_CN")
//        datePicker.locale = NSLocale.system
        datePicker.calendar = Calendar.current
        datePicker.datePickerMode = .dateAndTime
        datePicker.backgroundColor = .white
        datePicker.tag = 10086 + currentTag
        //注意：action里面的方法名后面需要加个冒号“：”
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        colorBgV.addSubview(datePicker)
    }
    
    @objc func removeBgView(sender: UIButton) {
        self.bgView.removeAllSubviews()
        self.bgView.removeFromSuperview()
        self.provinceIndex = 0
        self.cityIndex = 0
        self.areaIndex = 0
    }
    
    @objc func sureClick(btn:UIButton) {
        if self.curTravalCount > 0 {
            for i in 0..<self.curTravalCount{
                if btn.tag == 701 + 201 * i * 100 {
                    //            let layout:TGLinearLayout = self.view.viewWithTag(101) as! TGLinearLayout
                    let btn:UIButton = self.view.viewWithTag(btn.tag - 500) as! UIButton
                    btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 115))
                    if startTime.isEmpty{
                        let now = Date()
                        let dateFormat = DateFormatter()
                        dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
                        self.startDate = now
                        self.startTime = dateFormat.string(from: now)
                        btn.setTitle(startTime, for: .normal)
                    }else{
                        btn.setTitle(startTime, for: .normal)
                    }
                    self.selectStartTimeArr.replaceSubrange(Range(i..<i+1), with: [startTime])
                    btn.titleLabel?.font = kFontBoldSize15
                    
                    
                    
                    
                    
                    if !self.selectEndTimeArr[i].isEmpty {
                        if self.compareDate(startT: self.selectStartTimeArr[i], endT: self.selectEndTimeArr[i]){
                            
                            if !selectStartTimeArr[i].isEmpty && !self.selectEndTimeArr[i].isEmpty{
                                //更新提醒时间文本框
                                let formatter1 = DateFormatter()
                                //日期样式
                                formatter1.dateFormat = "yyyy-MM-dd HH:mm"
                                let bTime:Date = formatter1.date(from: self.selectStartTimeArr[i] as String)!
                                let eTime:Date = formatter1.date(from: self.selectEndTimeArr[i] as String)!
                                let second = eTime.timeIntervalSince(bTime)
                                DLog(second)
                                self.timeCount = second/3600
                                DLog(self.timeCount)
                                self.timeInter = String.init(format: "%.2f", self.timeCount!)
                                DLog(self.timeInter)
                            }
                            
                            
                            self.durationArr.replaceSubrange(Range(i..<i+1), with: [self.timeCount!/24])
                            self.travalDay = 0.00
//                            for time in self.durationArr{
//                                self.travalDay += time
//                            }
                            
                            if self.curType == "business" && !self.startTime.isEmpty && !self.endTime.isEmpty{
                                self.calculateDurationRequest(type: "businessTravel", start: startTime, end: endTime,i:i)
                                
                            }
                            
                            
                            
                            if i == 0{
                                for wrap in self.rootLayout.subviews{
                                    if 103 == wrap.tag {
                                        for lab in wrap.subviews{
                                            if 54 == lab.tag{
                                                let curLab:UILabel = lab as! UILabel
                                                if self.curType == "leave" {
                                                    if !startTime.isEmpty && !endTime.isEmpty && self.leaveId != nil{
                                                        self.getLeaveTimeRequest()
                                                        curLab.text = self.timeInter
                                                    }
                                                }else{
                                                    if self.curType == "business"{
                                                        
                                                        curLab.text = self.businessDuration + self.businessUnit
                                                    }else{
                                                        curLab.text = self.timeInter + "小时"
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }else{
                                for wrap in self.rootLayout.subviews{
                                    if 130 == wrap.tag{
                                        for subWrap in wrap.subviews{
                                            if 10000 == subWrap.tag {
                                                for DSubWrap in subWrap.subviews{
                                                    if (i-1)*100 + 5008 == DSubWrap.tag{
                                                        for lab in DSubWrap.subviews{
                                                            if 54 == lab.tag{
                                                                let curLab:UILabel = lab as! UILabel
                                                                if self.curType == "leave" {
                                                                    if !startTime.isEmpty && !endTime.isEmpty && self.leaveId != nil{
                                                                        self.getLeaveTimeRequest()
                                                                        curLab.text = self.timeInter
                                                                    }
                                                                }else{
                                                                    if self.curType == "business"{
                                                                        curLab.text = self.businessDuration + self.businessUnit
                                                                    }else{
                                                                        curLab.text = self.timeInter + "小时"
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }else{
                            SVProgressHUD.showInfo(withStatus: "结束时间必须大于开始时间")
                        }
                    }
                    
                }else if btn.tag == 702 + 201 * i * 100{
                    if self.curType == "modify"{
                        var message = ""
                        let displayBtn:UIButton = self.view.viewWithTag(btn.tag - 500) as! UIButton
                        message = self.checkModifyTimeArray[(pickView?.selectedRow(inComponent: 0))!]
                        self.endTime = message
                        displayBtn.setTitle(message, for: .normal)
                        displayBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 90))
                    }else{
                        let btn:UIButton = self.view.viewWithTag(btn.tag - 500) as! UIButton
                        btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 115))
                        if endTime.isEmpty{
                            let now = Date()
                            let dateFormat = DateFormatter()
                            dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
                            self.endTime = dateFormat.string(from: now)
                            self.endDate = now
                            btn.setTitle(endTime, for: .normal)
                        }else{
                            btn.setTitle(endTime, for: .normal)
                        }
                        self.selectEndTimeArr.replaceSubrange(Range(i..<i+1), with: [endTime])
                        btn.titleLabel?.font = kFontBoldSize15
                        
                        if !self.selectStartTimeArr[i].isEmpty {
                            if self.compareDate(startT: self.selectStartTimeArr[i], endT: self.selectEndTimeArr[i]) {
                                
                                if !selectStartTimeArr[i].isEmpty && !self.selectEndTimeArr[i].isEmpty{
                                    //更新提醒时间文本框
                                    let formatter1 = DateFormatter()
                                    //日期样式
                                    formatter1.dateFormat = "yyyy-MM-dd HH:mm"
                                    let bTime:Date = formatter1.date(from: self.selectStartTimeArr[i] as String)!
                                    let eTime:Date = formatter1.date(from: self.selectEndTimeArr[i] as String)!
                                    let second = eTime.timeIntervalSince(bTime)
                                    DLog(second)
                                    self.timeCount = second/3600
                                    DLog(self.timeCount)
                                    self.timeInter = String.init(format: "%.2f", self.timeCount!)
                                    DLog(self.timeInter)
                                }
                                
                                self.durationArr.replaceSubrange(Range(i..<i+1), with: [self.timeCount!/24])
//                                self.travalDay = 0.00
//                                for time in self.durationArr{
//                                    self.travalDay += time
//                                }
                                
                                if self.curType == "business" && !self.startTime.isEmpty && !self.endTime.isEmpty{
                                    self.calculateDurationRequest(type: "businessTravel", start: startTime, end: endTime,i: i)
                                    
                                }
                                
//                                for wrap in self.rootLayout.subviews{
//                                    if 122 == wrap.tag {
//                                        for lab in wrap.subviews{
//                                            if 54 == lab.tag{
//                                                let curLab:UILabel = lab as! UILabel
//                                                curLab.text = String.init(format: "%.f", self.travalDay) + "天"
//                                            }
//                                        }
//                                    }
//                                }
                                
                                
                                if i == 0{
                                    for wrap in self.rootLayout.subviews{
                                        if 103 == wrap.tag {
                                            for lab in wrap.subviews{
                                                if 54 == lab.tag{
                                                    let curLab:UILabel = lab as! UILabel
                                                    if self.curType == "leave" {
                                                        if !startTime.isEmpty && !endTime.isEmpty && self.leaveId != nil{
                                                            self.getLeaveTimeRequest()
                                                            curLab.text = self.timeInter
                                                        }
                                                    }else{
                                                        if self.curType == "business"{
                                                            curLab.text = self.businessDuration + self.businessUnit
                                                        }else{
                                                            curLab.text = self.timeInter + "小时"
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }else{
                                    for wrap in self.rootLayout.subviews{
                                        if 130 == wrap.tag{
                                            for subWrap in wrap.subviews{
                                                if 10000 == subWrap.tag {
                                                    for DSubWrap in subWrap.subviews{
                                                        if (i-1)*100 + 5008 == DSubWrap.tag{
                                                            for lab in DSubWrap.subviews{
                                                                if 54 == lab.tag{
                                                                    let curLab:UILabel = lab as! UILabel
                                                                    if self.curType == "leave" {
                                                                        if !startTime.isEmpty && !endTime.isEmpty && self.leaveId != nil{
                                                                            self.getLeaveTimeRequest()
                                                                            curLab.text = self.timeInter
                                                                        }
                                                                    }else{
                                                                        if self.curType == "business"{
                                                                            curLab.text = self.businessDuration + self.businessUnit
                                                                        }else{
                                                                            curLab.text = self.timeInter + "小时"
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                
                            }else{
                                SVProgressHUD.showInfo(withStatus: "结束时间必须大于开始时间")
                            }
                        }
                    }
                    
                }else if btn.tag == (700 + 201 * i * 100) || btn.tag == (703 + 201 * i * 100)  || btn.tag == (704 + 201 * i * 100)  ||  btn.tag == (705 + 201 * i * 100) || btn.tag == (706 + 201 * i * 100)  {
                    var message = ""
                    let displayBtn:UIButton = self.view.viewWithTag(btn.tag - 500) as! UIButton
                    if btn.tag == (700 + 201 * i * 100)  {
                        message = self.leaveDataArray[(pickView?.selectedRow(inComponent: 0))!]
                        displayBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 175))
                        self.leaveMessage = message
                        for i in 0..<self.leaveDataArray.count{
                            if self.leaveMessage == self.leaveDataArray[i]{
                                self.leaveId = self.leaveIdArray[i]
                            }
                        }
                        displayBtn.titleLabel?.font = kFontBoldSize15
                        if self.curType == "leave" {
                            if !startTime.isEmpty && !endTime.isEmpty && self.leaveId != nil{
                                self.getLeaveTimeRequest()
                            }
                        }
                        
                    }
                    
                    if btn.tag == (703 + 201 * i * 100)  {
                        message = self.transportArray[(pickView?.selectedRow(inComponent: 0))!]
                        self.trafic = message
                        var value = ""
                        for i in 0..<self.transportArray.count{
                            if message == self.transportArray[i]{
                                value = self.valueTransportArray[i]
                            }
                        }
                        self.selectTraficArr.replaceSubrange(Range(i..<i+1), with: [value])
                        displayBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 175))
                        
                    }
                    else if btn.tag == (704 + 201 * i * 100) {
                        message = self.checkboxArray[(pickView?.selectedRow(inComponent: 0))!]
                        if message == "单程"{
                            self.isBack = false
                        }else{
                            self.isBack = true
                        }
                        self.selectIsBackArr.replaceSubrange(Range(i..<i+1), with: [self.isBack])
                        displayBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 175))
                    }
                    else if btn.tag == (705 + 201 * i * 100) || btn.tag == (706 + 201 * i * 100) {
                        //获取选中的省
                        let p = self.addressArray[provinceIndex]
                        let province = p["state"] as! String
                        //获取选中的市
                        let c = (p["cities"] as! NSArray)[cityIndex] as! [String:AnyObject]
                        let city = c["city"] as! String
                        //获取选中的县（地区）
                        var area = ""
                        if (c["areas"] as! [String]).count > 0{
                            area = (c["areas"] as! [String])[areaIndex]
                            message = "\(province) - \(city) - \(area)"
                        }else{
                            message = "\(province) - \(city) "
                        }
                        if (705 + 201 * i * 100) == btn.tag{
                            self.fromAdd = message
                            self.selectFromCityArr.replaceSubrange(Range(i..<i+1), with: [self.fromAdd])
                        }else if (706 + 201 * i * 100) == btn.tag{
                            self.toAdd = message
                            self.selectToCityArr.replaceSubrange(Range(i..<i+1), with: [self.toAdd])
                        }
                        
                        displayBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 90))
                    }
                    
                    displayBtn.setTitle(message, for: .normal)
                }
            }
        }else{
            if btn.tag == 701  {
                //            let layout:TGLinearLayout = self.view.viewWithTag(101) as! TGLinearLayout
                let btn:UIButton = self.view.viewWithTag(201) as! UIButton
                btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 115))
                if startTime.isEmpty{
                    let now = Date()
                    let dateFormat = DateFormatter()
                    dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
                    self.startDate = now
                    self.startTime = dateFormat.string(from: now)
                    btn.setTitle(startTime, for: .normal)
                }else{
                    btn.setTitle(startTime, for: .normal)
                }
                btn.titleLabel?.font = kFontBoldSize15
                
                if self.curType == "business"{
                    self.selectStartTimeArr.replaceSubrange(Range(0..<1), with: [self.startTime])
                    if !self.selectEndTimeArr[0].isEmpty {
                        if self.compareDate(startT: self.selectStartTimeArr[0], endT: self.selectEndTimeArr[0]){
                            
                            if !selectStartTimeArr[0].isEmpty && !self.selectEndTimeArr[0].isEmpty{
                                //更新提醒时间文本框
                                let formatter1 = DateFormatter()
                                //日期样式
                                formatter1.dateFormat = "yyyy-MM-dd HH:mm"
                                let bTime:Date = formatter1.date(from: self.selectStartTimeArr[0] as String)!
                                let eTime:Date = formatter1.date(from: self.selectEndTimeArr[0] as String)!
                                let second = eTime.timeIntervalSince(bTime)
                                DLog(second)
                                self.timeCount = second/3600
                                DLog(self.timeCount)
                                self.timeInter = String.init(format: "%.2f", self.timeCount!)
                                DLog(self.timeInter)
                            }
                            
                            self.durationArr.replaceSubrange(Range(0..<1), with: [self.timeCount!/24])
//                            self.travalDay = 0.00
//                            for time in self.durationArr{
//                                self.travalDay += time
//                            }

                            if self.curType == "business" && !self.startTime.isEmpty && !self.endTime.isEmpty{
                                self.calculateDurationRequest(type: "businessTravel", start: startTime, end: endTime,i:0)
                                
                            }
                         
                            
                            for wrap in self.rootLayout.subviews{
                                if 103 == wrap.tag {
                                    for lab in wrap.subviews{
                                        if 54 == lab.tag{
                                            let curLab:UILabel = lab as! UILabel
                                            if self.curType == "leave" {
                                                if !startTime.isEmpty && !endTime.isEmpty && self.leaveId != nil{
                                                    self.getLeaveTimeRequest()
                                                    curLab.text = self.timeInter
                                                }
                                            }else{
                                                if self.curType == "business"{
                                                    curLab.text = self.businessDuration + self.businessUnit
                                                }else{
                                                    curLab.text = self.timeInter + "小时"
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }else{
                            SVProgressHUD.showInfo(withStatus: "结束时间必须大于开始时间")
                        }
                    }
                }else{
                    if !self.endTime.isEmpty {
                        if self.compareDate(startT: self.startTime, endT: self.endTime){
                            
                            if !self.startTime.isEmpty && !self.endTime.isEmpty{
                                //更新提醒时间文本框
                                let formatter1 = DateFormatter()
                                //日期样式
                                formatter1.dateFormat = "yyyy-MM-dd HH:mm"
                                let bTime:Date = formatter1.date(from: self.startTime as String)!
                                let eTime:Date = formatter1.date(from: self.endTime as String)!
                                let second = eTime.timeIntervalSince(bTime)
                                DLog(second)
                                self.timeCount = second/3600
                                DLog(self.timeCount)
                                self.timeInter = String.init(format: "%.2f", self.timeCount!)
                                DLog(self.timeInter)
                            }
                            
                            
                            for wrap in self.rootLayout.subviews{
                                if 103 == wrap.tag {
                                    for lab in wrap.subviews{
                                        if 54 == lab.tag{
                                            let curLab:UILabel = lab as! UILabel
                                            if self.curType == "leave" {
                                                if !startTime.isEmpty && !endTime.isEmpty && self.leaveId != nil{
                                                    self.getLeaveTimeRequest()
                                                    curLab.text = self.timeInter
                                                }
                                            }else{
                                                if self.curType == "business"{
                                                    curLab.text = self.businessDuration + self.businessUnit
                                                }else{
                                                    curLab.text = self.timeInter + "小时"
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }else{
                            SVProgressHUD.showInfo(withStatus: "结束时间必须大于开始时间")
                        }
                    }
                }
                
                
                
                
                
                
            }else if btn.tag == 702 {
                if self.curType == "modify"{
                    var message = ""
                    let displayBtn:UIButton = self.view.viewWithTag(btn.tag - 500) as! UIButton
                    message = self.checkModifyTimeArray[(pickView?.selectedRow(inComponent: 0))!]
                    self.endTime = message
                    displayBtn.setTitle(message, for: .normal)
                    displayBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 90))
                }else{
                    let btn:UIButton = self.view.viewWithTag(202) as! UIButton
                    btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 115))
                    if endTime.isEmpty{
                        let now = Date()
                        let dateFormat = DateFormatter()
                        dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
                        self.endTime = dateFormat.string(from: now)
                        self.endDate = now
                        btn.setTitle(endTime, for: .normal)
                    }else{
                        btn.setTitle(endTime, for: .normal)
                    }
                    
                    btn.titleLabel?.font = kFontBoldSize15
                    if self.curType == "business"{
                        self.selectEndTimeArr.replaceSubrange(Range(0..<1), with: [self.endTime])
                        if !self.selectStartTimeArr[0].isEmpty {
                            if self.compareDate(startT: self.selectStartTimeArr[0], endT: self.selectEndTimeArr[0]) {
                                
                                if !selectStartTimeArr[0].isEmpty && !self.selectEndTimeArr[0].isEmpty{
                                    //更新提醒时间文本框
                                    let formatter1 = DateFormatter()
                                    //日期样式
                                    formatter1.dateFormat = "yyyy-MM-dd HH:mm"
                                    let bTime:Date = formatter1.date(from: self.selectStartTimeArr[0] as String)!
                                    let eTime:Date = formatter1.date(from: self.selectEndTimeArr[0] as String)!
                                    let second = eTime.timeIntervalSince(bTime)
                                    DLog(second)
                                    self.timeCount = second/3600
                                    DLog(self.timeCount)
                                    self.timeInter = String.init(format: "%.2f", self.timeCount!)
                                    DLog(self.timeInter)
                                }
                                
                                self.durationArr.replaceSubrange(Range(0..<1), with: [self.timeCount!/24])
//                                self.travalDay = 0.00
//                                for time in self.durationArr{
//                                    self.travalDay += time
//                                }

                                if self.curType == "business" && !self.startTime.isEmpty && !self.endTime.isEmpty{
                                    self.calculateDurationRequest(type: "businessTravel", start: startTime, end: endTime,i:0)
                                }
                                
                                
                                
                                for wrap in self.rootLayout.subviews{
                                    if 103 == wrap.tag {
                                        for lab in wrap.subviews{
                                            if 54 == lab.tag{
                                                let curLab:UILabel = lab as! UILabel
                                                if self.curType == "leave" {
                                                    if !startTime.isEmpty && !endTime.isEmpty && self.leaveId != nil{
                                                        self.getLeaveTimeRequest()
                                                        curLab.text = self.timeInter
                                                    }
                                                }else{
                                                    if self.curType == "business"{
                                                        curLab.text = self.businessDuration + self.businessUnit
                                                    }else{
                                                        curLab.text = self.timeInter + "小时"
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                
                            }else{
                                SVProgressHUD.showInfo(withStatus: "结束时间必须大于开始时间")
                            }
                        }
                    }else{
                        if !self.startTime.isEmpty {
                            if self.compareDate(startT: self.startTime, endT: self.endTime) {
                                
                                if !startTime.isEmpty && !endTime.isEmpty{
                                    //更新提醒时间文本框
                                    let formatter1 = DateFormatter()
                                    //日期样式
                                    formatter1.dateFormat = "yyyy-MM-dd HH:mm"
                                    let bTime:Date = formatter1.date(from: self.startTime as String)!
                                    let eTime:Date = formatter1.date(from: self.endTime as String)!
                                    let second = eTime.timeIntervalSince(bTime)
                                    DLog(second)
                                    self.timeCount = second/3600
                                    DLog(self.timeCount)
                                    self.timeInter = String.init(format: "%.2f", self.timeCount!)
                                    DLog(self.timeInter)
                                }
                                
                                for wrap in self.rootLayout.subviews{
                                    if 103 == wrap.tag {
                                        for lab in wrap.subviews{
                                            if 54 == lab.tag{
                                                let curLab:UILabel = lab as! UILabel
                                                if self.curType == "leave" {
                                                    if !startTime.isEmpty && !endTime.isEmpty && self.leaveId != nil{
                                                        self.getLeaveTimeRequest()
                                                        curLab.text = self.timeInter
                                                    }
                                                }else{
                                                    if self.curType == "business"{
                                                        curLab.text = self.businessDuration + self.businessUnit
                                                    }else{
                                                        curLab.text = self.timeInter + "小时"
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                
                            }else{
                                SVProgressHUD.showInfo(withStatus: "结束时间必须大于开始时间")
                            }
                        }
                    }
                    
                }
                
            }else if btn.tag == 700  || btn.tag == 703  || btn.tag == 704  ||  btn.tag == 705 || btn.tag == 706  || btn.tag == 720{
                var message = ""
                let displayBtn:UIButton = self.view.viewWithTag(btn.tag - 500) as! UIButton
                if btn.tag == 700  {
                    message = self.leaveDataArray[(pickView?.selectedRow(inComponent: 0))!]
                    displayBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 175))
                    self.leaveMessage = message
                    for i in 0..<self.leaveDataArray.count{
                        if self.leaveMessage == self.leaveDataArray[i]{
                            self.leaveId = self.leaveIdArray[i]
                        }
                    }
                    displayBtn.titleLabel?.font = kFontBoldSize15
                    if self.curType == "leave" {
                        if !startTime.isEmpty && !endTime.isEmpty && self.leaveId != nil{
                            self.getLeaveTimeRequest()
                        }
                    }
                    
                }
                
                if btn.tag == 703  {
                    message = self.transportArray[(pickView?.selectedRow(inComponent: 0))!]
                    self.trafic = message
                    var value = ""
                    for i in 0..<self.transportArray.count{
                        if message == self.transportArray[i]{
                            value = self.valueTransportArray[i]
                        }
                    }
                    self.selectTraficArr.replaceSubrange(Range(0..<1), with: [value])
                    displayBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 175))
                    
                }
                else if btn.tag == 704 {
                    message = self.checkboxArray[(pickView?.selectedRow(inComponent: 0))!]
                    if message == "单程"{
                        self.isBack = false
                    }else{
                        self.isBack = true
                    }
                    self.selectIsBackArr.replaceSubrange(Range(0..<1), with: [self.isBack])
                    displayBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 175))
                }else if btn.tag == 720 {
                    message = self.moneyRangeArray[(pickView?.selectedRow(inComponent: 0))!]
                    for i in 0..<self.moneyRangeArray.count {
                        if message == self.moneyRangeArray[i]{
                            self.selectMoneyValue = self.moneyRangeValueArray[i]
                        }
                    }
                    displayBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 175))
                }
                else if btn.tag == 705 || btn.tag == 706 {
                    //获取选中的省
                    let p = self.addressArray[provinceIndex]
                    let province = p["state"] as! String
                    //获取选中的市
                    let c = (p["cities"] as! NSArray)[cityIndex] as! [String:AnyObject]
                    let city = c["city"] as! String
                    //获取选中的县（地区）
                    var area = ""
                    if (c["areas"] as! [String]).count > 0{
                        area = (c["areas"] as! [String])[areaIndex]
                        message = "\(province) - \(city) - \(area)"
                    }else{
                        message = "\(province) - \(city) "
                    }
                    if 705 == btn.tag{
                        self.fromAdd = message
                        self.selectFromCityArr.replaceSubrange(Range(0..<1), with: [self.fromAdd])
                    }else if 706 == btn.tag{
                        self.toAdd = message
                        self.selectToCityArr.replaceSubrange(Range(0..<1), with: [self.toAdd])
                    }
                    
                    displayBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 90))
                }
                
                displayBtn.setTitle(message, for: .normal)
            }
        }
        
        if self.curType == "leave"{
            if !self.startTime.isEmpty && !self.endTime.isEmpty && !self.leaveMessage.isEmpty{
                self.isChangeApproveler = true
                self.getLeaveTimeRequest()
                self.getApprovalPersonsRequest()
            }
        }else if self.curType == "overtime"{
            if !self.startTime.isEmpty && !self.endTime.isEmpty {
                self.isChangeApproveler = true
                self.calculateDurationRequest(type: "extra", start: self.startTime, end:self.endTime , i: 0)
                self.getApprovalPersonsRequest()
            }
        }else if self.curType == "outWork"{
            if !self.startTime.isEmpty && !self.endTime.isEmpty {
                self.isChangeApproveler = true
                self.calculateDurationRequest(type: "outWork", start: self.startTime, end:self.endTime , i: 0)
                self.getApprovalPersonsRequest()
            }
        }
        
        self.bgView.removeAllSubviews()
        self.bgView.removeFromSuperview()
        self.provinceIndex = 0
        self.cityIndex = 0
        self.areaIndex = 0
    }
    
    //日期选择器响应方法
    @objc func dateChanged(datePicker : UIDatePicker){
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        if self.curTravalCount > 0{
            for i in 0..<self.curTravalCount{
                if datePicker.tag == 10087 + (201 * i * 100){
                    startTime = formatter.string(from: datePicker.date)
                    
                    startDate = datePicker.date
                    
                }else if datePicker.tag == 10088 + (201 * i * 100){
                    endTime = formatter.string(from: datePicker.date)
                    endDate = datePicker.date
                }
            }
        }else{
            if datePicker.tag == 10087 {
                startTime = formatter.string(from: datePicker.date)
                startDate = datePicker.date
                
            }else{
                endTime = formatter.string(from: datePicker.date)
                endDate = datePicker.date
                
            }
        }
        
        
        
        if self.curType == "leave" {
            if !startTime.isEmpty && !endTime.isEmpty && self.leaveId != nil{
                self.getLeaveTimeRequest()
            }
        }
    }
    
    func compareDate(startT:String,endT:String) -> Bool {
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let BDate:Date?
        let EDate:Date?
        BDate = formatter.date(from: startT)
        EDate = formatter.date(from: endT)
        let result:ComparisonResult = (BDate?.compare(EDate ?? Date()))!
        if result == .orderedDescending || result == .orderedSame {
            return false
        }
        return true
    }
}

//  MARK:地址选择器
extension CQSupplyVC {
    func initAddressPickView(tag:Int)  {
        //初始化数据
        let path = Bundle.main.path(forResource: "address", ofType:"plist")
        self.addressArray = NSArray(contentsOfFile: path!) as! Array
        
        self.initPickView(tag: tag)
    }
}

//  Mark:UIPickView构造    点击事件与datepicker共用
extension CQSupplyVC{
    func initPickView(tag:Int)  {
        let tag = tag - 200
        self.view.endEditing(true)
        bgView.frame = CGRect(x: 0, y: 64, width: kWidth, height: kHeight - 64)
        bgView.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
        self.view.addSubview(bgView)
        bgView.addTarget(self, action: #selector(removeBgView), for: .touchUpInside)
        
        let colorBgV = UIView.init(frame: CGRect.init(x: 0, y: bgView.tz_height - 260, width: kWidth, height: 260))
        colorBgV.backgroundColor = UIColor.white
        bgView.addSubview(colorBgV)
        
        let sureBtn = UIButton()
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(.black, for: .normal)
        sureBtn.frame = CGRect(x: kWidth - 60, y: 10, width: 60, height: 50)
        sureBtn.tag = 700 + tag
        colorBgV.addSubview(sureBtn)
        sureBtn.addTarget(self, action: #selector(sureClick(btn:)), for: .touchUpInside)
        
        let cancelBtn = UIButton()
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(.black, for: .normal)
        cancelBtn.frame = CGRect(x: 0, y: 10, width: 60, height: 50)
        colorBgV.addSubview(cancelBtn)
        cancelBtn.addTarget(self, action: #selector(removeBgView(sender:)), for: .touchUpInside)
        
        self.pickView = UIPickerView.init(frame: CGRect.init(x: 0, y: 60, width: kWidth, height: 200))
        pickView?.delegate = self
        pickView?.dataSource = self
        pickView?.tag = 500 + tag
        pickView?.selectedRow(inComponent: 0)
        
        colorBgV.addSubview(pickView!)
    }
}

//  MARK:pickViewDelegate
extension CQSupplyVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if self.curTravalCount > 0{
            for i in 0..<self.curTravalCount{
                if 201 * i * 100 + 505 == self.pickView?.tag || 201 * i * 100 + 506 == self.pickView?.tag{
                    return 3
                }
            }
        }else{
            if 505  == self.pickView?.tag || 506  == self.pickView?.tag {
                return 3
            }
        }
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.curTravalCount > 0{
            for i in 0..<self.curTravalCount {
                if 503 + 201 * i * 100 == self.pickView?.tag {
                    return self.transportArray.count
                }else if 500 + 201 * i * 100  == self.pickView?.tag {
                    return self.leaveDataArray.count
                }else if 502 + 201 * i * 100  == self.pickView?.tag {
                    return self.checkModifyTimeArray.count
                }else if 505 + 201 * i * 100 == self.pickView?.tag || 506 + 201 * i * 100 == self.pickView?.tag{
                    if component == 0 {
                        return self.addressArray.count
                    } else if component == 1 {
                        let province = self.addressArray[provinceIndex]
                        return province["cities"]!.count
                    } else {
                        let province = self.addressArray[provinceIndex]
                        if let city = (province["cities"] as! NSArray)[cityIndex]
                            as? [String: AnyObject] {
                            return city["areas"]!.count
                        } else {
                            return 0
                        }
                    }
                }
            }
        }else{
            if 503  == self.pickView?.tag {
                return self.transportArray.count
            }else if 500  == self.pickView?.tag {
                return self.leaveDataArray.count
            }else if 502  == self.pickView?.tag {
                return self.checkModifyTimeArray.count
            }else if 520  == self.pickView?.tag {
                return self.moneyRangeArray.count
            }else if 505  == self.pickView?.tag || 506 == self.pickView?.tag{
                if component == 0 {
                    return self.addressArray.count
                } else if component == 1 {
                    let province = self.addressArray[provinceIndex]
                    return province["cities"]!.count
                } else {
                    let province = self.addressArray[provinceIndex]
                    if let city = (province["cities"] as! NSArray)[cityIndex]
                        as? [String: AnyObject] {
                        return city["areas"]!.count
                    } else {
                        return 0
                    }
                }
            }
        }
        
        return self.checkboxArray.count //504
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.curTravalCount > 0{
            for i in 0..<self.curTravalCount{
                if 503 + 201 * i * 100 == self.pickView?.tag {
                    return self.transportArray[row]
                }else if 500 + 201 * i * 100 == self.pickView?.tag {
                    return self.leaveDataArray[row]
                }else if 502 + 201 * i * 100 == self.pickView?.tag{
                    return self.checkModifyTimeArray[row]
                } else if 505 + 201 * i * 100 == self.pickView?.tag || 506 + 201 * i * 100 == self.pickView?.tag{
                    if component == 0 {
                        return self.addressArray[row]["state"] as? String
                    }else if component == 1 {
                        let province = self.addressArray[provinceIndex]
                        let city = (province["cities"] as! NSArray)[row]
                            as! [String: AnyObject]
                        return city["city"] as? String
                    }else {
                        let province = self.addressArray[provinceIndex]
                        let city = (province["cities"] as! NSArray)[cityIndex]
                            as! [String: AnyObject]
                        return (city["areas"] as! NSArray)[row] as? String
                    }
                }
            }
        }else{
            if 503  == self.pickView?.tag {
                return self.transportArray[row]
            }else if 500 == self.pickView?.tag {
                return self.leaveDataArray[row]
            }else if 502 == self.pickView?.tag{
                return self.checkModifyTimeArray[row]
            } else if 520 == self.pickView?.tag{
                return self.moneyRangeArray[row]
            } else if 505 == self.pickView?.tag || 506 == self.pickView?.tag{
                if component == 0 {
                    return self.addressArray[row]["state"] as? String
                }else if component == 1 {
                    let province = self.addressArray[provinceIndex]
                    let city = (province["cities"] as! NSArray)[row]
                        as! [String: AnyObject]
                    return city["city"] as? String
                }else {
                    let province = self.addressArray[provinceIndex]
                    let city = (province["cities"] as! NSArray)[cityIndex]
                        as! [String: AnyObject]
                    return (city["areas"] as! NSArray)[row] as? String
                }
            }
        }
        
        return self.checkboxArray[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.curTravalCount > 0{
            for i in 0..<self.curTravalCount{
                if 505 + 201 * i * 100  == self.pickView?.tag || 506 + 201 * i * 100 == self.pickView?.tag {
                    //根据列、行索引判断需要改变数据的区域
                    switch (component) {
                    case 0:
                        provinceIndex = row;
                        cityIndex = 0;
                        areaIndex = 0;
                        pickerView.reloadComponent(1);
                        pickerView.reloadComponent(2);
                        pickerView.selectRow(0, inComponent: 1, animated: false)
                        pickerView.selectRow(0, inComponent: 2, animated: false)
                    case 1:
                        cityIndex = row;
                        areaIndex = 0;
                        pickerView.reloadComponent(2);
                        pickerView.selectRow(0, inComponent: 2, animated: false)
                    case 2:
                        areaIndex = row;
                    default:
                        break;
                    }
                }
            }
        }else{
            if 505  == self.pickView?.tag || 506 == self.pickView?.tag {
                //根据列、行索引判断需要改变数据的区域
                switch (component) {
                case 0:
                    provinceIndex = row;
                    cityIndex = 0;
                    areaIndex = 0;
                    pickerView.reloadComponent(1);
                    pickerView.reloadComponent(2);
                    pickerView.selectRow(0, inComponent: 1, animated: false)
                    pickerView.selectRow(0, inComponent: 2, animated: false)
                case 1:
                    cityIndex = row;
                    areaIndex = 0;
                    pickerView.reloadComponent(2);
                    pickerView.selectRow(0, inComponent: 2, animated: false)
                case 2:
                    areaIndex = row;
                default:
                    break;
                }
            }
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if self.curTravalCount > 0{
            for i in 0..<self.curTravalCount{
                if 505 + 201 * i * 100  == self.pickView?.tag || 506 + 201 * i * 100  == self.pickView?.tag{
                    return kWidth/3
                }
            }
        }else{
            if 505 == self.pickView?.tag || 506 == self.pickView?.tag{
                return kWidth/3
            }
        }
        
        return kWidth
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return AutoGetHeight(height: 40)
    }
    
}

//  MARK:UICollectionViewDelegate
extension CQSupplyVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 800 {
            return self.supplyArray.count
        }else if collectionView.tag == 801{
            return self.copyArray.count + 1
        }else if collectionView.tag == 803 {
            if overTimeModel != nil {
                return 1
            }else{
                return 0
            }
        }//802
        return self.toghterArray.count + 1
    }
    
}

extension CQSupplyVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQWriteReportCellId", for: indexPath) as! CQWriteReportCell
        if collectionView.tag == 800 {
            cell.img.sd_setImage(with: URL(string: self.supplyArray[indexPath.item].headImage), placeholderImage:UIImage.init(named: "personDefaultIcon") )
            cell.deleteBtn.isHidden = true
            cell.nameLab.text = self.supplyArray[indexPath.item].realName
        }else if collectionView.tag == 801{
            if self.copyArray.count == 0 {
                if indexPath.item == 0{
                    cell.img.image = UIImage.init(named: "CQAddMenberIcon")
                    cell.nameLab.text = ""
                    cell.deleteBtn.isHidden = true
                }
            }else {
                if indexPath.item == self.copyArray.count {
                    cell.img.image = UIImage.init(named: "CQAddMenberIcon")
                    cell.deleteBtn.isHidden = true
                    cell.nameLab.text = ""
                }else {
                    cell.img.sd_setImage(with: URL(string: self.copyArray[indexPath.item].headImage), placeholderImage:UIImage.init(named: "personDefaultIcon") )
                    cell.deleteBtn.isHidden = false
                    cell.deleteDelegate = self
                    cell.nameLab.text = self.copyArray[indexPath.item].realName
                }
            }
        }else if collectionView.tag == 802{
            if self.toghterArray.count == 0 {
                if indexPath.item == 0{
                    cell.img.image = UIImage.init(named: "CQAddMenberIcon")
                    cell.nameLab.text = ""
                    cell.deleteBtn.isHidden = true
                }
            }else {
                if indexPath.item == self.toghterArray.count {
                    cell.img.image = UIImage.init(named: "CQAddMenberIcon")
                    cell.nameLab.text = ""
                    cell.deleteBtn.isHidden = true
                }else {
                    cell.img.sd_setImage(with: URL(string: self.toghterArray[indexPath.item].headImage), placeholderImage:UIImage.init(named: "personDefaultIcon") )
                    cell.togetherDelegate = self
                    cell.deleteBtn.isHidden = false
                    cell.nameLab.text = self.toghterArray[indexPath.item].realName
                }
            }
        }else if collectionView.tag == 803{
            if self.overTimeModel != nil {
                cell.img.sd_setImage(with: URL(string: (self.overTimeModel?.headImage)!), placeholderImage:UIImage.init(named: "personDefaultIcon") )
                if self.isReplace!{
                    cell.overDelegate = self
                    cell.deleteBtn.isHidden = false
                }else{
                    
                }
                cell.nameLab.text = self.overTimeModel?.realName
            }
            
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 800 {
            
        }else if collectionView.tag == 801{
            if self.copyArray.count == 0 {
                if indexPath.item == 0 {
                        let vc = AddressBookVC.init()
                        vc.toType = .fromSupply
                        vc.hasSelectModelArr = self.copyArray
                        self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                if indexPath.item == self.copyArray.count{
                    let vc = AddressBookVC.init()
                    vc.toType = .fromSupply
                    vc.hasSelectModelArr = self.copyArray
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    
                }
            }
        }else if collectionView.tag == 802{
            if self.toghterArray.count == 0 {
                if indexPath.item == 0 {
                    let vc = AddressBookVC.init()
                    vc.hasSelectModelArr = self.toghterArray
                    vc.toType = .fromTogetherPerson
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                if indexPath.item == self.toghterArray.count{
                    let vc = AddressBookVC.init()
                    vc.hasSelectModelArr = self.toghterArray
                    vc.toType = .fromTogetherPerson
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    
                }
            }
        }else if collectionView.tag == 803{
            
        }
    }
    
}



//  MARK:textViewDelegate
extension CQSupplyVC:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
}

//   MARK:判断一个数是否能整除另一个数
extension CQSupplyVC{
    func judgeInt(count:Int) -> Bool {
        if count % 4 != 0 {
            return false
        }
        return true
    }
}

extension CQSupplyVC:CQSelectDeleteDelegate{
    func deleteCollectionCell(index: IndexPath) {
       
        let collectionView = self.rootLayout.viewWithTag(801) as! UICollectionView
        collectionView.reloadData()
        self.copyArray.remove(at: index.item)
        self.userIdArr.remove(at: index.item)
        
    }
    
}

extension CQSupplyVC:CQOverSelectDeleteDelegate{
    func deleteOverCollectionCell(index: IndexPath) {
        let collectionView = self.rootLayout.viewWithTag(803) as! UICollectionView
        collectionView.reloadData()
        self.overTimeModel = nil
    }
}

extension CQSupplyVC:CQTogetherDeleteDelegate{
    func deleteTogetherPerson(index: IndexPath) {
        let collectionView = self.rootLayout.viewWithTag(802) as! UICollectionView
        collectionView.reloadData()
        self.toghterArray.remove(at: index.item)
    }
}

//   MARK:判断一个数是否能整除另一个数
extension CQSupplyVC{
    func judgeTheTag(count:Int) -> Bool {
        if count % 201 != 0 {
            return false
        }
        return true
    }
}

extension CQSupplyVC:UITextFieldDelegate,KeyBoardDelegate{
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

extension CQSupplyVC:CQDepartMentSelectDelegate{
    func selectCell(model: CQAddressBookModel) {
        self.selectPartmentStr = model.departmentName
        if !self.newDeparment{
            for wrap in self.rootLayout.subviews{
                if 135 == wrap.tag{
                    for vrap in wrap.subviews{
                        if vrap.tag == 101{
                            self.newDeparment = true
                            vrap.addSubview(self.addDepartMentContentLayout(tag: 140, title: model.departmentName, btnTag: 221))
                        }
                    }
                    
                }
            }
        }else{
            for wrap in self.rootLayout.subviews{
                if 135 == wrap.tag{
                    for vrap in wrap.subviews{
                        if vrap.tag == 101{
                            for c in vrap.subviews{
                                if 140 == c.tag{
                                    for co in c.subviews{
                                        if 221 == co.tag{
                                            let collect:UIButton = co as! UIButton
                                            collect.removeFromSuperview()
                                            vrap.addSubview(self.addDepartMentContentLayout(tag: 140, title: model.departmentName, btnTag: 221))
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


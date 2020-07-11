//
//  CQMeetingRommBookVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/7/1.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQMeetingRommBookVC: SuperVC {

    var userArray = [CQDepartMentUserListModel]()
    //datepicker一系列控件及参数
    var bgView = UIButton()
    var startTime = "" //开始时间
    var endTime = ""  //结束时间
    var roomModel:CQChooseRoomModel?
    var roomName = ""
    //提交表单
    var formStr = ""
    var isFromMyApplyVC = false
    var resultFormDict:NSDictionary?
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight-SafeAreaBottomHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight))
        headView.backgroundColor = kProjectBgColor
        return headView
    }()
    
    lazy var titleView: UIView = {
        let titleView = UIView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 275)))
        titleView.backgroundColor = UIColor.white
        return titleView
    }()
    
    lazy var titleLab: UILabel = {
        let titleLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: AutoGetWidth(width: 55), height: AutoGetHeight(height: 55)))
        titleLab.textColor = UIColor.black
        titleLab.text = "主题"
        titleLab.textAlignment = .left
        titleLab.font = kFontSize15
        return titleLab
    }()
    
    lazy var meetingTitleTextView: CBTextView = {
        
        let meetingTitleTextView = CBTextView.init(frame:CGRect.init(x: self.titleLab.right, y: AutoGetHeight(height: 10) , width: kWidth - kLeftDis - AutoGetWidth(width: 80), height: AutoGetHeight(height: 45)))
        meetingTitleTextView.aDelegate = self
        meetingTitleTextView.textView.backgroundColor = UIColor.white
        meetingTitleTextView.textView.font = UIFont.systemFont(ofSize: 15)
        meetingTitleTextView.textView.textColor = UIColor.black
        
        meetingTitleTextView.placeHolder = "请填写用会议室事由"
        meetingTitleTextView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        return meetingTitleTextView
    }()
    
    lazy var contentLab: UILabel = {
        let contentLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.titleLab.bottom, width: AutoGetWidth(width: 55), height: AutoGetHeight(height: 55)))
        contentLab.textColor = UIColor.black
        contentLab.text = "概要"
        contentLab.textAlignment = .left
        contentLab.font = kFontSize15
        return contentLab
    }()
    
    lazy var contentTextView: CBTextView = {
        
        let contentTextView = CBTextView.init(frame:CGRect.init(x: self.titleLab.right, y: self.meetingTitleTextView.bottom + AutoGetHeight(height: 10), width: kWidth - kLeftDis - AutoGetWidth(width: 80), height: AutoGetHeight(height: 45)))
        contentTextView.aDelegate = self
        contentTextView.textView.backgroundColor = UIColor.white
        contentTextView.textView.font = UIFont.systemFont(ofSize: 15)
        contentTextView.textView.textColor = UIColor.black
        
        contentTextView.placeHolder = "请填写会议概要"
        contentTextView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        return contentTextView
    }()
    
    
    lazy var xingStartLab: UILabel = {
        let xingStartLab = UILabel.init(frame: CGRect.init(x: 0, y: self.contentLab.bottom, width: AutoGetWidth(width: 30), height: AutoGetHeight(height: 55)))
        xingStartLab.textColor = UIColor.red
        xingStartLab.text = "*"
        xingStartLab.textAlignment = .center
        xingStartLab.font = kFontSize15
        return xingStartLab
    }()
    
    lazy var startLab: UILabel = {
        let startLab = UILabel.init(frame: CGRect.init(x: self.xingStartLab.right, y: self.contentLab.bottom, width: AutoGetWidth(width: 80), height: AutoGetHeight(height: 55)))
        startLab.textColor = UIColor.black
        startLab.text = "开始时间"
        startLab.textAlignment = .left
        startLab.font = kFontSize15
        return startLab
    }()
    
    lazy var startBtn: UIButton = {
        let startBtn = UIButton.init(type: .custom)
        startBtn.frame = CGRect.init(x: AutoGetWidth(width: 110), y: self.contentLab.bottom, width: kWidth - AutoGetWidth(width: 125), height: AutoGetHeight(height: 55))
        startBtn.setTitle("请选择开始时间", for: .normal)
        startBtn.setTitleColor(kLyGrayColor, for: .normal)
        startBtn.addTarget(self, action: #selector(startClick(btn:)), for: .touchUpInside)
        startBtn.tag = 200
        startBtn.titleLabel?.font = kFontSize15
        startBtn.titleEdgeInsets = UIEdgeInsetsMake(0, AutoGetWidth(width: 100), 0, 0)
        
        let arrowImg = UIImageView.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 131.5), y: AutoGetHeight(height: 21.5), width: AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 12)))
        arrowImg.image = UIImage.init(named: "PersonAddressArrow")
        startBtn.addSubview(arrowImg)
        return startBtn
    }()
    
    lazy var xingEndLab: UILabel = {
        let xingEndLab = UILabel.init(frame: CGRect.init(x: 0, y: self.xingStartLab.bottom, width: AutoGetWidth(width: 30), height: AutoGetHeight(height: 55)))
        xingEndLab.textColor = UIColor.red
        xingEndLab.text = "*"
        xingEndLab.textAlignment = .center
        xingEndLab.font = kFontSize15
        return xingEndLab
    }()
    
    lazy var endLab: UILabel = {
        let endLab = UILabel.init(frame: CGRect.init(x: self.xingEndLab.right, y: self.startLab.bottom, width: AutoGetWidth(width: 80), height: AutoGetHeight(height: 55)))
        endLab.textColor = UIColor.black
        endLab.text = "结束时间"
        endLab.textAlignment = .left
        endLab.font = kFontSize15
        return endLab
    }()
    
    lazy var endBtn: UIButton = {
        let endBtn = UIButton.init(type: .custom)
        endBtn.frame = CGRect.init(x: AutoGetWidth(width: 110), y: self.startLab.bottom, width: kWidth - AutoGetWidth(width: 125), height: AutoGetHeight(height: 55))
        endBtn.setTitle("请选择结束时间", for: .normal)
        endBtn.setTitleColor(kLyGrayColor, for: .normal)
        endBtn.titleLabel?.font = kFontSize15
        endBtn.addTarget(self, action: #selector(endClick(btn:)), for: .touchUpInside)
        endBtn.tag = 201
        endBtn.titleEdgeInsets = UIEdgeInsetsMake(0, AutoGetWidth(width: 100), 0, 0)
        
        let arrowImg = UIImageView.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 131.5), y: AutoGetHeight(height: 21.5), width: AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 12)))
        arrowImg.image = UIImage.init(named: "PersonAddressArrow")
        endBtn.addSubview(arrowImg)
        return endBtn
    }()
    
    lazy var meetingLab: UILabel = {
        let meetingLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.endBtn.bottom, width: AutoGetWidth(width: 80), height: AutoGetHeight(height: 55)))
        meetingLab.textColor = UIColor.black
        meetingLab.text = "会议室"
        meetingLab.textAlignment = .left
        meetingLab.font = kFontSize15
        return meetingLab
    }()
    
    lazy var meetingBtn: UIButton = {
        let meetingBtn = UIButton.init(type: .custom)
        meetingBtn.frame = CGRect.init(x: AutoGetWidth(width: 95), y: self.endLab.bottom, width: kWidth - AutoGetWidth(width: 110), height: AutoGetHeight(height: 55))
        meetingBtn.setTitle("请选择", for: .normal)
        meetingBtn.setTitleColor(kLyGrayColor, for: .normal)
        meetingBtn.addTarget(self, action: #selector(chooseMeetingRoomClick), for: .touchUpInside)
        meetingBtn.titleLabel?.font = kFontSize15
        meetingBtn.titleEdgeInsets = UIEdgeInsetsMake(0, AutoGetWidth(width: 180), 0, 0)
        
        let arrowImg = UIImageView.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 116.5), y: AutoGetHeight(height: 21.5), width: AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 12)))
        arrowImg.image = UIImage.init(named: "PersonAddressArrow")
        meetingBtn.addSubview(arrowImg)
        return meetingBtn
    }()
    
    lazy var attendPersonView: UIView = {
        let attendPersonView = UIView.init(frame: CGRect.init(x: 0, y:self.titleView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 145)))
        attendPersonView.backgroundColor = UIColor.white
        return attendPersonView
    }()
    
    lazy var attendPersonLab: UILabel = {
        let attendPersonLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 18), width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 15)))
        attendPersonLab.textColor = UIColor.black
        attendPersonLab.text = "审批人"
        attendPersonLab.textAlignment = .left
        attendPersonLab.font = kFontSize15
        return attendPersonLab
    }()
    
    
    lazy var collectionView: UICollectionView = {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width: kHaveLeftWidth/4, height: AutoGetHeight(height: 75))
        layOut.minimumLineSpacing = 0
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        //        layOut.headerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 38))
        //        layOut.footerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 11))
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: kLeftDis, y: self.attendPersonLab.bottom + AutoGetHeight(height: 14), width: kHaveLeftWidth, height: AutoGetHeight(height: 84)), collectionViewLayout: layOut)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(CQWriteReportCell.self, forCellWithReuseIdentifier: "CQWriteReportCellId")
        return collectionView
    }()
    
    lazy var footView: UIView = {
        let footView = UIView.init(frame: CGRect.init(x: 0, y: kHeight - AutoGetHeight(height: 64), width: kWidth, height:  AutoGetHeight(height: 64)))
        footView.backgroundColor = UIColor.white
        return footView
    }()
    
    lazy var submitBtn: UIButton = {
        let submitBtn = UIButton.init(type: .custom)
        submitBtn.frame = CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 8), width: kHaveLeftWidth, height: AutoGetHeight(height: 48))
        submitBtn.backgroundColor = kBlueColor
        submitBtn.setTitle("提 交", for: .normal)
        submitBtn.titleLabel?.font = kFontSize17
        submitBtn.setTitleColor(UIColor.white, for: .normal)
        submitBtn.layer.cornerRadius = 3
        submitBtn.addTarget(self, action: #selector(submitClick), for: .touchUpInside)
        return submitBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getApprovalPersonsRequest()
        self.title = "会议室预定"
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.titleView)
        self.titleView.addSubview(self.titleLab)
        self.titleView.addSubview(self.meetingTitleTextView)
        self.titleView.addSubview(self.contentLab)
        self.titleView.addSubview(self.contentTextView)
        self.titleView.addSubview(self.xingStartLab)
        self.titleView.addSubview(self.startLab)
        self.titleView.addSubview(self.startBtn)
        self.titleView.addSubview(self.xingEndLab)
        self.titleView.addSubview(self.endLab)
        self.titleView.addSubview(self.endBtn)
        self.titleView.addSubview(self.meetingLab)
        self.titleView.addSubview(self.meetingBtn)
        self.headView.addSubview(self.attendPersonView)
        self.attendPersonView.addSubview(self.attendPersonLab)
        self.attendPersonView.addSubview(self.collectionView)
//        self.view.addSubview(self.footView)
//        self.footView.addSubview(self.submitBtn)
        
        if self.isFromMyApplyVC {
            self.meetingTitleTextView.prevText = self.resultFormDict!["meetingTitle"] as? String
            self.contentTextView.prevText = self.resultFormDict!["outLine"] as? String
            self.startTime = (self.resultFormDict!["startDate"] as? String)!
            self.startBtn.setTitle(self.startTime, for: .normal)
            self.endTime = (self.resultFormDict!["endDate"] as? String)!
            self.endBtn.setTitle(self.endTime, for: .normal)
            let arr = resultFormDict!["meetingRoom"] as! NSDictionary
            self.roomName = arr["name"] as! String
            self.roomModel = CQChooseRoomModel.init(name: arr["name"] as! String, meetingRoomId: arr["entityId"] as! String)
            self.meetingBtn.setTitle(self.roomName, for: .normal)
            meetingBtn.titleEdgeInsets = UIEdgeInsetsMake(0, AutoGetWidth(width: 160), 0, 0)
        }
        
        for i in 1..<5 {
            let lineView = UIView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 55) * CGFloat(i), width: kWidth, height: 0.5))
            lineView.backgroundColor = kLineColor
            self.titleView.addSubview(lineView)
        }
        
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 44))
        rightBtn.setTitle("提交", for: .normal)
        rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5)
        rightBtn.sizeToFit()
        rightBtn.setTitleColor(UIColor.colorWithHexString(hex: "#20afff"), for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        rightBtn.addTarget(self, action: #selector(submitClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func startClick(btn:UIButton)  {
        self.initDatePickView(tag:btn.tag)
    }
    
    @objc func endClick(btn:UIButton)  {
        self.initDatePickView(tag:btn.tag)
    }

    @objc func chooseMeetingRoomClick()  {
        let vc = CQChooseRoomVC()
        if self.startTime.isEmpty {
            SVProgressHUD.showInfo(withStatus: "请选择开始时间")
            return
        }else if self.endTime.isEmpty {
            SVProgressHUD.showInfo(withStatus: "请选择结束时间")
            return
        }
        vc.startDate = startTime
        vc.endDate = endTime
        vc.selectDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func submitClick()  {
        var planContent = self.contentTextView.textView.text
        if planContent == self.contentTextView.placeHolder {
            planContent = ""
        }
        
        var titleContent = self.meetingTitleTextView.textView.text
        if titleContent == self.meetingTitleTextView.placeHolder{
            titleContent = ""
        }
        let dic = ["businessApplyDatas":[["meetingTitle":self.meetingTitleTextView.textView.text ?? "",
                                          "outLine":self.contentTextView.textView.text ?? "",
                                          "startDate":self.startTime,
                                          "endDate":self.endTime,
                                          "meetingRoom":["entityId":roomModel?.meetingRoomId ?? "",
                                                         "name":roomModel?.roomName ?? ""]]]]
        
        if self.endTime.count > 0 && self.startTime.count > 0 && (titleContent?.count)! > 0 && (planContent?.count)! > 0 && self.roomName.count > 0{
            self.formStr = getJSONStringFromDictionary(dictionary: dic as NSDictionary)
            self.loadingPlay()
            self.applySubmitRequest(data: self.formStr)
        }else{
            if (titleContent?.isEmpty)!{
                SVProgressHUD.showInfo(withStatus: "请填写用会议室事由")
            }else if (planContent?.isEmpty)!{
                SVProgressHUD.showInfo(withStatus: "请填写会议概要")
            }else if self.startTime.isEmpty{
                SVProgressHUD.showInfo(withStatus: "请选择开始时间")
            }else if self.endTime.isEmpty{
                SVProgressHUD.showInfo(withStatus: "请选择结束时间")
            }else if self.roomName.isEmpty{
                SVProgressHUD.showInfo(withStatus: "请选择会议室")
            }
        }
        
    }
    
  
}

extension CQMeetingRommBookVC{
    //提交
    func applySubmitRequest(data:String) {
        let userId = STUserTool.account().userID
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/applySubmit" ,
            type: .post,
            param: ["approvalBusinessId":"",
                    "businessApplyId":"",
                    "businessCode":"B_HYS",
                    "copyPersonIds":"",
                    "emyeId":userId,
                    "formData":data],
            successCallBack: { (result) in
                self.loadingSuccess()
                SVProgressHUD.showSuccess(withStatus: "发布成功")
                if self.isFromMyApplyVC{
                    for v in (self.navigationController?.viewControllers)!{
                        if v is CQMeSubmitVC{
                            NotificationCenter.default.post(name: NSNotification.Name.init("refreshMeApplyUI"), object: nil)
                            self.navigationController?.popToViewController(v, animated: true)
                        }
                    }
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
        }) { (error) in
            self.loadingSuccess()
        }
    }
    
    //获得审批人
    func getApprovalPersonsRequest() {
        let userId = STUserTool.account().userID
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getApplyApprovalPersons" ,
            type: .post,
            param: ["approvalBusinessId":"",
                    "businessCode":"B_HYS",
                    "emyeId":userId,
                    "vacationTypeId":""],
            successCallBack: { (result) in
                
                var arr = [CQDepartMentUserListModel]()
                
                self.userArray.removeAll()
                
                for modalJson in result["data"]["approvalFlowPersonUnitJsonList"].arrayValue  {
                    guard let modal = CQDepartMentUserListModel(jsonData: JSON(modalJson)) else {
                        return
                    }
                    DLog(modal)
                    arr.append(modal)
                }
                
                self.userArray = arr
                
                self.collectionView.reloadData()
                
        }) { (error) in
            
        }
    }
}

// MARK:datapicker构造及点击事件
extension CQMeetingRommBookVC{
    func initDatePickView(tag:Int)  {
        let currentTag = tag - 200
        self.view.endEditing(true)
       // bgView.frame = CGRect(x: 0, y: 64, width: kWidth, height: kHeight - 64)
        bgView.frame = CGRect(x: 0, y: SafeAreaTopHeight, width: kWidth, height: kHeight - SafeAreaTopHeight - SafeAreaBottomHeight)
        bgView.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
        self.view.addSubview(bgView)
        bgView.addTarget(self, action: #selector(removeBgView), for: .touchUpInside)
        
        let colorBgV = UIView.init(frame: CGRect.init(x: 0, y: bgView.tz_height - 240, width: kWidth, height: 240))
        colorBgV.backgroundColor = UIColor.white
        bgView.addSubview(colorBgV)
        
        let sureBtn = UIButton()
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(.black, for: .normal)
        sureBtn.frame = CGRect(x: kWidth - 60, y: 0, width: 60, height: 40)
        sureBtn.tag = 700 + currentTag
        colorBgV.addSubview(sureBtn)
        sureBtn.addTarget(self, action: #selector(sureClick(btn:)), for: .touchUpInside)
        
        let cancelBtn = UIButton()
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(.black, for: .normal)
        cancelBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        colorBgV.addSubview(cancelBtn)
        cancelBtn.addTarget(self, action: #selector(removeBgView(sender:)), for: .touchUpInside)
        
        //创建日期选择器
        let datePicker = UIDatePicker(frame: CGRect(x:0, y: 40, width:kWidth, height:200))
        //将日期选择器区域设置为中文，则选择器日期显示为中文
        datePicker.locale = Locale(identifier: "zh_CN")
        datePicker.datePickerMode = .dateAndTime
        datePicker.backgroundColor = .white
        datePicker.tag = 10086 + currentTag
        
        datePicker.calendar = .current
        datePicker.timeZone = .current
        datePicker.date = Date.init(timeIntervalSinceNow: 100)
        DLog(datePicker.date)
        //注意：action里面的方法名后面需要加个冒号“：”
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        colorBgV.addSubview(datePicker)
        
        let whiteV = UIView(frame:  CGRect(x: 0, y: datePicker.bottom, width: kWidth, height: SafeAreaBottomHeight))
        whiteV.backgroundColor = UIColor.white
        colorBgV.addSubview(whiteV)
    }
    
    @objc func removeBgView(sender: UIButton) {
        self.bgView.removeAllSubviews()
        self.bgView.removeFromSuperview()
    }
    
    @objc func sureClick(btn:UIButton) {
        
        if btn.tag == 700 {
            //            let layout:TGLinearLayout = self.view.viewWithTag(101) as! TGLinearLayout
            let btn:UIButton = self.view.viewWithTag(200) as! UIButton
            btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 100))
            if startTime.isEmpty{
                let now = Date()
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
                self.startTime = dateFormat.string(from: now)
                btn.setTitle(startTime, for: .normal)
            }else{
                btn.setTitle(startTime, for: .normal)
            }
            
            btn.titleLabel?.font = kFontSize15
            btn.setTitleColor(UIColor.black, for: UIControlState.normal)
            
            if !endTime.isEmpty {
                if self.compareDate(){
                    
                }else{
                    SVProgressHUD.showInfo(withStatus: "结束时间必须大于开始时间")
                }
            }
            
        }else if btn.tag == 701 {
            
            let btn:UIButton = self.view.viewWithTag(201) as! UIButton
            btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 100))
            if endTime.isEmpty{
                let now = Date()
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
                self.endTime = dateFormat.string(from: now)
                btn.setTitle(endTime, for: .normal)
            }else{
                btn.setTitle(endTime, for: .normal)
            }
            btn.titleLabel?.font = kFontSize15
            btn.setTitleColor(UIColor.black, for: UIControlState.normal)
           
            if !startTime.isEmpty {
                if self.compareDate() {
                    
                }else{
                    SVProgressHUD.showInfo(withStatus: "结束时间必须大于开始时间")
                }
            }
            
        }
        self.bgView.removeAllSubviews()
        self.bgView.removeFromSuperview()
    }
    
    //日期选择器响应方法
    @objc func dateChanged(datePicker : UIDatePicker){
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        if datePicker.tag == 10086 {
            startTime = formatter.string(from: datePicker.date)
            DLog(self.startTime)
        }else{
            endTime = formatter.string(from: datePicker.date)
        }
    }
    
    func compareDate() -> Bool {
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let BDate:Date?
        let EDate:Date?
        BDate = formatter.date(from: startTime)
        EDate = formatter.date(from: endTime)
        var result:ComparisonResult?
        if !self.startTime.isEmpty && !self.endTime.isEmpty{
            result = (BDate?.compare(EDate!))!
        }
        
        if result == .orderedDescending || result == .orderedSame {
            return false
        }
        return true
    }
}


extension CQMeetingRommBookVC:UITextFieldDelegate,KeyBoardDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    @objc func textFieldEditChanged(obj:Notification)  {
        
    }
}

// MARK: - 代理

extension CQMeetingRommBookVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userArray.count
    }
    
}

extension CQMeetingRommBookVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQWriteReportCellId", for: indexPath) as! CQWriteReportCell
        cell.nameLab.text = self.userArray[indexPath.item].realName
        cell.img.sd_setImage(with: URL(string: self.userArray[indexPath.item].headImage ), placeholderImage:UIImage.init(named: "personDefaultIcon") )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension CQMeetingRommBookVC:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
}


extension CQMeetingRommBookVC:CQRoomSelectDelegate{
    func selectCar(model: CQCarsModel) {
        
    }
    
    func selectRoom(model: CQChooseRoomModel) {
        self.roomModel = model
        self.roomName = model.roomName
        self.meetingBtn.setTitle(self.roomName, for: .normal)
        self.meetingBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        self.meetingBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 150))
    }
    
    
}

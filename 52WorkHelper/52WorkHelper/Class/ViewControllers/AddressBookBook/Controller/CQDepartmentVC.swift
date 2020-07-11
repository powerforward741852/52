//
//  CQDepartmentVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/2.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

/// 从何处进入通讯录 默认为tabbar进入
enum ToDepartmentVCType {
    case fromGroupChat
    case fromAddGroupMember
    case fromReport
    case fromSchedule
    case fromSupply
    case fromOverTime
    case fromTogetherPerson
    case fromCreateSchedule
    case fromCreateTask
    case fromContact
    case fromCreatMeeting
    case fromChooseDepart
    case fromGenJin
    case fromTurnSomeOne //转交
}

protocol CQChildDepartMentSelectDelegate : NSObjectProtocol{
    func selectCell(model:CQAddressBookModel)
}

class CQDepartmentVC: SuperVC {
    var hasSelectModelArr = [CQDepartMentUserListModel]()
    var toType:ToDepartmentVCType?
    var departmentId = ""
    var dataArray:CQDepartmnetModel?
    var childDepartmentDataArray = [CQAddressBookModel]()
    var selectArray = [Bool]() //选中与否
    var userIdArray = [String]() //已选中的userid
    var userNameArray = [String]() //已选中的userName
    var groupId = ""
    var groupNames = ""
    var reportUserArr = [CQDepartMentUserListModel]()//传回日报的数组
    var overTimeModel:CQDepartMentUserListModel?
    var rightBtn:UIButton?
    weak var selectDelegate:CQChildDepartMentSelectDelegate?
    var searchmode = "1"
    var remark = ""
    var businessApplyId = ""
    var curUserDataArray = [CQDepartMentUserListModel]()
    var oldHasSelectArr = [CQDepartMentUserListModel]()
    
    lazy var bookTable: CQChildDepartmentTable = {
        let bookTable = CQChildDepartmentTable.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        bookTable.separatorStyle = .singleLine
        bookTable.childTableDelegate = self
        bookTable.layer.borderColor = kLineColor.cgColor
        bookTable.backgroundColor = kProjectBgColor
        bookTable.layer.borderWidth = 0.5
        bookTable.hasSelectModelArr = self.hasSelectModelArr
        return bookTable
    }()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: self.bookTable.bottom, width: kWidth, height:kHeight  - CGFloat(self.curUserDataArray.count) * AutoGetHeight(height: 55)), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = kProjectBgColor
        table.layer.borderColor = kLineColor.cgColor
        table.layer.borderWidth = 0.5
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.oldHasSelectArr = self.hasSelectModelArr
        self.loadData()
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.bookTable)
        
        
        rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        rightBtn?.setTitle("完成", for: .normal)
        rightBtn?.sizeToFit()
        rightBtn?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: -6)
        rightBtn?.setTitleColor(UIColor.colorWithHexString(hex: "#20afff"), for: .normal)
        rightBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        let rightItem = UIBarButtonItem.init(customView: rightBtn!)
        
        if self.toType == .fromGroupChat {
            self.title = "发起群聊"
            self.bookTable.isFromLaunchGroupChat = true
            self.bookTable.changeDelegate = self
            rightBtn?.addTarget(self, action: #selector(OKClick), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = rightItem
        }else if self.toType == .fromOverTime {
            self.title = "选择加班人"
            self.bookTable.isFromLaunchGroupChat = false
            self.bookTable.isOverTime = true
            self.bookTable.overTimeDelegate = self
            rightBtn?.addTarget(self, action: #selector(overTimeClick), for: .touchUpInside)
            self.rightBtn?.isEnabled = true
            self.navigationItem.rightBarButtonItem = rightItem
        }else if self.toType == .fromContact {
            self.title = "选择联系人"
            self.bookTable.isFromLaunchGroupChat = false
            self.bookTable.isOverTime = true
            self.bookTable.overTimeDelegate = self
            rightBtn?.addTarget(self, action: #selector(contactClick), for: .touchUpInside)
            self.rightBtn?.isEnabled = true
            self.navigationItem.rightBarButtonItem = rightItem
        }else if self.toType == .fromAddGroupMember{
            self.title = "新增成员"
            self.bookTable.isFromLaunchGroupChat = true
            self.bookTable.changeDelegate = self
            rightBtn?.addTarget(self, action: #selector(addMemberClick), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = rightItem
        }else if self.toType == .fromReport{
            self.title = "选择想要发送的对象"
            self.bookTable.isFromLaunchGroupChat = true
            self.bookTable.changeDelegate = self
            rightBtn?.addTarget(self, action: #selector(reportChooseClick), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = rightItem
        }else if self.toType == .fromSupply{
            self.title = "选择想要抄送的对象"
            self.bookTable.isFromLaunchGroupChat = true
            self.bookTable.changeDelegate = self
            rightBtn?.addTarget(self, action: #selector(supplyChooseClick), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = rightItem
        }else if self.toType == .fromTogetherPerson{
            self.title = "选择同行人"
            self.bookTable.isFromLaunchGroupChat = true
            self.bookTable.changeDelegate = self
            rightBtn?.addTarget(self, action: #selector(togherChooseClick), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = rightItem
        }else if self.toType == .fromSchedule{
            self.title = "选择想查找的对象"
            self.bookTable.isFromSchedule = true
            self.bookTable.workMateSelectDelegate = self
            
        }else if self.toType == .fromCreateSchedule{
            self.title = "选择同事"
            self.bookTable.isFromLaunchGroupChat = true
            self.bookTable.changeDelegate = self
            self.bookTable.isFromCreateSchedule = true
            rightBtn?.addTarget(self, action: #selector(createScheduleClick), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = rightItem
        }else if self.toType == .fromCreatMeeting{
            self.title = "选择与会人员"
            self.bookTable.isFromLaunchGroupChat = true
            self.bookTable.changeDelegate = self
//            self.bookTable.isFromCreateSchedule = true
            rightBtn?.addTarget(self, action: #selector(createMeetingClick), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = rightItem
        }else if self.toType == .fromCreateTask{
            self.title = "选择任务成员"
            self.bookTable.isFromLaunchGroupChat = true
            self.bookTable.changeDelegate = self
            rightBtn?.addTarget(self, action: #selector(taskChooseClick), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = rightItem
        }else if self.toType == .fromChooseDepart{
            self.title = "选择部门"
        }else if self.toType == .fromGenJin {
            self.title = "选择跟进人"
            self.bookTable.changeDelegate = self
            self.bookTable.isFromLaunchGroupChat = true
            rightBtn?.addTarget(self, action: #selector(addGenJinClick), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = rightItem
        }else if self.toType == .fromTurnSomeOne {
            self.title = "选择转交人"
//            self.bookTable.isFromLaunchGroupChat = true
            self.bookTable.isTransferApprove = true
            self.bookTable.turnDelegate = self
        }
        
        
        let leftBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        leftBtn.setTitle("返回", for: .normal)
        leftBtn.setImage(UIImage(named: "blue_nav_arrow"), for: UIControlState.normal)
        leftBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        leftBtn.setTitleColor(kBlueColor, for: .normal)
        leftBtn.titleLabel?.tintColor = kBlueColor
        leftBtn.addTarget(self, action: #selector(backToSuperView), for: .touchUpInside)
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        leftBtn.contentHorizontalAlignment = .left
        let leftItem = UIBarButtonItem.init(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    @objc func cellClick(sender:UIButton)  {
        let btn = sender
        let cell = superUITableViewCell(of: btn)
        let table = superUITableView(of: btn)
        let index = table?.indexPath(for: cell!)
        let model = self.childDepartmentDataArray[index!.row]
        DLog(index)
        let nModel = CQAddressBookModel.init(name: model.childDepartmentName, dId: model.childDepartmentId)
        if self.selectDelegate != nil{
            self.selectDelegate?.selectCell(model: nModel!)
            for v in (self.navigationController?.viewControllers)! {
                if v is NCQApprovelVC{
                    self.navigationController?.popToViewController(v, animated: true)
                }
            }
        }
        
    }
    
    //返回button所在的UITableViewCell
    func superUITableViewCell(of: UIButton) -> UITableViewCell? {
        for view in sequence(first: of.superview, next: { $0?.superview }) {
            if let cell = view as? UITableViewCell {
                return cell
            }
        }
        return nil
    }
    
    //返回button所在的UITableView
    func superUITableView(of: UIButton) -> UITableView? {
        for view in sequence(first: of.superview, next: { $0?.superview }) {
            if let table = view as? UITableView {
                return table
            }
        }
        return nil
    }
    
    //创建群聊
    @objc func OKClick()  {
        self.userIdArray.removeAll()
        let userID = STUserTool.account().userID
        self.userIdArray.append(userID)
        
        
        for model in self.hasSelectModelArr{
            if model.userId != userID{
                self.userIdArray.append(model.userId)
            }
        }
        if self.userIdArray.count > 2{
        }else{
            SVProgressHUD.showInfo(withStatus: "群聊人数不得少于3人")
        }
        
    }
    //加班
    @objc func overTimeClick()  {
        //发送通知
        let NotifMycation = NSNotification.Name(rawValue:"refreshOverTimeMan")
        
        //这个方法可以传一个值
        NotificationCenter.default.post(name: NotifMycation, object: self.overTimeModel)
        
        for vc in (self.navigationController?.viewControllers)! {
            if vc is NCQApprovelVC {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    @objc func contactClick()  {
        //发送通知
        let NotifMycation = NSNotification.Name(rawValue:"refreshAddAddressVC")
        
        //这个方法可以传一个值
       
        
        for vc in (self.navigationController?.viewControllers)! {
            print(vc)
            if vc is CQAddAddressVC || vc is QRDetailCustomVC || vc is QRGonghaiVc || vc is QRCustomWebVC || vc is QRZanVC || vc is QRTongJiVC || vc is CQScheduleVC || vc is QRScheduleVC{
               // self.navigationController?.popToViewController(vc, animated: true)
                
                if vc is QRDetailCustomVC{
                    let vcc = vc as! QRDetailCustomVC
                    vcc.addobser()
                }else if vc is QRDetailCustomVC{
                    let vcc = vc as! QRDetailCustomVC
                    vcc.addobser()
                }else if vc is QRGonghaiVc{
                    let vcc = vc as! QRGonghaiVc
                    vcc.addobser()
                }else if vc is QRCustomWebVC || vc is QRZanVC || vc is QRTongJiVC || vc is CQScheduleVC || vc is QRScheduleVC{
                    self.navigationController?.popToViewController(vc, animated: false)
                    NotificationCenter.default.post(name: NotifMycation, object: self.overTimeModel)
                    return
                }
                
                NotificationCenter.default.post(name: NotifMycation, object: self.overTimeModel)
               // NotificationCenter.default.removeObserver(vc)
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
        print("xxxxxx")
         //NotificationCenter.default.post(name: NotifMycation, object: self.overTimeModel)
    }
    
    
    
    //选择同行人
    @objc func togherChooseClick() {
        
        //发送通知
        let NotifMycation = NSNotification.Name(rawValue:"refreshTogherCell")
        
        //这个方法可以传一个值
        NotificationCenter.default.post(name: NotifMycation, object: self.hasSelectModelArr)
        
        for vc in (self.navigationController?.viewControllers)! {
            if  vc is NCQApprovelVC{
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    //添加成员
    @objc func addMemberClick()  {
        
        var newSelectIdArr = [String]()
        
        var hasSelectIdArr = [String]()
        for model in self.oldHasSelectArr {
            hasSelectIdArr.append(model.userId)
        }
        
        self.userIdArray.removeAll()
        for model in self.hasSelectModelArr{
            self.userIdArray.append(model.userId)
        }
        
        for i in 0..<self.userIdArray.count{
            let hasNum = hasSelectIdArr.contains(self.userIdArray[i])
            if !hasNum{
                newSelectIdArr.append(self.userIdArray[i])
            }
        }
        if newSelectIdArr.count > 0{
           // self.invitateJoinGroupChatRequest(userIds: newSelectIdArr)
        }else{
            SVProgressHUD.showInfo(withStatus: "请勾选")
        }
    }
    
    //选择抄送
    @objc func supplyChooseClick()  {
        
        //发送通知
        let NotifMycation = NSNotification.Name(rawValue:"refreshSupplyCell")
        
        //这个方法可以传一个值
        NotificationCenter.default.post(name: NotifMycation, object: self.hasSelectModelArr)
       
        for vc in (self.navigationController?.viewControllers)! {
            if  vc is NCQApprovelVC{
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    // 选择汇报 创建日程 汇报 会议
    @objc func reportChooseClick()  {
        //发送通知
        let NotifMycation = NSNotification.Name(rawValue:"refreshReportCell")
        
        //这个方法可以传一个值
        NotificationCenter.default.post(name: NotifMycation, object: self.hasSelectModelArr)
        //这个方法可传一个字典
        //        NotificationCenter.default.post(name: NotifMycation, object: nil, userInfo: ["" :
        
        
        for vc in (self.navigationController?.viewControllers)! {
            if vc is CQWriteReportVC || vc is CQCreateScheduleVC || vc is CQCreateMeetingVC {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    //创建日程
    @objc func createScheduleClick()  {
       
        //发送通知
        let NotifMycation = NSNotification.Name(rawValue:"refreshCreateScheduleCell")
        
        //这个方法可以传一个值
        NotificationCenter.default.post(name: NotifMycation, object: self.hasSelectModelArr)
        //这个方法可传一个字典
        //        NotificationCenter.default.post(name: NotifMycation, object: nil, userInfo: ["" :
        
        
        for vc in (self.navigationController?.viewControllers)! {
            if vc is CQCreateScheduleVC {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    //创建会议
    @objc func createMeetingClick()  {
        
        //发送通知
        let NotifMycation = NSNotification.Name(rawValue:"refreshCreateMeetingCell")
        
        //这个方法可以传一个值
        NotificationCenter.default.post(name: NotifMycation, object: self.hasSelectModelArr)
        //这个方法可传一个字典
        //        NotificationCenter.default.post(name: NotifMycation, object: nil, userInfo: ["" :
        
        
        for vc in (self.navigationController?.viewControllers)! {
            if vc is CQCreateMeetingVC {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    @objc func taskChooseClick()  {
        
        //发送通知
        let NotifMycation = NSNotification.Name(rawValue:"refreshCreateTaskCell")
        
        //这个方法可以传一个值
        NotificationCenter.default.post(name: NotifMycation, object: self.hasSelectModelArr)
        //这个方法可传一个字典
        //        NotificationCenter.default.post(name: NotifMycation, object: nil, userInfo: ["" :
        
        
        for vc in (self.navigationController?.viewControllers)! {
            if vc is CQCreateTaskVC {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }

    //addGenJinClick
    @objc func addGenJinClick()  {
        //发送通知
        let NotifMycation = NSNotification.Name(rawValue:"AddTracker")
        
        //这个方法可以传一个值
        NotificationCenter.default.post(name: NotifMycation, object: self.hasSelectModelArr)
        //这个方法可传一个字典
        //        NotificationCenter.default.post(name: NotifMycation, object: nil, userInfo: ["" :
        
        
        for vc in (self.navigationController?.viewControllers)! {
            if   vc is QRAddTrackBusinessVC || vc is QRAddTrackPersonVC || vc is QRAddBusinessVC || vc is CQAddCustomerVC{
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    
    
    
    
}

// Mark:loadData
extension CQDepartmentVC{
    func loadData() {
        let userid = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/mailList/getChildDepartmentList",
            type: .get,
            param: ["departmentId":self.departmentId,
                    "groupId":"",
                    "searchmode":searchmode,"userId":userid], successCallBack: { (result) in
                
                guard let model = CQDepartmnetModel.init(jsonData: result["data"]) else {
                    return
                }
                self.dataArray = model
                var tempArray = [CQAddressBookModel]()
                
                for modelJson in result["data"]["childDepartmentData"].arrayValue {
                    guard let childModel = CQAddressBookModel(jsonData: modelJson) else {
                        return
                    }
                    tempArray.append(childModel)
                }
                
                self.childDepartmentDataArray = tempArray
                
                self.curUserDataArray.removeAll()
                self.selectArray.removeAll()
                        
                var userArray = [CQDepartMentUserListModel]()
                for modelJson in result["data"]["userData"].arrayValue{
                    guard let userModel = CQDepartMentUserListModel(jsonData: modelJson) else {
                        return
                    }
                    userArray.append(userModel)
                }
                
                self.curUserDataArray = userArray
                self.bookTable.dataArray = self.curUserDataArray
                for i in 0..<self.curUserDataArray.count{
                    self.selectArray.append(false)
                    DLog(self.selectArray[i])
                }
            
                if self.hasSelectModelArr.count > 0 {
                    for i in 0..<self.selectArray.count{
                        let model = self.curUserDataArray[i]
                        for m in self.hasSelectModelArr{
                            if m.userId == model.userId{
                                let num = i
                                let sec = i + 1
                                self.selectArray.replaceSubrange(Range(num ..< sec), with: [!self.selectArray[i]])
                            }
                        }
                    }
                }
                self.bookTable.tableFooterView = self.table
                        
                self.table.register(UITableViewCell.self, forCellReuseIdentifier: "CQAddressBookDefaultCellId")
                        
                self.bookTable.reloadDataWithSelectArr(statusArr: self.selectArray)
                self.table.reloadData()
                
        }) { (error) in
            print(error)
        }
    }
}


extension CQDepartmentVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.childDepartmentDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "CQAddressBookDefaultCellId", for: indexPath) as UITableViewCell
        cell.accessoryType = .disclosureIndicator
        let model = self.childDepartmentDataArray[indexPath.row]
        cell.textLabel?.text = model.childDepartmentName
        if self.toType == .fromChooseDepart{
            let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: kWidth/2, height: AutoGetHeight(height: 55)))
            btn.addTarget(self, action: #selector(cellClick(sender:)), for: .touchUpInside)
            cell.addSubview(btn)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.childDepartmentDataArray[indexPath.row]
        let vc = CQDepartmentVC.init()
        vc.departmentId = model.childDepartmentId
        if self.toType == .fromGroupChat{
            vc.toType = .fromGroupChat
            vc.groupNames = self.groupNames
        }else if self.toType == .fromAddGroupMember{
            vc.toType = .fromAddGroupMember
        }else if self.toType == .fromOverTime{
            vc.toType = .fromOverTime
        }else if self.toType == .fromContact{
            vc.toType = .fromContact
        }else if self.toType == .fromReport{
            vc.toType = .fromReport
        }else if self.toType == .fromCreateSchedule{
            vc.toType = .fromCreateSchedule
        }else if self.toType == .fromCreatMeeting{
            vc.toType = .fromCreatMeeting
        }else if self.toType == .fromSupply{
            vc.toType = .fromSupply
        }else if self.toType == .fromTogetherPerson{
            vc.toType = .fromTogetherPerson
        }else if self.toType == .fromCreateTask{
            vc.toType = .fromCreateTask
        }else if self.toType == .fromSchedule{
            vc.toType = .fromSchedule
        }else if self.toType == .fromGenJin{
            vc.toType = .fromGenJin
         //   vc.selectDelegate = self
        }else if self.toType == .fromChooseDepart{
            vc.toType = .fromChooseDepart
            vc.selectDelegate = self
        }else if self.toType == .fromTurnSomeOne{
            vc.toType = .fromTurnSomeOne
            vc.remark = self.remark
            vc.businessApplyId = self.businessApplyId
        }else {
            vc.title = model.childDepartmentName
        }
        vc.hasSelectModelArr = self.hasSelectModelArr
        vc.groupId = self.groupId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoGetHeight(height: 55)
    }
}


//MARK:选择聊天对象
extension CQDepartmentVC:CQChildTableDelegate{
    func pushToContactDetailVC(model:CQDepartMentUserListModel) {
        let vc = CQWorkInstrumentPersonInfoVC.init()
        vc.userId = model.userId
        vc.chatName = model.realName
        vc.userModel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK:选择同事日程
extension CQDepartmentVC:CQScheduleWorkMateSelectDelegate{
    func selectWorkMate(uid: String) {
        //发送通知
        let NotifMycation = NSNotification.Name(rawValue:"postUserIdToScheduleVC")
        
        //这个方法可以传一个值
        NotificationCenter.default.post(name: NotifMycation, object: uid)
        //这个方法可传一个字典
        //        NotificationCenter.default.post(name: NotifMycation, object: nil, userInfo: ["" :
        
        
        for vc in (self.navigationController?.viewControllers)! {
            if vc is CQScheduleVC{
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
}

extension CQDepartmentVC:CQGroupSelectDelegate{
    func changeSelectImg(hasSelectArr: [CQDepartMentUserListModel]) {
        self.hasSelectModelArr = hasSelectArr
    }
}

extension CQDepartmentVC:CQOverTimeChildSelectDelegate{
    func overSelectImg(userModelArr: CQDepartMentUserListModel) {
        self.overTimeModel = userModelArr
        self.rightBtn?.isEnabled = true
    }
    
    
}

extension CQDepartmentVC{
   
    
    // 审批-转交
    // 审批-转交
    func transferApprove(turnId:String)  {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/transferApprove" ,
            type: .get,
            param: ["agentEmyeId":turnId,
                    "emyeId":userID,
                    "businessApplyId":self.businessApplyId,
                    "remark":self.remark],
            successCallBack: { (result) in
                self.loadingSuccess()
                NotificationCenter.default.post(name: NSNotification.Name.init("refreshNotAgreeVC"), object: nil)
                SVProgressHUD.showInfo(withStatus: "转交成功")
                for vc in (self.navigationController?.viewControllers)! {
                    if vc is CQNeedMeAgreeVC || vc is CQIndexVC {
                        self.navigationController?.popToViewController(vc, animated: true)
                    }
                }
                
        }) { (error) in
            self.loadingSuccess()
        }
    }
}

extension CQDepartmentVC:CQChildDepartMentSelectDelegate{
    func selectCell(model: CQAddressBookModel) {
        if self.selectDelegate != nil{
            self.selectDelegate?.selectCell(model: model)
            
        }
    }
}

extension CQDepartmentVC:CQTranferAproveDelegate{
    func transferAprove(uid: String) {
        self.loadingPlay()
        self.transferApprove(turnId: uid)
    }
}


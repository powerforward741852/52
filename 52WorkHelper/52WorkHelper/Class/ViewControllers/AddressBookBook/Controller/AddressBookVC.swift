//
//  AddressBookVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/4/23.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

/// 从何处进入通讯录 默认为tabbar进入
enum ToAddressBookType {
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
    case fromKeHuGenJin
    case fromTurnSomeOne //转交
    case normal
}

protocol CQDepartMentSelectDelegate : NSObjectProtocol{
    func selectCell(model: CQAddressBookModel)
}

class AddressBookVC: SuperVC {
    
    var scheduleModel = false
    
    var hasSelectModelArr = [CQDepartMentUserListModel]()
    var toType:ToAddressBookType?
    var dataArray = [CQAddressBookModel]()
    var groupId = ""
    var selectArray = [Bool]() //选中与否
    var userIdArray = [String]() //已选中的userid
    var userNameArray = [String]() //已选中的userName
    var reportUserArr = [CQDepartMentUserListModel]()//传回日报的数组
    
    var groupNames = ""
    var overTimeModel:CQDepartMentUserListModel?
    var overTimeRightItem:UIBarButtonItem?
    var rightBtn:UIButton?
    weak var selectDelegate:CQDepartMentSelectDelegate?
    var remark = ""
    var businessApplyId = ""
    var oldHasSelectArr = [CQDepartMentUserListModel]()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    
    
    
    lazy var searchView: UIView = {
        let searchView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 45)))
        searchView.backgroundColor = UIColor.white
      //  searchView.layer.borderColor = kLineColor.cgColor
      //  searchView.layer.borderWidth = 0.5
        let line = UIView(frame:  CGRect(x: 0, y: AutoGetHeight(height: 44.5), width: kWidth, height: AutoGetHeight(height: 0.5)))
        line.backgroundColor = kLineColor
        searchView.addSubview(line)
        return searchView
    }()
    
    lazy var searchBtn: UIButton = {
        let searchBtn = UIButton.init(type: .custom)
        searchBtn.frame = CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 5), width: kHaveLeftWidth, height: AutoGetHeight(height: 35))
        searchBtn.setImage(UIImage.init(named: "knowledgeSearch"), for: .normal)
        searchBtn.setTitle(" 搜索姓名/手机号", for: .normal)
        searchBtn.setTitleColor(kLyGrayColor, for: .normal)
//         : 300), bottom: 0, right: 0)
        searchBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        searchBtn.layer.cornerRadius = 5
        searchBtn.backgroundColor = kProjectDarkBgColor
        searchBtn.addTarget(self, action: #selector(searchClick), for: .touchUpInside)
        return searchBtn
    }()
    
    
    
    lazy var bookTable: CQAddressBookTable = {
        let bookTable = CQAddressBookTable.init(frame: CGRect.init(x: 0, y: self.table.bottom, width: kWidth, height: kHeight - AutoGetHeight(height: 100) - 49 - 64), style: UITableViewStyle.plain)
        bookTable.separatorStyle = .singleLine
        bookTable.addressTableDelegate = self
        bookTable.changeDelegate = self
        bookTable.hasSelectModelArr = self.hasSelectModelArr
        return bookTable
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.oldHasSelectArr = self.hasSelectModelArr
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "CQAddressBookDefaultCellId")
        if self.toType == .fromChooseDepart{
            
        }else{
            self.table.tableHeaderView = self.searchView
            self.searchView.addSubview(self.searchBtn)
        }
        
        
        
        rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        rightBtn?.setTitle("完成", for: .normal)
        rightBtn?.sizeToFit()
        rightBtn?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: -6)
        rightBtn?.setTitleColor(kBlueColor, for: .normal)
        rightBtn?.titleLabel?.tintColor = kBlueColor
        rightBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        let rightItem = UIBarButtonItem.init(customView: rightBtn!)
        rightItem.tintColor = kBlueColor
        if self.toType == .fromGroupChat {
            self.title = "发起群聊"
            self.bookTable.isFromLaunchGroupChat = true
            rightBtn?.addTarget(self, action: #selector(OKClick), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = rightItem
        }else if self.toType == .fromAddGroupMember{
            self.title = "新增成员"
            self.bookTable.isFromLaunchGroupChat = true
            rightBtn?.addTarget(self, action: #selector(addMemberClick), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = rightItem
        }else if self.toType == .fromReport{
            self.title = "选择想要发送的对象"
            self.bookTable.isFromLaunchGroupChat = true
            rightBtn?.addTarget(self, action: #selector(reportChooseClick), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = rightItem
        }else if self.toType == .fromSupply{
            self.title = "选择想要抄送的对象"
            self.bookTable.isFromLaunchGroupChat = true
            rightBtn?.addTarget(self, action: #selector(supplyChooseClick), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = rightItem
        }else if self.toType == .fromTogetherPerson{
            self.title = "选择同行人"
            self.bookTable.isFromLaunchGroupChat = true
            rightBtn?.addTarget(self, action: #selector(toghterChooseClick), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = rightItem
        }else if self.toType == .fromOverTime  {
            self.title = "选择加班人"
            self.bookTable.isFromLaunchGroupChat = false
            self.bookTable.isOverTime = true
            self.bookTable.overTimeDelegate = self
            self.overTimeRightItem = UIBarButtonItem.init(title: "完成", style: .done, target: self, action: #selector(overTimeClick))
            self.overTimeRightItem?.isEnabled = false
            self.navigationItem.rightBarButtonItem = self.overTimeRightItem
        }else if self.toType == .fromContact  {
            self.title = "选择联系人"
            self.bookTable.isFromLaunchGroupChat = false
            self.bookTable.isOverTime = true
            self.bookTable.overTimeDelegate = self
            self.overTimeRightItem = UIBarButtonItem.init(title: "完成", style: .done, target: self, action: #selector(contactClick))
            self.overTimeRightItem?.tintColor = kBlueColor
            self.overTimeRightItem?.isEnabled = false
            self.navigationItem.rightBarButtonItem = self.overTimeRightItem
        }else if self.toType == .fromSchedule{
            self.title = "选择想查找的对象"
            self.bookTable.isFromSchedule = true
            self.bookTable.workmateSelectDelegate = self
        }else if self.toType == .fromCreateSchedule{
            self.title = "选择同事"
            self.bookTable.isFromLaunchGroupChat = true
            self.bookTable.isFromCreateSchedule = true
            rightBtn?.addTarget(self, action: #selector(CreateScheduleClick), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = rightItem
        }else if self.toType == .fromCreatMeeting{
            self.title = "选择与会人员"
            self.bookTable.isFromLaunchGroupChat = true
//            self.bookTable.isFromCreateSchedule = true
            rightBtn?.addTarget(self, action: #selector(CreateMeetingClick), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = rightItem
        }else if self.toType == .fromCreateTask{
            self.title = "选择任务成员"
            self.bookTable.isFromLaunchGroupChat = true
            rightBtn?.addTarget(self, action: #selector(taskChooseClick), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = rightItem
        }else if self.toType == .fromGenJin{
            self.title = "选择跟进人"
            self.bookTable.isFromLaunchGroupChat = true
            rightBtn?.addTarget(self, action: #selector(GenJinChooseClick), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = rightItem
        }else if self.toType == .fromChooseDepart{
            self.title = "选择部门"
        }else if self.toType == .fromTurnSomeOne {
            self.title = "选择转交人"
            
            self.bookTable.isTransferApprove = true
            self.bookTable.turnDelegate = self
//            self.bookTable.isFromLaunchGroupChat = true
        } else{
            self.title = "通讯录"
            self.bookTable.isFromLaunchGroupChat = false
            
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//         [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
//        let img = imageWithColor(color: UIColor.clear, size: CGSize(width: kWidth, height: 0.5))
       self.navigationController?.navigationBar.shadowImage = UIImage()
        self.loadData()
        if !self.isTabbarRoot(){
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
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      
        let img = imageWithColor(color: kfilterBackColor, size: CGSize(width: kWidth, height: 0.5))
        self.navigationController?.navigationBar.shadowImage = img
    }
    
    @objc func cellClick(sender:UIButton)  {
        let btn = sender
        let cell = superUITableViewCell(of: btn)
        let table = superUITableView(of: btn)
        let index = table?.indexPath(for: cell!)
        DLog(index)
        let model = self.dataArray[(index?.row)!]
        if self.selectDelegate != nil{
            self.selectDelegate?.selectCell(model: model)
            self.navigationController?.popViewController(animated: true)
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
    
    @objc func searchClick()  {
        let vc = CQAddressSearchVC()
        vc.hasSelectModelArr = self.hasSelectModelArr
        if self.toType == .fromSchedule {
            vc.toType = .fromSchedule
        }else if self.toType == .fromCreateSchedule{
            vc.toType = .fromCreateSchedule
        }else if self.toType == .fromCreatMeeting{
            vc.toType = .fromCreatMeeting
        }else if self.toType == .fromGroupChat {
            vc.toType = .fromGroupChat
            vc.groupNames = self.groupNames
        }else if self.toType == .fromReport{
            vc.toType = .fromReport
        }else if self.toType == .fromOverTime{
            vc.toType = .fromOverTime
        }else if self.toType == .fromContact{
            vc.toType = .fromContact
        }else if self.toType == .fromAddGroupMember{
            vc.toType = .fromAddGroupMember
            vc.groupId = self.groupId
        }else if self.toType == .fromSupply{
            vc.toType = .fromSupply
        }else if self.toType == .fromCreateTask{
            vc.toType = .fromCreateTask
        }else if self.toType == .fromTogetherPerson{
            vc.toType = .fromTogetherPerson
        }else if self.toType == .fromGenJin{
            vc.toType = .fromGenJin
        }else if self.toType == .fromTurnSomeOne{
            vc.toType = .fromTurnSomeOne
            vc.remark = self.remark
            vc.businessApplyId = self.businessApplyId
        }else{
            
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
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
            if vc is CQAddAddressVC || vc is QRDetailCustomVC || vc is QRGonghaiVc || vc is QRCustomWebVC || vc is QRZanVC || vc is QRTongJiVC || vc is CQScheduleVC || vc is QRScheduleVC{
                if vc is QRDetailCustomVC{
                    let vcc = vc as! QRDetailCustomVC
                    vcc.addobser()
                }else if vc is QRDetailCustomVC{
                    let vcc = vc as! QRGonghaiVc
                    vcc.addobser()
                }else if vc is QRCustomWebVC || vc is QRZanVC || vc is QRTongJiVC || vc is CQScheduleVC || vc is QRScheduleVC{
                    self.navigationController?.popToViewController(vc, animated: false)
                    NotificationCenter.default.post(name: NotifMycation, object: self.overTimeModel)
                    return
                }
                
                NotificationCenter.default.post(name: NotifMycation, object: self.overTimeModel)
                self.navigationController?.popToViewController(vc, animated: true)
        
            }
        }
        print("addressbook")
        
    }
    
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
        }else{
            SVProgressHUD.showInfo(withStatus: "请勾选")
        }
        
    }
    
    @objc func toghterChooseClick()  {
        
        
        //发送通知
        let NotifMycation = NSNotification.Name(rawValue:"refreshTogherCell")
        
        //这个方法可以传一个值
        NotificationCenter.default.post(name: NotifMycation, object: self.hasSelectModelArr)
        
        for vc in (self.navigationController?.viewControllers)! {
            if vc is NCQApprovelVC{
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    @objc func supplyChooseClick()  {
        
        
        //发送通知
        let NotifMycation = NSNotification.Name(rawValue:"refreshSupplyCell")
        
        //这个方法可以传一个值
        NotificationCenter.default.post(name: NotifMycation, object: self.hasSelectModelArr)
        
        for vc in (self.navigationController?.viewControllers)! {
            if  vc is NCQApprovelVC {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
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
    
    @objc func CreateScheduleClick()  {
        
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
    
    @objc func CreateMeetingClick()  {
        
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
    
    
    @objc func GenJinChooseClick()  {
        
        //发送通知
        let NotifMycation = NSNotification.Name(rawValue:"AddTracker")
        
        //这个方法可以传一个值
        NotificationCenter.default.post(name: NotifMycation, object: self.hasSelectModelArr)
        //这个方法可传一个字典
        //        NotificationCenter.default.post(name: NotifMycation, object: nil, userInfo: ["" :
        
        for vc in (self.navigationController?.viewControllers)! {
            if vc is QRAddTrackBusinessVC || vc is QRAddTrackPersonVC || vc is QRAddBusinessVC || vc is CQAddCustomerVC {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    
    
}

extension AddressBookVC{
    func loadData() {
        let userId = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/mailList/getParentDepartmentList" ,
            type: .get,
            param: ["userId":userId,"scheduleModel":scheduleModel],
            successCallBack: { (result) in
               
                var tempArray = [CQAddressBookModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQAddressBookModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                
                self.dataArray = tempArray
                
                self.table.tableFooterView = self.bookTable
                self.table.reloadData()
                self.bookTable.loadData()
                self.bookTable.reloadData()
                
                
                
                
                
        }) { (error) in
            
        }
    }
    
   
    
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

extension AddressBookVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "CQAddressBookDefaultCellId", for: indexPath) as UITableViewCell
        cell.accessoryType = .disclosureIndicator
        let model = self.dataArray[indexPath.row]
        cell.textLabel?.text = model.departmentName
        if self.toType == .fromChooseDepart{
            let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: kWidth/2, height: AutoGetHeight(height: 55)))
            btn.addTarget(self, action: #selector(cellClick(sender:)), for: .touchUpInside)
            cell.addSubview(btn)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataArray[indexPath.row]
        let vc = CQDepartmentVC.init()
        vc.departmentId = model.departmentId
        vc.title = model.departmentName
        vc.groupId = self.groupId
        if self.toType == .fromGroupChat{
            vc.toType = .fromGroupChat
            vc.groupNames = self.groupNames
        }else if self.toType == .fromAddGroupMember{
            vc.toType = .fromAddGroupMember
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
        }else if self.toType == .fromSchedule{
            vc.toType = .fromSchedule
        }else if self.toType == .fromOverTime{
            vc.toType = .fromOverTime
        }else if self.toType == .fromContact{
            vc.toType = .fromContact
        }else if self.toType == .fromCreateTask{
            vc.toType = .fromCreateTask
        }else if self.toType == .fromChooseDepart{
            vc.toType = .fromChooseDepart
            vc.selectDelegate = self
        }else if self.toType == .fromGenJin{
            vc.toType = .fromGenJin
        }else if self.toType == .fromTurnSomeOne{
            vc.toType = .fromTurnSomeOne
            vc.remark = self.remark
            vc.businessApplyId = self.businessApplyId
        }
        vc.hasSelectModelArr = self.hasSelectModelArr
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoGetHeight(height: 55)
    }
}



extension AddressBookVC:CQAddressBookTableDelegate{
    func pushToContactDetailVC(model:CQDepartMentUserListModel) {
        let vc = CQWorkInstrumentPersonInfoVC.init()
        vc.userId = model.userId
        vc.chatName = model.realName
        vc.userModel = model
        vc.isFromAdress = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AddressBookVC:CQOverTimeSelectDelegate{
    func overSelectImg(userModelArr: CQDepartMentUserListModel) {
        self.overTimeModel = userModelArr
        self.overTimeRightItem?.isEnabled = true
    }
}

extension AddressBookVC:CQAddressBookChangeSelectDelegate{
    func changeSelectImg(hasSelectArr: [CQDepartMentUserListModel]) {
        self.hasSelectModelArr = hasSelectArr
    }
    
//    func changeSelectImg(index: IndexPath,selectArr:[Bool],userModelArr:[CQDepartMentUserListModel]) {
//        self.selectArray = selectArr
//        self.curUserDataArray = userModelArr
//        let num = index.row
//        let sec = index.row + 1
//        let selectStaues = selectArray[index.row]
//        self.selectArray.replaceSubrange(Range(num ..< sec), with: [!selectStaues])
//        DLog(self.selectArray)
//        //        let cell:CQAdressBookCell = self.bookTable.cellForRow(at: index) as! CQAdressBookCell
//        
//        self.bookTable.reloadDataWithSelectArr(statusArr: self.selectArray)
//    }
    
    
}

//选择同事日程
extension AddressBookVC:CQScheduleFromAddressChooseDelegate{
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

extension AddressBookVC:CQChildDepartMentSelectDelegate{
    func selectCell(model: CQAddressBookModel) {
        if self.selectDelegate != nil{
            self.selectDelegate?.selectCell(model: model)
//            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}

extension AddressBookVC:CQTurnOverDelegate{
    func turnOverClcik(uid: String) {
        self.loadingPlay()
        self.transferApprove(turnId: uid)
    }
}



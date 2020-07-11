//
//  QRAddressBookVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/10/25.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRAddressBookVC: SuperVC {
    
    //scheduleModel
    var scheduleModel = false
    
    var titleStr = ""
    
    var dataArr = [CQDepartMentUserListModel]()//常用联系人
    var selectArr = [Bool]()//选中情况
    
    var hasSelectModelArr = [CQDepartMentUserListModel]()
    var toType:ToAddressBookType?
    var dataArray = [CQAddressBookModel]()
    var groupId = ""
    var userIdArray = [String]() //已选中的userid
    var userNameArray = [String]() //已选中的userName
    var reportUserArr = [CQDepartMentUserListModel]()//传回日报的数组
    
    var groupNames = ""
    var overTimeModel:CQDepartMentUserListModel?
    var overTimeRightItem:UIBarButtonItem?
    var rightBtn:UIButton?
    var selectDelegate:CQDepartMentSelectDelegate?
    var remark = ""
    var businessApplyId = ""
    
    lazy var titleView: UIView = {
        let titleView = UIView(frame:  CGRect(x: 0, y: 0, width: kWidth, height: 15))
        titleView.backgroundColor = kProjectBgColor
        let titlelab = UILabel(title: "常用联系人", textColor: UIColor.gray, fontSize: 10, alignment: .left, numberOfLines: 1)
        titlelab.frame =  CGRect(x: 15, y: 0, width: kWidth, height: 15)
        titleView.addSubview(titlelab)
        
        return titleView
    }()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
//        table.register(UITableViewCell.self, forCellReuseIdentifier: "CQAddressBookDefaultCellId")
        table.register(QRAddressBookCell.self, forCellReuseIdentifier: "QRAddressBookSingleCellId")
        table.register(QRAddressBookCell.self, forCellReuseIdentifier: "QRAddressBookCellId")
        
        table.register(UINib(nibName: "QRAddressDepartmentCell", bundle: nil), forCellReuseIdentifier: "QRAddressDepartmentID")
        
        table.backgroundColor = UIColor.white
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    
    lazy var searchView: UIView = {
        let searchView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 45)))
        searchView.backgroundColor = UIColor.white
//        searchView.layer.borderColor = kLineColor.cgColor
//        searchView.layer.borderWidth = 0.5
        let line = UIView(frame:  CGRect(x: 0, y: AutoGetHeight(height: 44.5), width: kWidth, height: AutoGetHeight(height: 0.5)))
        line.backgroundColor = kLineColor
        searchView.addSubview(line)
        return searchView
    }()
    
    lazy var searchBtn: UIButton = {
        let searchBtn = UIButton.init(type: .custom)
        searchBtn.frame = CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 5), width: kHaveLeftWidth, height: AutoGetHeight(height: 35))
        searchBtn.setImage(UIImage.init(named: "knowledgeSearch"), for: .normal)
        searchBtn.setTitle(" 搜索部门/姓名/手机", for: .normal)
        searchBtn.setTitleColor(kLyGrayColor, for: .normal)
        //        searchBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -AutoGetWidth(width: 300), bottom: 0, right: 0)
        searchBtn.layer.cornerRadius = 5
        searchBtn.backgroundColor = kProjectDarkBgColor
        searchBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        searchBtn.addTarget(self, action: #selector(searchClick), for: .touchUpInside)
        return searchBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
       
        self.table.tableHeaderView = self.searchView
        self.searchView.addSubview(self.searchBtn)
        //右键完成
        rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        rightBtn?.setTitle("完成", for: .normal)
        rightBtn?.sizeToFit()
        rightBtn?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: -6)
        rightBtn?.setTitleColor(kBlueColor, for: .normal)
        rightBtn?.titleLabel?.tintColor = kBlueColor
        rightBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        self.title = titleStr
        
        if self.toType == .fromGroupChat {
            self.title = "发起群聊"
        
        }else if self.toType == .fromAddGroupMember{
            self.title = "参与人员"
            rightBtn?.addTarget(self, action: #selector(creatScreduleClick), for: .touchUpInside)
           
        }else if self.toType == .fromReport{
            self.title = "选择想要发送的对象"
           
        }else if self.toType == .fromSupply{
            self.title = "选择想要抄送的对象"
         
        }else if self.toType == .fromTogetherPerson{
            self.title = "选择同行人"
            rightBtn?.addTarget(self, action: #selector(togetherChooseClick), for: UIControlEvents.touchUpInside)
        }else if self.toType == .fromOverTime  {
            self.title = "选择加班人"
        }else if self.toType == .fromContact  {
           //单选
            self.title = "选择联系人"
            rightBtn?.isHidden = true
            rightBtn?.isEnabled = false
            
        }else if self.toType == .fromSchedule{
            self.title = "选择想查找的对象"
        }else if self.toType == .fromCreateSchedule{
            self.title = "选择同事"
         
        }else if self.toType == .fromCreatMeeting{
            self.title = "选择与会人员"
            
        }else if self.toType == .fromCreateTask{
            self.title = "选择任务成员"
         
        }else if self.toType == .fromGenJin{
            
            rightBtn?.addTarget(self, action: #selector(GenJinChooseClick), for: UIControlEvents.touchUpInside)
        }else if self.toType == .fromKeHuGenJin{
            
            rightBtn?.addTarget(self, action: #selector(GenJinChooseClick), for: UIControlEvents.touchUpInside)
        }else if self.toType == .fromChooseDepart{
            self.title = "选择部门"
           // rightBtn?.addTarget(self, action: #selector(departmentChooseClick), for: UIControlEvents.touchUpInside)
        }else if self.toType == .fromTurnSomeOne {
            self.title = "选择转交人"
        }else if self.toType == .normal{
            self.title = "通讯录"
            rightBtn?.isHidden = true
        }
        
        let rightItem = UIBarButtonItem.init(customView: rightBtn!)
        self.navigationItem.rightBarButtonItem = rightItem
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadDownData()
        self.loadData()
        //取消选中
    }
    
    func loadDownData()  {
        self.dataArr.removeAll()
        self.selectArr.removeAll()
        
        let uData = UserDefaults.standard.object(forKey: "userArray")
        
        if uData != nil {
            let uArr:[CQDepartMentUserListModel] = NSKeyedUnarchiver.unarchiveObject(with: uData as! Data) as! [CQDepartMentUserListModel]
            self.dataArr = uArr
            DLog(uArr)
        }
        for _ in self.dataArr {
            self.selectArr.append(false)
        }
        if self.hasSelectModelArr.count > 0 {
            
            for i in 0..<self.selectArr.count{
                let model = self.dataArr[i]
                for m in self.hasSelectModelArr{
                    if m.userId == model.userId{
                        let num = i
                        let sec = i + 1
                        self.selectArr.replaceSubrange(Range(num ..< sec), with: [true])
                    }
                }
            }
        }
        self.table.reloadData()
    }
    
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
                //部门总管
                self.dataArray = tempArray
                self.table.reloadData()
                
        }) { (error) in
             self.loadData()
        }
    }
   
    func singleSelectJump(mod:CQDepartMentUserListModel){
        print(mod.realName)
        for vc in (self.navigationController?.viewControllers)! {
            if vc is CQAddAddressVC || vc is QRDetailCustomVC || vc is QRGonghaiVc || vc is QRCustomWebVC || vc is QRZanVC || vc is QRTongJiVC || vc is CQScheduleVC || vc is QRScheduleVC || vc is NCQApproelDetailVC{
                
                if vc is CQAddAddressVC || vc is QRDetailCustomVC || vc is QRZanVC || vc is QRCustomWebVC{
                    let NotifMycation = NSNotification.Name(rawValue:"refreshAddAddressVC")
                    self.navigationController?.popToViewController(vc, animated: false)
                    NotificationCenter.default.post(name: NotifMycation, object: mod)
                    
                }else if vc is QRGonghaiVc{
                    
                } else if vc is QRTongJiVC{
                    let selectVc = QRTongJiVC()
                    selectVc.mySearchUserId = mod.userId
//                    selectVc.myStartDate = (vc as! QRTongJiVC).myStartDate
//                    selectVc.myEndDate = (vc as! QRTongJiVC).myEndDate
                    selectVc.selectName = mod.realName
                    self.navigationController?.pushViewController(selectVc, animated: true)
                } else if vc is CQScheduleVC{
                    
                } else if vc is QRScheduleVC{
                    let vc = QRSworkmateScheduleVC()
                    vc.isFromeAddressbook = true
                    vc.title = mod.realName + "的日程"
                    vc.curUserId = mod.userId
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    
//                    let NotifMycation = NSNotification.Name(rawValue:"refreshAddAddressVC")
//                    self.navigationController?.popToViewController(vc, animated: false)
//                    NotificationCenter.default.post(name: NotifMycation, object: mod)
                }else if vc is NCQApproelDetailVC{
                    self.loadingPlay()
                    self.transferApprove(turnId: mod.userId)
                }
                
            }
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
                    if vc is CQNeedMeAgreeVC || vc is CQIndexVC || vc is CQCopyToMeVC {
                        self.navigationController?.popToViewController(vc, animated: true)
                    }
                }
                
        }) { (error) in
            self.loadingSuccess()
        }
    }
    
}

extension QRAddressBookVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.dataArray.count
        }
          return self.dataArr.count
        }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
//            let cell = table.dequeueReusableCell(withIdentifier: "CQAddressBookDefaultCellId", for: indexPath) as UITableViewCell
            let cell = table.dequeueReusableCell(withIdentifier: "QRAddressDepartmentID", for: indexPath) as! QRAddressDepartmentCell
           
            let model = self.dataArray[indexPath.row]
            cell.textLab?.text = model.departmentName + "(" + model.haveUserNum + ")"
            cell.countNumLab?.text = "" //model.haveUserNum
                       return cell
            
            //            cell.accessoryType = .disclosureIndicator
//            cell.textLabel?.text = model.departmentName
            
        }else{
            
            if self.toType == .fromContact{
                //单选跳转
                let cell = tableView.dequeueReusableCell(withIdentifier: "QRAddressBookSingleCellId") as! QRAddressBookCell
                cell.model = self.dataArr[indexPath.row]
                return cell
            }else if self.toType == .normal{
                let cell = tableView.dequeueReusableCell(withIdentifier: "QRAddressBookCellId") as! QRAddressBookCell
                cell.model = self.dataArr[indexPath.row]
                
                 return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "QRAddressBookCellId") as! QRAddressBookCell
                cell.model = self.dataArr[indexPath.row]
                cell.selectBtn.isHidden = false
                cell.iconImg.frame.origin.x = cell.selectBtn.right + 8
                cell.nameLab.frame.origin.x = cell.iconImg.right + kLeftDis
                cell.jobLab.frame.origin.x = cell.iconImg.right + kLeftDis
                //显示已经被选中的cell
                cell.selectStatus = self.selectArr[indexPath.row]
                cell.layoutSubviews()
                return cell
            }
  
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0{
            let model = self.dataArray[indexPath.row]
            let vc = QRDepartmentVC.init()
            vc.departmentId = model.departmentId
            vc.titleStr = titleStr
            vc.businessApplyId = businessApplyId
            vc.remark = remark
           // vc.title = model.departmentName
            //点击进入下级菜单,需要传值
            vc.toType = self.toType
            vc.hasSelectModelArr = self.hasSelectModelArr
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
           
            if self.toType == .fromContact{
                //单选跳转
                singleSelectJump(mod: self.dataArr[indexPath.row])
            }else if self.toType == .normal{
                let vc = CQWorkInstrumentPersonInfoVC.init()
                let model = self.dataArr[indexPath.row]
                vc.userId = model.userId
                vc.chatName = model.realName
                vc.userModel = model
                vc.isFromAdress = true
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                //进入详情
                let cell = tableView.cellForRow(at: indexPath) as! QRAddressBookCell
                cell.selectBtn.isHidden = false
                
                let model = self.dataArr[indexPath.row]
                if cell.selectStatus == true{
                    //首先获取现在的是否选中,如果是就在选中的bool变成false,除去该model
                    if self.toType == .fromKeHuGenJin{
                        if model.userId == hasSelectModelArr[0].userId {
                            SVProgressHUD.showInfo(withStatus: "创建人不可删除")
                            return
                        }
                        if model.userId == hasSelectModelArr[1].userId {
                            SVProgressHUD.showInfo(withStatus: "客户经理不可删除")
                            return
                        }
                    }
                    self.selectArr[indexPath.row] = false
                    cell.selectStatus = !cell.selectStatus
                    cell.layoutSubviews()
                    //在选中的模型中,去除该模型
                    for (index,m) in self.hasSelectModelArr.enumerated(){
                        
                        if m.userId == model.userId{
                            self.hasSelectModelArr.remove(at: index)
                        }
                    }
                    
                    for vc in (self.navigationController?.viewControllers)! {
                        if vc is QRAddressBookVC || vc is QRDepartmentVC{
                            if vc is QRAddressBookVC{
                                let vcc = vc as! QRAddressBookVC
                                vcc.hasSelectModelArr = self.hasSelectModelArr
                            }
                            if vc is QRDepartmentVC{
                                let vcc = vc as! QRDepartmentVC
                                vcc.hasSelectModelArr = self.hasSelectModelArr
                            }
                        }
                    }
                    
                }else{
                    //如果不是就在选中的bool变成true ,尾部添加model
                    self.selectArr[indexPath.row] = true
                    cell.selectStatus = !cell.selectStatus
                    cell.layoutSubviews()
                    //在选中的模型中,添加该模型
                    self.hasSelectModelArr.append(model)
                    //全部添加进选中数组
                    for vc in (self.navigationController?.viewControllers)! {
                        if vc is QRAddressBookVC || vc is QRDepartmentVC{
                            if vc is QRAddressBookVC{
                                let vcc = vc as! QRAddressBookVC
                                vcc.hasSelectModelArr = self.hasSelectModelArr
                            }
                            if vc is QRDepartmentVC{
                                let vcc = vc as! QRDepartmentVC
                                vcc.hasSelectModelArr = self.hasSelectModelArr
                            }
                        }
                    }
                }
                
                
            }
            }
            
           
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoGetHeight(height: 55)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1{
           
            return self.titleView
        }else{
            return UIView()
        }
       
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1{
            return 15
        }else{
            return 1
        }
    }
}




extension QRAddressBookVC{
    
    @objc func GenJinChooseClick()  {
        //发送通知
        let NotifMycation = NSNotification.Name(rawValue:"AddTracker")
        //这个方法可以传一个值
        NotificationCenter.default.post(name: NotifMycation, object: self.hasSelectModelArr)
        //这个方法可传一个字典
        for vc in (self.navigationController?.viewControllers)! {
            if vc is QRAddTrackBusinessVC || vc is QRAddTrackPersonVC || vc is QRAddBusinessVC || vc is CQAddCustomerVC || vc is QRScheduleVC || vc is CQWriteReportVC || vc is NCQApprovelVC{
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    @objc func creatScreduleClick()  {
        //发送通知
        let NotifMycation = NSNotification.Name(rawValue:"FAddTracker")
        NotificationCenter.default.post(name: NotifMycation, object: self.hasSelectModelArr)
        
        for vc in (self.navigationController?.viewControllers)! {
            if vc is CQCreateScheduleVC || vc is CQCreateTaskVC {
                //这个方法可以传一个值
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    @objc func searchClick()  {
        let vc = QRAddressSearchVC()
        vc.hasSelectModelArr = self.hasSelectModelArr
        vc.toType = self.toType
        vc.remark = self.remark
        vc.businessApplyId = self.businessApplyId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func togetherChooseClick(){
        //发送通知
        let NotifMycation = NSNotification.Name(rawValue:"together")
        //这个方法可以传一个值
        NotificationCenter.default.post(name: NotifMycation, object: self.hasSelectModelArr)
        //这个方法可传一个字典
        for vc in (self.navigationController?.viewControllers)! {
            if  vc is NCQApprovelVC{
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    
}

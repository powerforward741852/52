//
//  QRDepartmentVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/10/25.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRDepartmentVC: SuperVC {
    var titleStr = ""
    var rootVC : QRAddressBookVC?
    var rootDVC : QRDepartmentVC?
    //回调闭包
    typealias clickBtnClosure = ( _ selectedARR:[CQDepartMentUserListModel]) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    //点击完成标记
    var isWangCheng = "Nowangcheng"
    //
    var hasSelectModelArr = [CQDepartMentUserListModel]()
    var toType:ToAddressBookType?
    var departmentId = ""
    var dataArray:CQDepartmnetModel?
    var childDepartmentDataArray = [CQAddressBookModel]()
    var curUserDataArray = [CQDepartMentUserListModel]()
    var selectArray = [Bool]() //选中与否
    var userIdArray = [String]() //已选中的userid
    var userNameArray = [String]() //已选中的userName
    var groupId = ""
    var groupNames = ""
    var reportUserArr = [CQDepartMentUserListModel]()//传回日报的数组
    var overTimeModel:CQDepartMentUserListModel?
    var rightBtn:UIButton?
    var selectDelegate:CQChildDepartMentSelectDelegate?
    var searchmode = "1"
    var remark = ""
    var businessApplyId = ""
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height:kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
        table.layer.borderColor = kLineColor.cgColor
        table.layer.borderWidth = 0.5
        table.register(QRAddressBookCell.self, forCellReuseIdentifier: "QRAddressBookCellId")
        table.register(QRAddressBookCell.self, forCellReuseIdentifier: "QRAddressBookSingleCellId")
        table.register(UINib(nibName: "QRAddressDepartmentCell", bundle: nil), forCellReuseIdentifier: "QRAddressDepartmentID")
        
//        table.register(UITableViewCell.self, forCellReuseIdentifier: "CQAddressBookDefaultCellId")
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(table)
        self.loadData()
        self.view.backgroundColor = kProjectBgColor
        rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        rightBtn?.setTitle("完成", for: .normal)
        rightBtn?.sizeToFit()
        rightBtn?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: -6)
        rightBtn?.setTitleColor(UIColor.colorWithHexString(hex: "#20afff"), for: .normal)
        rightBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        if self.toType == .fromGroupChat {
            self.title = "发起群聊"
            // rightBtn?.addTarget(self, action: #selector(OKClick), for: .touchUpInside)
            
        }else if self.toType == .fromAddGroupMember{
            self.title = "参与人员"
            rightBtn?.addTarget(self, action: #selector(creatScreduleClick), for: .touchUpInside)
        }else if self.toType == .fromReport{
            self.title = "选择想要发送的对象"
            //rightBtn?.addTarget(self, action: #selector(reportChooseClick), for: .touchUpInside)
        }else if self.toType == .fromSupply{
            self.title = "选择想要抄送的对象"
            //  rightBtn?.addTarget(self, action: #selector(supplyChooseClick), for: .touchUpInside)
        }else if self.toType == .fromTogetherPerson{
            self.title = "选择同行人"
            rightBtn?.addTarget(self, action: #selector(togetherChooseClick), for: .touchUpInside)
        }else if self.toType == .fromOverTime  {
     
        }else if self.toType == .fromContact  {
            self.title = titleStr
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
            self.title = titleStr
            rightBtn?.addTarget(self, action: #selector(GenJinChooseClick), for: .touchUpInside)
        }else if self.toType == .fromKeHuGenJin{
            rightBtn?.addTarget(self, action: #selector(GenJinChooseClick), for: UIControlEvents.touchUpInside)
        }else if self.toType == .fromChooseDepart{
            self.title = "选择部门"
        }else if self.toType == .fromTurnSomeOne {
            self.title = "选择转交人"
        }else{
            self.title = "通讯录"
            rightBtn?.isHidden = true
        }
        
        let rightItem = UIBarButtonItem.init(customView: rightBtn!)
        self.navigationItem.rightBarButtonItem = rightItem
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       

    }
    
    
    
    
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
                        
                        
                        var userArray = [CQDepartMentUserListModel]()
                        for modelJson in result["data"]["userData"].arrayValue{
                            guard let userModel = CQDepartMentUserListModel(jsonData: modelJson) else {
                                return
                            }
                            userArray.append(userModel)
                        }
                        
                        self.curUserDataArray = userArray
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
                                        self.selectArray.replaceSubrange(Range(num ..< sec), with: [true])
                                    }
                                }
                            }
                        }
                        
                        
                        
                        self.table.reloadData()
                        
                        
        }) { (error) in
            print(error)
            self.loadData()
        }
    }
    
    
    func singleSelectJump(mod:CQDepartMentUserListModel){
        
        //这个方法可以传一个值,发送通知
        for vc in (self.navigationController?.viewControllers)! {
            if vc is CQAddAddressVC || vc is QRDetailCustomVC || vc is QRGonghaiVc || vc is QRCustomWebVC || vc is QRZanVC || vc is QRTongJiVC || vc is CQScheduleVC || vc is QRScheduleVC || vc is NCQApproelDetailVC{
               
                if vc is CQAddAddressVC || vc is QRDetailCustomVC || vc is QRZanVC || vc is QRCustomWebVC{
                     let NotifMycation = NSNotification.Name(rawValue:"refreshAddAddressVC")
                    self.navigationController?.popToViewController(vc, animated: false)
                    NotificationCenter.default.post(name: NotifMycation, object: mod)
                    
                }else if vc is QRGonghaiVc{

                }else if vc is QRTongJiVC{
      
                    let selectVc = QRTongJiVC()
                    selectVc.mySearchUserId = mod.userId
//                    selectVc.myStartDate = (vc as! QRTongJiVC).myStartDate
//                    selectVc.myEndDate = (vc as! QRTongJiVC).myEndDate
                    selectVc.selectName = mod.realName
                    self.navigationController?.pushViewController(selectVc, animated: true)
                } else if vc is CQScheduleVC{
                    
                } else if vc is QRScheduleVC{
//                    let NotifMycation = NSNotification.Name(rawValue:"refreshAddAddressVC")
//                    self.navigationController?.popToViewController(vc, animated: false)
//                    NotificationCenter.default.post(name: NotifMycation, object: mod)
                    let vc = QRSworkmateScheduleVC()
                    vc.isFromeAddressbook = true
                    vc.title = mod.realName + "的日程"
                    vc.curUserId = mod.userId
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else if vc is NCQApproelDetailVC{
                    print(mod.realName)
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
extension QRDepartmentVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return self.curUserDataArray.count
        }else{
            return self.childDepartmentDataArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if self.toType == .fromContact{
                let cell = tableView.dequeueReusableCell(withIdentifier: "QRAddressBookSingleCellId") as! QRAddressBookCell
                cell.model = self.curUserDataArray[indexPath.row]
                return cell
            }else if self.toType == .normal{
                let cell = tableView.dequeueReusableCell(withIdentifier: "QRAddressBookSingleCellId") as! QRAddressBookCell
                cell.model = self.curUserDataArray[indexPath.row]
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "QRAddressBookCellId") as! QRAddressBookCell
                cell.model = self.curUserDataArray[indexPath.row]
                cell.selectBtn.isHidden = false
                cell.iconImg.frame.origin.x = cell.selectBtn.right + 8
                cell.nameLab.frame.origin.x = cell.iconImg.right + kLeftDis
                cell.jobLab.frame.origin.x = cell.iconImg.right + kLeftDis
                //显示已经被选中的cell
                cell.selectStatus = self.selectArray[indexPath.row]
                cell.layoutSubviews()
                return cell
            }
                
           
        }else{
//            let cell = table.dequeueReusableCell(withIdentifier: "CQAddressBookDefaultCellId", for: indexPath) as UITableViewCell
            
            let model = self.childDepartmentDataArray[indexPath.row]
            
            let cell = table.dequeueReusableCell(withIdentifier: "QRAddressDepartmentID", for: indexPath) as! QRAddressDepartmentCell
            cell.textLab?.text = model.childDepartmentName + "(" + model.childDepartmentHaveUserNum + ")"
            cell.countNumLab?.text = ""//model.childDepartmentHaveUserNum
            
//            cell.accessoryType = .disclosureIndicator
//            cell.textLabel?.text = model.childDepartmentName
//            cell.detailTextLabel?.text = model.childDepartmentHaveUserNum
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            
            if self.toType == .fromContact{
                //单选跳转
                singleSelectJump(mod: self.curUserDataArray[indexPath.row])

            }else if self.toType == .normal{
                let vc = CQWorkInstrumentPersonInfoVC.init()
                let model = self.curUserDataArray[indexPath.row]
                vc.userId = model.userId
               // vc.isFromAdress = true
                vc.userModel = model
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                
                //进入详情
                let cell = tableView.cellForRow(at: indexPath) as! QRAddressBookCell
                cell.selectBtn.isHidden = false
                let model = self.curUserDataArray[indexPath.row]
                if cell.selectStatus == true{
                    
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
                    //首先获取现在的是否选中,如果是就在选中的bool变成false,除去该model
                    self.selectArray[indexPath.row] = false
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
                    self.selectArray[indexPath.row] = true
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
  
        }else{
            //进入子菜单
            let model = self.childDepartmentDataArray[indexPath.row]
            let vc = QRDepartmentVC.init()
            vc.titleStr = titleStr
            vc.businessApplyId = businessApplyId
            vc.remark = remark
            vc.departmentId = model.childDepartmentId
            vc.hasSelectModelArr = self.hasSelectModelArr
            vc.toType = self.toType
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoGetHeight(height: 55)
    }
}
extension QRDepartmentVC{
    @objc func GenJinChooseClick()  {
        //发送通知
        let NotifMycation = NSNotification.Name(rawValue:"AddTracker")
        NotificationCenter.default.post(name: NotifMycation, object: self.hasSelectModelArr)
        
        for vc in (self.navigationController?.viewControllers)! {
            if vc is QRAddTrackBusinessVC || vc is QRAddTrackPersonVC || vc is QRAddBusinessVC || vc is CQAddCustomerVC || vc is QRScheduleVC  || vc is CQWriteReportVC || vc is NCQApprovelVC{
                //这个方法可以传一个值
                self.navigationController?.popToViewController(vc, animated: false)
                return
            }
        }
    }
    
    @objc func creatScreduleClick()  {
        //发送通知
        let NotifMycation = NSNotification.Name(rawValue:"FAddTracker")
        NotificationCenter.default.post(name: NotifMycation, object: self.hasSelectModelArr)
        
        for vc in (self.navigationController?.viewControllers)! {
            if vc is CQCreateScheduleVC  || vc is CQCreateTaskVC {
                //这个方法可以传一个值
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
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

//
//  CQAddressSearchVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/4.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

let imageWidth = AutoGetWidth(width: 95)


/// 从何处进入通讯录 默认为tabbar进入
enum ToAddressBookSearchType {
    case fromGroupChat
    case fromSchedule
    case fromCreateSchedule
    case fromReport
    case fromOverTime
    case fromAddGroupMember
    case fromSupply
    case fromContact
    case fromCreatMeeting
    case fromCreateTask
    case fromTogetherPerson
    case fromGenJin
    case fromTurnSomeOne
}



class CQAddressSearchVC: SuperVC {
    var hasSelectModelArr = [CQDepartMentUserListModel]()
    var dataArray = [CQDepartMentUserListModel]()
    var toType:ToAddressBookSearchType?
    var selectArr = [Bool]()
    
    var overTimeModel:CQDepartMentUserListModel?
    var lastSelect:IndexPath?
    
    var userIdArray = [String]() //已选中的userid
    var userArray = [CQDepartMentUserListModel]() //选中的个人model
    var groupNames = ""
    var groupId = ""
    var remark = ""
    var businessApplyId = ""
    var oldHasSelectArr = [CQDepartMentUserListModel]()
    
    lazy var searchView: UIView = {
        let searchView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: CGFloat(SafeAreaTopHeight)))
        searchView.backgroundColor = kProjectBgColor
        let lineView = UIView.init(frame: CGRect.init(x: 0, y: CGFloat(SafeAreaTopHeight) - 0.5, width: kWidth, height: 0.5))
        lineView.backgroundColor = UIColor.init(red: 0.9529, green: 0.9529, blue: 0.9529, alpha: 1)
        searchView.addSubview(lineView)
        searchView.layer.borderColor = kLineColor.cgColor
        searchView.layer.borderWidth = 0.5
        return searchView
    }()
    
    lazy var searchBar: CQSearchBar = {
        let searchBar = CQSearchBar.init(frame: CGRect.init(x: AutoGetWidth(width: 15), y: CGFloat(SafeAreaStateTopHeight) + 7, width: kWidth - AutoGetWidth(width: 75), height: 30))
        searchBar.delegate = self
        //        searchBar.placeholder = "搜索"
        //searchBar.placeholder = "        搜索姓名/手机号"
        searchBar.returnKeyType = UIReturnKeyType.search
        return searchBar
    }()
    
    lazy var mysearchBar : UISearchBar = {
        let serchbar = UISearchBar(frame:  CGRect(x:  0, y: SafeAreaTopHeight-44, width: kWidth - AutoGetWidth(width: 60), height:  44))
        serchbar.backgroundColor = kProjectBgColor
        serchbar.placeholder = "  搜索姓名/手机号"
        serchbar.backgroundImage = UIImage()
        serchbar.delegate = self
        return serchbar
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton.init(type: .custom)
        cancelBtn.frame = CGRect.init(x: kWidth - AutoGetWidth(width: 60), y: CGFloat(SafeAreaStateTopHeight) + 7, width: AutoGetWidth(width: 55), height: 30)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor.gray, for: .normal)
        cancelBtn.addTarget(self, action: #selector(backToSuperView), for: .touchUpInside)
        cancelBtn.titleLabel?.textAlignment = .right
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return cancelBtn
    }()
    
    
    
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        return table
    }()
    
    lazy var withOutResultView: UIView = {
        let withOutResultView = UIView.init(frame: CGRect.init(x: 0, y: 64, width: kWidth, height: AutoGetHeight(height: kHeight )))
        withOutResultView.backgroundColor = UIColor.init(red: 0.9529, green: 0.9529, blue: 0.9529, alpha: 1)
        let imageV = UIImageView.init(frame: CGRect.init(x: (kWidth - imageWidth)/2.0, y: AutoGetHeight(height: 51), width: imageWidth, height: imageWidth))
        imageV.image = UIImage.init(named: "searchNoResult")
        let lab = UILabel.init(frame: CGRect.init(x: 0, y: imageV.bottom + AutoGetHeight(height: 25), width: kWidth, height: AutoGetHeight(height: 20)))
        lab.textAlignment = .center
        lab.textColor = UIColor.black
        lab.text = "要不...换个关键词试试"
        lab.font = UIFont.boldSystemFont(ofSize: 18)
        withOutResultView.addSubview(imageV)
        withOutResultView.addSubview(lab)
        return withOutResultView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.oldHasSelectArr = self.hasSelectModelArr
        self.view.backgroundColor = kProjectBgColor
        
        self.searchView.addSubview(self.mysearchBar)
        self.searchView.addSubview(self.cancelBtn)
        self.view.addSubview(self.table)
        self.table.register(CQAdressBookCell.self, forCellReuseIdentifier: "CQAdressBookCellId")
        
        self.table.isHidden = true
        
        self.view.addSubview(self.withOutResultView)
        self.withOutResultView.isHidden = true
        
        self.searchBar.becomeFirstResponder()
                
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEditChanged(obj:)), name: Notification.Name.UITextViewTextDidChange, object: nil)
    }
    
    
    
    
    override func backToSuperView()  {
        if self.toType == .fromGroupChat && self.cancelBtn.titleLabel?.text == "完成"{
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
            
        }else if self.toType == .fromCreateSchedule && self.cancelBtn.titleLabel?.text == "完成"{
            
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
        }else if self.toType == .fromContact && self.cancelBtn.titleLabel?.text == "完成"{

                    let NotifMycation = NSNotification.Name(rawValue:"refreshAddAddressVC")
            
                        for vc in (self.navigationController?.viewControllers)! {
                            if vc is CQAddAddressVC || vc is QRDetailCustomVC || vc is QRGonghaiVc || vc is QRCustomWebVC || vc is QRZanVC || vc is QRTongJiVC || vc is CQScheduleVC || vc is QRScheduleVC{
            
                                if vc is QRDetailCustomVC{
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
            
                              //  self.navigationController?.popToViewController(vc, animated: true)
                            }
                        }
            

        }else if self.toType == .fromCreatMeeting && self.cancelBtn.titleLabel?.text == "完成"{
            
            
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
        }else if self.toType == .fromCreateTask && self.cancelBtn.titleLabel?.text == "完成"{
            
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
        }else if self.toType == .fromTogetherPerson && self.cancelBtn.titleLabel?.text == "完成"{
            
            //发送通知
            let NotifMycation = NSNotification.Name(rawValue:"refreshTogherCell")
            
            //这个方法可以传一个值
            NotificationCenter.default.post(name: NotifMycation, object: self.hasSelectModelArr)
            
            for vc in (self.navigationController?.viewControllers)! {
                if  vc is NCQApprovelVC{
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }else if self.toType == .fromAddGroupMember && self.cancelBtn.titleLabel?.text == "完成"{
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
        }else if self.toType == .fromReport && self.cancelBtn.titleLabel?.text == "完成"{
            
            //发送通知
            let NotifMycation = NSNotification.Name(rawValue:"refreshReportCell")
            
            //这个方法可以传一个值
            NotificationCenter.default.post(name: NotifMycation, object: self.hasSelectModelArr)
            
            for vc in (self.navigationController?.viewControllers)! {
                if vc is CQWriteReportVC {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }else if self.toType == .fromSupply && self.cancelBtn.titleLabel?.text == "完成"{
            //发送通知
            let NotifMycation = NSNotification.Name(rawValue:"refreshSupplyCell")
            
            //这个方法可以传一个值
            NotificationCenter.default.post(name: NotifMycation, object: self.hasSelectModelArr)
            
            for vc in (self.navigationController?.viewControllers)! {
                if  vc is NCQApprovelVC {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }else if self.toType == .fromGenJin && self.cancelBtn.titleLabel?.text == "完成"{
            //发送通知
            let NotifMycation = NSNotification.Name(rawValue:"AddTracker")
            
            //这个方法可以传一个值
            NotificationCenter.default.post(name: NotifMycation, object: self.hasSelectModelArr)
            
            for vc in (self.navigationController?.viewControllers)! {
                if vc is QRAddTrackBusinessVC || vc is QRAddTrackPersonVC || vc is QRAddBusinessVC || vc is CQAddCustomerVC  {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }else{
            self.navigationController?.popViewController(animated: true)
        }
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchView.removeFromSuperview()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        self.navigationController?.view.addSubview(self.searchView)
        
        let btn = UIButton.init()
        let item = UIBarButtonItem.init(customView: btn )
        self.navigationItem.leftBarButtonItem = item
    }
    
 
}

extension CQAddressSearchVC{
    func loadSearchList(keyWord:String)  {
        self.table.isHidden = false
        // MARK:header
        let STHeader = CQRefreshHeader {
            self.loadDatas(keyWord: keyWord)
        }
        
        self.table.mj_header = STHeader
        self.table.mj_header.beginRefreshing()
    }
    
    // MARK:request
    fileprivate func loadDatas(keyWord:String) {
       
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/mailList/getMailListPersonByKeyword" ,
            type: .get,
            param: ["userId":userID,
                    "keyWord":keyWord],
            successCallBack: { (result) in
                
                self.dataArray.removeAll()
                self.selectArr.removeAll()
                var tempArray = [CQDepartMentUserListModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQDepartMentUserListModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                
               
                self.dataArray = tempArray
                
                //从创建群聊而来
                if self.toType == .fromGroupChat || self.toType == .fromCreateSchedule || self.toType == .fromReport || self.toType == .fromAddGroupMember || self.toType == .fromSupply || self.toType == .fromCreatMeeting || self.toType == .fromCreateTask || self.toType == .fromTogetherPerson || self.toType == .fromGenJin {
                    for _ in self.dataArray {
                        self.selectArr.append(false)
                    }
                    if self.hasSelectModelArr.count > 0 {
                        for i in 0..<self.selectArr.count{
                            let model = self.dataArray[i]
                            for m in self.hasSelectModelArr{
                                if m.userId == model.userId{
                                    let num = i
                                    let sec = i + 1
                                    self.selectArr.replaceSubrange(Range(num ..< sec), with: [!self.selectArr[i]])
                                }
                            }
                        }
                    }
                    self.cancelBtn.setTitle("完成", for: .normal)
                }
                
                //刷新表格
              //  self.table.mj_header.endRefreshing()
                self.table.reloadData()
                
                //分页控制
                if  self.dataArray.count == 0{
                    self.table.isHidden = true
                    self.withOutResultView.isHidden = false
                }else
                {
                    self.table.isHidden = false
                    self.withOutResultView.isHidden = true
                }
                
               
                
                
        }) { (error) in
            self.table.reloadData()
            
          //  self.table.mj_header.endRefreshing()
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

extension CQAddressSearchVC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQAdressBookCellId") as! CQAdressBookCell
        
        if self.toType == .fromGroupChat || self.toType == .fromCreateSchedule || self.toType == .fromReport || self.toType == .fromAddGroupMember || self.toType == .fromSupply || self.toType == .fromCreatMeeting || self.toType == .fromCreateTask || self.toType == .fromTogetherPerson || self.toType == .fromGenJin {
            cell.selectBtn.isHidden = false
            cell.iconImg.frame.origin.x = cell.selectBtn.right
            cell.nameLab.frame.origin.x = cell.iconImg.right + kLeftDis
            cell.jobLab.frame.origin.x = cell.iconImg.right + kLeftDis
            cell.cellSelDelegate = self
            cell.selectStatus = self.selectArr[indexPath.row]
            cell.layoutSubviews()
        }
        cell.model = self.dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataArray[indexPath.row]
        DLog("111111111111")
        if self.toType == .fromSchedule{
            //发送通知
            let NotifMycation = NSNotification.Name(rawValue:"postUserIdToScheduleVC")
            
            //这个方法可以传一个值
            NotificationCenter.default.post(name: NotifMycation, object: model.userId)
            //这个方法可传一个字典
            //        NotificationCenter.default.post(name: NotifMycation, object: nil, userInfo: ["" :
            
            
            for vc in (self.navigationController?.viewControllers)! {
                if vc is CQScheduleVC{
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }else if self.toType == .fromOverTime{
            //发送通知
            let NotifMycation = NSNotification.Name(rawValue:"refreshOverTimeMan")
            
            //这个方法可以传一个值
            NotificationCenter.default.post(name: NotifMycation, object: self.dataArray[indexPath.row])
            
            for vc in (self.navigationController?.viewControllers)! {
                if vc is NCQApprovelVC {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
            
        }else if self.toType == .fromContact{
            //发送通知

            if (self.lastSelect != nil) {
                let lastCell = tableView.cellForRow(at: self.lastSelect!)
                lastCell?.accessoryType = .none
            }
            
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
            self.lastSelect = indexPath
            self.cancelBtn.setTitle("完成", for: .normal)
            cancelBtn.setTitleColor(kBlueColor, for: .normal)
//            if self.overTimeDelegate != nil{
                self.overTimeModel = self.dataArray[indexPath.row]
//            }
//
            

            
        }else if self.toType == .fromTurnSomeOne{
            self.loadingPlay()
            self.transferApprove(turnId: model.userId)
        } else{
            let vc = CQWorkInstrumentPersonInfoVC.init()
            vc.userId = model.userId
            vc.chatName = model.realName
            vc.userModel = model
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 33)))
        view.backgroundColor = UIColor.white
        let lab = UILabel.init(frame: CGRect.init(x: AutoGetWidth(width: 15), y: AutoGetHeight(height: 19), width: kWidth - AutoGetWidth(width: 30), height: AutoGetHeight(height: 14)))
        lab.text = "搜索结果"
        lab.textAlignment = .left
        lab.textColor = UIColor.init(red: 0.5961, green: 0.5961, blue: 0.5961, alpha: 1)
        lab.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(lab)
        return view
    }
}



extension CQAddressSearchVC:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoGetHeight(height: 55)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AutoGetHeight(height: 33)
    }
    
}


extension CQAddressSearchVC:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.loadDatas(keyWord: searchBar.text!)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print()
       // if !(searchText.isEmpty){
        
            self.loadDatas(keyWord: searchText)
       // }
    }
    
    
}

extension CQAddressSearchVC:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.searchBar.placeholder = ""
        self.cancelBtn.setTitle("取消", for: .normal)
        let search = textField as! CQSearchBar
        search.searchbut?.isHidden = true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchBar.placeholder = " 搜索姓名/手机号"
        self.withOutResultView.isHidden = true
        self.table.isHidden = true
        self.cancelBtn.setTitle("取消", for: .normal)
//        let search = textField as! CQSearchBar
//        search.searchbut?.isHidden = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !(textField.text?.isEmpty)! {
            self.loadSearchList(keyWord: textField.text!)
           // let search = textField as! CQSearchBar
          //  search.searchbut?.isHidden =
        }
        
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text)
    }
    

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          print(textField.text)
//        print(string)
        return true
    }
    
    @objc func textFieldEditChanged(obj:Notification)  {
        
    }
    
}

extension CQAddressSearchVC:cellSelectDelegate{
    func pushToTable(index: IndexPath) {
        let model = self.dataArray[index.row]
        let cell = self.table.cellForRow(at: index)
        if !(cell as! CQAdressBookCell).selectStatus! {
            self.hasSelectModelArr.append(model)
        }else{
            for i in 0..<self.hasSelectModelArr.count{
                let hModel = self.hasSelectModelArr[i]
                if hModel.userId == model.userId{
                    self.hasSelectModelArr.remove(at: i)
                    break
                }
            }
        }
        let num = index.row
        let sec = index.row + 1
        let selectStaues = self.selectArr[index.row]
        self.selectArr.replaceSubrange(Range(num ..< sec), with: [!selectStaues])
        self.table.reloadData()
    }
}

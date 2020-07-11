//
//  QRAddressSearchVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/10/26.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRAddressSearchVC: SuperVC {
    
    var hasSelectModelArr = [CQDepartMentUserListModel]()//选中结果
    var dataArray = [CQDepartMentUserListModel]()//搜索结果
    var selectArr = [Bool]()//选中与否数组
    var groupId = ""
    var remark = ""
    var businessApplyId = ""
    var toType:ToAddressBookType?
    
    lazy var searchView: UIView = {
        let searchView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: CGFloat(SafeAreaTopHeight)))
       // searchView.backgroundColor = UIColor.white
        searchView.backgroundColor = kProjectBgColor
        let lineView = UIView.init(frame: CGRect.init(x: 0, y: CGFloat(SafeAreaTopHeight) - 0.5, width: kWidth, height: 0.5))
        lineView.backgroundColor = UIColor.init(red: 0.9529, green: 0.9529, blue: 0.9529, alpha: 1)
        searchView.addSubview(lineView)
        searchView.layer.borderColor = kLineColor.cgColor
        searchView.layer.borderWidth = 0.5
        return searchView
    }()
    
//    lazy var searchBar: CQSearchBar = {
//        let searchBar = CQSearchBar.init(frame: CGRect.init(x: AutoGetWidth(width: 15), y: CGFloat(SafeAreaStateTopHeight) + 7, width: kWidth - AutoGetWidth(width: 75), height: 30))
//        searchBar.delegate = self
//        searchBar.returnKeyType = UIReturnKeyType.search
//        return searchBar
//    }()
//
//    lazy var cancelBtn: UIButton = {
//        let cancelBtn = UIButton.init(type: .custom)
//        cancelBtn.frame = CGRect.init(x: kWidth - AutoGetWidth(width: 60), y: CGFloat(SafeAreaStateTopHeight) + 7, width: AutoGetWidth(width: 55), height: 30)
//        cancelBtn.setTitle("取消", for: .normal)
//        cancelBtn.setTitleColor(UIColor.gray, for: .normal)
//        cancelBtn.addTarget(self, action: #selector(backToSuperView), for: .touchUpInside)
//        cancelBtn.titleLabel?.textAlignment = .right
//        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        return cancelBtn
//    }()
//
    
    
    lazy var mysearchBar : UISearchBar = {
        let serchbar = UISearchBar(frame:  CGRect(x:  0, y: SafeAreaTopHeight-44, width: kWidth - AutoGetWidth(width: 60), height:  44))
        serchbar.backgroundColor = kProjectBgColor
        serchbar.placeholder = "  搜索部门/姓名/手机"
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
        cancelBtn.backgroundColor = kProjectBgColor
        cancelBtn.titleLabel?.textAlignment = .right
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return cancelBtn
    }()
    
    
    
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.keyboardDismissMode = UITableView.KeyboardDismissMode.onDrag
        table.register(QRAddressBookCell.self, forCellReuseIdentifier: "QRAddressBookSingleCellId")
        table.register(QRAddressBookCell.self, forCellReuseIdentifier: "QRAddressBookCellId")
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
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

        self.view.backgroundColor = kProjectBgColor
        
        self.searchView.addSubview(self.mysearchBar)
        //self.searchView.addSubview(self.searchBar)
        self.searchView.addSubview(self.cancelBtn)
        //self.mysearchBar.becomeFirstResponder()
        
        
        self.view.addSubview(self.table)
      
        self.table.isHidden = true
        self.view.addSubview(self.withOutResultView)
        self.withOutResultView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchView.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.view.addSubview(self.searchView)
    }
    
    override func backToSuperView()  {
        if self.toType == .fromGroupChat && self.cancelBtn.titleLabel?.text == "完成"{

            
        }else if self.toType == .fromGroupChat && self.cancelBtn.titleLabel?.text == "完成"{
            
        }else if self.toType == .fromCreateSchedule && self.cancelBtn.titleLabel?.text == "完成"{
            //发送通知
            let NotifMycation = NSNotification.Name(rawValue:"refreshCreateScheduleCell")
            //这个方法可以传一个值
            NotificationCenter.default.post(name: NotifMycation, object: self.hasSelectModelArr)
          
            for vc in (self.navigationController?.viewControllers)! {
                if vc is CQCreateScheduleVC {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }else if self.toType == .fromCreatMeeting && self.cancelBtn.titleLabel?.text == "完成"{
    
            //发送通知
            let NotifMycation = NSNotification.Name(rawValue:"refreshCreateMeetingCell")
            //这个方法可以传一个值
            NotificationCenter.default.post(name: NotifMycation, object: self.hasSelectModelArr)
        
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
        
            for vc in (self.navigationController?.viewControllers)! {
                if vc is CQCreateTaskVC {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }else if self.toType == .fromTogetherPerson && self.cancelBtn.titleLabel?.text == "完成"{
            
            //发送通知
            let NotifMycation = NSNotification.Name(rawValue:"together")
            
            //这个方法可以传一个值
            NotificationCenter.default.post(name: NotifMycation, object: self.hasSelectModelArr)
            
            for vc in (self.navigationController?.viewControllers)! {
                if vc is NCQApprovelVC {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }else if self.toType == .fromAddGroupMember && self.cancelBtn.titleLabel?.text == "完成"{
            //新建日程:参与人员
            let NotifMycation = NSNotification.Name(rawValue:"FAddTracker")
            
            //这个方法可以传一个值
            NotificationCenter.default.post(name: NotifMycation, object: self.hasSelectModelArr)
            
            for vc in (self.navigationController?.viewControllers)! {
                if vc is CQCreateScheduleVC || vc is CQCreateTaskVC{
                    self.navigationController?.popToViewController(vc, animated: true)
                }
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
                if vc is NCQApprovelVC {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }else if self.toType == .fromGenJin && self.cancelBtn.titleLabel?.text == "完成"{
            
            //发送通知
            let NotifMycation = NSNotification.Name(rawValue:"AddTracker")
            
            //这个方法可以传一个值
            NotificationCenter.default.post(name: NotifMycation, object: self.hasSelectModelArr)
            
            for vc in (self.navigationController?.viewControllers)! {
                if vc is QRAddTrackBusinessVC || vc is QRAddTrackPersonVC || vc is QRAddBusinessVC || vc is CQAddCustomerVC || vc is CQWriteReportVC || vc is NCQApprovelVC{
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }else if self.toType == .fromKeHuGenJin && self.cancelBtn.titleLabel?.text == "完成"{
            
            //发送通知
            let NotifMycation = NSNotification.Name(rawValue:"AddTracker")
            
            //这个方法可以传一个值
            NotificationCenter.default.post(name: NotifMycation, object: self.hasSelectModelArr)
            
            for vc in (self.navigationController?.viewControllers)! {
                if vc is QRAddTrackBusinessVC || vc is QRAddTrackPersonVC || vc is QRAddBusinessVC || vc is CQAddCustomerVC || vc is QRScheduleVC  {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    

}


extension QRAddressSearchVC{
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
                                self.selectArr.replaceSubrange(Range(num ..< sec), with: [true])
                            }
                        }
                    }
                }
                self.cancelBtn.setTitle("完成", for: .normal)
                
                //刷新表格
               // self.table.mj_header.endRefreshing()
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
            
                //self.table.mj_header.endRefreshing()
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
    
    
    func singleSelectJump(mod:CQDepartMentUserListModel){
        print(mod.realName)
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
                    let vc = QRSworkmateScheduleVC()
                    vc.isFromeAddressbook = true
                    vc.title = mod.realName + "的日程"
                    vc.curUserId = mod.userId
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if vc is NCQApproelDetailVC  {
                    self.loadingPlay()
                    self.transferApprove(turnId: mod.userId)
                }
                
            }
        }
    }
    
    
}



extension QRAddressSearchVC : UITableViewDelegate{
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        self.mysearchBar.resignFirstResponder()
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.toType == .fromContact{
            //单选跳转
            let cell = tableView.dequeueReusableCell(withIdentifier: "QRAddressBookSingleCellId") as! QRAddressBookCell
            cell.model = self.dataArray[indexPath.row]
            return cell
        }else if self.toType == .normal{
            let cell = tableView.dequeueReusableCell(withIdentifier: "QRAddressBookSingleCellId") as! QRAddressBookCell
            cell.model = self.dataArray[indexPath.row]
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "QRAddressBookCellId") as! QRAddressBookCell
            cell.model = self.dataArray[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        
        if self.toType == .fromContact{
            //单选跳转
            singleSelectJump(mod: self.dataArray[indexPath.row])
        }else if self.toType == .normal{
            let vc = CQWorkInstrumentPersonInfoVC.init()
            let model = self.dataArray[indexPath.row]
            vc.userId = model.userId
            vc.chatName = model.realName
            vc.userModel = model
            //vc.isFromAdress = true
           
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            //进入详情
            let cell = tableView.cellForRow(at: indexPath) as! QRAddressBookCell
            cell.selectBtn.isHidden = false
            let model = self.dataArray[indexPath.row]
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


extension QRAddressSearchVC : UITableViewDataSource{
    
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

//extension QRAddressSearchVC:UITextFieldDelegate {
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.searchBar.placeholder = ""
//        self.cancelBtn.setTitle("取消", for: .normal)
//        let search = textField as! CQSearchBar
//        search.searchbut?.isHidden = true
//    }
//    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        searchBar.placeholder = " 搜索部门/姓名/手机"
//        self.withOutResultView.isHidden = true
//        self.table.isHidden = true
//        self.cancelBtn.setTitle("取消", for: .normal)
//        //        let search = textField as! CQSearchBar
//        //        search.searchbut?.isHidden = false
//        return true
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if !(textField.text?.isEmpty)! {
//            self.loadSearchList(keyWord: textField.text!)
//        }
//        textField.resignFirstResponder()
//        return true
//    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
////        if !(textField.text?.isEmpty)! {
////            self.loadSearchList(keyWord: textField.text!)
////        }
//    }
//    @objc func textFieldEditChanged(obj:Notification)  {

//    }
//
//}

extension QRAddressSearchVC:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.loadDatas(keyWord: searchBar.text!)
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print()
        // if !(searchText.isEmpty){
        // self.loadSearchList(keyWord: searchText)
        self.loadDatas(keyWord: searchText)
        // }
    }
    
    
}

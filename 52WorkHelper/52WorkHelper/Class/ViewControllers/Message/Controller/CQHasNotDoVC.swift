//
//  CQHasNotDoVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/7/23.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQHasNotDoVC: SuperVC {
    var redImg :UIImageView?
    var redBut : UIButton?
    var dataArray = [CQHasNotHandleModel]()
    var pageNum = 1
    var searchmode = ""
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - 49 - AutoGetHeight(height: 289) - AutoGetHeight(height: 49)), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        //        table.backgroundColor = kProjectBgColor
        table.delegate = self
        table.dataSource = self
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
//        table.canCancelContentTouches = true
//        table.delaysContentTouches = true
     //   table.isScrollEnabled = false
        return table
    }()
    
    lazy var withOutDataView: UIView = {
        let withOutDataView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight))
        return withOutDataView
    }()
    
    lazy var withOutImageV: UIView = {
        let withOutImageV = UIImageView.init(frame: CGRect.init(x: (kWidth - AutoGetWidth(width: 96))/2, y: AutoGetHeight(height: 43), width: AutoGetWidth(width: 96), height: AutoGetHeight(height: 96.5)))
        withOutImageV.image = UIImage.init(named: "CQIndexWithOutData")
        return withOutImageV
    }()
    
    lazy var companyLab: UILabel = {
        let companyLab = UILabel.init(frame: CGRect.init(x: 0, y: self.withOutImageV.bottom + AutoGetHeight(height: 16), width: kWidth, height: AutoGetHeight(height: 15)))
        companyLab.font = kFontSize15
        companyLab.text = "四美达语录"
        companyLab.textColor = UIColor.colorWithHexString(hex: "#58c3ff")
        companyLab.textAlignment = .center
        return companyLab
    }()
    
    lazy var contentLab: UILabel = {
        let contentLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.companyLab.bottom + AutoGetHeight(height: 16), width: kWidth - 2 * kLeftDis, height: AutoGetHeight(height: 45)))
        contentLab.font = kFontSize18
        contentLab.text = ""
        contentLab.numberOfLines = 0
        contentLab.textColor = UIColor.colorWithHexString(hex: "#3abcff")
        contentLab.textAlignment = .center
        return contentLab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.loadingPlay()
        self.setUpRefresh()
        self.attendanceWordRequest()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.table)
        self.table.register(CQHasNotDoCell.self, forCellReuseIdentifier: "CQHasNotDoCellId")
        
        self.table.addSubview(self.withOutDataView)
        self.withOutDataView.addSubview(self.withOutImageV)
        self.withOutDataView.addSubview(self.companyLab)
        self.withOutDataView.addSubview(self.contentLab)
        self.withOutDataView.isHidden = true
        
//        NotificationCenter.default.addObserver(self, selector: #selector(refreshSubView(notification:)), name: NSNotification.Name.init("refreshIndexRowData"), object: nil)
        
      //  NotificationCenter.default.addObserver(self, selector: #selector(refreshSubView(notification:)), name: NSNotification.Name.init("refreshAllData"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadDatas(moreData: false)
    }
//    @objc func refreshSubView(notification:Notification)  {
//        self.setUpRefresh()
//    }
}

extension CQHasNotDoVC{
     func setUpRefresh() {
        // MARK:header
        let STHeader = CQRefreshHeader {[unowned self] in
            self.loadDatas(moreData: false)
        }
        // MARK:footer
        let STFooter = CQRefreshFooter {[unowned self] in
            self.loadDatas(moreData: true)
        }
        self.table.mj_header = STHeader
        self.table.mj_footer = STFooter
        self.table.mj_header.beginRefreshing()
    }
    // MARK:request
     func loadDatas(moreData: Bool) {
        if moreData {
            pageNum += 1
        } else {
            pageNum = 1
        }
        let userID = STUserTool.account().userID
//        if self.searchmode == "2"{
//            pageNum = 200
//        }
        STNetworkTools.requestData(URLString:"\(baseUrl)/mailList/getUntreatedWorkByPage" ,
            type: .get,
            param: ["userId":userID,
                    "currentPage":pageNum,
                    "rows":"10",
                    "searchmode":self.searchmode],
            successCallBack: { (result) in
                
                var tempArray = [CQHasNotHandleModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQHasNotHandleModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                
                
                if moreData {
                    self.dataArray.append(contentsOf: tempArray)
                } else {
                    self.dataArray = tempArray
                }
                
                //刷新表格
                self.table.mj_header.endRefreshing()
                self.table.mj_footer.endRefreshing()
                self.table.reloadData()
               //取消显示红点
//                var hid = true
//                for xx in self.dataArray{
//                    if xx.readSign == false{
//                        hid = false
//                    }
//                }
//                 self.redImg?.isHidden = hid
                self.loadUnReadCount()
                //分页控制
                let total = result["total"].intValue
                if self.dataArray.count == total {
                    self.table.mj_footer.endRefreshingWithNoMoreData()
//                    self.table.mj_footer.isHidden = true
                }else {
                    self.table.mj_footer.resetNoMoreData()
//                    self.table.mj_footer.isHidden = false
                }
                
                if self.dataArray.count < 1 {
                    self.withOutDataView.isHidden = false
                }else{
                    self.withOutDataView.isHidden = true
                }
                
              //  self.loadingSuccess()
                
        }) { (error) in
           // self.loadingSuccess()
            self.table.reloadData()
            self.table.mj_header.endRefreshing()
            self.table.mj_footer.endRefreshing()
        }
    }
    func loadUnReadCount(){
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/mailList/getUntreatedWorkByUnReadNum" ,
            type: .get,
            param: ["userId":userID],
            successCallBack: { (result) in
                if self.searchmode == "2"{
                    let num = result["data"]["unReadNum1"].intValue
                    if num>0{
                        self.redBut?.showBadge(with: WBadgeStyle.number, value: num, animationType: WBadgeAnimType.none)
                    }else{
                        self.redBut?.clearBadge()
                    }
                    
                    
                }else if self.searchmode == "3"{
                    let num = result["data"]["unReadNum2"].intValue
                    if num>0{
                        self.redBut?.showBadge(with: WBadgeStyle.number, value: num, animationType: WBadgeAnimType.none)
                    }else{
                        self.redBut?.clearBadge()
                    }
                }
        }) { (error) in
            
        }
    }
    
    //未处理工作-设置已读
    func setUntreatedWorkReadSignRequest(untreatedWorkId:String)  {
        STNetworkTools.requestData(URLString:"\(baseUrl)/mailList/setUntreatedWorkReadSign" ,
            type: .post,
            param: ["untreatedWorkId":untreatedWorkId],
            successCallBack: { (result) in
                self.loadDatas(moreData: false)
        }) { (error) in
            
        }
    }
    
    //签到语录
    func attendanceWordRequest() {
        let word = UserDefaults.standard.object(forKey: "attendanceWord")
        let userID = STUserTool.account().userID
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/attendance/getWord" ,
            type: .get,
            param: ["emyeId":userID,
                    "word":word ?? "你说行，我说好"],
            successCallBack: { (result) in
                
                let signName = result["data"]["word"].stringValue
                self.contentLab.text = signName
                UserDefaults.standard.set(signName, forKey: "attendanceWord")
        }) { (error) in
            
        }
    }
    
    func loadDeleteDaiBan(id:String) {
        STNetworkTools.requestData(URLString:"\(baseUrl)/mailList/deleteAllUntreatedWork" ,
            type: .post,
            param: ["untreatedWorkIds[]":id],
            successCallBack: { (result) in
             
                
        }) { (error) in
            self.loadDeleteDaiBan(id: id)
        }
    }
    
    
}



extension CQHasNotDoVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return UITableViewCellEditingStyle.delete
//    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQHasNotDoCellId") as! CQHasNotDoCell
        cell.model = self.dataArray[indexPath.row]
        
        let model = self.dataArray[indexPath.row]
        if model.readSign {
            cell.nameLab.textColor = kLyGrayColor 
            
        }else{
            cell.nameLab.textColor = UIColor.black
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = self.dataArray[indexPath.row]
        if !model.readSign {
           // self.loadingPlay()
            self.setUntreatedWorkReadSignRequest(untreatedWorkId: model.untreatedWorkId)
        }
        
        if "1" == model.workType { //审批
            let vc = NCQApproelDetailVC()
            vc.title = model.workName
            vc.isFromWaitApprovel = true
            vc.businessApplyId = model.workId
            self.navigationController?.pushViewController(vc, animated: true)
        }else if "2" == model.workType { //考勤
//            let vc = CQCheckWorkAttendanceVC()
//            vc.dateStr = model.publishTime
            let vc = QRSignVC.init()
//            vc.isFromStatics = true
//            vc.dateStr = model.publishTime
            self.navigationController?.pushViewController(vc, animated: true)
        }else if "3" == model.workType { //抄送
            let vc = NCQApproelDetailVC()
            vc.title = model.workName
             vc.titleStr = "审批流程"
            vc.isFromCopyToMe = true
            vc.businessApplyId = model.workId
            self.navigationController?.pushViewController(vc, animated: true)
        }else if "4" == model.workType || "6" == model.workType{//日程 //会议
            let vc = CQScheduleDetailVC()
            vc.schedulePlanId = model.workId
            self.navigationController?.pushViewController(vc, animated: true)
        }else if "5" == model.workType { //任务
            let vc = CQTaskDetailVC()
            vc.personnelTaskId = model.workId
            self.navigationController?.pushViewController(vc, animated: true)
        }else if "0" == model.workType { //我的申请
            let vc = NCQApproelDetailVC()
            vc.isFromMeSubmit = true
            vc.titleStr = model.workName
            vc.businessApplyId = model.workId
            self.navigationController?.pushViewController(vc, animated: true)
        }else if  "8" == model.workType{
             //点赞
            
            let vc = QRWorkmateCircleVC()
            self.navigationController?.pushViewController(vc, animated: true)
            loadDeleteDaiBan(id:model.untreatedWorkId)
        }else if "9" == model.workType{
            //生日祝福
            let vc = QRWorkmateCircleVC()
            self.navigationController?.pushViewController(vc, animated: true)
            loadDeleteDaiBan(id:model.untreatedWorkId)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return AutoGetHeight(height: 64)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
}
//extension CQHasNotDoVC:UIScrollViewDelegate{
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("yyyyyyyyyy"+"\(scrollView.contentOffset.y)")
////        if scrollView.contentOffset.y<0{
////            table.isScrollEnabled = false
////        }else{
////            table.isScrollEnabled = true
////        }
//    }
//}

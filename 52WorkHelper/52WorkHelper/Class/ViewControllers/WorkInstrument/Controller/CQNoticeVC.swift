//
//  CQNoticeVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/4.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQNoticeVC: SuperVC {
    var  redBut : UIButton?
    
    var dataArray = [CQNoticeModel]()
    
    var pageNum = 1
    
    var isFromApp = false
    var isFromeIndex = false
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.backgroundColor = kProjectBgColor
        table.delegate = self
        table.dataSource = self
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isFromeIndex {
         table.frame  = CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - 49 - AutoGetHeight(height: 289) - AutoGetHeight(height: 49))
        }
        setUpRefresh()
        
        self.title = "通知公告"
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.register(CQNoticeCell.self, forCellReuseIdentifier: "CQNoticeCellId")
   
    
         NotificationCenter.default.addObserver(self, selector: #selector(popBirthDayMainPageList(notification:)), name: NSNotification.Name(rawValue: "popBirthDayMainPageList"), object: nil)
    }
     @objc func popBirthDayMainPageList(notification:Notification) {
         
        self.navigationController?.popToRootViewController(animated: true)
        
        }
    

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isFromApp {
            self.navigationItem.leftBarButtonItem = self.barBackButton()
        }
    }
}

extension CQNoticeVC{
    fileprivate func setUpRefresh() {
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
    //    SVProgressHUD.show()
        if moreData {
            pageNum += 1
        } else {
            pageNum = 1
        }
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/notice/list" ,
            type: .get,
            param: ["emyeId":userID,
                    "currentPage":pageNum,
                    "pageSize":"10"],
            successCallBack: { (result) in
                var tempArray = [CQNoticeModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQNoticeModel(jsonData: modalJson) else {
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
                self.loadUnReadCount()
                //分页控制
                let total = result["total"].intValue
                if self.dataArray.count == total {
                    self.table.mj_footer.endRefreshingWithNoMoreData()
                }else {
                    self.table.mj_footer.resetNoMoreData()
                }
              //  SVProgressHUD.dismiss()
                
        }) { (error) in
            self.table.reloadData()
            
            self.table.mj_header.endRefreshing()
            self.table.mj_footer.endRefreshing()
          //  SVProgressHUD.dismiss()
        }
    }
    
    
    
    func loadUnReadCount(){
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/notice/getNoticeReadInfo" ,
            type: .get,
            param: ["userId":userID],
            successCallBack: { (result) in
            
                let num = result["data"]["unReadNum"].intValue
                if num>0{
                    self.redBut?.showBadge(with: WBadgeStyle.number, value: num, animationType: WBadgeAnimType.none)
                    
                }else{
                    self.redBut?.clearBadge()
                }
               
        }) { (error) in
            
        }
    }
    
    //未处理工作-设置已读
    func setUntreatedWorkReadSignRequest(untreatedWorkId:String)  {
      let userId = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/notice/setNoticeReadSign" ,
            type: .post,
            param: ["entityId":untreatedWorkId,"userId":userId],
            successCallBack: { (result) in
                self.loadDatas(moreData: false)
        }) { (error) in
            
        }
    }
}


extension CQNoticeVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQNoticeCellId") as! CQNoticeCell
        let mod = self.dataArray[indexPath.row]
        cell.model = mod
        if mod.readSign! {
            cell.nameLab.textColor = kLyGrayColor
            cell.detailLab.textColor = kLyGrayColor
            cell.dateLab.textColor = kLyGrayColor

        }else{
            cell.nameLab.textColor = UIColor.black
            cell.detailLab.textColor = UIColor.black
            cell.dateLab.textColor = UIColor.black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        let model:CQNoticeModel = self.dataArray[indexPath.row]
        //设置已读
        self.setUntreatedWorkReadSignRequest(untreatedWorkId: model.entityId)
      
        if model.isBirthwish{
            let vc = QRBirthDayParterVC()
            vc.isMainpage = true
            vc.date = model.createDate
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = CQWebVC.init()
            vc.titleStr = "详情"
            vc.urlStr = "\(baseUrl)/notice/info" + "?entityId=" + model.entityId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return AutoGetHeight(height: 102)
    }
  
}

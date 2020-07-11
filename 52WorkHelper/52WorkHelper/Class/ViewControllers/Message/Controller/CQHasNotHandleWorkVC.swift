//
//  CQHasNotHandleWorkVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/6.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQHasNotHandleWorkVC: SuperVC {
    
    var dataArray = [CQHasNotHandleModel]()
    var pageNum = 1
    
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        //        table.backgroundColor = kProjectBgColor
        table.delegate = self
        table.dataSource = self
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpRefresh()
        
        self.title = "未处理工作"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.table)
        self.table.register(CQHasNotHandleWorkCell.self, forCellReuseIdentifier: "CQHasNotHandleWorkCellId")
        
    }
}

extension CQHasNotHandleWorkVC{
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
    fileprivate func loadDatas(moreData: Bool) {
        if moreData {
            pageNum += 1
        } else {
            pageNum = 1
        }
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/mailList/getUntreatedWorkByPage" ,
            type: .get,
            param: ["userId":userID,
                    "currentPage":pageNum,
                    "rows":"10",
                    "keyWord":"",
                    "searchmode":"1"],
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
                
                //分页控制
                let total = result["total"].intValue
                if self.dataArray.count == total {
                    self.table.mj_footer.endRefreshingWithNoMoreData()
                }else {
                    self.table.mj_footer.resetNoMoreData()
                }
                
                
        }) { (error) in
            self.table.reloadData()
            
            self.table.mj_header.endRefreshing()
            self.table.mj_footer.endRefreshing()
        }
    }
    
    //未处理工作-设置已读
    func setUntreatedWorkReadSignRequest(untreatedWorkId:String)  {
        STNetworkTools.requestData(URLString:"\(baseUrl)/mailList/setUntreatedWorkReadSign" ,
            type: .post,
            param: ["untreatedWorkId":untreatedWorkId],
            successCallBack: { (result) in
                
        }) { (error) in
            
        }
    }
}



extension CQHasNotHandleWorkVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQHasNotHandleWorkCellId") as! CQHasNotHandleWorkCell
        cell.model = self.dataArray[indexPath.row]
        
        let model = self.dataArray[indexPath.row]
        if model.readSign {
            cell.nameLab.textColor = UIColor.black
            
        }else{
            cell.nameLab.textColor = kLyGrayColor
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataArray[indexPath.row]
        if !model.readSign {
            self.setUntreatedWorkReadSignRequest(untreatedWorkId: model.untreatedWorkId)
        }
        
        if "1" == model.workType {
            let vc = NCQApproelDetailVC()
            vc.isFromMeSubmit = true
            vc.businessApplyId = model.workId
            self.navigationController?.pushViewController(vc, animated: true)
        }else if "2" == model.workType {
//            let vc = CQCheckWorkAttendanceVC()
//            vc.dateStr = model.publishTime
            let vc = QRSignVC.init()
            vc.isFromStatics = true
            vc.dateStr = model.publishTime
            self.navigationController?.pushViewController(vc, animated: true)
        }else if "3" == model.workType {
            let vc = NCQApproelDetailVC()
            vc.title = model.workName
           
            vc.isFromCopyToMe = true
            vc.businessApplyId = model.workId
            self.navigationController?.pushViewController(vc, animated: true)
        }else if "4" == model.workType {
            let vc = CQScheduleDetailVC()
            vc.schedulePlanId = model.workId
            self.navigationController?.pushViewController(vc, animated: true)
        }else if "5" == model.workType {
            let vc = CQTaskDetailVC()
            vc.personnelTaskId = model.workId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return AutoGetHeight(height: 64)
    }
    
  
}

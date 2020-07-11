//
//  CQMyRecieveTaskVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/29.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQMyRecieveTaskVC: SuperVC {

    var pageNum = 1
    
    var taskDataArray = [CQTaskModel]()
    
    lazy var taskTable: CQTaskTable = {
        let taskTable = CQTaskTable.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight ), style: UITableViewStyle.plain)
        taskTable.isMePublish = true
        taskTable.selectDelegate = self
        return taskTable
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpRefresh()
        self.title = "我发布的任务"
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.taskTable)
    }
}

extension CQMyRecieveTaskVC{
    fileprivate func setUpRefresh() {
        // MARK:header
        let STHeader = CQRefreshHeader {[unowned self] in
            self.loadTaskDatas(moreData: false)
        }
        // MARK:footer
        let STFooter = CQRefreshFooter {[unowned self] in
            self.loadTaskDatas(moreData: true)
        }
        self.taskTable.mj_header = STHeader
        self.taskTable.mj_footer = STFooter
        self.taskTable.mj_header.beginRefreshing()
    }
    // MARK:request
    fileprivate func loadTaskDatas(moreData: Bool) {
        if moreData {
            pageNum += 1
        } else {
            pageNum = 1
        }
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/personnelTask/getPersonnelTaskByPage" ,
            type: .get,
            param: ["userId":userID,
                    "currentPage":pageNum,
                    "rows":"10",
                    "searchmode":"1"],
            successCallBack: { (result) in
                var tempArray = [CQTaskModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQTaskModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                
                if moreData {
                    self.taskDataArray.append(contentsOf: tempArray)
                } else {
                    self.taskDataArray = tempArray
                }
                //刷新表格
                self.taskTable.mj_header.endRefreshing()
                self.taskTable.mj_footer.endRefreshing()
                
                self.taskTable.dataArray = self.taskDataArray
                self.taskTable.reloadData()
                //分页控制
                let total = result["total"].intValue
                if self.taskDataArray.count == total {
                    self.taskTable.mj_footer.endRefreshingWithNoMoreData()
                }else {
                    self.taskTable.mj_footer.resetNoMoreData()
                }
                
                
        }) { (error) in
            self.taskTable.reloadData()
            
            self.taskTable.mj_header.endRefreshing()
            self.taskTable.mj_footer.endRefreshing()
        }
    }
}

extension CQMyRecieveTaskVC:CQTaskSelectDelegate{
    func pushToDetailVC(personnelTaskId: String) {
        let vc = CQTaskDetailVC()
        vc.personnelTaskId = personnelTaskId
        self.navigationController?.pushViewController(vc, animated: true)
    } 
}

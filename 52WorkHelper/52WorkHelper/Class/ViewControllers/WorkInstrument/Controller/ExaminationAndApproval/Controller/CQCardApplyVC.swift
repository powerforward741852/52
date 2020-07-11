//
//  CQCardApplyVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/25.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQCardApplyVC: SuperVC {

    var dataArray = [CQCardApplyListModel]()
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
        
        self.title = "补卡申请"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.table)
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "CQCardApplyCellId")
    }

}

extension CQCardApplyVC{
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
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getMyAllModifyApplys" ,
            type: .get,
            param: ["emyeId":userID,
                    "currentPage":pageNum,
                    "pageSize":"10"],
            successCallBack: { (result) in
                var tempArray = [CQCardApplyListModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQCardApplyListModel(jsonData: modalJson) else {
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
}



extension CQCardApplyVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = nil
        if cell == nil{
            cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "CQCardApplyCellId")
        }
        let model = self.dataArray[indexPath.row]
        
        cell?.accessoryType = .disclosureIndicator
        cell?.textLabel?.text = model.updateDate
        cell?.textLabel?.textAlignment = .left
        cell?.textLabel?.textColor = UIColor.black
        cell?.textLabel?.font = kFontSize15
        
        cell?.detailTextLabel?.text = model.statusDesc
        cell?.detailTextLabel?.textAlignment = .right
        if model.statusDesc == "审批中" {
            cell?.detailTextLabel?.textColor = UIColor.colorWithHexString(hex: "ff9000")
        }
        cell?.detailTextLabel?.textColor = kLyGrayColor
        cell?.detailTextLabel?.font = kFontSize15
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataArray[indexPath.row]
        let vc = NCQApproelDetailVC()
        vc.isFromMeSubmit = true
        vc.businessApplyId = model.businessApplyId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return AutoGetHeight(height: 55)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    
}

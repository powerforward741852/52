//
//  CQChooseAttenceByDayVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/9/11.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQChooseAttenceByDayVC: SuperVC {

    var dataArray = [CQDepartMentAttenceModel]()
    var pageNum = 1
    var departmentId = ""
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.backgroundColor = kProjectBgColor
        table.delegate = self
        table.dataSource = self
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.rowHeight = AutoGetHeight(height: 55)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "部门考勤"
        self.setUpRefresh()
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "CQChooseAttendanceId")
    }
}

extension CQChooseAttenceByDayVC{
    
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
        STNetworkTools.requestData(URLString:"\(baseUrl)/attendance/getDayOfDepAttendanceByPage" ,
            type: .get,
            param: ["emyeId":userID,
                    "currentPage":pageNum,
                    "rows":"10",
                    "departmentId":self.departmentId],
            successCallBack: { (result) in
                var tempArray = [CQDepartMentAttenceModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQDepartMentAttenceModel(jsonData: modalJson) else {
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



extension CQChooseAttenceByDayVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = nil
        if cell == nil{
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "CQChooseAttendanceId")
        }
        let model = self.dataArray[indexPath.row]
        cell?.accessoryType = .disclosureIndicator
        cell?.textLabel?.text = model.dayTime + "  " + model.weekOfDate
        cell?.textLabel?.font = kFontSize15
        cell?.textLabel?.textColor = UIColor.black
        cell?.textLabel?.textAlignment = .left
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = CQAttendancePersonVC()
        vc.departmentId = self.departmentId
        vc.statisticalDate = self.dataArray[indexPath.row].dayTime
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return AutoGetHeight(height: 55)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}

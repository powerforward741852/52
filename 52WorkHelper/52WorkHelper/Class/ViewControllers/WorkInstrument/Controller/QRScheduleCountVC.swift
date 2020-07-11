//
//  QRScheduleCountVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/4/24.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRScheduleCountVC: SuperVC {
     var pageNum = 1
     var startDate = ""
     var endDate = ""
     var searchUserId = ""
    //数据源
    var dataArray = [CQMyCustomerModel]()
    
    
      lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: SafeAreaTopHeight+10, width: kWidth, height: kHeight-SafeAreaTopHeight-10 ), style: UITableViewStyle.plain)
        if #available(iOS 11.0, *) {
            //            table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
            //            table.contentInset = UIEdgeInsetsMake(CGFloat(SafeAreaTopHeight), 0, CGFloat(SafeAreaBottomHeight), 0);
            //            table.scrollIndicatorInsets = table.contentInset;
        } else {
            //低于 iOS 9.0
            self.automaticallyAdjustsScrollViewInsets = false
        }
       // table.register(QRTongjiListCell.self, forCellReuseIdentifier: "tongjilist")
        table.register(UINib(nibName: "QRTongjiListCell", bundle: nil), forCellReuseIdentifier: "tongjilist")
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.rowHeight = 65
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = kProjectBgColor
        title = "日程列表"
        view.addSubview(table)
        setUpRefresh()
    }
    
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
        STNetworkTools.requestData(URLString:"\(baseUrl)/schedule/getCountScheduleList" ,
            type: .get,
            param: ["currentPage":pageNum,
                    "endDate":endDate,
                    "startDate":startDate,
                    "rows":10,
                    "searchUserId":searchUserId,
                    "userId":userID],
            successCallBack: { (result) in
                var tempArray = [CQMyCustomerModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQMyCustomerModel(jsonData: modalJson) else {
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

extension QRScheduleCountVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = CQScheduleDetailVC()
        let model = dataArray[indexPath.row]
        vc.schedulePlanId = model.entityId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tongjilist", for: indexPath) as! QRTongjiListCell
       cell.model = dataArray[indexPath.row]
        
       // cell.rootVc = self
       //cell.index = indexPath
//        cell.clickClosure = { path in
//            tableView.reloadRows(at: [path], with: UITableViewRowAnimation.none)
//        }
        
        return cell
    }
    
}

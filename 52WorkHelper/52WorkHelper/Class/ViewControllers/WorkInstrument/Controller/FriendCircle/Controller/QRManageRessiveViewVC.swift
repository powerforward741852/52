//
//  QRManageRessiveViewVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/21.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRManageRessiveViewVC: SuperVC {
    var dataArray = [QRWorkMateCircleModel]()
    var pageNum = 1
    var isfromResive = false
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: SafeAreaTopHeight, width: kWidth, height: kHeight-SafeAreaTopHeight ), style: UITableViewStyle.plain)
        if #available(iOS 11.0, *) {
            //            table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
            //            table.contentInset = UIEdgeInsetsMake(CGFloat(SafeAreaTopHeight), 0, CGFloat(SafeAreaBottomHeight), 0);
            //            table.scrollIndicatorInsets = table.contentInset;
        } else {
            //低于 iOS 9.0
            self.automaticallyAdjustsScrollViewInsets = false
        }
        table.register(QRFriendCircleCell.self, forCellReuseIdentifier: "resivefriendcellid")
        table.register(QRFriendCircleCell.self, forCellReuseIdentifier: "postfriendcellid")
        
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.estimatedRowHeight = 107
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(table)
       // self.setUpRefresh()
    }
    
    func setUpRefresh()  {
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
    
    func loadDatas(moreData:Bool) {
        
        if moreData {
            pageNum += 1
        } else {
            pageNum = 1
        }
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/birth/getAllMonthgetAllOfMySendByUserId" ,
            type: .get,
            param: ["userId":userID,
                    "currentPage":pageNum,
                    "rows":"10"],
            successCallBack: { (result) in
                var tempArray = [QRWorkMateCircleModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = QRWorkMateCircleModel(jsonData: modalJson) else {
                        return
                    }
                    modal.page = result["page"].intValue
                    tempArray.append(modal)
                }
                
                if self.pageNum > 1 {
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
extension QRManageRessiveViewVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  5//dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isfromResive {
            let cell = tableView.dequeueReusableCell(withIdentifier: "resivefriendcellid", for: indexPath) as! QRFriendCircleCell
            // cell.model = dataArray[indexPath.row]
            //cell.rootVc = self
            cell.index = indexPath
            cell.clickClosure = { path in
                tableView.reloadRows(at: [path], with: UITableViewRowAnimation.none)
            }
             return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "postfriendcellid", for: indexPath) as! QRFriendCircleCell
            // cell.model = dataArray[indexPath.row]
            //cell.rootVc = self
            cell.index = indexPath
            cell.clickClosure = { path in
                tableView.reloadRows(at: [path], with: UITableViewRowAnimation.none)
            }
             return cell
        }
       
        
       
    }
    
}

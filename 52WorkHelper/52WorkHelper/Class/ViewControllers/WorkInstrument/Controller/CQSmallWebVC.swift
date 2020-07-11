//
//  CQSmallWebVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/4.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQSmallWebVC: SuperVC {
    var dataArray = [CQSmallWebModel]()
    var pageNum = 1
    var isFromSmallWeb = true
    var searchName = ""
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .none
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

        
        if self.isFromSmallWeb {
            self.title = "微网站"
            self.setUpRefresh(siteType: "1")
            self.table.register(CQSmallWebCell.self, forCellReuseIdentifier: "CQSmallWebCellId")
            self.table.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CQSmallFootView")
        }else{
           // self.title = "媒体报道"
            self.setUpRefresh(siteType: "2")
            self.table.register(CQNoticeCell.self, forCellReuseIdentifier: "CQNoticeCellId")
        }
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.table)
        
        
    }
}

extension CQSmallWebVC{
    fileprivate func setUpRefresh(siteType:String) {
        // MARK:header
        let STHeader = CQRefreshHeader {
            self.loadDatas(moreData: false,siteType:siteType)
        }
        // MARK:footer
        let STFooter = CQRefreshFooter {
            self.loadDatas(moreData: true,siteType:siteType)
        }
        self.table.mj_header = STHeader
        self.table.mj_footer = STFooter
        self.table.mj_header.beginRefreshing()
    }
    // MARK:request
//    fileprivate func loadDatas(moreData: Bool,siteType:String) {
//        if moreData {
//            pageNum += 1
//        } else {
//            pageNum = 1
//        }
//        let userID = STUserTool.account().userID
//        STNetworkTools.requestData(URLString:"\(baseUrl)/microWeb/list" ,
//            type: .get,
//            param: ["typeId":userID,
//                    "currentPage":pageNum,
//                    "pageSize":"10",
//                    "siteType":siteType,
//                    "searchName":self.searchName],
//            successCallBack: { (result) in
//                var tempArray = [CQSmallWebModel]()
//                for modalJson in result["data"].arrayValue {
//                    guard let modal = CQSmallWebModel(jsonData: modalJson) else {
//                        return
//                    }
//                    tempArray.append(modal)
//                }
//
//                if moreData {
//                    self.dataArray.append(contentsOf: tempArray)
//                } else {
//                    self.dataArray = tempArray
//                }
//                //刷新表格
//                self.table.mj_header.endRefreshing()
//                self.table.mj_footer.endRefreshing()
//                self.table.reloadData()
//
//                //分页控制
//                let total = result["total"].intValue
//                if self.dataArray.count == total {
//                    self.table.mj_footer.endRefreshingWithNoMoreData()
//                }else {
//                    self.table.mj_footer.resetNoMoreData()
//                }
//
//
//        }) { (error) in
//            self.table.reloadData()
//
//            self.table.mj_header.endRefreshing()
//            self.table.mj_footer.endRefreshing()
//        }
//    }

    
    
    // MARK:request
    fileprivate func loadDatas(moreData: Bool,siteType:String) {
        if moreData {
            pageNum += 1
        } else {
            pageNum = 1
        }
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/microWeb/list" ,
            type: .get,
            param: ["emyeId":userID,
                    "currentPage":pageNum,
                    "pageSize":"10",
                    "version":CQVersion,
                    "siteType":siteType],
            successCallBack: { (result) in
                var tempArray = [CQSmallWebModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQSmallWebModel(jsonData: modalJson) else {
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



extension CQSmallWebVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isFromSmallWeb{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CQSmallWebCellId") as! CQSmallWebCell
            cell.model = self.dataArray[indexPath.section]
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CQNoticeCellId") as! CQNoticeCell
            cell.webModel = self.dataArray[indexPath.section]
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model:CQSmallWebModel = self.dataArray[indexPath.section]
       // if model.siteUrl.count > 5{
            let vc = CQWebVC.init()
            vc.urlStr = model.siteUrl
            vc.titleStr = model.siteTitle
            vc.isFromSmallWebVC = true
            self.navigationController?.pushViewController(vc, animated: true)
       // }else{
         //   SVProgressHUD.showInfo(withStatus: "无法显示当前网页")
       // }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.isFromSmallWeb{
            return AutoGetHeight(height: 64)
        }else{
            return AutoGetHeight(height: 102)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.isFromSmallWeb{
            return AutoGetHeight(height: 13)
        }
        return AutoGetHeight(height: 0.01)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.white
        return header
    }
}

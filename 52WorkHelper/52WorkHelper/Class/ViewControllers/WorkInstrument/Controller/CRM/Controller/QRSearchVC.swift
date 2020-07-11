//
//  QRSearchVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/4.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRSearchVC: SuperVC {
    
    //客户名
    var name = ""
    var currentPage  = 1
    var pageSize = 10
    var businessId = ""
    var customerId = ""
    
    var dataArr = [QRContractModel]()
    lazy var searchView: UIView = {
        let searchView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 45)))
        searchView.backgroundColor = UIColor.white
        searchView.layer.borderColor = kLineColor.cgColor
        searchView.layer.borderWidth = 0.5
        return searchView
    }()
    lazy var searchBar: SSSearchBar = {
        let searchbar = SSSearchBar(frame:  CGRect(x:0, y: 0, width: kWidth, height: AutoGetHeight(height: 45)))
        searchbar.delegate = self
        searchbar.barTintColor = UIColor.white
        searchbar.searchBarStyle = UISearchBarStyle.minimal
        searchbar.placeholder = "  搜索"
        return searchbar
    }()
    
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.register(QRContractCell.self, forCellReuseIdentifier:QRContractVC.CellIdentifier )
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.allowsSelectionDuringEditing = true
        return table
    }()
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.searchView
        self.searchView.addSubview(self.searchBar)
        self.title = "搜索"
        //self.navigationController?.navigationItem.titleView = searchBar
       // self.setUpRefresh()
        table.backgroundColor = UIColor.white
    }
    
    
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
      //  self.table.mj_header.beginRefreshing()
    }

    
    func loadDatas(moreData: Bool) {
        if moreData {
             currentPage += 1
        } else {
            currentPage = 1
        }
        let userid = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/crmContract/getContractList" ,
            type: .get,
            param:  ["emyeId": userid,
                     "currentPage":currentPage ,
                     "pageSize":10,"customerId":customerId ,"businessId":businessId,"name":name],
            successCallBack: { (result) in
                var tempArray = [QRContractModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = QRContractModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                
                if moreData {
                    self.dataArr.append(contentsOf: tempArray)
                } else {
                    self.dataArr = tempArray
                }
                //刷新表格
//                self.table.mj_header.endRefreshing()
//                self.table.mj_footer.endRefreshing()
                self.table.reloadData()
                
                //分页控制
//                let total = result["total"].intValue
//                if self.dataArr.count == total {
//                    self.table.mj_footer.endRefreshingWithNoMoreData()
//                }else {
//                    self.table.mj_footer.resetNoMoreData()
//                }
                
        }) { (error) in
            self.table.reloadData()
            self.table.mj_header.endRefreshing()
            self.table.mj_footer.endRefreshing()
        }
    }
    

}

extension QRSearchVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QRContractVC.CellIdentifier, for: indexPath)as! QRContractCell
          cell.model = dataArr[indexPath.row]
        return cell
    }
}

extension QRSearchVC:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      //  开始搜索并显示在table上
         self.searchBar.resignFirstResponder()
        if let tex = searchBar.text {
            self.name = tex
            self.loadDatas(moreData: false)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            self.name = ""
            self.loadDatas(moreData: false)
        }else{
            self.name = searchText
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.loadDatas(moreData: false)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }

}

extension QRSearchVC :UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        let detail = QRContratDetaiVC()
        let model = dataArr[indexPath.row]
        detail.contratKey = model.entityId
        navigationController?.pushViewController(detail, animated:true)
    
    }
    
}




//
//  QRSaleVC.swift
//  test
//
//  Created by 秦榕 on 2018/9/8.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit

class QRSaleVC: SuperVC {
    static let  CellIdentifier = "saleid"
    var saleArr = [QRGoodSaleModel]()
    var commodityId = ""
    var pageNum = 1
    var pageSize = 10
    var yearMonth = ""
    var yearOrMonth = ""
    
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = kProjectBgColor
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.register(QRSaleCell.self, forCellReuseIdentifier:QRSaleVC.CellIdentifier )
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.allowsSelection = false
        
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(table)
        table.backgroundColor = kProjectBgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpRefresh()
        loadDatas(moreData: false)
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
        
    }
    
    
    func loadDatas(moreData: Bool) {
        if moreData {
            pageNum += 1
        } else {
            pageNum = 1
        }
        STNetworkTools.requestData(URLString:"\(baseUrl)/crmCommodity/getTheMonthOfSales" ,
            type: .get,
            param:  ["commodityId": commodityId,
                     "currentPage":pageNum ,
                     "pageSize":10,
                     "yearMonth":yearMonth,
                     "yearOrMonth":yearOrMonth,
                     ],
            
            successCallBack: { (result) in
                var tempArray = [QRGoodSaleModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = QRGoodSaleModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }

                if moreData {
                    self.saleArr.append(contentsOf: tempArray)
                } else {
                    self.saleArr = tempArray
                }
                //刷新表格
                self.table.mj_header.endRefreshing()
                self.table.mj_footer.endRefreshing()
                self.table.reloadData()

                //分页控制
                let total = result["total"].intValue
                if self.saleArr.count == total {
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
extension QRSaleVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
extension QRSaleVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saleArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QRSaleVC.CellIdentifier, for: indexPath)as!QRSaleCell
        cell.model = saleArr[indexPath.row]
        return cell
    }
}

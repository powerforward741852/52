//
//  QRHistoryEditeVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/18.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRHistoryEditeVC: SuperVC {

    
    static let CellIdentifier = "historyEditeId"
    static let imgCellIdentifier = "imghistoryEditeId"
    //currentPage
    var currentPage = 1
    //客户id
    var customerId = ""
    //每页的条数
    var rows = "10"
    
    var dataArray = [QRHistoryModel]()
    var imgDataArray = [QRHistoryImageModel]()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.register(QRHistoryEditeCell.self, forCellReuseIdentifier:QRHistoryEditeVC.CellIdentifier )
        table.register(QRHistoryImgCell.self, forCellReuseIdentifier:QRHistoryEditeVC.imgCellIdentifier )
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 100
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "历史编辑记录"
        view.addSubview(table)
        self.loadImageDatas()
       self.loadDatas()
        
    }

    
    func loadImageDatas() {
       //getCrmFollowRecordByList
        STNetworkTools.requestData(URLString:"\(baseUrl)/crmCustomer/getCrmFollowRecordByList",
            type: .get,
            param:  ["customerId": customerId],
            successCallBack: { (result) in
                var tempArray = [QRHistoryImageModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = QRHistoryImageModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                    self.imgDataArray = tempArray
                self.table.reloadData()
                
        }) { (error) in
           
           
        }
    }
    
    
    
    func loadDatas() {
       
        STNetworkTools.requestData(URLString:"\(baseUrl)/crmCustomer/getCrmHistoryByList",
            type: .get,
            param:  ["customerId": customerId],
            successCallBack: { (result) in
                
                var tempArray = [QRHistoryModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = QRHistoryModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                
                self.dataArray = tempArray
                self.table.reloadData()
                
                
                
        }) { (error) in
      
        }
    }
    
}
    
    extension QRHistoryEditeVC:UITableViewDelegate{
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
extension QRHistoryEditeVC: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if section == 0 {
                return imgDataArray.count
            }else{
                return dataArray.count
            }
            
        
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.section == 0{
                let cell = (tableView.dequeueReusableCell(withIdentifier: QRHistoryEditeVC.imgCellIdentifier, for: indexPath) as! QRHistoryImgCell) ;
                // cell.gongHaiDelegate = self
                cell.model = imgDataArray[indexPath.row]
                return cell
            }else{
                let cell = (tableView.dequeueReusableCell(withIdentifier: QRHistoryEditeVC.CellIdentifier, for: indexPath) as! QRHistoryEditeCell) ;
                cell.model = dataArray[indexPath.row]
                return cell
            }
           
        }
        
        
    }
    
    


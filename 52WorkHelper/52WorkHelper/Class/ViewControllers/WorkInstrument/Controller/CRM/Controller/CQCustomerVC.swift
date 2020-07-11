//
//  CQCustomerVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/8/6.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQCustomerVC: SuperVC {
    var FreeArray = [QRCateModel]()
    var dataArray = ["我的客户","我跟进的客户","下属的客户","我的关系"]
    var pageNum = 1
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        //table.backgroundColor = kProjectBgColor
        table.delegate = self
        table.dataSource = self
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "客户"
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "CQCustomerCellId")
       // self.loadData()
        self.setUpRefresh()
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
        self.table.mj_header.beginRefreshing()

    }
    
    // MARK:request
    fileprivate func loadDatas(moreData: Bool) {
        if moreData {
            pageNum += 1
        } else {
            pageNum = 1
        }
        self.loadData()
    }
    
    deinit {
        
    }
    
    func loadData()  {
        let userid =  STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmCustomer/getCrmCustomerCategoryList", type: .get, param: ["userId":userid], successCallBack: { (result) in
            
            var temp = [QRCateModel]()
            for xx in result["data"].arrayValue{
                let mod = QRCateModel(jsonData: xx)
                temp.append(mod!)
            }
              self.FreeArray = temp
              self.table.reloadData()
            self.table.mj_header.endRefreshing()
            self.table.mj_footer.endRefreshing()
            self.table.reloadData()
            self.table.mj_footer.endRefreshingWithNoMoreData()
            
        }, failCallBack: { (error) in
            
        })
    }

}





extension CQCustomerVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.dataArray.count
        }else{
         return self.FreeArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = nil
        if cell == nil{
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "CQCustomerCellId")
        }
        
        cell?.accessoryType = .disclosureIndicator
        cell?.textLabel?.font = kFontSize15
        cell?.textLabel?.textColor = UIColor.black
        cell?.textLabel?.textAlignment = .left
        if indexPath.section == 0{
            cell?.textLabel?.text =  self.dataArray[indexPath.row]
        }else{
           let mod = self.FreeArray[indexPath.row]
            cell?.textLabel?.text = mod.categoryName
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if 0 == indexPath.row{
                let vc = CQMyCustomerVC()
                vc.titleStr = "我的客户"
                vc.searchmode = 1
                self.navigationController?.pushViewController(vc, animated: true)
            }else if 1 == indexPath.row{
                let vc = CQMyCustomerVC()
                vc.titleStr = "我跟进的客户"
                vc.searchmode = 4
                self.navigationController?.pushViewController(vc, animated: true)
            }else if 2 == indexPath.row{
                let vc = CQMyCustomerVC()
                vc.searchmode = 5
                vc.titleStr = "下属的客户"
                self.navigationController?.pushViewController(vc, animated: true)
            }else if 3 == indexPath.row{
                let vc = CQMyCustomerVC()
                vc.searchmode = 3
                vc.titleStr = "我的关系"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        if indexPath.section == 1 {
            let mod = FreeArray[indexPath.row]
            
            let vc = CQMyCustomerVC()
            vc.searchmode = 6
            vc.categoryId = mod.customerCategoryId
            vc.titleStr = mod.categoryName
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return AutoGetHeight(height: 55)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
}

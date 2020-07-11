//
//  QRKeHuList.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/17.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRKeHuList: SuperVC {

    var pageNum = 1
    var pageSize = "15"
    //客户主键
    var crmCustomer = [String]()
    //客户名字
    var crmCustomerName = [String]()
    
    //声明闭包
    typealias kehuListClosure = (_ name: String?,_ id :String ) -> Void
    //把申明的闭包设置成属性
    var clickClosure: kehuListClosure?
    
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.register(QRGoodsCell.self, forCellReuseIdentifier:QRGoodsVC.CellIdentifier )
       // table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.allowsSelectionDuringEditing = true
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpRefresh()
        view.backgroundColor = UIColor.white
        title = "选择客户"
        view.addSubview(table)
        table.backgroundColor = kProjectBgColor
        
    }
    
    //MARK:-加载客户列表类型
    func loadBusinessType(moreData:Bool){
        
        if moreData {
            pageNum += 1
        } else {
            pageNum = 1
        }
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmBusiness/getCrmBusinessCustomerList", type: .get, param: ["emyeId":userID,"currentPage":pageNum,"pageSize":pageSize
            ], successCallBack: { (result) in
                var tempID = [String]();
                var tempname = [String]();
                for xx in result["data"].arrayValue{
                    tempID.append(xx["crmCustomer"].stringValue)
                    tempname.append(xx["crmCustomerName"].stringValue)
                }
                
                if moreData {
                    self.crmCustomer.append(contentsOf: tempID)
                    self.crmCustomerName.append(contentsOf: tempname)
                } else {
                    self.crmCustomer = tempID
                    self.crmCustomerName = tempname
                }
                //刷新表格
                self.table.mj_header.endRefreshing()
                self.table.mj_footer.endRefreshing()
                self.table.reloadData()
                
                //分页控制
                let total = result["total"].intValue
                if self.crmCustomerName.count == total {
                    self.table.mj_footer.endRefreshingWithNoMoreData()
                }else {
                    self.table.mj_footer.resetNoMoreData()
                }
                
                
                
        }) { (result) in
            self.table.reloadData()
            self.table.mj_header.endRefreshing()
            self.table.mj_footer.endRefreshing()
            
        }
        
    }
   
    
    func setUpRefresh() {
        // MARK:header
        let STHeader = CQRefreshHeader {[unowned self] in
            self.loadBusinessType(moreData: false)
        }
        // MARK:footer
        let STFooter = CQRefreshFooter {[unowned self] in
            self.loadBusinessType(moreData: true)
        }
        self.table.mj_header = STHeader
        self.table.mj_footer = STFooter
        self.table.mj_header.beginRefreshing()
    }
}


extension QRKeHuList:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
       
        clickClosure!(crmCustomerName[indexPath.row],crmCustomer[indexPath.row])
        self.navigationController?.popViewController(animated: true)
        
    }
}
extension QRKeHuList:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return crmCustomerName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "default")
        cell.textLabel?.text = crmCustomerName[indexPath.row]
        return cell
    }
}

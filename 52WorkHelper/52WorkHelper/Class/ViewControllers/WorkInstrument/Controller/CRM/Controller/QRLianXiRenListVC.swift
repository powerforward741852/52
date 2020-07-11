//
//  QRLianXiRenListVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/17.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRLianXiRenListVC: UIViewController {
    
    //点击联系人后进行回调
    //声明闭包
    typealias clickBtnClosure = (_ lxr: QRLianXiRenModel ) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    
    
    //客户名称
    var crmCustomer = ""
    //
    var dataArr = [QRLianXiRenModel]()
    
    //联系mod
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        //table.register(QRGoodsCell.self, forCellReuseIdentifier:QRGoodsVC.CellIdentifier )
        // table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.allowsSelectionDuringEditing = true
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "联系人"
        view.addSubview(table)
        table.backgroundColor = kProjectBgColor
        loadLianXiRenList()
    }
    
    func loadLianXiRenList(){
     //   let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmBusiness/getCrmLinkmanList", type: .get, param: ["crmCustomer":crmCustomer], successCallBack: { (result) in
                var tempArr = [QRLianXiRenModel]()
            for xx in result["data"].arrayValue{
             let mod = QRLianXiRenModel(jsonData: xx)
                tempArr.append(mod!)
            }
            self.dataArr = tempArr
            self.table.reloadData()
            
        }) { (error) in
            
        }
        
    }
    
    
}

extension QRLianXiRenListVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        clickClosure!(dataArr[indexPath.row])
        self.navigationController?.popViewController(animated: true)
        
    }
}
extension QRLianXiRenListVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "defaultLXR")
        let mod = dataArr[indexPath.row]
        cell.textLabel?.text = mod.linkName
        return cell
    }
}


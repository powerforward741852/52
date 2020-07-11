//
//  CQMyBusinessListVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/9/28.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQMyBusinessListVC: SuperVC {

    var dataArray = [CQSmileWallModel]()
    
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
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
        
        self.getIsBusinessTravelTodayRequest()
        
        self.title = "我的出差"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.table)
        
    }
}

extension CQMyBusinessListVC{
    
    // MARK:request
    func getIsBusinessTravelTodayRequest() {
        let userID = STUserTool.account().userID
        let now = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormat.string(from: now)
        STNetworkTools.requestData(URLString:"\(baseUrl)/businessSign/getIsBusinessTravelToday" ,
            type: .get,
            param: ["userId":userID,
                    "recordDate":dateStr],
            successCallBack: { (result) in
                var tempArray = [CQSmileWallModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQSmileWallModel(jsonData: modalJson) else {
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



extension CQMyBusinessListVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "CQMyBusinessId")
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = self.dataArray[indexPath.row].businessApplyName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataArray[indexPath.row]
        let vc = CQBussinessSignVC()
        vc.businessApplyId = model.businessApplyId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return AutoGetHeight(height: 45)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}

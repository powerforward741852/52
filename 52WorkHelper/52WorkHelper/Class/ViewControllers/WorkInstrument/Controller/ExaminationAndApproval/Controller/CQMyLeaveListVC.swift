//
//  CQMyLeaveListVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/9/12.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQMyLeaveListVC: SuperVC {

    var dataArray = [CQMyLeaveListModel]()
    var pageNum = 1
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        //        table.backgroundColor = kProjectBgColor
        table.delegate = self
        table.dataSource = self
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
       // table.
        return table
    }()
    
    lazy var findAllLeaveRecordBtn: UIButton = {
        let findAllLeaveRecordBtn = UIButton.init(type: .custom)
        findAllLeaveRecordBtn.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: 44)
        findAllLeaveRecordBtn.backgroundColor = UIColor.colorWithHexString(hex: "#f2f6fc")
        findAllLeaveRecordBtn.addTarget(self, action: #selector(findAllClick), for: .touchUpInside)
        
        let lab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kWidth, height: 44))
        lab.text = "查看全部请假记录"
        lab.textAlignment = .left
        lab.textColor = UIColor.black
        lab.font = kFontSize15
        findAllLeaveRecordBtn.addSubview(lab)
        
        let img = UIImageView.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 40), y: 14.5, width: AutoGetWidth(width: 8), height: 15))
        img.image = UIImage.init(named: "roomClose")
        findAllLeaveRecordBtn.addSubview(img)
        return findAllLeaveRecordBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的假期"
        //self.view.backgroundColor = kProjectBgColor
        self.getLeaveTypeRequest()
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.findAllLeaveRecordBtn
        self.table.register(UINib.init(nibName: "CQMyLeaveListCell", bundle: Bundle.init(identifier: "MyLeaveList")), forCellReuseIdentifier: "CQMyLeaveListCellId")
    }
    
    @objc func findAllClick()  {
        let vc = CQMeSubmitVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CQMyLeaveListVC{
    
    //获取所有请假类型
    func getLeaveTypeRequest() {
        let userID = STUserTool.account().userID
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getAllVacationType" ,
            type: .get,
            param: ["emyeId":userID],
            successCallBack: { (result) in
                var tempArray = [CQMyLeaveListModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQMyLeaveListModel(jsonData: modalJson) else {
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



extension CQMyLeaveListVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQMyLeaveListCellId") as! CQMyLeaveListCell
        cell.model = self.dataArray[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = CQMyLeaveDTVC()
        vc.model = self.dataArray[indexPath.row]
        vc.titleStr = self.dataArray[indexPath.row].text
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 75
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}

//
//  CQMyLeaveDTVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/9/12.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQMyLeaveDTVC: SuperVC {

    var model:CQMyLeaveListModel?
    var titleStr = ""
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
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.titleStr
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.register(UINib.init(nibName: "CQMyLeaveDTCell", bundle: Bundle.init(identifier: "MyLeaveDT")), forCellReuseIdentifier: "CQMyLeaveDTCellId")
    }
    
}


extension CQMyLeaveDTVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return self.dataArray.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQMyLeaveDTCellId") as! CQMyLeaveDTCell
        cell.model = self.model
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 230
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}

//
//  CQNeedMeAgreeVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/28.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQNeedMeAgreeVC: SuperVC {

    var pageNum = 1
    var dataArray = [CQNeedMeAgreeModel]()
    var searchType = "2"
    
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpRefresh()
        
        self.title = "需要我审批的"
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.register(CQNeedMeAgreeCell.self, forCellReuseIdentifier: "CQNeedMeAgreeCellId")
        self.table.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CQCQNeedMeAgreeHeader")
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUI), name: NSNotification.Name.init("refreshNotAgreeVC"), object: nil)
    }
    
    @objc func refreshUI()  {
        self.setUpRefresh()
    }
}

extension CQNeedMeAgreeVC{
    fileprivate func setUpRefresh() {
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
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getMyApprovalList" ,
            type: .get,
            param: ["emyeId":userID,
                    "currentPage":pageNum,
                    "pageSize":"10",
                    "type":self.searchType],
            successCallBack: { (result) in
                var tempArray = [CQNeedMeAgreeModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQNeedMeAgreeModel(jsonData: modalJson) else {
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


extension CQNeedMeAgreeVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if 0 == section {
            return 1
        }
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = nil
        if 0 == indexPath.row && 0 == indexPath.section {
            if cell == nil{
                cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "personCellId")
            }
            cell?.textLabel?.text = "我已审批的"
            cell?.textLabel?.textColor = UIColor.black
            cell?.textLabel?.font = kFontSize15
            cell?.accessoryType = .disclosureIndicator
        }else {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "CQNeedMeAgreeCellId") as! CQNeedMeAgreeCell
            let c:CQNeedMeAgreeCell = cell as! CQNeedMeAgreeCell
            c.model = self.dataArray[indexPath.row]
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if 0 == indexPath.row && 0 == indexPath.section {
            let vc = CQHasAgreeVC()
            vc.searchType = "1"
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let model = self.dataArray[indexPath.row]
            let vc = NCQApproelDetailVC()
            vc.businessApplyId = model.entityId
            vc.isFromWaitApprovel = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return AutoGetHeight(height: 65)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if 1 == section {
            return AutoGetHeight(height: 38)
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if 0 == section {
            return AutoGetHeight(height: 13)
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        if 1 == section {
            let lab = UILabel.init(frame: CGRect.init(x:kLeftDis, y: 0, width: kHaveLeftWidth - 2 * kLeftDis, height: 38))
            lab.text = "待我审批的"
            lab.font = kFontSize15
            lab.textColor = UIColor.black
            lab.textAlignment = .left
            header.addSubview(lab)
        }
        header.backgroundColor = UIColor.white
        
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = kProjectBgColor
        return footer
    }
}

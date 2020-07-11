//
//  CQCopyToMeVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/28.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQCopyToMeVC: SuperVC {

    var pageNum = 1
    var dataArray = [CQCopyToMeModel]()
    var searchName = ""
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.delegate = self
        table.backgroundColor = UIColor.white
        table.dataSource = self
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    
    lazy var searchView: UIView = {
        let searchView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 45)))
        searchView.backgroundColor = UIColor.white
        searchView.layer.borderColor = kLineColor.cgColor
        searchView.layer.borderWidth = 0.5
        return searchView
    }()
    
    lazy var searchBar: CQSearchBar = {
        let searchBar = CQSearchBar.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 5), width: kHaveLeftWidth, height: AutoGetHeight(height: 35)))
        searchBar.delegate = self
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpRefresh()
        
        self.title = "抄送给我的"
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.searchView
        self.searchView.addSubview(self.searchBar)
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 44))
        rightBtn.setTitle("全部已读", for: .normal)
        rightBtn.setTitleColor(UIColor.colorWithHexString(hex: "#20afff"), for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        rightBtn.addTarget(self, action: #selector(hasReadClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        
        self.table.register(CQCopyToMeCell.self, forCellReuseIdentifier: "CQCopyToMeCellId")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpRefresh()
    }

    @objc func hasReadClick()  {
        self.approvalAllReadRequest()
    }
}

extension CQCopyToMeVC{
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
            self.dataArray.removeAll()
            pageNum = 1
        }
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getMyCopyList" ,
            type: .get,
            param: ["emyeId":userID,
                    "currentPage":pageNum,
                    "pageSize":"10",
                    "searchName":self.searchName],
            successCallBack: { (result) in
                var tempArray = [CQCopyToMeModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQCopyToMeModel(jsonData: modalJson) else {
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
    
    func approvalAllReadRequest() {
        let userID = STUserTool.account().userID
       
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/allRead" ,
            type: .get,
            param: ["emyeId":userID],
            successCallBack: { (result) in
                
                SVProgressHUD.showSuccess(withStatus: "全部已读")
                self.loadDatas(moreData: false)
                self.table.reloadData()
        }) { (error) in
            
        }
    }
}

extension CQCopyToMeVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQCopyToMeCellId") as! CQCopyToMeCell
        cell.model = self.dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataArray[indexPath.row]
        let vc = NCQApproelDetailVC()
        vc.isFromCopyToMe = true
        vc.title = model.nameApply
        vc.businessApplyId = model.entityId
        vc.titleStr = model.nameApply
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoGetHeight(height: 65)
    }
}

extension CQCopyToMeVC:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let search = textField as! CQSearchBar
        search.searchbut?.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if !(textField.text?.isEmpty)!{
            self.searchName = textField.text!
            self.setUpRefresh()
//        let search = textField as! CQSearchBar
//        search.searchbut?.isHidden = false
//        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}

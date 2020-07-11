//
//  CQMeSubmitVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/28.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQMeSubmitVC: SuperVC {

    var pageNum = 1
    var dataArray = [CQMyApplyListModel]()
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
//        searchView.layer.borderColor = kLineColor.cgColor
//        searchView.layer.borderWidth = 0.5
        let lineView = UIView(frame:  CGRect(x: 0, y: 44.5, width: kWidth, height: 0.5))
        lineView.backgroundColor = kProjectDarkBgColor
        searchView.addSubview(lineView)
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
        self.title = "我提交的"
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.searchView
        self.searchView.addSubview(self.searchBar)
        
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "CQMeSubmitCellId")
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUI), name: NSNotification.Name.init("refreshMeApplyUI"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    override func viewWillDisappear(_ animated: Bool) {
            let img = imageWithColor(color: kfilterBackColor, size: CGSize(width: kWidth, height: 0.5))
            self.navigationController?.navigationBar.shadowImage = img
    }
    @objc func refreshUI()  {
        self.setUpRefresh()
    }

}

extension CQMeSubmitVC{
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
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getMyApplyList" ,
            type: .get,
            param: ["emyeId":userID,
                    "currentPage":pageNum,
                    "pageSize":"10",
                    "searchName":self.searchName],
            successCallBack: { (result) in
                var tempArray = [CQMyApplyListModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQMyApplyListModel(jsonData: modalJson) else {
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

extension CQMeSubmitVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = nil
        if cell == nil{
            cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "CQMeSubmitCellId")
        }
        let model = self.dataArray[indexPath.row]
        
        cell?.accessoryType = .disclosureIndicator
        cell?.textLabel?.text = model.applyName
        cell?.textLabel?.textAlignment = .left
        cell?.textLabel?.textColor = UIColor.black
        cell?.textLabel?.font = kFontSize15
        
        let str = model.updateDate as NSString
        let subStr = str.replacingOccurrences(of: "-", with: ".") as NSString
        let finalStr = subStr.substring(with: NSRange.init(location: 0, length: 16))

        cell?.detailTextLabel?.text = model.statusDesc + "\n" + finalStr
        cell?.detailTextLabel?.textAlignment = .right
        cell?.detailTextLabel?.numberOfLines = 0
        cell?.detailTextLabel?.textColor = kLyGrayColor
        cell?.detailTextLabel?.font = kFontSize13
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataArray[indexPath.row]
        let vc = NCQApproelDetailVC()
        vc.businessApplyId = model.businessApplyId
        vc.isFromMeSubmit = true
        vc.titleStr = model.applyName
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoGetHeight(height: 55)
    }
}

extension CQMeSubmitVC:UITextFieldDelegate {
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

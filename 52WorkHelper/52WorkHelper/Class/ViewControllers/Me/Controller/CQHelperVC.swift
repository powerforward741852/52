//
//  CQHelperVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/5.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQHelperVC: SuperVC {

    var dataArray = [PersonModel]()
    var pageNum = 1
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.backgroundColor = kProjectBgColor
        table.delegate = self
        table.dataSource = self
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "帮助"
        self.setUpRefresh()
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 44))
        rightBtn.setTitle("意见反馈", for: .normal)
        rightBtn.sizeToFit()
        rightBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        rightBtn.setTitleColor(UIColor.colorWithHexString(hex: "#20afff"), for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        rightBtn.addTarget(self, action: #selector(suggestClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func suggestClick()  {
        let vc = CQHelpAndSuggustVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CQHelperVC{
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
        STNetworkTools.requestData(URLString:"\(baseUrl)/my/getHelpList" ,
            type: .get,
            param: ["emyeId":userID,
                    "currentPage":pageNum,
                    "pageSize":"10",
                    "version":CQVersion],
            successCallBack: { (result) in
                var tempArray = [PersonModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = PersonModel(jsonData: modalJson) else {
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

extension CQHelperVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "CQHelperVCCellId")
        let model = self.dataArray[indexPath.row]
        cell.textLabel?.text = model.articleTitle
        cell.textLabel?.font = kFontSize15
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let mod = dataArray[indexPath.row]
        let vc = CQWebVC()
        let url = "\(baseUrl)/my/getHelpInfo" + "?entityId=" + mod.entityId
        vc.urlStr = url
//        vc.titleStr = mod.articleTitle
        vc.titleStr = "帮助详情"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoGetHeight(height: 55)
    }
    
    
}

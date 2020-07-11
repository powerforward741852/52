//
//  CQLocationNearVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/9/26.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQLocationNearVC: SuperVC {

    var dataArray = [CQDepartMentAttenceModel]()
    var pageNum = 1
    var distance = "500"
    var departmentId = ""
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 40)))
        headView.backgroundColor = UIColor.white
        return headView
    }()
    
    lazy var distanceBtn: UIButton = {
        let distanceBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 120, height: AutoGetHeight(height: 40)))
        distanceBtn.setTitle("当前: 500m", for: .normal)
        distanceBtn.titleLabel?.font = kFontSize15
        distanceBtn.setTitleColor(UIColor.colorWithHexString(hex: "#21afff"), for: .normal)
        distanceBtn.setImage(UIImage.init(named: "open_icon"), for: .normal)
        distanceBtn.setImage(UIImage.init(named: "close_icon"), for: .selected)
        distanceBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 100, bottom: 0, right: 0)
        distanceBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -30, bottom: 0, right: 0)
        distanceBtn.addTarget(self, action: #selector(chooseDistance), for: .touchUpInside)
        return distanceBtn
    }()
    
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
    
    lazy var distanceTable: CQChooseDistanceTable = {
        let distanceTable = CQChooseDistanceTable.init(frame: CGRect.init(x: 0, y: 64 + AutoGetHeight(height: 40), width: kWidth, height: AutoGetHeight(height: 160)), style: UITableViewStyle.plain)
        distanceTable.selectDelegate = self
        return distanceTable
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpRefresh()
        self.view.backgroundColor = kProjectBgColor
        self.title = "附近"
        self.view.addSubview(self.table)
        self.table.register(UINib.init(nibName: "CQLocationNearCell", bundle: Bundle.init(identifier: "CQLocationNearCellId")), forCellReuseIdentifier: "CQLocationNearCellId")
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.distanceBtn)
        self.view.addSubview(self.distanceTable)
        self.distanceTable.isHidden = true
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 0, y: 0, width: 60, height: 40)
        btn.setTitle("位置", for: .normal)
        btn.setTitleColor(UIColor.colorWithHexString(hex: "#21afff"), for: .normal)
        btn.addTarget(self, action: #selector(locationClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: btn)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func chooseDistance(btn:UIButton)  {
        btn.isSelected = !btn.isSelected
        
        if btn.isSelected {
            self.distanceTable.isHidden = false
            self.table.isScrollEnabled = false
            distanceBtn.setImage(UIImage.init(named: "open_icon"), for: .normal)
        }else{
            self.distanceTable.isHidden = true
            self.table.isScrollEnabled = true
            distanceBtn.setImage(UIImage.init(named: "close_icon"), for: .selected)
        }
    }
    
    @objc func locationClick()  {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension CQLocationNearVC{
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
        STNetworkTools.requestData(URLString:"\(baseUrl)/historyPosition/getHistoryPositionByPage" ,
            type: .get,
            param: ["userId":userID,
                    "currentPage":pageNum,
                    "rows":"10",
                    "distance":self.distance],
            successCallBack: { (result) in
                var tempArray = [CQDepartMentAttenceModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQDepartMentAttenceModel(jsonData: modalJson) else {
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

extension CQLocationNearVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQLocationNearCellId") as! CQLocationNearCell
        cell.model = self.dataArray[indexPath.row]
        return cell    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataArray[indexPath.row]
        let vc = CQWorkInstrumentPersonInfoVC.init()
        vc.userId = model.createUserId
        vc.chatName = model.createUserRealName
        vc.userModel = CQDepartMentUserListModel.init(uId: model.createUserId, realN: model.createUserRealName, headImag: model.createUserHeadImage)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return AutoGetHeight(height: 110)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
}

extension CQLocationNearVC:distanceSelectDelegate{
    func chooseDistanceAction(distance: String) {
        self.distanceTable.isHidden = true
        self.distanceBtn.setTitle("当前: " + distance + "m", for: .normal)
        self.distanceBtn.isSelected = false
        self.distance = distance
        self.setUpRefresh()
    }
}


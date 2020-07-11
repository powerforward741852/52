//
//  CQHasAgreeVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/30.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQHasAgreeVC: SuperVC {

    var dataArray = [CQNeedMeAgreeModel]()
    var pageNum = 1
    var searchType = ""
    var businessName = ""
    var finishSign = true
    var nameApply = ""
    var isSearching = false
    var isFilter = false
    var twoLevelArr = [String]()
    var twoLevelDataArray = [CQFilterApplyModel]()
    var v:CQApplyFilterView?
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 0), width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        //        table.backgroundColor = kProjectBgColor
        table.delegate = self
        table.dataSource = self
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
        NotificationCenter.default.addObserver(self, selector: #selector(updateReflesh(notification:)), name: NSNotification.Name.init("refleshAllreadySignUseless"), object: nil)
        self.setUpRefresh()
        self.getAllBussinessRequest()
        self.title = "我已审批的"
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.searchView
        self.searchView.addSubview(self.searchBar)
        self.table.register(CQNeedMeAgreeCell.self, forCellReuseIdentifier: "CQNeedMeAgreeCellId")
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        rightBtn.setTitle("筛选", for: .normal)
        rightBtn.setTitleColor(UIColor.colorWithHexString(hex: "#20afff"), for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        rightBtn.addTarget(self, action: #selector(shaixuanClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func updateReflesh(notification: Notification){
        self.loadDatas(moreData: false)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   @objc func shaixuanClick()  {
        //
        v = CQApplyFilterView.init(frame: CGRect.init(x: 0, y: 64, width: kWidth, height: kHeight), levelOneTitle: "状态", leverlTwoTitle: "类型", levelOneArray: ["全部","审批完成","审批中"], levelTwoArray: self.twoLevelArr)
        v?.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
        v?.submitDelegate = self
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.addSubview(v!)
    }
    
    override func backToSuperView() {
        self.v?.removeFromSuperview()
        self.navigationController?.popViewController(animated: true)
    }

}

extension CQHasAgreeVC{
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
        var param = [String:Any]()
//        if self.isSearching {
            param = ["emyeId":userID,
                     "currentPage":pageNum,
                     "pageSize":"10",
                     "type":self.searchType,
                     "businessName":self.businessName,
                     "finishSign":self.finishSign,
                     "nameApply":self.nameApply]

        ////申请状态码(0-审核中，1-审核通过，2-被驳回，3-已撤销，4-已销假(请假申请))
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getMyApprovalList" ,
            type: .get,
            param: param,
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
    
    //筛选
    func getAllBussinessRequest() {
        let userId = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getAllBusinessApplys" ,
            type: .get,
            param: ["emyeId":userId],
            successCallBack: { (result) in
                
                var tempArray = [CQFilterApplyModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQFilterApplyModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                self.twoLevelDataArray = tempArray
                for model in self.twoLevelDataArray{
                    self.twoLevelArr.append(model.businessName)
                }
                
        }) { (error) in
            
        }
    }
}



extension CQHasAgreeVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQNeedMeAgreeCellId") as! CQNeedMeAgreeCell
        cell.model = self.dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataArray[indexPath.row]
        let vc = NCQApproelDetailVC()
        vc.businessApplyId = model.entityId
        //vc.isFromWaitApprovel = true
        vc.isFromMeHasApprovel = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return AutoGetHeight(height: 65)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = kProjectBgColor
        return header
    }
}

extension CQHasAgreeVC:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let search = textField as! CQSearchBar
        search.searchbut?.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if !(textField.text?.isEmpty)!{
            self.isSearching = true
            self.nameApply = textField.text!
            self.setUpRefresh()
//        let search = textField as! CQSearchBar
//        search.searchbut?.isHidden = false
//        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
//        let search = textField as! CQSearchBar
       // search.searchbut?.isHidden = false
    }
}

extension CQHasAgreeVC:CQFilterSubmitDelegate{
    func loadNewData(finish: Bool, businessName: String) {
        self.isFilter = true
        self.finishSign = finish
        self.businessName = businessName
        self.setUpRefresh()
    }
    
    
}

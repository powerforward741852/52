//
//  CQMyCustomerVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/8/6.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQMyCustomerVC: SuperVC {
    
    var rightBtn:UIButton?
    var titleStr = ""
    var dataArray = [CQMyCustomerModel]()
    var pageNum = 1
    var searchmode = 0
    var selectArr = [0,0,0]
    var dealStatus = ""
    var followDate = ""
    var followStatus = ""
    var rows = "10"
    var name = ""
    //客户来源
    var message = ""
    //分类id
    var categoryId = ""
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight ), style: UITableViewStyle.plain)
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
            table.contentInset = UIEdgeInsetsMake(CGFloat(SafeAreaTopHeight), 0, CGFloat(SafeAreaBottomHeight), 0);
            table.scrollIndicatorInsets = table.contentInset;
            
        } else {
            //低于 iOS 9.0
        }
        
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.estimatedRowHeight = 107
        return table
    }()
    
    
    
    lazy var searchView: UIView = {
        let searchView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 45)))
        searchView.backgroundColor = UIColor.white
        searchView.layer.borderColor = kLineColor.cgColor
        searchView.layer.borderWidth = 0.5
      //  self.searchView.addSubview(self.searchBar)
        return searchView
    }()
    

    lazy var searchBar: SSSearchBar = {
        let searchbar = SSSearchBar(frame:  CGRect(x: 0, y: 0, width: kWidth  , height: AutoGetHeight(height: 45)))
        searchbar.delegate = self
        searchbar.searchBarStyle = UISearchBarStyle.minimal
        searchbar.placeholder = "  搜索"
 
        return searchbar
    }()
    
    
    lazy var addCustomerBtn: UIButton = {
        let addCustomerBtn = UIButton.init(type: .custom)
        addCustomerBtn.frame = CGRect.init(x: kWidth - 1.5 * kLeftDis - AutoGetWidth(width: 77), y: kHeight - AutoGetHeight(height: 150), width: AutoGetWidth(width: 77), height: AutoGetWidth(width: 77))
        addCustomerBtn.addTarget(self, action: #selector(addCustomerClick), for: UIControlEvents.touchUpInside)
        addCustomerBtn.setImage(UIImage.init(named: "CRMAddCustomer"), for: .normal)
        return addCustomerBtn
    }()
    deinit {
        NotificationCenter.default.removeObserver(self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.tableHeaderView = self.searchView
        self.searchView.addSubview(self.searchBar)
        self.setUpRefresh()
        
        
        
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.register(CQMyCustomerCell.self, forCellReuseIdentifier: "CQMyCustomerCellId")
        self.table.tableHeaderView = self.searchView
        self.searchView.addSubview(self.searchBar)
        self.title = self.titleStr
        if self.title == "我的客户"{
            self.view.addSubview(self.addCustomerBtn)
            self.view.bringSubview(toFront: self.addCustomerBtn)
        }
        
       
        rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 17, height: 17))
        rightBtn?.setImage(UIImage.init(named: "CRMFilter"), for: .normal)
        let rightItem = UIBarButtonItem.init(customView: rightBtn!)
        rightBtn?.addTarget(self, action: #selector(OKClick), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = rightItem
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateImages(notification:)), name: NSNotification.Name(rawValue: "imagsCellID"), object: nil)
    }
    
    @objc func updateImages(notification:NSNotification){
        
        let index = notification.userInfo?["index"] as? Int
        let imgs = notification.userInfo?["imags"] as? [String]
        if let index = index ,let imags = imgs, imags.count > 0{
            let previewVC = ImagePreViewVC(images: imags, index: index)
            self.navigationController?.pushViewController(previewVC, animated: true)
        }
    }
    
    

    @objc func OKClick()  {
        DLog("筛选")
        let filter = QRCustomFilterVC()
        filter.selectArr = selectArr
        filter.clickClosure = {[unowned self] a,b,c,d in
            self.selectArr = d
            self.message = a!
            self.followStatus = b
            self.dealStatus = c
            self.loadDatas(moreData: false)
        }
        filter.title = self.title
        self.navigationController?.pushViewController(filter, animated: true)
    }
    
    @objc func addCustomerClick() {
        let vc = CQAddCustomerVC()
        vc.clickClosure = {[unowned self] reflash in
            self.loadDatas(moreData: false)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK loadData
extension CQMyCustomerVC{
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
        STNetworkTools.requestData(URLString:"\(baseUrl)/crmCustomer/getCrmCustomerByPage" ,
            type: .get,
            param: ["categoryId":categoryId,
                    "currentPage":pageNum,
                    "dealStatus":dealStatus,
                    "followDate":followDate,
                    "followStatus":followStatus,
                    "message":message,
                    "name":name,
                    "rows":rows,
                    "searchmode":searchmode,
                    "userId":userID],
            successCallBack: { (result) in
                var tempArray = [CQMyCustomerModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQMyCustomerModel(jsonData: modalJson) else {
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

extension CQMyCustomerVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "CQMyCustomerCellId", for: indexPath) as! CQMyCustomerCell
        cell.model = dataArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let mod = self.dataArray[indexPath.row]
        let vc = QRDetailCustomVC()
        vc.customerId = mod.customerId
        vc.clickClosure = {[unowned self] xx in
            self.loadDatas(moreData: false)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
}

extension CQMyCustomerVC:UITextFieldDelegate {
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

extension CQMyCustomerVC:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //开始搜索并显示在table上
        self.table.resignFirstResponder()
        if let tex = searchBar.text {
            self.name = tex
            self.loadDatas(moreData: false)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            self.name = ""
            self.loadDatas(moreData: false)
        }else{
             self.name = searchText
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       //  searchBar.showsCancelButton = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
       // self.loadDatas(moreData: false)
        // searchBar.showsCancelButton = false
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    
}

extension CQMyCustomerVC :UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}


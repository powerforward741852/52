//
//  QRBusinessVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/6.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRBusinessVC: SuperVC {
    var filterArr = [0,0,0]
    var dataARR = [QRBusinessModel]()
    var pageNum = 1
    //商机名称
    var businessName = ""
    //最后跟进时间
    var lastFollowDate = ""
    //金额查询标志
    var estimatedAmountFlag = ""
    //结束时间
    var closeDate = ""
    //
    var customerId = ""
    static let CellIdentifier = "BusinessCell_ID";
    
        lazy var addBut:UIButton = {
            let but = UIButton(type: UIButtonType.custom);
            but.setImage(UIImage(named: "CRMAddCustomer"), for:.normal)
            but.sizeToFit()
            but.addTarget(self, action: #selector(AddCustomer), for: .touchUpInside)
            return but
        }()
    
    lazy var searchBar: SSSearchBar = {
        let searchbar = SSSearchBar(frame:  CGRect(x: 0, y: 0 , width: kWidth, height: AutoGetHeight(height: 45)))
        searchbar.delegate = self
        searchbar.barTintColor = UIColor.white
        searchbar.searchBarStyle = UISearchBarStyle.minimal
        searchbar.placeholder = "  搜索"
        return searchbar
    }()
    
    lazy var searchView: UIView = {
        let searchView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 45)))
        searchView.backgroundColor = UIColor.white
        searchView.layer.borderColor = kLineColor.cgColor
        searchView.layer.borderWidth = 0.5
        return searchView
    }()
    lazy var greyiew:UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height:10 ))
        view.backgroundColor = kProjectBgColor
        return view
    }()
    
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
        table.register(QRBusinessCell.self, forCellReuseIdentifier:QRBusinessVC.CellIdentifier )
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.backgroundColor = kProjectBgColor
        table.estimatedRowHeight = AutoGetHeight(height: 133)
        table.rowHeight = UITableViewAutomaticDimension
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "商机"
        view.addSubview(table)
        table.backgroundColor = UIColor.white
        self.table.tableHeaderView = self.searchView
        self.searchView.addSubview(self.searchBar)
        navigationItem.rightBarButtonItem = rightButtonWithImg(image: UIImage(named: "shaixuan")!)
        addAddBut()
        setUpRefresh()
    }
    func addAddBut()  {
        view.addSubview(addBut)
        addBut.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(-14)
            make?.bottom.mas_equalTo()(-100)
        }
    }
    override func rightItemClick() {
        //添加筛选框
      let filter = QRBusinessfilterVC()
        filter.selectArr = filterArr
        
        filter.clickClosure = {[unowned self] a,b,c,d in
            self.closeDate = a
            self.estimatedAmountFlag = b
            self.lastFollowDate = c
            self.filterArr = d
            self.loadDatas(moreData: false)
        }
       // filterVc.fenlei = self.cateArry
        self.navigationController?.pushViewController(filter, animated: true)
        
    }
    
    
   
    
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    func setUpRefresh()  {
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
    
    func loadDatas(moreData:Bool) {
        
        if moreData {
            pageNum += 1
        } else {
            pageNum = 1
        }
        let userid = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/crmBusiness/getCrmBusinessList" ,
            type: .get,
            param:  ["emyeId": userid,
                     "currentPage":pageNum ,
                     "pageSize":10,"businessName":businessName,"closeDate":closeDate,"estimatedAmountFlag":estimatedAmountFlag,"lastFollowDate":lastFollowDate,"customerId":customerId],
            successCallBack: { (result) in
               
                var tempArray = [QRBusinessModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = QRBusinessModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                
                if moreData {
                    self.dataARR.append(contentsOf: tempArray)
                } else {
                    self.dataARR = tempArray
                }
                //刷新表格
                self.table.mj_header.endRefreshing()
                self.table.mj_footer.endRefreshing()
                self.table.reloadData()
                //分页控制
                let total = result["total"].intValue
                if self.dataARR.count == total {
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

extension QRBusinessVC : UITableViewDelegate{
    
}

extension QRBusinessVC :UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}
extension QRBusinessVC : UITableViewDataSource{
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataARR.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QRBusinessVC.CellIdentifier, for: indexPath) as! QRBusinessCell
        cell.model = dataARR[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let detail = QRDetailBusinessVC()
        detail.entityId = dataARR[indexPath.row].entityId
        detail.clickClosure = {[unowned self] a in
            self.table.mj_header.beginRefreshing()
        }
        print(dataARR[indexPath.row].entityId)
       self.navigationController?.pushViewController(detail, animated: true)
    }
    

    
    
}

extension QRBusinessVC:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //开始搜索并显示在table上
        self.searchBar.resignFirstResponder()
        if let tex = searchBar.text {
            self.businessName = tex
            self.loadDatas(moreData: false)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            self.businessName = ""
            self.loadDatas(moreData: false)
        }else{
            self.businessName = searchText
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.table.resignFirstResponder()
        self.loadDatas(moreData: false)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    
}



//:MARK- 点击事件
extension QRBusinessVC{
    
    @objc func searchClick()  {
        
    }
   
    @objc func AddCustomer(){
        let business = QRAddBusinessVC()
        
        business.clickClosure = {[unowned self] a in
            self.table.mj_header.beginRefreshing()
        }
        
        self.navigationController?.pushViewController(business, animated: true)
    }
    
}

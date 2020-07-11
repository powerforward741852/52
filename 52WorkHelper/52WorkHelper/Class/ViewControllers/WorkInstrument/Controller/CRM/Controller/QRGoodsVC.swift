//
//  QRGoodsVC.swift
//  test
//
//  Created by 秦榕 on 2018/9/8.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit

class QRGoodsVC: SuperVC {
    var pageNum = 1
    var dataArray = [QRGoodsModel]()
    var cateArry = [QRGoodCateModel]()
    
    var fiterArr = [0,0]
    //商品分类主键
    var categoryId = ""
    //商品分类名称
    var commodityName = ""
    //商品是否上架(0为上架中，1为下架)
    var commodityState = ""
    //客户主键
    var customerId = ""
    
    static let CellIdentifier = "GoodsCell_ID";
    
    lazy var searchBtn: UIButton = {
        let searchBtn = UIButton.init(type: .custom)
        searchBtn.frame = CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 5), width: kHaveLeftWidth, height: AutoGetHeight(height: 35))
        searchBtn.setImage(UIImage.init(named: "knowledgeSearch"), for: .normal)
        searchBtn.setTitle(" 搜索", for: .normal)
        searchBtn.setTitleColor(kLyGrayColor, for: .normal)
        searchBtn.layer.cornerRadius = 5
        searchBtn.backgroundColor = kProjectBgColor
        searchBtn.addTarget(self, action: #selector(searchClick), for: .touchUpInside)
        return searchBtn
    }()
    
    lazy var searchView: UIView = {
        let searchView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 45)))
        searchView.backgroundColor = UIColor.white
        searchView.layer.borderColor = kLineColor.cgColor
        searchView.layer.borderWidth = 0.5
        return searchView
    }()
    lazy var searchBar: SSSearchBar = {
        let searchbar = SSSearchBar(frame:  CGRect(x: 0, y:  0, width: kWidth, height: AutoGetHeight(height: 45)))
        searchbar.delegate = self
        searchbar.barTintColor = UIColor.white
        searchbar.searchBarStyle = UISearchBarStyle.minimal
        searchbar.placeholder = "  搜索"
//        if #available(iOS 11.0, *) {
//            searchbar.setPositionAdjustment(UIOffset(horizontal: (searchbar.width)/2, vertical: 0), for: UISearchBarIcon.search)
//        }
        return searchbar
    }()
    
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
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
        table.register(QRGoodsCell.self, forCellReuseIdentifier:QRGoodsVC.CellIdentifier )
        table.rowHeight = AutoGetHeight(height: 93)
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.allowsSelectionDuringEditing = true
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.backgroundColor = UIColor.white
        view.backgroundColor = UIColor.white
        title = "商品"
        view.addSubview(table)
        table.backgroundColor = UIColor.white
        self.table.tableHeaderView = self.searchView
        self.searchView.addSubview(self.searchBar)
        navigationItem.rightBarButtonItem = rightButtonWithImg(image: UIImage(named: "shaixuan")!)
        loadCtate()
        setUpRefresh()
        //loadDatas(moreData: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    func loadCtate()  {
        let userid = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmCommodity/getCategories", type: .get, param: ["emyeId": userid], successCallBack: { (result) in
           
            var tempArray = [QRGoodCateModel]()
            
            for modalJson in result["data"].arrayValue {
                guard let modal = QRGoodCateModel(jsonData: modalJson) else {
                    return
                }
                tempArray.append(modal)
            }
            self.cateArry = tempArray//传入筛选控制器
            
        }) { (error) in
            SVProgressHUD.show(withStatus: "商品分类加载失败")
        }
    }
    
    override func rightItemClick() {
        let filterVc = QRFilterVC()
        filterVc.selectArr = self.fiterArr
        filterVc.clickClosure = {[unowned self] a,b,c in
            self.commodityState = a!
            self.categoryId = b
            self.fiterArr = c
            //self.table.mj_header.beginRefreshing()
            self.loadDatas(moreData: false)
        }
        filterVc.fenlei = self.cateArry
        self.navigationController?.pushViewController(filterVc, animated: true)
    }
    func setUpRefresh() {
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
    
    
    func loadDatas(moreData: Bool) {
        if moreData {
            pageNum += 1
        } else {
            pageNum = 1
        }
        let userid = STUserTool.account().userID

        
        STNetworkTools.requestData(URLString:"\(baseUrl)/crmCommodity/getCommodityList" ,
            type: .get,
        param: ["emyeId": userid,
        "currentPage":pageNum ,
        "pageSize":10,
        "commodityState":commodityState,
        "categoryId":categoryId,"commodityName":commodityName,"customerId":customerId] ,
            successCallBack: { (result) in
                var tempArray = [QRGoodsModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = QRGoodsModel(jsonData: modalJson) else {
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

extension QRGoodsVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
       let goodSaleVc = QRGoodInfoVC()
        goodSaleVc.goodModel = dataArray[indexPath.row]
        goodSaleVc.entityId = dataArray[indexPath.row].entityId
       navigationController?.pushViewController(goodSaleVc, animated: true)
    
    }
}
extension QRGoodsVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QRGoodsVC.CellIdentifier, for: indexPath)as! QRGoodsCell

        cell.model = dataArray[indexPath.row]
        return cell
    }
}

extension QRGoodsVC:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //开始搜索并显示在table上
         self.searchBar.resignFirstResponder()
        if let tex = searchBar.text {
           self.commodityName = tex
           self.loadDatas(moreData: false)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            self.commodityName = ""
            self.loadDatas(moreData: false)
        }else{
            self.commodityName = searchText
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
         self.searchBar.resignFirstResponder()
        if let tex = searchBar.text {
            self.commodityName = tex
        }
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    
}

extension QRGoodsVC :UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}

//MARK:- 点击事件
extension QRGoodsVC{
    @objc  func searchClick(){
        
    }
    
}

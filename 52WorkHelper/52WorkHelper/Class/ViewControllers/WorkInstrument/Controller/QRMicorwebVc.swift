//
//  QRMicorwebVc.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/5.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRMicorwebVc: SuperVC {
    var myprojectId = ""
    var dataArray = [CQEnterpriseInfoModel]()
    //分类模型
    var cateArr = [CQGuideModel]()
    var cateTitleArr = [String]()
    var selectArr = [0]
    var typeId = ""
    var siteType = ""
    var pageNum = 1
    var searchName = ""
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
            table.contentInset = UIEdgeInsetsMake(CGFloat(SafeAreaTopHeight), 0, CGFloat(SafeAreaBottomHeight), 0);
            table.scrollIndicatorInsets = table.contentInset;

        } else {
            //低于 iOS 9.0
        }
        //table.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.register(CQNoticeCell.self, forCellReuseIdentifier: "CQMicroellId")
      //  table.rowHeight = AutoGetHeight(height: 93)

        return table
    }()
    
    
    lazy var searchBtn: UIButton = {
        let searchBtn = UIButton.init(type: .custom)
        searchBtn.frame = CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 5), width: kHaveLeftWidth, height: AutoGetHeight(height: 35))
        searchBtn.setImage(UIImage.init(named: "knowledgeSearch"), for: .normal)
        searchBtn.setTitle(" 搜索", for: .normal)
        searchBtn.setTitleColor(kLyGrayColor, for: .normal)
        searchBtn.layer.cornerRadius = 5
        searchBtn.backgroundColor = kProjectBgColor
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //title = "媒体报道"
        
        //添加一个全部模型
        let mod = CQGuideModel()
        mod.entityId = ""
        mod.projectName = "全部"
        self.cateArr.append(mod)
        
        
        view.backgroundColor = UIColor.white
        view.addSubview(table)
        self.table.tableHeaderView = self.searchView
        self.searchView.addSubview(self.searchBar)
       
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        rightBtn.setImage(UIImage.init(named: "CRMFilter"), for: .normal)
        rightBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        rightBtn.addTarget(self, action: #selector(jumpIn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
       
        self.setUpReflash()
        self.loadCateData()
  
    }
    
    func loadCateData(){
        SVProgressHUD.show()
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/microWeb/getInformationProject" ,
        type: .get,
        param: ["emyeId":userID],
        successCallBack: { (result) in
            
        var tempArray = [CQGuideModel]()
        for modalJson in result["data"].arrayValue {
        guard let modal = CQGuideModel(jsonData: modalJson) else {
        return
        }
        tempArray.append(modal)
        
        }
        self.cateArr.append(contentsOf: tempArray)
        //self.cateArr = tempArray
            
        //                if guideImageArray.count > 0{
        //                    let images = guideImageArray
        //                    let ranGuide = RanGuidePages(frame: UIScreen.main.bounds, images: images)
        //                    self.window?.addSubview(ranGuide)
        //                }
        //
        SVProgressHUD.dismiss()
        }) { (error) in
        SVProgressHUD.dismiss()
        }
    }
    
    
    @objc func jumpIn(){
        let filterVc = QRWebFilterVC()
        filterVc.selectArr = selectArr
        filterVc.cateTitleArr = [""]
        self.cateTitleArr.removeAll()
        for (_,value) in self.cateArr.enumerated(){
            self.cateTitleArr.append(value.projectName)
        }
        filterVc.cateArr = [self.cateTitleArr]
        filterVc.clickClosure = {[unowned self] selectArr in
            for (index,value) in selectArr.enumerated(){
              self.myprojectId = self.cateArr[value].entityId
              self.selectArr[index] = value
            }
            
            print(selectArr)
            self.setUpReflash()
           // self.loadDatas(moreData: false)
        }
        self.navigationController?.pushViewController(filterVc, animated: true)
    }
   

}


extension QRMicorwebVc:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQMicroellId") as! CQNoticeCell
        cell.modelm = self.dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataArray[indexPath.row]
        let vc = CQWebVC()
        vc.urlStr = model.sitegUrl
        vc.titleStr = model.siteTitle
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return AutoGetHeight(height: 94)
    }
}



extension QRMicorwebVc{

    func setUpReflash(){
        // MARK:header
        let STHeader = CQRefreshHeader {
            self.loadDatas(moreData: false)
        }
        // MARK:footer
        let STFooter = CQRefreshFooter {
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
            self.dataArray.removeAll()
        }
        STNetworkTools.requestData(URLString:"\(baseUrl)/microWeb/list" ,
            type: .get,
            param: ["siteType":self.siteType,
                    "typeId":self.typeId,
                    "currentPage":pageNum,
                    "pageSize":"10",
                    "searchName":searchName,"projectId":myprojectId],
            successCallBack: { (result) in
                var tempArray = [CQEnterpriseInfoModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQEnterpriseInfoModel(jsonData: modalJson) else {
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
extension QRMicorwebVc :UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}

extension QRMicorwebVc:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //开始搜索并显示在table上
        self.searchBar.resignFirstResponder()
        if let tex = searchBar.text {
            self.searchName = tex
            self.loadDatas(moreData: false)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            self.searchName = ""
            self.loadDatas(moreData: false)
        }else{
            self.searchName = searchText
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        if let tex = searchBar.text {
            self.searchName = tex
        }
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    
}

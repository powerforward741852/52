//
//  QRGonghaiVc.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/6.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRGonghaiVc: SuperVC {
     static let CellIdentifier = "GongHaiCell_ID";
    //部门ID
    var departmentId = ""
    //回调model
    var overTimeModel : CQDepartMentUserListModel?
    //分配的model
    var fenPeiModel : QRGongHaiModel?
    
    //筛选数组
    var filterArr = [0,0,0,0]
    //当前页
    var pageNum = 1
    //自定义分类Id
    var categoryId = ""
    //交易状态
    var dealStatus = ""
    //跟进时间
    var followDate = ""
    //跟进状态
    var followStatus  = ""
    //客户信息来源
    var message = ""
    //客户名称
    var name = ""
    //每页的条数
    var rows = 15
    //查询模式
    var searchmode = ""
    //searchmode
   
   var butHidden = false
    
    
    
    lazy var searchBar: SSSearchBar = {
        let searchbar = SSSearchBar(frame:  CGRect(x: 0, y: 0, width: kWidth , height: AutoGetHeight(height: 45)))
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
        table.register(QRGongHaiCell.self, forCellReuseIdentifier:QRGonghaiVc.CellIdentifier )
        table.rowHeight = AutoGetHeight(height: 80)
       
        return table
    }()
    
    
    var dataArray = [QRGongHaiModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        STNetworkTools.requestData(URLString:"\(baseUrl)/crmCustomer/getCrmCustomerByPage",
            type: .get,
            param:  ["categoryId": categoryId,
                     "currentPage":pageNum ,
                     "rows":rows,"searchmode":2,"userId":userid,"dealStatus":dealStatus,"followDate":followDate,"followStatus":followStatus,"message":message,"name":name],
            successCallBack: { [unowned self](result) in
               
                
                var tempArray = [QRGongHaiModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = QRGongHaiModel(jsonData: modalJson) else {
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "客户公海"
        view.addSubview(table)
        self.table.tableHeaderView = self.searchView
        self.searchView.addSubview(self.searchBar)
        navigationItem.rightBarButtonItem = rightButtonWithImg(image: UIImage(named: "shaixuan")!)
        self.loadFatherDepartMentList()
        setUpRefresh()
       
       
    }
    
    func addobser()  {
        let NotifMycation2 = NSNotification.Name(rawValue:"refreshAddAddressVC")
        NotificationCenter.default.addObserver(self, selector: #selector(overChange(notif:)), name: NotifMycation2, object: nil)
    }
    
    
    //接受对象
    @objc func overChange(notif: NSNotification) {
        guard let model: CQDepartMentUserListModel = notif.object as? CQDepartMentUserListModel else { return }
        self.overTimeModel = model
        loadFenPeiLingQu(method: 1, custId: self.fenPeiModel?.customerId ?? "", userID: model.userId)
        
        
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func rightItemClick() {
        let filter =  QRGongHaiFilterVC()
        filter.selectArr = filterArr
        filter.clickClosure = {[unowned self] a,b,c,d,e in
            self.filterArr = e
            self.dealStatus = c
            self.followDate = d
            self.followStatus = b
            self.message = a!
            self.loadDatas(moreData: false)
        }
        
        self.navigationController?.pushViewController(filter, animated: true)
    }
    
}


extension QRGonghaiVc: UITableViewDataSource{

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = QRGongHaiCell(style: .default, reuseIdentifier: QRGonghaiVc.CellIdentifier)
        weak var weakSelf = self
        
        cell.gongHaiDelegate = weakSelf
        cell.model = dataArray[indexPath.row]
        cell.fenPei.isHidden = butHidden
        if butHidden == true {
            cell.lingQu.mas_remakeConstraints { (make) in
                make?.right.mas_equalTo()(cell.contentView)?.setOffset(-15)
                make?.centerY.mas_equalTo()(cell.contentView.mas_centerY)
                make?.width.mas_equalTo()(59)
                make?.height.mas_equalTo()(24)
            }
        }
        
        return cell
    }

    
}


extension QRGonghaiVc : QRGongHaiCellDelegate{
    
    func fenPeiOrLingQu(index: IndexPath, method: Int) {
      
       let mod = dataArray[index.row]
        if method == 1{
         //分配列表弹窗
            self.loadFatherDepartMent()
            self.fenPeiModel = mod
        }else if method == 2{
            SVProgressHUD.show()
            loadFenPeiLingQu(method: method, custId: mod.customerId, userID: "")
        }else{
            
        }
    }
    
    func loadFatherDepartMent(){
        let userId = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/mailList/getPersonDetails", type: .get, param: ["userId": userId], successCallBack: { (result) in

            self.departmentId = result["data"]["departmentId"].stringValue
            
            DispatchQueue.main.async {
                let vc = CQDepartmentVC.init()
                vc.departmentId = self.departmentId
                vc.toType = .fromContact
                vc.searchmode = "3"
                if self.overTimeModel != nil{
                    vc.hasSelectModelArr = [self.overTimeModel] as! [CQDepartMentUserListModel]
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }) { (error) in
            SVProgressHUD.showInfo(withStatus: "网络加载失败")
        }
    }
    
    func loadFatherDepartMentList(){
        let userId = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/mailList/getPersonDetails", type: .get, param: ["userId": userId], successCallBack: { (result) in
            
            self.departmentId = result["data"]["departmentId"].stringValue
            self.loadXiShu()
            
            
            
        }) { (error) in
            SVProgressHUD.showInfo(withStatus: "网络加载失败")
        }
    }
    
    func loadXiShu(){
        let userId = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/mailList/getChildDepartmentList",
            type: .get,
            param: ["departmentId":self.departmentId,
                    "groupId":"",
                    "searchmode":3,"userId":userId], successCallBack: { (result) in
               
            let num = result["data"]["userData"].arrayValue.count
            let num2 = result["data"]["childDepartmentData"].arrayValue.count
                        if num == 1 && num2 == 0 {
                            self.butHidden = true
                            self.table.reloadData()
                        }
                        
        }) { (error) in
            SVProgressHUD.showInfo(withStatus: "网络加载失败")
        }
    }
    
    
    func loadFenPeiLingQu(method:Int,custId:String,userID:String ){
       var userid = userID
        if method == 1{
             userid = userID
        }else{
             userid = STUserTool.account().userID
        }
        
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmCustomer/distributeOrClaim", type: .post, param: ["customerIds[]":custId,"mode":method,"userId":userid], successCallBack: { (result) in
            if method == 1 {
                DLog("分配")
                self.table.mj_header.beginRefreshing()
                SVProgressHUD.dismiss()
            }else if method == 2{
                self.loadDatas(moreData: false)
                SVProgressHUD.dismiss()
            }else{
                DLog("退回公海")
            }
            
            
        }) { (error) in
            SVProgressHUD.showInfo(withStatus: "分配失败")
        }
    }
    
}




extension QRGonghaiVc:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
                let detail = QRGongHaiDetailVC()
                let model = dataArray[indexPath.row]
                detail.customerId = model.customerId
                navigationController?.pushViewController(detail, animated:true)
    }
    //
}

//:MARK- 点击事件
extension QRGonghaiVc{
 
}

extension QRGonghaiVc:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //开始搜索并显示在table上
        
        if let tex = searchBar.text {
            self.name = tex
            self.table.mj_header.beginRefreshing()
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
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
       // self.loadDatas(moreData: false)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    
}

extension QRGonghaiVc :UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}



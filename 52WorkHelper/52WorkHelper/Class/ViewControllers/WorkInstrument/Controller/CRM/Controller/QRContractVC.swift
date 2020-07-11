//
//  QRContractVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/4.
//  Copyright © 2018年 chenqihang. All rights reserved.

//合同

import UIKit

class QRContractVC: SuperVC {

     static let CellIdentifier = "ContractCell_ID";
     static let CellIdentifier2 = "ContractCell_ID2";
    
    var businessId = ""
    var customerId = ""
    var name = ""
    //添加but
     var date = "startDate"

     lazy var searchBtn: UIButton = {
        let searchBtn = UIButton.init(type: .custom)
        searchBtn.frame = CGRect.init(x: AutoGetHeight(height: 13), y: AutoGetHeight(height: 5), width: kWidth - AutoGetWidth(width: 26), height: AutoGetHeight(height: 35))
       // searchBtn.setImage(UIImage.init(named: "knowledgeSearch"), for: .normal)
        searchBtn.setTitle("创建时间", for: .normal)
        searchBtn.setImage(UIImage(named: "j"), for: .normal)
        searchBtn.setTitleColor(kLyGrayColor, for: .normal)
        searchBtn.titleLabel?.font = kFontSize15
        searchBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left:  105, bottom: 0, right: 0)
        searchBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left:  -45, bottom: 0, right: 0)
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
    lazy var  backView = UIView()
    
    lazy var select : UIView = {
        let select = UIView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 45) + CGFloat(SafeAreaTopHeight) , width: kWidth, height: 80))
        //let gesture = UITapGestureRecognizer(target: select, action: #selector(cancel))
        let but1 = UIButton(title: "创建时间")
        let but2 = UIButton(title: "截止时间")
        
        let greyLine = UIView()
        
//        switch but1 {
//        case but1 == nil:
//            print("sss")
//        default:
//            break
//        }
        greyLine.backgroundColor = kLineColor
        but1.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        but2.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        but1.titleEdgeInsets = UIEdgeInsets.init(top: 0, left:  AutoGetWidth(width: 15), bottom: 0, right: 0)
        but2.titleEdgeInsets = UIEdgeInsets.init(top: 0, left:  AutoGetWidth(width: 15), bottom: 0, right: 0)
        greyLine.frame =  CGRect(x: 10, y: 40, width: kWidth, height: 0.5)
        but1.frame = CGRect(x: 10, y:0 , width: kWidth, height: 40)
        but2.frame = CGRect(x: 10, y: 40.5, width: kWidth, height: 40)
        but1.layer.shadowColor = UIColor.gray.cgColor
        but1.layer.shadowOffset = CGSize(width: 1, height: 1)
        but1.addTarget(self, action: #selector(searchStarDateClick), for: .touchUpInside)
        but2.addTarget(self, action: #selector(searchEndDateClick), for: .touchUpInside)
        select.addSubview(but1)
        select.addSubview(but2)
        select.addSubview(greyLine)
        select.backgroundColor = UIColor.white
        select.isHidden = true
        return select
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
        table.estimatedRowHeight = AutoGetHeight(height: 80)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.register(QRContractCell.self, forCellReuseIdentifier:QRContractVC.CellIdentifier )
        table.register(QRContractStartCell.self, forCellReuseIdentifier: QRContractVC.CellIdentifier2)
        return table
    }()
    //MARK:-
    //数据使用计算属性
    var pageNum = 1
    
    var dataArray = [QRContractModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        
        view.addSubview(select)
       // self.navigationController?.setNavigationBarHidden(false, animated: false)
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
    
    deinit {
    }
    
    func loadDatas(moreData: Bool) {
        if moreData {
            pageNum += 1
        } else {
            pageNum = 1
        }
        let userid = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/crmContract/getContractList" ,
            type: .get,
            param:  ["emyeId": userid,
                     "currentPage":pageNum ,
                     "pageSize":10,"orderByStartDateOrEndDate":date,"customerId":customerId,"businessId":businessId,"name":name],
            successCallBack: { [unowned self](result) in
                var tempArray = [QRContractModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = QRContractModel(jsonData: modalJson) else {
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
  
    
    
    
  
// MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        

        view.backgroundColor = UIColor.white
        title = "合同"
        view.addSubview(table)

        self.table.tableHeaderView = self.searchView
        self.searchView.addSubview(self.searchBtn)
        table.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem = rightButtonWithImg(image: UIImage(named: "s")!)
        setUpRefresh()
      //  loadDatas(moreData: false)

    }
   
    @objc override func rightItemClick() {
        select.isHidden = true
        let searchView = QRSearchVC()
        self.navigationController?.pushViewController(searchView, animated: true)
    }
    
    
    
}

extension QRContractVC : UITableViewDelegate{
    
    
}

extension QRContractVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(dataArray.count)
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if date == "startDate"{
            var cell :QRContractStartCell? = (tableView.dequeueReusableCell(withIdentifier: QRContractVC.CellIdentifier2, for: indexPath) as! QRContractStartCell) ;
            if cell == nil   {
                cell = QRContractStartCell(style: .default, reuseIdentifier: QRContractVC.CellIdentifier2)
            }
            
            
            cell?.model = dataArray[indexPath.row]
            return cell!
        }else{
            var cell :QRContractCell? = (tableView.dequeueReusableCell(withIdentifier: QRContractVC.CellIdentifier, for: indexPath) as! QRContractCell) ;
            if cell == nil   {
                cell = QRContractCell(style: .default, reuseIdentifier: QRContractVC.CellIdentifier)
            }
                
            
            cell?.model = dataArray[indexPath.row]
            return cell!
        }
        
//        var cell :QRContractCell? = (tableView.dequeueReusableCell(withIdentifier: QRContractVC.CellIdentifier, for: indexPath) as! QRContractCell) ;
//        if cell == nil   {
//            cell = QRContractCell(style: .default, reuseIdentifier: QRContractVC.CellIdentifier)
//        }
//            cell?.model = dataArray[indexPath.row]
//        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        select.isHidden = true
        let detail = QRContratDetaiVC()
        let model = dataArray[indexPath.row]
        detail.contratKey = model.entityId
        detail.clickClosure = {[unowned self] reflash in
            self.loadDatas(moreData: false)
        }
      navigationController?.pushViewController(detail, animated:true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }

}
//:MARK- 点击事件
extension QRContractVC{
   @objc func myContrat(){
        print("合同按钮")
    }
   @objc func searchClick()  {
        select.isHidden = !select.isHidden
    
        //背景view
    if select.isHidden == true {
        backView.removeFromSuperview()
    }else{
       
        backView.alpha = 0.1
        backView.backgroundColor = UIColor.black
        backView.frame =  CGRect(x: 0, y: select.tz_bottom, width: kWidth, height: kHeight-select.tz_bottom)
        let tap = UITapGestureRecognizer(target: self, action: #selector(removeSelector(tap:)))
        backView.addGestureRecognizer(tap)
        view.addSubview(backView)
    }
    
    
    }
    
    @objc func searchStarDateClick()  {
        select.isHidden = !select.isHidden
        searchBtn.setTitle("创建时间", for: .normal)
        //开始日期选择
////    let result = dataArray.sorted { (s1:QRContractModel, s2:QRContractModel) -> Bool in
////            return s1.startDate>s2.startDate
////        }
//      dataArray = result
        date = "startDate"
        self.table.mj_header.beginRefreshing()
      table.reloadData()
        self.backView.removeFromSuperview()
    }
    
    @objc func searchEndDateClick()  {
        select.isHidden = !select.isHidden
        searchBtn.setTitle("截止时间", for: .normal)
        //截止日期选择
//        let result = dataArray.sorted { (s1:QRContractModel, s2:QRContractModel) -> Bool in
//            return s1.startDate<s2.startDate
//        }
//        dataArray = result
        date = "endDate"
        self.table.mj_header.beginRefreshing()
        table.reloadData()
        self.backView.removeFromSuperview()
    }
    
    @objc func cancel()  {
        select.isHidden = !select.isHidden
    }
    
    @objc func removeSelector(tap:UITapGestureRecognizer){
        select.isHidden = !select.isHidden
        tap.view?.removeFromSuperview()
    }
    
  
}

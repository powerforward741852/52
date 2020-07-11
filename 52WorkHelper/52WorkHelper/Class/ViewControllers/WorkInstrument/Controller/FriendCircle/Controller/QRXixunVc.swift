//
//  QRXixunVc.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/6/3.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class QRXixunVc: SuperVC {


    //输入框
    var  inputViewEW : EwenTextView?
    var pageNum = 1
    var dataArray = [QRWorkMateCircleModel]()
    /*创建一个输入框*/
    var ewenTextView:EwenTextView!
    
    
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: kLeftDis, y: SafeAreaTopHeight, width: kHaveLeftWidth, height: kHeight-SafeAreaTopHeight ), style: UITableViewStyle.plain)
        if #available(iOS 11.0, *) {
            //            table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
            //            table.contentInset = UIEdgeInsetsMake(CGFloat(SafeAreaTopHeight), 0, CGFloat(SafeAreaBottomHeight), 0);
            //            table.scrollIndicatorInsets = table.contentInset;
        } else {
            //低于 iOS 9.0
            self.automaticallyAdjustsScrollViewInsets = false
        }
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
        table.allowsSelection = false
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.register(QRFriendCircleCell.self, forCellReuseIdentifier:"friendcellid")
        table.register(QRCommenCell.self, forCellReuseIdentifier:"xixunfriendFramecellid")
        
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.backgroundColor = kProjectBgColor
        //    table.estimatedRowHeight = AutoGetHeight(height: 130)
        //    table.rowHeight = UITableViewAutomaticDimension
        table.estimatedSectionHeaderHeight = 0;
        table.estimatedSectionFooterHeight = 0;
        table.estimatedRowHeight = 0;
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = kProjectBgColor
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        rightBtn.setImage(UIImage.init(named: "FriendAdd"), for: .normal)
        rightBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        rightBtn.addTarget(self, action: #selector(jumpIn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
       
        self.view.addSubview(self.table)
        setUpRefresh()
        NotificationCenter.default.addObserver(self, selector: #selector(reflashFriendCircle(notification:)), name: NSNotification.Name.init("reflashFriendCircle"), object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func reflashFriendCircle(notification:Notification){
        setUpRefresh()
    }
    
    
    @objc func jumpIn(){
        let vc = QRAddGenJinVC()
        vc.fromType = .fromXiXun
        vc.titleStr = "喜讯"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func setUpRefresh()  {
        
        let STHeader = CQRefreshHeader {[unowned self] in
            self.loadDatas(moreData: false)
        }
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
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/goodNews/getGoodNewsByPage" ,
            type: .get,
            param: ["userId":userID,
                    "currentPage":pageNum,
                    "rows":"10"],
            successCallBack: { (result) in
                var tempArray = [QRWorkMateCircleModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = QRWorkMateCircleModel(jsonData: modalJson) else {
                        return
                    }
                    modal.page = result["page"].intValue
                    tempArray.append(modal)
                }
                
                if self.pageNum > 1 {
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
extension QRXixunVc :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "xixunfriendFramecellid") as! QRCommenCell
        let mod = dataArray[indexPath.row]
        mod.manageType = 0
        cell.model = mod
        cell.rootVc = self
        cell.index = indexPath
        cell.clickClosure = { path in
            tableView.reloadRows(at: [path], with: UITableViewRowAnimation.none)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mod = dataArray[indexPath.row]
        return CGFloat(mod.rowHeight)
    }
   
}


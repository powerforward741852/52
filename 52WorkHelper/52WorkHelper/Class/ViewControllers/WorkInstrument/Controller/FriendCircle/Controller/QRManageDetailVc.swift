//
//  QRManageDetailVc.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/25.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRManageDetailVc: SuperVC {
    //筛选id 3为正常,0为我收到的,1为我发送到,2为我的动态
    var type : Int = 3
    weak var rootNav : QRCateManageVC?
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
        table.register(QRFriendCircleFrameCell.self, forCellReuseIdentifier:"friendFramecellidmanage")
        
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.backgroundColor = kProjectBgColor
        table.estimatedRowHeight = 0
        table.estimatedSectionHeaderHeight = 0;
        table.estimatedSectionFooterHeight = 0;
        //        table.rowHeight = UITableViewAutomaticDimension
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpRefresh()
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
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
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

}
extension QRManageDetailVc :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendFramecellidmanage", for: indexPath) as! QRFriendCircleFrameCell
        //   let cell = tableView.dequeueReusableCell(withIdentifier: "friendcellid", for: indexPath) as! QRFriendCircleCell
        let mod = dataArray[indexPath.row]
        mod.manageType = type
        cell.model = mod
        cell.MrootVc = self 
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
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        let mod = dataArray[indexPath.row]
//        return  CGFloat(mod.rowHeight)
//    }
    
//        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//            return true
//        }
//        func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//            return UITableViewCellEditingStyle.delete
//        }
//
//        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//
//        }
    
}
extension QRManageDetailVc{
    
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
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/circle/getCircleManagerByType" ,
            type: .get,
            param: ["userId":userID,
                    "currentPage":pageNum,
                    "rows":"10","type":type],
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
    
    
    func loadSigleLineDatas(moreData:Bool,page:Int,model:QRWorkMateCircleModel) {
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/circle/getCircleManagerByType" ,
            type: .get,
            param: ["userId":userID,
                    "currentPage":page,
                    "rows":"10","type":type],
            successCallBack: { (result) in
                var tempArray = [QRWorkMateCircleModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = QRWorkMateCircleModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                
                //                for (index,mod) in tempArray.enumerated(){
                //                    if model.circleArticleId == mod.circleArticleId {
                //                        for (index1,mod1) in self.dataArray.enumerated(){
                //                            mod1
                //                        }
                //                    }
                //                }
                
                //                if self.pageNum > 1 {
                //                    self.dataArray.append(contentsOf: tempArray)
                //                } else {
                //                    self.dataArray = tempArray
                //                }
                
                
        }) { (error) in
            
        }
    }
}

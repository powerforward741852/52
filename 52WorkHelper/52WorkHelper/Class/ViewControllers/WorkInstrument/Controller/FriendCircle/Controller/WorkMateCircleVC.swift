//
//  WorkMateCircleVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/19.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class WorkMateCircleVC: SuperVC {

    var pageNum = 1
    var dataArray = [CQWorkMateCircleModel]()
    var collectionData = [JSON]()
    var commentData = [CQWorkMateCircleModel]()
    var laudUserData = [JSON]()
    
    var laudHeight:CGFloat?
    var contentHeight:CGFloat?
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        //        table.backgroundColor = kProjectBgColor
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpRefresh()
        self.title = "同事圈"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.table)
        self.table.register(CQWorkMateCell.self, forCellReuseIdentifier: "CQWorkMateCellId")
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 19, height: 19))
        rightBtn.setImage(UIImage.init(named: "FriendAdd"), for: .normal)
        rightBtn.addTarget(self, action: #selector(publishClick), for: .touchUpInside)
        
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        //        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: self, action: nil)
        //        negativeSpacer.width = 10
        self.navigationItem.rightBarButtonItem = rightItem
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpRefresh()
    }
    
   @objc func publishClick()  {
        let vc = CQPublishToCircleVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
 
}


extension WorkMateCircleVC{
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
        STNetworkTools.requestData(URLString:"\(baseUrl)/circle/getCircleArticleByPage" ,
            type: .get,
            param: ["userId":userID,
                    "currentPage":pageNum,
                    "rows":"10"],
            successCallBack: { (result) in
                var tempArray = [CQWorkMateCircleModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQWorkMateCircleModel(jsonData: modalJson) else {
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

extension WorkMateCircleVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CQWorkMateCellId") as! CQWorkMateCell
        if cell.isEqual(nil) {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "CQWorkMateCellId") as! CQWorkMateCell
        }else{
            while cell.contentView.subviews.last != nil{
                cell.contentView.subviews.last?.removeFromSuperview()
            }
        }
        var commentArray = [CQWorkMateCircleModel]()
        let model = self.dataArray[indexPath.row]
        for modalJson in model.commentData {
             let commentModel = CQWorkMateCircleModel(jsonData: modalJson)
            commentArray.append(commentModel!)
        }
        self.commentData = commentArray
        
        self.collectionData = model.picurlData
    
        self.laudUserData = model.laudUserData
        
        cell.workmatecircleDeleagate = self
        cell.commentData = commentArray
        cell.collectData = self.collectionData
        cell.nameData = self.laudUserData
        cell.model = self.dataArray[indexPath.row]
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var collectionHeight:CGFloat?
        var commentHeight:CGFloat?
        var zanHeight:CGFloat?
        if 0 == self.collectionData.count  {
            collectionHeight = 0
        }else if 1 == self.collectionData.count {
            collectionHeight = AutoGetHeight(height: 180)
        }else if 2 == self.collectionData.count || 3 == self.collectionData.count {
            collectionHeight = AutoGetHeight(height: 79)
        }else if 4 == self.collectionData.count || 5 == self.collectionData.count || 6 == self.collectionData.count {
            collectionHeight = AutoGetHeight(height: 163)
        }else if 7 == self.collectionData.count || 8 == self.collectionData.count || 9 == self.collectionData.count {
            collectionHeight = AutoGetHeight(height: 247)
        }
        let model = self.dataArray[indexPath.row]
        let contentStr = model.articleContent
        self.contentHeight = self.getTextHeigh(textStr: contentStr, font: kFontSize15, width: kWidth - 2*kLeftDis - AutoGetWidth(width: 32) - AutoGetWidth(width: 12))
        
        var nameArr = [String]()
        var textStr = ""
        for i in 0..<model.laudUserData.count {
            let name = model.laudUserData[i].stringValue
            nameArr.append(name)
            
            if textStr.count > 1{
                textStr = textStr + "," + name
            }else{
                textStr =   name
            }
        }
        zanHeight = self.getTextHeigh(textStr: textStr, font: kFontSize14, width: kWidth - 2*kLeftDis - AutoGetWidth(width: 32) - AutoGetWidth(width: 12) - AutoGetWidth(width: 52.5)) + 12
        
        commentHeight = CGFloat(self.commentData.count) * AutoGetHeight(height: 26)
        return AutoGetHeight(height: 118) + commentHeight!+collectionHeight! + self.contentHeight! + zanHeight!
        
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

extension WorkMateCircleVC:CQWorkMateCircleDelegate{
    func zanRequest(index: IndexPath) {
//        let model = self.dataArray[index.row]
//        var laudMode = ""
//        if model.laudStatus == "1" {
//            laudMode = "0"
//        }else{
//            laudMode = "1"
//        }
//        let userID = STUserTool.account().userID
//        STNetworkTools.requestData(URLString: "\(baseUrl)/circle/saveCircleLaud",
//            type: .post,
//            param: ["userId":userID,
//                    "circleArticleId":model.circleArticleId,
//                    "laudMode":laudMode],
//            successCallBack: { (result) in
//                self.setUpRefresh()
//        }) { (error) in
//            
//        }
    }
    
    func commentRequest(index: IndexPath) {
        let model = self.dataArray[index.row]
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/circle/saveCircleComment",
            type: .post,
            param: ["userId":userID,
                    "circleArticleId":model.circleArticleId,
                    "commentContent":"12345"],
            successCallBack: { (result) in
                self.setUpRefresh()
        }) { (error) in
            
        }
    }
    
    
}

extension WorkMateCircleVC{
    //计算高度
    func getTextHeigh(textStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        let normalText: String = textStr
        let size = CGSize.init(width: width, height: 1000)
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context:nil).size
        return stringSize.height
    }
    //计算宽度
    func getTexWidth(textStr:String,font:UIFont,height:CGFloat) -> CGFloat {
        
        let normalText: String = textStr
        
        let size = CGSize.init(width: 1000, height: height)
        
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context:nil).size
        
        return stringSize.width
        
    }
}




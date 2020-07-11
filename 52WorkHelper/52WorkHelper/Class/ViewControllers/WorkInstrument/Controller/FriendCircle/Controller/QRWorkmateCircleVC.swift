//
//  QRWorkmateCircleVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/11/1.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRWorkmateCircleVC: SuperVC {
    //筛选id 3为正常,0为我收到的,1为我发送到,2为我的动态
    var type : Int = 3
    //输入框
    var  inputViewEW : EwenTextView?
    var pageNum = 1
    var dataArray = [QRWorkMateCircleModel]()
    /*创建一个输入框*/
    var ewenTextView:EwenTextView!
    
    var isFromApp = false
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: kLeftDis, y: SafeAreaTopHeight+100, width: kHaveLeftWidth, height: kHeight-SafeAreaTopHeight-100 ), style: UITableViewStyle.plain)
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
        table.register(QRFriendCircleFrameCell.self, forCellReuseIdentifier:"friendFramecellid")
        
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.backgroundColor = kProjectBgColor
    //    table.estimatedRowHeight = AutoGetHeight(height: 130)
    //    table.rowHeight = UITableViewAutomaticDimension
        table.estimatedSectionHeaderHeight = 0;
        table.estimatedSectionFooterHeight = 0;
        table.estimatedRowHeight = 0;
        return table
    }()
    
    lazy var btn1:UUButton = {
        
        let btn1 = UUButton()
        btn1.contentAlignment = UUContentAlignment.centerImageTop
        btn1.titleLabel?.font = kFontSize12
        btn1.frame =  CGRect(x: 0, y: 0, width: kWidth/2, height: 100)
        btn1.setTitle("生日祝福", for: UIControlState.normal)
        btn1.setImage(UIImage(named: "zhuf"), for: UIControlState.normal)
        btn1.setTitleColor(UIColor.black, for: UIControlState.normal)
        btn1.addTarget(self, action: #selector(zanAndWishAction(sender:)), for: UIControlEvents.touchUpInside)
        btn1.tag = 1
        btn1.setBackgroundImage(UIImage(named: "recty"), for: UIControlState.normal)
        return btn1
    }()
    lazy var btn2:UUButton = {
        let btn2 = UUButton()
        btn2.contentAlignment = UUContentAlignment.centerImageTop
        btn2.titleLabel?.font = kFontSize12
        btn2.frame = CGRect(x: kWidth/2, y: 0, width: kWidth/2, height: 100)
        btn2.setTitle("点赞", for: UIControlState.normal)
        btn2.setImage(UIImage(named: "dianz"), for: UIControlState.normal)
        btn2.setTitleColor(UIColor.black, for: UIControlState.normal)
        btn2.addTarget(self, action: #selector(zanAndWishAction(sender:)), for: UIControlEvents.touchUpInside)
        btn2.setBackgroundImage(UIImage(named: "recty"), for: UIControlState.normal)
        btn2.tag = 2
        return btn2
    }()
    lazy var headButView:UIView = {
        let head = UIView.init(frame: CGRect.init(x: 0, y: SafeAreaTopHeight, width: kWidth, height: 100 ))
        head.backgroundColor = UIColor.white
         head.addSubview(btn1)
         head.addSubview(btn2)
        return head
    }()
    
    var imagsArr = ["xiaol","xixun","srzhf","dianzans","xinsheng",]
    var titleArr = ["笑脸墙","喜讯","生日祝福","点赞","心声"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpRefresh()
        self.title = "同事圈"
        self.view.backgroundColor = kProjectBgColor
      //  view.addSubview(headButView)
        let butView = Bundle.main.loadNibNamed("QRFriendTitlescrollView", owner: nil, options: nil)?.last as! QRFriendTitlescrollView
        butView.frame =  CGRect(x: 0, y: SafeAreaTopHeight, width: kWidth, height: 100)
        butView.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        butView.flowLayout.minimumLineSpacing = 0
        butView.flowLayout.minimumInteritemSpacing = 0
        butView.flowLayout.itemSize = CGSize(width: kWidth/5, height: 100)
        butView.imgArr = imagsArr
        butView.titleArr = titleArr
        butView.collect.isScrollEnabled = false
        butView.clickClosure = {[unowned self] indexpath in
        if indexpath.row == 0{
            //笑脸墙
            let vc = CQSmileWallVC()
            vc.title = "笑脸墙"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexpath.row == 1{
            //喜讯
            let vc = QRXixunVc()
             vc.title = "喜讯"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexpath.row == 2{
            //生日祝福
            let vc = QRBirthdayWishVC()
            vc.title = "生日祝福"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexpath.row == 3{
            //点赞
            let vc = QRZanVC()
            vc.title = "点赞"
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            //心声
            let vc = QRXinShengVC()
            vc.title = "心声"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        }
        view.addSubview(butView)

        self.view.addSubview(self.table)
//        if type == 3{
//            self.table.tableHeaderView = headButView
//        }else{
//           self.table.tableHeaderView = nil
//        }
        
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 44))
        rightBtn.setImage(UIImage.init(named: "FriendAdd"), for: .normal)
        rightBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        rightBtn.addTarget(self, action: #selector(publishClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        
        let manageBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44))
        manageBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        manageBtn.setTitle("管理", for: UIControlState.normal)
        manageBtn.titleLabel?.font = kFontSize17
        manageBtn.setTitleColor(kBlueColor, for: UIControlState.normal)
        manageBtn.addTarget(self, action: #selector(manageClick), for: .touchUpInside)
        let managebarBtn = UIBarButtonItem.init(customView: manageBtn)
        self.navigationItem.rightBarButtonItems = [rightItem,managebarBtn]
         NotificationCenter.default.addObserver(self, selector: #selector(refreshUI), name: NSNotification.Name.init("refreshFriendView"), object: nil)
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
        if self.isFromApp {
            self.navigationItem.leftBarButtonItem = self.barBackButton()
        }
    }
  
    @objc func zanAndWishAction(sender:UUButton){
        if sender.tag == 1{
           let vc = QRBirthdayWishVC()
            vc.title = "生日祝福"
           self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = QRZanVC()
            vc.title = "点赞"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc func refreshUI()  {
        self.setUpRefresh()
    }
    @objc func publishClick()  {
            let vc = CQPublishToCircleVC()
            self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func manageClick()  {
         let vc = QRCateManageVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension QRWorkmateCircleVC :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendFramecellid") as! QRFriendCircleFrameCell
       // let cell = tableView.dequeueReusableCell(withIdentifier: "friendcellid") as! QRFriendCircleCell
        let mod = dataArray[indexPath.row]
        mod.manageType = 3
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
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        let mod = dataArray[indexPath.row]
//        return  CGFloat(mod.rowHeight)
//    }
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//       let mod = dataArray[indexPath.row]
//        mod.rowHeight = cell.frame.size.height
//
//    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return UITableViewCellEditingStyle.delete
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        
//    }
}

extension QRWorkmateCircleVC:flashSingleLineDelegete{
    func QRFriendCircleFrameCellReflashSingleLine(index:IndexPath) {
        self.table.reloadRows(at: [index], with: UITableViewRowAnimation.none)
    }
    
    
}

extension QRWorkmateCircleVC{
   
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
        STNetworkTools.requestData(URLString:"\(baseUrl)/circle/getCircleArticleByPage" ,
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
    
    
    func loadSigleLineDatas(moreData:Bool,page:Int,model:QRWorkMateCircleModel) {
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/circle/getCircleArticleByPage" ,
            type: .get,
            param: ["userId":userID,
                    "currentPage":page,
                    "rows":"10"],
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

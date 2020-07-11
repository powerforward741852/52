//
//  QRContratDetaiVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/4.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRContratDetaiVC: SuperVC {
    var isDle = "0"
    var contratKey : String = ""
    var dataArray = [QRGoodListModel]()
    var attachDataArray = [QRDetailAttachmentModel]()
    var model : QRContratctDetailModel?
    
    //声明闭包
    typealias clickBtnClosure = (_ text:String ) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    
    static let reuseid = "detail"
    static let reuseid2 = "detail2"
    
    lazy var table:UITableView = {
//        let tab = UITableView(frame:  )
        let tab = UITableView(frame: CGRect(x:0 , y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.grouped)
        if #available(iOS 11.0, *) {
            tab.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
            tab.contentInset = UIEdgeInsetsMake(CGFloat(SafeAreaTopHeight), 0, CGFloat(SafeAreaBottomHeight), 0);
            tab.scrollIndicatorInsets = tab.contentInset;
            
        } else {
            //低于 iOS 9.0
        }
        
        
        tab.delegate = self
        tab.dataSource = self
        tab.backgroundColor = UIColor.white
        tab.register(QRContrectDetailCell.self, forCellReuseIdentifier: QRContratDetaiVC.reuseid)
        tab.register(QRHeadDetailCell.self, forCellReuseIdentifier: QRContratDetaiVC.reuseid2)
        tab.estimatedRowHeight = 100
        tab.rowHeight = UITableViewAutomaticDimension
        tab.separatorStyle = UITableViewCellSeparatorStyle.none
        return tab
    }()
    
    lazy var kehu:UILabel = {
        let lab = UILabel(title: "客户:", textColor: kLyGrayColor, fontSize: 15)
        return lab
    }()
    lazy var kehuName:UILabel = {
        let lab1 = UILabel(title: "xxxxxx", textColor: kLyGrayColor, fontSize: 15)
        return lab1
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpRefresh()
        title = "合同详情"
        view.backgroundColor = UIColor.white
        view.addSubview(table)
       navigationItem.rightBarButtonItem = rightButtonWithImg(image: UIImage(named:"gd")!)
        loadDetailMessage()
    
        NotificationCenter.default.addObserver(self, selector: #selector(updateImages(notification:)), name: NSNotification.Name(rawValue: "imagsCellID"), object: nil)
    }
    func setUpRefresh() {
        // MARK:header
        let STHeader = CQRefreshHeader {[unowned self] in
            self.loadDetailMessage()
        }
        // MARK:footer
        let STFooter = CQRefreshFooter {[unowned self] in
            self.loadDetailMessage()
        }
        self.table.mj_header = STHeader
        self.table.mj_footer = STFooter
        
    }
    
 
    @objc func updateImages(notification:NSNotification){
        
        let index = notification.userInfo?["index"] as? Int
        let imgs = notification.userInfo?["imags"] as? [String]
        if let index = index ,let imags = imgs, imags.count > 0{
            let previewVC = ImagePreViewVC(images: imags, index: index)
            self.navigationController?.pushViewController(previewVC, animated: true)
        }
    }
   
    
    
    
    
    @objc override func rightItemClick() {
        initSelectView()
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func loadDeleteContract()  {
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmContract/deleteContract", type: .get, param: ["contractId":contratKey,
                                                                                                                   "emyeId":userID], successCallBack: { (result) in
                                                                                                                    
                                                                                                                    if   result["success"].boolValue{
                                                                                                                        SVProgressHUD.showInfo(withStatus: "删除成功")
                                                                                                                    }
                                                                                                                    self.clickClosure!("reflash")
                                                                                                                    self.navigationController?.popViewController(animated: true)
                                                                                                                    
        }) { (error) in
            
            SVProgressHUD.showInfo(withStatus: "删除失败")
            
            
        }
        
        
    }
    func initSelectView()  {
        let selectView = QRDeleteView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight))
        selectView.cqSelectDelegate = self
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.addSubview(selectView)
        
    }
    
    
    func loadDetailMessage() {
            self.loadingPlay()
         let userid = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmContract/getContractInfo", type: .get, param: ["emyeId": userid,
                                                                                                            "contractId":contratKey
            ], successCallBack: { (result) in
        
                let mod = QRContratctDetailModel(jsonData: result["data"])
                self.model = mod!
                
                let goodList  =  result["data"]["commodityList"].arrayValue
              //商品列表
                var tepArr =  [QRGoodListModel]()
                for item in goodList{
                    let moda = QRGoodListModel .init(jsonData: item)
                    tepArr.append(moda!)
                }
                self.dataArray = tepArr
                self.table.reloadData()
                //附件列表
                let attachList  =  result["data"]["attachmentList"].arrayValue
                var tepArr1 =  [QRDetailAttachmentModel]()
                for item in attachList{
                    let moda = QRDetailAttachmentModel .init(jsonData: item)
                    tepArr1.append(moda!)
                }
                self.attachDataArray = tepArr1
                
              self.isDle = result["data"]["isDelete"].stringValue
              self.kehuName.text = result["data"]["customerName"].stringValue
               self.loadingSuccess()
                self.table.mj_header.endRefreshing()
                self.table.mj_footer.endRefreshing()
                
        }) { (error) in
            DLog(error)
            self.loadingSuccess()
            self.table.mj_header.endRefreshing()
            self.table.mj_footer.endRefreshing()
            SVProgressHUD.showSuccess(withStatus: "网络出错")
        }
        
    
    }
}

extension QRContratDetaiVC :UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        //跳入商品详情
        if indexPath.section == 1 {
            //进入商品列表
            let goodlist = QRGoodsListVC()
           // goodlist.contratKey = dataArray[indexPath.row].commodityId
            goodlist.contratKey = contratKey
            navigationController?.pushViewController(goodlist, animated: true)
            
        }
        
    }
}
extension QRContratDetaiVC :UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return dataArray.count
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 46
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 46
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1{
            let titleview = UIView(frame: CGRect(x: 0, y: 0, width: kScreenSize.width, height: 46))
            let but = UIButton()
            but.setTitle("标地", for: .normal)
            but.titleLabel?.font = kFontSize15
            but.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            but.setTitleColor(UIColor.black, for: .normal)
            but.setImage(UIImage(named: "sp"), for: .normal)
            but.frame =  CGRect(x: 0, y: 13, width: 100, height: 33)
            let greyview = UIView(frame:  CGRect(x: 0, y: 0, width: kWidth, height: 13))
            greyview.backgroundColor = kProjectBgColor
            titleview.addSubview(but)
            titleview.addSubview(greyview)
            return titleview
        }else{
            
            return  UIView(frame: CGRect(x: 0, y: 0, width: kScreenSize.width, height: 0))
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 0 {
//            let titleview = UIView(frame: CGRect(x: 0, y: 0, width: kScreenSize.width, height: 46))
//            let but = UIButton()
//            but.setTitle("商品", for: .normal)
//            but.titleLabel?.font = kFontSize15
//            but.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
//            but.setTitleColor(UIColor.black, for: .normal)
//            but.setImage(UIImage(named: "sp"), for: .normal)
//            but.frame =  CGRect(x: 0, y: 13, width: 100, height: 33)
//            let greyview = UIView(frame:  CGRect(x: 0, y: 0, width: kWidth, height: 13))
//            greyview.backgroundColor = kProjectBgColor
//            titleview.addSubview(but)
//            titleview.addSubview(greyview)
            let titleview = UIView(frame: CGRect(x: 0, y: 0, width: kScreenSize.width, height: 0))
            return titleview
        }else{
            
            let titleview = UIView(frame: CGRect(x: 0, y: 0, width: kScreenSize.width, height: 36))
            titleview.addSubview(kehu)
            titleview.addSubview(kehuName)
            kehuName.mas_makeConstraints({ (make) in
                make?.right.mas_equalTo()(titleview)?.setOffset(-AutoGetWidth(width: 15))
                make?.centerY.mas_equalTo()(titleview)
            })
            kehu.mas_makeConstraints({ (make) in
                make?.right.mas_equalTo()(kehuName.mas_left)
                make?.centerY.mas_equalTo()(titleview)
            })
            
            return titleview
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell :QRHeadDetailCell? = (tableView.dequeueReusableCell(withIdentifier: QRContratDetaiVC.reuseid2, for: indexPath) as! QRHeadDetailCell) ;
            cell?.model = model
            cell?.modeld = attachDataArray
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            return cell!
            
        }else{
            var cell :QRContrectDetailCell? = (tableView.dequeueReusableCell(withIdentifier: QRContratDetaiVC.reuseid, for: indexPath) as! QRContrectDetailCell) ;
            if cell == nil   {
                cell = QRContrectDetailCell(style: .default, reuseIdentifier: QRContratDetaiVC.reuseid)
            }
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
               cell?.model = dataArray[indexPath.row]
            return cell!
        }
        
        
    }
    
    
}

extension QRContratDetaiVC{
    @objc func shangpin()  {
        
        
    }
}

extension QRContratDetaiVC :QRDeleteViewDelegate {
    
    func pushToDetailThroughType(btn: UIButton) {
        if 400 == btn.tag{
            //删除
            loadDeleteContract()
        }
    }
    
}

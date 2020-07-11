//
//  QRZanVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/14.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRZanVC: SuperVC {
    //选中联系人model
    var overTimeModel:CQDepartMentUserListModel?
    var dataArr = [QRZanModel]()
    //前三名
    var dataArray = [QRZanlistModel]()
    var pageNum = 1
    //输入框
    var  inputViewEW : EwenTextView?
    //排行榜view
    var paiHangView : QRPaiMingView?
    
    
    
    lazy var headView : UIView = {
        let headView = UIView(frame:  CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 194)))
        headView.backgroundColor = UIColor.white
        headView.addSubview(paiHangBangBtn)
        return headView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width: (kWidth-AutoGetWidth(width: 60))/3, height: AutoGetHeight(height: 120))
        layOut.minimumLineSpacing = 0
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        layOut.sectionInset = UIEdgeInsets(top: 0, left: AutoGetWidth(width: 30), bottom: 0, right: AutoGetWidth(width: 30))
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 120)), collectionViewLayout: layOut)
        
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(QRBigWishCell.self, forCellWithReuseIdentifier: "birthId")
        return collectionView
    }()
    
    
    lazy var paiHangBangBtn : UIButton = {
        let paiHangBangBtn = UIButton(frame:  CGRect(x: 0, y: AutoGetHeight(height: 154), width: kWidth, height: AutoGetHeight(height: 40)))
        paiHangBangBtn.setTitle("查看获赞排行榜 >", for: UIControlState.normal)
        paiHangBangBtn.titleEdgeInsets = UIEdgeInsets(top: -8, left: 0, bottom: 8, right: 0)
        paiHangBangBtn.titleLabel?.font = kFontSize13
        paiHangBangBtn.setTitleColor(kBlueC, for: UIControlState.normal)
        paiHangBangBtn.setBackgroundImage(UIImage(named: "recty"), for: UIControlState.normal)
        paiHangBangBtn.addTarget(self, action: #selector(jumpPaihb), for: UIControlEvents.touchUpInside)
        return paiHangBangBtn
    }()
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: SafeAreaTopHeight, width: kWidth, height: kHeight-SafeAreaTopHeight ), style: UITableViewStyle.plain)
        if #available(iOS 11.0, *) {
//            table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
//            table.contentInset = UIEdgeInsetsMake(CGFloat(SafeAreaTopHeight), 0, CGFloat(SafeAreaBottomHeight), 0);
//            table.scrollIndicatorInsets = table.contentInset;
        } else {
            //低于 iOS 9.0
            self.automaticallyAdjustsScrollViewInsets = false
        }
        table.allowsSelection = false
        table.register(QRZanDetailCell.self, forCellReuseIdentifier: "zandetailcellid")
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
//        table.estimatedRowHeight = 107
//        table.rowHeight = UITableViewAutomaticDimension
        
        table.estimatedRowHeight = 0
        table.estimatedSectionFooterHeight = 0
        table.estimatedSectionHeaderHeight = 0
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //赋值前3名
        let mod1 = QRZanlistModel()
        mod1.realName = "none"
        mod1.headImage = "personDefaultIcon"
        let mod2 = QRZanlistModel()
        mod2.realName = "none"
        mod2.headImage = "personDefaultIcon"
        let mod3 = QRZanlistModel()
        mod3.realName = "none"
        mod3.headImage = "personDefaultIcon"
        dataArray.append(mod1)
        dataArray.append(mod2)
        dataArray.append(mod3)
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        rightBtn.setImage(UIImage.init(named: "FriendAdd"), for: .normal)
        rightBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        rightBtn.addTarget(self, action: #selector(jumpIn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
       
        view.addSubview(table)
        table.tableHeaderView = headView
       // headView.addSubview(collectionView)
        
        let paiHangView = (Bundle.main.loadNibNamed("QRPaiHangView", owner: nil, options: nil)?.last) as! QRPaiMingView
        paiHangView.frame =  CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 154))
        self.paiHangView = paiHangView
        headView.addSubview(paiHangView )
       // paiHangView.setData(dataSource: dataArray)
        addobser()
        let NotifMycation2 = NSNotification.Name(rawValue:"refreshZanVC")
        NotificationCenter.default.addObserver(self, selector: #selector(reflashZanVC), name: NotifMycation2, object: nil)
        setUpRefresh()
      //  loadPaiHangDatas(moreData: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // setUpRefresh()
         loadPaiHangDatas(moreData: false)
    }
    func addobser()  {
        let NotifMycation2 = NSNotification.Name(rawValue:"refreshAddAddressVC")
        NotificationCenter.default.addObserver(self, selector: #selector(overChange(notif:)), name: NotifMycation2, object: nil)
    }
    
    @objc func reflashZanVC(){
        setUpRefresh()
    }
    
    @objc func jumpPaihb(){
        let vc = QRZanlistVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func jumpIn(){
       //let vc = AddressBookVC.init()
        let vc = QRAddressBookVC.init()
        vc.toType = .fromContact
        if self.overTimeModel != nil{
            vc.hasSelectModelArr = [self.overTimeModel] as! [CQDepartMentUserListModel]
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
    
    //接收加班人
    @objc func overChange(notif: NSNotification) {
        guard let model: CQDepartMentUserListModel = notif.object as? CQDepartMentUserListModel else { return }
        self.overTimeModel = model
        
        let vc = CQPublishToCircleVC()
        vc.isFromZan = true
        vc.mod = model
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    ///加载前三名
    func loadPaiHangDatas(moreData:Bool) {
        if moreData {
            pageNum += 1
        } else {
            pageNum = 1
        }
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/admir/getRankList" ,
            type: .get,
            param: ["userId":userID,
                    "currentPage":pageNum,
                    "rows":"10"],
            successCallBack: { (result) in
                var tempArray = [QRZanlistModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = QRZanlistModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                for (index,value) in tempArray.enumerated(){
                    if index == 0{
                        self.dataArray[1] = value
                    }else if index == 1{
                        self.dataArray[0] = value
                    }else if index == 2 {
                        self.dataArray[2] = value
                    }
                }
              //  tempArray.removeAll()
                if tempArray.count == 0{
                    self.headView.frame = CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 0))
                    self.paiHangView?.frame = CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height:0))
                    self.paiHangBangBtn.frame = CGRect(x: 0, y: AutoGetHeight(height: 0), width: kWidth, height: AutoGetHeight(height: 0))
                    self.table.tableHeaderView = self.headView
                }else{
                    self.headView.frame = CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 194))
                    self.paiHangView?.frame = CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 154))
                    self.paiHangBangBtn.frame = CGRect(x: 0, y: AutoGetHeight(height: 154), width: kWidth, height: AutoGetHeight(height: 40))
                    self.table.tableHeaderView = self.headView
                }
                self.paiHangView?.setData(dataSource: self.dataArray)
            // self.collectionView.reloadData()
        }) { (error) in
         
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension QRZanVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "zandetailcellid") as! QRZanDetailCell
          cell.modelc = dataArr[indexPath.row]
          cell.rootVc = self
          cell.index = indexPath
          cell.clickClosure = { path in
            tableView.reloadRows(at: [path], with: UITableViewRowAnimation.none)
          }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mod = dataArr[indexPath.row]
        return mod.rowHeight
        
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
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/admir/getAdmirByPage" ,
            type: .get,
            param: ["currentPage":pageNum,
                    "rows":10,"userId":userID],
            successCallBack: { (result) in
                var tempArray = [QRZanModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = QRZanModel(jsonData: modalJson) else {
                      
                        return
                    }
                    tempArray.append(modal)
                    modal.page = result["page"].intValue
                }
                
                
                if self.pageNum > 1 {
                    self.dataArr.append(contentsOf: tempArray)
                } else {
                    self.dataArr = tempArray
                }
                //刷新表格
                self.table.mj_header.endRefreshing()
                self.table.mj_footer.endRefreshing()
                self.table.reloadData()
                //分页控制
                let total = result["total"].intValue
                if self.dataArr.count == total {
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

extension QRZanVC:UICollectionViewDataSource,UICollectionViewDelegate{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "birthId", for: indexPath)as! QRBigWishCell
    //    let cell = QRBigWishCell()
        cell.backgroundColor = UIColor.white
        let mod = dataArray[indexPath.row]
        if let name = mod.realName{
            cell.nameLable.text = name
        }else{
            cell.nameLable.text = ""
        }
        cell.wishBut.isHidden = true
        let imgV = UIImageView()
      
        cell.iconImg.addSubview(imgV)
        if indexPath.row == 0{
            cell.iconImg.image = UIImage(named: "yinp")
            cell.iconImg.mas_updateConstraints { (make) in
                make?.centerY.mas_equalTo()(cell.contentView.mas_centerY)?.setOffset(-10)
                make?.width.mas_equalTo()(kWidth/3/2-4)
                make?.height.mas_equalTo()(kWidth/3/2-4)
            }
            imgV.mas_updateConstraints { (make) in
                make?.left.mas_equalTo()(cell.iconImg.mas_left)?.setOffset(2)
                make?.top.mas_equalTo()(cell.iconImg.mas_top)?.setOffset(2)
                make?.width.mas_equalTo()(kWidth/3/2-8)
                make?.height.mas_equalTo()(kWidth/3/2-8)
            }
            imgV.layer.cornerRadius = (kWidth/3/2-8)/2
            imgV.clipsToBounds = true

        }else if indexPath.row == 1{
            cell.iconImg.image = UIImage(named: "gold")
            cell.iconImg.mas_updateConstraints { (make) in
                make?.centerY.mas_equalTo()(cell.contentView.mas_centerY)?.setOffset(-10)
                make?.width.mas_equalTo()(kWidth/3/2+5)
                make?.height.mas_equalTo()(kWidth/3/2+5)
            }
            imgV.mas_updateConstraints { (make) in
                make?.left.mas_equalTo()(cell.iconImg.mas_left)?.setOffset(2)
                make?.top.mas_equalTo()(cell.iconImg.mas_top)?.setOffset(2)
                make?.width.mas_equalTo()(kWidth/3/2+5-4)
                make?.height.mas_equalTo()(kWidth/3/2+5-4)
            }
            imgV.layer.cornerRadius = (kWidth/3/2+1)/2
            imgV.clipsToBounds = true
        }else if indexPath.row == 2{
             cell.iconImg.image = UIImage(named: "tong")
            cell.iconImg.mas_updateConstraints { (make) in
                make?.centerY.mas_equalTo()(cell.contentView.mas_centerY)?.setOffset(-10)
                make?.width.mas_equalTo()(kWidth/3/2-4)
                make?.height.mas_equalTo()(kWidth/3/2-4)
            }
            imgV.mas_updateConstraints { (make) in
                make?.left.mas_equalTo()(cell.iconImg.mas_left)?.setOffset(2)
                make?.top.mas_equalTo()(cell.iconImg.mas_top)?.setOffset(2)
                make?.width.mas_equalTo()(kWidth/3/2-8)
                make?.height.mas_equalTo()(kWidth/3/2-8)
            }
            imgV.layer.cornerRadius = (kWidth/3/2-8)/2
            imgV.clipsToBounds = true
        }
        imgV.image = UIImage(named: "personDefaultIcon")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

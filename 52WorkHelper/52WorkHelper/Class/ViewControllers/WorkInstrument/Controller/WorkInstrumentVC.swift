//
//  WorkInstrumentVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/4/23.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit


class WorkInstrumentVC: SuperVC {

    var titleArr = [[String]]()
    var imageArr = [[String]]()
    var infoIdArr = [String]()
    
    //微网站 1 媒体报道2
   // var siteType = ""
    var microTitleArr = [[String]]()
    var mtbdid = ""
// MARK: - 懒加载
    var departmentId = ""
   var scheduleHidden = false
    var indexStart:IndexPath?
    
    
    lazy var collectionView: UICollectionView = {
        let layOut = QRYuanjiaoFlowLayout.init()
        layOut.itemSize = CGSize.init(width: (kHaveLeftWidth-30)/4, height: AutoGetHeight(height: 84))
        layOut.minimumLineSpacing = 0
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        layOut.headerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 38))
       // layOut.footerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 11))
        let collectionView = UICollectionView.init(frame: CGRect.init(x: kLeftDis, y: SafeAreaTopHeight, width: kHaveLeftWidth, height: kHeight - SafeAreaTopHeight - 49), collectionViewLayout: layOut)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        collectionView.register(WorkInstrumentCell.self, forCellWithReuseIdentifier: "workInstrumentCell")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "WorkInstrumnetHeader")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "WorkInstrumnetForFooter")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "WorkInstrumnetScheduleForFooter")
        
        let longPresssG = UILongPressGestureRecognizer(target: self, action: #selector(changeItemGesture(longpress:)))
        collectionView.addGestureRecognizer(longPresssG)
        
        return collectionView
    }()
    
    
    @objc func changeItemGesture(longpress:UILongPressGestureRecognizer){
        
        
           switch longpress.state {
           case UIGestureRecognizer.State.began:
                indexStart = self.collectionView.indexPathForItem(at: longpress.location(in: self.collectionView))
               if let indexPath = indexStart{
                   let cell = self.collectionView.cellForItem(at: indexPath) as! WorkInstrumentCell
                   self.view.bringSubview(toFront: cell)
                   self.collectionView.beginInteractiveMovementForItem(at: indexPath)
               }
//               self.isEdit = true
//               self.editBut?.isHidden = false
//               NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeDeleteState"), object: nil, userInfo: ["isEdit":true])
               print("began")
               break
           case UIGestureRecognizer.State.changed:
              
                 let indexChange = self.collectionView.indexPathForItem(at: longpress.location(in: self.collectionView))
                  print(indexChange?.section,indexStart?.section)
                 if indexChange?.section == indexStart?.section{
                     self.collectionView.updateInteractiveMovementTargetPosition(longpress.location(in: self.collectionView))
                 }else{
                        print("out")
                    break
                    self.collectionView.endInteractiveMovement()
                 }
           
               print("change")
               break
           case UIGestureRecognizer.State.ended:
               self.collectionView.endInteractiveMovement()
               print("end")
               break
           default:
               self.collectionView.cancelInteractiveMovement()
               print("default")
               break
               
           }
       }
    
    var DBnames = ["考勤","外勤","请假","审批","日程","位置","任务","通知公告","汇报","派车","会议室预订","员工之星","客户","商品","合同","商机","客户公海","名片夹","公司资料","产品资料","技术资料","个人资料","微网站","媒体报道"]
    var DBImages = ["WIHasWork","WISignIn","WILeave","WIDWShenpi","WIDWDate","workInstrumentLocation","WIDWTask","WIDWNotice","WIDWReport","WIDWCar","WIDWRoom","ygzx","CRM0","CRM2","CRM3","CRM1","CRM4","mingpjia","WIPublic0","WIPublic2","WIPublic1","WIPublic3","WIPublic4","mtbd"]
    
    
   func initArrayDateBase(){
    
    for(index,_) in DBnames.enumerated(){
        let tempP = Person()
        tempP.name = DBnames[index]
        tempP.imageStr = DBImages[index]
        tempP.funcId = index
        WHC_ModelSqlite.insert(tempP)
    }
    
    
    }
    
    
    func loadAllitems(){
        SVProgressHUD.show()
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/benchitem/getAll" ,
              type: .get,
              param: nil,
              successCallBack: { (result) in
                
              
                SVProgressHUD.dismiss()
                 
          }) { (error) in
              SVProgressHUD.dismiss()
          }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllitems()
        
        self.view.backgroundColor = kProjectBgColor
        self.title = "工作台"
        titleArr = [["考勤","外勤","请假","审批"], ["考勤","外勤","请假",/*"出差"*/"位置"],
                    ["日程","审批","任务","通知公告","汇报","派车","会议室预订","员工之星"],
                    ["客户","商品","合同","商机","客户公海","名片夹"],
                    ["公司资料","产品资料","技术资料","个人资料","微网站","媒体报道"]]
        
        imageArr = [["WIHasWork","WISignIn","WILeave","WIDWShenpi"],["WIHasWork","WISignIn","WILeave","workInstrumentLocation"],
                    ["WIDWDate","WIDWShenpi","WIDWTask","WIDWNotice","WIDWReport","WIDWCar","WIDWRoom","ygzx"],
                    ["CRM0","CRM2","CRM3","CRM1","CRM4","mingpjia"],
            ["WIPublic0","WIPublic2","WIPublic1","WIPublic3","WIPublic4","mtbd"]]
        
        
        
        var result = WHC_ModelSqlite.query(Person.self) as! [Person]
        if result.count == 0{
            //添加数据库
            initArrayDateBase()
        }else{
            
        }
        
        result = (WHC_ModelSqlite.query(Person.self) as! [Person])
        let rr = result.sorted { (k1, k2) -> Bool in
            return k1.lookTimeCount>k2.lookTimeCount
        }
        
        let rrr = rr.sorted { (k1, k2) -> Bool in
            if k1.lookTimeCount == k2.lookTimeCount{
               return k1.lookTime>k2.lookTime
            }else{
               return k1.lookTimeCount > k2.lookTimeCount
            }
        }
        
//        /asc
//        let rr = (WHC_ModelSqlite.query(Person.self, order: "by lookTimeCount desc")) as! [Person]
        
        let usuallyFunc = rrr.prefix(upTo: 4)
        var tempName = [String]()
        var tempimage = [String]()
        for (_,val) in usuallyFunc.enumerated(){
            tempName.append(val.name)
            tempimage.append(val.imageStr)
        }
        titleArr[0] = tempName
        imageArr[0] = tempimage
        
        
        self.view.addSubview(self.collectionView)
        self.automaticallyAdjustsScrollViewInsets = false
        self.getCompanyInfoList()
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24))
        rightBtn.setImage(UIImage.init(named: "tongshiquan"), for: .normal)
        rightBtn.addTarget(self, action: #selector(friendCircleClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
//        getSchedulePlanByMonthListRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var result = WHC_ModelSqlite.query(Person.self) as! [Person]
        let rr = result.sorted { (k1, k2) -> Bool in
            return k1.lookTimeCount>k2.lookTimeCount
        }
        let rrr = rr.sorted { (k1, k2) -> Bool in
            if k1.lookTimeCount == k2.lookTimeCount{
                return k1.lookTime>k2.lookTime
            }else{
                return k1.lookTimeCount > k2.lookTimeCount
            }
        }
//        let rr = (WHC_ModelSqlite.query(Person.self, order: "by lookTimeCount desc")) as! [Person]
        let usuallyFunc = rrr.prefix(upTo: 4)
        var tempName = [String]()
        var tempimage = [String]()
        for (_,val) in usuallyFunc.enumerated(){
            tempName.append(val.name)
            tempimage.append(val.imageStr)
        }
        titleArr[0] = tempName
        imageArr[0] = tempimage
        
        self.collectionView.reloadData()
    }
    
// MARK: - 点击事件
    
    @objc func friendCircleClick()  {
        //let vc = CQFriendCircleVC()
        //let vc = QRTongJiVC()
        let vc = QRWorkmateCircleVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
        
       
        
    }
    
// MARK: - 数据加载
 
    func getSchedulePlanByMonthListRequest() {
        SVProgressHUD.show()
        let userID = STUserTool.account().userID
       
            let now = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM"
           let data = dateFormat.string(from: now)
      STNetworkTools.requestData(URLString:"\(baseUrl)/schedule/getSchedulePlanByMonthList" ,
            type: .get,
            param: ["userId":userID,
                    "loginUserId":userID,
                    "date":data],
            successCallBack: { (result) in
                if !result["data"]["isHaveAuthority"].boolValue{
                    
                    self.scheduleHidden = true
                    let layOut = QRYuanjiaoFlowLayout.init()
                    layOut.itemSize = CGSize.init(width: (kHaveLeftWidth-30)/4, height: AutoGetHeight(height: 84))
                    layOut.minimumLineSpacing = 0
                    layOut.minimumInteritemSpacing = 0
                    layOut.scrollDirection = UICollectionViewScrollDirection.vertical
                    layOut.headerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 38))
                    self.collectionView.collectionViewLayout = layOut
                    UIView.performWithoutAnimation {
                        self.collectionView.reloadData()
                        self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionViewScrollPosition.centeredVertically, animated: false)
                    }
                    
                }else{
                    self.scheduleHidden = false
                    let layOut = QRYuanjiaoFlowLayout.init()
                    layOut.itemSize = CGSize.init(width: (kHaveLeftWidth-30)/4, height: AutoGetHeight(height: 84))
                    layOut.minimumLineSpacing = 0
                    layOut.minimumInteritemSpacing = 0
                    layOut.scrollDirection = UICollectionViewScrollDirection.vertical
                    layOut.headerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 38))
                    self.collectionView.collectionViewLayout = layOut
                    UIView.performWithoutAnimation {
                        self.collectionView.reloadData()
                        self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionViewScrollPosition.centeredVertically, animated: false)
                    }
                    //self.collectionView.reloadData()
                }
                
            
              SVProgressHUD.dismiss()
               
        }) { (error) in
            SVProgressHUD.dismiss()
        }
    }
    
    
    
}


// MARK: - 代理

extension WorkInstrumentVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.titleArr[section].count
    }
    
}

extension WorkInstrumentVC: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
         if indexPath.section == 0{
             return false
         }else{
             return true
         }
         
     }
     func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//          let sourceTitle = self.titleArr[sourceIndexPath.section][sourceIndexPath.row]
//          let sourceImg = self.imageArr[sourceIndexPath.section][sourceIndexPath.row]
//         self.titleArr[sourceIndexPath.section].remove(at: sourceIndexPath.row)
//         self.imageArr[sourceIndexPath.section].remove(at: sourceIndexPath.row)
//         self.titleArr[destinationIndexPath.section].insert(sourceTitle, at: destinationIndexPath.row)
//         self.imageArr[destinationIndexPath.section].insert(sourceImg, at: destinationIndexPath.row)
     }

    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "workInstrumentCell", for: indexPath) as! WorkInstrumentCell
        cell.img.image = UIImage.init(named: self.imageArr[indexPath.section][indexPath.row])
        if 4 == indexPath.section && 0 == indexPath.row{
            cell.img.sd_setImage(with: URL(string: self.imageArr[indexPath.section][indexPath.row] ), placeholderImage:UIImage.init(named: "personDefaultIcon") )
        }else if 4 == indexPath.section && 1 == indexPath.row{
            cell.img.sd_setImage(with: URL(string: self.imageArr[indexPath.section][indexPath.row] ), placeholderImage:UIImage.init(named: "personDefaultIcon") )
        }else if 4 == indexPath.section && 2 == indexPath.row{
            cell.img.sd_setImage(with: URL(string: self.imageArr[indexPath.section][indexPath.row] ), placeholderImage:UIImage.init(named: "personDefaultIcon") )
        }
        cell.nameLab.text = self.titleArr[indexPath.section][indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if titleArr[indexPath.section][indexPath.row] == "考勤"{
            let vc = QRSignVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if titleArr[indexPath.section][indexPath.row] == "外勤"{
            let vc = CQFieldPersonelVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if titleArr[indexPath.section][indexPath.row] == "请假"{
            let vc = NCQApprovelVC.init()
            vc.businessCode = "B_QJ"
            vc.titleStr = "请假"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if titleArr[indexPath.section][indexPath.row] == "位置"{
            let vc = CQAllLocationVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if titleArr[indexPath.section][indexPath.row] == "日程"{
            let vc = QRScheduleVC.init()
            //let vc = CQScheduleVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if titleArr[indexPath.section][indexPath.row] == "审批"{
            let vc = CQExaminationAndApprovalVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if titleArr[indexPath.section][indexPath.row] == "任务"{
            let vc = QRScheduleVC.init()
            vc.isFromTask = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if titleArr[indexPath.section][indexPath.row] == "通知公告"{
            let vc = CQNoticeVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if titleArr[indexPath.section][indexPath.row] == "汇报"{
            let vc = CQReportVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if titleArr[indexPath.section][indexPath.row] == "派车"{
            let vc = CQCarApplyVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if titleArr[indexPath.section][indexPath.row] == "会议室预订"{
            let vc = CQMeetingRommBookVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if titleArr[indexPath.section][indexPath.row] == "员工之星"{
            let vc = StarHomeViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if titleArr[indexPath.section][indexPath.row] == "客户"{
            let vc = CQCustomerVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if titleArr[indexPath.section][indexPath.row] == "商品"{
            let vc = QRGoodsVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if titleArr[indexPath.section][indexPath.row] == "合同"{
            let vc = QRContractVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if titleArr[indexPath.section][indexPath.row] == "商机"{
            let vc = QRBusinessVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if titleArr[indexPath.section][indexPath.row] == "客户公海"{
            let vc = QRGonghaiVc.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if titleArr[indexPath.section][indexPath.row] == "名片夹"{
            let vc = CQBussinessCardListVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if titleArr[indexPath.section][indexPath.row] == "公司资料"{
            
            let entityId = self.infoIdArr[0]
            let vc = CQEnterpriseInfoVC.init()
            vc.typeId = entityId
            vc.title = "公司资料"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if titleArr[indexPath.section][indexPath.row] == "产品资料"{
            let entityId = self.infoIdArr[1]
            let vc = CQEnterpriseInfoVC.init()
            vc.typeId = entityId
            vc.title = "产品资料"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if titleArr[indexPath.section][indexPath.row] == "技术资料"{
            let entityId = self.infoIdArr[2]
            let vc = CQEnterpriseInfoVC.init()
            vc.typeId = entityId
            vc.title = "技术资料"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if titleArr[indexPath.section][indexPath.row] == "个人资料"{
            let vc = CQEnterpriseInfoVC.init()
            vc.title = "个人资料"
            vc.createRight = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if titleArr[indexPath.section][indexPath.row] == "微网站"{
            let vc = CQSmallWebVC.init()
            vc.isFromSmallWeb = true
            //            let vc = QRMicorwebVc.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if titleArr[indexPath.section][indexPath.row] == "媒体报道"{
            let vc = CQEnterpriseInfoVC.init()
            vc.title = "媒体报道"
            vc.siteType = "2"
            vc.isFromMTBD = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
            let per = WHC_ModelSqlite.query(Person.self, where: "name = '\(titleArr[indexPath.section][indexPath.row])'" )?.first as! Person
            let val = per.lookTimeCount
            let time = Date().timeIntervalSince1970
            WHC_ModelSqlite.update(Person.self, value: "lookTimeCount = \(val+1) , lookTime = \(time)", where: "name = '\(titleArr[indexPath.section][indexPath.row])'" )
        
        
        
        
    
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 2{
            if scheduleHidden == true{
                return CGSize(width: kWidth,height: AutoGetHeight(height: 11))
            }else{
                return CGSize(width: kWidth,height: AutoGetHeight(height: 51+11))
            }
        }else{
            return CGSize(width: kWidth,height: AutoGetHeight(height: 11))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var header:UICollectionReusableView!
        if kind == UICollectionElementKindSectionHeader {
            
            header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "WorkInstrumnetHeader", for: indexPath)
            
            for v in header.subviews{
                v.removeFromSuperview()
            }
            
            header.layer.cornerRadius = 10
            header.backgroundColor = UIColor.white
            let upView = UIView(frame:  CGRect(x: 0, y: AutoGetHeight(height: 18), width: kHaveLeftWidth, height: AutoGetHeight(height: 20)))
            upView.backgroundColor = UIColor.white
            header.addSubview(upView)
            
            let lab = UILabel.init(frame: CGRect.init(x:kLeftDis, y: 0, width: kHaveLeftWidth - 2 * kLeftDis, height: 38))
            let greyLine = UIView(frame:  CGRect(x: 0, y: 39, width: kHaveLeftWidth , height: 1))
            greyLine.backgroundColor = kProjectBgColor
            header.addSubview(greyLine)
            if 0 == indexPath.section {
                lab.text = "常用功能"
                lab.textColor = UIColor.black
                lab.textAlignment = .left
                header.addSubview(lab)
            }else if 1 == indexPath.section {
                lab.text = "移动考勤"
                lab.textColor = UIColor.black
                lab.textAlignment = .left
                header.addSubview(lab)
            }else if 2 == indexPath.section {
                lab.text = "日常工作"
                lab.textColor = UIColor.black
                lab.textAlignment = .left
                header.addSubview(lab)
            }else if 3 == indexPath.section {
                lab.text = "CRM"
                lab.textColor = UIColor.black
                lab.textAlignment = .left
                header.addSubview(lab)
            }else{
                lab.text = "共享资料"
                lab.textColor = UIColor.black
                lab.textAlignment = .left
                header.addSubview(lab)
            }
           
            
        }else if kind == UICollectionElementKindSectionFooter {
            if indexPath.section == 2{
                if scheduleHidden == true{
                    header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "WorkInstrumnetForFooter", for: indexPath)
                    let sectionBgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 11)))
                    sectionBgView.backgroundColor = kProjectBgColor
                    header.addSubview(sectionBgView)
                }else{
                    header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "WorkInstrumnetScheduleForFooter", for: indexPath)
                    let view = (Bundle.main.loadNibNamed("QRScheduleHview", owner: self, options: nil)?.last) as! QRScheduleHview
                    view.textLab.text = "工作统计"
                    view.frame =  CGRect(x: 0, y: 11, width: kHaveLeftWidth, height: 40)
                    view.layer.cornerRadius = 5
                    view.clipsToBounds = true
                    view.clickClosure = {[unowned self] click in
                        let vc = QRTongJiVC()
                        vc.departmentId =  self.departmentId
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    header.addSubview(view)
                }
                
              
            }else{
                header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "WorkInstrumnetForFooter", for: indexPath)
                let sectionBgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 11)))
                sectionBgView.backgroundColor = kProjectBgColor
                header.addSubview(sectionBgView)
            }
            
        }
        
        
        return header
    }
    
    
}

extension WorkInstrumentVC{
    
    func getCompanyInfoList() {
         SVProgressHUD.dismiss()
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/information/getCompanyFolders" ,
            type: .get,
            param: ["emyeId":userID],
            successCallBack: { (result) in
                var tempArray = [CQEnterpriseInfoModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQEnterpriseInfoModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                var nameArr = [String]()
                var iconArr = [String]()
                for listModel in tempArray{
                    self.infoIdArr.append(listModel.entityId)
                    nameArr.append(listModel.typeName)
                    iconArr.append(listModel.icon)
                }
                
                
                for i in 0..<tempArray.count{
                    self.titleArr[4].replaceSubrange(Range(i..<(tempArray.count - 1)), with: [nameArr[i]])
                    self.imageArr[4].replaceSubrange(Range(i..<(tempArray.count - 1)), with: [iconArr[i]])
                }

                
               self.collectionView.reloadData()
             //   self.collectionView.reloadSections(IndexSet(integer: 3))
                SVProgressHUD.dismiss()
        }) { (error) in
             SVProgressHUD.dismiss()
        }
    }
}


extension UIView {

    /// 部分圆角
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
//    func cornerForPart(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
//        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
//        let maskLayer = CAShapeLayer()
//        maskLayer.frame = self.bounds
//        maskLayer.path = maskPath.cgPath
//        self.layer.mask = maskLayer
//    }
}


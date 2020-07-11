

//
//  QRWorkInstrumentVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/4/23.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit


class QRWorkInstrumentVC: SuperVC {

    var sectionArray = [QRSection]()

    //微网站 1 媒体报道2
   // var siteType = ""
    var microTitleArr = [[String]]()
    var mtbdid = ""
// MARK: - 懒加载
    var departmentId = ""
    var indexStart:IndexPath?
    
    
    lazy var collectionView: UICollectionView = {
//        let layOut = QRYuanjiaoFlowLayout.init()
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width: (kHaveLeftWidth-30)/4, height: AutoGetHeight(height: 84))
        layOut.minimumLineSpacing = 0
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        layOut.headerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 38))
       //layOut.footerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 11))
        let collectionView = UICollectionView.init(frame: CGRect.init(x: kLeftDis, y: SafeAreaTopHeight, width: kHaveLeftWidth, height: kHeight - SafeAreaTopHeight - 49), collectionViewLayout: layOut)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
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
                 if indexChange?.section == indexStart?.section{
                     self.collectionView.updateInteractiveMovementTargetPosition(longpress.location(in: self.collectionView))
                 }else{
                    break
                 }
               break
           case UIGestureRecognizer.State.ended:
               self.collectionView.endInteractiveMovement()
               print("end")
               break
           default:
               self.collectionView.cancelInteractiveMovement()
               print("cancel")
               break
               
           }
       }
    
    func initUserlyModel()->QRSection{
        var usely = QRSection()
         usely.name = "常用功能"
         usely.code = "cygn"
         usely.ind = "0"
        
        
//        it.lookTimeCount += 1
//        it.lookTime = Int64(Date().timeIntervalSince1970)
//        WHC_ModelSqlite.update(QRSection.self, value: "items = \(groupItem)", where: "code = '\(sectionArray[indexPath.section].code!)'" )
        
        
        var result = [Item]()
        let sections = WHC_ModelSqlite.query(QRSection.self) as! [QRSection]
        for (_,item) in sections.enumerated(){
            for (_,i) in item.items.enumerated(){
                result.append(i as! Item)
            }
        }
//        let result = WHC_ModelSqlite.query(Item.self) as! [Item]
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
       
        let usuallyFunc =  Array(rrr.prefix(upTo: 4)) //as! [Item]
        usely.items = usuallyFunc
        return usely
    }
    
    

    func loadAllitems(){
        SVProgressHUD.show()
        STNetworkTools.requestData(URLString:"\(baseUrl)/benchItem/getAll" ,
              type: .get,
              param: nil,
              successCallBack: { (result) in
                 var tempSection = [QRSection]()
               
                for (index,modalJson) in result["data"].arrayValue.enumerated() {
                    let modal = QRSection.init()
                    modal.workId = index
                    modal.code = modalJson["groupJson"]["code"].stringValue
                    modal.ind = modalJson["groupJson"]["index"].stringValue
                    modal.name = modalJson["groupJson"]["name"].stringValue
                    var tempItems = [Item]()
                   for (sindex,json) in modalJson["itemJsons"].arrayValue.enumerated(){
                      let it = Item.init()
                     it.workId = sindex
                     it.code = json["code"].stringValue
                     it.ind = json["index"].stringValue
                     it.name = json["name"].stringValue
                     it.icon = json["icon"].stringValue
                     it.itemId = json["itemId"].stringValue
                    tempItems.append(it)
//                    WHC_ModelSqlite.insert(it)
                  }
                    modal.items = tempItems
                    tempSection.append(modal)
                    WHC_ModelSqlite.insert(modal)
                  }
                self.sectionArray = tempSection
                //插入常用联系人组
                self.sectionArray.insert(self.initUserlyModel(), at: 0)
                self.view.addSubview(self.collectionView)
                SVProgressHUD.dismiss()
          }) { (error) in
                SVProgressHUD.dismiss()
          }
    }
    
    func reloadAllitems(){
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/benchItem/getAll" ,
              type: .get,
              param: nil,
              successCallBack: { (result) in
                
                 var tempSection = [QRSection]()
                for (index,modalJson) in result["data"].arrayValue.enumerated() {
                    let modal = QRSection.init()
                    modal.workId = index
                    modal.code = modalJson["groupJson"]["code"].stringValue
                    modal.ind = modalJson["groupJson"]["index"].stringValue
                    modal.name = modalJson["groupJson"]["name"].stringValue
                    let sec = WHC_ModelSqlite.query(QRSection.self)[index] as! QRSection
                   
                    var tempItems = [Item]()
                    var copyItems = [Item]()
                   for (sindex,json) in modalJson["itemJsons"].arrayValue.enumerated(){

                    let it = Item.init()
                     it.workId = sindex
                     it.code = json["code"].stringValue
                     it.ind = json["index"].stringValue
                     it.name = json["name"].stringValue
                     it.icon = json["icon"].stringValue
                     it.itemId = json["itemId"].stringValue

                    for(_,i) in sec.items.enumerated(){
                        let ii = i as! Item
                        if ii.code == it.code && ii.itemId == it.itemId{
                            it.lookTimeCount = ii.lookTimeCount
                            it.lookTime = ii.lookTime
                        }

                    }
                    tempItems.append(it)
                    copyItems.append(it)
                  }
                    
                    
                    //将网络数据赋值对比最后提交,多的添加,少的删除
                      // 按照原来的顺序排序
                       var tempSameitem = [Item]()
                       for(_,xxx) in sec.items.enumerated(){
                          let ii = xxx as! Item
                           for (_,sxxx) in tempItems.enumerated(){
                               if ii.code == sxxx.code && ii.itemId == sxxx.itemId{
                                if tempSameitem.contains(sxxx){
                                    
                                }else{
                                   tempSameitem.append(sxxx)
                                }
                                   
                                   
                                   let ind = copyItems.index(of: sxxx)
                                   if ind == nil || copyItems.count == 0{
                                   }else{
                                       copyItems.remove(at: ind!)
                                   }
                             }
                           }
                       }
                       tempSameitem.append(contentsOf: copyItems)
                       modal.items =  tempSameitem//tempItems//
                       tempSection.append(modal)
                 
                    WHC_ModelSqlite.update(modal, where: "code = '\(sec.code ?? "")'")
                  }
                
                self.sectionArray = tempSection
                self.sectionArray.insert(self.initUserlyModel(), at: 0)
                //插入常用联系人组
                self.collectionView.reloadData()
                self.view.addSubview(self.collectionView)
                
          }) { (error) in
               let result = WHC_ModelSqlite.query(QRSection.self) as! [QRSection]
               self.sectionArray = result
               self.sectionArray.insert(self.initUserlyModel(), at: 0)
               self.view.addSubview(self.collectionView)
          }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kProjectBgColor
        self.title = "工作台"

        let result = WHC_ModelSqlite.query(QRSection.self) as! [QRSection]
        if result.count == 0{
            //网络添加数据库
            loadAllitems()
        }else{
 
            reloadAllitems()
 
        }
      
        self.automaticallyAdjustsScrollViewInsets = false
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24))
        rightBtn.setImage(UIImage.init(named: "tongshiquan"), for: .normal)
        rightBtn.addTarget(self, action: #selector(friendCircleClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
        
    }
    
    func reloadCollect(){
        let result = WHC_ModelSqlite.query(Item.self) as! [Item]
         if result.count == 0{
       
         }else{
//          self.sectionArray[0] = self.initUserlyModel()
            CATransaction.setDisableActions(true)
            self.collectionView.reloadData()
            CATransaction.commit()
         }
    }
    
// MARK: - 点击事件
    
    @objc func friendCircleClick()  {
        //let vc = CQFriendCircleVC()
        let vc = QRWorkmateCircleVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: - 代理

extension QRWorkInstrumentVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.sectionArray[section].items.count
         
    }
    
}

extension QRWorkInstrumentVC: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
         if indexPath.section == 0{
             return false
         }else{
             return true
         }
         
     }
     func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        
        print(sourceIndexPath.item)
        print(destinationIndexPath.item)
        
        var sourceItems = (self.sectionArray[sourceIndexPath.section].items) as! [Item]
        let sourceIndex = sourceIndexPath.row
        let sourceItem = sourceItems[sourceIndex].copy() as! Item
        let desItemIndex = destinationIndexPath.row
        if sourceIndex<desItemIndex{
            sourceItems.insert(sourceItem, at: desItemIndex+1)
            sourceItems.remove(at: sourceIndex)
           
        }else{
            sourceItems.insert(sourceItem, at: desItemIndex)
            sourceItems.remove(at: sourceIndex+1)
        }
         self.sectionArray[sourceIndexPath.section].items = sourceItems
        
        WHC_ModelSqlite.update(self.sectionArray[sourceIndexPath.section], where:  " code = '\(self.sectionArray[sourceIndexPath.section].code ?? "")'")
        CATransaction.setDisableActions(true)
        self.collectionView.reloadData()
        CATransaction.commit()
        
     }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "workInstrumentCell", for: indexPath) as! WorkInstrumentCell
        let groupItem = sectionArray[indexPath.section].items as! [Item]
        let it = groupItem[indexPath.row]

        cell.img.sd_setImage(with: URL(string: (imagePreUrl+it.icon) ), placeholderImage:UIImage.init(named: "xcxz") )
        //"personDefaultIcon"
        cell.nameLab.text = it.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            let groupItem = sectionArray[indexPath.section].items as! [Item]
            let it = groupItem[indexPath.row]
        
        
              it.lookTimeCount += 1
              it.lookTime = Int64(Date().timeIntervalSince1970)

              let sec = sectionArray[indexPath.section] as! QRSection
              sec.items = groupItem
              WHC_ModelSqlite.update(sec, where: "code = '\(sectionArray[indexPath.section].code!)'" )
              self.sectionArray[0] = self.initUserlyModel()
//              self.collectionView.reloadData()
        
        if it.code == "ydkq_kq"{
            let vc = QRSignVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if it.code == "ydkq_wq"{
            let vc = CQFieldPersonelVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if it.code == "ydkq_qj"{
            let vc = NCQApprovelVC.init()
            vc.businessCode = "B_QJ"
            vc.titleStr = "请假"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if it.code == "ydkq_wz"{
            let vc = CQAllLocationVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if it.code == "rcgz_rc"{
            let vc = QRScheduleVC.init()
            //let vc = CQScheduleVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if it.code == "rcgz_sp"{
            let vc = CQExaminationAndApprovalVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if it.code == "rcgz_rw"{
            let vc = QRScheduleVC.init()
            vc.isFromTask = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if it.code == "rcgz_tzgg"{
            let vc = CQNoticeVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if it.code == "rcgz_hb"{
            let vc = CQReportVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if it.code == "rcgz_pc"{
            let vc = CQCarApplyVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if it.code == "rcgz_hysyd"{
            let vc = CQMeetingRommBookVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if it.code == "rcgz_ygzx"{
            let vc = StarHomeViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if it.code == "rcgz_gztj"{
            let vc = QRTongJiVC()
           vc.departmentId =  self.departmentId
           self.navigationController?.pushViewController(vc, animated: true)
        }else if it.code == "crm_kh"{
            let vc = CQCustomerVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if it.code == "crm_sp"{
            let vc = QRGoodsVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if it.code == "crm_ht"{
            let vc = QRContractVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if it.code == "crm_sj"{
            let vc = QRBusinessVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if it.code == "crm_khgh"{
            let vc = QRGonghaiVc.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if it.code == "crm_mpj"{
            let vc = CQBussinessCardListVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if it.code == "gxzl_gszl" &&  it.itemId == "5"{

            let entityId = it.itemId//self.infoIdArr[0]
            let vc = CQEnterpriseInfoVC.init()
            vc.typeId = entityId!
            vc.title = "公司资料"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if it.code == "gxzl_gszl" &&  it.itemId == "6"{
            let entityId = it.itemId //self.infoIdArr[0]
           let vc = CQEnterpriseInfoVC.init()
           vc.typeId = entityId!
           vc.title = "产品资料"
           self.navigationController?.pushViewController(vc, animated: true)
        }else if it.code == "gxzl_gszl" &&  it.itemId == "7"{
            let entityId = it.itemId //self.infoIdArr[0]
           let vc = CQEnterpriseInfoVC.init()
           vc.typeId = entityId!
           vc.title = "技术资料"
           self.navigationController?.pushViewController(vc, animated: true)
        }else if it.code == "gxzl_grzl"{
            let vc = CQEnterpriseInfoVC.init()
            vc.title = "个人资料"
            vc.createRight = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if it.code == "gxzl_wwz"{
            let vc = CQSmallWebVC.init()
            vc.isFromSmallWeb = true
            //let vc = QRMicorwebVc.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if it.code == "gxzl_mtbd"{
            let vc = CQEnterpriseInfoVC.init()
            vc.title = "媒体报道"
            vc.siteType = "2"
            vc.isFromMTBD = true
            self.navigationController?.pushViewController(vc, animated: true)
        }

//        let per = WHC_ModelSqlite.query(Item.self, where: "code = '\(it.code!)'" )?.first as! Item
//        let val = per.lookTimeCount
//        let time = Date().timeIntervalSince1970
//        if it.code == "gxzl_gszl"{
//            WHC_ModelSqlite.update(Item.self, value: "lookTimeCount = \(val+1) , lookTime = \(time)", where: "itemId = '\(it.itemId!)'" )
//        }else{
//            WHC_ModelSqlite.update(Item.self, value: "lookTimeCount = \(val+1) , lookTime = \(time)", where: "code = '\(it.code!)'" )
//        }
        

            
          
                
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            return CGSize(width: kWidth,height: AutoGetHeight(height: 11))
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
            
            lab.text = self.sectionArray[indexPath.section].name
            lab.textColor = UIColor.black
            lab.textAlignment = .left
            header.addSubview(lab)
            
           
        }else if kind == UICollectionElementKindSectionFooter {
            header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "WorkInstrumnetForFooter", for: indexPath)
            let sectionBgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 11)))
            sectionBgView.backgroundColor = kProjectBgColor
            header.addSubview(sectionBgView)
       
        }
        return header
    }
    
    
}


extension UIView {

    /// 部分圆角
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    func cornerForPart(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}


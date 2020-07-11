//
//  QRAddTrackBusinessVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/10/12.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRAddTrackBusinessVC: SuperVC {

    var type :Int = 0
    //客户跟进人
    var customerId = ""
    var UserId = [String]()
    var genJin = [QRGonghaiGenjinModel]()
    
    var kehu = QRKeHuModel()
    ////商机跟进人
    var genjingrens = [QRGenJinRenModel]()
    var TrackArray = [CQDepartMentUserListModel]() //跟进人列表
    var businessDetailModel : QRDetailBusinessMdel?
    var genjinStr = ""
    
    //声明闭包
    typealias clickBtnClosure = (_ trackARR:[CQDepartMentUserListModel],_ text:String ) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    
    
    lazy var collectionView: UICollectionView = {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width: (kHaveLeftWidth)/5, height: 75)
        layOut.sectionInset = UIEdgeInsetsMake(0, kLeftDis, 0, kLeftDis)
        layOut.minimumLineSpacing = 0
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        
        
        let collectionView = UICollectionView(frame:  CGRect(x: 0, y: CGFloat(SafeAreaTopHeight), width: kWidth, height: 44+75+15), collectionViewLayout: layOut)
        if #available(iOS 11.0, *) {
            //            collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
            //            collectionView.contentInset = UIEdgeInsetsMake(CGFloat(SafeAreaTopHeight), 0, CGFloat(SafeAreaBottomHeight), 0);
            //            collectionView.scrollIndicatorInsets = collectionView.contentInset;
            
        } else {
            collectionView.contentInset = UIEdgeInsetsMake(-CGFloat(SafeAreaTopHeight), 0, 0, 0);
            collectionView.scrollIndicatorInsets = collectionView.contentInset;
        }
        
        layOut.headerReferenceSize = CGSize(width: kWidth, height: 44)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(QRGenjinCollectionCell.self, forCellWithReuseIdentifier: "QRGenjinCellId")
        collectionView.register(QRheadcell.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "head1")
        return collectionView
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if type == 1{
            //客户装换成
            //genJin
            var temp = [CQDepartMentUserListModel]()
            for xx in genJin{
                let mod = CQDepartMentUserListModel(uId: xx.userId, realN: xx.realName, headImag: xx.headImage)
                temp.append(mod)
            }
            self.TrackArray = temp
            
        }
        collectionView.frame = CGRect(x: 0, y: 64, width: Int(kWidth), height: ((TrackArray.count)/5+1)*75+44+15  )
        title = "跟进人"
        view.addSubview(collectionView)
        //将已经有了的跟进人加入tracks
        view.backgroundColor = kProjectBgColor
        
        
        let but = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.done, target: self, action: #selector(done))
        navigationItem.rightBarButtonItem = but
        but.tintColor = kBlueColor
        //添加通知
        let NotifMycation = NSNotification.Name(rawValue:"AddTracker")
        NotificationCenter.default.addObserver(self, selector: #selector(upDataChange(notif:)), name: NotifMycation, object: nil)
        
        
        
        
    }
    
    //MARK:接受通知后的事件
    
    //接收到后执行的方法
    @objc func upDataChange(notif: NSNotification) {
        print(notif)
        
        
        guard let arr: [CQDepartMentUserListModel] = notif.object as! [CQDepartMentUserListModel]? else { return }
        
        var temp = [CQDepartMentUserListModel]()
        for i in 0..<arr.count {
            //添加选中的模型
            temp.append(arr[i])
        }
        if temp.count == 0{
            SVProgressHUD.showInfo(withStatus: "跟进人必须保留一个")
        }else{
            self.TrackArray = temp
        }
       
        print(genjingrens.count,genjingrens)
        self.collectionView.reloadData()
        self.collectionView.frame =  CGRect(x: 0, y: 64, width: Int(kWidth), height: ((TrackArray.count)/5+1)*75+44 + 15   )
        
    }
    
    
    //MARK:-编辑商机
    func loadEdite()  {
        //  businessName businessType  closeDate crmCustomer  entityId  estimatedAmount  opt
        //  salesStage
        self.loadingPlay()
        let userID = STUserTool.account().userID
        var par = [String:AnyObject]()
        if let mod = businessDetailModel {
            par = ["businessName":mod.businessName as AnyObject,
                   "businessType":mod.businessType as AnyObject,
                   "closeDate":mod.closeDate as AnyObject,"crmCustomer":mod.crmCustomer as AnyObject,"entityId":mod.entityId as AnyObject,"estimatedAmount":mod.estimatedAmount as AnyObject,"salesStage":mod.salesStage as AnyObject,"opt":"editFollowPerson" as AnyObject,"emyeId":userID as AnyObject,"followPerson":genjinStr as AnyObject]
        }
        
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmBusiness/operateCrmBusiness", type: .post, param: par, successCallBack: { (result) in
            
            self.loadingSuccess();                                                  if   result["success"].boolValue{
                SVProgressHUD.showInfo(withStatus: "编辑成功")
                
                self.navigationController?.popViewController(animated: true)
                self.clickClosure!(self.TrackArray,self.genjinStr)
            }
            
            
            
        }) { (error) in
            self.loadingSuccess()
            SVProgressHUD.showInfo(withStatus: "编辑失败")
        }
        
        
        
    }
    
    func updateKeHu()  {
        loadingPlay()
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmCustomer/updateCrmFollow", type: .post, param: ["userIds[]":genjinStr,"customerId":customerId,"loginUserId":userID], successCallBack: { (result) in
            
            self.loadingSuccess();
            if   result["success"].boolValue{
                SVProgressHUD.showInfo(withStatus: "编辑成功")
                
                self.navigationController?.popViewController(animated: true)
                self.clickClosure!(self.TrackArray,self.genjinStr)
            }
            
            
        }) { (error) in
            self.loadingSuccess();
            
        }
        
        
    }
    
}


extension QRAddTrackBusinessVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TrackArray.count+1
    }
    
}

extension QRAddTrackBusinessVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        print(kehu.creator,kehu.principal,kehu.principalId,kehu.creatorId,kehu.creatorHeadImage,kehu.principalHeadImage)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QRGenjinCellId", for: indexPath) as! QRGenjinCollectionCell
        
        if self.TrackArray.count == 0 {
            if indexPath.item == 0{
                cell.img.image = UIImage.init(named: "CQAddMenberIcon")
                cell.deleteBtn.isHidden = true
                cell.name.isHidden = true
                cell.location.isHidden = true
            }
        }else {
            if indexPath.item == self.TrackArray.count {
                cell.img.image = UIImage.init(named: "CQAddMenberIcon")
                cell.deleteBtn.isHidden = true
                cell.name.isHidden = true
                cell.location.isHidden = true
            }else {
                //  图片赋值
                let mod = self.TrackArray[indexPath.row]
                cell.img.sd_setImage(with: URL(string:mod.headImage), placeholderImage: UIImage(named:"personDefaultIcon"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
                cell.name.isHidden = false
                cell.name.text = mod.realName
                cell.deleteBtn.isHidden = false
                cell.deleteDelegate = self
                cell.location.isHidden = true
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let head = collectionView.dequeueReusableSupplementaryView(ofKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "head1", for:indexPath ) as! QRheadcell
        head.label.font = kFontSize15
        head.label.text = "跟进人(\(self.TrackArray.count))"
        return head
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.TrackArray.count == 0 {
            if indexPath.item == 0 {
                let contact = QRAddressBookVC()
                contact.hasSelectModelArr = self.TrackArray
                contact.toType = ToAddressBookType.fromGenJin
                self.navigationController?.pushViewController(contact, animated: true)
            }
        }else{
            if indexPath.item == self.TrackArray.count{
                let contact = QRAddressBookVC()
                contact.hasSelectModelArr = self.TrackArray
                contact.toType = ToAddressBookType.fromGenJin
                self.navigationController?.pushViewController(contact, animated: true)
            }else{
                
            }
        }
        
    }
    
    
}

extension QRAddTrackBusinessVC :QRGenjinCollectionCellDeleteDelegate{
    func deletePublishPic(index: IndexPath) {
        if self.TrackArray.count == 1 {
            SVProgressHUD.showInfo(withStatus: "跟进人必须保留一个")
        }else{
            self.TrackArray.remove(at: index.row )
            collectionView.reloadData()
        }
        
    }
    
}

extension QRAddTrackBusinessVC{
    @objc func done(){
        //将数组返回并且修改商机
        //获取id数组
        
        if type == 1 {
            var tracker = [String]()
            var trackerstr = ""
            for xx in TrackArray{
                let  str = xx.userId
                trackerstr += xx.userId + ","
                tracker.append(str)
            }
            if trackerstr == ""{
                
            }else{
                trackerstr.removeLast()
            }
            
            genjinStr  = trackerstr
            UserId.append(contentsOf: tracker)
            print(UserId)
            updateKeHu()
        }else{
            var tracker = ""
            for xx in TrackArray{
                tracker += xx.userId + ","
            }
            if tracker == ""{
                
            }else{
                tracker.removeLast()
            }
            
            genjinStr = tracker
            print(tracker)
            
            loadEdite()
        }
        
        
        
    }
}

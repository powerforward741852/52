//
//  CQEarlyWorkOutVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2019/2/19.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class CQEarlyWorkOutVC: SuperVC {
    var userArray = [CQDepartMentUserListModel]()
    var locationManager:AMapLocationManager? //定位服务
    var curLatitude:Double? //经度
    var curLongitude:Double? //纬度
    var curlocationStr:String? //当前位置
    var outReason = "" //外出原因
    var rightBtn:UIButton!
    var isFromMyApplyVC = false
    var approvalBusinessId = ""
    var businessApplyId = ""
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: SafeAreaTopHeight, width: kWidth, height: kHeight - SafeAreaTopHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        table.backgroundColor = kProjectBgColor
        if #available(iOS 11.0, *) {
        } else {
            //低于 iOS 9.0
            //scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never;
            self.automaticallyAdjustsScrollViewInsets = false
            // scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            //scrollView.scrollIndicatorInsets = scrollView.contentInset;
        }
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 396)))
        headView.backgroundColor = kProjectBgColor
        return headView
    }()
    
    lazy var locationImg: UIImageView = {
        let locationImg = UIImageView.init(frame: CGRect.init(x: AutoGetWidth(width: 15), y: AutoGetHeight(height: 15), width: AutoGetWidth(width: 15), height: AutoGetHeight(height: 19)))
        locationImg.image = UIImage.init(named: "FieldPersonelLocation")
        return locationImg
    }()
    
    lazy var locationLab: UILabel = {
        let locationLab = UILabel.init(frame: CGRect.init(x: self.locationImg.right + AutoGetWidth(width: 12), y: 0, width: kWidth/4 * 3, height: AutoGetHeight(height: 49)))
        locationLab.textColor = UIColor.black
        locationLab.textAlignment = .left
        locationLab.font = UIFont.systemFont(ofSize: 15)
        locationLab.text = ""
        locationLab.numberOfLines = 2
        return locationLab
    }()
    
    lazy var textBgView: UIView = {
        let textBgView = UIView.init(frame: CGRect.init(x: 0, y: AutoGetWidth(width: 49), width: kWidth, height: AutoGetHeight(height: 187)))
        textBgView.backgroundColor = UIColor.white
        return textBgView
    }()
    
    lazy var textView: CBTextView = {
        let textView = CBTextView.init(frame: CGRect.init(x: AutoGetWidth(width: 15), y: AutoGetWidth(width: 9), width: kWidth - AutoGetWidth(width: 30), height: AutoGetHeight(height: 170)))
        textView.aDelegate = self
        textView.textView.backgroundColor = UIColor.white
        textView.textView.font = UIFont.systemFont(ofSize: 15)
        textView.textView.textColor = UIColor.black
       
        textView.placeHolder = "请填写提前下班理由(必填)..."
        textView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        
        return textView
    }()
    
    lazy var attendPersonView: UIView = {
        let attendPersonView = UIView.init(frame: CGRect.init(x: 0, y:self.textBgView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 145)))
        attendPersonView.backgroundColor = UIColor.white
        return attendPersonView
    }()
    
    lazy var attendPersonLab: UILabel = {
        let attendPersonLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 18), width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 15)))
        attendPersonLab.textColor = UIColor.black
        attendPersonLab.text = "审批人"
        attendPersonLab.textAlignment = .left
        attendPersonLab.font = kFontSize15
        return attendPersonLab
    }()
    
    
    lazy var collectionView: UICollectionView = {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width: kHaveLeftWidth/4, height: AutoGetHeight(height: 75))
        layOut.minimumLineSpacing = 0
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        //        layOut.headerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 38))
        //        layOut.footerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 11))
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: kLeftDis, y: self.attendPersonLab.bottom + AutoGetHeight(height: 14), width: kHaveLeftWidth, height: AutoGetHeight(height: 84)), collectionViewLayout: layOut)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(CQWriteReportCell.self, forCellWithReuseIdentifier: "CQWriteReportCellId")
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.locateMap()
        getApprovalPersonsRequest()
        
    }
    //获得审批人
    func getApprovalPersonsRequest() {
        self.loadingPlay()
        let userId = STUserTool.account().userID
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getApplyApprovalPersons" ,
            type: .post,
            param: ["approvalBusinessId":"",
                    "businessCode":"B_WCTQXB",
                    "emyeId":userId,
                    "vacationTypeId":""],
            successCallBack: { (result) in
                
                var arr = [CQDepartMentUserListModel]()
                
                self.userArray.removeAll()
                
                for modalJson in result["data"]["approvalFlowPersonUnitJsonList"].arrayValue  {
                    guard let modal = CQDepartMentUserListModel(jsonData: JSON(modalJson)) else {
                        return
                    }
                    DLog(modal)
                    arr.append(modal)
                }
                
                self.userArray = arr
                
                self.collectionView.reloadData()
                self.loadingSuccess()
        }) { (error) in
            
        }
    }
    func initView()  {
        
        self.title = "提前下班申请"
        
        self.view.backgroundColor = kProjectBgColor
        
        self.view.addSubview(self.table)
        
        self.table.tableHeaderView = self.headView
        
        self.headView.addSubview(self.locationImg)
        self.headView.addSubview(self.locationLab)
        self.headView.addSubview(self.textBgView)
        self.textBgView.addSubview(self.textView)
        self.headView.addSubview(self.attendPersonView)
        self.attendPersonView.addSubview(self.attendPersonLab)
        self.attendPersonView.addSubview(self.collectionView)
        
        
        let leftBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        leftBtn.setTitle("取消", for: .normal)
        leftBtn.setTitleColor(kBlueColor, for: .normal)
        leftBtn.titleLabel?.tintColor = kBlueColor
        leftBtn.addTarget(self, action: #selector(backToSuperView), for: .touchUpInside)
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        leftBtn.contentHorizontalAlignment = .left
        let leftItem = UIBarButtonItem.init(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftItem
        
        self.rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        rightBtn.setTitle("提交", for: .normal)
        rightBtn.sizeToFit()
         self.rightBtn.setTitleColor(kBlueColor, for: .normal)
//        if outReason == ""{
//           // rightBtn.setTitleColor(kLyGrayColor, for: .normal)
//           // rightBtn.isUserInteractionEnabled = false
//        }else{
//
//        }
        
    
        rightBtn.contentHorizontalAlignment = .right
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        rightBtn.addTarget(self, action: #selector(OKClick), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.locationManager?.stopUpdatingLocation()
    }
    
    func locateMap()  {
        locationManager = AMapLocationManager.init()
        locationManager?.delegate = self
        //设置定位最小更新距离
        locationManager?.distanceFilter = 5.0
        locationManager?.startUpdatingLocation()
        //如果需要持续定位返回逆地理编码信息
        //        locationManager?.locatingWithReGeocode = true
        //        locationManager?.startUpdatingLocation()
    }

    @objc func OKClick() {
        
        if outReason == ""{
            SVProgressHUD.showInfo(withStatus: "请填写外出下班理由")
            return
        }else{
            
        }
        
        var dicArr = [Any]()
       // let dic = NSMutableDictionary.init()
         var detailArr = [NSMutableDictionary]()
        //提前下班
        let contentDic:NSMutableDictionary = NSMutableDictionary.init()
        contentDic.setValue(self.curLatitude, forKey: "LatitudeValue")
        contentDic.setValue(self.curLongitude, forKey: "LongitudeValue")
        contentDic.setValue(self.curlocationStr, forKey: "addressRemark")
        contentDic.setValue(self.outReason, forKey: "outReason")
        detailArr.append(contentDic)
        
        dicArr.append(contentDic)
        DLog(dicArr)
        let formDic = ["businessApplyDatas":dicArr]
        DLog(formDic)
        let formStr = getJSONStringFromDictionary(dictionary: formDic as NSDictionary)
        self.loadingPlay()
        self.applySubmitRequest(data: formStr)
    }
   
    //提交申请
    func applySubmitRequest(data:String) {
        let userId = STUserTool.account().userID
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/applySubmit" ,
            type: .post,
            param: ["approvalBusinessId":self.approvalBusinessId,
                    "businessApplyId":self.businessApplyId,
                    "businessCode":"B_WCTQXB",
                    "copyPersonIds":"",
                    "emyeId":userId,
                    "formData":data],
            successCallBack: { (result) in
                self.loadingSuccess()
               // SVProgressHUD.showSuccess(withStatus: "发布成功")
                if self.isFromMyApplyVC{
                    for v in (self.navigationController?.viewControllers)!{
                        if v is CQMeSubmitVC{
                         //   NotificationCenter.default.post(name: NSNotification.Name.init("refreshMeApplyUI"), object: nil)
                            self.navigationController?.popToViewController(v, animated: true)
                        }
                    }
                }else{
                    self.navigationController?.popViewController(animated: true)
                  //  NotificationCenter.default.post(name: NSNotification.Name.init("refreshMeWorkOutUI"), object: nil)
                }
        }) { (error) in
            self.loadingSuccess()
        }
    }
    
//    
//    func workOutSignOut(btn:UIButton) {
//        let longitude = String(format: "%.6f", self.curLongitude!)
//        let latitude = String(format: "%.6f", self.curLatitude!)
//        STNetworkTools.requestData(URLString:"\(baseUrl)/outWork/updateSignBack" ,
//            type: .post,
//            param: ["attendanceRecordId":detailModel!.attendanceRecordId,
//                    "latitudeValue":latitude,
//                    "longitudeValue":longitude],
//            successCallBack: { (result) in
//                self.loadingSuccess()
//                SVProgressHUD.showSuccess(withStatus: "签退成功")
//                let btn = self.view.viewWithTag(100) as! UIButton
//                btn.isUserInteractionEnabled = true
//        }) { (error) in
//            self.loadingSuccess()
//        }
//    }
//
    
//    func loadPerson(){
//        let userId = STUserTool.account().userID
//        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getApplyApprovalPersons" ,
//            type: .post,
//            param: ["approvalBusinessId":"",
//                    "businessCode":"B_WC",
//                    "emyeId":userId,
//                    "formData":""],
//            successCallBack: { (result) in
//                //                self.copyArray.removeAll()
//                //                self.userIdArr.removeAll()
//                //审核人列表
//                //                var approvalArr = [CQCopyForModel]()
//                //                for modalJson in result["data"]["approvalFlowPersonUnitJsonList"].arrayValue  {
//                //                    guard let modal = CQCopyForModel(jsonData: JSON(modalJson)) else {
//                //                        return
//                //                    }
//                //                    approvalArr.append(modal)
//                //                }
//                
//                //抄送人列表  copyFlowPersonUnitJsonList
//                var copyToArr = [CQDepartMentUserListModel]()
//                for modalJson in result["data"]["approvalFlowPersonUnitJsonList"].arrayValue  {
//                    guard let modal = CQDepartMentUserListModel(jsonData: JSON(modalJson)) else {
//                        return
//                    }
//                    copyToArr.append(modal)
//                }
//                self.TrackArray = copyToArr
//                self.personCollectionView.reloadData()
//                //                for model in copyToArr{
//                //                    self.copyArray.append(CQDepartMentUserListModel.init(uId: model.approverId, realN: model.realName, headImag: model.headImage))
//                //                }
//                //
//                //                for model in self.copyArray {
//                //                    self.userIdArr.append(model.userId)
//                //                }
//                
//                
//        }) { (error) in
//            self.personCollectionView.reloadData()
//            
//        }
//    }
//    
    
}

// Mark:高德位置
extension CQEarlyWorkOutVC:AMapLocationManagerDelegate{
    //定位失败弹出此代理方法
    //定位失败弹出提示框,提示打开定位按钮，会打开系统的设置，提示打开定位服务
    func amapLocationManager(_ manager: AMapLocationManager!, didFailWithError error: Error!) {
        //设置提示提醒用户打开定位服务
        if   CLLocationManager.authorizationStatus().rawValue == 4 ||  CLLocationManager.authorizationStatus().rawValue == 3{
            
        }else{
            let alert = UIAlertController.init(title: "允许\"定位\"提示", message: "请在设置中打开定位", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "打开定位", style: .default) { (al) in
                //打开定位设置
                if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(appSettings as URL)
                }
            }
            let cancel = UIAlertAction.init(title: "取消", style: .cancel) { (ca) in
            }
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
       
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!) {
        self.curLatitude = location.coordinate.latitude
        self.curLongitude = location.coordinate.longitude
        DLog(self.curLatitude)
        DLog(self.curLongitude)
        let geoCoder = CLGeocoder.init()
        geoCoder.reverseGeocodeLocation(location) { (placemark, error) -> Void in
            
            
            
            if(error == nil)//成功
                
            {
                
                let array = placemark! as NSArray
                
                let mark = array.firstObject as! CLPlacemark
                
                //                //这个是城市
                //
                //                let city: String = (mark.addressDictionary! as NSDictionary).value(forKey: "City") as! String
                //
                //                //这个是国家
                //
                //                let country: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "Country") as! NSString
                //
                //                //这个是国家的编码
                //
                //                let CountryCode: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "CountryCode") as! NSString
                //
                //这是街道位置
                
                let FormattedAddressLines: NSString = ((mark.addressDictionary! as NSDictionary).value(forKey: "FormattedAddressLines") as AnyObject).firstObject as! NSString
                
                //这是具体位置
                
                //                let Name: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "Name") as! NSString
                
                //                //这是省
                //
                //                var State: String = (mark.addressDictionary! as NSDictionary).value(forKey: "State") as! String
                //
                //                //这是区
                //
                //                let SubLocality: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "SubLocality") as! NSString
                
                
                //                print("\(CountryCode)\(FormattedAddressLines)\(Name)\(State)\(SubLocality)")
                //                let str1 = Name as String
                let str2 = FormattedAddressLines as String
                self.curlocationStr = str2
                DLog(self.curlocationStr)
                self.locationLab.text = self.curlocationStr
                
            }
                
            else
                
            {
                
                print(error!)
                
                
                
            }
            
        }
    }
}

extension CQEarlyWorkOutVC:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if self.textView.textView.text.isEmpty {
            
        }
        
        self.rightBtn.setTitleColor(kBlueColor, for: .normal)
        self.rightBtn.isUserInteractionEnabled = true
        self.outReason = textView.text
        print(self.outReason)
//        let count = 100 - textView.text.count
//        let cStr:String = String(count)
//        self.countLab.text = "还可以输入" + cStr + "字"
//        if count < 0 {
//            SVProgressHUD.showError(withStatus: "请控制字数在100字以内")
//        }
//
//        if textView.text.count > 100{
//            var str = textView.text! as NSString
//            str = str.substring(to: 100) as NSString
//            textView.text = str as String
//            self.countLab.text = "还可以输入0字"
//        }
        
//        if textView.text.count == 0 {
//            self.rightBtn.isUserInteractionEnabled = false
//            self.rightBtn.setTitleColor(kLyGrayColor, for: .normal)
//        }
    }
}

// MARK: - 代理

extension CQEarlyWorkOutVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userArray.count
    }
    
}

extension CQEarlyWorkOutVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQWriteReportCellId", for: indexPath) as! CQWriteReportCell
        let mod = userArray[indexPath.row]
        cell.img.sd_setImage(with: URL(string: mod.headImage ), placeholderImage:UIImage.init(named: "personDefaultIcon") )
        cell.deleteBtn.isHidden = true
        cell.nameLab.text = mod.realName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

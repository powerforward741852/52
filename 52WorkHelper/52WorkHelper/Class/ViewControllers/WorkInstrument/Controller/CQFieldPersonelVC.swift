//
//  CQFieldPersonelVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/4/26.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit


class CQFieldPersonelVC: SuperVC {
    
    var overlays: Array<MAOverlay>!
    
    var detailModel:CQFieldPersonalModel?
    var locationManager:AMapLocationManager? //定位服务
    var curLatitude:Double? //经度
    var curLongitude:Double? //纬度
    var curlocationStr:String? //当前位置
    var mapView: MAMapView!
    var dateStr = ""
    var isFromStatics = false
    var isOutDate = true
    var signInbtn : UIButton?
    var signOutbtn : UIButton?
    var rada : UIImageView?
    var rada1 : UIImageView?
// MARK: - 懒加载控件
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: SafeAreaTopHeight, width: kWidth, height: kHeight-SafeAreaTopHeight-SafeAreaBottomHeight-AutoGetHeight(height: 49)), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        table.backgroundColor = kProjectBgColor
        if #available(iOS 11.0, *) {
        
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        return table
    }()
    
    lazy var headView: UIView = {     //AutoGetHeight(height: 618)
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight-SafeAreaTopHeight-SafeTabbarBottomHeight))
        return headView
    }()
    
    lazy var dateAndWeekLab: UILabel = {
        let dateAndWeekLab = UILabel.init(frame: CGRect.init(x: AutoGetWidth(width: 15), y: 0, width: kWidth/3*2, height: AutoGetHeight(height: 45)))
        dateAndWeekLab.textColor = UIColor.black
        dateAndWeekLab.textAlignment = .left
        dateAndWeekLab.font = UIFont.systemFont(ofSize: 15)
        
        let weeks = ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
        let now = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy年MM月dd日"
        
        let str = dateFormat.string(from: now)
        let week = weeks[dateFormat.date(from: str)!.resultWeek()]
        
        dateAndWeekLab.text = str + week
        return dateAndWeekLab
    }()
    
    lazy var statueLab: UILabel = {
        let statueLab = UILabel.init(frame: CGRect.init(x: kWidth/3*2, y: 0, width: kWidth/3 - AutoGetWidth(width: 15), height: AutoGetHeight(height: 45)))
        statueLab.textColor = UIColor.black
        statueLab.textAlignment = .right
        statueLab.font = UIFont.systemFont(ofSize: 15)
        statueLab.text = ""
        return statueLab
    }()
    
    
    
    lazy var locationImg: UIImageView = {
        let locationImg = UIImageView.init(frame: CGRect.init(x: AutoGetWidth(width: 15), y:self.mapView.bottom + AutoGetHeight(height: 13), width: AutoGetWidth(width: 15), height: AutoGetHeight(height: 19)))
        locationImg.image = UIImage.init(named: "FieldPersonelLocation")
        return locationImg
    }()
    
    lazy var locationLab: UILabel = {
        let locationLab = UILabel.init(frame: CGRect.init(x: self.locationImg.right + AutoGetWidth(width: 12), y: self.mapView.bottom, width: kWidth/4 * 3, height: AutoGetHeight(height: 45)))
        locationLab.textColor = UIColor.black
        locationLab.textAlignment = .left
        locationLab.font = UIFont.systemFont(ofSize: 15)
        locationLab.text = ""
        
        return locationLab
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: self.locationLab.bottom, width: kWidth, height: (kHeight-SafeAreaTopHeight-SafeAreaBottomHeight-AutoGetHeight(height: 49+90))/2 ))
        scrollView.contentSize = CGSize.init(width: kWidth/5*8+AutoGetHeight(height: 37+15+37), height: (kHeight-SafeAreaTopHeight-SafeAreaBottomHeight-AutoGetHeight(height: 49+90))/2)
        scrollView.backgroundColor = kProjectBgColor
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var footView: UIView = {
        let footView = UIView.init(frame: CGRect.init(x: 0, y: kHeight - AutoGetHeight(height: 49) - CGFloat(SafeAreaBottomHeight), width: kWidth, height: AutoGetHeight(height: 49)))
        footView.backgroundColor = UIColor.white
        return footView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUI), name: NSNotification.Name.init("refreshMeWorkOutUI"), object: nil)
        self.title = "外勤"
        
        if self.isFromStatics {
            let weeks = ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            let week = weeks[dateFormat.date(from: self.dateStr)!.resultWeek()]
            self.dateAndWeekLab.text = self.dateStr + " " +  week
        }else{
            let now = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            self.dateStr = dateFormat.string(from: now)
        }
        
        let nowDate = Date()
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd"
        let nowStr = dateformat.string(from: nowDate)
        if nowStr == self.dateStr{
            self.isOutDate = false
        }else{
            self.isOutDate = true
        }
        
        self.setUpRefresh()
        
        //right
        let rightButton = UIButton(type: .custom)
        rightButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        rightButton.setTitle("统计", for: .normal)
        rightButton.titleLabel?.font = kFontSize17
        rightButton.sizeToFit()
        rightButton.setTitleColor(kBlueColor, for: .normal)
        rightButton.addTarget(self, action: #selector(StaticsClick), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshOutWorkView(notification:)), name: NSNotification.Name(rawValue: "refreshOutWorkView"), object: nil)
    }
    @objc func refreshUI(){
        workOutSignOut(btn: UIButton())
    }
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    func initView()  {
        self.view.addSubview(self.table)
        
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.dateAndWeekLab)
        self.headView.addSubview(self.statueLab)
        self.headView.addSubview(self.locationImg)
        self.headView.addSubview(self.locationLab)
        self.headView.addSubview(self.scrollView)
        
        self.view.addSubview(self.footView)
        
        self.createFootView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !self.isFromStatics{
             self.locationManager?.stopUpdatingLocation()
        }
       
    }
    
    
    
    
   
    
    func initMapView()  {
        mapView = MAMapView.init(frame: CGRect.init(x: 0, y: self.statueLab.bottom, width: kWidth, height: (kHeight-SafeAreaTopHeight-SafeAreaBottomHeight-AutoGetHeight(height: 49+90))/2  ))
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.zoomLevel = 15
        mapView.isZoomEnabled = true
        mapView.showsCompass = false
        mapView.delegate = self
        self.headView.addSubview(self.mapView)
    }
    
    func initHasLocatMapView()  {
        mapView = MAMapView.init(frame: CGRect.init(x: 0, y: self.statueLab.bottom, width: kWidth, height: (kHeight-SafeAreaTopHeight-SafeAreaBottomHeight-AutoGetHeight(height: 49+90))/2 ))
        mapView.zoomLevel = 15
        mapView.isZoomEnabled = true
        mapView.centerCoordinate = CLLocationCoordinate2DMake(self.curLatitude!,self.curLongitude!)
        mapView.delegate = self
        
        let annotion = MAPointAnnotation()
        var coor = CLLocationCoordinate2D()
        coor.latitude = self.curLatitude!
        coor.longitude = self.curLongitude!
        annotion.coordinate = coor
        self.headView.addSubview(self.mapView)
        self.mapView.addAnnotation(annotion)
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
    
// MARK: - 按钮点击事件
    @objc func signClick() {
        if self.isFromStatics{
            if self.isOutDate{
                SVProgressHUD.showInfo(withStatus: "时间已过期")
            }else{
                let vc = CQWorkOutReasonVC.init()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            let vc = CQWorkOutReasonVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc func workFinishClick(btn:UIButton)  {
        if self.isFromStatics{
            if self.isOutDate{
                SVProgressHUD.showInfo(withStatus: "时间已过期")
            }else{
                if self.detailModel?.attendanceRecordId != "0"{
//                    self.loadingPlay()
//                    self.workOutSignOut(btn:btn)
                      loadEarlySignOut(btn:btn)
                }else{
                    SVProgressHUD.showInfo(withStatus: "你尚未签到")
                }
            }
            
        }else{
            if self.detailModel?.attendanceRecordId != "0"{
                        loadEarlySignOut(btn:btn)
//                self.loadingPlay()
//                self.workOutSignOut(btn:btn)
            }else{
                SVProgressHUD.showInfo(withStatus: "你尚未签到")
            }
        }
    }
    //加载是否早退功能
    func loadEarlySignOut(btn:UIButton){
        self.loadingPlay()
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/outWork/checkAttendanceRecordEarly" ,
            type: .get,
            param: ["userId":userID],
            successCallBack: { (result) in
                self.loadingSuccess()
                if  result["data"]["isEarly"].boolValue{
                    //询问是否早退
                    //  SVProgressHUD.dismiss()
                    self.loadingSuccess()
                    let alert = UIAlertController.init(title: "是否提前申请下班?", message: "", preferredStyle: .alert)
                    let ok = UIAlertAction.init(title: "否", style: .default) { (al) in
                      
                        self.loadingPlay()
                        self.workOutSignOut(btn:btn)
                    }
                    let cancel = UIAlertAction.init(title: "是", style: .cancel) { (ca) in
                        //确认早退
                        //进入提前外出审批
                        let vc = CQEarlyWorkOutVC()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    alert.addAction(cancel)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    self.loadingPlay()
                    self.workOutSignOut(btn:btn)
                }
               
               
        }) { (error) in
            self.loadingSuccess()
        }
    }
    
    
    @objc func goHasGone()  {
        let now = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let recordDate = dateFormat.string(from: now)
        let vc = CQFootPrintVC.init()
        vc.recordDate = recordDate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func StaticsClick()  {
        let vc = CQStatisticsVC.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
 
    @objc func refreshOutWorkView(notification:Notification)  {
        self.setUpRefresh()
    }
    
}

// MARK: - 网络请求  获取当前签到状态
extension CQFieldPersonelVC{
  
        
   
    fileprivate func setUpRefresh() {
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/outWork/getOutWorkDetails" ,
            type: .get,
            param: ["version":CQVersion,
                    "userId":userID,
                    "recordDate":dateStr],
            successCallBack: { (result) in
                guard let model = CQFieldPersonalModel.init(jsonData: result["data"]) else {
                    return
                }
               
                self.detailModel = model

                var tempArray = [CQFieldPersonalModel]()
                for modalJson in result["data"]["punchData"].arrayValue {
                    guard let cardModel = CQFieldPersonalModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(cardModel)
                }
                
                self.curLatitude = result["data"]["latitudeValue"].doubleValue
                self.curLongitude = result["data"]["longitudeValue"].doubleValue
                
                if self.isFromStatics {
                    self.initHasLocatMapView()
                    self.locationLab.text = result["data"]["addressRemark"].stringValue
                }else{
                    self.locateMap()
                    self.initMapView()
                    
                }
                self.initView()
                self.createSignView(btnDataArray:tempArray)
                for i in 0..<tempArray.count{
                    if 0 == i {
                        if tempArray[i].punchTime != "签到"{
                            self.scrollView.setContentOffset(CGPoint.init(x:AutoGetWidth(width: 317), y: 0), animated: true)
                        }else{
                            self.scrollView.setContentOffset(CGPoint.init(x:AutoGetWidth(width: 0), y: 0), animated: true)
                        }
                    }
                }
                // 24.486354   118.181857
                if result["data"]["latitudeValue"].stringValue == "0"{
                    
                }else{
                    self.overlays = Array()
                    let circle: MACircle = MACircle(center: CLLocationCoordinate2D(latitude: result["data"]["latitudeValue"].doubleValue, longitude: result["data"]["longitudeValue"].doubleValue), radius: result["data"]["outRadius"].doubleValue)
                    self.overlays.append(circle)
                    self.mapView.addOverlays(self.overlays)
                    self.mapView.showOverlays(self.overlays, edgePadding: UIEdgeInsetsMake(20, 120, 20, 120), animated: true)
                }
                
               
                
                //self.perform(#selector(self.creatCircle(la:lo:radius:)), with: nil, afterDelay: 1)
                
                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    self.creatCircle(la: result["data"]["latitudeValue"].doubleValue, lo: result["data"]["longitudeValue"].doubleValue, radius: result["data"]["outRadius"].doubleValue)
//                }
//
//            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
//                self.creatCircle(la: 24.486354, lo: 118.181857, radius: 100)
//            }

        }) { (error) in
       
        }
    }
    
//    @objc func creatCircle(la:Double,lo:Double,radius:Double){
//        self.overlays = Array()
//        let circle: MACircle = MACircle(center: CLLocationCoordinate2D(latitude: la, longitude: lo), radius: radius)
//        //let circle: MACircle = MACircle(center: CLLocationCoordinate2D(latitude: 24.486354, longitude: 118.181857), radius: 100)
//        self.overlays.append(circle)
//        self.mapView.addOverlays(self.overlays)
//        self.mapView.showOverlays(self.overlays, edgePadding: UIEdgeInsetsMake(20, 120, 20, 120), animated: true)
//    }
    
}

// MARK: - 网络请求  外勤签退
extension CQFieldPersonelVC{
    func workOutSignOut(btn:UIButton) {
        let longitude = String(format: "%.6f", self.curLongitude!)
        let latitude = String(format: "%.6f", self.curLatitude!)
        STNetworkTools.requestData(URLString:"\(baseUrl)/outWork/updateSignBack" ,
            type: .post,
            param: ["attendanceRecordId":detailModel!.attendanceRecordId,
                    "latitudeValue":latitude,
                    "longitudeValue":longitude],
            successCallBack: { (result) in
                self.loadingSuccess()
                SVProgressHUD.showSuccess(withStatus: "签退成功")
                self.setUpRefresh()
                let btn = self.view.viewWithTag(100) as! UIButton
                btn.isUserInteractionEnabled = true
        }) { (error) in
            self.loadingSuccess()
        }
    }
    
    
    
}




// Mark:高德位置
extension CQFieldPersonelVC:AMapLocationManagerDelegate{
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


// MARK: - 构造打卡视图与底部视图
extension CQFieldPersonelVC{
    func createSignView(btnDataArray:[CQFieldPersonalModel])  {
        for i  in 0..<2 {
            let btnV = UIView.init(frame: CGRect.init(x: AutoGetWidth(width: 37) + (kWidth/5*4+AutoGetWidth(width: 15)) * CGFloat(i) , y: AutoGetHeight(height: 0), width:kWidth/5*4, height: (kHeight-SafeAreaTopHeight-SafeAreaBottomHeight-AutoGetHeight(height: 49+90))/2 - 10))
            btnV.backgroundColor = UIColor.white
            
            btnV.layer.shadowOpacity = 0.1;// 阴影透明度
            btnV.layer.shadowColor = UIColor.black.cgColor;// 阴影的颜色
            btnV.layer.shadowRadius = 1.3;// 阴影扩散的范围控制
            btnV.layer.shadowOffset = CGSize(width: 0, height: 0)// 阴影的范围
            
            btnV.layer.borderColor = kProjectDarkBgColor.cgColor
            btnV.layer.borderWidth = 0.7
            btnV.layer.cornerRadius = 5   //ExaCollectionBg
//            let img = UIImage(named: "ExaCollectionBg")
//            btnV.layer.contents = img?.cgImage
            
            if 0 == i {
                
                let btn1 = UIButton.init(type: UIButtonType.custom)
                 self.signInbtn = btn1
                btn1.frame = CGRect.init(x: (kWidth/5*4 - AutoGetWidth(width: 124))/2, y:  AutoGetHeight(height: 33), width: AutoGetWidth(width: 124), height: AutoGetWidth(width: 124))
                btn1.layer.cornerRadius = AutoGetWidth(width: 62)
                btn1.clipsToBounds = true
                btn1.setBackgroundImage(UIImage.init(named: "amBg"), for: UIControlState.normal)
                btn1.tag = 100+i
                
                btn1.addTarget(self, action: #selector(signClick), for: UIControlEvents.touchUpInside)
                btnV.addSubview(btn1)
                
                let staL = UILabel.init(frame: CGRect.init(x: 0, y: btn1.bottom + AutoGetHeight(height: 25), width:  kWidth/5*4, height: AutoGetHeight(height: 14)))
                staL.textAlignment = .center
                staL.tag = 200+i
                staL.font = UIFont.systemFont(ofSize: 14)
                staL.textColor = UIColor.colorWithHexString(hex: "#a9a9a9")
                let model = btnDataArray[i]
                btn1.setTitle("签到", for: .normal)
                if model.punchTime.count > 4{
//                     btn1.setTitle((model.punchTime as NSString).substring(with: NSRange.init(location: 0, length: 5)), for: .normal)
                    staL.text = (model.punchTime as NSString).substring(with: NSRange.init(location: 0, length: 5))
                }else{
//                     btn1.setTitle(model.punchTime, for: .normal)
                    staL.text = model.punchTime
                }
//                staL.text = model.punchMsg
                
//                if model.punchMsg == "您已签到"{
//                    btn1.isUserInteractionEnabled = false
//                }else{
//                    btn1.isUserInteractionEnabled = true
//                }
                
                let pie_Pic_Size = btn1.frame.width
                let pie_Pic = UIImageView.init(frame: CGRect(x: 0, y: 0, width: pie_Pic_Size/2, height: pie_Pic_Size/2))
                pie_Pic.layer.anchorPoint = CGPoint.init(x: 0, y: 1)
                pie_Pic.center = CGPoint(x: pie_Pic_Size/2, y: pie_Pic_Size/2)
                pie_Pic.image = UIImage.init(named: "radar_6")
                btn1.addSubview(pie_Pic)
                let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
                rotationAnimation.toValue = Double.pi * 2
                rotationAnimation.duration = 2
                rotationAnimation.repeatCount = 1
                pie_Pic.layer.add(rotationAnimation, forKey: "rotationAnimation")
                self.rada = pie_Pic
                rotationAnimation.isRemovedOnCompletion = true
                self.perform(#selector(removeRada), with: nil, afterDelay: 2)
                btnV.addSubview(staL)
            }else if 1 == i {
                
                let btn1 = UIButton.init(type: UIButtonType.custom)
                self.signOutbtn = btn1
                btn1.frame = CGRect.init(x: ( kWidth/5*4 - AutoGetWidth(width: 124))/2, y: AutoGetHeight(height: 33), width: AutoGetWidth(width: 124), height: AutoGetWidth(width: 124))
                btn1.layer.cornerRadius = AutoGetWidth(width: 62)
                btn1.clipsToBounds = true
                btn1.tag = 100+i
                btn1.setBackgroundImage(UIImage.init(named: "amBg"), for: UIControlState.normal)
                btn1.addTarget(self, action: #selector(workFinishClick(btn:)), for: UIControlEvents.touchUpInside)
                btnV.addSubview(btn1)
          
                let staL = UILabel.init(frame: CGRect.init(x: 0, y: btn1.bottom + AutoGetHeight(height: 25), width: kWidth/5*4, height: AutoGetHeight(height: 14)))
                staL.textAlignment = .center
                staL.font = UIFont.systemFont(ofSize: 14)
                staL.textColor = UIColor.colorWithHexString(hex: "#a9a9a9")
                staL.tag = 200+i
                btnV.addSubview(staL)
                let model1 = btnDataArray[i]
//                btn1.setTitle(model1.punchTime, for: .normal)
                btn1.setTitle("签退", for: .normal)
                if model1.punchTime.count > 4{
                    staL.text = (model1.punchTime as NSString).substring(with: NSRange.init(location: 0, length: 5))
                }else{
                    staL.text = model1.punchTime
                }
                
//                staL.text = model1.punchMsg
                let pie_Pic_Size = btn1.frame.width
                let pie_Pic = UIImageView.init(frame: CGRect(x: 0, y: 0, width: pie_Pic_Size/2, height: pie_Pic_Size/2))
                pie_Pic.layer.anchorPoint = CGPoint.init(x: 0, y: 1)
                pie_Pic.center = CGPoint(x: pie_Pic_Size/2, y: pie_Pic_Size/2)
                pie_Pic.image = UIImage.init(named: "radar_6")
                btn1.addSubview(pie_Pic)
                let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
                rotationAnimation.toValue = Double.pi * 2
                rotationAnimation.duration = 2
                rotationAnimation.repeatCount = 1
                pie_Pic.layer.add(rotationAnimation, forKey: "rotationAnimation")
                self.rada1 = pie_Pic
                rotationAnimation.isRemovedOnCompletion = true
                self.perform(#selector(removeRada1), with: nil, afterDelay: 2)
            }
            
            self.scrollView.addSubview(btnV)
        }
    }
    
    @objc func removeRada(){
        self.rada?.removeFromSuperview()
    }
    @objc func removeRada1(){
        self.rada1?.removeFromSuperview()
    }
    
    func createFootView() {
        for i in 0..<2 {
            let btn = UIButton.init(type: .custom)
            btn.frame = CGRect.init(x: kWidth/2 * CGFloat(i), y: 0, width: kWidth/2, height: AutoGetHeight(height: 49))
            if 0 == i {
                
                btn.addTarget(self, action: #selector(signClick), for: .touchUpInside)
                
                let img = UIImageView.init(frame: CGRect.init(x: (kWidth/2 - AutoGetWidth(width: 25))/2, y: AutoGetHeight(height: 3), width: AutoGetWidth(width: 25), height: AutoGetWidth(width: 25)))
                img.image = UIImage.init(named: "wortOutSign")
                img.isUserInteractionEnabled = false
                btn.addSubview(img)
                
                let lab = UILabel.init(frame: CGRect.init(x: 0, y:img.bottom + AutoGetHeight(height: 4.5), width: kWidth/2, height: AutoGetHeight(height: 10)))
                lab.font = UIFont.systemFont(ofSize: 11)
                lab.text = "签到"
                lab.textAlignment = .center
                lab.textColor = kBlueC
                lab.isUserInteractionEnabled = false
                btn.addSubview(lab)
            }else  {
                
                btn.addTarget(self, action: #selector(goHasGone), for: .touchUpInside)
                
                let img = UIImageView.init(frame: CGRect.init(x: (kWidth/2 - AutoGetWidth(width: 25))/2, y: AutoGetHeight(height: 3), width: AutoGetWidth(width: 25), height: AutoGetWidth(width: 25)))
                img.image = UIImage.init(named: "workOutGoneUnSelect")
                img.isUserInteractionEnabled = false
                btn.addSubview(img)
                
                let lab = UILabel.init(frame: CGRect.init(x: 0, y:img.bottom + AutoGetHeight(height: 4.5), width: kWidth/2, height: AutoGetHeight(height: 10)))
                lab.font = UIFont.systemFont(ofSize: 11)
                lab.text = "足迹"
                lab.textAlignment = .center
                lab.textColor = UIColor.colorWithHexString(hex: "#a9a9a9")
                lab.isUserInteractionEnabled = false
                btn.addSubview(lab)
            }
            self.footView.addSubview(btn)
        }
    }
}

extension CQFieldPersonelVC:MAMapViewDelegate{
//    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
//        if annotation.isKind(of: MAPointAnnotation.self) {
//            let pointReuseIndetifier = "pointReuseIndetifier"
//            let annotationView = MAAnnotationView.init(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
//            annotationView!.canShowCallout = true
//            return annotationView
//        }
//        return nil
//    }
    
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay.isKind(of: MACircle.self) {
            let renderer: MACircleRenderer = MACircleRenderer(overlay: overlay)
            renderer.lineWidth = 4.0
            renderer.strokeColor = kSignLocationbtnColor
            renderer.fillColor = kSignLocationbtnColor.withAlphaComponent(0.3)
            return renderer
        }
        return nil
    }
}


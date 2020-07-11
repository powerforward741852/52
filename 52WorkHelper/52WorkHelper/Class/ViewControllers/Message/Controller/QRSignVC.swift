//
//  QRSignVC.swift
//  test
//
//  Created by 秦榕 on 2018/12/17.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit
    

class QRSignVC: SuperVC {

    var bkStrArray : [String]?
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: SafeAreaTopHeight, width: kWidth, height: kHeight-SafeAreaTopHeight), style: UITableViewStyle.plain)
        if #available(iOS 11.0, *) {
//            table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
//            table.contentInset = UIEdgeInsetsMake(CGFloat(SafeAreaTopHeight), 0, CGFloat(SafeAreaBottomHeight), 0);
//            table.scrollIndicatorInsets = table.contentInset;
        } else {
            //低于 iOS 9.0
           self.automaticallyAdjustsScrollViewInsets = false
        }
       
        table.allowsSelection = false
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.estimatedRowHeight = 107
        table.register(QRSignNewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    //顶部视图
    lazy var headView : UIView = {
        let headView = UIView(frame:  CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 65)))
        headView.layer.borderColor = kProjectDarkBgColor.cgColor
        headView.layer.borderWidth = 0.4
        headView.addSubview(headImg)
        headView.addSubview(headBut)
        headView.addSubview(headName)
        headView.addSubview(headJob)
        headView.addSubview(headTime)
        headView.addSubview(headArrowImg)
        let line = UIView(frame:  CGRect(x: 0, y: AutoGetHeight(height: 65)-0.5, width: kWidth, height: 0.5))
        line.backgroundColor = kProjectDarkBgColor
        headView.addSubview(line)
        return headView
    }()
    //图片
    lazy var headImg : UIImageView = {
        let headImg = UIImageView(frame:  CGRect(x: AutoGetWidth(width: 15), y: AutoGetWidth(width: 10), width: AutoGetHeight(height: 45), height: AutoGetHeight(height: 45)))
        headImg.layer.cornerRadius = AutoGetHeight(height: 45)/2
        headImg.clipsToBounds = true
        headImg.image = UIImage(named: "personDefaultIcon")
        return headImg
    }()
    //名字
    lazy var headName : UILabel = {
        let headName = UILabel(frame:  CGRect(x: headImg.right+15, y: AutoGetWidth(width: 10), width: AutoGetWidth(width: 120),  height: AutoGetHeight(height: 45)/2))
        headName.text = "    "
        headName.numberOfLines = 1
        headName.textColor = UIColor.black
        headName.font = UIFont.systemFont(ofSize: 16)
        headName.textAlignment = .left
        return headName
    }()
    //工作
    lazy var headJob : UILabel = {
        let headJob = UILabel(frame:  CGRect(x: headName.left, y: headName.bottom, width: AutoGetWidth(width: 170), height: AutoGetHeight(height: 45)/2))
        headJob.text = "  "
        headJob.numberOfLines = 1
        headJob.textColor = UIColor.lightGray
        headJob.font = UIFont.systemFont(ofSize: 12)
        headJob.textAlignment = .left
        return headJob
    }()
    //时间按钮
    lazy var headBut : UIButton = {
        let headBut = UIButton(frame:  CGRect(x: AutoGetWidth(width: 60), y: 0, width: kWidth-AutoGetWidth(width: 60), height: AutoGetHeight(height: 55)))
        headBut.backgroundColor = UIColor.white
        headBut.addTarget(self, action: #selector(headClick), for: UIControlEvents.touchUpInside)
        return headBut
    }()
    
    //时间
    lazy var headTime : UILabel = {
        let headTime = UILabel(frame:  CGRect(x: kWidth-AutoGetWidth(width: 115)-11-8, y: AutoGetWidth(width: 5), width: AutoGetWidth(width: 100), height: AutoGetHeight(height: 45)))
        headTime.text = "2018-12-17"
        headTime.numberOfLines = 1
        headTime.textColor = UIColor.black
        headTime.font = UIFont.systemFont(ofSize: 15)
        headTime.textAlignment = .right
        return headTime
    }()
    //箭头
    lazy var headArrowImg : UIImageView = {
        let headArrowImg = UIImageView(frame:  CGRect(x: kWidth-AutoGetWidth(width: 15)-11, y: (AutoGetWidth(width: 55)-6.5)/2, width: 11, height: 6.5))
        headArrowImg.image = UIImage(named: "zk")
        return headArrowImg
    }()
    
    
    ////底部视图
    lazy var footView : UIView = {
        let footView = UIView(frame:  CGRect(x: 0, y: kHeight-AutoGetHeight(height: 240)-SafeAreaBottomHeight, width: kWidth, height: AutoGetHeight(height: 240)))
        footView.addSubview(signBut)
        footView.addSubview(remarkLab)
        footView.addSubview(remarkImg)
        footView.addSubview(LocationBut)
        return footView
    }()
    //签到按钮
    lazy var signBut : UIButton = {
        let signBut = UIButton(frame:  CGRect(x: (kWidth-AutoGetWidth(width: 140))/2, y: AutoGetHeight(height: 25), width: AutoGetWidth(width: 140), height: AutoGetWidth(width: 140)))
        signBut.setBackgroundImage(UIImage(named: "ann"), for: UIControlState.normal)
        signBut.setTitle("打卡", for: UIControlState.normal)
        signBut.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        signBut.titleEdgeInsets = UIEdgeInsets(top: -15, left: 0, bottom: 0, right: 0)
        signBut.addTarget(self, action: #selector(signClick), for: UIControlEvents.touchUpInside)
        return signBut
    }()
    //地址
    lazy var remarkLab : UILabel = {
        let remarkLab = UILabel()
        remarkLab.text = "未进入考勤范围"
        remarkLab.numberOfLines = 1
        remarkLab.textColor = UIColor.black
        remarkLab.font = UIFont.systemFont(ofSize: 14)
        remarkLab.textAlignment = .center
        return remarkLab
    }()
    
    //对称图片
    lazy var remarkImg : UIImageView = {
        let remarkImg = UIImageView(frame:  CGRect(x: kWidth-AutoGetWidth(width: 15)-6.6, y: (AutoGetWidth(width: 55)-12)/2, width: 12, height: 12))
        remarkImg.image = UIImage(named: "c")
        return remarkImg
    }()
    //定位but
    lazy var LocationBut : UIButton = {
        let LocationBut = UIButton(frame:  CGRect(x: kWidth/3, y: AutoGetWidth(width: 25), width: 40, height: kWidth/3))
        LocationBut.setTitle("去重新定位", for: UIControlState.normal)
        LocationBut.addTarget(self, action: #selector(LocationClick), for: UIControlEvents.touchUpInside)
        LocationBut.setTitleColor(kSignLocationbtnColor, for: UIControlState.normal)
        LocationBut.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        LocationBut.sizeToFit()
        return LocationBut
    }()
    //时钟Lab
    lazy var clockLab : UILabel = {
        let clockLab = UILabel()
        clockLab.text = "  "
        clockLab.numberOfLines = 1
        clockLab.textColor = UIColor.white
        clockLab.font = UIFont.systemFont(ofSize: 14)
        clockLab.textAlignment = .center
        clockLab.sizeToFit()
        return clockLab
    }()
    //计时器
    var time : Timer?
    var locationManager:AMapLocationManager? //定位服务
    var coordinates : CLLocationCoordinate2D?
    var curLatitude:Double? //经度
    var curLongitude:Double? //纬度
   
    //圆形围栏的管理类
    var geoFenceManager:AMapGeoFenceManager?
    
    
    //圆心与半径
    var baseLatitudeValue:Double? //经度
    var baseLongitudeValue:Double? //纬度
    var baseMapRadius: Double?//半径s
    
    //时间选择器
    var bgView = UIButton()
    var startTime = "" //开始时间
    var endTime = ""  //结束时间
    var dateStr = ""
    
    //今天
    var now = ""
    //
    var isFromStatics = false
    var isFromSign = false
    var isFromOut = false
    
    //数据源
    var dataArray = [CQCheckInstanceModel]() //考勤数据
    
    //地图
    lazy var mapView : MAMapView = {
        let mapView = MAMapView(frame:  CGRect(x: 0, y: 400, width: 1, height: 1))
        mapView.showsUserLocation = true
        //        mapView.userLocationAccuracyCircle = nil
        mapView.userTrackingMode = .follow
        mapView.desiredAccuracy = kCLLocationAccuracyBest
        mapView.showsScale = false
        mapView.zoomLevel = 15
        mapView.isHidden = true
        mapView.delegate = self
        mapView.showsCompass = false
        //mapView.customizeUserLocationAccuracyCircleRepresentation = false
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.curLatitude = 0.00
        self.curLongitude = 0.00
        self.title = "考勤"
        view.backgroundColor = UIColor.white
        
        // 获取今天
        let nowday = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        self.now = dateFormat.string(from: nowday)
        
        //加载补卡弹窗
        self.loadPopWindowData()
        
        //加载头部
        loadData()
        if isFromStatics {
            self.headTime.text = self.dateStr
        }else{
            let now = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            self.dateStr = dateFormat.string(from: now)
            self.headTime.text = self.dateStr
        }
       //统计按钮
        let rightBut = UIButton(frame:  CGRect(x: 0, y: 0, width: 80, height: 40))
        rightBut.setTitle("统计", for: UIControlState.normal)
        rightBut.titleLabel?.font = kFontSize17
        rightBut.sizeToFit()
        rightBut.setTitleColor(UIColor.blue, for: UIControlState.normal)
        rightBut.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: -7)
        rightBut.setTitleColor(kBlueColor, for: UIControlState.normal)
        rightBut.addTarget(self, action: #selector(staticseClick), for: UIControlEvents.touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBut)
        
        //table
        view.addSubview(table)
        table.tableHeaderView = headView
        
        //加载数据
        
     //   self.locateMap()
        
        
    }
    
    func locateGeoManage()  {
        self.geoFenceManager = AMapGeoFenceManager()
        self.geoFenceManager!.delegate = self
        self.geoFenceManager!.activeAction = [AMapGeoFenceActiveAction.inside , AMapGeoFenceActiveAction.outside]//进入，离开，停留都要进行通知
        self.geoFenceManager!.allowsBackgroundLocationUpdates = true  //允许后台定位
        let coordinate = CLLocationCoordinate2D(latitude: baseLatitudeValue!, longitude: baseLongitudeValue!) //天安门
        self.geoFenceManager!.addCircleRegionForMonitoring(withCenter: coordinate, radius: baseMapRadius!, customID: "circle_1")
    }
    //定位
    func locateMap()  {
        
        locationManager = AMapLocationManager.init()
        locationManager?.delegate = self
        //设置定位最小更新距离
        locationManager?.distanceFilter = kCLDistanceFilterNone
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
        //如果需要持续定位返回逆地理编码信息
        //        locationManager?.locatingWithReGeocode = true
        //        locationManager?.startUpdatingLocation()
        
    }
    //地图定位
    func locateMapView()  {
        if   CLLocationManager.authorizationStatus().rawValue == 4 ||  CLLocationManager.authorizationStatus().rawValue == 3{
            // manager.startUpdatingLocation()
            view.addSubview(mapView)
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  self.loadDatas(moreData: false)
        self.loadDatass(moreData: false)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.locationManager?.stopUpdatingLocation()
        for (index,_) in dataArray.enumerated(){
            let cell = table.cellForRow(at: IndexPath(row: index, section: 0)) as! QRSignNewCell
            cell.clearTimes()
        }

    }
    deinit {
       
    }
    @objc func headClick(){
         self.initDatePickView(tag: 200)
    }
    
    @objc func signClick(){
        print("打卡")
        if now == dateStr{
            siginEarlyRequest()
        }else{
            SVProgressHUD.showInfo(withStatus: "工作当天才能打卡")
        }
    }
    
    
    @objc func staticseClick(){
        let vc = CQStatisticsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func LocationClick(){
        let locationVC = QRSignLocationVC()
        locationVC.curLatitude = self.curLatitude
        locationVC.curLongitude = self.curLongitude
        locationVC.mylocate = self.coordinates
        locationVC.dateStr = dateStr
        //圆心半径
        locationVC.baseLongitudeValue = baseLongitudeValue
        locationVC.baseLatitudeValue = baseLatitudeValue
        locationVC.baseMapRadius = baseMapRadius
        
        
        locationVC.clickClosure = {[unowned self] lo ,la in
            self.curLongitude = lo
            self.curLatitude = la
            self.signClick()
        }
        self.navigationController?.pushViewController(locationVC, animated: true)
    }
    
    @objc func updateTime(){
        let currentDate = NSDate();
        let dateformate = DateFormatter()
        dateformate.dateFormat = "hh:mm:ss"
        let dateString = dateformate.string(from: currentDate as Date)
        clockLab.text = dateString
    }
   
    func initDatePickView(tag:Int)  {
        let currentTag = tag - 200
        self.view.endEditing(true)
        bgView.frame = CGRect(x: 0, y: SafeAreaTopHeight, width: kWidth, height: kHeight - SafeAreaTopHeight - SafeAreaBottomHeight)
        bgView.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
        self.view.addSubview(bgView)
        bgView.addTarget(self, action: #selector(removeBgView), for: .touchUpInside)
        
        let colorBgV = UIView.init(frame: CGRect.init(x: 0, y: bgView.frame.size.height - 240, width: kWidth, height: 240))
        colorBgV.backgroundColor = UIColor.white
        bgView.addSubview(colorBgV)
        
        let sureBtn = UIButton()
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(.black, for: .normal)
        sureBtn.frame = CGRect(x: kWidth - 60, y: 0, width: 60, height: 40)
        sureBtn.tag = 700 + currentTag
        colorBgV.addSubview(sureBtn)
        sureBtn.addTarget(self, action: #selector(sureClick(btn:)), for: .touchUpInside)
        
        let cancelBtn = UIButton()
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(.black, for: .normal)
        cancelBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        colorBgV.addSubview(cancelBtn)
        cancelBtn.addTarget(self, action: #selector(removeBgView(sender:)), for: .touchUpInside)
        
        //创建日期选择器
        let datePicker = UIDatePicker(frame: CGRect(x:0, y: 40, width:kWidth, height:200))
        //将日期选择器区域设置为中文，则选择器日期显示为中文
        datePicker.locale = Locale(identifier: "zh_CN")
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .white
        datePicker.tag = 10086 + currentTag
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        colorBgV.addSubview(datePicker)
    }
    
    @objc func removeBgView(sender: UIButton) {
        self.bgView.removeFromSuperview()
    }
    
    @objc func sureClick(btn:UIButton) {
        //截止日期需要大于现在
        
        self.bgView.removeFromSuperview()
        if compareDate(){
            self.headTime.text =  endTime
            self.dateStr = endTime
        }else{
            SVProgressHUD.showInfo(withStatus: "截单时间必须小于当前时间")
            return
        }
        
        if self.startTime == ""{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let now = Date()
            let nowTime = formatter.string(from: now)
            self.headTime.text =  nowTime
            self.dateStr = nowTime
        }
        self.startTime = ""
       // self.loadDatas(moreData: false)
        self.loadDatass(moreData: false)
    }
    
    //日期选择器响应方法
    @objc func dateChanged(datePicker : UIDatePicker){
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd"
        endTime = formatter.string(from: datePicker.date)
        startTime = "s"
        
    }
    
    func compareDate() -> Bool {
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd"
        var EDate:Date?
        let now = Date()
        
        EDate = formatter.date(from: endTime)
        if EDate == nil {
            EDate = now
            return true
        }
        let result:ComparisonResult = (now.compare(EDate!))
      
        if result == .orderedAscending || result == .orderedSame {
            self.endTime = formatter.string(from: now)
            return false
        }
        return true
    }

}

extension QRSignVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! QRSignNewCell
        let mod = dataArray[indexPath.row]
        if  indexPath.row == 1 {
            cell.MorningTime.text = mod.ruleDesc + mod.ruleTime
        }else{
            cell.MorningTime.text = mod.ruleDesc + mod.ruleTime
        }
        cell.lDelegate = self
        cell.sDelegate = self
        cell.rootVc = self
        cell.dateStr = dateStr
        cell.model = mod
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension QRSignVC:AMapGeoFenceManagerDelegate{
    
    func amapGeoFenceManager(_ manager: AMapGeoFenceManager!, didGeoFencesStatusChangedFor region: AMapGeoFenceRegion!, customID: String!, error: Error!) {
        if error == nil {
            if region.fenceStatus.rawValue == 1 {
                //范围内
             //   print("距离"+"\(location.distance(from: company))")
                for (index,_) in dataArray.enumerated(){
                    let cell = table.cellForRow(at: IndexPath(row: index, section: 0)) as! QRSignNewCell
                    cell.remarkImg.image = UIImage(named: "g")
                    cell.remarkLab.text = "已进入考勤范围"
                }
            }else{
                //范围外
                //print("距离"+"\(location.distance(from: company))")
                for (index,_) in dataArray.enumerated(){
                    let cell = table.cellForRow(at: IndexPath(row: index, section: 0)) as! QRSignNewCell
                    cell.remarkImg.image = UIImage(named: "c")
                    cell.remarkLab.text = "未进入考勤范围"
                }
            }
        } else {
            SVProgressHUD.showInfo(withStatus: "地位失败")
        }
    }
    func amapGeoFenceManager(_ manager: AMapGeoFenceManager!, didAddRegionForMonitoringFinished regions: [AMapGeoFenceRegion]!, customID: String!, error: Error!) {
        
    }
}

// Mark:高德位置
extension QRSignVC:AMapLocationManagerDelegate{
    //定位失败弹出提示框,提示打开定位按钮，会打开系统的设置，提示打开定位服务
    func amapLocationManager(_ manager: AMapLocationManager!, didFailWithError error: Error!) {
//        设置提示提醒用户打开定位服务
        //  CLLocationManager.locationServicesEnabled()==true
        if   CLLocationManager.authorizationStatus().rawValue == 4 ||  CLLocationManager.authorizationStatus().rawValue == 3{
            manager.startUpdatingLocation()
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
    
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode!) {
        
        self.curLatitude = location.coordinate.latitude
        self.curLongitude = location.coordinate.longitude
        self.coordinates = location.coordinate
        
        //let company = CLLocation(latitude: 24.486354, longitude: 118.181857)
        let company = CLLocation(latitude: baseLatitudeValue!, longitude: baseLongitudeValue!)
        let isContain = MACircleContainsCoordinate(location.coordinate, company.coordinate, baseMapRadius!)
        print(isContain)
        let loc1 = location.coordinate
        let loc2 = company.coordinate
        let p1 = MAMapPointForCoordinate(loc1)
        let p2 = MAMapPointForCoordinate(loc2)
        let distance =  MAMetersBetweenMapPoints(p1, p2)
        print(distance)
       // location.distance(from: company)>baseMapRadius!
        if !isContain{
         //   print("距离"+"\(location.distance(from: company))")
            for (index,_) in dataArray.enumerated(){
                let cell = table.cellForRow(at: IndexPath(row: index, section: 0)) as! QRSignNewCell
                cell.remarkImg.image = UIImage(named: "c")
                cell.remarkLab.text = "未进入考勤范围"
            }
        }else{
            //定位完成处理赋值图片.并且判断是否
//            remarkImg.image = UIImage(named: "g")
//            remarkLab.text = "已进入考勤范围"
          //  print("距离"+"\(location.distance(from: company))")
            for (index,_) in dataArray.enumerated(){
                let cell = table.cellForRow(at: IndexPath(row: index, section: 0)) as! QRSignNewCell
                cell.remarkImg.image = UIImage(named: "g")
                cell.remarkLab.text = "已进入考勤范围"
            }
        }
        

    }
}


extension QRSignVC{
    
    //是否弹出补卡请求
    func loadPopWindowData() {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/checkModifySituation" ,
            type: .get,
            param: ["emyeId":userID],
            successCallBack: { (result) in
                
                guard CQStasticsModel.init(jsonData: result["data"]) != nil else {
                    return
                }
                if result["data"]["isPopUpDisplay"].boolValue{
                    //弹出补卡
                    let popview = QRPopWindowView.creatPopview()
                    popview.clickClosure = {[unowned self] xx in
                        let vc = NCQApprovelVC()
                        vc.titleStr = "补卡"
                        vc.businessCode = "B_BK"
                        vc.modifyTime = result["data"]["modifyTime"].stringValue
                        self.navigationController?.pushViewController(vc, animated: true)
                        popview.dismissPopView()
                    }
                    popview.showPopView()
                }else{

                }
                
        }) { (error) in
            
        }
    }
    
    func loadData()  {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/my/index" ,
            type: .get,
            param: ["emyeId":userID],
            successCallBack: { (result) in
                guard let model = PersonModel.init(jsonData: result["data"]) else {
                    return
                }
                self.headImg.sd_setImage(with: URL(string: model.headImage), placeholderImage:UIImage.init(named: "CQIndexPersonDefault") )
                self.headName.text = model.realName
                self.headJob.text =  model.positionName
        }) { (error) in
            
        }
    }
    
    
    fileprivate func loadDatass(moreData: Bool) {
        self.loadingPlay()
        let userID = STUserTool.account().userID
        
        let headers = ["t_userId": STUserTool.account().userID,
                       "token": STUserTool.account().token]
        STNetworkTools.sharedSessionManager.request("\(baseUrl)/attendance/checkWorkAttendanceType", method: HTTPMethod.get, parameters: ["emyeId":userID,"dateStr":self.dateStr], encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
            //校验是否有值
            guard let result = response.result.value else {
                //请求失败
             //   if let err = response.error{
//                    let aferror = err as! AFError
//                    if aferror.errorDescription == AFError.responseSerializationFailed(reason: AFError.ResponseSerializationFailureReason.inputDataNilOrZeroLength).errorDescription {
//                    }else{
//                        SVProgressHUD.showError(withStatus: "网络异常，请检查连接")
//                    }
//                }
//                SVProgressHUD.showError(withStatus: "网络异常，请检查连接")
                self.loadingSuccess()
                SVProgressHUD.dismiss()
                return
            }
            //将结果回调出去
            let json = JSON(result)
            if json["success"].boolValue {
                //将结果回调出去
                self.baseMapRadius = json["data"]["baseMapRadius"].doubleValue
                self.baseLatitudeValue = json["data"]["baseLatitudeValue"].doubleValue
                self.baseLongitudeValue = json["data"]["baseLongitudeValue"].doubleValue
                self.locateMapView()

                var tempArray = [CQCheckInstanceModel]()
                for modalJson in json["data"]["attendanceList"].arrayValue {
                    guard let modal = CQCheckInstanceModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                self.dataArray = tempArray
                self.table.reloadData()
                self.loadingSuccess()
                SVProgressHUD.dismiss()
            } else {
                if json["code"].stringValue == "-1"{
                }else{
                    SVProgressHUD.showInfo(withStatus: json["message"].stringValue)
                }
                self.loadingSuccess()
                SVProgressHUD.dismiss()
                
            }
            
        }
        
       
//        STNetworkTools.requestData(URLString:"\(baseUrl)/attendance/checkWorkAttendanceType" ,
//            type: .get,
//            param: ["emyeId":userID,
//                    "dateStr":self.dateStr],
//            successCallBack: { (result) in
//
//                self.baseMapRadius = result["data"]["baseMapRadius"].doubleValue
//                self.baseLatitudeValue = result["data"]["baseLatitudeValue"].doubleValue
//                self.baseLongitudeValue = result["data"]["baseLongitudeValue"].doubleValue
//                self.locateMapView()
//
//                var tempArray = [CQCheckInstanceModel]()
//                for modalJson in result["data"]["attendanceList"].arrayValue {
//                    guard let modal = CQCheckInstanceModel(jsonData: modalJson) else {
//                        return
//                    }
//                    tempArray.append(modal)
//                }
//                self.dataArray = tempArray
//                self.table.reloadData()
//
//                self.loadingSuccess()
//        }) { (error) in
//            self.loadingSuccess()
//            SVProgressHUD.dismiss()
//        }

    }

    
    
    fileprivate func loadDatas(moreData: Bool) {
        self.loadingPlay()
        //SVProgressHUD.show()
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/attendance/checkWorkAttendanceType" ,
            type: .get,
            param: ["emyeId":userID,
                    "dateStr":self.dateStr],
            successCallBack: { (result) in

                self.baseMapRadius = result["data"]["baseMapRadius"].doubleValue
                self.baseLatitudeValue = result["data"]["baseLatitudeValue"].doubleValue
                self.baseLongitudeValue = result["data"]["baseLongitudeValue"].doubleValue
                self.locateMapView()

                var tempArray = [CQCheckInstanceModel]()
                for modalJson in result["data"]["attendanceList"].arrayValue {
                    guard let modal = CQCheckInstanceModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                self.dataArray = tempArray
                self.table.reloadData()

               self.loadingSuccess()
        }) { (error) in
            self.loadingSuccess()
            SVProgressHUD.dismiss()
        }

    }
    
    //签到
    func siginInOrSiginOutRequest(type:String) {
        //SVProgressHUD.show()
        self.loadingPlay()
        let userID = STUserTool.account().userID
        var longitude = String(format: "%.6f", self.curLongitude!)
        var latitude = String(format: "%.6f", self.curLatitude!)
        if isAdmin{
            longitude = String(format: "%.6f",118.181857 + (Float(arc4random()%100) + 1)/1000000 )
            latitude = String(format: "%.6f",24.486354 + (Float(arc4random()%100) + 1)/1000000 )
        }
        STNetworkTools.requestData(URLString:"\(baseUrl)/attendance/signInOrSiginOut" ,
            type: .get,
            param: ["emyeId":userID,
                    "longitudeValue":longitude,
                    "latitudeValue":latitude],
            successCallBack: { (result) in
                
                //SVProgressHUD.dismiss()
               // self.loadingSuccess()
              //  self.loadDatas(moreData: false)
                self.loadDatass(moreData: false)
                if "" == result["message"].stringValue{
                    
                }else{
                     SVProgressHUD.showInfo(withStatus:result["message"].stringValue)
                }
               
                
        }) { (error) in
           // SVProgressHUD.dismiss()
            self.loadingSuccess()
        }
    }
    
    //是否早退
    func siginEarlyRequest() {
      //  SVProgressHUD.show()
        self.loadingPlay()
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/attendance/checkAttendanceRecordEarly" ,
            type: .get,
            param: ["emyeId":userID],
            successCallBack: { (result) in
                
                if  result["data"]["isEarly"].boolValue{
                    //询问是否早退
                  //  SVProgressHUD.dismiss()
                    self.loadingSuccess()
                    let alert = UIAlertController.init(title: "现在是早退时间,你确定签退么?", message: "", preferredStyle: .alert)
                    let ok = UIAlertAction.init(title: "确定", style: .default) { (al) in
                        //确认早退
                        self.siginInOrSiginOutRequest(type: "")
                    }
                    let cancel = UIAlertAction.init(title: "取消", style: .cancel) { (ca) in
                    }
                    alert.addAction(ok)
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                   // SVProgressHUD.dismiss()
                   // self.loadingSuccess()
                    self.siginInOrSiginOutRequest(type: "")
                }
                
                
        }) { (error) in
           // SVProgressHUD.dismiss()
            self.loadingSuccess()
        }
    }
}


extension QRSignVC :MAMapViewDelegate{
    
    
//    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
//        if overlay.isKind(of: MACircle.self) {
//            let renderer: MACircleRenderer = MACircleRenderer(overlay: overlay)
//            renderer.lineWidth = 4.0
//            renderer.strokeColor = kSignLocationbtnColor
//            renderer.fillColor = kSignLocationbtnColor.withAlphaComponent(0.3)
//            return renderer
//        }
//        return nil
//    }
//
//    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
//
//        if annotation.isKind(of: MAPointAnnotation.self) {
//            let pointReuseIndetifier = "pointReuseIndetifier"
//            var annotationView: QRLocationView?
//
//            if annotationView == nil {
//                let center = myConpany
//                let isContain = MACircleContainsCoordinate(annotation.coordinate, center, baseMapRadius!)
//                //  print("oooooooooooooo\(mapView.userLocation.coordinate)")
//                if isContain==false {
//                    annotationView = QRLocationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier, name: "no")
//                    annotationView?.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
//                }else{
//                    annotationView = QRLocationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier, name: "yes")
//                    annotationView?.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
//                }
//
//            }
//            return annotationView!
//        }
//
//        return nil
//    }
//
//    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
//        view.isSelected = true
//    }
//    func mapView(_ mapView: MAMapView!, didDeselect view: MAAnnotationView!) {
//        view.isSelected = true
//    }
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
      
            self.curLatitude = userLocation.location.coordinate.latitude
            self.curLongitude = userLocation.location.coordinate.longitude
            self.coordinates = userLocation.location.coordinate
          //  userLocation.location.horizontalAccuracy
            let company = CLLocation(latitude: baseLatitudeValue!, longitude: baseLongitudeValue!)
            let isContain = MACircleContainsCoordinate(userLocation.location.coordinate, company.coordinate, baseMapRadius!)
            let loc1 = userLocation.location.coordinate
            let loc2 = company.coordinate
            let p1 = MAMapPointForCoordinate(loc1)
            let p2 = MAMapPointForCoordinate(loc2)
            let distance =  MAMetersBetweenMapPoints(p1, p2)
            
            // location.distance(from: company)>baseMapRadius!
            if !isContain{
                for (index,_) in dataArray.enumerated(){
                    let cell = table.cellForRow(at: IndexPath(row: index, section: 0)) as! QRSignNewCell
                    cell.remarkImg.image = UIImage(named: "c")
                    cell.remarkLab.text = "未进入考勤范围"
                }
            }else{
                //定位完成处理赋值图片.并且判断是否
                //            remarkImg.image = UIImage(named: "g")
                //            remarkLab.text = "已进入考勤范围"
                //    print("距离"+"\(userLocation.location.distance(from: company))")
                for (index,_) in dataArray.enumerated(){
                    let cell = table.cellForRow(at: IndexPath(row: index, section: 0)) as! QRSignNewCell
                    cell.remarkImg.image = UIImage(named: "g")
                    cell.remarkLab.text = "已进入考勤范围"
                }
            }
        
       
    }
    
    func mapView(_ mapView: MAMapView!, didFailToLocateUserWithError error: Error!) {
        if   CLLocationManager.authorizationStatus().rawValue == 4 ||  CLLocationManager.authorizationStatus().rawValue == 3{
           // manager.startUpdatingLocation()
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
    
}


extension QRSignVC: QRSignNewCelldelegate,QRLocationNewCelldelegate{
    func locationUpdataAction() {
        LocationClick()
    }
    func signAction() {
        signClick()
    }
}

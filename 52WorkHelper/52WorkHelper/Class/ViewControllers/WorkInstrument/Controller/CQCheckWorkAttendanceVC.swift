//
//  CQCheckWorkAttendanceVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/4/26.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQCheckWorkAttendanceVC: SuperVC {
    
    var signView:CQCheckAddantenceView?
    var locationManager:AMapLocationManager? //定位服务
    var curLatitude:Double? //经度
    var curLongitude:Double? //纬度
    var dataArray = [CQCheckInstanceModel]() //考勤数据
    var pmEndEarlyRule = ""
    var dateStr = ""
    var isFromStatics = false
    var isGoApplyCard = false
    var applyId = ""
    var curDate = ""
    var isFromSign = false
    var isFromOut = false
    var attendanceTime = ""
    var isScrollToBack = ""
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - 64), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 351)-64))
        return headView
    }()
    
    lazy var headImg: UIImageView = {
        let headImg = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 351)-64))
        let hour = self.getHour()
        if hour > 12 {
            headImg.image = UIImage.init(named: "workPmF")
        }else{
            headImg.image = UIImage.init(named: "workAmF")
        }
        
        return headImg
    }()
    
    lazy var dateLab: UILabel = {
        let dateLab = UILabel.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 55), width: kWidth, height: AutoGetHeight(height: 19)))
        dateLab.textAlignment = .center
        
        let now = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy年MM月dd日"
        let str = dateFormat.string(from: now)
        
        dateLab.text = str
        dateLab.textColor = UIColor.white
        dateLab.font = UIFont.systemFont(ofSize: 19)
        return dateLab
    }()
    
    lazy var weekLab: UILabel = {
        let weekLab = UILabel.init(frame: CGRect.init(x: 0, y: self.dateLab.bottom + AutoGetHeight(height: 12), width: kWidth, height: AutoGetHeight(height: 48)))
        weekLab.textAlignment = .center
        let weeks = ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
        let now = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str = dateFormat.string(from: now)
        let week = weeks[dateFormat.date(from: str)!.resultWeek()]
        weekLab.text = week
        weekLab.textColor = UIColor.white
        weekLab.font = UIFont.systemFont(ofSize: 48)
        return weekLab
    }()
    
    lazy var statueLab: UILabel = {
        let statueLab = UILabel.init(frame: CGRect.init(x: 0, y: self.weekLab.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 19)))
        statueLab.textAlignment = .center
        statueLab.text = "上班中"
        statueLab.textColor = UIColor.white
        statueLab.font = UIFont.systemFont(ofSize: 19)
        return statueLab
    }()
    
    lazy var signNameLab: UILabel = {
        let signNameLab = UILabel.init(frame: CGRect.init(x: 0, y: self.statueLab.bottom + AutoGetHeight(height: 45), width: kWidth, height: AutoGetHeight(height: 15)))
        signNameLab.textAlignment = .center
        signNameLab.text = "上班中"
        signNameLab.textColor = UIColor.white
        signNameLab.font = UIFont.systemFont(ofSize: 15)
        return signNameLab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        self.title = "考勤"
        
        if isFromStatics {
            self.dateLab.text = self.dateStr
            let weeks = ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            let week = weeks[dateFormat.date(from: self.dateStr)!.resultWeek()]
            self.weekLab.text = week
        }else{
            let now = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            self.dateStr = dateFormat.string(from: now)
        }
        
        self.locateMap()
        self.setUpRefresh()
        
        self.view.backgroundColor = UIColor.colorWithHexString(hex: "f7f7f7")
//        self.navigationController?.navigationBar.subviews[0].removeFromSuperview() //
        
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.view.addSubview(self.table)
//        self.view.addSubview(self.headView)
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.headImg)
        self.headView.addSubview(self.dateLab)
        self.headView.addSubview(self.weekLab)
        self.headView.addSubview(self.statueLab)
        self.headView.addSubview(self.signNameLab)
        self.attendanceWordRequest()
        
        let btn = UIButton.init(type: .custom)
       // btn.frame = CGRect.init(x: 0, y: 0, width: 60, height: 40)
        btn.setTitle("统计", for: .normal)
        btn.sizeToFit()
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(stasticClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: btn)
        self.navigationItem.rightBarButtonItem = rightItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.leftBarButtonItem = self.barBackWhiteButton()
        let hour = self.getHour()
        if hour > 12 {
            
            self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "workPmH"), for: .default)
        }else{
            self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "workAmH"), for: .default)
        }
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20),NSAttributedStringKey.foregroundColor:UIColor.white]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20),NSAttributedStringKey.foregroundColor:UIColor.white]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.locationManager?.stopUpdatingLocation()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: ""), for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black]
    }
    
    
    func initSignView(dataArr:[CQCheckInstanceModel]) {
        signView = CQCheckAddantenceView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 309)))
        signView?.signDelegate = self
        signView?.dataArray = dataArr
        self.table.tableFooterView = signView
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
    
    @objc func stasticClick()  {
        let vc = CQStatisticsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}



extension CQCheckWorkAttendanceVC{
    fileprivate func setUpRefresh() {
        // MARK:header
        let STHeader = CQRefreshHeader {[unowned self] in
            self.loadDatas(moreData: false)
        }
        
        self.table.mj_header = STHeader
        self.table.mj_header.beginRefreshing()
    }
    // MARK:request
    fileprivate func loadDatas(moreData: Bool) {
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/attendance/checkWorkAttendanceType" ,
            type: .get,
            param: ["emyeId":userID,
                    "dateStr":self.dateStr],
            successCallBack: { (result) in
                
                var tempArray = [CQCheckInstanceModel]()
                for modalJson in result["data"]["attendanceList"].arrayValue {
                    guard let modal = CQCheckInstanceModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                self.dataArray = tempArray
                
                let attendanceStatus = result["data"]["attendanceStatus"].stringValue
                self.statueLab.text = attendanceStatus
                self.pmEndEarlyRule =  result["data"]["pmEndEarlyRule"].stringValue
                

                
                self.initSignView(dataArr: self.dataArray)
                //刷新表格
                self.table.mj_header.endRefreshing()
                self.table.reloadData()
                
                if self.isFromOut || self.isFromSign{
                    if self.isFromOut{
                        for i in 0..<self.dataArray.count{
                            if 0 == i {
//                                if self.dataArray[i].attendanceTime.count > 0{
                                    self.signView?.scrollView.setContentOffset(CGPoint.init(x:AutoGetWidth(width: 317), y: 0), animated: true)
//                                }
                            }else if 2 == i{
//                                if self.dataArray[i].attendanceTime.count > 0{
                                    self.signView?.scrollView.setContentOffset(CGPoint.init(x: AutoGetWidth(width: 317) * 3 , y: 0), animated: true)
//                                }
                            }
                        }
                    }
                }else{
//                    for i in 0..<self.dataArray.count{
//                        if 0 == i {
////                            if self.dataArray[i].attendanceTime.count > 0{
//                                self.signView?.scrollView.setContentOffset(CGPoint.init(x:AutoGetWidth(width: 317), y: 0), animated: true)
////                            }
//                        }else if 2 == i{
////                            if self.dataArray[i].attendanceTime.count > 0{
//                                self.signView?.scrollView.setContentOffset(CGPoint.init(x: AutoGetWidth(width: 317) * 3 , y: 0), animated: true)
////                            }
//                        }
//                    }
                }
                
                
                if self.isScrollToBack == "下午签退"{
                    self.signView?.scrollView.setContentOffset(CGPoint.init(x: AutoGetWidth(width: 317)  , y: 0), animated: true)
                }
                
        }) { (error) in
            self.table.reloadData()
            self.table.mj_header.endRefreshing()
        }
    }
}

extension CQCheckWorkAttendanceVC{
    func siginInOrSiginOutRequest(type:String) {
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
                    "type":type,
                    "longitudeValue":longitude,
                    "latitudeValue":latitude],
            successCallBack: { (result) in
                
                self.loadingSuccess()
                if type == "signIn"{
                    SVProgressHUD.showSuccess(withStatus: "签到成功")
                }else{
                    SVProgressHUD.showSuccess(withStatus: "签退成功")
                }
                self.locationManager?.stopUpdatingLocation()
                self.loadDatas(moreData: false)
             
        }) { (error) in
            self.loadingSuccess()
        }
    }
 
    
    
    
    
    //签到语录
    func attendanceWordRequest() {
        let word = UserDefaults.standard.object(forKey: "attendanceWord")
        let userID = STUserTool.account().userID
       
        STNetworkTools.requestData(URLString:"\(baseUrl)/attendance/getWord" ,
            type: .get,
            param: ["emyeId":userID,
                    "word":word ?? "你说行，我说好"],
            successCallBack: { (result) in
                
                let signName = result["data"]["word"].stringValue
                self.signNameLab.text = signName
                UserDefaults.standard.set(signName, forKey: "attendanceWord")
        }) { (error) in
            
        }
    }
}

extension CQCheckWorkAttendanceVC:SignForWorkDelegate{
    
    func signActionComplete() {
        DLog("111111")
        if self.isFromStatics{
            if self.isGoApplyCard {
                let vc = NCQApprovelVC()
                vc.businessCode = self.applyId
                vc.modifyTime = self.dateStr + " " + self.dataArray[0].ruleTime
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                SVProgressHUD.showInfo(withStatus: "时间已过期")
            }
        }else{
            self.loadingPlay()
            self.siginInOrSiginOutRequest(type: "signIn")
        }
       
        
    }
    
    func finishWorkActionComplete(time:String,ruleTime:String) {
        
        if self.isFromStatics{
            if self.isGoApplyCard {
                let vc = NCQApprovelVC()
                vc.businessCode = self.applyId
                vc.modifyTime = self.dateStr  + " " + self.dataArray[1].ruleTime
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                SVProgressHUD.showInfo(withStatus: "时间已过期")
            }
        }else{
            if time.isEmpty {
                let nowDate = Date()
                let format = DateFormatter.init()
                format.dateFormat = "HH:mm:ss"
                let currentTime = format.string(from: nowDate)
                let timeRight = self.compareDate(currentTime: currentTime, endTime: ruleTime)
                if timeRight {
                    let alertVC = UIAlertController.init(title: "", message: "现在是早退时间，你确定签退么？", preferredStyle: UIAlertControllerStyle.alert)
                    let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
                    let okAction = UIAlertAction.init(title: "确定", style: .default) { (action) in
                        self.loadingPlay()
                        self.siginInOrSiginOutRequest(type: "signOut")
                    }
                    alertVC.addAction(cancelAction)
                    alertVC.addAction(okAction)
                    self.present(alertVC, animated: true, completion: nil)
                }else{
                    self.loadingPlay()
                    self.siginInOrSiginOutRequest(type: "signOut")
                }
            }else{
                SVProgressHUD.showInfo(withStatus: "您已签退")
            }
        }
        
        
        
    }
}



// Mark:高德位置
extension CQCheckWorkAttendanceVC:AMapLocationManagerDelegate{
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
    
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode!) {
        self.curLatitude = location.coordinate.latitude
        self.curLongitude = location.coordinate.longitude
        /*
        DLog(self.curLatitude)
        DLog(self.curLongitude)
        if isAdmin{
            let longitude = String(format: "%.6f",118.181857 + (Float(arc4random()%100) + 1)/1000000 )
            let latitude = String(format: "%.6f",24.486354 + (Float(arc4random()%100) + 1)/1000000 )
            DLog((Float(arc4random()%100) + 1)/1000000)
            DLog(longitude)
            DLog(latitude)
        }
        */
    }
}

extension CQCheckWorkAttendanceVC{
    //获取当前几点
    func getHour() -> Int {
        let now = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str = dateFormat.string(from: now)
        let s:NSString = str as NSString
        let hour = s.substring(with: NSRange.init(location: 11, length: 2))
        return Int(hour)!
    }
    //比较两个时间
    func compareDate(currentTime:String,endTime:String) -> Bool {
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "HH:mm:ss"
        let BDate:Date?
        let EDate:Date?
        BDate = formatter.date(from: currentTime)
        EDate = formatter.date(from: endTime)
        let result:ComparisonResult = (BDate?.compare(EDate!))!
        if result == .orderedDescending || result == .orderedSame {
            return false
        }
        return true
    }
}

extension Date {
    //获取星期几
    func resultWeek() -> Int {
        let interval = Int(self.timeIntervalSince1970) + Int(NSTimeZone.local.secondsFromGMT())
        let day = Int(interval/86400)
        return (day - 3)%7
    }
}

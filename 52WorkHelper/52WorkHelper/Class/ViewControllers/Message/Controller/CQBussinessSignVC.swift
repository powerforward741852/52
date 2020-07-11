//
//  CQBussinessSignVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/9/10.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQBussinessSignVC: SuperVC {

    var locationManager:AMapLocationManager? //定位服务
    var mapView: MAMapView!
    var curLatitude:Double? //经度
    var curLongitude:Double? //纬度
    var curlocationStr:String? //当前位置
    var businessApplyId = ""
    
    // MARK: - 懒加载控件
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        table.backgroundColor = kProjectBgColor
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 309)))
        headView.backgroundColor = UIColor.white
        return headView
    }()
    
    lazy var dateAndWeekLab: UILabel = {
        let dateAndWeekLab = UILabel.init(frame: CGRect.init(x: AutoGetWidth(width: 15), y: 0, width: kWidth/3*2, height: AutoGetHeight(height: 49)))
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
        let statueLab = UILabel.init(frame: CGRect.init(x: kWidth/3*2, y: 0, width: kWidth/3 - AutoGetWidth(width: 15), height: AutoGetHeight(height: 49)))
        statueLab.textColor = UIColor.black
        statueLab.textAlignment = .right
        statueLab.font = UIFont.systemFont(ofSize: 15)
        statueLab.text = ""
        return statueLab
    }()
    
    
    
    lazy var locationImg: UIImageView = {
        let locationImg = UIImageView.init(frame: CGRect.init(x: AutoGetWidth(width: 15), y:self.mapView.bottom + AutoGetHeight(height: 15), width: AutoGetWidth(width: 15), height: AutoGetHeight(height: 19)))
        locationImg.image = UIImage.init(named: "FieldPersonelLocation")
        return locationImg
    }()
    
    lazy var locationLab: UILabel = {
        let locationLab = UILabel.init(frame: CGRect.init(x: self.locationImg.right + AutoGetWidth(width: 12), y: self.mapView.bottom, width: kWidth/4 * 3, height: AutoGetHeight(height: 49)))
        locationLab.textColor = UIColor.black
        locationLab.textAlignment = .left
        locationLab.font = UIFont.systemFont(ofSize: 15)
        locationLab.text = ""
        
        return locationLab
    }()
    
    lazy var footBgView: UIView = {
        let footBgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 244)))
        return footBgView
    }()
    
    
    lazy var footView: UIView = {
        let footView = UIView.init(frame: CGRect.init(x: AutoGetWidth(width: 38), y: AutoGetHeight(height: 13), width: kWidth - AutoGetWidth(width: 76), height: AutoGetHeight(height: 218)))
        footView.layer.borderWidth = 1
        footView.layer.borderColor = kLineColor.cgColor
        footView.layer.cornerRadius = 5
        footView.clipsToBounds = true
        footView.backgroundColor = UIColor.white
        return footView
    }()
    
    lazy var signBtn: UIButton = {
        let signBtn = UIButton.init(type: .custom)
        signBtn.frame = CGRect.init(x: (kWidth - AutoGetWidth(width: 76) - AutoGetWidth(width: 125))/2 , y: AutoGetHeight(height: 33), width: AutoGetWidth(width: 125), height: AutoGetWidth(width: 125))
        signBtn.layer.cornerRadius =  AutoGetWidth(width: 62.5)
        signBtn.clipsToBounds = true
        signBtn.backgroundColor = kLightBlueColor
        signBtn.setTitle("签到", for: .normal)
        signBtn.tag = 100
        signBtn.addTarget(self, action: #selector(signClick), for: .touchUpInside)
        return signBtn
    }()
    
    lazy var statusLab: UILabel = {
        let statusLab = UILabel.init(frame: CGRect.init(x: 0, y: self.signBtn.bottom + AutoGetHeight(height: 33), width: kWidth - AutoGetWidth(width: 76), height: AutoGetHeight(height: 15)))
        statusLab.font = kFontSize15
        statusLab.text = "签到"
        statusLab.textColor = kLyGrayColor
        statusLab.textAlignment = .center
        return statusLab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "出差签到"
        
        self.locateMap()
        
        self.view.backgroundColor = kProjectBgColor
        
        let now = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormat.string(from: now)
        let weeks = ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
        let week = weeks[dateFormat.date(from: dateStr)!.resultWeek()]
        self.dateAndWeekLab.text = dateStr + week
        
        self.view.addSubview(self.table)
        
        self.table.tableHeaderView = self.headView
        
        self.headView.addSubview(self.dateAndWeekLab)
        self.headView.addSubview(self.statueLab)
        
        self.initMapView()
        
        
        self.headView.addSubview(self.locationImg)
        self.headView.addSubview(self.locationLab)
        
        self.table.tableFooterView = self.footBgView
        self.footBgView.addSubview(self.footView)
        self.footView.addSubview(self.signBtn)
        self.footView.addSubview(self.statusLab)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.locationManager?.stopUpdatingLocation()
    }
    
    func initMapView()  {
        mapView = MAMapView.init(frame: CGRect.init(x: 0, y: self.statueLab.bottom, width: kWidth, height: AutoGetHeight(height: 211)))
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.zoomLevel = 10
        mapView.isZoomEnabled = true
        mapView.showsCompass = false
        self.headView.addSubview(self.mapView)
    }
    
    func locateMap()  {
        locationManager = AMapLocationManager.init()
        locationManager?.delegate = self
        //设置定位最小更新距离
        locationManager?.distanceFilter = 5.0
        locationManager?.startUpdatingLocation()
        //如果需要持续定位返回逆地理编码信息
        //        locationManager?.locatingWithReGeocode = true
        //
    }
    
    @objc func signClick()  {
        self.bussinessSign()
    }

}

// Mark:高德位置
extension CQBussinessSignVC:AMapLocationManagerDelegate{
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
                
                print(error ?? "")
                
                
                
            }
            
        }
    }
}

// MARK: - 网络请求  出差签到
extension CQBussinessSignVC{
    func bussinessSign() {
        let now = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
        let dateStr = dateFormat.string(from: now)
        let longitude = String(format: "%.6f", self.curLongitude!)
        let latitude = String(format: "%.6f", self.curLatitude!)
        let userId = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/businessSign/saveBusinessSign" ,
            type: .post,
            param: ["latitudeValue":latitude,
                    "longitudeValue":longitude,
                    "addressRemark":self.curlocationStr ?? "",
                    "businessApplyId":self.businessApplyId,
                    "signDate":dateStr,
                    "userId":userId],
            successCallBack: { (result) in
                SVProgressHUD.showSuccess(withStatus: "签到成功")
                self.navigationController?.popViewController(animated: true)
        }) { (error) in
            
        }
    }
}

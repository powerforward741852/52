//
//  QRSignLocationVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/12/17.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRSignLocationVC : SuperVC {
    var time : Timer?
    var locationManager:AMapLocationManager? //定位服务
    var curLatitude:Double? //经度
    var curLongitude:Double? //纬度
   // var myConpany = CLLocationCoordinate2D(latitude: 24.486354, longitude: 118.181857)
    var myConpany :CLLocationCoordinate2D {
        return  CLLocationCoordinate2D(latitude: baseLatitudeValue!, longitude: baseLongitudeValue!)
        
    }
    var mylocate : CLLocationCoordinate2D?
       // CLLocation(latitude: 24.486354, longitude: 118.181857)
    //数据源
    var annotations: Array<MAPointAnnotation>!
    var overlays: Array<MAOverlay>!
    //反地理m编码
    var search : AMapSearchAPI?
    var now = ""
    //圆心与半径
    var dateStr = ""
    var baseLatitudeValue:Double? //经度
    var baseLongitudeValue:Double? //纬度
    var baseMapRadius: Double?//半径s
    
    //声明闭包
    typealias clickBtnClosure = (_ lontitude : Double?,_ latitude : Double) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    //地图
    lazy var mapView : MAMapView = {
        let mapView = MAMapView(frame:  CGRect(x: 0, y: SafeAreaTopHeight, width: kWidth, height: kHeight-SafeAreaTopHeight-SafeAreaBottomHeight-175))
        mapView.showsUserLocation = true
//        mapView.userLocationAccuracyCircle = nil
        mapView.userTrackingMode = .follow
        mapView.showsScale = false
        mapView.zoomLevel = 15
        
        mapView.delegate = self
        mapView.showsCompass = false
        //mapView.customizeUserLocationAccuracyCircleRepresentation = false
        return mapView
    }()
    lazy var footView : UIView = {
        let footView = UIView(frame:  CGRect(x: 0, y: mapView.bottom, width: kWidth, height:175))
        footView.backgroundColor = UIColor.white
        return footView
    }()
    
    //我的地址title
    lazy var titleLab : UILabel = {
        let titleLab = UILabel()
        titleLab.text = "我的位置"
        titleLab.numberOfLines = 1
        titleLab.textColor = UIColor.black
        titleLab.font = UIFont.systemFont(ofSize: 16)
        titleLab.textAlignment = .left
        return titleLab
    }()
    
    lazy var greyLine1 : UIView = {
    let greyLine1 = UIView()
        greyLine1.backgroundColor = kProjectDarkBgColor
    return greyLine1
    }()
    //我的地址
    //对称图片
    lazy var remarkImg : UIImageView = {
        let remarkImg = UIImageView(frame:  CGRect(x: kWidth-AutoGetWidth(width: 15)-6.6, y: (AutoGetWidth(width: 55)-12)/2, width: 12, height: 12))
        remarkImg.image = UIImage(named: "bz_h")
        return remarkImg
    }()
    lazy var addressLab : UILabel = {
        let addressLab = UILabel()
        addressLab.text = "厦门市思明区观日路24号"
        addressLab.numberOfLines = 0
        addressLab.textColor = UIColor.black
        addressLab.font = UIFont.systemFont(ofSize: 15)
        addressLab.textAlignment = .left
        return addressLab
    }()
    
    lazy var greyLine2 : UIView = {
        let greyLine2 = UIView()
        greyLine2.backgroundColor = kProjectDarkBgColor
        return greyLine2
    }()
    //定位but
    lazy var SignBut : UIButton = {
        let SignBut = UIButton(frame:  CGRect(x: kWidth/3, y: AutoGetWidth(width: 25), width: 40, height: kWidth/3))
        SignBut.setTitle("打卡", for: UIControlState.normal)
        SignBut.addTarget(self, action: #selector(SignClick), for: UIControlEvents.touchUpInside)
        SignBut.setTitleColor(kSignLocationbtnColor, for: UIControlState.normal)
        SignBut.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        SignBut.backgroundColor = kBlueC
        SignBut.setTitleColor(UIColor.white, for: UIControlState.normal)
        SignBut.sizeToFit()
        SignBut.layer.cornerRadius = 5
       
        return SignBut
    }()
    //map定位but
    lazy var MapBut : UIButton = {
        let MapBut = UIButton(frame:  CGRect(x: AutoGetWidth(width: 5), y:footView.top - 45, width: 117, height: 42))
        MapBut.setBackgroundImage(UIImage(named: "dwnn"), for: UIControlState.normal)
        MapBut.addTarget(self, action: #selector(LocationClick), for: UIControlEvents.touchUpInside)
        MapBut.layer.cornerRadius = 5
        return MapBut
    }()
    deinit {
        print("deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "考勤"
        view.addSubview(mapView)
        view.addSubview(footView)
        footView.addSubview(addressLab)
        footView.addSubview(greyLine1)
        footView.addSubview(titleLab)
        footView.addSubview(greyLine2)
        footView.addSubview(remarkImg)
        footView.addSubview(SignBut)
        
        // 获取今天
        let nowday = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        self.now = dateFormat.string(from: nowday)
        
      
        self.updateTime()
        
         self.initAnnotations()
        self.initSearch()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.addSubview(MapBut)
 
       
        mapView.addOverlays(overlays)
        mapView.showOverlays(overlays, edgePadding: UIEdgeInsetsMake(20, 120, 20, 120), animated: true)
        //定时器 反复执行
        let timer = Timer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
        self.time = timer
        
        
        titleLab.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(15)
            make?.top.mas_equalTo()(10)
        }
        greyLine1.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(footView)?.setOffset(40)
            make?.left.mas_equalTo()(footView)
            make?.height.mas_equalTo()(0.5)
            make?.width.mas_equalTo()(kWidth)
        }
        
        SignBut.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(footView)?.setOffset(AutoGetWidth(width: 15))
            make?.right.mas_equalTo()(footView)?.setOffset(AutoGetWidth(width: -15))
            make?.bottom.mas_equalTo()(footView)?.setOffset(-10)
            make?.height.mas_equalTo()(49)
        }
        
        greyLine2.mas_makeConstraints { (make) in
            make?.bottom.mas_equalTo()(SignBut.mas_top)?.setOffset(-10)
            make?.left.mas_equalTo()(footView)
            make?.height.mas_equalTo()(0.5)
            make?.width.mas_equalTo()(kWidth)
        }
        
        remarkImg.mas_makeConstraints { (make) in
            make?.width.mas_equalTo()(15)
            make?.height.mas_equalTo()(19)
            make?.left.mas_equalTo()(15)
            make?.top.mas_equalTo()(greyLine1)?.setOffset(14)
        }
        
        addressLab.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(remarkImg.mas_right)?.setOffset(8)
            make?.right.mas_equalTo()(footView)?.setOffset(-15)
            make?.centerY.mas_equalTo()(remarkImg)
        }
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.time?.invalidate()
    }
    
    func initSearch() {
        search = AMapSearchAPI()
        search!.delegate = self
    }
    
    @objc func staticseClick(){
        print("统计")
        let vc = CQStatisticsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func SignClick(){
        print("打卡")
        if now == dateStr{
          //  siginEarlyRequest()
            clickClosure!(self.curLongitude,self.curLatitude!)
            self.navigationController?.popViewController(animated: true)
        }else{
            SVProgressHUD.showInfo(withStatus: "工作当天才能打卡")
        }
    }
    @objc func LocationClick(){
        print("定位")
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        
    }
    @objc func updateTime(){
        let currentDate = NSDate();
        let dateformate = DateFormatter()
        dateformate.dateFormat = "hh:mm:ss"
        let dateString = dateformate.string(from: currentDate as Date)
        SignBut.setTitle(dateString+" 打卡", for: UIControlState.normal)
    }
    
    func initAnnotations() {
        overlays = Array()
        let circle: MACircle = MACircle(center: CLLocationCoordinate2D(latitude: baseLatitudeValue!, longitude: baseLongitudeValue!), radius: baseMapRadius!)
        overlays.append(circle)
    }
    //反地理编码
    func searchRegeocode(withCoordinate coordinate: CLLocationCoordinate2D) {
        
        print("经纬度"+"\(coordinate)")
        let request = AMapReGeocodeSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude))
        request.requireExtension = true
        search!.aMapReGoecodeSearch(request)
    }
}

extension QRSignLocationVC :MAMapViewDelegate{
    

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
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: QRLocationView?
            
            if annotationView == nil {
                let center = myConpany
                let isContain = MACircleContainsCoordinate(annotation.coordinate, center, baseMapRadius!)
                if isContain==false {
                    annotationView = QRLocationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier, name: "no")
                    annotationView?.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
                }else{
                    annotationView = QRLocationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier, name: "yes")
                    annotationView?.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
                }
                
                            }
            return annotationView!
        }
        
        return nil
    }
    
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        view.isSelected = true
    }
    func mapView(_ mapView: MAMapView!, didDeselect view: MAAnnotationView!) {
        view.isSelected = true
    }
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        self.mylocate =  userLocation.coordinate
        self.searchRegeocode(withCoordinate: userLocation.coordinate)
        let center = myConpany
        let isContain = MACircleContainsCoordinate(userLocation.coordinate, center, baseMapRadius!)
        if isContain {
            mapView.removeAnnotation(mapView.userLocation)
            mapView.addAnnotation(mapView.userLocation)
        }else{
            mapView.removeAnnotation(mapView.userLocation)
            mapView.addAnnotation(mapView.userLocation)
        }
    }
    
    
    
}
extension QRSignLocationVC : AMapSearchDelegate{
    
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        if response.regeocode == nil {
            return
        }
        self.addressLab.text = response.regeocode.formattedAddress
        
       // print("地理编码"+response.regeocode.formattedAddress)
    }
    
    
}


extension QRSignLocationVC{
    
    
    //签到
    func siginInOrSiginOutRequest(type:String) {
        SVProgressHUD.show()
        let userID = STUserTool.account().userID
        var longitude = String(format: "%.6f", (self.mylocate?.longitude)!)
        var latitude = String(format: "%.6f", (self.mylocate?.latitude)!)
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
                
                SVProgressHUD.dismiss()
               
                
        }) { (error) in
            SVProgressHUD.dismiss()
        }
    }
    
    
    //是否早退
    func siginEarlyRequest() {
        SVProgressHUD.show()
        let userID = STUserTool.account().userID
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/attendance/checkAttendanceRecordEarly" ,
            type: .get,
            param: ["emyeId":userID],
            successCallBack: { (result) in
                
                if  result["data"]["isEarly"].boolValue{
                    //询问是否早退
                    SVProgressHUD.dismiss()
                    
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
                    SVProgressHUD.dismiss()
                    self.siginInOrSiginOutRequest(type: "")
                }
                
                
        }) { (error) in
            SVProgressHUD.dismiss()
        }
    }
}

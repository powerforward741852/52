//
//  CQAllLocationVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/9/26.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQAllLocationVC: SuperVC {

    var mapView: MAMapView!
    var departArray = [CQDepartMentAttenceModel]()
    var isDepart = true
    var dataArray = [CQDepartMentAttenceModel]()
    var pageNum = 1
    var selectArr = ["所有","在岗","外出","离线"]
    var typeArr = ["","1","2","3"]
    var dapart = ""
    var type = ""
    var lastBtn = UIButton()
    var lastSelectView:CQPinView?
    
    lazy var headBtnView: UIView = {
        let headBtnView = UIView.init(frame: CGRect.init(x: 0, y:CGFloat(SafeAreaTopHeight), width: kWidth, height: AutoGetHeight(height: 40)))
        headBtnView.backgroundColor = UIColor.white
        
        let lineV = UIView.init(frame: CGRect.init(x: kWidth/2, y: 0, width: 0.5, height: AutoGetHeight(height: 40)))
        lineV.backgroundColor = kLineColor
        headBtnView.addSubview(lineV)
        return headBtnView
    }()
    
    lazy var footBtn: UIButton = {
        let footBtn = UIButton.init(type: .custom)
        footBtn.frame = CGRect.init(x: 0, y: kHeight - AutoGetHeight(height: 40) - CGFloat(SafeAreaBottomHeight) , width: kWidth, height: AutoGetHeight(height: 40))
        footBtn.backgroundColor = UIColor.white
//        footBtn.setTitle("1人在线", for: .normal)
        footBtn.setTitleColor(UIColor.black, for: .normal)
        return footBtn
    }()
    
    lazy var table: UITableView = {
        var tableHeight:CGFloat!
        if self.isDepart {
            tableHeight = AutoGetHeight(height: 40) * CGFloat(self.departArray.count)
        }else {
            tableHeight = AutoGetHeight(height: 160)
        }
        let table = UITableView.init(frame: CGRect.init(x: 0, y: self.headBtnView.bottom, width: kWidth, height: tableHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        //        table.backgroundColor = kProjectBgColor
        table.delegate = self
        table.dataSource = self
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    
    
    lazy var footView: CQLocationPersonView = {
        let footView = CQLocationPersonView.init(frame: CGRect.init(x: AutoGetWidth(width: 10), y: kHeight - AutoGetHeight(height: 100), width: kWidth - AutoGetWidth(width: 20), height: AutoGetHeight(height: 50)))
        footView.personVDelegate = self
        return footView
    }()
    deinit {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "位置"
        self.view.backgroundColor = kProjectBgColor
        self.getDepList()
        self.view.addSubview(self.headBtnView)
        
        mapView = MAMapView.init(frame: CGRect.init(x: 0, y: self.headBtnView.bottom, width: kWidth, height: kHeight - AutoGetHeight(height: 80) - CGFloat(SafeAreaBottomHeight) - CGFloat(SafeAreaTopHeight)))
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.zoomLevel = 15
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.showsCompass = false
        
        self.view.addSubview(self.mapView)
        
        self.view.addSubview(self.footBtn)
        
        let btn = UIButton.init(type: .custom)
//        btn.frame = CGRect.init(x: 0, y: 0, width: 60, height: 40)
        btn.sizeToFit()
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        btn.setTitle("附近", for: .normal)
        btn.titleLabel?.font = kFontSize17
        btn.setTitleColor(UIColor.colorWithHexString(hex: "#21afff"), for: .normal)
        btn.addTarget(self, action: #selector(nearClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: btn)
        self.navigationItem.rightBarButtonItem = rightItem
        
        self.view.addSubview(self.footView)

        self.footView.isHidden = true
        
        self.view.addSubview(self.table)
        self.table.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    @objc func btnClick(btn:UIButton)  {
        
        self.footView.isHidden = true
        
        
        if btn.tag == 100{
            self.isDepart = true
            if btn.isSelected {
                btn.isSelected = false
                self.table.tz_height = 0
            }else{
                btn.isSelected = true
                self.table.tz_height = AutoGetHeight(height: 40) * CGFloat(self.departArray.count)
            }
        }else {
            self.isDepart = false
           
            if btn.isSelected {
                btn.isSelected = false
                self.table.tz_height = 0
            }else{
                btn.isSelected = true
                self.table.tz_height = AutoGetHeight(height: 40) * CGFloat(self.selectArr.count)
            }
        }
        
        if btn.tag != lastBtn.tag{
            if lastBtn.isSelected{
                self.lastBtn.isSelected = false
            }
        }
        self.table.isHidden = false
        self.lastBtn = btn
        self.table.reloadData()
    }
    
    @objc func nearClick()  {
        self.footView.isHidden = true
        let vc = CQLocationNearVC()
        vc.departmentId = self.departArray[0].departmentId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


extension CQAllLocationVC{
    func getDepList() {
        let userID = STUserTool.account().userID
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/historyPosition/getDepList" ,
            type: .get,
            param: ["userId":userID],
            successCallBack: { (result) in
                var tempArray = [CQDepartMentAttenceModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQDepartMentAttenceModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                self.departArray = tempArray
                let titleArr = [tempArray[0].departmentName,"所有"]
                for i in 0..<2{
                    let btn = UIButton.init(type: .custom)
                    btn.frame = CGRect.init(x: kWidth/2 * CGFloat(i), y: 0, width: kWidth/2, height: AutoGetHeight(height: 40))
                    btn.setTitle(titleArr[i], for: .normal)
                    btn.setTitleColor(kLyGrayColor, for: .normal)
                    btn.titleLabel?.font = kFontSize13
                    btn.tag = 100 + i
                    btn.setImage(UIImage.init(named: "open_icon"), for: .normal)
                    btn.setImage(UIImage.init(named: "close_icon"), for: .selected)
                    btn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 160, bottom: 0, right: 0)
                    btn.addTarget(self, action: #selector(self.btnClick(btn:)), for: .touchUpInside)
                    self.headBtnView.addSubview(btn)
                }
                self.dapart = tempArray[0].departmentId
                self.loadDatas(departmentId: tempArray[0].departmentId, type: "")
                self.getDepHistoryPositionNum(lineStatus: "1", departmentId: tempArray[0].departmentId)
        }) { (error) in
            
        }
    }
    
    
    func getDepHistoryPositionNum(lineStatus:String,departmentId:String) {
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/historyPosition/getDepHistoryPositionNum" ,
            type: .get,
            param: ["departmentId":departmentId,
                    "lineStatus":lineStatus],
            successCallBack: { (result) in
                self.footBtn.setTitle("在线人数" + result["data"]["userNum"].stringValue + "人", for: .normal)
                
        }) { (error) in
            
        }
    }
}

extension CQAllLocationVC{
    // MARK:request
    fileprivate func loadDatas(departmentId:String,type:String) {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/historyPosition/getHistoryPositionByPage" ,
            type: .get,
            param: ["userId":userID,
                    "currentPage":pageNum,
                    "rows":"1000",
                    "departmentId":departmentId,
                    "type":type],
            successCallBack: { (result) in
                var tempArray = [CQDepartMentAttenceModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQDepartMentAttenceModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                self.dataArray = tempArray
                
                self.changeAnnotation()
        }) { (error) in
            
        }
    }
    
    func changeAnnotation()  {
        self.mapView.removeAnnotations(self.mapView.annotations)
        var arr = [MAPointAnnotation]()
        for index in 0..<self.dataArray.count{
            let model = self.dataArray[index]
            let annotion = MAPointAnnotation()
            var coor = CLLocationCoordinate2D()
            coor.latitude = model.latitudeValue
            coor.longitude = model.longitudeValue
            annotion.coordinate = coor
            annotion.title = model.createUserRealName
            arr.append(annotion)
            
        }
        self.mapView.addAnnotations(arr)
    }
}

extension CQAllLocationVC{
    //计算宽度
    func getTexWidth(textStr:String,font:UIFont,height:CGFloat) -> CGFloat {
        
        let normalText: String = textStr
        
        let size = CGSize.init(width: 1000, height: height)
        
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context:nil).size
        
        return stringSize.width
        
    }
}


extension CQAllLocationVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isDepart{
            return self.departArray.count
        }else{
            return self.selectArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "alllocationId")
        if self.isDepart{
            cell.textLabel?.text = self.departArray[indexPath.row].departmentName
        }else{
            cell.textLabel?.text = self.selectArr[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.footView.isHidden = true
        
        if self.isDepart{
            let btn = self.view.viewWithTag(100) as! UIButton
            btn.isSelected = false
            btn.setTitle(self.departArray[indexPath.row].departmentName, for: .normal)
            if self.departArray.count > 0{
                self.dapart = self.departArray[indexPath.row].departmentId
            }
            
        }else{
            let btn = self.view.viewWithTag(101) as! UIButton
            btn.isSelected = false
            btn.setTitle(self.selectArr[indexPath.row], for: .normal)
            self.type = self.typeArr[indexPath.row]
        }
        self.loadDatas(departmentId: self.dapart, type: self.type)
        self.table.isHidden = true
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return AutoGetHeight(height: 40)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}

extension CQAllLocationVC:MAMapViewDelegate{
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            let annotationView = CQPinView.init(annotation: annotation, reuseIdentifier: pointReuseIndetifier,name:"")
//            annotationView.button?.setTitle(annotation.title, for: .normal)
            annotationView.canShowCallout = false
            annotationView.clickDelegate = self
            return annotationView
        }
//        if annotation.isKind(of: MAPointAnnotation.self) {
//            let pointReuseIndetifier = "pointReuseIndetifier"
//            var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
//
//            if annotationView == nil {
//                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
//            }
//
//            annotationView!.canShowCallout = true
//            annotationView!.animatesDrop = true
//            annotationView!.isDraggable = false
////            annotationView.
////            annotationView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
//            if annotationView!.isSelected {
//                annotationView!.pinColor = MAPinAnnotationColor.red
//            }else{
//                annotationView!.pinColor = MAPinAnnotationColor.purple
//            }
//
//
//            return annotationView!
//        }
        return nil
    }
    
    
    func mapView(_ mapView: MAMapView!, didAnnotationViewTapped view: MAAnnotationView!) {
    }

    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        
        for model in self.dataArray{
            if model.createUserRealName == view.annotation.title{
                self.footView.isHidden = false
                self.footView.iconImage.sd_setImage(with: URL(string: model.createUserHeadImage ), placeholderImage:UIImage.init(named: "personDefaultIcon"))
                self.footView.nameLab.text = model.createUserRealName
                var status = ""
                if model.type == "1"{
                    status = "在岗"
                    self.footView.statusLab.backgroundColor = kColorRGB(r: 33, g: 151, b: 216)
                }else if model.type == "2"{
                    status = "外出"
                    self.footView.statusLab.backgroundColor = kColorRGB(r: 33, g: 151, b: 216)
                }else if model.type == "3"{
                    status = "离线"
                    self.footView.statusLab.backgroundColor = kLyGrayColor
                }
                self.footView.positionLab.text = model.departmentName + " " + model.positionName + " " + status
                self.footView.model = model
                
            }
        }
    }
    
    func mapView(_ mapView: MAMapView!, didDeselect view: MAAnnotationView!) {
        self.footView.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.footView.isHidden = true
        if self.lastSelectView != nil{
            self.lastSelectView!.bgImage!.image = UIImage.init(named: "red_location")
            self.lastSelectView!.button!.setTitleColor(kColorRGB(r: 33, g: 151, b: 216), for: .normal)
        }
    }
}

extension CQAllLocationVC:viewClickDelegate{
    func clickAnnotionView(annot: MAAnnotation,view:CQPinView) {
        view.bgImage!.image = UIImage.init(named: "green_Location")
        view.button?.setTitleColor(kGoldYellowColor, for: .normal)
        if self.lastSelectView != nil{
            self.lastSelectView!.bgImage!.image = UIImage.init(named: "red_location")
            self.lastSelectView!.button!.setTitleColor(kColorRGB(r: 33, g: 151, b: 216), for: .normal)
        }
        
        self.lastSelectView = view
        for model in self.dataArray{
            if model.createUserRealName == annot.title{
                self.footView.isHidden = false
                self.footView.iconImage.sd_setImage(with: URL(string: model.createUserHeadImage ), placeholderImage:UIImage.init(named: "personDefaultIcon"))
                self.footView.nameLab.text = model.createUserRealName
                var status = ""
                if model.type == "1"{
                    status = "在岗"
                    self.footView.statusLab.backgroundColor = kColorRGB(r: 33, g: 151, b: 216)
                }else if model.type == "2"{
                    status = "外出"
                    self.footView.statusLab.backgroundColor = kColorRGB(r: 33, g: 151, b: 216)
                }else if model.type == "3"{
                    status = "离线"
                    self.footView.statusLab.backgroundColor = kLyGrayColor
                }
                self.footView.positionLab.text = model.departmentName + " " + model.positionName + " " + status
                self.footView.model = model
                
            }
        }

    }
}

extension CQAllLocationVC:locationVClickDelegate{
    func viewClick(v: CQLocationPersonView) {
        let model = v.model
        let vc = CQWorkInstrumentPersonInfoVC.init()
        vc.userId = model!.createUserId
        vc.chatName = model!.createUserRealName
        vc.userModel = CQDepartMentUserListModel.init(uId: model!.createUserId, realN: model!.createUserRealName, headImag: model!.createUserHeadImage)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

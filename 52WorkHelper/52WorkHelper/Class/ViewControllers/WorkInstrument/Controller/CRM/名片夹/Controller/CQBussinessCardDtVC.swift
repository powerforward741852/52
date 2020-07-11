//
//  CQBussinessCardDtVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2019/1/14.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class CQBussinessCardDtVC: SuperVC {
    var swichStatus : Bool?
    var flag = 1
    var lastHeight:CGFloat = 0
    //pageControl
//    fileprivate let pageControl = UIPageControl()
    var isShowPageC = true
    var phoneV:CQBusinessCardDTV?
    var cardId = ""
    var dataArray = [[String]()]
    var nameArray = [String]()
    var bgBtn = UIButton.init(type: .custom)
    var telArr = [String]()
    var myModel:CQBussinessCardListModel?
    var callArr = [String]()
    
    var frontImg = UIImageView()
    var backImg = UIImageView()
    var bV:CQBussinessBottomSelectV?
    
    var locationManager:AMapLocationManager? //定位服务
    var curLatitude:Double? //经度
    var curLongitude:Double? //纬度
    var curlocationStr = "" //当前位置
    
    lazy var bgScrollV: UIScrollView = {
        let bgScrollV = UIScrollView.init(frame: CGRect.init(x: 0, y: CGFloat(SafeAreaTopHeight) , width: kWidth, height: kHeight-SafeAreaTopHeight))
        bgScrollV.contentSize = CGSize.init(width: kWidth, height:kHeight - SafeAreaTopHeight)
        bgScrollV.backgroundColor = UIColor.colorWithHexString(hex: "#eaeaea")
        bgScrollV.delegate = self
       // scrollView.backgroundColor = UIColor.white
        bgScrollV.tag = 1001
      //  bgScrollV.bounces = false
        bgScrollV.showsVerticalScrollIndicator = false
        bgScrollV.showsHorizontalScrollIndicator = false
        
        return bgScrollV
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y:0  , width: kWidth, height: AutoGetHeight(height: 222)))
        scrollView.contentSize = CGSize.init(width: kWidth * 2, height:AutoGetHeight(height: 222))
        scrollView.backgroundColor = UIColor.colorWithHexString(hex: "#eaeaea")
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        // scrollView.backgroundColor = UIColor.black
        scrollView.tag = 1002
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        return scrollView
    }()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: self.scrollView.bottom , width: kWidth, height: kHeight-SafeAreaTopHeight-AutoGetHeight(height: 222)), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
//        table.backgroundColor = UIColor.colorWithHexString(hex: "#eaeaea")
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.tag = 4000
        table.isScrollEnabled = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 280)))
        headView.backgroundColor = UIColor.white
        return headView
    }()
    
    
    lazy var cardV: UIView = {
        let cardV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 277)))
        cardV.backgroundColor = UIColor.white
        return cardV
    }()
    
    lazy var cardImage: UIImageView = {
        let cardImage = UIImageView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 15), width: kWidth - 2 * kLeftDis, height: AutoGetHeight(height: 191)))
        cardImage.image = UIImage.init(named: "mpbg")
        return cardImage
    }()
    
    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView.init(frame: CGRect.init(x: AutoGetWidth(width: 19), y: AutoGetHeight(height: 22), width: AutoGetWidth(width: 60), height: AutoGetWidth(width: 60)))
        iconImg.layer.cornerRadius = AutoGetWidth(width: 30)
        iconImg.clipsToBounds = true
        iconImg.image = UIImage.init(named: "BCDefault")
        return iconImg
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + kLeftDis, y: AutoGetHeight(height: 22), width: AutoGetWidth(width: 190), height:AutoGetHeight(height: 18)))
        nameLab.text = ""
        nameLab.textColor = UIColor.black
        nameLab.textAlignment = .left
        nameLab.font = kFontSize18
        return nameLab
    }()
    
    lazy var positionLab: UILabel = {
        let positionLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + kLeftDis, y: self.nameLab.bottom + AutoGetHeight(height: 8), width: AutoGetWidth(width: 160), height:AutoGetHeight(height: 13)))
        positionLab.text = ""
        positionLab.textColor = UIColor.colorWithHexString(hex: "#757575")
        positionLab.textAlignment = .left
        positionLab.font = kFontSize13
        return positionLab
    }()
    
    lazy var companyNameLab: UILabel = {
        let companyNameLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + kLeftDis, y: self.positionLab.bottom + AutoGetHeight(height: 8), width: AutoGetWidth(width: 160), height:AutoGetHeight(height: 13)))
        companyNameLab.text = ""
        companyNameLab.textColor = UIColor.colorWithHexString(hex: "#757575")
        companyNameLab.textAlignment = .left
        companyNameLab.font = kFontSize13
        return companyNameLab
    }()
    
    lazy var phoneImg: UIButton = {
        let phoneImg = UIButton.init(frame: CGRect.init(x: AutoGetWidth(width: 19), y:self.iconImg.bottom + AutoGetHeight(height: 19), width: AutoGetWidth(width: 17), height: AutoGetWidth(width: 17)))
        phoneImg.setImage(UIImage.init(named: "BCPhone"), for: .normal)
        return phoneImg
    }()
    
    lazy var phoneLab: UILabel = {
        let phoneLab = UILabel.init(frame: CGRect.init(x: self.phoneImg.right + AutoGetWidth(width: 15), y: self.iconImg.bottom + AutoGetHeight(height: 19), width: AutoGetWidth(width: 160), height:AutoGetHeight(height: 17)))
        phoneLab.text = ""
        phoneLab.textColor = UIColor.colorWithHexString(hex: "#1f5878")
        phoneLab.textAlignment = .left
        phoneLab.font = kFontSize17
        return phoneLab
    }()
    
    lazy var emailImg: UIButton = {
        let emailImg = UIButton.init(frame: CGRect.init(x: AutoGetWidth(width: 19), y:self.phoneImg.bottom + AutoGetHeight(height: 10), width: AutoGetWidth(width: 17), height: AutoGetWidth(width: 17)))
        emailImg.setImage(UIImage.init(named: "BCEmail"), for: .normal)
        return emailImg
    }()
    
    lazy var emailLab: UILabel = {
        let emailLab = UILabel.init(frame: CGRect.init(x: self.phoneImg.right + kLeftDis, y: self.phoneLab.bottom + AutoGetHeight(height: 10), width: AutoGetWidth(width: 260), height:AutoGetHeight(height: 17)))
        emailLab.text = ""
        emailLab.textColor = UIColor.colorWithHexString(hex: "#1f5878")
        emailLab.textAlignment = .left
        emailLab.font = kFontSize17
        return emailLab
    }()
    
    lazy var locaImg: UIButton = {
        let locaImg = UIButton.init(frame: CGRect.init(x: AutoGetWidth(width: 19), y:self.emailImg.bottom + AutoGetHeight(height: 10), width: AutoGetWidth(width: 17), height: AutoGetWidth(width: 17)))
        locaImg.setImage(UIImage.init(named: "BCLocation"), for: .normal)
        return locaImg
    }()
    
    lazy var locaLab: UILabel = {
        let locaLab = UILabel.init(frame: CGRect.init(x: self.phoneImg.right + kLeftDis , y: self.emailLab.bottom + AutoGetHeight(height: 10), width: AutoGetWidth(width: 260), height:AutoGetHeight(height: 17)))
        locaLab.text = ""
        locaLab.textColor = UIColor.colorWithHexString(hex: "#1f5878")
        locaLab.textAlignment = .left
        locaLab.font = kFontSize17
        return locaLab
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl.init(frame: CGRect(x: (kWidth - AutoGetWidth(width: 36))/2, y: AutoGetHeight(height: 183) , width: AutoGetWidth(width: 36), height: 10))
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = kLyGrayColor
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
            //低于 iOS 9.0
        }
//        self.loadData()
        self.initView()
        self.locateMap()
    }
    
    func loadData()  {
        self.setUpRefresh()
    }
    
    func initView()  {
        self.title = "名片详情"
        self.view.backgroundColor = UIColor.colorWithHexString(hex: "#eaeaea")
        self.view.addSubview(self.bgScrollV)
        self.bgScrollV.addSubview(self.scrollView)
        self.bgScrollV.addSubview(self.table)
        self.table.register(CQBCardDTCell.self, forCellReuseIdentifier: "CQBCardDTCellId")
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.cardV)
        self.cardV.addSubview(self.cardImage)
        self.cardImage.addSubview(self.iconImg)
        self.cardImage.addSubview(self.nameLab)
        self.cardImage.addSubview(self.positionLab)
        self.cardImage.addSubview(self.companyNameLab)
        self.cardImage.addSubview(self.phoneImg)
        self.cardImage.addSubview(self.phoneLab)
        self.cardImage.addSubview(self.emailImg)
        self.cardImage.addSubview(self.emailLab)
        self.cardImage.addSubview(self.locaImg)
        self.cardImage.addSubview(self.locaLab)
        
        let imageArr = ["dhd","ddz","bz","pianj"]
        let titleArr = ["电话","地址","备注","编辑"]
        for i in 0..<4 {
            let btn = UIButton.init(frame: CGRect.init(x: kWidth/4 * CGFloat(i), y: self.cardImage.bottom, width: kWidth/4, height: AutoGetHeight(height: 47)))
            btn.setImage(UIImage.init(named: imageArr[i]), for: .normal)
            btn.contentHorizontalAlignment = .center
            btn.tag = 100 + i
            btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
            self.cardV.addSubview(btn)
            
            let lab = UILabel.init(frame: CGRect.init(x:kWidth/4 * CGFloat(i) , y: btn.bottom, width: kWidth/4, height: AutoGetHeight(height: 24)))
            lab.text = titleArr[i]
            lab.textAlignment = .center
            lab.textColor = UIColor.colorWithHexString(hex: "#757575")
            lab.font = kFontSize12
            self.cardV.addSubview(lab)
        }
        
        for i in 0..<2 {
            if i == 0{
                let img = UIImageView.init(frame: CGRect.init(x: kLeftDis + CGFloat(i) * kWidth, y: kLeftDis, width: kHaveLeftWidth, height: AutoGetHeight(height: 192)))
                img.image = UIImage.init(named: "mpbg")
                self.frontImg = img
                self.scrollView.addSubview(img)
            }else{
                let img = UIImageView.init(frame: CGRect.init(x: kLeftDis + CGFloat(i) * kWidth, y: kLeftDis, width: kHaveLeftWidth, height: AutoGetHeight(height: 192)))
                img.image = UIImage.init(named: "mpbg")
                self.backImg = img
                self.scrollView.addSubview(img)
            }
            
            
        }
        self.scrollView.addSubview(self.pageControl)
//        self.pageControl.isHidden = true
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44))
        rightBtn.setImage(UIImage.init(named: "CQMoreBtn"), for: .normal)
        rightBtn.addTarget(self, action: #selector(addClick), for: .touchUpInside)
        
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
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
    
    @objc func addClick()  {
        
        self.bgBtn.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight)
        self.bgBtn.backgroundColor = UIColor.colorWithHexString(hex: "#000000")
        self.bgBtn.alpha = 0.8
        self.bgBtn.addTarget(self, action: #selector(bgClick), for: .touchUpInside)
        self.navigationController?.view.addSubview(self.bgBtn)
        
        bV = CQBussinessBottomSelectV.init(frame: CGRect.init(x: 0, y: kHeight - 210 - SafeAreaBottomHeight, width: kWidth, height: 210), dataArray: ["编辑","更新到通讯录","分享"])
        bV!.showDelegate = self
        bV!.cancelDelegate = self
        self.navigationController?.view.addSubview(bV!)
    }
    
    @objc func bgClick()  {
        DLog(self.navigationController?.view.subviews.count)
        self.bV?.removeAllSubviews()
        self.bV?.removeFromSuperview()
        self.bgBtn.removeFromSuperview()
    }
    
    @objc func btnClick(sender:UIButton)  {
        if sender.tag == 100{
            self.bgBtn.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight)
            self.bgBtn.backgroundColor = UIColor.colorWithHexString(hex: "#000000")
            self.bgBtn.alpha = 0.8
            self.bgBtn.addTarget(self, action: #selector(bgClick), for: .touchUpInside)
            self.navigationController?.view.addSubview(self.bgBtn)
            
            bV = CQBussinessBottomSelectV.init(frame: CGRect.init(x: 0, y: kHeight - (CGFloat(self.callArr.count) * 50 + 60) - SafeAreaBottomHeight, width: kWidth, height:CGFloat(self.callArr.count) * 50 + 60), dataArray: self.callArr)
            bV!.telDelegate = self
            bV!.cancelDelegate = self
            bV!.isTel = true
            self.navigationController?.view.addSubview(bV!)
        }else if sender.tag == 101{
            let geocoder = CLGeocoder.init()
            let loca = self.myModel?.address[0].stringValue
            if !(loca?.isEmpty)!{
                geocoder.geocodeAddressString((loca!)) { (placeMark, error) in
                    if (placeMark != nil){
                        if (placeMark?.count)! > 0{
                            let place = placeMark![0]
                            let coordinate = place.location?.coordinate
                            DLog(coordinate?.latitude)
                            DLog(coordinate?.longitude)
                            
                            var hasNumArr = [String]()
                            hasNumArr.removeAll()
                            
                            let actionSheet = UIAlertController.init(title: "选择导航地图", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
                            let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
                                
                            })
                            
                            let apple_App = URL.init(string: "http://maps.apple.com/")
                            if UIApplication.shared.canOpenURL(apple_App!){
                                let urlString = "http://maps.apple.com/?saddr=\(self.curLatitude ?? 0.0),\(self.curLongitude ?? 0.0)&daddr=\(coordinate!.latitude),\(coordinate!.longitude)"
                                let ok = UIAlertAction.init(title: "使用苹果自带地图导航", style: UIAlertActionStyle.default, handler: { (action) in
                                    UIApplication.shared.openURL(URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
                                })
                                actionSheet.addAction(ok)
                                hasNumArr.append("1")
                            }
                            
                            let baidu_App = URL.init(string: "baidumap://")
                            if UIApplication.shared.canOpenURL(baidu_App!){
                                let bmkCoor = BMKCoordTrans(coordinate!, BMK_COORD_TYPE.COORDTYPE_COMMON, BMK_COORD_TYPE.COORDTYPE_BD09LL)
                                let urlStr = "baidumap://map/direction?origin={{我的位置}}&destination=latlng:\(bmkCoor.latitude),\(bmkCoor.longitude)|name=\(loca!)&mode=driving&coord_type=bd09ll"
                                let ok = UIAlertAction.init(title: "使用百度地图导航", style: UIAlertActionStyle.default, handler: { (action) in
                                    UIApplication.shared.openURL(URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
                                })
                                actionSheet.addAction(ok)
                                hasNumArr.append("2")
                            }
                            
                            let gaode_App = URL.init(string: "iosamap://")
                            if UIApplication.shared.canOpenURL(gaode_App!){
                                let urlStr = "iosamap://path?sourceApplication=\(self.curlocationStr)&sid=BGVIS1&slat=\(self.curLatitude)&slon=\(self.curLongitude)&sname=\(loca!)&did=BGVIS2&dlat=\(coordinate!.latitude)&dlon=\(coordinate!.longitude)&dname=\(loca!)&dev=0&t=0"
                                let ok = UIAlertAction.init(title: "使用高德地图导航", style: UIAlertActionStyle.default, handler: { (action) in
                                    UIApplication.shared.openURL(URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
                                })
                                actionSheet.addAction(ok)
                                hasNumArr.append("3")
                            }
                            
                            if hasNumArr.count > 0{
                                actionSheet.addAction(cancel)
                                self.present(actionSheet, animated: true, completion: nil)
                            }else{
                                SVProgressHUD.showError(withStatus: "建议您安装高德或者百度地图")
                            }
                            
                            
                        }
                    }else{
                        SVProgressHUD.showError(withStatus: "地址信息解析失败")
                    }
                }
            }else{
                SVProgressHUD.showError(withStatus: "尚未填写地址信息")
            }
        }else if sender.tag == 102{
            let vc = CQBCardRemarkVC.init()
            vc.cardId = self.cardId
            if !(self.myModel?.remark.isEmpty)!{
                vc.preStr = (self.myModel?.remark)!
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else if sender.tag == 103{
            let vc = CQAutoEditBussinessCardVC.init()
            vc.cardId = self.cardId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.loadData()
    }
    
    func initShareView()  {
        let shareV = CQShareView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - CGFloat(SafeAreaBottomHeight)))
        shareV.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
        shareV.cqShareDelegate = self
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.addSubview(shareV)
    }
   
}

// MARK: - 网络请求  获取当前签到状态
extension CQBussinessCardDtVC{
    
    fileprivate func setUpRefresh() {
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/crmBusinessCard/getCardInfo" ,
            type: .get,
            param: ["cardId":self.cardId],
            successCallBack: { (result) in
                guard let model = CQBussinessCardListModel.init(jsonData: result["data"]) else {
                    return
                }
                self.myModel = model
                self.dataArray.removeAll()
                self.telArr.removeAll()
                self.nameArray.removeAll()
                for modelJson in model.mobile{
                    self.telArr.append(modelJson.stringValue)
                }
                if self.telArr.count > 0 && !self.telArr[0].isEmpty{
                    self.dataArray.append(self.telArr)
                    self.nameArray.append("手机")
                }
                
                
                var stringArray = [String]()
                for modelJson in model.phone{
                    stringArray.append(modelJson.stringValue)
                }
                if stringArray.count > 0  && !stringArray[0].isEmpty{
                    self.dataArray.append(stringArray)
                    self.nameArray.append("电话")
                }

                var emailArray = [String]()
                for modelJson in model.email{
                    emailArray.append(modelJson.stringValue)
                }
                if emailArray.count > 0 && !emailArray[0].isEmpty{
                    self.dataArray.append(emailArray)
                    self.nameArray.append("邮箱")
                }
                
                var addressArray = [String]()
                for modelJson in model.address{
                    addressArray.append(modelJson.stringValue)
                }
                if addressArray.count > 0 && !addressArray[0].isEmpty{
                    self.dataArray.append(addressArray)
                    self.nameArray.append("地址")
                }
                
                var companyArray = [String]()
                for modelJson in model.companyArr{
                    companyArray.append(modelJson.stringValue)
                }
                if companyArray.count > 0 && !companyArray[0].isEmpty{
                    self.dataArray.append(companyArray)
                    self.nameArray.append("公司")
                }
                
                var departmentArray = [String]()
                for modelJson in model.department{
                    departmentArray.append(modelJson.stringValue)
                }
                if departmentArray.count > 0 && !departmentArray[0].isEmpty{
                    self.dataArray.append(departmentArray)
                    self.nameArray.append("部门")
                }
                
                var positionArray = [String]()
                for modelJson in model.positionArr{
                    positionArray.append(modelJson.stringValue)
                }
                if positionArray.count > 0 && !positionArray[0].isEmpty{
                    self.dataArray.append(positionArray)
                    self.nameArray.append("职位")
                }
                
                
                var webSitArray = [String]()
                for modelJson in model.website{
                    webSitArray.append(modelJson.stringValue)
                }
                if webSitArray.count > 0 && !webSitArray[0].isEmpty{
                    self.dataArray.append(webSitArray)
                    self.nameArray.append("网址")
                }
                
                if !model.remark.isEmpty{
                    var remarkArray = [String]()
                    remarkArray.append(model.remark)
                    self.dataArray.append(remarkArray)
                    self.nameArray.append("备注")
                }
                
                self.iconImg.sd_setImage(with: URL(string: model.frontPhoto), placeholderImage:UIImage.init(named: "BCDefault") )
                self.nameLab.text = model.realName
                
                if model.positionArr.count > 0{
                    self.positionLab.text = model.positionArr[0].stringValue
                }else{
                    self.positionLab.text = ""
                }
                if model.companyArr.count > 0{
                    self.companyNameLab.text = model.companyArr[0].stringValue
                }else{
                    self.companyNameLab.text = ""
                }
                if model.mobile.count > 0{
                    self.phoneLab.text = model.mobile[0].stringValue
                }else{
                    self.phoneLab.text = ""
                }
                if model.email.count > 0{
                    self.emailLab.text = model.email[0].stringValue
                }else{
                    self.emailLab.text = ""
                }
                if model.address.count > 0{
                    self.locaLab.text = model.address[0].stringValue
                }else{
                    self.locaLab.text = ""
                }
                //查询通讯录
               // self.flag = self.searchPhone()
                
                self.callArr.removeAll()
            
                for tel in self.telArr{
                    if tel == ""{
                        
                    }else{
                       self.callArr.append(tel)
                    }
                    
                }
                for phone in stringArray{
                    if phone == ""{
                        
                    }else{
                        self.callArr.append(phone)
                    }
                    
                }
                
                self.frontImg.sd_setImage(with: URL(string: model.frontPhoto), placeholderImage:UIImage.init(named: "mpbg") )
                self.backImg.sd_setImage(with: URL(string: model.backPhoto), placeholderImage:UIImage.init(named: "mpbg") )
                
                //自动保存
                self.swichStatus = self.myModel?.autoSave
                
                
                self.table.reloadData()
                self.setUpUi()
        }) { (error) in
             self.table.reloadData()
        }
    }
    //计算高度
    func caculaterHeight()->CGFloat {
        var  heights = AutoGetHeight(height: 280)
        for (_,value) in dataArray.enumerated() {
            heights = heights + CGFloat(value.count) * AutoGetHeight(height: 55)
        }
        heights = heights + AutoGetHeight(height: 10)*CGFloat(dataArray.count)

        return heights
    }
    
    func setUpUi(){
       // self.table.layoutIfNeeded()
//        self.table.frame =  CGRect(x: 0, y: self.scrollView.bottom, width: kWidth, height: self.table.contentSize.height)
        let heights = caculaterHeight()
        
        print(heights)
        print(self.table.contentSize.height)
        if heights < (kHeight - SafeAreaTopHeight){
            table.frame = CGRect.init(x: 0, y: self.scrollView.bottom, width: kWidth, height: kHeight - SafeAreaTopHeight)
        }else{
            table.frame = CGRect.init(x: 0, y: self.scrollView.bottom, width: kWidth, height: heights + +SafeTabbarBottomHeight)
        }
        
        self.bgScrollV.contentSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 222) +  self.table.frame.size.height )
        self.bgScrollV.setContentOffset(CGPoint.init(x: 0, y: AutoGetHeight(height: 222)) , animated: false)
//        if self.table.contentSize.height < (kHeight - SafeAreaTopHeight){
//            table.frame = CGRect.init(x: 0, y: self.scrollView.bottom, width: kWidth, height: kHeight - SafeAreaTopHeight)
//        }else{
//            table.frame = CGRect.init(x: 0, y: self.scrollView.bottom, width: kWidth, height: self.table.contentSize.height + AutoGetHeight(height: 111))
//        }
//
//        self.bgScrollV.contentSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 222) +  self.table.frame.size.height )
//        self.bgScrollV.setContentOffset(CGPoint.init(x: 0, y: AutoGetHeight(height: 222)) , animated: false)
    }
    
}

extension CQBussinessCardDtVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CQBCardDTCell.init(style: .default, reuseIdentifier: "CQBCardDTCellId")
        cell.refreshNameWithName(name:self.nameArray[indexPath.section],indexPath:indexPath)
        cell.dtLab.text = self.dataArray[indexPath.section][indexPath.row]
        if (cell.contentView.subviews.last != nil)  {
            cell.contentView.subviews.last?.removeFromSuperview()
        }
        
        let height = cell.countCellHeight(labStr: self.dataArray[indexPath.section][indexPath.row])
        DLog(height)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoGetHeight(height: 55)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AutoGetHeight(height: 10)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 10)))
        header.backgroundColor = kProjectBgColor
        return header
    }
    
}

extension CQBussinessCardDtVC:UIScrollViewDelegate{
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = Int((scrollView.contentOffset.x + UIScreen.main.bounds.width / 2.0) / UIScreen.main.bounds.width)
        self.pageControl.frame = CGRect(x: (kWidth - AutoGetWidth(width: 36))/2 + kWidth * CGFloat(self.pageControl.currentPage), y: AutoGetHeight(height: 183), width: AutoGetWidth(width: 36), height: 10)
        
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.tag == 1001{
            print(scrollView.contentOffset.y)
                if scrollView.contentOffset.y < AutoGetHeight(height: 111){
                    scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
                }else if scrollView.contentOffset.y >= AutoGetHeight(height: 111) && scrollView.contentOffset.y < AutoGetHeight(height: 222){
                    scrollView.setContentOffset(CGPoint.init(x: 0, y: AutoGetHeight(height: 222)), animated: true)
                }else{

                }

        }
    }
    
   
}

extension CQBussinessCardDtVC:BCardBottomSelectDelegate{
   //查找是否有改名字,手机号有的话提醒
    func searchPhone()->Int{
        //var flag = 1
        LJContactManager().accessContactsComplection { (boo, peoples) in
            for (_,value) in (peoples?.enumerated())!{
                for (_,val) in value.phones.enumerated(){
                    for (_,v) in (self.myModel?.phone.enumerated())!{
                        //有一个电话号码d就不保存
                        if val.phone == v.stringValue {
                            //包含电话号码
                           self.flag = 100
                           
                        }else{
                            
                        }
                        
                    }
                }
            }
        }
        return flag
    }

   // 更新通讯录
    func updatePhoneNum()  {
        //更新到通讯录
        let per = LJPerson()
        //公司
        if nameArray.contains("公司"){
            var str = ""
            for (index,_) in (self.myModel?.companyArr.enumerated())!{
                str = str + (self.myModel?.companyArr[index].stringValue)!
            }
            per.organizationName = str
        }
        //部门
        if nameArray.contains("部门"){
            var str = ""
            for (index,_) in (self.myModel?.department.enumerated())!{
                str = str + (self.myModel?.department[index].stringValue)!
            }
            per.departmentName = str
        }
        //名字
        per.familyName = self.myModel?.realName
        //地址
        var addressArr = [LJAddress]()
        if nameArray.contains("地址"){
            for (index,_) in (self.myModel?.address.enumerated())!{
                let Maddress = LJAddress()
                Maddress.street = self.myModel?.address[index].stringValue
                addressArr.append(Maddress)
            }
        }
        per.addresses = addressArr
        //职位
        if nameArray.contains("职位"){
            var str = ""
            for (index,_) in (self.myModel?.positionArr.enumerated())!{
                str = str + (self.myModel?.positionArr[index].stringValue)!
            }
            per.jobTitle = str
        }
        //url
        var addressUrlArr = [LJUrlAddress]()
        if nameArray.contains("网址"){
            for (index,_) in (self.myModel?.website.enumerated())!{
                let MUrladdress = LJUrlAddress()
                MUrladdress.urlString = self.myModel?.website[index].stringValue
                MUrladdress.label = CNLabelWork
                addressUrlArr.append(MUrladdress)
            }
        }
        per.urls = addressUrlArr
        //备注
        per.note = self.myModel?.remark
        //email邮箱
        var emailArr = [LJEmail]()
        if nameArray.contains("邮箱"){
            for (index,_) in (self.myModel?.email.enumerated())!{
                let Memail = LJEmail()
                Memail.email = self.myModel?.email[index].stringValue
                Memail.label = CNLabelWork
                emailArr.append(Memail)
            }
        }
        per.emails = emailArr
        //手机
        var PhoneArr = [LJPhone]()
        if nameArray.contains("手机"){
            for (index,_) in (self.myModel?.mobile.enumerated())!{
                let Mphone = LJPhone()
                Mphone.phone = self.myModel?.mobile[index].stringValue
                Mphone.label = CNLabelPhoneNumberMobile
                PhoneArr.append(Mphone)
            }
        }
        //电话
        if nameArray.contains("电话"){
            for (index,_) in (self.myModel?.phone.enumerated())!{
                let Mphone = LJPhone()
                Mphone.phone = self.myModel?.phone[index].stringValue
                Mphone.label = CNLabelHome
                PhoneArr.append(Mphone)
            }
        }
        per.phones = PhoneArr
        LJContactManager.sharedInstance()?.createNewContact(withPhoneNum: per, controller: self)
    }
    
    func showChooseClick(index: IndexPath) {
        self.bgClick()
        if index.row == 0{
            let vc = CQAutoEditBussinessCardVC.init()
            vc.cardId = self.cardId
            self.navigationController?.pushViewController(vc, animated: true)
        }else if index.row == 1{
             updatePhoneNum()
//            if flag == 100 {
//                let alert = UIAlertController.init(title: "注意", message: "通讯录中已有此联系人的电话号码,无法保存", preferredStyle: .alert)
//                let ok = UIAlertAction.init(title: "确定", style: .default) { (al) in
//                }
//                let cancel = UIAlertAction.init(title: "取消", style: .cancel) { (ca) in
//
//                }
//                alert.addAction(ok)
//                alert.addAction(cancel)
//                self.present(alert, animated: true, completion: nil)
//            }else {
//                updatePhoneNum()
//            }
        }else if index.row == 2{
            self.initShareView()
        }
    }
}

extension CQBussinessCardDtVC:BCardBottomTelSelectDelegate{
    func showTelChooseClick(index: IndexPath) {
        self.bgClick()
        
        //自动打开拨号页面并自动拨打电话
        if  !self.callArr[index.row].isEmpty {
            let telStr = self.callArr[index.row]
//            let str = (telStr as NSString).replacingOccurrences(of: "手机 ", with: "").replacingOccurrences(of: "电话 ", with: "")
            let urlString = "tel://" + telStr
            if let url = URL(string: urlString) {
                //根据iOS系统版本，分别处理
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:],
                                              completionHandler: {
                                                (success) in
                                                
                    })
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}

extension CQBussinessCardDtVC:BCardBottomCancelDelegate{
    func cancelAction() {
        self.bgClick()
    }
}

extension CQBussinessCardDtVC:CQShareDelegate{
    func pushToThirdPlatform(index: Int) {
        var type:SSDKPlatformType!
        if 0 == index {
            type = SSDKPlatformType.subTypeWechatSession
        }else if 1 == index{
            type = SSDKPlatformType.subTypeWechatTimeline
        }else if 2 == index{
            type = SSDKPlatformType.subTypeQQFriend
        }else if 3 == index{
            type = SSDKPlatformType.subTypeQZone
        }
        
        //        let imgUrl:String = UserDefaults.standard.object(forKey: "headImage") as! String
        //        let imgData = NSData.init(contentsOf: URL.init(string: self.personInfo?.headImage)!)
        //        let img = UIImage.init(data: imgData! as Data)
        let shareUrl = "http://crm.52zhushou.com/crm/card/shareCard?cardId=" + self.cardId
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: "分享" + (self.myModel?.realName)! + "的名片",
                                          images : UIImage.init(named: "1024"),
                                          url : NSURL(string:shareUrl) as URL?,
                                          title :  "名片分享",
                                          type : SSDKContentType.webPage)
        
        //2.进行分享
        ShareSDK.share(type , parameters: shareParames) { (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
            
            switch state{
                
            case SSDKResponseState.success: print("分享成功")
            case SSDKResponseState.fail:    print("授权失败,错误描述:\(String(describing: error))")
            case SSDKResponseState.cancel:  print("操作取消")
                
            default:
                break
            }
            
        }
    }
    
    
}

// Mark:高德位置
extension CQBussinessCardDtVC:AMapLocationManagerDelegate{
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
                let FormattedAddressLines: NSString = ((mark.addressDictionary! as NSDictionary).value(forKey: "FormattedAddressLines") as AnyObject).firstObject as! NSString
              
                let str2 = FormattedAddressLines as String
                self.curlocationStr = str2
            }
            else{
                print(error!)
            }
        }
    }
}

//
//  CQIndexVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/7/23.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQIndexVC: SuperVC {
    var dataArray = [CQHasNotHandleModel]()
    var lastBtn:UIButton?
    let titleArr = ["待办","待审","通知公告"]
    var btnArr = [UIButton]()
    var actionV:CQActionView?
    var firstBtnTitle = "本月"
    var secBtnTitle = "上月"
    var remarkView:CQApprovalRemarkView?
  //  var signCircle:UIView?
    var leaveCircle:UIView?
    var businessCircle:UIView?
    var outWorkCircle:UIView?
//    var signOutCircle:UIView?
    
    var signCircle:AILoadingView?
    var signOutCircle:AILoadingView?
    var timer:Timer?
    var locationManager:AMapLocationManager? //定位服务
    var curLatitude:Double? //经度
    var curLongitude:Double? //纬度
    var addressRemark = "厦门"
    var childvc1 :CQHasNotDoVC?
    var childvc2 :CQHasNotDoVC?
    lazy var headImage: UIImageView = {
        let headImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 289)))
        print("headImage\(headImage.frame)")
        headImage.image = UIImage.init(named: "CQIndexBGIMG")
        headImage.isUserInteractionEnabled = true
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(touchClick(gesture:)))
        headImage.addGestureRecognizer(tapGes)
        return headImage
    }()
    
    @objc func touchClick(gesture:UITapGestureRecognizer){
        let point = gesture.location(in: headImage)
        if ((self.workSignBtn.layer.presentation()?.hitTest(point)) != nil){
            self.signClick()
        }
        if ((self.signOutBtn.layer.presentation()?.hitTest(point)) != nil){
            self.signOutClick()
        }
    }
    
    lazy var titleLab: UILabel = {
        let titleLab = UILabel.init(frame: CGRect.init(x: 0, y: SafeAreaStateTopHeight, width: kWidth, height: 44))
        titleLab.font = kFontSize18
        titleLab.text = "52助手"
        titleLab.textColor = UIColor.white
        titleLab.textAlignment = .center
        return titleLab
    }()
    
    lazy var smileWallBtn: UIButton = {
        let smileWallBtn = UIButton.init(type: .custom)
        smileWallBtn.frame = CGRect.init(x: kWidth - AutoGetWidth(width: 30.5), y: AutoGetHeight(height: 100), width: AutoGetWidth(width: 30.5), height: AutoGetHeight(height: 89.5))
        smileWallBtn.setImage(UIImage.init(named: "smileBut"), for: .normal)
        smileWallBtn.addTarget(self, action: #selector(smileClick), for: .touchUpInside)
        return smileWallBtn
    }()

    
    lazy var personIconBtn: UIButton = {
        let personIconBtn = UIButton.init(frame: CGRect.init(x: (kWidth - AutoGetWidth(width: 114))/2, y: AutoGetHeight(height: 154), width: AutoGetWidth(width: 114), height: AutoGetWidth(width: 114)))
        personIconBtn.layer.borderColor = UIColor.white.cgColor
        personIconBtn.layer.borderWidth = 3
        personIconBtn.layer.cornerRadius = AutoGetWidth(width: 57)
        personIconBtn.clipsToBounds = true
        personIconBtn.addTarget(self, action: #selector(iconClick), for: .touchUpInside)
        
        let imageView = UIImageView.init(frame: CGRect.init(x: AutoGetWidth(width: 9), y: AutoGetWidth(width: 9), width: AutoGetWidth(width: 96), height: AutoGetWidth(width: 96)))
        imageView.layer.cornerRadius = AutoGetWidth(width: 48)
        imageView.clipsToBounds = true
        imageView.tag = 100
        personIconBtn.addSubview(imageView)
        
        return personIconBtn
    }()
    
    lazy var workSignBtn: UIButton = {
        
//        signCircle = UIView.init(frame: CGRect.init(x: AutoGetWidth(width: 30), y: AutoGetHeight(height: 192), width: AutoGetWidth(width: 46), height: AutoGetWidth(width: 46)))
//        signCircle?.backgroundColor = kAlpaRGB(r: 255, g: 255, b: 255, a: 0.35)
//        signCircle?.layer.cornerRadius = AutoGetWidth(width: 23)
//        self.headImage.addSubview(signCircle!)
    
        signCircle = AILoadingView.init(frame: CGRect.init(x: AutoGetWidth(width: 30), y: AutoGetHeight(height: 192), width: AutoGetWidth(width: 46), height: AutoGetWidth(width: 46)))
        signCircle?.loadingLayer.lineWidth = 4
        signCircle?.duration = 4
        signCircle!.strokeColor = kAlpaRGB(r: 255, g: 255, b: 255, a: 0.35)
        self.headImage.addSubview(signCircle!)
       
        let workSignBtn = UIButton.init(type: .custom)
        workSignBtn.frame = CGRect.init(x: AutoGetWidth(width: 29), y: AutoGetHeight(height: 191), width: AutoGetWidth(width: 48), height: AutoGetWidth(width: 48))
        workSignBtn.setImage(UIImage.init(named: "CQIndexSignIn"), for: .normal)
        workSignBtn.addTarget(self, action: #selector(signClick), for: .touchUpInside)
        
        let lab = UILabel.init(frame: CGRect.init(x: AutoGetWidth(width: 29), y: workSignBtn.bottom + AutoGetHeight(height: 8), width: AutoGetWidth(width: 48), height: AutoGetHeight(height: 13)))
        lab.textAlignment = .center
        lab.text = "上班"
        lab.textColor = UIColor.white
        lab.font = kFontSize13
        self.headImage.addSubview(lab)
        return workSignBtn
    }()
    
    lazy var leaveBtn: UIButton = {
        leaveCircle = UIView.init(frame: CGRect.init(x: AutoGetWidth(width: 61), y: AutoGetHeight(height: 120), width: AutoGetWidth(width: 46), height: AutoGetWidth(width: 46)))
        leaveCircle?.backgroundColor = kAlpaRGB(r: 255, g: 255, b: 255, a: 0.35)
        leaveCircle?.layer.cornerRadius = AutoGetWidth(width: 23)
        self.headImage.addSubview(leaveCircle!)
        
        
        let leaveBtn = UIButton.init(type: .custom)
        leaveBtn.frame = CGRect.init(x: AutoGetWidth(width: 60), y: AutoGetHeight(height: 119), width: AutoGetWidth(width: 48), height: AutoGetWidth(width: 48))
        leaveBtn.setBackgroundImage(UIImage.init(named: "CQIndexLeave"), for: .normal)
        leaveBtn.addTarget(self, action: #selector(leaveClick), for: .touchUpInside)
        
        let lab = UILabel.init(frame: CGRect.init(x: AutoGetWidth(width: 61), y: leaveBtn.bottom + AutoGetHeight(height: 8), width: AutoGetWidth(width: 48), height: AutoGetHeight(height: 13)))
        lab.textAlignment = .center
        lab.text = "请假"
        lab.textColor = UIColor.white
        lab.font = kFontSize13
        self.headImage.addSubview(lab)
        return leaveBtn
    }()
    
    lazy var businessBtn: UIButton = {
        businessCircle = UIView.init(frame: CGRect.init(x: kWidth/2 - AutoGetWidth(width: 23), y: AutoGetHeight(height: 77), width: AutoGetWidth(width: 46), height: AutoGetWidth(width: 46)))
        businessCircle?.backgroundColor = kAlpaRGB(r: 255, g: 255, b: 255, a: 0.35)
        businessCircle?.layer.cornerRadius = AutoGetWidth(width: 23)
        self.headImage.addSubview(businessCircle!)
        
        let businessBtn = UIButton.init(type: .custom)
        businessBtn.frame = CGRect.init(x: kWidth/2 - AutoGetWidth(width: 24), y: AutoGetHeight(height: 76), width: AutoGetWidth(width: 48), height: AutoGetWidth(width: 48))
        businessBtn.setBackgroundImage(UIImage.init(named: "CQIndexBusiness"), for: .normal)
        businessBtn.addTarget(self, action: #selector(businessClick), for: .touchUpInside)
        
        let lab = UILabel.init(frame: CGRect.init(x: kWidth/2 - AutoGetWidth(width: 22), y: businessBtn.bottom + AutoGetHeight(height: 8), width: AutoGetWidth(width: 48), height: AutoGetHeight(height: 13)))
        lab.textAlignment = .center
        lab.text = "出差"
        lab.textColor = UIColor.white
        lab.font = kFontSize13
        self.headImage.addSubview(lab)
        return businessBtn
    }()
    
    lazy var outWorkBtn: UIButton = {
        outWorkCircle = UIView.init(frame: CGRect.init(x:  kWidth - AutoGetWidth(width: 105), y: AutoGetHeight(height: 123), width: AutoGetWidth(width: 46), height: AutoGetWidth(width: 46)))
        outWorkCircle?.backgroundColor = kAlpaRGB(r: 255, g: 255, b: 255, a: 0.35)
        outWorkCircle?.layer.cornerRadius = AutoGetWidth(width: 23)
        self.headImage.addSubview(outWorkCircle!)
        
        let outWorkBtn = UIButton.init(type: .custom)
        outWorkBtn.frame = CGRect.init(x:  kWidth - AutoGetWidth(width: 106), y: AutoGetHeight(height: 122), width: AutoGetWidth(width: 48), height: AutoGetWidth(width: 48))
        outWorkBtn.setBackgroundImage(UIImage.init(named: "CQIndexOutWork"), for: .normal)
        outWorkBtn.addTarget(self, action: #selector(outWorkClick), for: .touchUpInside)
        
        let lab = UILabel.init(frame: CGRect.init(x:  kWidth - AutoGetWidth(width: 105), y: outWorkBtn.bottom + AutoGetHeight(height: 8), width: AutoGetWidth(width: 48), height: AutoGetHeight(height: 13)))
        lab.textAlignment = .center
        lab.text = "外出"
        lab.textColor = UIColor.white
        lab.font = kFontSize13
        self.headImage.addSubview(lab)
        return outWorkBtn
    }()
    
    lazy var signOutBtn: UIButton = {
//        signOutCircle = UIView.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 75), y: AutoGetHeight(height: 203), width: AutoGetWidth(width: 46), height: AutoGetWidth(width: 46)))
//        signOutCircle?.backgroundColor = kAlpaRGB(r: 255, g: 255, b: 255, a: 0.35)
//        signOutCircle?.layer.cornerRadius = AutoGetWidth(width: 23)
//        self.headImage.addSubview(signOutCircle!)
        signOutCircle = AILoadingView.init(frame:  CGRect(x: kWidth - AutoGetWidth(width: 75), y: AutoGetHeight(height: 203), width: AutoGetWidth(width: 46), height: AutoGetWidth(width: 46)))
        signOutCircle?.loadingLayer.lineWidth = 4
        signOutCircle?.duration = 4
        signOutCircle!.strokeColor = kAlpaRGB(r: 255, g: 255, b: 255, a: 0.35)
        self.headImage.addSubview(signOutCircle!)
        
        
        let signOutBtn = UIButton.init(type: .custom)
        signOutBtn.frame = CGRect.init(x: kWidth - AutoGetWidth(width: 76), y: AutoGetHeight(height: 202), width: AutoGetWidth(width: 48), height: AutoGetWidth(width: 48))
        signOutBtn.setBackgroundImage(UIImage.init(named: "CQIndexSignOut"), for: .normal)
        signOutBtn.addTarget(self, action: #selector(signOutClick), for: .touchUpInside)
        
        let lab = UILabel.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 76), y: signOutBtn.bottom + AutoGetHeight(height: 8), width: AutoGetWidth(width: 48), height: AutoGetHeight(height: 13)))
        lab.textAlignment = .center
        lab.text = "下班"
        lab.textColor = UIColor.white
        lab.font = kFontSize13
        self.headImage.addSubview(lab)
        return signOutBtn
    }()
    
    lazy var btnView: UIView = {
        let btnView = UIView.init(frame: CGRect.init(x: 0, y: self.headImage.bottom, width: kWidth, height: AutoGetHeight(height: 49)))
        btnView.backgroundColor = UIColor.white
        btnView.layer.borderColor = kLineColor.cgColor
        btnView.layer.borderWidth = 0.5
//        let swipe  = UISwipeGestureRecognizer(target: self, action: #selector(swipeVC(swipeGes:)))
//        swipe.direction = .up
//        let swipeDown  = UISwipeGestureRecognizer(target: self, action: #selector(swipeVC(swipeDownGes:)))
//        swipeDown.direction = .down
//        btnView.addGestureRecognizer(swipe)
//        btnView.addGestureRecognizer(swipeDown)
        return btnView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView.init(frame: CGRect.init(x: 0 , y: AutoGetHeight(height: 47), width: kWidth/CGFloat(titleArr.count), height: AutoGetHeight(height: 2)))
        lineView.backgroundColor = kLightBlueColor
        return lineView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: btnView.bottom, width: kWidth, height: kHeight - AutoGetHeight(height: 320) - 49 ))
        scrollView.contentSize = CGSize.init(width: kWidth*CGFloat(titleArr.count), height:  kHeight - AutoGetHeight(height: 320) - 49 )
        scrollView.backgroundColor = UIColor.white
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        //scrollView.isScrollEnabled = false
        return scrollView
    }()
//    lazy var scrollView: QRScrollView = {
//        let scrollView = QRScrollView.init(frame: CGRect.init(x: 0, y: btnView.bottom, width: kWidth, height: kHeight - AutoGetHeight(height: 320) - 49 ))
//        scrollView.contentSize = CGSize.init(width: kWidth*CGFloat(titleArr.count), height:  kHeight - AutoGetHeight(height: 320) - 49 )
//        scrollView.backgroundColor = UIColor.white
//        scrollView.isPagingEnabled = true
//        scrollView.delegate = self
//        scrollView.showsVerticalScrollIndicator = false
//        scrollView.showsHorizontalScrollIndicator = false
//        // scrollView.isScrollEnabled = false
//        return scrollView
//    }()
    lazy var BigScrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - CGFloat(SafeTabbarBottomHeight)))
        scrollView.contentSize = CGSize.init(width: kWidth, height: kHeight +  AutoGetHeight(height: 289) - CGFloat(SafeTabbarBottomHeight) )
        scrollView.backgroundColor = UIColor.white
        scrollView.isPagingEnabled = false
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.tag = 10086
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            scrollView.scrollIndicatorInsets = scrollView.contentInset;
            
        } else {
            //低于 iOS 9.0
            //scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never;
            self.automaticallyAdjustsScrollViewInsets = false
           // scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            //scrollView.scrollIndicatorInsets = scrollView.contentInset;
        }
        return scrollView
    }()
    
    
    //是否弹出补卡请求
       func loadPopWindowData() {
           let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/schedule/getEmployeeBirthOfToday" ,
               type: .get,
               param: ["userId":userID],
               successCallBack: { (result) in
                
                let isShowBirthday = (UserDefaults.standard.value(forKey: "isShowBirthday") ?? false) as! Bool
                
//               let birthdayDate = (UserDefaults.standard.value(forKey: "birthdayDate") ?? "0000-00-00") as! String

//                if result["data"]["date"].stringValue == birthdayDate{
//                    if isShowBirthday == true{
//                    }else{
//                    }
//                }else{
//                }
                
                   if result["data"]["isTodayBirth"].boolValue{
                       //弹出生日祝福
                     if isShowBirthday == true{

                    }else{
                            DispatchQueue.main.asyncAfter(wallDeadline: .now()+3) {
                                   let mainV = Bundle.main.loadNibNamed("QRmainBirthView", owner: nil, options: nil)?.last as! QRmainBirthView
                                mainV.frame =  CGRect(x: 0, y: 0, width: kWidth, height: kHeight)
                                    UIApplication.shared.keyWindow?.addSubview(mainV)
                                    UserDefaults.standard.set(true, forKey: "isShowBirthday")
                            }
                    }
                   }else{
                    UserDefaults.standard.set(false, forKey: "isShowBirthday")
                }

           }) { (error) in

           }
       }
       
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        self.loadIconImg()
//        self.view.addSubview(self.BigScrollView)
//        self.BigScrollView.addSubview(self.headImage)
        self.view.addSubview(self.headImage)
        self.headImage.addSubview(self.titleLab)
        self.headImage.addSubview(self.smileWallBtn)
        self.headImage.addSubview(self.personIconBtn)
        self.headImage.addSubview(self.workSignBtn)
        self.headImage.addSubview(self.leaveBtn)
        self.headImage.addSubview(self.businessBtn)
        self.headImage.addSubview(self.outWorkBtn)
        self.headImage.addSubview(self.signOutBtn)
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: kWidth - 20 - AutoGetWidth(width: 15), y: 0, width: 20, height: 20))
        rightBtn.setImage(UIImage.init(named: "gdb"), for: .normal)
        rightBtn.titleLabel?.font = kFontSize14
        rightBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        rightBtn.center.y = titleLab.center.y
        rightBtn.frame.origin.x = kWidth - rightBtn.tz_width - AutoGetWidth(width: 15)
        rightBtn.addTarget(self, action: #selector(loadCard), for: .touchUpInside)

        let leftBtn = UIButton.init(frame: CGRect.init(x: AutoGetWidth(width: 15), y: 0, width: 40, height: 44))
        //leftBtn.setImage(UIImage.init(named: "gdb"), for: .normal)
        leftBtn.setTitle("开锁", for: UIControlState.normal)
        leftBtn.titleLabel?.font = kFontSize17
        leftBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        //leftBtn.sizeToFit()
        leftBtn.center.y = titleLab.center.y
        leftBtn.frame.origin.x = AutoGetWidth(width: 15)
        leftBtn.addTarget(self, action: #selector(loadQrcode), for: .touchUpInside)
        
        self.headImage.addSubview(leftBtn)
        self.headImage.addSubview(rightBtn)
        
        self.view.addSubview(self.btnView)
        
        self.btnView.addSubview(self.lineView)
        initBtn()
        self.view.addSubview(self.scrollView)
        

        let childVC0 = CQHasNotDoVC()
        childVC0.searchmode = "2"
        childVC0.redBut = btnArr.first
        childVC0.redBut?.badgeCenterOffset = CGPoint(x: -kWidth/CGFloat(titleArr.count)/2+25, y: AutoGetHeight(height: 10))
        childVC0.redBut?.clearBadge()
        
        let childVC1 = CQHasNotDoVC()
        childVC1.redBut = btnArr[1]
        childVC1.redBut?.badgeCenterOffset = CGPoint(x: -kWidth/CGFloat(titleArr.count)/2+25, y: AutoGetHeight(height: 10))
        childVC1.redBut?.clearBadge()
        childVC1.searchmode = "3"
        
        childvc1 = childVC0
        childvc2 = childVC1
        
        addChildViewController(childVC0)
        addChildViewController(childVC1)
       // 系统公告
        let childVC2 = CQNoticeVC()
        childVC2.isFromeIndex = true
        childVC2.redBut = btnArr[2]
        childVC2.redBut?.badgeCenterOffset = CGPoint(x: -kWidth/CGFloat(titleArr.count)/2+35, y: AutoGetHeight(height: 10))
        childVC2.redBut?.clearBadge()
        addChildViewController(childVC2)
        
        addChildView()
         NotificationCenter.default.addObserver(self, selector: #selector(refleshRedPot(notification:)), name: NSNotification.Name(rawValue: "reflashRedPot"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeHeaderImg(notification:)), name: NSNotification.Name(rawValue: "changePersonHeaderImg"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(launchActionV(notification:)), name: NSNotification.Name(rawValue: "launchActionV"), object: nil)
    
//        NotificationCenter.default.addObserver(self, selector: #selector(popBirthDayMainPageList(notification:)), name: NSNotification.Name(rawValue: "popBirthDayMainPageList"), object: nil)

        self.setAttenceEarlierHeadImageRequest(checkType: "today")
        self.btnClick(btn: self.btnArr[1])
        self.btnClick(btn: self.btnArr[2])
        self.btnClick(btn: self.btnArr[0])
        
        
        
        
    }
    
//    @objc func popBirthDayMainPageList(notification:Notification) {
//
//
//        }
    
    //手势
        @objc func swipeVC(swipeGes:UISwipeGestureRecognizer){
    
            if swipeGes.direction == .up {
                UIView.animate(withDuration: 0.3) {
                    swipeGes.view?.frame = CGRect(x: 0, y:CGFloat(SafeAreaTopHeight), width: kWidth, height: 50)
                    self.scrollView.frame =  CGRect(x: 0, y: swipeGes.view!.bottom, width: kWidth, height: kHeight-swipeGes.view!.bottom-CGFloat(SafeAreaBottomHeight))
                    self.childvc1?.table.frame =  CGRect(x: 0, y: 0, width: kWidth, height: kHeight-swipeGes.view!.bottom-CGFloat(SafeAreaBottomHeight))
                    self.childvc2?.table.frame =  CGRect(x: 0, y: 0, width: kWidth, height: kHeight-swipeGes.view!.bottom-CGFloat(SafeAreaBottomHeight))
                    //self.childvc3?..frame =  CGRect(x: 0, y: swipeGes.view!.bottom, width: kWidth, height: kHeight-swipeGes.view!.bottom-CGFloat(SafeAreaBottomHeight))
                }
    
            }
    
        }
    
        @objc func swipeVC(swipeDownGes:UISwipeGestureRecognizer){
    
            if swipeDownGes.direction == .down {
                UIView.animate(withDuration: 0.3) {
                    swipeDownGes.view?.frame = CGRect(x: 0, y: self.headImage.bottom, width: kWidth, height: 50)
                    self.scrollView.frame =  CGRect(x: 0, y: swipeDownGes.view!.bottom, width: kWidth, height: kHeight-swipeDownGes.view!.bottom-CGFloat(SafeAreaBottomHeight))
                    self.childvc1?.table.frame =  CGRect(x: 0, y: 0, width: kWidth, height: kHeight-swipeDownGes.view!.bottom-CGFloat(SafeAreaBottomHeight))
                    self.childvc2?.table.frame =  CGRect(x: 0, y: 0, width: kWidth, height: kHeight-swipeDownGes.view!.bottom-CGFloat(SafeAreaBottomHeight))
                 //   self.childvc3?.frame =  CGRect(x: 0, y: swipeDownGes.view!.bottom, width: kWidth, height: kHeight-swipeDownGes.view!.bottom-CGFloat(SafeAreaBottomHeight))
                }
    
            }
    
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
        self.loadDeskDatas()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var select = false
        let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        if app.mainVC?.selectedIndex == 0 {
            select = true
        }else{
            select = false
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: select)
        
        self.actionV?.isHidden = false
       // NotificationCenter.default.post(name: NSNotification.Name.init("refreshAllData"), object: nil)
        self.locateMap()
        
        if isAdmin {
            let curLongitude = String(format: "%.6f",118.181857 + (Float(arc4random()%100) + 1)/1000000 )
            let curLatitude = String(format: "%.6f",24.486354 + (Float(arc4random()%100) + 1)/1000000 )
            self.addressRemark = "中国福建省厦门市思明区观日路"
            self.saveAdminHistoryPosition(type: "3", lat: curLatitude, long: curLongitude)
        }else{
            self.saveHistoryPosition(type: "3")
        }
        
        UIApplication.shared.statusBarStyle = .lightContent
        
       
        
        //刷新红点
        let vc = self.childViewControllers.first as! CQHasNotDoVC
        vc.loadDatas(moreData: false)
        
        let vc1 = self.childViewControllers[1] as! CQHasNotDoVC
        vc1.loadDatas(moreData: false)
        
        let vc2 = self.childViewControllers[2] as! CQNoticeVC
        vc2.loadDatas(moreData: false)
        
        //弹窗
        self.loadPopWindowData()
    }
   
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.locationManager?.stopUpdatingLocation()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.actionV?.isHidden = true
        UIApplication.shared.statusBarStyle = .default
        self.signCircle?.stopAnimation()
        self.signCircle?.frame = CGRect.init(x: AutoGetWidth(width: 30), y: AutoGetHeight(height: 192), width: AutoGetWidth(width: 46), height: AutoGetWidth(width: 46))
        self.signCircle?.strokeColor = kAlpaRGB(r: 255, g: 255, b: 255, a: 0.35)
        self.signOutCircle?.stopAnimation()
        self.signOutCircle?.frame = CGRect(x: kWidth - AutoGetWidth(width: 75), y: AutoGetHeight(height: 203), width: AutoGetWidth(width: 46), height: AutoGetWidth(width: 46))
        self.signOutCircle?.strokeColor = kAlpaRGB(r: 255, g: 255, b: 255, a: 0.35)
    }
   
    //刷新红点
    @objc func refleshRedPot(notification:Notification)  {
       
        let vc = self.childViewControllers.first as! CQHasNotDoVC
        vc.loadDatas(moreData: false)
        
        let vc1 = self.childViewControllers[1] as! CQHasNotDoVC
        vc1.loadDatas(moreData: false)
        
        let vc2 = self.childViewControllers[2] as! CQNoticeVC
        vc2.loadDatas(moreData: false)
    }
    @objc func changeHeaderImg(notification:Notification)  {
        self.loadIconImg()
        
    }
    
    @objc func smileClick() {
        let vc = QRWorkmateCircleVC() //CQSmileWallVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getActionV() -> CQActionView {
        if actionV == nil{
            actionV = CQActionView.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 81), y: kHeight/3 * 2, width: AutoGetWidth(width: 81), height: AutoGetHeight(height: 152)))
            actionV?.lastDelegate = self
            actionV?.currentDelegate = self
            actionV?.iconDelegate = self
        }
        return actionV!
    }
    
    @objc func launchActionV(notification:Notification) {
        self.getActionV().removeFromSuperview()
//        let app = UIApplication.shared.delegate as! AppDelegate
//        app.window?.addSubview(self.getActionV())
        self.view.addSubview(self.getActionV())
        self.view.bringSubview(toFront: actionV!)
        self.firstBtnTitle = "本月"
        self.secBtnTitle = "上月"
        self.setAttenceEarlierHeadImageRequest(checkType: "today")
    }
    
    //发起群聊
    @objc func launchGroupChat()  {
        remarkView = CQApprovalRemarkView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), viewTitle: "群聊名称", isAgree: true,placeHolder:"请输入群名称")
        remarkView?.cqRemarkDelegate = self
        remarkView?.isFromIndex = true
        remarkView?.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.addSubview(remarkView!)
        
    }
    //发起名片夹
    @objc func loadCard()  {
            let selectView = CQBussinessSelectV.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight))
            selectView.cqSelectDelegate = self
            let app = UIApplication.shared.delegate as! AppDelegate
            app.window?.addSubview(selectView)
        
      
    }
   
    //2维码识别
    @objc func loadQrcode(){

        let vc =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "qrcode") as! QRqrcodeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func iconClick()  {
        let vc = CQBusinessCardVC.init()
        vc.title = STUserTool.account().realName + "的名片"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //签到
    @objc func signClick()  {
    //    let vc = CQCheckWorkAttendanceVC.init()
     //   vc.isFromSign = true
        let vc = QRSignVC.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func signAnimation()  {
//        UIView.animate(withDuration: 1.5, animations: {
//            self.signCircle?.frame = CGRect.init(x: AutoGetWidth(width: 23), y: AutoGetHeight(height: 185), width: AutoGetWidth(width: 60), height: AutoGetWidth(width: 60))
//            self.signCircle?.layer.cornerRadius = AutoGetWidth(width: 30)
//        }) { (isFinish) in
//            self.signCircle?.frame = CGRect.init(x: AutoGetWidth(width: 30), y: AutoGetHeight(height: 192), width: AutoGetWidth(width: 46), height: AutoGetWidth(width: 46))
//            self.signCircle?.layer.cornerRadius = AutoGetWidth(width: 23)
//        }
//        self.signCircle?.frame = CGRect.init(x: AutoGetWidth(width: 23), y: AutoGetHeight(height: 185), width: AutoGetWidth(width: 55), height: AutoGetWidth(width: 55))
        self.workSignBtn.frame = CGRect.init(x: AutoGetWidth(width: 27), y: AutoGetHeight(height: 189), width: AutoGetWidth(width: 52), height: AutoGetWidth(width: 52))
        self.signCircle?.frame.size = CGSize(width: AutoGetWidth(width: 55), height: AutoGetWidth(width: 55))
        self.signCircle?.center = self.workSignBtn.center
        
        self.signCircle?.starAnimation()
        self.signCircle?.strokeColor = UIColor.white
    }
    
    //请假
    @objc func leaveClick()  {
        let vc = NCQApprovelVC.init()
        vc.businessCode = "B_QJ"
        vc.titleStr = "请假"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func leaveAnimation()  {
        UIView.animate(withDuration: 1.5, animations: {
            self.leaveCircle?.frame = CGRect.init(x: AutoGetWidth(width: 54), y: AutoGetHeight(height: 113), width: AutoGetWidth(width: 60), height: AutoGetWidth(width: 60))
            self.leaveCircle?.layer.cornerRadius = AutoGetWidth(width: 30)
        }) { (isFinish) in
            self.leaveCircle?.frame = CGRect.init(x: AutoGetWidth(width: 61), y: AutoGetHeight(height: 120), width: AutoGetWidth(width: 46), height: AutoGetWidth(width: 46))
            self.leaveCircle?.layer.cornerRadius = AutoGetWidth(width: 23)
        }
    }
    
    //出差
    @objc func businessClick()  {
        self.getIsBusinessTravelTodayRequest()
        
    }
    
    @objc func businessAnimation()  {
        UIView.animate(withDuration: 1.5, animations: {
            self.businessCircle?.frame = CGRect.init(x: kWidth/2 - AutoGetWidth(width: 30), y: AutoGetHeight(height: 72), width: AutoGetWidth(width: 60), height: AutoGetWidth(width: 60))
            self.businessCircle?.layer.cornerRadius = AutoGetWidth(width: 30)
        }) { (isFinish) in
            self.businessCircle?.frame = CGRect.init(x: kWidth/2 - AutoGetWidth(width: 23), y: AutoGetHeight(height: 77), width: AutoGetWidth(width: 46), height: AutoGetWidth(width: 46))
            self.businessCircle?.layer.cornerRadius = AutoGetWidth(width: 23)
        }
    }
    
    //外出
    @objc func outWorkClick()  {
        let vc = CQFieldPersonelVC.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func outWorkAnimation()  {
        UIView.animate(withDuration: 1.5, animations: {
            self.outWorkCircle?.frame = CGRect.init(x:  kWidth - AutoGetWidth(width: 112), y: AutoGetHeight(height: 116), width: AutoGetWidth(width: 60), height: AutoGetWidth(width: 60))
            self.outWorkCircle?.layer.cornerRadius = AutoGetWidth(width: 30)
        }) { (isFinish) in
            self.outWorkCircle?.frame =  CGRect.init(x:  kWidth - AutoGetWidth(width: 105), y: AutoGetHeight(height: 123), width: AutoGetWidth(width: 46), height: AutoGetWidth(width: 46))
            self.outWorkCircle?.layer.cornerRadius = AutoGetWidth(width: 23)
        }
        
       
    }
    
    //签退
    @objc func signOutClick()  {
//        let vc = CQCheckWorkAttendanceVC.init()
//        vc.isFromOut = true
        let vc = QRSignVC.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func signOutAnimation()  {
//        UIView.animate(withDuration: 1.5, animations: {
//            self.signOutCircle?.frame = CGRect.init(x: kWidth - AutoGetWidth(width: 82), y: AutoGetHeight(height: 196), width: AutoGetWidth(width: 60), height: AutoGetWidth(width: 60))
//            self.signOutCircle?.layer.cornerRadius = AutoGetWidth(width: 30)
//        }) { (isFinish) in
//            self.signOutCircle?.frame =  CGRect.init(x:kWidth - AutoGetWidth(width: 75), y: AutoGetHeight(height: 203), width: AutoGetWidth(width: 46), height: AutoGetWidth(width: 46))
//            self.signOutCircle?.layer.cornerRadius = AutoGetWidth(width: 23)
//        }
        
        self.signOutBtn.frame =  CGRect.init(x: kWidth - AutoGetWidth(width: 78), y: AutoGetHeight(height: 200), width: AutoGetWidth(width: 52), height: AutoGetWidth(width: 52))
        self.signOutCircle?.frame.size = CGSize(width: AutoGetWidth(width: 55), height: AutoGetWidth(width: 55))
        self.signOutCircle?.center = self.signOutBtn.center
       
        self.signOutCircle?.starAnimation()
         self.signOutCircle?.strokeColor = UIColor.white
    }
    
    //生成btn群
    func initBtn()  {
        
        for i in 0..<titleArr.count {
            let btn = UIButton.init(type: .custom)
            btn.frame = CGRect.init(x: kWidth/CGFloat(titleArr.count) * CGFloat(i), y: 0, width: kWidth/CGFloat(titleArr.count), height: AutoGetHeight(height: 49))
            btn.setTitle(titleArr[i], for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.tag = 300+i
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            btn.setTitleColor(kLightBlueColor, for: .selected)
            btn.setTitleColor(klightGreyColor, for: .normal)
            
            btn.titleLabel?.font = kFontSize15
            self.btnView.addSubview(btn)
            self.btnArr.append(btn)
        
            
        }
    }
    
    //点击事件
    @objc func btnClick(btn:UIButton)  {
        if lastBtn?.tag != btn.tag {
            lastBtn?.setTitleColor(klightGreyColor, for: .normal)
            lastBtn?.titleLabel?.font = kFontSize15
            btn.titleLabel?.font = kFontBoldSize18
            btn.setTitleColor(kLightBlueColor, for: .normal)
            lastBtn = btn
//            self.lineView.frame.origin.x = (kWidth/3 - AutoGetWidth(width: 60))/2 + kWidth/3 * CGFloat(btn.tag - 300)
            let xx = kWidth/CGFloat(titleArr.count) * CGFloat(btn.tag - 300)
            UIView.animate(withDuration: 0.25) {
                self.lineView.frame = CGRect.init(x: xx, y: AutoGetHeight(height: 47), width: kWidth/CGFloat(self.titleArr.count), height: AutoGetHeight(height: 2))
            }
            self.scrollView.setContentOffset(CGPoint.init(x: kWidth * CGFloat(btn.tag - 300), y: 0), animated: true)
        }
//        let vc = self.childViewControllers.first as! CQHasNotDoVC
//        vc.loadDatas(moreData: false)
//        
//        let vc1 = self.childViewControllers[1] as! CQHasNotDoVC
//        vc1.loadDatas(moreData: false)
    }
    
    //添加子控制器的view
    fileprivate func addChildView() {
        
        let index: CGFloat = self.scrollView.contentOffset.x / self.view.frame.size.width
        
        //取出子控制器
        let childVc = childViewControllers[Int(index)]
        if childVc.isViewLoaded {
            return
        }
        
        childVc.view.frame = CGRect.init(x: self.scrollView.bounds.origin.x, y: self.scrollView.bounds.origin.y, width: self.scrollView.bounds.width, height: self.scrollView.bounds.height)
        self.scrollView.addSubview(childVc.view)
        
      
    }
    
    
    
    
}


//数据处理
extension CQIndexVC{
    //最早考勤人头像
    func setAttenceEarlierHeadImageRequest(checkType:String)  {
        let userId = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/attendance/attendanceEarliestHeadImage" ,
            type: .get,
            param: ["checkType":checkType,
                    "emyeId":userId],
            successCallBack: { (result) in
               
                var imageStr = ""
                imageStr = result["data"]["headImage"].stringValue
                NotificationCenter.default.post(name: NSNotification.Name.init("changeActionVImage"), object: imageStr)
        }) { (error) in
            
        }
    }
    //最早考勤人头像
    func setAttenceEarlierHeadImageRequest(checkType:String,btn:UIButton,isOneClick:Bool)  {
        let userId = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/attendance/attendanceEarliestHeadImage" ,
            type: .get,
            param: ["checkType":checkType,
                    "emyeId":userId],
            successCallBack: { (result) in
                
                
                if isOneClick{
                    if self.firstBtnTitle == "本月" && self.secBtnTitle == "上月"{
                        self.firstBtnTitle = "今日"
                        btn.setTitle("今日", for: .normal)
                    }else if self.firstBtnTitle == "本月" && self.secBtnTitle == "今日"{
                        self.firstBtnTitle = "上月"
                        btn.setTitle("上月", for: .normal)
                    }else if self.firstBtnTitle == "上月" && self.secBtnTitle == "今日"{
                        self.firstBtnTitle = "本月"
                        btn.setTitle("本月", for: .normal)
                    }else if self.firstBtnTitle == "上月" && self.secBtnTitle == "本月"{
                        self.firstBtnTitle = "今日"
                        btn.setTitle("今日", for: .normal)
                    }else if self.firstBtnTitle == "今日" && self.secBtnTitle == "本月"{
                        self.firstBtnTitle = "上月"
                        btn.setTitle("上月", for: .normal)
                    }else if self.firstBtnTitle == "今日" && self.secBtnTitle == "上月"{
                        self.firstBtnTitle = "本月"
                        btn.setTitle("本月", for: .normal)
                    }
                }else{
                    if self.firstBtnTitle == "本月" && self.secBtnTitle == "上月"{
                        self.secBtnTitle = "今日"
                        btn.setTitle("今日", for: .normal)
                    }else if self.firstBtnTitle == "本月" && self.secBtnTitle == "今日"{
                        self.secBtnTitle = "上月"
                        btn.setTitle("上月", for: .normal)
                    }else if self.firstBtnTitle == "上月" && self.secBtnTitle == "今日"{
                        self.secBtnTitle = "本月"
                        btn.setTitle("本月", for: .normal)
                    }else if self.firstBtnTitle == "上月" && self.secBtnTitle == "本月"{
                        self.secBtnTitle = "今日"
                        btn.setTitle("今日", for: .normal)
                    }else if self.firstBtnTitle == "今日" && self.secBtnTitle == "本月"{
                        self.secBtnTitle = "上月"
                        btn.setTitle("上月", for: .normal)
                    }else if self.firstBtnTitle == "今日" && self.secBtnTitle == "上月"{
                        self.secBtnTitle = "本月"
                        btn.setTitle("本月", for: .normal)
                    }
                }
                var imageStr = ""
                imageStr = result["data"]["headImage"].stringValue
                NotificationCenter.default.post(name: NSNotification.Name.init("changeActionVImage"), object: imageStr)
        }) { (error) in
            
        }
    }
    
    fileprivate func loadDeskDatas() {
        let now = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        var dateStr = ""
        dateStr = dateFormat.string(from: now)
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/attendance/checkWorkAttendanceType" ,
            type: .get,
            param: ["emyeId":userID,
                    "dateStr":dateStr],
            successCallBack: { (result) in
                
                self.timer?.invalidate()
                self.timer = nil
                
                let attendanceStatusType = result["data"]["attendanceStatusType"].stringValue
                if !isAdmin{
                    if attendanceStatusType == "onWork"{
//                        self.timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector:#selector(self.signAnimation), userInfo: nil, repeats: true)
                        self.signAnimation()
                        self.saveHistoryPosition(type: "1")
                    }else if attendanceStatusType == "onLeave"{
                        self.timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector:#selector(self.leaveAnimation), userInfo: nil, repeats: true)
                        self.saveHistoryPosition(type: "3")
                    }else if attendanceStatusType == "onTravelBusiness"{
                        self.timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector:#selector(self.businessAnimation), userInfo: nil, repeats: true)
                        self.saveHistoryPosition(type: "2")
                    }else if attendanceStatusType == "onOutWork"{
                        self.timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector:#selector(self.outWorkAnimation), userInfo: nil, repeats: true)
                        self.saveHistoryPosition(type: "2")
                    }else if attendanceStatusType == "goOffWork"{
//                        self.timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector:#selector(self.signOutAnimation), userInfo: nil, repeats: true)
                        self.signOutAnimation()
                        self.saveHistoryPosition(type: "3")
                    }else{
                        self.saveHistoryPosition(type: "3")
                    }
                }
                
                
                
        }) { (error) in
            
        }
    }
    
    @objc func saveHistoryPosition(type:String)  {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/historyPosition/saveHistoryPosition",
            type: .post,
            param: ["userId":userID,
                    "type":type,
                    "addressRemark":self.addressRemark,
                    "latitudeValue":self.curLatitude ?? 0.0,
                    "longitudeValue":self.curLongitude ?? 0.0],
            successCallBack: { (result) in
                
        }) { (error) in
        }
    }
    
    @objc func saveAdminHistoryPosition(type:String,lat:String,long:String)  {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/historyPosition/saveHistoryPosition",
            type: .post,
            param: ["userId":userID,
                    "type":type,
                    "addressRemark":self.addressRemark,
                    "latitudeValue":lat,
                    "longitudeValue":long],
            successCallBack: { (result) in
                
        }) { (error) in
        }
    }
    
    @objc func loadIconImg()  {
        let par = ["emyeId":STUserTool.account().userID]
        STNetworkTools.requestData(URLString: "\(baseUrl)/my/index",
            type: .get,
            param: par,
            successCallBack: { (result) in
                let image = self.personIconBtn.viewWithTag(100) as! UIImageView
                image.sd_setImage(with: URL(string: result["data"]["headImage"].stringValue), placeholderImage:UIImage.init(named: "CQIndexPersonDefault"))
                UserDefaults.standard.set(result["data"]["workNumber"].stringValue, forKey: "personnelNo")
                UserDefaults.standard.set(result["data"]["realName"].stringValue, forKey: "personnelName")
        }) { (error) in
        }
    }
    
    //
    func getIsBusinessTravelTodayRequest() {
        let userID = STUserTool.account().userID
        let now = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormat.string(from: now)
        STNetworkTools.requestData(URLString:"\(baseUrl)/businessSign/getIsBusinessTravelToday" ,
            type: .get,
            param: ["userId":userID,
                    "recordDate":dateStr],
            successCallBack: { (result) in
                var tempArray = [CQSmileWallModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQSmileWallModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                if tempArray.count > 0 {
                    if tempArray.count > 1{
                        let vc = CQMyBusinessListVC()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        let vc = CQBussinessSignVC()
                        vc.businessApplyId = tempArray[0].businessApplyId
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else{
                    let vc = NCQApprovelVC.init()
                    vc.businessCode = "B_CC"
                    vc.titleStr = "出差"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                
        }) { (error) in
            let vc = NCQApprovelVC.init()
            vc.businessCode = "B_CC"
            vc.titleStr = "出差"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension CQIndexVC: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        addChildView()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / scrollView.frame.width
        let btn = btnArr[Int(index)]
        addChildView()
        btnClick(btn: btn)
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.tag == 10086{
//                print("xxxxxxx"+"\(scrollView.contentOffset.y)")
//            if scrollView.contentOffset.y < self.headImage.bottom{
//
//            }else{
//                childvc1?.table.isScrollEnabled = true
//            }
//
//        }
//
//    }
}

extension CQIndexVC:CQCurretMonthClickDelegate{
    func currentMonthAction(btn: UIButton) {
        
        if self.firstBtnTitle == "本月" && self.secBtnTitle == "上月"{
            self.setAttenceEarlierHeadImageRequest(checkType: "this", btn: btn,isOneClick:true)
        }else if self.firstBtnTitle == "本月" && self.secBtnTitle == "今日"{
            self.setAttenceEarlierHeadImageRequest(checkType: "this", btn: btn,isOneClick:true)
        }else if self.firstBtnTitle == "上月" && self.secBtnTitle == "今日"{
            self.setAttenceEarlierHeadImageRequest(checkType: "last", btn: btn,isOneClick:true)
        }else if self.firstBtnTitle == "上月" && self.secBtnTitle == "本月"{
            self.setAttenceEarlierHeadImageRequest(checkType: "last", btn: btn,isOneClick:true)
        }else if self.firstBtnTitle == "今日" && self.secBtnTitle == "本月"{
            self.setAttenceEarlierHeadImageRequest(checkType: "today", btn: btn,isOneClick:true)
        }else if self.firstBtnTitle == "今日" && self.secBtnTitle == "上月"{
            self.setAttenceEarlierHeadImageRequest(checkType: "today", btn: btn,isOneClick:true)
        }
        
    }
}

extension CQIndexVC:CQLastMonthClickDelegate{
    func lastMonthAction(btn: UIButton) {
        
        if self.firstBtnTitle == "本月" && self.secBtnTitle == "上月"{
            self.setAttenceEarlierHeadImageRequest(checkType: "last", btn: btn,isOneClick:false)
        }else if self.firstBtnTitle == "本月" && self.secBtnTitle == "今日"{
            self.setAttenceEarlierHeadImageRequest(checkType: "today", btn: btn,isOneClick:false)
        }else if self.firstBtnTitle == "上月" && self.secBtnTitle == "今日"{
            self.setAttenceEarlierHeadImageRequest(checkType: "today", btn: btn,isOneClick:false)
        }else if self.firstBtnTitle == "上月" && self.secBtnTitle == "本月"{
            self.setAttenceEarlierHeadImageRequest(checkType: "this", btn: btn,isOneClick:false)
        }else if self.firstBtnTitle == "今日" && self.secBtnTitle == "本月"{
            self.setAttenceEarlierHeadImageRequest(checkType: "this", btn: btn,isOneClick:false)
        }else if self.firstBtnTitle == "今日" && self.secBtnTitle == "上月"{
            self.setAttenceEarlierHeadImageRequest(checkType: "last", btn: btn,isOneClick:false)
        }
        
    }
}

extension CQIndexVC:CQApprovalRemarkDelegate{
    func getApprovelDoing(remark: String, isAgree: Bool) {
        self.remarkView?.removeFromSuperview()
        let vc = AddressBookVC.init()
        vc.toType = .fromGroupChat
        vc.groupNames = remark
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CQIndexVC:CQActionVIconDelegate{
    func iconAction() {
        let vc = CQRankVC.init()
        let now = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let str = dateFormat.string(from: now)
        vc.timeString = str
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// Mark:高德位置
extension CQIndexVC:AMapLocationManagerDelegate{
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
        let geoCoder = CLGeocoder.init()
        geoCoder.reverseGeocodeLocation(location) { (placemark, error) -> Void in
            if(error == nil)//成功
            {
                let array = placemark! as NSArray
                
                let mark = array.firstObject as! CLPlacemark
                
                let FormattedAddressLines: NSString = ((mark.addressDictionary! as NSDictionary).value(forKey: "FormattedAddressLines") as AnyObject).firstObject as! NSString
                let str2 = FormattedAddressLines as String
                self.addressRemark = str2
                DLog(self.addressRemark)
            }else
            {
                print(error ?? "")
            }
        }
    }
}

extension CQIndexVC:CQBussinessCardListSelectDelegate{
    func pushToDetailThroughType(btn: UIButton) {
        if 400 == btn.tag{
         
           let cardVC = CQBussinessCardListVC()
           self.navigationController?.pushViewController(cardVC, animated: false)
           cardVC.checkAuthen()
        }else if 401 == btn.tag{
          
            let cardVC = CQBussinessCardListVC()
            self.navigationController?.pushViewController(cardVC, animated: false)
            cardVC.pushToEdite()
        }else {
           
            let cardVC = CQBussinessCardListVC()
            self.navigationController?.pushViewController(cardVC, animated: false)
            cardVC.checkPhotoAuthen()
        }
        
}
}

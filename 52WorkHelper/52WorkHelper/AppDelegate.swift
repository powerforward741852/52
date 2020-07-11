//
//  AppDelegate.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/4/23.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?

    var mainVC:MainTabbarController?
    
    var pushDic : NSDictionary?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        DLog(UIDevice.current.identifierForVendor?.uuidString)
        DLog(Bundle.main.bundleIdentifier)
         DLog(NSHomeDirectory())

        UIViewController.swizzlePresent()

        HDeviceIdentifier.syncDeviceIdentifier()
        
        //相册,相机授权
       // getAuthen()

        
        var isLogin:Bool?
        if UserDefaults.standard.value(forKey: "APPIsLogin") != nil {
            isLogin = UserDefaults.standard.value(forKey: "APPIsLogin") as? Bool
            if isLogin! {
              //  rongCloundConnect()
                self.getBaseInfo()
            }
        }
        loadJPushHandle(launchOptions: launchOptions)
        self.loadGuideData()
        
        loadMap()
        // MARK:Share
        loadShare()
        // MARK:SV
        SVpublicConfig()
        
     //   loadPGY()
       // Bugly.start(withAppId: "c2d9953f1a")
        
        //注册推送
        let setting = UIUserNotificationSettings.init(types: UIUserNotificationType.alert , categories: nil)
        application.registerUserNotificationSettings(setting)
        
        //检测版本
        NotificationCenter.default.addObserver(self, selector: #selector(loadVersion(notification:)), name: NSNotification.Name.init("loadCurrentVersion"), object: nil)
        //融云
//        NotificationCenter.default.addObserver(self, selector: #selector(refreshGroupInfo(notification:)), name: NSNotification.Name.init("loadGroupDataNow"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(shouldRongCloundConnect(notification:)), name: NSNotification.Name(rawValue: "rongCloudRequest"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(refreshChatInfo(notification:)), name: NSNotification.Name(rawValue: "refreshChatInfo"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(rcimReciveMessage(notification:)), name: Notification.Name.RCKitDispatchMessage, object: nil)
        

        //杀死状态下的推送
            if launchOptions == nil {
                pushDic = nil
            }else{
//                 let dicc = launchOptions![UIApplicationLaunchOptionsKey.remoteNotification] as! NSDictionary
////                SVProgressHUD.showInfo(withStatus: getJSONStringFromDictionary(dictionary: dicc))
//                pushDic = dicc
                
                
                  let dicc = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification]
                    if dicc == nil{
                       pushDic = nil
                    }else{
                       pushDic = dicc as! NSDictionary
                    }
              
            }
           
        return true
    }
    
  
    func getAuthen()  {
        //相册授权
        PHPhotoLibrary.requestAuthorization({ (firstStatus) in
            let result = (firstStatus == .authorized)
            if result {
               // print("允许APP访问相册")
            } else {
             //   print("拒绝APP访问相册")
            }
        })
        //相机授权
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (statusFirst) in
            if statusFirst {
               // print("允许APP访问相机")
            } else {
                
            }
        })
    }
    
    //员工之心,获取IP地址
    func getBaseInfo()  {
        let model = StarViewModel.init()
        model.getIpWithModel()
    }
    
    
    

    
    
    //加载版本更新
    @objc func loadVersion(notification:Notification)  {
        if !isAdmin{
            self.loadCurrentVersion()
        }
        
    }
    
    
    //载入极光
    func loadJPushHandle(launchOptions:[UIApplicationLaunchOptionsKey: Any]?) {
        let entity = JPUSHRegisterEntity.init()
        entity.types = Int(UInt8(JPAuthorizationOptions.alert.rawValue)|UInt8(JPAuthorizationOptions.badge.rawValue)|UInt8(JPAuthorizationOptions.sound.rawValue))
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        
//        let advertisingId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        //如不需要使用IDFA，advertisingIdentifier 可为nil
  
        JPUSHService.setup(withOption: launchOptions,
                           appKey: JPAPPKEY,
                           channel: JPCHANNEL,
                           apsForProduction: isTrueEnvironment,
                           advertisingIdentifier: "")
        JPUSHService.registrationIDCompletionHandler { (resCode, registrationID) in
            if resCode == 0{
                UserDefaults.standard.set(registrationID, forKey: "JPushRegisterId")
                self.updataJpushRegisterId(jPushRegistrationId: registrationID!)
                DLog(registrationID)
            }else{
                DLog(resCode)
            }
        }
        
        
    }
    //更新用户极光推送id
    func updataJpushRegisterId(jPushRegistrationId:String) {
        let userID = STUserTool.account().userID
        if userID.count > 0 {
//            Alamofire.request("\(baseUrl)/loginModule/updateUserJPushRegistration",
//                method: .post,
//                parameters: ["jPushRegistrationId":jPushRegistrationId,
//                             "userId":userID]).responseJSON { (response) in
//
//            }
            
            STNetworkTools.requestData(URLString:"\(baseUrl)/loginModule/updateUserJPushRegistration" ,
                type: .post,
                param: ["jPushRegistrationId":jPushRegistrationId,"userId":userID],
                successCallBack: { (result) in
                // SVProgressHUD.showInfo(withStatus: result["message"].stringValue)
            }) { (error) in
                
            }
        }
    }
    
    //加载引导页
    func loadGuideData()  {
        let num = kHeight/kWidth
        let fNum = String.init(format: "%.2f", num)
        var guideImageArray = [String]()
        STNetworkTools.requestData(URLString:"\(baseUrl)/loginModule/getStartImageList" ,
            type: .get,
            param: ["imageProportion":fNum],
            successCallBack: { (result) in
                var tempArray = [CQGuideModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQGuideModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                
                for model in tempArray{
                    guideImageArray.append(model.startImageUrl)
                }
                self.loadTabbarControlle()
                
                
                if guideImageArray.count > 0{
                    let images = guideImageArray
                    let ranGuide = RanGuidePages(frame: UIScreen.main.bounds, images: images)
                    self.window?.addSubview(ranGuide)
                }
                
        }) { (error) in
            self.loadTabbarControlle()
        }
    }
    
    //加载tabbar
    func loadTabbarControlle() -> Void {
        if mainVC == nil {
            mainVC = MainTabbarController.init()
        }
        
        let user = STUserTool.account()
        if user.userName.count < 1{
            let vc = LoginVC()
            window?.rootViewController = vc
        }else{
            mainVC?.selectedIndex = 0
            mainVC?.delegate = self
            window?.rootViewController = mainVC
        }
        window?.backgroundColor = kProjectBgColor
        window?.makeKeyAndVisible()
        
        if (self.pushDic != nil) {
            self.loadPushInfo(userInfo: self.pushDic! )
        }
        
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    
    //强制更新
    func loadCurrentVersion()  {
        STNetworkTools.requestData(URLString:"\(baseUrl)/loginModule/getAppSystemConfig" ,
            type: .get,
            param: nil,
            successCallBack: { (result) in
                let currentVersion = result["data"]["currentVersion"].stringValue
                let currentUrl =  result["data"]["currentUrl"].stringValue
                //"https://itunes.apple.com/app/id1461729715"
                if currentVersion.compare(CQVersion) == .orderedDescending{
                    let v = CQVersionView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), title: "", message: "", urlStr: currentUrl)
                    v.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
                    let app = UIApplication.shared.delegate as! AppDelegate
                    v.vDelegate = self
                    app.window?.addSubview(v)
                }
                else{
//                    PgyUpdateManager.sharedPgy()?.checkUpdate(withDelegete: self, selector: #selector(self.updateMethod(dic: )))
                }

        }) { (error) in

        }
    }
    
//    @objc func updateMethod(dic:NSDictionary)  {
//        if dic.value(forKey: "version") != nil{
//
//            let v = CQVersionView.init( title: "", message: "", urlStr: dic.value(forKey: "appUrl") as! String)
//            v.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
//            let app = UIApplication.shared.delegate as! AppDelegate
//            v.vDelegate = self
//            app.window?.addSubview(v)
//        }else{
//        }
//    }
    
    
//   @objc func updateMethod(dic:NSDictionary)  {
//        if let version = dic.value(forKey: "version"){
//            //判断
//            let str = "AppReadVersion"
//            if let readSign = UserDefaults.standard.value(forKey:str ){
//
//            }else{
//                UserDefaults.standard.set("readSign", forKey: str)
//            }
//            if  UserDefaults.standard.value(forKey:str )as!String != CQVersion{
//                let v = CQVersionView.init( title: "", message: "", urlStr: dic.value(forKey: "appUrl") as! String)
//                v.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
//                let app = UIApplication.shared.delegate as! AppDelegate
//                v.vDelegate = self
//                app.window?.addSubview(v)
//                UserDefaults.standard.set((version as! String), forKey: str)
//            }else{
//
//            }
//
//        }else{
//
//        }
//    }
    
    
    //系统更新
//    func loadCurrentVersion()  {
//        STNetworkTools.requestData(URLString:"\(baseUrl)/loginModule/getAppSystemConfig" ,
//            type: .get,
//            param: nil,
//            successCallBack: { (result) in
//                let currentVersion = result["data"]["currentVersion"].stringValue
//                let currentUrl = result["data"]["currentUrl"].stringValue
//                let force = true
//                let readSign = true
//                //判断是否需要更新
//                if currentVersion.compare(CQVersion) == .orderedDescending{
//                    //需要更新,判断是否为强转更新
//                    if force{
//                        let v = CQVersionView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), title: "", message: "", urlStr: currentUrl)
//                        v.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
//                        let app = UIApplication.shared.delegate as! AppDelegate
//                        v.vDelegate = self
//                        app.window?.addSubview(v)
//                    }else{
//                        if readSign {
//                            //已读就不需要弹窗,自己去设置更新
//                        }else{
//                            //未读就需要弹窗,点击确定或者取消之后,设置已读
//                            let v = CQVersionView.init( title: "", message: "", urlStr: currentUrl)
//                            v.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
//                            let app = UIApplication.shared.delegate as! AppDelegate
//                            v.vDelegate = self
//                            app.window?.addSubview(v)
//                        }
//                       
//                    }
//                    
//                }else{
//                    //不需要更新
//                }
//                
//        }) { (error) in
//            
//        }
//    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let dataStr = NSData.init(data: deviceToken)
        let token = dataStr.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
     //   RCIMClient.shared().setDeviceToken(token)
        
        /// Required - 注册 DeviceToken
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        DLog(error)
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        JPUSHService.setBadge(0)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        JPUSHService.setBadge(0)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reflashRedPot"), object: self, userInfo: nil)
    }
    
    func loadMap()  {
        AMapServices.shared().apiKey = gaodeKey
        AMapServices.shared().enableHTTPS = true

    }
    
    // MARK:share配置
    func loadShare()  {
        /**
         *  初始化ShareSDK应用
         *  @param activePlatforms          使用的分享平台集合，如:@[@(SSDKPlatformTypeSinaWeibo), @(SSDKPlatformTypeTencentWeibo)];
         *  @param importHandler           导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作。具体的导入方式可以参考ShareSDKConnector.framework中所提供的方法。
         *  @param configurationHandler     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
         */
        
        ShareSDK.registerActivePlatforms(
            [SSDKPlatformType.typeWechat.rawValue,
             SSDKPlatformType.typeQQ.rawValue],
            // onImport 里的代码,需要连接社交平台SDK时触发
            onImport: {(platform : SSDKPlatformType) -> Void in
                switch platform
                {
                case SSDKPlatformType.typeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                case SSDKPlatformType.typeQQ:
                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                default:
                    break
                }
        },
            onConfiguration: {(platform : SSDKPlatformType , appInfo : NSMutableDictionary?) -> Void in
                switch platform
                {
                    
                case SSDKPlatformType.typeWechat:
                    //设置微信应用信息
                    appInfo?.ssdkSetupWeChat(byAppId: wxAppKey,
                                             appSecret: wxAppSecret)
                case SSDKPlatformType.typeQQ:
                    //设置QQ应用信息
                    appInfo?.ssdkSetupQQ(byAppId: qqAppKey,
                                         appKey: qqAppSecret,
                                         authType: SSDKAuthTypeWeb)
                default:
                    break
                }
        })
}
    //蒲公英配置
//    func loadPGY()  {
//       PgyManager.shared()?.start(withAppId: "7718ff4d7f610a0f0e5d53ea27859478")
//       PgyUpdateManager.sharedPgy()?.start(withAppId: "7718ff4d7f610a0f0e5d53ea27859478")
//       PgyManager.shared()?.isFeedbackEnabled = false
//    }
  //   MARK:SV全局设置
    func SVpublicConfig () {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1))
        SVProgressHUD.setMinimumDismissTimeInterval(0.75)
        SVProgressHUD.setMaximumDismissTimeInterval(3)
        SVProgressHUD.setOffsetFromCenter(UIOffset(horizontal: 0, vertical: 40))
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        IQKeyboardManager.shared.registerTextFieldViewClass(YYTextView.self, didBeginEditingNotificationName: "YYTextViewTextDidBeginEditing", didEndEditingNotificationName: "YYTextViewTextDidEndEditing")
    }
    
    
   

}




// MARK:tabbarControllerDelegate
extension AppDelegate:UITabBarControllerDelegate{
    // MARK:tabbar 点击事件 去小红点
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabbar = tabBarController.tabBar
        if tabBarController.selectedIndex == 0 {
            tabbar.removeBadgeOnItemIndex(index: 0)
        } 
    }
}

extension AppDelegate:CQVersionUpdataClickDelegate{
    func versionUpdataAction(url: String) {
        UIApplication.shared.openURL(URL.init(string:url)!)
    }
}

extension AppDelegate:JPUSHRegisterDelegate{
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        // Required
       
        let userInfo:NSDictionary = notification.request.content.userInfo as NSDictionary
        if notification.request.trigger is UNPushNotificationTrigger{
            JPUSHService.handleRemoteNotification(userInfo as? [AnyHashable : Any])
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reflashRedPot"), object: self, userInfo: nil)
        
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue)) // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    }
    
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        // Required
        let userInfo:NSDictionary = response.notification.request.content.userInfo as NSDictionary
        if response.notification.request.trigger is UNPushNotificationTrigger{
            JPUSHService.handleRemoteNotification(userInfo as? [AnyHashable : Any])
        }
        
        
//        SVProgressHUD.showInfo(withStatus: getJSONStringFromDictionary(dictionary: userInfo))
        self.loadPushInfo(userInfo: userInfo)
      
        completionHandler()
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // Required, iOS 7 Support
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        // Required,For systems with less than or equal to iOS6
        JPUSHService.handleRemoteNotification(userInfo)
    }
    
}

extension AppDelegate{
    func topVC() -> UIViewController {
        return self.topVCWithRootVC(rootViewController: (self.window?.rootViewController)!)
    }
    
    func topVCWithRootVC(rootViewController:UIViewController) -> UIViewController {
        if rootViewController is UITabBarController{
            let tabbarController:UITabBarController = rootViewController as! UITabBarController
            return self.topVCWithRootVC(rootViewController:tabbarController.selectedViewController!)
        }else if rootViewController is UINavigationController{
            let nav:UINavigationController = rootViewController as! UINavigationController
            return self.topVCWithRootVC(rootViewController:nav.visibleViewController!)
        }else if (rootViewController.presentedViewController != nil){
            let presentVC:UIViewController = rootViewController
            return self.topVCWithRootVC(rootViewController:presentVC)
        }else{
            return rootViewController
        }
    }
    
    func loadPushInfo(userInfo:NSDictionary)  {
        if userInfo["data"] != nil{
            let data:String = userInfo["data"] as! String
            let dic = getDictionaryFromJSONString(jsonString: data)
            let workType = dic["workType"] as! NSNumber
            var workId:NSNumber?
            var workName = ""
            if workType != 2{
                workId = dic["workId"] as? NSNumber
                workName = dic["workName"] as! String
            }
            
 
            let cv = (UIApplication.shared.keyWindow?.rootViewController)!//self.topVC()
            cv.modalPresentationStyle = .fullScreen
            if workType == 0{
                 let vc = NCQApproelDetailVC()
                  vc.isFromApp = true
                  vc.modalPresentationStyle = .fullScreen
                  let nav = UINavigationController.init(rootViewController: vc)
                  vc.businessApplyId = String.init(format: "%@", workId!)
                  vc.title = workName
                  vc.isFromMeSubmit = true
                  cv.present(nav, animated: true, completion: nil)
           }else if workType == 1 {
                let vc = NCQApproelDetailVC()
                vc.isFromApp = true
                vc.modalPresentationStyle = .fullScreen
                let nav = UINavigationController.init(rootViewController: vc)
                vc.businessApplyId = String.init(format: "%@", workId!)
                vc.title = workName
                vc.isFromWaitApprovel = true
                cv.present(nav, animated: true, completion: nil)
            }else if workType == 2 {
                //let vc = CQCheckWorkAttendanceVC()
                let vc = QRSignVC.init()
                vc.modalPresentationStyle = .fullScreen
                let nav = UINavigationController.init(rootViewController: vc)
                cv.present(nav, animated: true, completion: nil)
            }else if workType == 3{
                let vc = NCQApproelDetailVC()
                vc.modalPresentationStyle = .fullScreen
                let nav = UINavigationController.init(rootViewController: vc)
                vc.businessApplyId = String.init(format: "%@", workId!)
                vc.title = workName
                vc.isFromCopyToMe = true
                vc.isFromApp = true
                cv.present(nav, animated: true, completion: nil)
            }else if workType == 4{
                let vc = CQScheduleDetailVC()
                vc.modalPresentationStyle = .fullScreen
                let nav = UINavigationController.init(rootViewController: vc)
                vc.schedulePlanId = String.init(format: "%@", workId!)
                vc.title = workName
                vc.isFromApp = true
                cv.present(nav, animated: true, completion: nil)
            }else if workType == 5{
                let vc = CQTaskDetailVC()
                vc.modalPresentationStyle = .fullScreen
                let nav = UINavigationController.init(rootViewController: vc)
                vc.personnelTaskId = String.init(format: "%@", workId!)
                vc.title = workName
                vc.isFromApp = true
                cv.present(nav, animated: true, completion: nil)
            }else if workType == 6{
                //会议
                let vc = CQScheduleDetailVC()
                vc.modalPresentationStyle = .fullScreen
                vc.schedulePlanId = String.init(format: "%@", workId!)
                vc.title = workName
                vc.isFromApp = true
                let nav = UINavigationController.init(rootViewController: vc)
                cv.present(nav, animated: true, completion: nil)
            }else if workType == 7{

                //是否生日祝福
                let  isBirthwish = dic["isBirthwish"] as? Bool
                let  workDate = dic["workDate"] as? String
                if isBirthwish==nil || isBirthwish == false{
                    //公告通知
                   let vc = CQNoticeVC.init()
                   vc.isFromApp = true
                    vc.modalPresentationStyle = .fullScreen
                   let nav = UINavigationController.init(rootViewController: vc)
                   cv.present(nav, animated: true, completion: nil)

                }else{
                    let vc = QRBirthDayParterVC.init()
                    vc.isMainpage = true
                    vc.isfromMain = true
                    vc.date = workDate!
                    let nav = UINavigationController.init(rootViewController: vc)
//                    let back = UIButton(frame:  CGRect(x: 0, y: 0, width: 100, height: 44))
//                    back.setTitle("取消", for: UIControlState.normal)
//                    back.addTarget(self, action: #selector(back), for: UIControlEvents.touchUpInside)
//                    nav.navigationItem.backBarButtonItem = UIBarButtonItem(customView: back)

                    cv.present(nav, animated: true, completion: nil)
                }


                
    
                
            }else if  workType == 8{
                //点赞
                let vc = QRWorkmateCircleVC()
                vc.isFromApp = true
                vc.modalPresentationStyle = .fullScreen
                let nav = UINavigationController.init(rootViewController: vc)
                cv.present(nav, animated: true, completion: nil)

            }else if workType == 9{
                //生日祝福
                let vc = QRWorkmateCircleVC()
                vc.isFromApp = true
                vc.modalPresentationStyle = .fullScreen
                let nav = UINavigationController.init(rootViewController: vc)
                cv.present(nav, animated: true, completion: nil)
              
            }else{
                
            }
        }else if userInfo["rc"] != nil{
//            let jsonDic = JSON.init(userInfo["rc"] as Any)
//            let str = "\(jsonDic)"
//            let subStr = (str as NSString).replacingOccurrences(of: "\n", with: "")
//            let dic = getDictionaryFromJSONString(jsonString: subStr)
//            DLog(dic)
//            let cType = dic["cType"] as! String
//            DLog(cType)
//            let cv = self.topVC()
//            if cType == "GRP"{
//                let vc = CQChatWithSomeOneController()
//                let nav = UINavigationController.init(rootViewController: vc)
//                vc.targetId = dic["tId"] as? String
////                vc.title =
//                vc.isFromApp = true
//                vc.conversationType = .ConversationType_GROUP
//                cv.present(nav, animated: true, completion: nil)
//            }else if cType == "SYS"{
//            RCIMClient.shared().clearMessagesUnreadStatus(RCConversationType.ConversationType_SYSTEM, targetId: "2")
//                //公告通知
//                let vc = CQNoticeVC.init()
//                vc.isFromApp = true
//                let nav = UINavigationController.init(rootViewController: vc)
//                cv.present(nav, animated: true, completion: nil)
//            }
            
        }
    }

    
    func loadDeleteDaiBan(id:String) {
        STNetworkTools.requestData(URLString:"\(baseUrl)/mailList/deleteAllUntreatedWork" ,
            type: .post,
            param: ["untreatedWorkIds[]":[id]],
            successCallBack: { (result) in
                
                
        }) { (error) in
            
        }
    }
    
    
}


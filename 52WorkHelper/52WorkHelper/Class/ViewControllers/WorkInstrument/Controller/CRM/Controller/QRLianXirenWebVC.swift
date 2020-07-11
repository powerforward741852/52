//
//  QRLianXirenWebVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/13.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit
import WebKit
class QRLianXirenWebVC: UIViewController {
    
    
    var customerId  = ""
    
    var cardUrl = ""
    var model:PersonModel?
    fileprivate lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.preferences = WKPreferences()
        config.preferences.minimumFontSize = 10
        config.processPool = WKProcessPool()
        let webview = WKWebView(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHeight ), configuration: config)
        return webview
    }()
    
    fileprivate lazy var progress: UIProgressView = {
        let progress = UIProgressView()
        progress.frame = CGRect(x: 0, y: 64, width: kWidth, height: 5)
        progress.trackTintColor = UIColor.white
        progress.progressTintColor = #colorLiteral(red: 0.4590730071, green: 0.862973392, blue: 0.7096511722, alpha: 1)
        self.view.addSubview(progress)
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let rightBut = UIBarButtonItem(image: UIImage(named: "ShareUnAble"), style: .done, target: self, action: #selector(share))
        navigationItem.rightBarButtonItem = rightBut
          view.addSubview(webView)
        // Do any additional setup after loading the view.
        webView.navigationDelegate = self
        webView.uiDelegate = self
        //进度条
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
//        self.cardUrl = "\(baseUrl)/my/businessCard" + "?emyeId=" + STUserTool.account().userID + "&type=my"
//        webView.load(URLRequest.init(url: URL.init(string: self.cardUrl)!))
        
        
        
        let userID = STUserTool.account().userID
    //"http://192.168.1.33:9094/api/v1/crmCustomer/getCrmCustomerDetails?commodityId=\(customerId)&userId=\(userID)"
        let str = URL(string: "\(baseUrl)/crmCustomer/getCrmCustomerDetails?customerId=\(customerId)&userId=\(userID)")
        let request = URLRequest(url: str!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 60)
       webView.load(request)
    
    }
    
    
    func initShareView()  {
        let shareV = CQShareView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - CGFloat(SafeAreaBottomHeight)))
        shareV.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
        shareV.cqShareDelegate = self
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.addSubview(shareV)
    }
    
    //分享朋友圈
    @objc func share(){
        initShareView()
    }
    //监听加载进度
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progress.progress = Float(webView.estimatedProgress)
        }
        if !webView.isLoading {
            UIView.animate(withDuration: 0.55, animations: { () -> Void in
                self.progress.alpha = 0.0
            })
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
}


extension QRLianXirenWebVC:WKNavigationDelegate,WKUIDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIView.animate(withDuration: 0.55, animations: { () -> Void in
            self.progress.alpha = 0.0
        })
    }
}


extension QRLianXirenWebVC:CQShareDelegate{
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
        //        let imgData = NSData.init(contentsOf: URL.init(string: imgUrl)!)
        //        let img = UIImage.init(data: imgData! as Data)
        // 1.创建分享参数
        
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: "部门：" + (self.model?.departmentName)! + "\n" + "职位：" + (self.model?.positionName)! + "\n" + "手机：" + STUserTool.account().userName,
                                          images : self.model?.headImage,
                                          url : NSURL(string:self.cardUrl) as URL?,
                                          title : (self.model?.realName)! + "的名片",
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




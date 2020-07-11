//
//  CQBusinessCardVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/3.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit
import WebKit
class CQBusinessCardVC: SuperVC {

    var uid = ""
    var cardUrl = ""
    var isFromChat = false
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
        
        self.loadPersonInfo()
        
        // Do any additional setup after loading the view.
        webView.navigationDelegate = self
        webView.uiDelegate = self
        view.addSubview(webView)
        //进度条
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        if self.isFromChat{
           self.cardUrl = "\(baseUrl)/my/businessCard" + "?emyeId=" + uid + "&type=my"
        }else{
            self.cardUrl = "\(baseUrl)/my/businessCard" + "?emyeId=" + STUserTool.account().userID + "&type=my"
        }
        
        webView.load(URLRequest.init(url: URL.init(string: self.cardUrl)!))
        
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        rightBtn.setTitle("分享", for: .normal)
        rightBtn.sizeToFit()
        rightBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        rightBtn.setTitleColor(UIColor.colorWithHexString(hex: "#20afff"), for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        rightBtn.addTarget(self, action: #selector(shareClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        
    }
    
    func initShareView()  {
        let shareV = CQShareView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - CGFloat(SafeAreaBottomHeight)))
        shareV.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
        shareV.cqShareDelegate = self
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.addSubview(shareV)
    }
    
    @objc func shareClick()  {
        self.initShareView()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progress.progress = Float(webView.estimatedProgress)
        }
        
        if !webView.isLoading {
            UIView.animate(withDuration: 0.55, animations: { () -> Void in
                self.progress.alpha = 0.0
            })
        }
        
        if keyPath == "title" {
            if (object as! WKWebView) == self.webView{
                self.title = self.webView.title
            }
        }
        
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "title")
    }
    
    
    func loadPersonInfo() {
        let userID = STUserTool.account().userID
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/my/index" ,
            type: .get,
            param: ["emyeId":userID],
            successCallBack: { (result) in
                guard let model = PersonModel.init(jsonData: result["data"]) else {
                    return
                }
                self.model = model
               
        }) { (error) in
            
        }
    }

}

extension CQBusinessCardVC:WKNavigationDelegate,WKUIDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIView.animate(withDuration: 0.55, animations: { () -> Void in
            self.progress.alpha = 0.0
        })
    }
}

extension CQBusinessCardVC:CQShareDelegate{
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


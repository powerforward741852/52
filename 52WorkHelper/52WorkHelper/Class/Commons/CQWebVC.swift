//
//  CQWebVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/7.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit
import WebKit

class CQWebVC: SuperVC {

    
    var isPDF = false
    var titleStr = ""
    var urlStr = ""
    var isFromApp = false
    var isFromSmallWebVC = false
    
    fileprivate lazy var webView: WKWebView = {
        
        let config = WKWebViewConfiguration()
        config.preferences = WKPreferences()
        config.preferences.minimumFontSize = 10
        config.processPool = WKProcessPool()
       // config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypes.all
        let webview = WKWebView(frame: CGRect(x: 0, y: SafeAreaTopHeight, width: kWidth, height: kHeight-SafeAreaTopHeight), configuration: config)
        return webview
    }()
    
    fileprivate lazy var progress: UIProgressView = {
        let progress = UIProgressView()
        progress.frame = CGRect(x: 0, y: SafeAreaTopHeight, width: kWidth, height: 2)
        progress.trackTintColor = UIColor.white
        progress.progressTintColor = #colorLiteral(red: 0.4590730071, green: 0.862973392, blue: 0.7096511722, alpha: 1)
        self.view.addSubview(progress)
        return progress
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = titleStr
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        view.addSubview(webView)
//        view.addSubview(progress)
        //进度条
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        //清楚空格
        
      
        self.urlStr = recursive(urlstr: self.urlStr)
          if isPDF{
//方法一
            DispatchQueue.global().async {
                SVProgressHUD.show()
                     let data = try? Data(contentsOf: URL.init(string: self.urlStr)!)
                   DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.webView.load(data!, mimeType: "application/pdf", characterEncodingName: "GBK", baseURL: URL.init(string: self.urlStr)!)
                   }
               }

            
//方法2
//                let enc = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
//                 let string : String = NSString(data: responseObj as! Data, encoding: enc) as! String
//                var result:String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//
//                webView.load(URLRequest.init(url: URL.init(string: self.urlStr)!))
//            var reque = URLRequest.init(url: URL.init(string: self.urlStr)!)
//            reque.setValue("application/pdf,charset=GBK", forHTTPHeaderField: "Content-Type")
//            webView.load(reque)
          }else{
               webView.load(URLRequest.init(url: URL.init(string: self.urlStr)!))
          }
        
        
        
      
        
        //if self.isFromSmallWebVC{
            let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
            rightBtn.setTitle("分享", for: .normal)
            rightBtn.sizeToFit()
            rightBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
            rightBtn.setTitleColor(UIColor.colorWithHexString(hex: "#20afff"), for: .normal)
            rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            rightBtn.addTarget(self, action: #selector(shareClick), for: .touchUpInside)
            let rightItem = UIBarButtonItem.init(customView: rightBtn)
            self.navigationItem.rightBarButtonItem = rightItem
      //  }
        
    }
    //递归去除
    func recursive(urlstr:String) -> String{
        if urlstr.hasSuffix(" ") {
            var tempstr = urlstr
            tempstr.removeLast()
            let result = recursive(urlstr: tempstr)
            return result
        } else {
            return urlstr
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isFromApp {
            self.navigationItem.leftBarButtonItem = self.barBackButton()
        }
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
        
//        if keyPath == "title" {
//            if (object as! WKWebView) == self.webView{
//                self.title = self.webView.title
//            }
//        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
//        webView.removeObserver(self, forKeyPath: "title")
        NotificationCenter.default.removeObserver(self)
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
}

extension CQWebVC:WKNavigationDelegate,WKUIDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIView.animate(withDuration: 0.55, animations: { () -> Void in
            self.progress.alpha = 0.0
        })
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
//        if navigationAction.targetFrame == nil{
//            self.webView.load(URLRequest.init(url: URL.init(string: self.urlStr)!))
//        }
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
}

extension CQWebVC:CQShareDelegate{
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
        
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: "52工作助手",
                                          images : UIImage.init(named: "1024"),
                                          url : NSURL(string:self.urlStr) as URL?,
                                          title : self.titleStr,
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

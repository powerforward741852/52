//
//  QRCustomWebVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/19.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit
import WebKit
import Contacts
import MessageUI
import Messages
class QRCustomWebVC: SuperVC {
    //0客户 1商品 2商机
    var type = 0
    //商品id
    var comdityId = ""
    //客户id
    var customerId  = ""
    var cardUrl = ""
    var model:PersonModel?
    var customer : QRKeHuModel?
    var goodsModel :QRGoodsModel?
    var businessModel :QRDetailBusinessMdel?
    var customurl :URL?
    var save = "0"
    var goodsurl :URL?
    
    var dataArr = [QRLianXiRenModel]()
    //选中联系人model
    var overTimeModel:CQDepartMentUserListModel?
    
    fileprivate lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.preferences = WKPreferences()
        config.preferences.minimumFontSize = 10
        config.processPool = WKProcessPool()
        let webview = WKWebView(frame: CGRect(x: 0, y: SafeAreaTopHeight, width: kWidth, height: kHeight-SafeAreaTopHeight ), configuration: config)
        
        webview.uiDelegate = self
        webview.navigationDelegate = self
        
        return webview
    }()
    
    fileprivate lazy var composeVC: MFMessageComposeViewController = {
        let composeVC = MFMessageComposeViewController()
         
         //composeVC.delegate = self
         composeVC.messageComposeDelegate = self
        return composeVC
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
        if #available(iOS 11.0, *) {
            //            table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
            //            table.contentInset = UIEdgeInsetsMake(CGFloat(SafeAreaTopHeight), 0, CGFloat(SafeAreaBottomHeight), 0);
            //            table.scrollIndicatorInsets = table.contentInset;
        } else {
            //低于 iOS 9.0
            self.automaticallyAdjustsScrollViewInsets = false
        }
        let rightBut = UIBarButtonItem(image: UIImage(named: "ShareUnAble"), style: .done, target: self, action: #selector(share))
        rightBut.tintColor = kBlueColor
        
        navigationItem.rightBarButtonItem = rightBut
        view.addSubview(webView)
        // Do any additional setup after loading the view.
        webView.navigationDelegate = self
        webView.uiDelegate = self
        //进度条
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        
        let userID = STUserTool.account().userID
        //"http://192.168.1.33:9094/api/v1/crmCustomer/getCrmCustomerDetails?commodityId=\(customerId)&userId=\(userID)"
        
        
        if type == 0  || type == 2{
          let  str = URL(string: "\(baseUrl)/crmCustomer/getCrmCustomerDetails?customerId=\(customerId)&userId=\(userID)")
            let request = URLRequest(url: str!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 60)
            self.customurl = str
            self.title = "客户详情"
            self.loadLianXiRenList()
            
            webView.load(request)
            if self.customer == nil {
                //加载别的model
                self.customer = QRKeHuModel()
                self.customer?.name = self.businessModel?.crmCustomerName
                //第一个联系人的信息
                let contact = QRContactModel()
                contact.linkName = (self.businessModel?.linkPersonName)!
                contact.linkPhone = (self.businessModel?.linkPersonPhone)!
                
                self.customer?.crmLinkmans.insert(contact, at: 0)
            }
            
        } else if type == 1 {
           
            let str = URL(string: baseUrl + "/crmCommodity/getCommodityInfo?commodityId=\(comdityId)")
            let request = URLRequest(url: str!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 60)
            self.goodsurl = str
            self.title = "商品详情"
            webView.load(request)
        }
        
        let NotifMycation2 = NSNotification.Name(rawValue:"refreshAddAddressVC")
        NotificationCenter.default.addObserver(self, selector: #selector(overChange(notif:)), name: NotifMycation2, object: nil)
     
    }
    
    //接受对象
    @objc func overChange(notif: NSNotification) {
        guard let model: CQDepartMentUserListModel = notif.object as? CQDepartMentUserListModel else { return }
        
        self.overTimeModel = model
      
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
         webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
  
    func initShareView()  {
        let shareV = CQShareView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - CGFloat(SafeAreaBottomHeight)))
    
        shareV.type = type
        shareV.setData()
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
    

    func loadLianXiRenList(){
        //   let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmBusiness/getCrmLinkmanList", type: .get, param: ["crmCustomer":customerId], successCallBack: { (result) in
            var tempArr = [QRLianXiRenModel]()
            for xx in result["data"].arrayValue{
                let mod = QRLianXiRenModel(jsonData: xx)
                tempArr.append(mod!)
            }
            self.dataArr = tempArr
           
            
        }) { (error) in
            
        }
        
    }
    

}




extension QRCustomWebVC:WKNavigationDelegate,WKUIDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIView.animate(withDuration: 0.55, animations: { () -> Void in
            self.progress.alpha = 0.0
        })
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let str = navigationAction.request.url, str.absoluteString.hasPrefix("sms:") {
            //截取电话号码
            var urlStr = str.absoluteString
            urlStr.removeSubrange(str.absoluteString.range(of: "sms:")!)
            
            let items = ["发短信"]
            let vProperty = FWSheetViewProperty()
            vProperty.touchWildToHide = "1"
            let sheetView = FWSheetView.sheet(title:"", itemTitles: items, itemBlock: { [unowned self] (popupView, index, title) in
 
                
                let composeVC = MFMessageComposeViewController()
                composeVC.messageComposeDelegate = self
                composeVC.recipients = [urlStr]
                composeVC.body = ""
                composeVC.modalPresentationStyle = .fullScreen
                self.present(composeVC, animated: true, completion: nil)

            
            }, cancenlBlock: {
                print("点击了取消")
            }, property: vProperty)
            sheetView.show()
            
            
        }
        if let str = navigationAction.request.url, str.absoluteString.hasPrefix("tel:") {
            print("tel")
            var urlStr = str.absoluteString
            urlStr.removeSubrange(str.absoluteString.range(of: "tel:")!)
            let items = ["拨打电话"]
            let vProperty = FWSheetViewProperty()
            vProperty.touchWildToHide = "1"
            let sheetView = FWSheetView.sheet(title:"", itemTitles: items, itemBlock: {  (popupView, index, title) in
                let url = URL(string: "tel:" + "\(urlStr)" )
                UIApplication.shared.openURL(url!)
            }, cancenlBlock: {
                print("点击了取消")
            }, property: vProperty)
            sheetView.show()
        }
        decisionHandler(WKNavigationActionPolicy.allow)
        
    }
}


extension QRCustomWebVC : MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate{
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
       
        
        switch result {
        case MessageComposeResult.cancelled:
            controller.dismiss(animated: true, completion: nil)
            break
        case MessageComposeResult.sent:
            controller.dismiss(animated: true, completion: nil)
            break
        case MessageComposeResult.failed:
            controller.dismiss(animated: true, completion: nil)
            break

        }
        
    }
 
    
}


extension QRCustomWebVC:CQShareDelegate{
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
        }else if 4 == index{
            //商品分享或者保存客户
            if self.type == 0{
             //保存客户
                CNContactStore().requestAccess(for: .contacts) { (isRight, error) in
                    if isRight {
                        //授权成功添加数据。
                        self.addContact()
                    }
                }
                return
            }else if self.type == 1{
             //商品分享
               // let vc = AddressBookVC.init()
                let vc = QRAddressBookVC.init()
                vc.toType = .fromContact
                if self.overTimeModel != nil{
                    vc.hasSelectModelArr = [self.overTimeModel] as! [CQDepartMentUserListModel]
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
//                let contact = QRAddressBookVC()
//                contact.titleStr = "跟进人"
//                contact.hasSelectModelArr = self.TrackArray
//                contact.toType = ToAddressBookType.fromGenJin
//                self.navigationController?.pushViewController(contact, animated: true)
                
                
                return
            }
        }
        
        
        
      let shareParames = NSMutableDictionary()
        // 1.创建分享参数
        if self.type == 0 || self.type == 2{
            var str = " "
            if let linkManMod = self.dataArr.first{
                str = "姓名：" + "\(linkManMod.linkName)" + "\n" + "手机：" + "\(linkManMod.linkPhone)"
            }
            
            shareParames.ssdkSetupShareParams(byText: str,
                                              images : UIImage(named: "1024"),
                                              url : customurl,
                                              title : self.customer?.name,
                                              type : SSDKContentType.webPage)
        }else if  self.type == 1 {
            var str = " "
            if let goodMod = self.goodsModel{
                str = "商品分类：" + "\(goodMod.commodityCategoryName)" + "\n" + "销售价：" + "\(goodMod.commodityPrice)" +  goodMod.commodityUnitName
            }
            shareParames.ssdkSetupShareParams(byText: str ,
                                              images : UIImage(named: "1024"),
                                              url : self.goodsurl ,
                                              title : self.goodsModel?.commodityName,
                                              type : SSDKContentType.webPage)
        }
        
        
        
        
        
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
    
    
    
    
    func addContact() {
        //创建通讯录对象
        let store = CNContactStore()
        //创建CNMutableContact类型的实例
        let contactToAdd = CNMutableContact()
      
       // contactToAdd.givenName = "飞"
        //设置昵称
       // contactToAdd.nickname = "fly"
        //设置头像//设置电话
        let model = self.dataArr.first
        //设置姓名
        contactToAdd.familyName = (model?.linkName)!
        let mobileNumber = CNPhoneNumber(stringValue: (model?.linkPhone)!)
        if model?.linkPhone == "" {
            SVProgressHUD.showInfo(withStatus: "没有联系人电话")
          return
        }
        let mobileValue = CNLabeledValue(label: CNLabelPhoneNumberMobile,
                                         value: mobileNumber)
        contactToAdd.phoneNumbers = [mobileValue]
        //设置email
//   let email = CNLabeledValue(label: CNLabelHome, value: "feifei@163.com" as NSString)
//   contactToAdd.emailAddresses = [email]
        
     
        //获取Fetch,并且指定要获取联系人中的什么属性
        let keys = [ CNContactPhoneNumbersKey ]
        //创建请求对象
        //需要传入一个(keysToFetch: [CNKeyDescriptor]) 包含CNKeyDescriptor类型的数组
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        do {
            //写入联系人
            try store.enumerateContacts(with: request, usingBlock: { (contact, unsafe) in
                
              //  print(contact.phoneNumbers)
                for phone in contact.phoneNumbers {
                    //获得标签名（转为能看得懂的本地标签名，比如work、home）
                    var label = "未知标签"
                    if phone.label != nil {
                        label = CNLabeledValue<NSString>.localizedString(forLabel:
                            phone.label!)
                    }
                    DLog(label)
                    //获取号码
                    let value = phone.value.stringValue
                  
                    if value == (model?.linkPhone)!{
                        SVProgressHUD.showInfo(withStatus: "已存在该联系人")
                        self.save = "1"
                        return
                    }else{
                        
                    }
                    
//                    guard   value == (model?.linkPhone)! else{
//                         SVProgressHUD.showInfo(withStatus: "已存在该联系人")
//                        self.save = "1"
//                        return
//                    }
//                    self.save = "0"
                }
                
            })
            
        } catch {
            SVProgressHUD.showInfo(withStatus: error.localizedDescription)
            //print(error)
        }
        
        do {
            if save == "0"{
                let saveRequest = CNSaveRequest()
                saveRequest.add(contactToAdd, toContainerWithIdentifier: nil)
                try store.execute(saveRequest)
                SVProgressHUD.showInfo(withStatus: "保存联系人成功")
            }
            
        }catch{
            
        }
        
        
       
      
    }
}








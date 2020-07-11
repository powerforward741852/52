//
//  QRqrcodeVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/6/27.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class QRqrcodeVC: UIViewController {
    var navBar : QRNavbarView?
    
    @IBOutlet weak var qrCodeView: UIView!
    
    @IBOutlet weak var successView: UIView!
    
    @IBOutlet weak var successImage: UIImageView!
    
    @IBOutlet weak var refleshCodeLabel: MLLinkLabel!
    @IBOutlet weak var codeImage: UIImageView!
    
    @IBAction func sureAction(_ sender: Any) {
    }
    
    var imgStr = ""
    var isBig = false
    
    @IBOutlet weak var aspectWH: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.successView.isHidden = true
        
        //设置富文本

        let tempAtt = NSMutableAttributedString(string: "二维码自动  ")
        let shauXin = NSMutableAttributedString(string: "刷新")

        let dic = [NSAttributedStringKey.foregroundColor:kBlueC] as [NSAttributedStringKey : Any]
        shauXin.setAttributes(dic, range: ("刷新" as NSString).range(of: "刷新"))
        tempAtt.append(shauXin)
        refleshCodeLabel.attributedText = tempAtt
        
        //添加手势
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapTouchIn))
        refleshCodeLabel.addGestureRecognizer(tapGes)
        //图片添加手势
        codeImage.isUserInteractionEnabled = true
        let tapGesImg = UITapGestureRecognizer(target: self, action: #selector(tapImg))
        codeImage.addGestureRecognizer(tapGesImg)
        
        
        
       // title = "开锁"
       // navigationController?.navigationBar.layer.contents = UIImage(named: "bg_nav")?.cgImage
       // navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bg_nav"), for: UIBarMetrics.default)
//        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bg_nav"), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
//        navigationController?.navigationBar.tintColor = UIColor.white
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.view?.layer.contents = UIImage(named: "bgback")?.cgImage
        
//         NotificationCenter.default.addObserver(self, selector: #selector(updateImages(notification:)), name: NSNotification.Name(rawValue: "imagsCellID"), object: nil)
    }
    deinit {
         NotificationCenter.default.removeObserver(self)
    }
    @objc func tapTouchIn(){
      //刷新2维码
        loadQRcodeNew()
    }
    @objc func tapImg(){
        
//        let imgaArr = [imgStr]
//        let userinfo = ["imags" : imgaArr, "index": 0] as [String : Any]
//        //新建通知
//        let notification = NSNotification(name: NSNotification.Name(rawValue: "imagsCellID"), object: nil, userInfo: userinfo)
//        NotificationCenter.default.post(notification as Notification)
        
        isBig = !isBig
        if isBig == true{
             //self.qrCodeView.frame =  CGRect(x: 0, y: 0, width: kWidth, height: kHeight)
            
            UIView.animate(withDuration: 0.3) {
                self.codeImage.frame.size = CGSize(width: self.qrCodeView.width, height: self.qrCodeView.width)
               self.codeImage.center = CGPoint(x: self.qrCodeView.width/2, y: self.qrCodeView.height/2)
                self.refleshCodeLabel.isHidden = true
                self.refleshCodeLabel.frame.origin = CGPoint(x: 0, y: self.codeImage.bottom+25)
            }
            
            
        }else{
            //self.qrCodeView.frame =  CGRect(x: 0, y: 0, width: kWidth, height: kHeight)
            
            UIView.animate(withDuration: 0.3) {
                self.codeImage.frame.size = CGSize(width:  self.qrCodeView.width*0.6, height:  self.qrCodeView.width*0.6)
                self.codeImage.center = CGPoint(x: self.qrCodeView.width/2, y: self.qrCodeView.height/2-20)
                self.refleshCodeLabel.isHidden = false
                self.refleshCodeLabel.frame.origin = CGPoint(x: 0, y: self.codeImage.bottom+25)
            }
            
        }
       
    }
    @objc func updateImages(notification:NSNotification){
        
        let index = notification.userInfo?["index"] as? Int
        let imgs = notification.userInfo?["imags"] as? [String]
        if let index = index ,let imags = imgs, imags.count > 0{
            let previewVC = ImagePreViewVC(images: imags, index: index)
            self.navigationController?.pushViewController(previewVC, animated: true)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      //  self.automaticallyAdjustsScrollViewInsets = false
       // self.navigationController?.navigationBar.isHidden = false
        self.navBar?.removeFromSuperview()
        self.navBar = nil
        
        //self.perform(#selector(delayExecution), with: nil, afterDelay: 3)
       // Thread.sleep(forTimeInterval: 2)
         self.navigationController?.navigationBar.barTintColor = UIColor.white

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isHidden = true
        
         self.navigationController?.navigationBar.barTintColor = kColorRGB(r: 90, g: 199, b: 255)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        
        
        let nav = Bundle.main.loadNibNamed("QRHeadNavView", owner: nil, options: nil)?.last as! QRNavbarView
        nav.titleLab.text = "开锁"
        nav.backBut.setTitleColor( UIColor.white, for: UIControlState.normal)
        nav.jianTouIma.image = UIImage(named: "back_white_icon")//UIImage(named: "nav_bt_back")//
        nav.jianTouIma.backgroundColor = UIColor.clear
        nav.titleLab.textColor = UIColor.white
        nav.rightBut.isHidden = true
        
        
        nav.frame =  CGRect(x: 0, y: 0, width: kWidth, height: SafeAreaTopHeight)
        self.view.addSubview(nav)
        view.bringSubview(toFront: nav)
        self.navBar = nav
        self.navBar?.layer.contents = UIImage(named: "bg_nav")?.cgImage


        nav.clickClosure = {type in
            if type == .back{
                 self.navigationController?.popViewController(animated: true)
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        //loadQRcode()
        loadQRcodeNew()
    }
    
    func loadQRcode(){
        SVProgressHUD.show()
        let userName = STUserTool.account().userName
        let apiToken = STUserTool.account().token
        
        //http://oa.52zhushou.com
        STNetworkTools.requestData(URLString:"http://192.168.1.33:9093/code/QRCode/createCode" ,
            type: .post,
            param: ["userName":userName,"apiToken":apiToken],
            successCallBack: { (result) in

               let url = result["data"].stringValue
              self.codeImage.sd_setImage(with: URL(string: url ), placeholderImage:UIImage.init(named: "PersonNoticBg") )
                SVProgressHUD.dismiss()
        }) { (error) in
                SVProgressHUD.dismiss()
        }
    }
    
    func loadQRcodeNew(){
        
        SVProgressHUD.show()
        let userName = STUserTool.account().userName
        let apiToken = STUserTool.account().token
        let headers = ["t_userId": STUserTool.account().userID,
                       "token": STUserTool.account().token]
        
       // let base = "http://192.168.1.33:9093"
       // let base = "http://oa.52zhushou.com"
        Alamofire.request(baseCodeUrl+"/code/QRCode/createCode", method: .post, parameters: ["userName":userName,"apiToken":apiToken],  headers: headers).responseJSON { (
            response) in
                SVProgressHUD.dismiss()
            let result = response.result.value
            let json = JSON(result as Any)
            let dic = self.getDictionaryFromJSONString(jsonString: json.rawValue as! String)
            
            //PersonNoticBg//占位符
            if JSON(dic)["success"].boolValue  {
                let url = baseCodeUrl + JSON(dic)["data"].stringValue
                self.imgStr = url
                self.codeImage.sd_setImage(with: URL(string: url ), placeholderImage:UIImage.init(named: "") )
                SVProgressHUD.dismiss()
            }else{
                SVProgressHUD.showInfo(withStatus:JSON(dic)["message"].stringValue)
            }

            
           
           
          
            
        }
    }
    
    
    func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        let jsonData:Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
            
        }
        return NSDictionary()
        
    }
    

}

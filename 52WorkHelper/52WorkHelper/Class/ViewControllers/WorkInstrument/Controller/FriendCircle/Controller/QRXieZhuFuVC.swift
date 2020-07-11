
//
//  QRXieZhuFuVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/5/24.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class QRXieZhuFuVC: SuperVC {

    var backGroundImageId = "9"
    var dataModel : QRBirthModel?
    var isDetaile = false
    
    //声明闭包
    typealias clickBtnClosure = (_ backimg : String ) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    
    
    lazy var changeBackgroundBut : UIButton = {
        let changeBackgroundBut = UIButton(frame:  CGRect(x: kWidth-AutoGetWidth(width: 90), y: SafeAreaTopHeight+10, width: AutoGetWidth(width: 90), height: AutoGetWidth(width: 37.5)))
        changeBackgroundBut.setBackgroundImage(UIImage(named: "chann"), for: UIControlState.normal)
        changeBackgroundBut.addTarget(self, action: #selector(changeBackgroundButAction), for: UIControlEvents.touchUpInside)

        return changeBackgroundBut
    }()
    
    lazy var BackgroundView : UIView = {
        let BackgroundView = UIView(frame:  CGRect(x: 0, y: SafeAreaTopHeight, width: kWidth, height: kHeight-SafeAreaTopHeight))
        BackgroundView.layer.contents = UIImage(named: "bg9")?.cgImage
        return BackgroundView
    }()
    lazy var BackgroundImgView : UIImageView = {
        let BackgroundImgView = UIImageView(frame:  CGRect(x: 0, y: SafeAreaTopHeight, width: kWidth, height: kHeight-SafeAreaTopHeight))
       //BackgroundImgView.image = UIImage(named: "bg9")
        BackgroundImgView.isUserInteractionEnabled = true
        return BackgroundImgView
    }()
    
    
    lazy var textView: CBTextView = {
        let textView = CBTextView(frame:  CGRect(x:kLeftDis, y:AutoGetHeight(height: 60),width:kHaveLeftWidth, height: kHeight-SafeAreaTopHeight-AutoGetHeight(height: 120)))
        textView.placeHolder = "写下你的祝福"
        textView.placeHolderColor = UIColor.black
        textView.textView.font = kFontSize17
        textView.backgroundColor = UIColor.clear//UIColor.colorWithHexString(hex: "#05a3f5")
        textView.textView.backgroundColor = UIColor.clear//UIColor.colorWithHexString(hex: "#05a3f5")
        textView.aDelegate = self
      
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        if isDetaile{
            view.addSubview(BackgroundImgView)
            BackgroundImgView.addSubview(textView)
            
            loadDetail()
        }else{
            view.addSubview(BackgroundView)
            BackgroundView.addSubview(textView)
           view.addSubview(changeBackgroundBut)
            let RightButton = UIButton(frame:  CGRect(x: 0, y: 0, width: 60, height: 30))
            RightButton.setTitle("发送", for: UIControlState.normal)
            RightButton.addTarget(self, action: #selector(jumpIn), for: UIControlEvents.touchUpInside)
            RightButton.titleLabel?.font = kFontSize17
            RightButton.setTitleColor(kBlueColor, for: UIControlState.normal)
            RightButton.sizeToFit()
            RightButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: -7)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: RightButton)
        }
        
      
       
      
        
   
    }
    @objc func jumpIn(){
        let text = self.textView.textView.text
        if text?.count == 0 || text == "写下你的祝福"{
            SVProgressHUD.showInfo(withStatus: "你的祝福为空")
        }else{
            commitWish(texts: text!)
            
        }
    }
    @objc func loadDetail(){
        self.loadingPlay()
        //let userID = STUserTool.account().userID
        let benisonId = (dataModel?.contentId) ?? ""
        STNetworkTools.requestData(URLString: "\(baseUrl)/birth/getBenisonDetails", type: MethodType.get, param: ["benisonId":benisonId], successCallBack: { (result) in
            if result["success"].boolValue == true{
                self.loadingSuccess()
              
               self.textView.textView.isSelectable = false
                
                let textStr = result["data"]["content"].stringValue
                    var str = textStr
                    if textStr.hasSuffix("\n"){
                        str.removeLast()
                        if str.fromBase64() == nil{
                            str =  str.replacingOccurrences(of: "\n", with: "").fromBase64()!
                        }else{
                            str = str.fromBase64()!
                        }
                    }else{
                        str = textStr
                    }
                    self.textView.prevText = str
                

              //   self.textView.prevText = result["data"]["content"].stringValue
                 self.textView.textView.inputView = nil
                 self.BackgroundImgView.sd_setImage(with: URL(string: result["data"]["imgUrl"].stringValue), placeholderImage:UIImage(named:"bg9") , options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
               
            }
            
        }) { (error) in
            self.loadingSuccess()
        }
    }
    
    func commitWish(texts:String)  {
        //["toUserIds":userIds]
        self.loadingPlay()//,"toUserIds":"0"
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/birth/saveBenison", type: MethodType.post, param: ["content":texts ,"createUserId":userID,"type":"2","backGroundImageId":backGroundImageId,"toUserIds":""], successCallBack: { (result) in
            if result["success"].boolValue == true{
                self.loadingSuccess()
                 self.clickClosure!("reflash")
               // SVProgressHUD.showInfo(withStatus: result["message"].stringValue)
                SVProgressHUD.showInfo(withStatus: "发布成功")
                self.navigationController?.popViewController(animated: true)
            }
            
        }) { (error) in
            self.loadingSuccess()
        }
    }
    
    
    @objc func changeBackgroundButAction(){
        let  vc = QRChooseBackgroundVC()
        vc.title = "选择背景"
        vc.clickClosure = {[unowned self]img in
            self.backGroundImageId = img
            self.BackgroundView.layer.contents = UIImage(named: "bg"+img)?.cgImage
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension QRXieZhuFuVC : UITextViewDelegate{
  
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        //self.text = textView.text
    }

}

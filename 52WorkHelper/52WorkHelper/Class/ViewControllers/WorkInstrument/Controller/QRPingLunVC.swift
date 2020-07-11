//
//  QRPingLunVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/4/20.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRPingLunVC: SuperVC {
//    var commentUserTo = ""
//    var commentUserFrom = ""
//    var circleCommentId = ""
    
    var isFromBack = false
    var backMod : QRCommentDataModel!
    var pataskId = ""
    var preStr = "输入内容,如注意事项"
    var textStr = ""
    lazy var headView: UIView = {
        let headView = UIView.init(frame:  CGRect.init(x: 0, y: CGFloat(SafeAreaTopHeight) , width: kWidth, height: AutoGetHeight(height: 165)))
        headView.backgroundColor = UIColor.white
        return headView
    }()
    
    lazy var titleTextView: CBTextView = {
        let titleTextView = CBTextView.init(frame:  CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 20), width: kHaveLeftWidth, height: AutoGetHeight(height: 125)))
        titleTextView.aDelegate = self
        titleTextView.textView.backgroundColor = UIColor.white
        titleTextView.textView.font = UIFont.systemFont(ofSize: 15)
        titleTextView.textView.textColor = UIColor.black
        
        titleTextView.placeHolder = preStr
        titleTextView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        
        return titleTextView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.headView)
        self.headView.addSubview(self.titleTextView)

        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44))
        rightBtn.setTitle("完成", for: .normal)
        rightBtn.titleLabel?.font = kFontSize17
        rightBtn.setTitleColor(kBlueColor, for: .normal)
        rightBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: -7)
        rightBtn.addTarget(self, action: #selector(commitClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        
        let popButton = UIButton(frame:  CGRect(x: 0, y: 0, width: 60, height: 30))
        popButton.setTitle("取消", for: UIControlState.normal)
        popButton.addTarget(self, action: #selector(popVC), for: UIControlEvents.touchUpInside)
        popButton.titleLabel?.font = kFontSize17
        popButton.setTitleColor(kBlueColor, for: UIControlState.normal)
        popButton.sizeToFit()
        popButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: -7)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: popButton)
        
      
    }
    deinit {
       
    }

    @objc func popVC()  {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func commitClick()  {
        if titleTextView.textView.text.count==0 || titleTextView.textView.text==preStr{
            SVProgressHUD.showInfo(withStatus: "内容不可为空")
        }else{
            self.loadingPlay()
            if isFromBack == true{
                //回复
                self.submitBackRequest()
            }else{
                //留言
                 self.submitRemarkRequest()
            }
            
        }
        
    }
    //回复
    func submitBackRequest()  {
        let userID = STUserTool.account().userID
        let textStr = self.titleTextView.textView.text as String
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/personnelTask/saveChildComment" ,
            type: .post,
            param: ["createUserId":userID,
                    "partakeId":self.pataskId,
                    "content":textStr,
                    "commentId":backMod.circleCommentId!],
            successCallBack: { (result) in
                self.loadingSuccess()
                SVProgressHUD.showInfo(withStatus: "发布成功")
                let notification = NSNotification(name: NSNotification.Name(rawValue: "popToTaskDetail"), object: nil, userInfo: nil)
                NotificationCenter.default.post(notification as Notification)
        }) { (error) in
            self.loadingSuccess()
        }
    }
    
    
    //留言
    func submitRemarkRequest()  {
        let userID = STUserTool.account().userID
        let textStr = self.titleTextView.textView.text as String
        
            STNetworkTools.requestData(URLString:"\(baseUrl)/personnelTask/saveComment" ,
                type: .post,
                param: ["userId":userID,
                        "partakeId":self.pataskId,
                        "content":textStr],
                successCallBack: { (result) in
                    self.loadingSuccess()
                    SVProgressHUD.showInfo(withStatus: "发布成功")
                    let notification = NSNotification(name: NSNotification.Name(rawValue: "popToTaskDetail"), object: nil, userInfo: nil)
                    NotificationCenter.default.post(notification as Notification)
            }) { (error) in
                self.loadingSuccess()
            }
    }
}


extension QRPingLunVC:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
  
   
}

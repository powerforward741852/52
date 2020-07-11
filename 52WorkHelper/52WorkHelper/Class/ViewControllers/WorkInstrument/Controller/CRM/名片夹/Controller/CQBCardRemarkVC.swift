//
//  CQBCardRemarkVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2019/1/16.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class CQBCardRemarkVC: SuperVC {
    
    var isTypeMod = false
    var model : QRCardInfoModel?
    var cardId = ""
    var preStr = ""
    
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
        
        titleTextView.placeHolder = "请输入备注信息..."
        titleTextView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        
        return titleTextView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "备注"
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.headView)
        self.headView.addSubview(self.titleTextView)
        if !self.preStr.isEmpty{
            self.titleTextView.prevText = self.preStr
        }
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44))
        rightBtn.setTitle("完成", for: .normal)
        rightBtn.titleLabel?.font = kFontSize17
        rightBtn.setTitleColor(kBlueColor, for: .normal)
        rightBtn.addTarget(self, action: #selector(commitClick), for: .touchUpInside)
        
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }

    @objc func commitClick()  {
      //
        if titleTextView.textView.text.count==0{
            SVProgressHUD.showInfo(withStatus: "备注不可为空")
        }else{
            
            if isTypeMod == true{
                model?.remark = titleTextView.textView.text
                self.navigationController?.popViewController(animated: true)
            }else{
                self.loadingPlay()
                self.submitRemarkRequest()
            }

            
        }
        
    }
}

extension CQBCardRemarkVC{
    func submitRemarkRequest()  {
        let userID = STUserTool.account().userID
        
        var textStr = self.titleTextView.textView.text as String
        if textStr == self.titleTextView.placeHolder {
            textStr = ""
        }
        if textStr.count > 0 {
            STNetworkTools.requestData(URLString:"\(baseUrl)/crmBusinessCard/saveCardRemark" ,
                type: .post,
                param: ["emyeId":userID,
                        "cardId":self.cardId,
                        "remark":textStr],
                successCallBack: { (result) in
                    self.loadingSuccess()
                    SVProgressHUD.showInfo(withStatus: "已修改备注！")
                    self.navigationController?.popViewController(animated: true)
            }) { (error) in
                self.loadingSuccess()
            }
        }else{
            self.loadingSuccess()
            SVProgressHUD.showInfo(withStatus: "请输入内容")
        }
        
        
    }
}

extension CQBCardRemarkVC:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
}

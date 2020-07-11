//
//  CQHelpAndSuggustVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/14.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQHelpAndSuggustVC: SuperVC {

    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight-0-AutoGetHeight(height: 65)), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        table.backgroundColor = kProjectBgColor
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 236)))
        headView.backgroundColor = UIColor.white
        headView.layer.borderColor = kLineColor.cgColor
        headView.layer.borderWidth = 0.5
        return headView
    }()
    
    
    lazy var textView: CBTextView = {
        let textView = CBTextView.init(frame: CGRect.init(x: AutoGetWidth(width: 15), y: AutoGetWidth(width: 9), width: kWidth - AutoGetWidth(width: 30), height: AutoGetHeight(height: 170)))
        textView.aDelegate = self
        textView.textView.backgroundColor = UIColor.white
        textView.textView.font = UIFont.systemFont(ofSize: 15)
        textView.textView.textColor = UIColor.black
        
        textView.placeHolder = "请输入你的反馈意见和建议..."
        textView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        
        return textView
    }()
    
    lazy var countLab: UILabel = {
        let countLab = UILabel.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 120), y: self.headView.sd_height - AutoGetHeight(height: 30), width: AutoGetWidth(width: 105), height: AutoGetHeight(height: 11)))
        countLab.text = "还可以输入100字"
        countLab.textAlignment = .right
        countLab.textColor = UIColor.black
        countLab.font = kFontSize11
        return countLab
    }()
    
    lazy var footView: UIView = {
        let footView = UIView.init(frame: CGRect.init(x: 0, y: kHeight - AutoGetHeight(height: 65), width: kWidth, height: AutoGetHeight(height: 65)))
        footView.backgroundColor = kProjectBgColor
        return footView
    }()
    
    lazy var submitBtn: UIButton = {
        let submitBtn = UIButton.init(type: .custom)
        submitBtn.frame = CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 10), width: kHaveLeftWidth, height: AutoGetHeight(height: 45))
        submitBtn.setTitle("提 交", for: .normal)
        submitBtn.backgroundColor = kLightBlueColor
        submitBtn.setTitleColor(UIColor.white, for: .normal)
        submitBtn.layer.cornerRadius = 3
        submitBtn.addTarget(self, action: #selector(submitClick), for: .touchUpInside)
        return submitBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "意见反馈"
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.textView)
        self.headView.addSubview(self.countLab)
//        self.view.addSubview(self.footView)
//        self.footView.addSubview(self.submitBtn)
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 44))
        rightBtn.setTitle("提交", for: .normal)
        rightBtn.setTitleColor(UIColor.colorWithHexString(hex: "#20afff"), for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        rightBtn.addTarget(self, action: #selector(submitClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func submitClick()  {
        self.loadingPlay()
        self.submitAdviseRequest()
    }

}

extension CQHelpAndSuggustVC{
    func submitAdviseRequest()  {
        let userID = STUserTool.account().userID
        
        var textStr = self.textView.textView.text as String
        if textStr == self.textView.placeHolder {
            textStr = ""
        }
        if textStr.count > 0 {
            STNetworkTools.requestData(URLString:"\(baseUrl)/my/submitAdvise" ,
                type: .post,
                param: ["emyeId":userID,
                        "type":"1",
                        "adviseContent":textStr],
                successCallBack: { (result) in
                    self.loadingSuccess()
                    SVProgressHUD.showInfo(withStatus: "已收到您的反馈！")
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

extension CQHelpAndSuggustVC:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if self.textView.textView.text.isEmpty {
            
        }
        
        self.submitBtn.backgroundColor = kLightBlueColor
        self.submitBtn.isUserInteractionEnabled = true
        
        let count = 100 - textView.text.count
        let cStr:String = String(count)
        self.countLab.text = "还可以输入" + cStr + "字"
        if count < 0 {
            SVProgressHUD.showError(withStatus: "请控制字数在100字以内")
        }
        
        if textView.text.count > 100{
            var str = textView.text! as NSString
            str = str.substring(to: 100) as NSString
            textView.text = str as String
            self.countLab.text = "还可以输入0字"
        }
        
        if textView.text.count == 0 {
            self.submitBtn.isUserInteractionEnabled = false
            self.submitBtn.backgroundColor = kLyGrayColor
        }
    }
}

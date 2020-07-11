//
//  CQLeavingMessageVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/10.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQLeavingMessageVC: SuperVC {

    var schedulePlanId = ""
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.backgroundColor = kProjectBgColor
        table.separatorStyle = .none
        
        return table
    }()
    
    lazy var txtView: UIView = {
        let txtView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 150)))
        txtView.backgroundColor = UIColor.white
        return txtView
    }()
    
    lazy var textView: CBTextView = {
        let textView = CBTextView.init(frame: CGRect.init(x: AutoGetWidth(width: 15), y: AutoGetWidth(width: 18), width: kWidth - AutoGetWidth(width: 30), height: AutoGetHeight(height: 114)))
        textView.aDelegate = self
        textView.textView.backgroundColor = UIColor.white
        textView.textView.font = UIFont.systemFont(ofSize: 15)
        textView.textView.textColor = UIColor.black
        
        textView.placeHolder = "请输入内容，比如工作提醒..."
        textView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        
        return textView
    }()
    
    lazy var countLab: UILabel = {
        let countLab = UILabel.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 120), y: self.txtView.bottom + AutoGetHeight(height: 5), width: AutoGetWidth(width: 105), height: AutoGetHeight(height: 11)))
        countLab.text = "还可以输入120字"
        countLab.textAlignment = .right
        countLab.textColor = kLyGrayColor
        countLab.font = kFontSize11
        return countLab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "留言"
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.txtView
        self.txtView.addSubview(self.textView)
        self.table.addSubview(self.countLab)
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        rightBtn.setTitle("完成", for: .normal)
        rightBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        rightBtn.setTitleColor(UIColor.colorWithHexString(hex: "#20afff"), for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        rightBtn.addTarget(self, action: #selector(storeClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        
        
    }

    
    @objc func storeClick()  {
        addCommentRequest()
    }
        
}

//extension String{
//    subscript (r: Range<Int>) -> String {
//        get {
//            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
//            let endIndex =   self.index(self.startIndex, offsetBy: r.upperBound)
//            return String(self[Range(startIndex..<endIndex)])
//        }
//    }
//}

//extension String{
//    subscript (r: Range<Int>) -> String {
//        get {
//            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
//            let endIndex =   self.index(self.startIndex, offsetBy: r.upperBound)
//            return String(self[Range(startIndex..<endIndex)])
//        }
//    }
//}

extension CQLeavingMessageVC{
    func addCommentRequest()  {
        SVProgressHUD.show()
        var txt = self.textView.textView.text as String
        if txt == self.textView.placeHolder {
            txt = ""
        }
        
        if txt.count > 0 {
            let userID = STUserTool.account().userID
            STNetworkTools.requestData(URLString: "\(baseUrl)/schedule/saveScheduleComment",
                type: .post,
                param: ["userId":userID,
                        "schedulePlanId":self.schedulePlanId,
                        "commentContent":txt ],
                successCallBack: { (result) in
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showInfo(withStatus: "添加成功")
                    self.navigationController?.popViewController(animated: true)
            }) { (error) in
                SVProgressHUD.dismiss()
            }
        }else{
            SVProgressHUD.dismiss()
            SVProgressHUD.showInfo(withStatus: "请输入留言内容")
        }
    }
}
    
extension CQLeavingMessageVC:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        return true
    }
        
    func textViewDidChange(_ textView: UITextView) {
        
        let count = 120 - textView.text.count
        let cStr:String = String(count)
        self.countLab.text = "还可以输入" + cStr + "字"
        if count < 0 {
            SVProgressHUD.showError(withStatus: "请控制字数在120字以内")
        }
        
        if textView.text.count > 120{
            var str = textView.text! as NSString
            str = str.substring(to: 120) as NSString
            textView.text = str as String
            self.countLab.text = "还可以输入0字"
        }
    }
    
    
    
}

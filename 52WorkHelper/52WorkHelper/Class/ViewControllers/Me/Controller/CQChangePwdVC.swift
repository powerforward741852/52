//
//  CQChangePwdVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/4.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQChangePwdVC: SuperVC {

    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        table.backgroundColor = UIColor.colorWithHexString(hex: "#f7f7f7")
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight))
        return headView
    }()
    
    lazy var oldView: UIView = {
        let oldView = UIView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 55)))
        oldView.backgroundColor = UIColor.white
        return oldView
    }()
    
    lazy var pwdField: MyTextField = {
        let pwdField = MyTextField.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kWidth - 2 * kLeftDis, height: AutoGetHeight(height: 55)))
        pwdField?.delegate = self
        pwdField?.clearButtonMode = .never
        pwdField?.keyBoardDelegate = self
        pwdField?.font = kFontSize15
        pwdField?.textColor = UIColor.black
        pwdField?.tintColor = UIColor.black
        pwdField?.placeholder = "请输入旧密码"
        pwdField?.keyboardType = .default
        pwdField?.isSecureTextEntry = true
        
        return pwdField!
    }()
    
    lazy var newView: UIView = {
        let newView = UIView.init(frame: CGRect.init(x: 0, y:self.oldView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 110)))
        newView.backgroundColor = UIColor.white
        
        let lineView = UIView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 55), width: kWidth - kLeftDis, height: 0.5))
        lineView.backgroundColor = kLyGrayColor
        newView.addSubview(lineView)
        return newView
    }()
    
    lazy var newPwdField: MyTextField = {
        let newPwdField = MyTextField.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kWidth - 2 * kLeftDis, height: AutoGetHeight(height: 55)))
        newPwdField?.delegate = self
        newPwdField?.clearButtonMode = .never
        newPwdField?.keyBoardDelegate = self
        newPwdField?.font = kFontSize15
        newPwdField?.textColor = UIColor.black
        newPwdField?.tintColor = UIColor.black
        newPwdField?.placeholder = "请输入新密码"
        newPwdField?.keyboardType = .default
        newPwdField?.isSecureTextEntry = true
        
        return newPwdField!
    }()
    
    lazy var surePwdField: MyTextField = {
        let surePwdField = MyTextField.init(frame: CGRect.init(x: kLeftDis, y: self.newPwdField.bottom, width: kWidth - 2 * kLeftDis, height: AutoGetHeight(height: 55)))
        surePwdField?.delegate = self
        surePwdField?.clearButtonMode = .never
        surePwdField?.keyBoardDelegate = self
        surePwdField?.font = kFontSize15
        surePwdField?.textColor = UIColor.black
        surePwdField?.tintColor = UIColor.black
        surePwdField?.placeholder = "请确认新密码"
        surePwdField?.keyboardType = .default
        surePwdField?.isSecureTextEntry = true
        
        return surePwdField!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "修改密码"
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.oldView)
        self.oldView.addSubview(self.pwdField)
        self.headView.addSubview(self.newView)
        self.newView.addSubview(self.newPwdField)
        self.newView.addSubview(self.surePwdField)

        let rightItem = UIBarButtonItem.init(title: "完成", style: .done, target: self, action: #selector(changePwdClick))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func changePwdClick()  {
        
        
        if (self.pwdField.text?.isEmpty)! {
            SVProgressHUD.showInfo(withStatus: "请输入旧密码")
            return
        }else if (self.newPwdField.text?.isEmpty)! {
            SVProgressHUD.showInfo(withStatus: "请输入新密码")
            return
        }else if (self.surePwdField.text?.isEmpty)! {
            SVProgressHUD.showInfo(withStatus: "请确认新密码")
            return
        }
        
        
        if !(self.pwdField.text?.isEmpty)! && !(surePwdField.text?.isEmpty)! && surePwdField.text == newPwdField.text {
            // 数字判断
            guard let oldPwd = self.pwdField.text, oldPwd.count > 5,
                let newPwd = self.newPwdField.text, newPwd.count > 5,
                let certerPwd = self.surePwdField.text, certerPwd.count > 5  else {
                    SVProgressHUD.showInfo(withStatus: "密码必须大于六位数")
                    return
            }
            self.changePwdRequest()
        }else{
            SVProgressHUD.showInfo(withStatus: "两次输入的密码不一致")
        }
        
    }
}

extension CQChangePwdVC{
    fileprivate func changePwdRequest() {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/my/alterPassword",
            type: .post,
            param: ["emyeId":userID,
                    "newPassword":self.newPwdField.text ?? "",
                    "oldPassword":self.pwdField.text ?? ""],
            successCallBack: { (result) in
                SVProgressHUD.showInfo(withStatus: "修改成功")
                self.navigationController?.popViewController(animated: true)
        }) { (error) in
            
        }
    }
    
    
}

extension CQChangePwdVC:UITextFieldDelegate,KeyBoardDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    @objc func textFieldEditChanged(obj:Notification)  {
        
    }
    
    
}

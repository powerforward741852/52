//
//  CQSetPwdVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/2.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQSetPwdVC: SuperVC {

    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        table.backgroundColor = UIColor.colorWithHexString(hex: "#f7f7f7")
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 152)))
        return headView
    }()
    
    lazy var fieldBgView: UIView = {
        let fieldBgView = UIView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 7), width: kWidth, height: AutoGetHeight(height: 110)))
        fieldBgView.backgroundColor = UIColor.white
        
        
        return fieldBgView
    }()
    
    lazy var scanfNewPwdField: MyTextField = {
        let scanfNewPwdField = MyTextField.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 0) , width: kWidth - 2*kLeftDis , height: AutoGetHeight(height: 55)))
        scanfNewPwdField?.delegate = self
        scanfNewPwdField?.backgroundColor = UIColor.white
        scanfNewPwdField?.clearButtonMode = .never
        scanfNewPwdField?.keyBoardDelegate = self
        scanfNewPwdField?.font = kFontSize15
        scanfNewPwdField?.textColor = UIColor.black
        scanfNewPwdField?.tintColor = UIColor.black
        scanfNewPwdField?.placeholder = "请输入新密码"
        scanfNewPwdField?.keyboardType = .default
        scanfNewPwdField?.isSecureTextEntry = true
        return scanfNewPwdField!
    }()
    
    lazy var confirmNewPwdField: MyTextField = {
        let confirmNewPwdField = MyTextField.init(frame: CGRect.init(x: kLeftDis, y: self.scanfNewPwdField.bottom , width: kWidth - 2*kLeftDis, height: AutoGetHeight(height: 55)))
        confirmNewPwdField?.delegate = self
        confirmNewPwdField?.backgroundColor = UIColor.white
        confirmNewPwdField?.clearButtonMode = .never
        confirmNewPwdField?.keyBoardDelegate = self
        confirmNewPwdField?.font = kFontSize15
        confirmNewPwdField?.textColor = UIColor.black
        confirmNewPwdField?.tintColor = UIColor.black
        confirmNewPwdField?.placeholder = "请确认新密码"
        confirmNewPwdField?.keyboardType = .default
        confirmNewPwdField?.isSecureTextEntry = true
        return confirmNewPwdField!
    }()
    
    lazy var promptLab: UILabel = {
        let promptLab = UILabel.init(frame: CGRect.init(x: AutoGetWidth(width: 20), y: self.fieldBgView.bottom + AutoGetHeight(height: 12) , width: kWidth - AutoGetWidth(width: 40), height: AutoGetHeight(height: 11)))
        promptLab.textColor = kLyGrayColor
        promptLab.text = "* 密码不超过12位，不少于6个字符"
        promptLab.textAlignment = .left
        promptLab.font = kFontSize11
        return promptLab
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.table)
        
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.fieldBgView)
        self.fieldBgView.addSubview(self.scanfNewPwdField)
        self.fieldBgView.addSubview(self.confirmNewPwdField)
        self.headView.addSubview(self.promptLab)
        
        self.initLineView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEditChanged(obj:)), name: Notification.Name.UITextViewTextDidChange, object: nil)
    }
    
    func initLineView()  {
        let line1 = UIView.init(frame: CGRect.init(x: AutoGetWidth(width: 15), y: AutoGetHeight(height: 55) - 0.5, width: kWidth - AutoGetWidth(width: 15), height: 0.5))
        line1.backgroundColor = kLyGrayColor
        self.fieldBgView.addSubview(line1)
    }

}

extension CQSetPwdVC:UITextFieldDelegate,KeyBoardDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    @objc func textFieldEditChanged(obj:Notification)  {
        
    }
    
    
}

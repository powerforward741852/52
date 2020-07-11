//
//  CQForgetPwdVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/2.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQForgetPwdVC: SuperVC {

    var isCodeRight = false
    var verifyCode = ""
    
    lazy var navigateTitleLab: UILabel = {
        let navigateTitleLab = UILabel.init(frame: CGRect.init(x: 0, y: SafeAreaStateTopHeight, width: kWidth, height: 44))
        navigateTitleLab.textColor = UIColor.black
        navigateTitleLab.textAlignment = .center
        navigateTitleLab.font = kFontSize17
        return navigateTitleLab
    }()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: SafeAreaTopHeight, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        table.backgroundColor = UIColor.colorWithHexString(hex: "#f7f7f7")
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 123)))
        return headView
    }()
    
    lazy var fieldBgView: UIView = {
        let fieldBgView = UIView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 0), width: kWidth, height: AutoGetHeight(height: 55)))
        fieldBgView.backgroundColor = UIColor.white
        
        
        return fieldBgView
    }()
    
    lazy var telField: MyTextField = {
        let telField = MyTextField.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 0) , width: kWidth - 2*kLeftDis , height: AutoGetHeight(height: 55)))
        telField?.delegate = self
        telField?.backgroundColor = UIColor.white
        telField?.clearButtonMode = .never
        telField?.keyBoardDelegate = self
        telField?.font = kFontSize15
        telField?.textColor = UIColor.black
        telField?.tintColor = UIColor.black
        telField?.placeholder = "请输入手机号"
        telField?.keyboardType = .numberPad
        return telField!
    }()
    
    lazy var identityingCodeBgView: UIView = {
        let identityingCodeBgView = UIView.init(frame: CGRect.init(x: 0, y:self.fieldBgView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 55)))
        identityingCodeBgView.backgroundColor = UIColor.white
        
        
        return identityingCodeBgView
    }()
    
    lazy var codeField: MyTextField = {
        let codeField = MyTextField.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 0) , width: kWidth/3 * 2 , height: AutoGetHeight(height: 55)))
        codeField?.delegate = self
        codeField?.backgroundColor = UIColor.white
        codeField?.clearButtonMode = .never
        codeField?.keyBoardDelegate = self
        codeField?.font = kFontSize15
        codeField?.textColor = UIColor.black
        codeField?.tintColor = UIColor.black
        codeField?.placeholder = "请输入短信验证码"
        codeField?.keyboardType = .numberPad
        return codeField!
    }()
    
    lazy var getCodeBtn: CQCountDownBtn = {
        let getCodeBtn = CQCountDownBtn.init(frame:  CGRect.init(x: kWidth - AutoGetWidth(width: 115), y: 0, width: AutoGetWidth(width: 115), height: AutoGetHeight(height: 55)))
        getCodeBtn.setTitle("获取验证码", for: .normal)
        getCodeBtn.setTitleColor(kLightBlueColor, for: .normal)
        getCodeBtn.addTarget(self, action: #selector(getCodeAction), for: .touchUpInside)
        return getCodeBtn
    }()
    
    lazy var leftBtn: UIButton = {
        let leftBtn = UIButton.init(type: .custom)
        leftBtn.frame = CGRect.init(x: AutoGetWidth(width: 5), y: SafeAreaStateTopHeight+7, width: AutoGetWidth(width: 55), height: 30)
        leftBtn.setTitle("取消", for: .normal)
        leftBtn.setTitleColor(kLightBlueColor, for: .normal)
        leftBtn.addTarget(self, action: #selector(backToSuperView), for: .touchUpInside)
        leftBtn.titleLabel?.textAlignment = .left
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return leftBtn
    }()
    
    lazy var rightBtn: UIButton = {
        let rightBtn = UIButton.init(type: .custom)
        rightBtn.frame = CGRect.init(x:kWidth - AutoGetWidth(width: 60), y: SafeAreaStateTopHeight+7, width: AutoGetWidth(width: 55), height: 30)
        rightBtn.setTitle("下一步", for: .normal)
        rightBtn.setTitleColor(kLightBlueColor, for: .normal)
        rightBtn.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
        rightBtn.titleLabel?.textAlignment = .right
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return rightBtn
    }()
    
    
    lazy var setView: UIView = {
        let setView = UIView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 7), width: kWidth, height: AutoGetHeight(height: 110)))
        setView.backgroundColor = UIColor.white
        return setView
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
        let lineV = UIView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 55) - 0.5, width: kWidth - kLeftDis, height: 0.5))
        lineV.backgroundColor = kLineColor
        scanfNewPwdField?.addSubview(lineV)
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
        self.view.addSubview(self.navigateTitleLab)
        self.navigateTitleLab.text = "忘记密码"
        self.view.addSubview(self.table)
        
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.fieldBgView)
        self.fieldBgView.addSubview(self.telField)
        self.headView.addSubview(self.identityingCodeBgView)
        self.identityingCodeBgView.addSubview(self.codeField)
        self.identityingCodeBgView.addSubview(self.getCodeBtn)
        self.view.addSubview(self.leftBtn)
        self.view.addSubview(self.rightBtn)
        initLineView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEditChanged(obj:)), name: Notification.Name.UITextViewTextDidChange, object: nil)
    }

    func initLineView()  {
        let line1 = UIView.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 115) - 0.5, y: AutoGetHeight(height: 10) , width: 0.5, height: AutoGetHeight(height: 35)))
        line1.backgroundColor = kLyGrayColor
        self.identityingCodeBgView.addSubview(line1)
    }
    
    @objc func getCodeAction() {
        self.loadCodeData()
    }
    
    @objc func nextClick() {
        if self.verifyCode == self.codeField.text{
            self.isCodeRight = true
        }else{
            self.isCodeRight = false
        }
        self.view.endEditing(true)
        if self.rightBtn.titleLabel?.text == "下一步" {
            if !(self.telField.text?.isEmpty)! && !(self.codeField.text?.isEmpty)! && isCodeRight  {
                self.rightBtn.setTitle("完成", for: .normal)
                self.fieldBgView.isHidden = true
                self.identityingCodeBgView.isHidden = true
                self.headView.addSubview(self.setView)
                self.setView.addSubview(self.scanfNewPwdField)
                self.setView.addSubview(self.confirmNewPwdField)
                
            }else{
                if !isCodeRight{
                    SVProgressHUD.showInfo(withStatus: "验证码输入错误")
                }else{
                    SVProgressHUD.showInfo(withStatus: "请输入手机号及验证码")
                }
            }
        }else if self.rightBtn.titleLabel?.text == "完成"{
            if (self.scanfNewPwdField.text?.isEmpty)! {
                SVProgressHUD.showInfo(withStatus: "请输入新密码")
                return
            }else if (self.confirmNewPwdField.text?.isEmpty)! {
                SVProgressHUD.showInfo(withStatus: "请确认新密码")
                return
            }
            
            
            if !(self.scanfNewPwdField.text?.isEmpty)! && !(self.confirmNewPwdField.text?.isEmpty)! && self.scanfNewPwdField.text == self.confirmNewPwdField.text {
                // 数字判断
                guard let oldPwd = self.scanfNewPwdField.text, oldPwd.count > 5,
                    let newPwd = self.confirmNewPwdField.text, newPwd.count > 5 else {
                        SVProgressHUD.showInfo(withStatus: "密码必须大于六位数")
                        return
                }
                self.setPwdRequest()
            }else{
                SVProgressHUD.showInfo(withStatus: "两次输入的密码不一致")
            }
        }
        
        
    }
    
    override func backToSuperView() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension CQForgetPwdVC{
    func loadCodeData()  {
        
        if !(self.telField.text?.isEmpty)! {
            if self.cherkPhoneNum(num: self.telField.text!) {
                STNetworkTools.requestData(URLString: "\(baseUrl)/loginModule/getVerifyCode",
                    type: .get,
                    param: ["mobile":self.telField.text ?? ""],
                    successCallBack: { (result) in
                        self.verifyCode = result["data"]["verifyCode"].stringValue
                        
                        self.getCodeBtn.isEnabled = false
                        self.getCodeBtn.starCountDownWithSeconf(secondCount: 60)
                        self.getCodeBtn.countChanging(countChange: { (countBtn, second) -> (String) in
                            self.getCodeBtn.setTitleColor(kLyGrayColor, for: .normal)
                            return "\(second)秒"
                        })
                        
                        //结束
                        self.getCodeBtn.countFinish { (countBtn, sencond) -> (String) in
                            self.getCodeBtn.isEnabled = true
                            self.getCodeBtn.setTitleColor(kLightBlueColor, for: .normal)
                            return "重新获取"
                        }
                }) { (error) in
                    SVProgressHUD.showInfo(withStatus: "获取验证码失败,请稍后重试")
                }
            }else{
                SVProgressHUD.showInfo(withStatus: "请输入正确的手机号码")
            }
        }else{
            SVProgressHUD.showInfo(withStatus: "请输入手机号码")
        }
        
        
    }
    
    //设置手机号
    fileprivate func setPwdRequest() {
        STNetworkTools.requestData(URLString: "\(baseUrl)/loginModule/updateForgotPassword",
            type: .post,
            param: ["passWord":self.confirmNewPwdField.text ?? "",
                    "mobile":self.telField.text ?? "",
                    "verifyCode":self.codeField.text ?? ""],
            successCallBack: { (result) in
                SVProgressHUD.showInfo(withStatus: "设置成功")
                self.dismiss(animated: true, completion: nil)
        }) { (error) in
            
        }
    }
    
    /// 验证是否为手机
    ///
    /// - Parameter num: 输入的号码
    /// - Returns: 是否为手机bool值
    func cherkPhoneNum(num: String) -> Bool {
        do {
            let pattern = "^1[0-9]{10}$|^400[0-9]{7}$|^800[0-9]{7}$|0[0-9]{9,11}"
            let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: num, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, num.count))
            return matches.count > 0
        }
        catch {
            return false
        }
    }
}

extension CQForgetPwdVC:UITextFieldDelegate,KeyBoardDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    @objc func textFieldEditChanged(obj:Notification)  {
        
    }
    
    
}

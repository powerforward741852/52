//
//  LoginVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/4/28.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class LoginVC: SuperVC {

    var mainVC:MainTabbarController?
    
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
    
    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView.init(frame: CGRect.init(x: (kWidth - AutoGetWidth(width: 135))/2, y: AutoGetHeight(height: 145), width: AutoGetWidth(width: 135), height: AutoGetHeight(height: 36.5)))
        iconImg.image = UIImage.init(named: "loginLogo")
        return iconImg
    }()
    
    
    
    lazy var countLab: UILabel = {
        let countLab = UILabel.init(frame: CGRect.init(x: AutoGetWidth(width: 31), y: self.iconImg.bottom + AutoGetHeight(height: 16) + AutoGetHeight(height: 18) + AutoGetHeight(height: 35), width: AutoGetWidth(width: 65), height: AutoGetHeight(height: 55)))
        countLab.textColor = UIColor.black
        countLab.text = "账号"
        countLab.textAlignment = .center
        countLab.font = kFontSize15
        return countLab
    }()
    
    lazy var countField: MyTextField = {
        let countField = MyTextField.init(frame: CGRect.init(x: self.countLab.right, y: self.iconImg.bottom + AutoGetHeight(height: 16) + AutoGetHeight(height: 18) + AutoGetHeight(height: 35), width: kWidth - AutoGetWidth(width: 62) - AutoGetWidth(width: 65), height: AutoGetHeight(height: 55)))
        countField?.delegate = self
        countField?.clearButtonMode = .never
        countField?.keyBoardDelegate = self
        countField?.font = kFontSize15
        countField?.textColor = UIColor.black
        countField?.tintColor = UIColor.black
        countField?.placeholder = "请输入手机号"
        countField?.keyboardType = .numberPad
        
        return countField!
    }()
    
    lazy var pwdLab: UILabel = {
        let pwdLab = UILabel.init(frame: CGRect.init(x: AutoGetWidth(width: 31), y: self.countLab.bottom , width: AutoGetWidth(width: 65), height: AutoGetHeight(height: 55)))
        pwdLab.textColor = UIColor.black
        pwdLab.text = "密码"
        pwdLab.textAlignment = .center
        pwdLab.font = kFontSize15
        return pwdLab
    }()
    
    lazy var pwdField: MyTextField = {
        let pwdField = MyTextField.init(frame: CGRect.init(x: self.countLab.right, y: self.countLab.bottom , width: kWidth - AutoGetWidth(width: 62) - AutoGetWidth(width: 65), height: AutoGetHeight(height: 55)))
        pwdField?.delegate = self
        pwdField?.clearButtonMode = .never
        pwdField?.keyBoardDelegate = self
        pwdField?.font = kFontSize15
        pwdField?.textColor = UIColor.black
        pwdField?.tintColor = UIColor.black
        pwdField?.placeholder = "请输入密码"
        pwdField?.keyboardType = .default
        pwdField?.isSecureTextEntry = true
        
        return pwdField!
    }()
    
    lazy var forgetPwdBtn: UIButton = {
        let forgetPwdBtn = UIButton.init(type: .custom)
        forgetPwdBtn.frame = CGRect.init(x: kWidth - AutoGetWidth(width: 101), y: self.pwdField.bottom + AutoGetHeight(height: 13), width: AutoGetWidth(width: 71), height: AutoGetHeight(height: 12))
        forgetPwdBtn.setTitle("忘记密码？", for: .normal)
        forgetPwdBtn.setTitleColor(kColorRGB(r: 135, g: 200, b: 254), for: .normal)
        forgetPwdBtn.titleLabel?.font = kFontSize12
        forgetPwdBtn.addTarget(self, action: #selector(forgetAction), for: .touchUpInside)
        return forgetPwdBtn
    }()
    
    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton.init(type: .custom)
        loginBtn.frame = CGRect.init(x: AutoGetWidth(width: 31), y: self.forgetPwdBtn.bottom + AutoGetHeight(height: 20), width: kWidth - AutoGetWidth(width: 62), height: AutoGetHeight(height: 45))
        loginBtn.setTitle("登 录", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.backgroundColor = kColorRGB(r: 62, g: 172, b: 254)
        loginBtn.titleLabel?.font = kFontSize15
        loginBtn.layer.cornerRadius = 3.0
        loginBtn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        return loginBtn
    }()
    
    lazy var spaceV: UIView = {
        let spaceV = UIView.init()
        spaceV.frame = CGRect.init(x: 0, y: -SafeAreaTopHeight, width: kWidth, height: SafeAreaTopHeight)
        spaceV.backgroundColor = UIColor.white
        return spaceV
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ""
         self.view.addSubview(self.spaceV)
        self.view.addSubview(self.table)
        
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.iconImg)
        self.headView.addSubview(self.countLab)
        self.headView.addSubview(self.countField)
        self.headView.addSubview(self.pwdLab)
        self.headView.addSubview(self.pwdField)
        self.headView.addSubview(self.forgetPwdBtn)
        self.headView.addSubview(self.loginBtn)
        
        initLineView()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEditChanged(obj:)), name: Notification.Name.UITextViewTextDidChange, object: nil)
    }
    
    func initLineView() {
        let line1 = UIView.init(frame: CGRect.init(x: AutoGetWidth(width: 31), y: self.countField.bottom, width: kWidth - AutoGetWidth(width: 62), height: 0.5))
        line1.backgroundColor = kLyGrayColor
        self.headView.addSubview(line1)
        
        let line2 = UIView.init(frame: CGRect.init(x: AutoGetWidth(width: 31), y: self.pwdField.bottom, width: kWidth - AutoGetWidth(width: 62), height: 0.5))
        line2.backgroundColor = kLyGrayColor
        self.headView.addSubview(line2)
    }
    
    @objc func forgetAction()  {
        let vc = CQForgetPwdVC.init()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func loginAction()  {
        
        self.view.endEditing(true)
        // 数字判断
        guard let phoneNum = countField.text, phoneNum.count > 0,
            let password = pwdField.text, password.count > 5 else {
                SVProgressHUD.showInfo(withStatus: "请按要求输入账号与密码")
                return
        }
        let v:String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        //获取唯一设备标识
        let udid = HDeviceIdentifier.deviceIdentifier()!
        DLog(udid)
        //判断应用是第一次在这台手机上安装
        let isFirstInstall = HDeviceIdentifier.isFirstInstall()
        if isFirstInstall {
            DLog("本应用是第一次在这台手机上安装")
        }else{
            DLog("本应用不是第一次在这台手机上安装")
        }
        self.loadingPlay()
        let equipmentName:String = UIDevice.current.systemName 
        STNetworkTools.requestData(URLString: "\(baseUrl)/loginModule/login",
                                    type: .post,
                                    param: ["userName":phoneNum,
                                            "passWord":password,
                                            "version":v,
                                            "equipmentKey":udid,
                                            "equipmentName":equipmentName], successCallBack: { (result) in
                guard let loginUser = CQLoginUser(jsonData: result["data"]) else {
                    return
                }
                STUserTool.saveAccount(account: loginUser)
                
                self.storePublicMessage()
                
                if  UserDefaults.standard.value(forKey: "JPushRegisterId") != nil{
                    let registerId = UserDefaults.standard.value(forKey: "JPushRegisterId") as! String
                    self.updataJpushRegisterId(jPushRegistrationId: registerId)
                }
                
                UserDefaults.standard.set(true, forKey: "APPIsLogin")
                NotificationCenter.default.post(name: NSNotification.Name.init("rongCloudRequest"), object: nil)
                                                
//                let userID = STUserTool.account().userID
//                STNetworkTools.requestData(URLString:"\(baseUrl)/mailList/getToken" ,
//                type: .get,
//                param: ["userId":userID],
//                successCallBack: { (result) in
//
//
//
//
//
//                }) { (error) in
//
//                }
                self.loadingSuccess()
                                                let rootTabVC = MainTabbarController()
                                                rootTabVC.selectedIndex = 0
                                                UIApplication.shared.keyWindow?.rootViewController = rootTabVC
        }) { (error) in
            self.loadingSuccess()
        }
    }
    
    
    //更新用户极光推送id
    func updataJpushRegisterId(jPushRegistrationId:String) {
        let userId = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/loginModule/updateUserJPushRegistration" ,
            type: .post,
            param: ["jPushRegistrationId":jPushRegistrationId,
                    "userId":userId],
            successCallBack: { (result) in
                
                
        }) { (error) in
            
            
        }
    }
}

extension LoginVC{
    func storePublicMessage()  {

        
//        let noticeId:String = STUserTool.account().noticeUserId
//        if !noticeId.isEmpty {
//            let userInfo = RCUserInfo()
//            userInfo.userId = noticeId
//            userInfo.name = STUserTool.account().noticeUseName
//            userInfo.portraitUri =  STUserTool.account().noticeUserHeadImg
//            RCIM.shared().refreshUserInfoCache(userInfo, withUserId: noticeId)
//        }
        
    }
}

extension LoginVC:UITextFieldDelegate,KeyBoardDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    @objc func textFieldEditChanged(obj:Notification)  {
        
    }
    
    
}

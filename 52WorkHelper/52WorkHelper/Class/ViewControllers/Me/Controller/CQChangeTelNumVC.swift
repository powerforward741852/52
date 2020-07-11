//
//  CQChangeTelNumVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/4.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

private let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/account.archive"

class CQChangeTelNumVC: SuperVC {

    var rightItem:UIBarButtonItem?
    var isFirst = true
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y:0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        table.backgroundColor = UIColor.colorWithHexString(hex: "#f7f7f7")
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 0), width: kWidth, height: AutoGetHeight(height: 55)))
        headView.backgroundColor = UIColor.white
        return headView
    }()
    
    lazy var telField: MyTextField = {
        let telField = MyTextField.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kWidth - 2 * kLeftDis, height: AutoGetHeight(height: 55)))
        telField?.delegate = self
        telField?.clearButtonMode = .never
        telField?.keyBoardDelegate = self
        telField?.font = kFontSize15
        telField?.textColor = UIColor.black
        telField?.tintColor = UIColor.black
        telField?.placeholder = "请输入原来的手机号码"
        telField?.keyboardType = .numberPad
        
        return telField!
    }()
    
    lazy var changeView: UIView = {
        let changeView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 90)))
        changeView.backgroundColor = UIColor.white
        return changeView
    }()
    
    lazy var telView: UIView = {
        let telView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 35)))
        telView.backgroundColor = kColorRGB(r: 254, g: 249, b: 230)
        return telView
    }()
    
    lazy var telLab: UILabel = {
        let telLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kHaveLeftWidth, height: AutoGetHeight(height: 35)))
        telLab.font = kFontSize13
        
        telLab.textAlignment = .left
        telLab.textColor = UIColor.colorWithHexString(hex: "#f89800")
        return telLab
    }()
    
    lazy var codeField: MyTextField = {
        let codeField = MyTextField.init(frame: CGRect.init(x: kLeftDis, y: self.telView.bottom, width: kWidth - 2 * kLeftDis - AutoGetWidth(width: 122), height: AutoGetHeight(height: 55)))
        codeField?.delegate = self
        codeField?.clearButtonMode = .never
        codeField?.keyBoardDelegate = self
        codeField?.font = kFontSize15
        codeField?.textColor = UIColor.black
        codeField?.tintColor = UIColor.black
        codeField?.placeholder = "请输入短信验证码"
        codeField?.keyboardType = .numberPad
        
        return codeField!
    }()
    
    lazy var codeBtn: CQCountDownBtn = {
        let codeBtn = CQCountDownBtn.init(frame: CGRect.init(x: self.codeField.right , y: self.telView.bottom, width: AutoGetWidth(width: 122), height: AutoGetHeight(height: 55)))
        codeBtn.addTarget(self, action: #selector(getCode(sender:)), for: .touchUpInside)
        codeBtn.setTitleColor(kLyGrayColor, for: .normal)
        return codeBtn
    }()
    
    lazy var successView: UIView = {
        let successView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight))
        successView.backgroundColor = UIColor.white
        return successView
    }()
    
    lazy var successIconImg: UIImageView = {
        let successIconImg = UIImageView.init(frame: CGRect.init(x: (kWidth - AutoGetWidth(width: 65))/2, y: AutoGetHeight(height: 82), width: AutoGetWidth(width: 65), height: AutoGetHeight(height: 71.5)))
        successIconImg.image = UIImage.init(named: "PersonSuccess")
        return successIconImg
    }()
    
    lazy var successLab: UILabel = {
        let successLab = UILabel.init(frame: CGRect.init(x: 0, y: self.successIconImg.bottom + AutoGetHeight(height: 31), width: kWidth, height: AutoGetHeight(height: 19)))
        successLab.font = kFontBoldSize19
        successLab.text = "恭喜您，成功更换手机号"
        successLab.textAlignment = .center
        successLab.textColor = UIColor.black
        return successLab
    }()
    
    lazy var successBtn: UIButton = {
        let successBtn = UIButton.init(type: .custom)
        successBtn.frame = CGRect.init(x: (kWidth - AutoGetWidth(width: 310))/2, y: self.successLab.bottom + AutoGetHeight(height: 72), width: AutoGetWidth(width: 310), height: AutoGetHeight(height: 45))
        successBtn.backgroundColor = kColorRGB(r: 62, g: 172, b: 254)
        successBtn.setTitle("确 定", for: .normal)
        successBtn.setTitleColor(UIColor.white, for: .normal)
        successBtn.addTarget(self, action: #selector(successClick), for: .touchUpInside)
        return successBtn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "更换手机号码"
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.telField)

        self.rightItem  = UIBarButtonItem.init(title: "下一步", style: UIBarButtonItemStyle.done, target: self, action: #selector(netStepClick))
        self.navigationItem.rightBarButtonItem = rightItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEditChanged(obj:)), name: Notification.Name.UITextViewTextDidChange, object: nil)
    }
    
    @objc func netStepClick()  {
        if self.rightItem?.title == "下一步" {
            if self.isFirst{
                guard let phoneNum = self.telField.text else {
                    return
                }
                if cherkPhoneNum(num: phoneNum) {
                    self.checkOldPhone()
                }else{
                    SVProgressHUD.showInfo(withStatus: "请输入正确手机号")
                }
            }else{
                guard let phoneNum = self.telField.text else {
                    return
                }
                if cherkPhoneNum(num: phoneNum) {
                    self.loadCodeData()
                }else{
                    SVProgressHUD.showInfo(withStatus: "请输入正确手机号")
                }
            }
            
            
        }else if self.rightItem?.title == "完成"{
            if self.codeField.text!.count > 0 {
                self.changeTelRequest()
            }
            
        }
        
        
    }
    
    @objc func successClick()  {
//        self.navigationController?.popViewController(animated: true)
        self.loginOutRequest()
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
    
    @objc func getCode(sender:CQCountDownBtn)  {
        self.loadCodeData()
    }
}

// Mark:changeTel
//FIXME:修改我  这里应该要刷新我的界面
extension CQChangeTelNumVC{
    func changeTelRequest()  {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/my/alterPhone",
            type: .get,
            param: ["emyeId":userID,
                    "newPhone":self.telField.text ?? "",
                    "verifyCode":self.codeField.text ?? ""],
            successCallBack: { (result) in
                self.changeView.isHidden = true
                self.rightItem?.title = ""
                self.rightItem?.isEnabled = false
                self.table.tableHeaderView = self.successView
                self.successView.addSubview(self.successIconImg)
                self.successView.addSubview(self.successLab)
                self.successView.addSubview(self.successBtn)
                UserDefaults.standard.set(self.telField.text, forKey: "userName")
                NotificationCenter.default.post(name: NSNotification.Name.init("changelNumBerInSettingCell"), object: nil)
        }) { (error) in
            
        }
    }
    
    func checkOldPhone() {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/my/checkOldPhone",
            type: .post,
            param: ["emyeId":userID,
                    "phone":self.telField.text ?? ""],
            successCallBack: { (result) in
                self.telField.text = ""
                self.telField.placeholder = "请输入新手机号码"
                self.isFirst = false
        }) { (error) in
            
        }
    }
    
    func loginOutRequest()  {
        STNetworkTools.requestData(URLString: "\(baseUrl)/loginModule/logout",
            type: .post,
            param: ["userId":STUserTool.account().userID],
            successCallBack: { (result) in
                
                if result["success"].boolValue {
                    
                    let bool = FileManager.default.fileExists(atPath: path)
                    if bool {
                        do {
                            // 删除路径下存储的数据，做了错误处理，运用do-catch处理，不太理解do-catch的我的文章中有
                            try FileManager.default.removeItem(atPath: path)
                            // 下边两行代码是界面转换和一些数据的处理  可以根据自己的需求来做
                            UserDefaults.standard.set("default", forKey: "userStatus")
                            SVProgressHUD.showSuccess(withStatus: "退出成功")
                            //设置为未登陆
                            UserDefaults.standard.set(false, forKey: "APPIsLogin")
                            UserDefaults.standard.set(false, forKey: "isShowBirthday")
                            WHC_ModelSqlite.removeModel(QRSection.self)
                            let vc = LoginVC()
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                        }catch {
                            SVProgressHUD.showInfo(withStatus: "退出失败")
                        }
                    }
                }
        }) { (error) in
            SVProgressHUD.showInfo(withStatus: "退出登录失败,请重试")
        }
    }
}

extension CQChangeTelNumVC{
    func loadCodeData()  {
        STNetworkTools.requestData(URLString: "\(baseUrl)/loginModule/getVerifyCode",
            type: .get,
            param: ["mobile":self.telField.text ?? ""],
            successCallBack: { (result) in
                self.headView.isHidden = true
                self.rightItem?.title = "完成"
                self.table.tableHeaderView = self.changeView
                self.changeView.addSubview(self.telView)
                self.telView.addSubview(self.telLab)
                self.telLab.text = "验证码短信已发送至手机" + self.telField.text!
                self.changeView.addSubview(self.codeField)
                self.changeView.addSubview(self.codeBtn)
                self.codeBtn.isEnabled = false
                self.codeBtn.starCountDownWithSeconf(secondCount: 60)
                self.codeBtn.countChanging(countChange: { (countBtn, second) -> (String) in
                    countBtn.setTitleColor(kLyGrayColor, for: .normal)
                    return "\(second)秒"
                })
                
                //结束
                self.codeBtn.countFinish { (countBtn, sencond) -> (String) in
                    countBtn.isEnabled = true
                    countBtn.setTitleColor(kLightBlueColor, for: .normal)
                    return "重新获取"
                }
        }) { (error) in
            SVProgressHUD.showInfo(withStatus: "获取验证码失败,请稍后重试")
        }
    }
}

extension CQChangeTelNumVC:UITextFieldDelegate,KeyBoardDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    @objc func textFieldEditChanged(obj:Notification)  {
        
    }
    
    
}

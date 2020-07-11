//
//  CQSetVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/3.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

private let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/account.archive"

class CQSetVC: SuperVC {

    var nameArr = [[String]]()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.backgroundColor = kProjectBgColor
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    lazy var footView: UIView = {
        let footView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 55)))
        footView.backgroundColor = UIColor.white
        return footView
    }()
    
    lazy var loginOutBtn: UIButton = {
        let loginOutBtn = UIButton.init(type: .custom)
        loginOutBtn.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 55))
        loginOutBtn.setTitle("退出登录", for: .normal)
        loginOutBtn.setTitleColor(UIColor.colorWithHexString(hex: "#f82222"), for: .normal)
        loginOutBtn.addTarget(self, action: #selector(loginOutAction), for: .touchUpInside)
        return loginOutBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameArr = [["更换手机号码","修改密码"],
                        ["关于52助手","检查更新"]]
//        self.nameArr = [["更换手机号码","修改密码"],
//                        ["关于52助手"]]
        
        self.title = "设置"
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CQSetFooter")
        self.table.tableFooterView = self.footView
        self.footView.addSubview(self.loginOutBtn)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeHeaderNum(notification:)), name: NSNotification.Name(rawValue: "changelNumBerInSettingCell"), object: nil)
    }
    
    @objc func changeHeaderNum(notification:Notification)  {
        self.table.reloadData()
    }

    @objc func loginOutAction()  {
        self.loginOutRequest()
    }
}

extension CQSetVC{
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
                            //设置为未显示生日
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

extension CQSetVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.nameArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nameArr[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = nil
        
        if cell == nil{
            cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier:"CQSetCellId")
        }
        cell?.textLabel?.text = self.nameArr[indexPath.section][indexPath.row]
        
        cell?.accessoryType = .disclosureIndicator
        
        if 0 == indexPath.row && 0 == indexPath.section{
            cell?.detailTextLabel?.text = STUserTool.account().userName
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if 0 == indexPath.section && 0 == indexPath.row{
            let vc = CQChangeTelNumVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if 0 == indexPath.section && 1 == indexPath.row {
            let vc = CQChangePwdVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if 1 == indexPath.section && 0 == indexPath.row{
            let vc = CQAboutWorkHelperVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if 1 == indexPath.section && 1 == indexPath.row{
            //检查更新
            let urlString = "https://itunes.apple.com/app/id1461729715"
            let url = URL(string: urlString)
            UIApplication.shared.openURL(url!)
        //    SVProgressHUD.showInfo(withStatus: "当前为最新版本")
//            loadCurrentVersion()
        }
        
        //http://itunes.apple.com/cn/lookup?id1461729715
    }
    //https://itunes.apple.com/cn/lookup?id=1461729715
    
//        func loadCurrentVersion()  {
//            PgyUpdateManager.sharedPgy()?.checkUpdate(withDelegete: self, selector: #selector(self.updateMethod(dic: )))
//        }
//    
//       @objc func updateMethod(dic:NSDictionary)  {
//            SVProgressHUD.dismiss()
//        if dic.value(forKey: "version") != nil{
//             
//                    let v = CQVersionView.init( title: "", message: "", urlStr: dic.value(forKey: "appUrl") as! String)
//                    v.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
//                    let app = UIApplication.shared.delegate as! AppDelegate
//                    v.vDelegate = self
//                    app.window?.addSubview(v)
//            }else{
//                SVProgressHUD.showInfo(withStatus: "当前为最新版本")
//            }
//        }
//    
    
    
    
//    func loadCurrentVersion()  {      STNetworkTools.requestData(URLString:"\(baseUrl)/loginModule/getAppSystemConfig" ,
//            type: .get,
//            param: nil,
//            successCallBack: { (result) in
//                SVProgressHUD.dismiss()
//                let currentVersion = result["data"]["currentVersion"].stringValue
//                let currentUrl = result["data"]["currentUrl"].stringValue
//                if currentVersion.compare(CQVersion) == .orderedDescending{
//                    let v = CQVersionView.init( title: "", message: "", urlStr: currentUrl)
//                    v.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
//                    let app = UIApplication.shared.delegate as! AppDelegate
//                    v.vDelegate = self
//                    app.window?.addSubview(v)
//                }else{
//                    SVProgressHUD.showInfo(withStatus: "当前为最新版本")
//                }
//
//        }) { (error) in
//                SVProgressHUD.dismiss()
//        }
//    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return AutoGetHeight(height: 55)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return AutoGetHeight(height: 13)
        }
        return AutoGetHeight(height: 32)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        
        footer.backgroundColor = kProjectBgColor
        
        return footer
    }
    
}
extension CQSetVC:CQVersionUpdataClickDelegate{
    func versionUpdataAction(url: String) {
        UIApplication.shared.openURL(URL.init(string:url)!)
    }
}

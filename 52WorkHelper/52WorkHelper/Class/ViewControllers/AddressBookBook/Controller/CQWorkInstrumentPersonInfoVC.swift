//
//  CQWorkInstrumentPersonInfoVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/14.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit
import MessageUI
class CQWorkInstrumentPersonInfoVC: SuperVC {

    var userId = ""
    var chatName = ""
    var titleArr = [String]()
    var subTitleArr = [String]()
    var model:CQPersonInfoMationModel?
    var userModel:CQDepartMentUserListModel?
    var isFromAdress = false
    var cardUrl = ""
    var dModel:CQDepartMentUserListModel?
    var imageArr = [String]()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: self.bgImg.tz_bottom, width: kWidth, height: kHeight-self.bgImg.tz_height-CGFloat(SafeAreaBottomHeight)   ), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        
        table.delegate = self
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.dataSource = self
        return table
    }()
    
    lazy var bgImg: UIImageView = {
        
        let bgImg = UIImageView.init(frame: CGRect.init(x: 0, y:0, width: kWidth, height:44 + AutoGetHeight(height: 167) + CGFloat(SafeAreaStateTopHeight)))
        bgImg.image = UIImage.init(named: "bgForPerson")
        bgImg.isUserInteractionEnabled = true
        
        let btn =  UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 15, y: SafeAreaStateTopHeight-5, width: 60, height: 44)
        btn.setTitle(" 返回", for: .normal)
        btn.setImage(UIImage.init(named: "back_white_icon"), for: .normal)
        btn.addTarget(self, action: #selector(backToSuperView), for: .touchUpInside)
        bgImg.addSubview(btn)
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: Int(kWidth - 60), y: Int(SafeAreaStateTopHeight-5), width: 60, height: 44))
        rightBtn.addTarget(self, action: #selector(shareClick), for: .touchUpInside)
        rightBtn.setImage(UIImage.init(named: "personShareBtn"), for: .normal)
        bgImg.addSubview(rightBtn)
        
        let titleLab = UILabel.init(frame: CGRect.init(x: 0, y: Int(SafeAreaStateTopHeight-5), width: Int(kWidth), height: 44))
        titleLab.font = kFontSize17
        titleLab.text = "个人资料"
        titleLab.textColor = UIColor.white
        titleLab.textAlignment = .center
        bgImg.addSubview(titleLab)
        
        let iconImg = UIImageView.init(frame: CGRect.init(x: AutoGetWidth(width: 23), y: AutoGetHeight(height: 47.5) + 44, width: AutoGetWidth(width: 72), height: AutoGetWidth(width: 72)))
        iconImg.sd_setImage(with: URL(string: model?.headImage ?? ""), placeholderImage:UIImage.init(named: "personDefaultIcon") )
        iconImg.layer.cornerRadius = AutoGetWidth(width: 36)
        iconImg.clipsToBounds = true
        bgImg.addSubview(iconImg)
        let messageView = UIView(frame:  CGRect(x: iconImg.tz_right, y:iconImg.tz_top + AutoGetHeight(height: 9) , width: 230, height: AutoGetHeight(height: 54)))
        bgImg.addSubview(messageView)
        
        
        let width = self.getTexWidth(textStr: (self.model?.realName)!, font: kFontBoldSize24, height: AutoGetHeight(height: 28))
        let nameLab = UILabel.init(frame: CGRect.init(x:  AutoGetWidth(width: 14), y: 0, width: width, height: AutoGetHeight(height: 28)))
        nameLab.font = kFontBoldSize24
        nameLab.text = self.model?.realName
        nameLab.textColor = UIColor.white
        nameLab.textAlignment = .left
        messageView.addSubview(nameLab)
        
        let sexImg = UIImageView.init(frame: CGRect.init(x: nameLab.right + AutoGetWidth(width: 9), y: 0, width: AutoGetWidth(width: 16), height: AutoGetWidth(width: 16)))
        if self.model?.employeeSex == "1" {
            sexImg.image = UIImage.init(named: "PersonSex")
        }else{
            sexImg.image = UIImage.init(named: "girl")
        }
        messageView.addSubview(sexImg)
        
        let jobLab = UILabel.init(frame: CGRect.init(x:  AutoGetWidth(width: 14), y: nameLab.bottom + AutoGetHeight(height: 9), width: AutoGetWidth(width: 210), height: AutoGetHeight(height: 14)))
        jobLab.font = kFontSize14
        jobLab.text = model?.positionName
        jobLab.textColor = UIColor.white
        jobLab.textAlignment = .left
        messageView.addSubview(jobLab)
        return bgImg
    }()
    
    lazy var footView: UIView = {
        let footView = UIView.init(frame: CGRect.init(x: 0, y: kHeight-AutoGetHeight(height: 65)-CGFloat(SafeAreaBottomHeight) , width: kWidth, height: AutoGetHeight(height: 65)))
        return footView
    }()
    
    lazy var sendMessageBtn: UIButton = {
        let sendMessageBtn = UIButton.init(type: .custom)
        sendMessageBtn.frame = CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 10), width: kHaveLeftWidth, height: AutoGetHeight(height: 45))
        sendMessageBtn.setTitle("发消息", for: .normal)
        sendMessageBtn.backgroundColor = kLightBlueColor
        sendMessageBtn.setTitleColor(UIColor.white, for: .normal)
        sendMessageBtn.layer.cornerRadius = 3
        sendMessageBtn.addTarget(self, action: #selector(sendClick), for: .touchUpInside)
        return sendMessageBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.titleArr = ["直线:    ","手机:    ","邮箱:    "]
        
        self.imageArr = ["CQWorkInstrumentTel","PersonInfoTel","emailIcon"]
        self.loadData()
        
        self.title = "个人资料"
        self.view.backgroundColor = UIColor.white
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        rightBtn.setImage(UIImage.init(named: "CQWorkInstrumentShare"), for: .normal)
        rightBtn.addTarget(self, action: #selector(shareClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func initView()  {
        
        self.view.addSubview(self.bgImg)
        self.view.addSubview(self.table)
        self.view.addSubview(self.footView)
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "CQWorkInstrumentPersonInfoCell")
        self.table.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CQPersonInfoHeader")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.shared.statusBarStyle = .lightContent
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func setStatusBarBackgroundColor(color : UIColor) {
        let statusBarWindow : UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
        let statusBar : UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
      
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = color
        }
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
//        UIApplication.shared.statusBarStyle = .default
//         self.setStatusBarBackgroundColor(color: UIColor.clear)
        UIApplication.shared.statusBarStyle = .default
        
    }
    
    
    
    @objc func shareClick()  {
        self.initShareView()
    }
    
   @objc func messageClick()  {
        let recipient = model?.userName
        if MFMessageComposeViewController.canSendText() {
            let vc = MFMessageComposeViewController()
            //设置短信内容
            //                vc.body = "短信内容：欢迎来到hangge.com"
            //设置收件人列表
            vc.recipients = [recipient] as? [String]
            //设置代理
            vc.messageComposeDelegate = self
            //打开界面
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }else{
            SVProgressHUD.showInfo(withStatus: "本设备无法发送短信")
        }
    }
    
    @objc func btnClick(sender:UIButton)  {
        
    }
    
    func initShareView()  {
        let shareV = CQShareView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - CGFloat(SafeAreaBottomHeight)))
        shareV.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
        shareV.cqShareDelegate = self
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.addSubview(shareV)
    }
    
    @objc func sendClick()  {
        let uData = UserDefaults.standard.object(forKey: "userArray")
        if !self.isFromAdress {
            if uData != nil {
                var uArr:[CQDepartMentUserListModel] = NSKeyedUnarchiver.unarchiveObject(with: uData as! Data) as! [CQDepartMentUserListModel]
                var idArr = [String]()
                for i in 0..<uArr.count{
                    let model = uArr[i]
                    idArr.append(model.userId)
                }
                
                let hasNum = idArr.contains((self.userModel?.userId)!)
                if !hasNum {
                    uArr.append(self.userModel!)
                    let data = NSKeyedArchiver.archivedData(withRootObject: uArr)
                    UserDefaults.standard.set(data, forKey: "userArray")
                }
                
                for i in 0..<idArr.count{
                    if self.userModel?.userId == idArr[i]{
                        uArr[i] = self.userModel!
                        let data = NSKeyedArchiver.archivedData(withRootObject: uArr)
                        UserDefaults.standard.set(data, forKey: "userArray")
                    }
                }
            }else{
                var userArr = [CQDepartMentUserListModel]()
                userArr.append(self.userModel!)
                let data = NSKeyedArchiver.archivedData(withRootObject: userArr)
                UserDefaults.standard.set(data, forKey: "userArray")
            }
        }else{
            var uArr:[CQDepartMentUserListModel] = NSKeyedUnarchiver.unarchiveObject(with: uData as! Data) as! [CQDepartMentUserListModel]
            var idArr = [String]()
            for i in 0..<uArr.count{
                let model = uArr[i]
                idArr.append(model.userId)
            }
            
           
            for i in 0..<idArr.count{
                if self.userModel?.userId == idArr[i]{
                    uArr[i] = self.dModel!
                    self.dModel?.userId = self.userId
                    let data = NSKeyedArchiver.archivedData(withRootObject: uArr)
                    UserDefaults.standard.set(data, forKey: "userArray")
                }
            }
        }
        
        
    
    }
    
}

extension CQWorkInstrumentPersonInfoVC{
    //数据加载
    func loadData()  {
        if self.userId.isEmpty {
            self.userId = STUserTool.account().userID
        }
        STNetworkTools.requestData(URLString:"\(baseUrl)/mailList/getPersonDetails" ,
            type: .get,
            param: ["userId":self.userId],
            successCallBack: { (result) in
            
            guard let model = CQPersonInfoMationModel.init(jsonData: result["data"]) else {
                    return
            }
                
            guard let dModel = CQDepartMentUserListModel.init(jsonData: result["data"]) else {
                return
            }
            self.dModel = dModel
                
            self.cardUrl = "\(baseUrl)/my/businessCard" + "?emyeId=" + self.userId + "&type=my"
            self.model = model
            self.initView()
            
            self.table.reloadData()
        }) { (error) in
            
        }
    }
    
   
}
    
extension CQWorkInstrumentPersonInfoVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = nil
        
        if cell == nil{
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier:"CQWorkInstrumentPersonInfoCellId")
        }
        cell?.imageView?.image = UIImage.init(named: self.imageArr[indexPath.row])
        cell?.textLabel?.textColor = kLyGrayColor
        cell?.textLabel?.font = kFontSize15
        
        
        
        if 0 == indexPath.row {
            var string = ""
            if !(model?.phoneNumber.isEmpty)!{
                string = self.titleArr[indexPath.row] + (model?.phoneNumber)!
                let ranStr = self.titleArr[indexPath.row]
                let attrstring:NSMutableAttributedString = NSMutableAttributedString.init(string: string)
                let str = NSString.init(string: string)
                let theRange = str.range(of: ranStr)
                attrstring.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: theRange)
                cell?.textLabel?.attributedText = attrstring
            }
            
            
        }else if 1 == indexPath.row {
            if !(model?.userName.isEmpty)!{
                let string = self.titleArr[indexPath.row] + (model?.userName)!
                let ranStr = self.titleArr[indexPath.row]
                let attrstring:NSMutableAttributedString = NSMutableAttributedString.init(string: string)
                let str = NSString.init(string: string)
                let theRange = str.range(of: ranStr)
                attrstring.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: theRange)
                cell?.textLabel?.attributedText = attrstring
                
                let btn = UIButton.init(type: .custom)
                btn.frame = CGRect.init(x: kWidth - AutoGetWidth(width: 87), y: AutoGetHeight(height: 4), width: AutoGetWidth(width: 87), height: AutoGetHeight(height: 47))
                btn.setImage(UIImage.init(named: "sendMessageBtn"), for: .normal)
                btn.addTarget(self, action: #selector(messageClick), for: .touchUpInside)
                cell?.addSubview(btn)
            }
            
            
        }else if 2 == indexPath.row {
            if !(model?.eMail.isEmpty)!{
                let string = self.titleArr[indexPath.row] + (model?.eMail)!
                let ranStr = self.titleArr[indexPath.row]
                let attrstring:NSMutableAttributedString = NSMutableAttributedString.init(string: string)
                let str = NSString.init(string: string)
                let theRange = str.range(of: ranStr)
                attrstring.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: theRange)
                cell?.textLabel?.attributedText = attrstring
            }
        }
        
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if 0 == indexPath.row {
            //自动打开拨号页面并自动拨打电话
            if  !(model?.phoneNumber.isEmpty)!{
                let urlString = "tel://" + (model?.phoneNumber)!
                if let url = URL(string: urlString) {
                    //根据iOS系统版本，分别处理
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url, options: [:],
                                                  completionHandler: {
                                                    (success) in
                                                    let uData = UserDefaults.standard.object(forKey: "userArray")
                                                    if !self.isFromAdress {
                                                        if uData != nil {
                                                            var uArr:[CQDepartMentUserListModel] = NSKeyedUnarchiver.unarchiveObject(with: uData as! Data) as! [CQDepartMentUserListModel]

                                                            var idArr = [String]()
                                                            for i in 0..<uArr.count{
                                                                let model = uArr[i]
                                                                idArr.append(model.userId)
                                                            }

                                                            let hasNum = idArr.contains((self.userModel?.userId)!)
                                                            if !hasNum {
                                                                uArr.append(self.userModel!)
                                                                let data = NSKeyedArchiver.archivedData(withRootObject: uArr)
                                                                UserDefaults.standard.set(data, forKey: "userArray")
                                                            }

                                                            for i in 0..<idArr.count{
                                                                if self.userModel?.userId == idArr[i]{
                                                                    uArr[i] = self.userModel!
                                                                    let data = NSKeyedArchiver.archivedData(withRootObject: uArr)
                                                                    UserDefaults.standard.set(data, forKey: "userArray")
                                                                }
                                                            }
                                                        }else{
                                                            var userArr = [CQDepartMentUserListModel]()
                                                            userArr.append(self.userModel!)
                                                            let data = NSKeyedArchiver.archivedData(withRootObject: userArr)
                                                            UserDefaults.standard.set(data, forKey: "userArray")
                                                        }
                                                    }else{
                                                        var uArr:[CQDepartMentUserListModel] = NSKeyedUnarchiver.unarchiveObject(with: uData as! Data) as! [CQDepartMentUserListModel]
                                                        var idArr = [String]()
                                                        for i in 0..<uArr.count{
                                                            let model = uArr[i]
                                                            idArr.append(model.userId)
                                                        }


                                                        for i in 0..<idArr.count{
                                                            if self.userModel?.userId == idArr[i]{
                                                                uArr[i] = self.dModel!
                                                                self.dModel?.userId = self.userId
                                                                let data = NSKeyedArchiver.archivedData(withRootObject: uArr)
                                                                UserDefaults.standard.set(data, forKey: "userArray")
                                                            }
                                                        }
                                                    }
                        })
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            
            
        }else if 1 == indexPath.row{
            //自动打开拨号页面并自动拨打电话
            if !(model?.userName.isEmpty)!{
                let urlString = "tel://" + (model?.userName)!
                if let url = URL(string: urlString) {
                    //根据iOS系统版本，分别处理
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url, options: [:],
                                                  completionHandler: {
                                                    (success) in
                                                    let uData = UserDefaults.standard.object(forKey: "userArray")
                                                    if !self.isFromAdress {
                                                        if uData != nil {
                                                            var uArr:[CQDepartMentUserListModel] = NSKeyedUnarchiver.unarchiveObject(with: uData as! Data) as! [CQDepartMentUserListModel]

                                                            var idArr = [String]()
                                                            for i in 0..<uArr.count{
                                                                let model = uArr[i]
                                                                idArr.append(model.userId)
                                                            }

                                                            let hasNum = idArr.contains((self.userModel?.userId)!)
                                                            if !hasNum {
                                                                uArr.append(self.userModel!)
                                                                let data = NSKeyedArchiver.archivedData(withRootObject: uArr)
                                                                UserDefaults.standard.set(data, forKey: "userArray")
                                                            }

                                                            for i in 0..<idArr.count{
                                                                if self.userModel?.userId == idArr[i]{
                                                                    uArr[i] = self.userModel!
                                                                    let data = NSKeyedArchiver.archivedData(withRootObject: uArr)
                                                                    UserDefaults.standard.set(data, forKey: "userArray")
                                                                }
                                                            }
                                                        }else{
                                                            var userArr = [CQDepartMentUserListModel]()
                                                            userArr.append(self.userModel!)
                                                            let data = NSKeyedArchiver.archivedData(withRootObject: userArr)
                                                            UserDefaults.standard.set(data, forKey: "userArray")
                                                        }
                                                    }else{
                                                        var uArr:[CQDepartMentUserListModel] = NSKeyedUnarchiver.unarchiveObject(with: uData as! Data) as! [CQDepartMentUserListModel]
                                                        var idArr = [String]()
                                                        for i in 0..<uArr.count{
                                                            let model = uArr[i]
                                                            idArr.append(model.userId)
                                                        }


                                                        for i in 0..<idArr.count{
                                                            if self.userModel?.userId == idArr[i]{
                                                                uArr[i] = self.dModel!
                                                                self.dModel?.userId = self.userId
                                                                let data = NSKeyedArchiver.archivedData(withRootObject: uArr)
                                                                UserDefaults.standard.set(data, forKey: "userArray")
                                                            }
                                                        }
                                                    }
                        })
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoGetHeight(height: 55)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = UIView()
//
//        header.backgroundColor = UIColor.white
//
//
//
//        return header
//    }
    
    
}

//Mark 短信代理
extension CQWorkInstrumentPersonInfoVC:MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        let uData = UserDefaults.standard.object(forKey: "userArray")
        if !self.isFromAdress {
            if uData != nil {
                var uArr:[CQDepartMentUserListModel] = NSKeyedUnarchiver.unarchiveObject(with: uData as! Data) as! [CQDepartMentUserListModel]
                var idArr = [String]()
                for i in 0..<uArr.count{
                    let model = uArr[i]
                    idArr.append(model.userId)
                }
                
                let hasNum = idArr.contains((self.userModel?.userId)!)
                if !hasNum {
                    uArr.append(self.userModel!)
                    let data = NSKeyedArchiver.archivedData(withRootObject: uArr)
                    UserDefaults.standard.set(data, forKey: "userArray")
                }
                
                for i in 0..<idArr.count{
                    if self.userModel?.userId == idArr[i]{
                        uArr[i] = self.userModel!
                        let data = NSKeyedArchiver.archivedData(withRootObject: uArr)
                        UserDefaults.standard.set(data, forKey: "userArray")
                    }
                }
            }else{
                var userArr = [CQDepartMentUserListModel]()
                userArr.append(self.userModel!)
                let data = NSKeyedArchiver.archivedData(withRootObject: userArr)
                UserDefaults.standard.set(data, forKey: "userArray")
            }
        }else{
            var uArr:[CQDepartMentUserListModel] = NSKeyedUnarchiver.unarchiveObject(with: uData as! Data) as! [CQDepartMentUserListModel]
            var idArr = [String]()
            for i in 0..<uArr.count{
                let model = uArr[i]
                idArr.append(model.userId)
            }
            
            
            for i in 0..<idArr.count{
                if self.userModel?.userId == idArr[i]{
                    uArr[i] = self.dModel!
                    self.dModel?.userId = self.userId
                    let data = NSKeyedArchiver.archivedData(withRootObject: uArr)
                    UserDefaults.standard.set(data, forKey: "userArray")
                }
            }
        }
        if result == .cancelled {
            SVProgressHUD.showInfo(withStatus: "短信已取消发送")
        }else if result == .sent {
            SVProgressHUD.showInfo(withStatus: "短信发送成功")
            
        }else if result == .failed {
            SVProgressHUD.showInfo(withStatus: "短信发送失败")
        }
        
    }
}

extension CQWorkInstrumentPersonInfoVC:CQShareDelegate{
    func pushToThirdPlatform(index: Int) {
        var type:SSDKPlatformType!
        if 0 == index {
            type = SSDKPlatformType.subTypeWechatSession
        }else if 1 == index{
            type = SSDKPlatformType.subTypeWechatTimeline
        }else if 2 == index{
            type = SSDKPlatformType.subTypeQQFriend
        }else if 3 == index{
            type = SSDKPlatformType.subTypeQZone
        }
        
//        let imgUrl:String = UserDefaults.standard.object(forKey: "headImage") as! String
//        let imgData = NSData.init(contentsOf: URL.init(string: self.personInfo?.headImage)!)
//        let img = UIImage.init(data: imgData! as Data)
        
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: "部门：" + (self.model?.departmentName)! + "\n" + "职位：" + (self.model?.positionName)! + "\n" + "手机：" + (self.model?.userName)!,
                                          images : self.model?.headImage ?? UIImage.init(named: "CQIndexPersonDefault"),
                                          url : NSURL(string:self.cardUrl) as URL?,
                                          title :  (self.model?.realName)! + "的名片",
                                          type : SSDKContentType.webPage)
        
        //2.进行分享
        ShareSDK.share(type , parameters: shareParames) { (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
            
            switch state{
                
            case SSDKResponseState.success: print("分享成功")
            case SSDKResponseState.fail:    print("授权失败,错误描述:\(String(describing: error))")
            case SSDKResponseState.cancel:  print("操作取消")
                
            default:
                break
            }
            
        }
    }
    
    
}

extension CQWorkInstrumentPersonInfoVC{
    //计算宽度
    func getTexWidth(textStr:String,font:UIFont,height:CGFloat) -> CGFloat {
        
        let normalText: String = textStr
        
        let size = CGSize.init(width: 1000, height: height)
        
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context:nil).size
        
        return stringSize.width
        
    }
}

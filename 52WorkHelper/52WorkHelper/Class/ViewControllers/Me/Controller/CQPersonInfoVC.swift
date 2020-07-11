//
//  CQPersonInfoVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/3.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQPersonInfoVC: SuperVC {
    var index:IndexPath?
    var infoModel:PersonModel?
    fileprivate lazy var photosPickerC = UIImagePickerController()
    var phoneField:MyTextField!
    var userNameField:MyTextField!
    var eMailField:MyTextField!
    var QQField:MyTextField!
    var weChatField:MyTextField!
    var decField:MyTextField!
    var rightItem:UIBarButtonItem!
    var personDesField:MyTextField!
    var isCodeClick = false
    var rightBtn:UIButton?
    var isEdite = false
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.backgroundColor = kProjectBgColor
        table.delegate = self
        table.dataSource = self
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    
    lazy var wechatCodeBtn: UIButton = {
        let wechatCodeBtn = UIButton.init(type: .custom)
        wechatCodeBtn.frame = CGRect.init(x: AutoGetWidth(width: 70), y: 0, width: AutoGetWidth(width: 70), height: AutoGetHeight(height: 55))
        wechatCodeBtn.setImage(UIImage.init(named: "wechatCode"), for: .normal)
        wechatCodeBtn.setTitle("上传", for: .normal)
        wechatCodeBtn.titleLabel?.font = kFontSize17
        wechatCodeBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -40, bottom: 0, right: 0)
        wechatCodeBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 45, bottom: 0, right: 0)
        wechatCodeBtn.isUserInteractionEnabled = false
        wechatCodeBtn.isHidden = true
        wechatCodeBtn.setTitleColor(kLightBlueColor, for: .normal)
        wechatCodeBtn.addTarget(self, action: #selector(upLoadCode), for: .touchUpInside)
        return wechatCodeBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // loadData()
        self.title = "我的信息"
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        
        self.table.register(CQPersonInfoCell.self, forCellReuseIdentifier: "CQPersonInfoCellId")
        
        rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        rightBtn?.setTitle("编辑", for: .normal)
        rightBtn?.sizeToFit()
        rightBtn!.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        rightBtn?.setTitleColor(UIColor.colorWithHexString(hex: "#20afff"), for: .normal)
        rightBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        rightBtn?.addTarget(self, action: #selector(editClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn!)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    @objc func editClick()  {
        if self.rightBtn?.titleLabel?.text == "编辑" {
            isEdite = true
            self.table.reloadData()
            self.rightBtn?.setTitle("完成", for: .normal)
//            self.phoneField.isUserInteractionEnabled = true
//            self.decField.isUserInteractionEnabled = true
//            self.eMailField.isUserInteractionEnabled = true
//            self.QQField.isUserInteractionEnabled = true
            self.wechatCodeBtn.isHidden = false
            self.wechatCodeBtn.isUserInteractionEnabled = true
//            self.personDesField.isUserInteractionEnabled = true
//            self.userNameField.isUserInteractionEnabled = true
//            self.weChatField.isUserInteractionEnabled = true
            
        }else if self.rightBtn?.titleLabel?.text == "完成"{
            isEdite = false
            self.table.reloadData()
            self.rightBtn?.setTitle("编辑", for: .normal)
//            self.phoneField.isUserInteractionEnabled = false
//            self.decField.isUserInteractionEnabled = false
//            self.eMailField.isUserInteractionEnabled = false
//            self.QQField.isUserInteractionEnabled = false
            self.wechatCodeBtn.isHidden = true
            self.wechatCodeBtn.isUserInteractionEnabled = false
//            self.userNameField.isUserInteractionEnabled = false
//            self.personDesField.isUserInteractionEnabled = false
//            self.weChatField.isUserInteractionEnabled = false
            self.updateMyInfo()
        }
        
    }
    
    @objc func upLoadCode()  {
        self.isCodeClick = true
        
        self.initLibImgPicker()
    }
    
    func initLibImgPicker()  {
        KiClipperHelper.sharedInstance.nav = navigationController
        KiClipperHelper.sharedInstance.clippedImgSize = CGSize.init(width: AutoGetWidth(width: 100), height: AutoGetWidth(width: 100))
        KiClipperHelper.sharedInstance.clippedImageHandler = {[weak self]img in
            if (self?.isCodeClick)!{
                self?.uploadImage(header: img)
            }else{
                let cell:CQPersonInfoCell = self!.table.cellForRow(at: self!.index!) as! CQPersonInfoCell
                cell.iconImg.image = img
                self?.uploadImage(header: img)
                //刷新用户信息 头像
                self?.refreshHeader()
         
            }
        }
        
        KiClipperHelper.sharedInstance.clipperType = .Stay
        KiClipperHelper.sharedInstance.systemEditing = false
        KiClipperHelper.sharedInstance.isSystemType = false
        takePhoto()
    }
    
    func takePhoto() {
        
        //        KiClipperHelper.sharedInstance.photoWithSourceType(type: .photoLibrary) //直接打开相册选取图片
        //        KiClipperHelper.sharedInstance.photoWithSourceType(type: .camera) //打开相机拍摄照片
        
        var message = ""
        if isCodeClick == false {
            message = "选择头像"
        }else{
            message = "选择微信二维码"
        }
        let alertSheet = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        // 2 命令（样式：退出Cancel，警告Destructive-按钮标题为红色，默认Default）
        let cancelAction = UIAlertAction(title: "取消", style:  .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "拍照", style:  .default, handler:{
            action in
            KiClipperHelper.sharedInstance.photoWithSourceType(type: .camera)
        })
        
        let archiveAction = UIAlertAction(title: "从相册选择", style: .default, handler: {
            action in
            KiClipperHelper.sharedInstance.photoWithSourceType(type: .photoLibrary)
        })
        
        alertSheet.addAction(cancelAction)
        alertSheet.addAction(deleteAction)
        alertSheet.addAction(archiveAction)
        // 3 跳转
        self.present(alertSheet, animated: true, completion: nil)
    }
    
}


extension CQPersonInfoVC{
    func loadData()  {
        //,"version":"v1"
        
        SVProgressHUD.show()
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/my/information" ,
            type: .get,
            param: ["emyeId":userID],
            successCallBack: { (result) in
                guard let model = PersonModel.init(jsonData: result["data"]) else {
                    return
                }
                
                self.infoModel = model
                self.table.reloadData()
                SVProgressHUD.dismiss()
        }) { (error) in
           // self.table.reloadData()
            SVProgressHUD.dismiss()
            
        }
    }
    
    func updateMyInfo()  {
//        // 判断
//        guard let phoneNum = self.phoneField.text, phoneNum.count > 0,
//            let emailNum = self.eMailField.text, emailNum.count > 0,
//            let qqNum = self.QQField.text, qqNum.count > 0,
//            let weChatNum = self.weChatField.text, weChatNum.count > 0,
//            let personDes = self.decField.text, personDes.count > 0,
//            let postL = self.personDesField.text, postL.count > 0 else {
////                SVProgressHUD.showInfo(withStatus: "11111")
//                return
//        }
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/my/updateMyInfo" ,
            type: .post,
            param: ["emyeId":userID,
                    "eMail":self.eMailField.text ?? "",
                    "personalStatement":self.decField.text ?? "",
                    "phoneNumber":self.phoneField.text ?? "",
                    "postalAddress":self.infoModel?.postalAddress ?? "",
                    "qqNumber":self.QQField.text ?? "",
                    "wechatNumber":self.weChatField.text ?? "","userName":self.userNameField.text ?? ""],
            successCallBack: { (result) in
                self.loadData()
                SVProgressHUD.showInfo(withStatus: "上传成功")
        }) { (error) in
            self.table.reloadData()
            
        }
    }
    
    func uploadImage(header: UIImage) {
        let urlUpload = "\(baseUrl)/my/uploadHeadImage"
        let headers = ["t_userId":STUserTool.account().userID,
                       "token":STUserTool.account().token]
        var type = ""
        if isCodeClick == false {
            type = "headImage"
        }else{
            type = "headQRCode"
        }
        Alamofire.upload(multipartFormData: { formData in
            let userID = STUserTool.account().userID
            let param = ["emyeId":userID,
                         "type":type]
            //图片
            let imageData = UIImageJPEGRepresentation(header, 0.3)
            formData.append(imageData!, withName: "file", fileName: "photo.png", mimeType: "image/jpg")
            
            for (key, value) in param {
                formData.append((value.data(using: .utf8)!), withName: key)
            }
        }, to: urlUpload, headers: headers, encodingCompletion: {encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    guard let result = response.result.value else {
                        SVProgressHUD.showError(withStatus: "服务器有点问题")
                        return
                    }
                    let json = JSON(result)
                    if json["success"].boolValue {
                        SVProgressHUD.showSuccess(withStatus: "上传成功")
                        if self.isCodeClick {
                            self.rightBtn?.setTitle("编辑", for: .normal)
                            self.phoneField.isUserInteractionEnabled = false
                            self.decField.isUserInteractionEnabled = false
                            self.userNameField.isUserInteractionEnabled = false
                            self.eMailField.isUserInteractionEnabled = false
                            self.QQField.isUserInteractionEnabled = false
                            self.wechatCodeBtn.isHidden = true
                            self.wechatCodeBtn.isUserInteractionEnabled = false
                            self.personDesField.isUserInteractionEnabled = false
                            self.weChatField.isUserInteractionEnabled = false
                        }else{
                            NotificationCenter.default.post(name: NSNotification.Name.init("changePersonHeaderImg"), object: nil)
                        }
                    } else {
                        SVProgressHUD.showError(withStatus: json["message"].stringValue)
                    }
                }
            case .failure( _):
                SVProgressHUD.showError(withStatus: "服务器有点问题")
            }
        })
    }
    
    func refreshHeader() {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/mailList/updateUserInfo",
            type: .get,
            param: ["userId":userID],
            successCallBack: { (result) in
                
        }) { (error) in
            
        }
    }
}

extension CQPersonInfoVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = nil
        if 0 == indexPath.row {
            cell = tableView.dequeueReusableCell(withIdentifier: "CQPersonInfoCellId") as! CQPersonInfoCell
            
            (cell as! CQPersonInfoCell).iconImg.sd_setImage(with: URL(string: self.infoModel?.headImage ?? ""), placeholderImage:UIImage.init(named: "personDefaultIcon") )
            cell?.accessoryType = .disclosureIndicator
        }else if 1 == indexPath.row {
            if cell == nil{
                cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "personCellId")
            }
            
            cell?.textLabel?.text = "工号"
            cell?.detailTextLabel?.text = self.infoModel?.workNumber
        }else if 2 == indexPath.row {
            if cell == nil{
                cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "personCellId")
            }
            cell?.textLabel?.text = "性别"
            cell?.detailTextLabel?.text = self.infoModel?.employeeSex
            
        }else if 3 == indexPath.row {
            if cell == nil{
                cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "birthCellId")
            }
            cell?.textLabel?.text = "生日"
            if self.infoModel?.birthDate == ""{
               cell?.detailTextLabel?.text = "未设置"
            }else{
                
                if self.infoModel?.birthDateType == "1"{
                    cell?.detailTextLabel?.text = self.infoModel?.birthDate
                }else{
                    if let mod = self.infoModel{
                        let  timeDate = Date(dateString: mod.birthDate, format: "yyyy-MM-dd")
                        let str = solarToLunar(year: timeDate.year, month: timeDate.month, day: timeDate.day)
                        cell?.detailTextLabel?.text = str
                    }else{
                        
                    }
                    
                }
                
                
            }
            cell?.accessoryType = .disclosureIndicator
        }else if 4 == indexPath.row {
            if cell == nil{
                cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "personCellId")
            }
            cell?.textLabel?.text = "手机"
           // cell?.detailTextLabel?.text = self.infoModel?.userName
            self.userNameField = self.insertField(frame: CGRect.init(x: kWidth/2, y: 0, width: kWidth/2 - kLeftDis, height: AutoGetHeight(height: 55)), keyboardType: .default, font: kFontSize17, textColor: kLyGrayColor, tag: 300, text:self.infoModel?.userName ?? "")
            self.userNameField.isUserInteractionEnabled = false
            cell?.addSubview(self.userNameField)
            if  isEdite == true{
                userNameField.isUserInteractionEnabled = true
                userNameField.textColor = UIColor.black
                
            }else{
                userNameField.isUserInteractionEnabled = false
                userNameField.textColor = kLyGrayColor
            }
            
            
        }else if 5 == indexPath.row {
            if cell == nil{
                cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "personCellId")
            }
            cell?.textLabel?.text = "电话"
            self.phoneField = self.insertField(frame: CGRect.init(x: kWidth/2, y: 0, width: kWidth/2 - kLeftDis, height: AutoGetHeight(height: 55)), keyboardType: .default, font: kFontSize17, textColor: kLyGrayColor, tag: 300, text:self.infoModel?.phoneNumber ?? "")
            self.phoneField.isUserInteractionEnabled = false
            cell?.addSubview(self.phoneField)
            if  isEdite == true{
                phoneField.textColor = UIColor.black
                phoneField.isUserInteractionEnabled = true
            }else{
                phoneField.textColor = kLyGrayColor
                phoneField.isUserInteractionEnabled = false
            }
        }else if 6 == indexPath.row {
            if cell == nil{
                cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "personCellId")
            }
            cell?.textLabel?.text = "邮箱"
            self.eMailField = self.insertField(frame: CGRect.init(x: kWidth/2, y: 0, width: kWidth/2 - kLeftDis, height: AutoGetHeight(height: 55)), keyboardType: .default, font: kFontSize17, textColor: kLyGrayColor, tag: 300, text:self.infoModel?.eMail ?? "")
            self.eMailField.isUserInteractionEnabled = false
            cell?.addSubview(self.eMailField)
            if  isEdite == true{
                eMailField.isUserInteractionEnabled = true
                eMailField.textColor = UIColor.black
            }else{
                eMailField.textColor = kLyGrayColor
                eMailField.isUserInteractionEnabled = false
            }
        }else if 7 == indexPath.row{
            if cell == nil{
                cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "personCellId")
            }
            cell?.textLabel?.text = "QQ"
            self.QQField = self.insertField(frame: CGRect.init(x: kWidth/2, y: 0, width: kWidth/2 - kLeftDis, height: AutoGetHeight(height: 55)), keyboardType: .numberPad, font: kFontSize17, textColor: kLyGrayColor, tag: 300, text: self.infoModel?.qqNumber ?? "")
            self.QQField.isUserInteractionEnabled = false
            cell?.addSubview(self.QQField)
            if  isEdite == true{
                QQField.isUserInteractionEnabled = true
                QQField.textColor = UIColor.black
                
            }else{
                
                QQField.textColor = kLyGrayColor
                QQField.isUserInteractionEnabled = false
            }
        }else if 8 == indexPath.row{
            if cell == nil{
                cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "personCellId")
            }
            cell?.textLabel?.text = "微信"
            cell?.addSubview(self.wechatCodeBtn)
            
            self.weChatField = self.insertField(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 130), y: 0, width: AutoGetWidth(width: 115), height: AutoGetHeight(height: 55)), keyboardType: .numberPad, font: kFontSize17, textColor: kLyGrayColor, tag: 300, text:self.infoModel?.wechatNumber ?? "")
            self.weChatField.isUserInteractionEnabled = false
            cell?.addSubview(self.weChatField)
            
            if  isEdite == true{
                weChatField.textColor = UIColor.black
                weChatField.isUserInteractionEnabled = true
                wechatCodeBtn.isHidden = false
            }else{
                weChatField.textColor = kLyGrayColor
                weChatField.isUserInteractionEnabled = false
                wechatCodeBtn.isHidden = true
            }
        }else if 9 == indexPath.row{
            if cell == nil{
                cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "personCellId")
            }
            cell?.textLabel?.text = "座右铭"
            self.decField = self.insertField(frame: CGRect.init(x: kWidth/2, y: 0, width: kWidth/2 - kLeftDis, height: AutoGetHeight(height: 55)), keyboardType: .default, font: kFontSize17, textColor: kLyGrayColor, tag: 300, text: self.infoModel?.personalStatement ?? "")
            self.decField.isUserInteractionEnabled = false
            cell?.addSubview(self.decField)
            
            if  isEdite == true{
                decField.textColor = UIColor.black
                decField.isUserInteractionEnabled = true
            }else{
                
                decField.textColor = kLyGrayColor
                decField.isUserInteractionEnabled = false
            }
        }else if 10 == indexPath.row {
            if cell == nil{
                cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "personCellId")
            }
            
            let lab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 12), width: kWidth/2, height: AutoGetHeight(height: 17)))
            lab.text = "通讯地址"
            lab.textAlignment = .left
            lab.font = kFontSize15
            lab.textColor = UIColor.black
            cell?.addSubview(lab)
            
            self.personDesField = self.insertField(frame: CGRect.init(x: kLeftDis, y: lab.bottom + AutoGetHeight(height: 0), width: kWidth - 2 * kLeftDis, height: AutoGetHeight(height: 70)), keyboardType: .default, font: kFontSize17, textColor: kLyGrayColor, tag: 300, text: self.infoModel?.postalAddress ?? "")
            self.personDesField.textAlignment = .left
            self.personDesField.isUserInteractionEnabled = false
            cell?.addSubview(self.personDesField)
            if  isEdite == true{
                personDesField.textColor = UIColor.black
                personDesField.isUserInteractionEnabled = true
            }else{
                personDesField.textColor = kLyGrayColor
                personDesField.isUserInteractionEnabled = false
            }
        }
        
        cell?.textLabel?.font = kFontSize15
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            index = indexPath
            self.isCodeClick = false
            self.initLibImgPicker()
        }
        else if indexPath.row == 3{

            let vc =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "bSeting") as! QRBirthdaySettingVC
            vc.title = "生日设置"
            
            if  (self.infoModel?.birthDate.count)! > 5{
                vc.timeStr = self.infoModel!.birthDate
                vc.birthDateType = self.infoModel!.birthDateType
            }else{
                
            }
             self.navigationController?.pushViewController(vc, animated: true)
        }else{
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if 0 == indexPath.section && 0 == indexPath.row {
            return AutoGetHeight(height: 100)
        }else if 0 == indexPath.section && 10 == indexPath.row{
            return AutoGetHeight(height: 104)
        }
        return AutoGetHeight(height: 55)
    }
    

}

extension CQPersonInfoVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    @objc func textFieldEditChanged(obj:Notification)  {
        
    }
    
    
}

extension CQPersonInfoVC{
    func insertField(frame:CGRect,keyboardType:UIKeyboardType,font:UIFont,textColor:UIColor
        ,tag:Int,text:String) -> MyTextField {
        let field = MyTextField.init(frame: frame)
        field?.delegate = self
        field?.tag = tag
        field?.clearButtonMode = .never
        field?.font = font
        field?.textColor = textColor
        field?.text = text
        field?.textAlignment = .right
        field?.tintColor = UIColor.black
        field?.placeholder = text
        field?.keyboardType = keyboardType
        return field!
    }
}




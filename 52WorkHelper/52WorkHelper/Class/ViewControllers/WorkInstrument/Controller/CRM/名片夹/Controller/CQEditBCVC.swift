//
//  CQEditBCVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2019/1/15.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class CQEditBCVC: SuperVC {

    var curRealName = ""
    var telArray = [String]()
    var phoneArray = [String]()
    var emailArray = [String]()
    var locaArr = [String]()
    var companyArray = [String]()
    var departmentArray = [String]()
    var postionArray = [String]()
    var websiteArray = [String]()
    
    var frontImg : UIImage?
    var backImg : UIImage?
    var frontBtn : UIButton?
    var backBtn : UIButton?
    
    
    var frontClick = false
    var backClick = false
    
    var commitDic = NSMutableDictionary.init()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: CGFloat(SafeAreaTopHeight), width: kWidth, height: kHeight - CGFloat(SafeAreaTopHeight) - SafeAreaBottomHeight), style: UITableViewStyle.grouped)
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.colorWithHexString(hex: "#eaeaea")
        // 去除多余的分割线
        if #available(iOS 11.0, *) {
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
            //低于 iOS 9.0
        }
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 223)))
        headView.backgroundColor = UIColor.white
        return headView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y:AutoGetHeight(height: 0) , width: kWidth, height: AutoGetHeight(height: 223)))
        scrollView.contentSize = CGSize.init(width: kWidth * 2, height:AutoGetHeight(height: 223))
//        scrollView.backgroundColor = UIColor.colorWithHexString(hex: "#eaeaea")
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        // scrollView.backgroundColor = UIColor.black
        scrollView.tag = 1001
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        return scrollView
    }()
    
    lazy var footView: UIView = {
        let footView = UIView.init(frame: CGRect.init(x: 0, y:0, width: kWidth, height: AutoGetHeight(height: 120)))
        footView.backgroundColor = kProjectBgColor
        return footView
    }()
    
    lazy var labBgView: UIView = {
        let labBgView = UIView.init(frame: CGRect.init(x: 0, y:AutoGetHeight(height: 10), width: kWidth, height: AutoGetHeight(height: 110)))
        labBgView.backgroundColor = UIColor.white
        return labBgView
    }()
    
    lazy var footLab: UILabel = {
        let footLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: AutoGetWidth(width: 230), height: AutoGetHeight(height: 55)))
        footLab.text = " 名片自动保存到通讯录"
        footLab.textColor = UIColor.black
        footLab.textAlignment = .left
        footLab.font = kFontSize15
        return footLab
    }()
    
    lazy var footLabs: UILabel = {
        let footLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 55), width: AutoGetWidth(width: 230), height: AutoGetHeight(height: 55)))
        footLab.text = " 名片自动保存为客户"
        footLab.textColor = UIColor.black
        footLab.textAlignment = .left
        footLab.font = kFontSize15
        return footLab
    }()
    lazy var sws: UISwitch = {
        let sw = UISwitch.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 68), y: AutoGetHeight(height: 12.5)+AutoGetHeight(height: 55), width: AutoGetWidth(width: 53), height: AutoGetHeight(height: 30)))
        sw.isOn = true
        sw.tag = 101
        sw.addTarget(self, action: #selector(swClick(sender:)), for: .valueChanged)
        return sw
    }()
    
    lazy var sw: UISwitch = {
        let sw = UISwitch.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 68), y: AutoGetHeight(height: 12.5), width: AutoGetWidth(width: 53), height: AutoGetHeight(height: 30)))
        //        sw.tintColor = kLyGrayColor
        //        sw.onTintColor = kli
        sw.isOn = true
        sw.addTarget(self, action: #selector(swClick(sender:)), for: .valueChanged)
        return sw
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl.init(frame: CGRect(x: (kWidth - AutoGetWidth(width: 36))/2, y: AutoGetHeight(height: 183), width: AutoGetWidth(width: 36), height: 10))
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = kLyGrayColor
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "编辑名片"
        self.view.backgroundColor = UIColor.colorWithHexString(hex: "#eaeaea")
        self.view.addSubview(self.table)
        self.table.register(CQEditBusinessCardCell.self, forCellReuseIdentifier: "CQEditBusinessCardCellId")
        self.table.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CQEdictBCardView")
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.scrollView)
        
        let titleArr = ["添加正面","添加背面"]
        for i in 0..<titleArr.count {
            let btn = UIButton.init(type: .custom)
            btn.frame = CGRect.init(x: kLeftDis + CGFloat(i) * kWidth, y: kLeftDis, width: kHaveLeftWidth, height: AutoGetHeight(height: 193))
            btn.setImage(UIImage.init(named: "tjj"), for: .normal)
            btn.setTitle(titleArr[i], for: .normal)
            btn.setTitleColor(kLyGrayColor, for: .normal)
            btn.tag = 800 + i
            if i == 0{
                frontBtn = btn
            }else{
                backBtn = btn
            }
            btn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 70, bottom: 60, right: 0)
            btn.titleEdgeInsets = UIEdgeInsets.init(top: 40, left: -60, bottom: 0, right: 0)
            btn.backgroundColor = UIColor.colorWithHexString(hex: "#ebf8ff")
            btn.addTarget(self, action: #selector(addCardClick(sender:)), for: .touchUpInside)
            //前图旋转按钮
            let rotationBut = UIButton(frame:  CGRect(x: kHaveLeftWidth-45, y: AutoGetHeight(height: 193)-45, width: 37, height: 37))
            rotationBut.tag = i
            rotationBut.setImage(UIImage(named: "rotation"), for: UIControlState.normal)
            btn.addSubview(rotationBut)
            rotationBut.addTarget(self, action: #selector(rotationImg(sender:)), for: UIControlEvents.touchUpInside)
            self.scrollView.addSubview(btn)
        }
        self.scrollView.addSubview(self.pageControl)
        
        self.table.tableFooterView = self.footView
        self.footView.addSubview(self.labBgView)
        self.labBgView.addSubview(self.footLab)
        self.labBgView.addSubview(self.sw)
        self.labBgView.addSubview(self.footLabs)
        self.labBgView.addSubview(self.sws)
        
        if STUserTool.account().crmUser == "false"{
            sws.isOn = false
            sws.isEnabled = false
        }else{
            sws.isOn = true
            sws.isEnabled = true
        }
//
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44))
        rightBtn.setTitle("完成", for: .normal)
        rightBtn.setTitleColor(kLightBlueColor, for: .normal)
        rightBtn.addTarget(self, action: #selector(commitClick), for: .touchUpInside)
        
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        
        self.telArray.append("")
    }
    
    //旋转z按钮
    @objc func rotationImg(sender:UIButton){
        if sender.tag == 0{

            if let front = self.frontImg{
                self.frontBtn?.setBackgroundImage(UIImage.init(front, rotation: UIImageOrientation.right), for: UIControlState.normal)
                    self.frontImg = UIImage.init(front, rotation: UIImageOrientation.right)

            }else{
                SVProgressHUD.showInfo(withStatus: "图片为空")
            }

        }else{

            if let back = self.backImg{
                self.backBtn?.setBackgroundImage(UIImage.init(back, rotation: UIImageOrientation.right), for: UIControlState.normal)
                self.backImg = UIImage.init(back, rotation: UIImageOrientation.right)

            }else{
                SVProgressHUD.showInfo(withStatus: "图片为空")
            }

        }
        
        
    }
    
    @objc func addCellClick(sender:UIButton)  {
        if sender.tag == 200 {
            self.telArray.append("")
        }else if sender.tag == 201 {
            self.phoneArray.append("")
        }else if sender.tag == 202 {
            self.emailArray.append("")
        }else if sender.tag == 203 {
            self.locaArr.append("")
        }else if sender.tag == 204 {
            self.companyArray.append("")
        }else if sender.tag == 205 {
            self.departmentArray.append("")
        }else if sender.tag == 206 {
            self.postionArray.append("")
        }else if sender.tag == 207 {
            self.websiteArray.append("")
        }
        
        self.table.reloadData()
    }
    
    @objc func addCardClick(sender:UIButton)  {
        let camera = QRCameraViewController()
        camera.cateBut.isHidden = true
        camera.clickClosure = {[unowned self] xx in
            sender.setImage(UIImage.init(named: ""), for: .normal)
            sender.setTitle("", for: .normal)
            sender.setBackgroundImage(xx, for: .normal)
            if sender.tag == 800{
                self.frontImg = xx!
                self.frontClick = true
            }else{
                self.backImg = xx!
                self.backClick = true
            }
        }
        camera.isEdit = true
        camera.modalPresentationStyle = .fullScreen
        self.present(camera, animated: true, completion: nil)
        
    }
    //自动保存
    @objc func swClick(sender:UISwitch)  {
        
    }
    func updatePhoneNum()  {
        //更新到通讯录
        let per = LJPerson()
        //公司
        if companyArray.count>0{

            var str = ""
            for (index,_) in (companyArray.enumerated()){
                str = str + "  " + companyArray[index]
            }
            per.organizationName = str
        }
        //部门
        if departmentArray.count>0{
           // per.departmentName = departmentArray[0]
            var str = ""
            for (index,_) in (departmentArray.enumerated()){
                str = str + "  " + departmentArray[index]
            }
            per.departmentName = str
        }
        //名字
        //备注
       // per.note = self.commitDic.value(forKey: "realName") as! String

        per.familyName = (self.commitDic.value(forKey: "realName") as! String)
        //地址
        var addressArr = [LJAddress]()
        if locaArr.count>0{
            for (index,_) in locaArr.enumerated(){
                let Maddress = LJAddress()
                Maddress.street = locaArr[index]
                addressArr.append(Maddress)
            }
        }
        per.addresses = addressArr
        //url
        var addressUrlArr = [LJUrlAddress]()
        if websiteArray.count>0{
            for (index,_) in websiteArray.enumerated(){
                let MUrladdress = LJUrlAddress()
                MUrladdress.urlString = websiteArray[index]
                addressUrlArr.append(MUrladdress)
            }
        }
        per.urls = addressUrlArr


        //email邮箱
        var emailArr = [LJEmail]()
        if emailArray.count>0{
            for (index,_) in emailArray.enumerated(){
                let Memail = LJEmail()
                Memail.email = emailArray[index]
                Memail.label = CNLabelWork
                emailArr.append(Memail)
            }
        }
        per.emails = emailArr
        //手机
        var PhoneArr = [LJPhone]()
        if phoneArray.count>0{
            for (index,_) in (phoneArray.enumerated()){
                let Mphone = LJPhone()
                Mphone.phone = phoneArray[index]
                Mphone.label = CNLabelPhoneNumberMobile
                PhoneArr.append(Mphone)
            }
        }
        //电话
        if telArray.count>0{
            for (index,_) in telArray.enumerated(){
                let Mphone = LJPhone()
                Mphone.phone = telArray[index]
                Mphone.label = CNLabelHome
                PhoneArr.append(Mphone)
            }
        }
        per.phones = PhoneArr
        LJContactManager.sharedInstance()?.saveNewContact(withPhoneNum: per)
    }
    
    
//    func updatePhoneNum()  {
//        //更新到通讯录
//        let per = LJPerson()
//        //名字
//        if let realName = self.commitDic.value(forKey: "realName"){
//            per.familyName =  realName as! String
//        }else{
//            per.familyName = ""
//        }
//        //备注
//        if let remark = self.commitDic.value(forKey: "remark"){
//            per.note =  remark as! String
//        }else{
//            per.note = ""
//        }
//        //公司
//        if companyArray.count>0{
//            var str = ""
//            var arr = [String]()
//            if let arrs = self.commitDic.value(forKey: "company"){
//                arr = arrs as! [String]
//                for (index,data) in (arr.enumerated()){
//                    str = str + data
//                }
//                per.organizationName = str
//            }else{
//
//            }
//
//        }
//        //部门
//        if departmentArray.count>0{
//            var str = ""
//            var arr = [String]()
//            if let arrs = self.commitDic.value(forKey: "position"){
//                arr = arrs as! [String]
//                for (index,data) in (arr.enumerated()){
//                    str = str + data
//                }
//                per.organizationName = str
//            }else{
//
//            }
//        }
//        //地址
//        var addressArr = [LJAddress]()
//        if locaArr.count>0{
//            var arr = [String]()
//
//            if let arrs = self.commitDic.value(forKey: "address"){
//                arr = arrs as! [String]
//                for (index,data) in arr.enumerated(){
//                    let Maddress = LJAddress()
//                    Maddress.street = data
//                    addressArr.append(Maddress)
//                }
//                per.addresses = addressArr
//            }else{
//
//            }
//        }
//
//        //url
//        var addressUrlArr = [LJUrlAddress]()
//        if websiteArray.count>0{
//            var arr = [String]()
//            if let arrs = self.commitDic.value(forKey: "website"){
//                arr = arrs as! [String]
//                for (index,data) in arr.enumerated(){
//                    let MUrladdress = LJUrlAddress()
//                    MUrladdress.urlString = data
//                    MUrladdress.label = CNLabelWork
//                    addressUrlArr.append(MUrladdress)
//                }
//                 per.urls = addressUrlArr
//            }else{
//
//            }
//        }
//
//        //email邮箱
//        var emailArr = [LJEmail]()
//        if emailArray.count>0{
//            var arr = [String]()
//            if let arrs = self.commitDic.value(forKey: "email"){
//                arr = arrs as! [String]
//                for (index,data) in arr.enumerated(){
//                    let Memail = LJEmail()
//                    Memail.email = data
//                    Memail.label = CNLabelWork
//                    emailArr.append(Memail)
//                }
//                per.emails = emailArr
//            }else{
//
//            }
//
//        }
//
//        //手机
//        var PhoneArr = [LJPhone]()
//        if phoneArray.count>0{
//            var arr = [String]()
//            if let arrs = self.commitDic.value(forKey: "mobile"){
//                arr = arrs as! [String]
//                for (index,data) in arr.enumerated(){
//                    let Mphone = LJPhone()
//                    Mphone.phone = data
//                    Mphone.label = CNLabelPhoneNumberMobile
//                    PhoneArr.append(Mphone)
//                }
//            }else{
//
//            }
//
//        }
//        //电话
//        if telArray.count>0{
//            var arr = [String]()
//            if let arrs = self.commitDic.value(forKey: "phone"){
//                arr = arrs as! [String]
//                for (index,data) in arr.enumerated(){
//                    let Mphone = LJPhone()
//                    Mphone.phone = data
//                    Mphone.label = CNLabelHome
//                    PhoneArr.append(Mphone)
//                }
//
//            }else{
//
//            }
//        }
//         per.phones = PhoneArr
//        LJContactManager.sharedInstance()?.saveNewContact(withPhoneNum: per)
//    }
    
    
    @objc func commitClick()  {
        
        let realName = self.commitDic["realName"]
        let mobileArray = self.commitDic["mobile"]
        if (realName != nil) {
            if (realName as! String).isEmpty{
                SVProgressHUD.showInfo(withStatus: "请输入姓名")
                return
            }
        }else{
            SVProgressHUD.showInfo(withStatus: "请输入姓名")
            return
        }
        if (mobileArray != nil){
            if ((mobileArray as! NSArray)[0] as! String).isEmpty{
                SVProgressHUD.showInfo(withStatus: "请输入手机")
                return
            }
        }else{
            SVProgressHUD.showInfo(withStatus: "请输入手机")
            return
        }
        if self.sw.isOn {
            updatePhoneNum()
        }else{
        }
        //添加字段
            self.commitDic.setValue(sw.isOn, forKey: "autoSave")
        
        let dataStr = getJSONStringFromDictionary(dictionary: self.commitDic)
        SVProgressHUD.show()
        self.createBussinessCardRequest(dataStr: dataStr)
        
        //自动保存crm
        if sws.isOn == true {
            saveCrmContact(dataStr: dataStr)
        }else{
            
        }
    }
    
    
    func saveCrmContact(dataStr:String){
        let userID = STUserTool.account().userID
        let urlUpload = "\(baseUrl)/crmBusinessCard/cardToCustomer"
        let headers = ["t_userId":userID,
                       "token":STUserTool.account().token]
        
        Alamofire.upload(multipartFormData: { formData in
//            let param =   ["createId":userID,
//                           "cardId":"",
//                           "data":dataStr]
           
            var param =   ["userId":userID,
                           "cardStr":dataStr]
            
            for (key, value) in param {
                formData.append((value.data(using: .utf8)!), withName: key)
            }
        }, to: urlUpload, headers: headers, encodingCompletion: {encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    self.loadingSuccess()
                    guard let result = response.result.value else {
                        //请求失败
                        if let err = response.error{
                        }
                        SVProgressHUD.showError(withStatus: "服务器有点问题")
                        DLog(response.error)
                        return
                    }
                    //将结果回调出去
                    let json = JSON(result)
                    if json["success"].boolValue == true{
                        SVProgressHUD.showInfo(withStatus: json["message"].stringValue)
                    }else{
                        SVProgressHUD.showError(withStatus: json["message"].stringValue)
                    }
                    
                    
                }
            case .failure( _):
                self.loadingSuccess()
                
                
            }
        })
        
        
    }
    
    
    
}

extension CQEditBCVC{
    //上传文件
    @objc func createBussinessCardRequest(dataStr:String)  {
        let userID = STUserTool.account().userID
        let urlUpload = "\(baseUrl)/crmBusinessCard/saveCardInfo"
        let headers = ["t_userId":userID,
                       "token":STUserTool.account().token]
        Alamofire.upload(multipartFormData: { formData in
            let param = ["createId":userID,
                         "cardId":"",
                         "data":dataStr]
            if self.frontClick{
                let frontImageData = UIImageJPEGRepresentation(self.frontImg!, 0.5)
                formData.append(frontImageData!, withName: "frontPhoto", fileName:"frontPhoto.png", mimeType: "image/jpg")
            }
            if self.backClick{
                let backImageData = UIImageJPEGRepresentation(self.backImg!, 0.5)
                formData.append(backImageData!, withName: "backPhoto", fileName:"backPhoto.png", mimeType: "image/jpg")
            }
            
            for (key, value) in param {
                formData.append((value.data(using: .utf8)!), withName: key)
            }
        }, to: urlUpload, headers: headers, encodingCompletion: {encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
            
                    
                    guard let result = response.result.value else {
                        //请求失败
                        if let err = response.error{
                        }
                        SVProgressHUD.showError(withStatus: "服务器有点问题")
                        DLog(response.error)
                        return
                    }
                    //将结果回调出去
                    let json = JSON(result)
                    if json["success"].boolValue == true{
                      //  SVProgressHUD.showInfo(withStatus: json["message"].stringValue)
                        SVProgressHUD.showInfo(withStatus: "添加成功")
                        NotificationCenter.default.post(name: NSNotification.Name.init("popToRoot"), object: nil)
                    }else{
                        SVProgressHUD.showError(withStatus: json["message"].stringValue)
                    }
                    
                    
                    
                }
            case .failure( _):
                SVProgressHUD.showError(withStatus: "上传失败,请稍后重试")
                self.loadingSuccess()
            }
        })
    }
    
  
}

extension CQEditBCVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
        }else if section == 1{
            return self.telArray.count
        }else if section == 2{
            return self.phoneArray.count
        }else if section == 3{
            return self.emailArray.count
        }else if section == 4{
            return self.locaArr.count
        }else if section == 5{
            return self.companyArray.count
        }else if section == 6{
            return self.departmentArray.count
        }else if section == 7{
            return self.postionArray.count
        }else if section == 8{
            return self.websiteArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CQEditBusinessCardCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "CQEditBusinessCardCellId")
        
        
        cell.showDelegate = self
        cell.editDelegate = self
        if indexPath.row == 0 && indexPath.section == 0{
            cell.nameLab.text = "姓名"
            cell.deleteBtn.isHidden = true
            cell.xingLab.text = "*"
        }else if indexPath.row == 0 && indexPath.section == 1{
            cell.nameLab.text = "手机"
            cell.deleteBtn.isHidden = true
            cell.xingLab.text = "*"
        }else if indexPath.row == 0 && indexPath.section == 2{
            cell.nameLab.text = "电话"
        }else if indexPath.row == 0 && indexPath.section == 3{
            cell.nameLab.text = "邮箱"
        }else if indexPath.row == 0 && indexPath.section == 4{
            cell.nameLab.text = "地址"
        }else if indexPath.row == 0 && indexPath.section == 5{
            cell.nameLab.text = "公司"
        }else if indexPath.row == 0 && indexPath.section == 6{
            cell.nameLab.text = "部门"
        }else if indexPath.row == 0 && indexPath.section == 7{
            cell.nameLab.text = "职位"
        }else if indexPath.row == 0 && indexPath.section == 8{
            cell.nameLab.text = "网址"
        }
        
        
        if (cell.txtFiled.prevText != nil){
            
        }else{
            if indexPath.section == 0{
                if self.curRealName.isEmpty{
                    cell.txtFiled.placeHolder = "请输入姓名"
                }else{
                    cell.txtFiled.prevText = self.curRealName
                }
            }else if indexPath.section == 1{
                if self.telArray[indexPath.row].isEmpty{
                    cell.txtFiled.placeHolder = "请输入手机号"
                }else{
                    cell.txtFiled.prevText = self.telArray[indexPath.row]
                }
                cell.txtFiled.textView.keyboardType = .numberPad
            }else if indexPath.section == 2{
                if self.phoneArray[indexPath.row].isEmpty{
                    cell.txtFiled.placeHolder = "请输入电话号"
                }else{
                    cell.txtFiled.prevText = self.phoneArray[indexPath.row]
                }
                cell.txtFiled.textView.keyboardType = .numberPad
            }else if indexPath.section == 3{
                if self.emailArray[indexPath.row].isEmpty{
                    cell.txtFiled.placeHolder = "请输入邮箱"
                }else{
                    cell.txtFiled.prevText = self.emailArray[indexPath.row]
                }
            }else if indexPath.section == 4{
                if self.locaArr[indexPath.row].isEmpty{
                    cell.txtFiled.placeHolder = "请输入地址"
                }else{
                    cell.txtFiled.prevText = self.locaArr[indexPath.row]
                }
            }else if indexPath.section == 5{
                if self.companyArray[indexPath.row].isEmpty{
                    cell.txtFiled.placeHolder = "请输入公司"
                }else{
                    cell.txtFiled.prevText = self.companyArray[indexPath.row]
                }
            }else if indexPath.section == 6{
                if self.departmentArray[indexPath.row].isEmpty{
                    cell.txtFiled.placeHolder = "请输入部门"
                }else{
                    cell.txtFiled.prevText = self.departmentArray[indexPath.row]
                }
            }else if indexPath.section == 7{
                if self.postionArray[indexPath.row].isEmpty{
                    cell.txtFiled.placeHolder = "请输入职位"
                }else{
                    cell.txtFiled.prevText = self.postionArray[indexPath.row]
                }
            }else if indexPath.section == 8{
                if self.websiteArray[indexPath.row].isEmpty{
                    cell.txtFiled.placeHolder = "请输入网址"
                }else{
                    cell.txtFiled.prevText = self.websiteArray[indexPath.row]
                }
            }
        }
        
        if (cell.contentView.subviews.last != nil)  {
            cell.contentView.subviews.last?.removeFromSuperview()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoGetHeight(height: 55)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AutoGetHeight(height: 10)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 10)))
        header.backgroundColor = kProjectBgColor
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0{
            return 0.01
        }else{
            return AutoGetHeight(height: 55)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 55)))
        footer.backgroundColor = UIColor.white
        
        if section != 0{
            let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 55)))
            if section == 1{
                btn.setTitle("  添加手机                                                  ", for: .normal)
                btn.tag = 200
            }else if section == 2{
                btn.setTitle("  添加电话                                                  ", for: .normal)
                btn.tag = 201
            }else if section == 3{
                btn.setTitle("  添加邮箱                                                  ", for: .normal)
                btn.tag = 202
            }else if section == 4{
                btn.setTitle("  添加地址                                                  ", for: .normal)
                btn.tag = 203
            }else if section == 5{
                btn.setTitle("  添加公司                                                  ", for: .normal)
                btn.tag = 204
            }else if section == 6{
                btn.setTitle("  添加部门                                                  ", for: .normal)
                btn.tag = 205
            }else if section == 7{
                btn.setTitle("  添加职位                                                  ", for: .normal)
                btn.tag = 206
            }else if section == 8{
                btn.setTitle("  添加网址                                                  ", for: .normal)
                btn.tag = 207
            }else if section == 0{
                
            }
            btn.setImage(UIImage.init(named: "addCell"), for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.addTarget(self, action: #selector(addCellClick), for: .touchUpInside)
            footer.addSubview(btn)
        }
        
        
        return footer
    }
}

extension CQEditBCVC:UIScrollViewDelegate{
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = Int((scrollView.contentOffset.x + UIScreen.main.bounds.width / 2.0) / UIScreen.main.bounds.width)
        self.pageControl.frame = CGRect(x: (kWidth - AutoGetWidth(width: 36))/2 + kWidth * CGFloat(self.pageControl.currentPage), y: AutoGetHeight(height: 183), width: AutoGetWidth(width: 36), height: 10)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

extension CQEditBCVC:CQEdictBusinessCardDelegate{
    func deleteCellClick(index: IndexPath) {
        if index.section == 1{
            self.telArray.remove(at: index.row)
        }else if index.section == 2{
            self.phoneArray.remove(at: index.row)
        }else if index.section == 3{
            self.emailArray.remove(at: index.row)
        }else if index.section == 4{
            self.locaArr.remove(at: index.row)
        }else if index.section == 5{
            self.companyArray.remove(at: index.row)
        }else if index.section == 6{
            self.departmentArray.remove(at: index.row)
        }else if index.section == 7{
            self.postionArray.remove(at: index.row)
        }else if index.section == 8{
            self.websiteArray.remove(at: index.row)
        }
        self.table.reloadData()
    }
}

extension CQEditBCVC:CQBCardEditDelegate{
    func editDelegate(index: IndexPath, text: String) {
        var key = ""
        if index.section == 0{
            key = "realName"
            self.curRealName = text
            self.commitDic.setValue(text, forKey: key)
        }else if index.section == 1{
            key = "mobile"
            self.telArray[index.row] = text
            self.commitDic.setValue(self.telArray, forKey: key)
        }else if index.section == 2{
            key = "phone"
            self.phoneArray[index.row] = text
            self.commitDic.setValue(self.phoneArray, forKey: key)
        }else if index.section == 3{
            key = "email"
            self.emailArray[index.row] = text
            self.commitDic.setValue(self.emailArray, forKey: key)
        }else if index.section == 4{
            key = "address"
            self.locaArr[index.row] = text
            self.commitDic.setValue(self.locaArr, forKey: key)
        }else if index.section == 5{
            key = "company"
            self.companyArray[index.row] = text
            self.commitDic.setValue(self.companyArray, forKey: key)
        }else if index.section == 6{
            key = "department"
            self.departmentArray[index.row] = text
            self.commitDic.setValue(self.departmentArray, forKey: key)
        }else if index.section == 7{
            key = "position"
            self.postionArray[index.row] = text
            self.commitDic.setValue(self.postionArray, forKey: key)
        }else if index.section == 8{
            key = "website"
            self.websiteArray[index.row] = text
            self.commitDic.setValue(self.websiteArray, forKey: key)
        }
    }
}

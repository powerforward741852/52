//
//  CQBCardStoreStatusVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2019/1/16.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class CQBCardStoreStatusVC: SuperVC {
    var type : Int?
    var dataArray = [QRCardInfoModel]()
    var sDataArray = [[String]()]
     var dataArrayStr = [String]()
    var recognizeStaues : Bool?
    var rootVc : CQBussinessCardListVC?
  // var commitDic = NSMutableDictionary.init()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: CGFloat(SafeAreaTopHeight), width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = kProjectBgColor
        if #available(iOS 11.0, *) {
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
            //低于 iOS 9.0
        }
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 200)))
        headView.backgroundColor = UIColor.white
        return headView
    }()
    
    lazy var statusImg: UIImageView = {
        let statusImg = UIImageView.init(frame: CGRect.init(x: (kWidth - AutoGetWidth(width: 78.5))/2, y: AutoGetHeight(height: 40), width: AutoGetWidth(width: 78.5), height: AutoGetHeight(height: 76.5)))
        statusImg.image = UIImage.init(named: "cg")
        return statusImg
    }()
    
    lazy var statusLab: UILabel = {
        let statusLab = UILabel.init(frame: CGRect.init(x: 0, y: self.statusImg.bottom + AutoGetHeight(height: 15), width: kWidth, height: AutoGetHeight(height: 18)))
        statusLab.text = "名片保存成功"
        statusLab.textAlignment = .center
        statusLab.textColor = UIColor.black
        statusLab.font = kFontSize18
        return statusLab
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if type == 1{
            
        }else{
            self.navigationItem.hidesBackButton = true
            self.navigationItem.leftBarButtonItem = nil
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "名片"
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.register(UINib.init(nibName: "CQBussinessCardListCell", bundle: Bundle.init(identifier: "CQBussinessCardListCellId")), forCellReuseIdentifier: "CQBussinessCardListCellId")
        self.table.tableHeaderView = self.headView
        
        self.headView.addSubview(self.statusImg)
        if recognizeStaues == true{
            if type == 1{
                self.statusLab.text = "识别到\(dataArray.count)张名片"
            }
        }else{
            self.statusLab.text = "名片保存失败"
            self.statusImg.image = UIImage(named: "csp")
        }
        
        self.headView.addSubview(self.statusLab)
        
        if type == 1{
            
        }else{
            let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 29, height: 19))
            rightBtn.setTitle("完成", for: .normal)
            rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5)
            rightBtn.setTitleColor(kBlueC, for: UIControlState.normal)
            rightBtn.sizeToFit()
            rightBtn.addTarget(self, action: #selector(addClick), for: .touchUpInside)
            let rightItem = UIBarButtonItem.init(customView: rightBtn)
            self.navigationItem.rightBarButtonItem = rightItem
        }
        
    }
    
    @objc func storeClcik()  {
        if self.type == 1{
            SVProgressHUD.show()
            let workingGroup = DispatchGroup()
            let workingQueue = DispatchQueue.main
            //全部保存
            for (index,_) in dataArray.enumerated(){
                workingGroup.enter()
                workingQueue.async {
                    self.loadNativeData(mod: self.dataArray[index])
                    workingGroup.leave()
                }
            }
            print("我是最开始执行的，异步操作里的打印后执行")
            // 调度组里的任务都执行完毕
            workingGroup.notify(queue: workingQueue) {
                print("接口 A 和接口 B 的数据请求都已经完毕！, 开始合并两个接口的数据")
                SVProgressHUD.dismiss()
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name.init("popToRoot"), object: nil)
            }
           
            
        }else{
            //下一张
            NotificationCenter.default.post(name: NSNotification.Name.init("popToRootnNxt"), object: nil)
            
        }
    }
    
  
    //上传文件
//    @objc func createBussinessCardRequest(mod:QRCardInfoModel , dataStr:String)  {
//        let userID = STUserTool.account().userID
//        let param = ["createId":userID,
//                     "cardId":"",
//                     "data":dataStr,
//                     "frontPhoto":mod.frontPhoto ?? "",
//                     "backPhoto":mod.backPhoto ?? ""]
//
//        STNetworkTools.requestData(URLString:"\(baseUrl)/crmBusinessCard/saveCardInfo" ,
//            type: .post,
//            param: param ,
//            successCallBack: { (result) in
//                SVProgressHUD.dismiss()
//                 SVProgressHUD.showInfo(withStatus: "添加成功")
//
//
//        }) { (error) in
//             SVProgressHUD.showInfo(withStatus: "保存失败,请稍后再试")
//        }
//
//    }

  
    
    @objc func createBussinessCardRequest(mod:QRCardInfoModel , dataStr:String)  {
        
        let userID = STUserTool.account().userID
        let urlUpload = "\(baseUrl)/crmBusinessCard/saveCardInfo"
        let headers = ["t_userId":userID,
                       "token":STUserTool.account().token]
        Alamofire.upload(multipartFormData: { formData in
            let param =   ["createId":userID,
                           "cardId":"",
                           "data":dataStr,
                           "frontPhoto":mod.frontPhoto,
                           "backPhoto":mod.backPhoto]

            DLog(param)
            if let frontImg = mod.frontImg {
                let frontImageData = UIImageJPEGRepresentation(frontImg, 0.3)
                formData.append(frontImageData!, withName: "frontPhoto", fileName:"frontPhoto.png", mimeType: "image/jpg")
            }else{
        
            }
            

            if let backImg = mod.backImg{
                let backImageData = UIImageJPEGRepresentation(backImg, 0.3)
                formData.append(backImageData!, withName: "backPhoto", fileName:"backPhoto.png", mimeType: "image/jpg")
            }else{
                
            }
            
            for (key, value) in param {
                formData.append((value!.data(using: .utf8)!), withName: key)
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
                        SVProgressHUD.showInfo(withStatus: "添加成功")
                    } else {
                        SVProgressHUD.showError(withStatus: json["message"].stringValue)
                    }
                    print(json)
       
                    self.loadingSuccess()
                 
                    
                }
            case .failure( _):
                SVProgressHUD.showError(withStatus: "上传失败,请稍后重试")
                self.loadingSuccess()
    
            }
        })
    }
                   
    
   
    
    func loadNativeData(mod: QRCardInfoModel)  {
       // self.sDataArray.removeAll()
            
        let commitDic = NSMutableDictionary.init()
        
            if !mod.frontPhoto.isEmpty{
                commitDic.setValue(mod.frontPhoto, forKey: "frontPhoto")

            }
        
            if !mod.backPhoto.isEmpty{
                commitDic.setValue(mod.backPhoto, forKey: "backPhoto")
            }
        
            if !mod.realName.isEmpty{
                commitDic.setValue(mod.realName, forKey: "realName")
            }
        
            if !mod.remark.isEmpty{
                commitDic.setValue(mod.remark, forKey: "remark")
            }
        
            if mod.mobile.count > 0{
               commitDic.setValue(mod.mobile, forKey: "mobile")
            }

            if mod.phone.count > 0{
                commitDic.setValue(mod.phone, forKey: "phone")
            }

            if mod.email.count > 0{
                commitDic.setValue(mod.email, forKey: "email")
            }

            if mod.address.count > 0{
               commitDic.setValue(mod.address, forKey: "address")
            }

            if mod.company.count > 0{
                commitDic.setValue(mod.company, forKey: "company")
            }

            if mod.department.count > 0{
                commitDic.setValue(mod.department, forKey: "department")
            }

            if mod.position.count > 0{
               commitDic.setValue(mod.position, forKey: "position")
            }

            if mod.website.count > 0{
                commitDic.setValue(mod.website, forKey: "website")
            }
        
            commitDic.setValue(mod.autoSave, forKey: "autoSave")
            if mod.autoSave == true{
                //更新通讯录
                updatePhoneNum(mod: mod)
            }
        
            let str = getJSONStringFromDictionary(dictionary: commitDic)
            print(str)
            self.createBussinessCardRequest(mod: mod, dataStr: str)
        
    }
    
    func updatePhoneNum(mod:QRCardInfoModel)  {
        //更新到通讯录
        let per = LJPerson()
        //名字
        if let realName = mod.realName {
            per.familyName =  realName
        }else{
            per.familyName = ""
        }
        //备注
        if let remark = mod.remark{
            per.note =  remark
        }else{
            per.note = ""
        }
        //公司
        
            var conpantStr = ""
        for (_,data) in mod.company.enumerated(){
                conpantStr = conpantStr + data
            }
            per.organizationName = conpantStr
        //部门
    
            var departStr = ""
        for (_,data) in (mod.position.enumerated()){
                departStr = departStr + data
            }
            per.departmentName = departStr
        
        //地址
        var addressArr = [LJAddress]()
        for (_,data) in mod.address.enumerated(){
                let Maddress = LJAddress()
                Maddress.street = data
                addressArr.append(Maddress)
            }
        per.addresses = addressArr
        
        //url
        var addressUrlArr = [LJUrlAddress]()
        
        for (_,data) in mod.website.enumerated(){
                let MUrladdress = LJUrlAddress()
                MUrladdress.urlString = data
                MUrladdress.label = CNLabelWork
                addressUrlArr.append(MUrladdress)
            }
        per.urls = addressUrlArr
        //email邮箱
        var emailArr = [LJEmail]()
        
        for (_,data) in  mod.email.enumerated(){
                let Memail = LJEmail()
                Memail.email = data
                Memail.label = CNLabelWork
                emailArr.append(Memail)
            }
        per.emails = emailArr
        //手机
        var PhoneArr = [LJPhone]()
    
        for (_,data) in mod.mobile.enumerated(){
                let Mphone = LJPhone()
                Mphone.phone = data
                Mphone.label = CNLabelPhoneNumberMobile
                PhoneArr.append(Mphone)
            }
        
        //电话
        
        for (_,data) in mod.phone.enumerated(){
                let Mphone = LJPhone()
                Mphone.phone = data
                Mphone.label = CNLabelHome
                PhoneArr.append(Mphone)
            }
        per.phones = PhoneArr
        LJContactManager.sharedInstance()?.saveNewContact(withPhoneNum: per)
    }
    
    
    @objc func addClick() {
      //  self.navigationController?.popViewController(animated: true)
       
        if type == 1{
            self.storeClcik()
        }else{
             NotificationCenter.default.post(name: NSNotification.Name.init("popToRoot"), object: nil)
            
        }
    }

}

extension CQBCardStoreStatusVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table.dequeueReusableCell(withIdentifier: "CQBussinessCardListCellId", for: indexPath) as! CQBussinessCardListCell
        
        if self.type == 1{
             cell.chooseBtn.isHidden = false
             cell.showDelegate = self
        }else{
            cell.chooseBtn.isHidden = true
        }
        cell.otherModel = dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if type == 1{
            let vc = CQAutoEditBussinessCardVC()
            vc.Mmod = dataArray[indexPath.row]
            vc.type = 2
            vc.indexPaths = indexPath
            vc.clickClosure = {[unowned self] mod,indx in
                self.dataArray[indx.row] = mod!
                self.table.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else if type == 0{
            let vc =  CQBussinessCardDtVC()
            vc.cardId = self.dataArray[indexPath.row].cardId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 97
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
        return AutoGetHeight(height: 95)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 95)))
        footer.backgroundColor = kProjectBgColor
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: (kWidth - AutoGetWidth(width: 310))/2, y: AutoGetHeight(height: 50), width: AutoGetWidth(width: 310), height: AutoGetHeight(height: 45))
        btn.layer.cornerRadius = 2
        if self.type == 1{
            btn.setTitle("全部保存", for: .normal)
        }else{
            btn.setTitle("   拍下一张", for: .normal)
            btn.setImage(UIImage.init(named: "pz"), for: .normal)
        }
        
        btn.backgroundColor = UIColor.colorWithHexString(hex: "#22afff")
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(storeClcik), for: .touchUpInside)
        footer.addSubview(btn)
        return footer
    }
}

extension CQBCardStoreStatusVC:ShowBtnDelegate{
    func showChooseClick(index: IndexPath, but: UIButton) {
        let rect = but.convert(but.bounds, to: self.view)
        let x = rect.origin.x-35
        let y = rect.origin.y+rect.size.height/2
        print(rect)
        let pop = QRCirclePopview.creatPopview(center: CGPoint(x: x, y: y), imgs:["beiz","sc"] , titles: ["备注","删除"])
        pop.clickClosure = {[unowned self] select in
            if select == 0 {
                //备注
                let remark = CQBCardRemarkVC()
                remark.isTypeMod = true
                remark.model = self.dataArray[index.row]
                self.navigationController?.pushViewController(remark, animated: true)
            }else if select == 1{
                //删除
                self.dataArray.remove(at: index.row)
                self.table.reloadData()
                
                
            }
        }
        pop.showPopView()
    }
}

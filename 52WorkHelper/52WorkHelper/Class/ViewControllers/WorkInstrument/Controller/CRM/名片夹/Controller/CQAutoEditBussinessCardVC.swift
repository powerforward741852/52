//
//  CQAutoEditBussinessCardVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2019/1/17.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class CQAutoEditBussinessCardVC: SuperVC {
    //声明闭包
    typealias clickBtnClosure = (_ model: QRCardInfoModel?, _ indx:IndexPath) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    
    var indexPaths : IndexPath?
    //自动保存设置
    var autoSave : Bool?
    //单拍接入0,多拍2
    var type = 1
    var Mmod :QRCardInfoModel?
    
    //传递的模型
    var onePassMod :QRCardInfoModel?
    
    var dataArray = [[String]()]
    var nameArray = [String]()
    var telArr = [String]()
    
    var phoneArray = [String]()
    var emailArray = [String]()
    var companyArray = [String]()
    var locaArr = [String]()
    var departmentArr = [String]()
    var positionArr = [String]()
    var webSiteArr = [String]()
    var remarkArr = [String]()
    
    var cardId = ""
    var frontImg = UIImageView.init()
    var backImg = UIImageView.init()
    
    var frontImgName = UIImage.init()
    var backImgName = UIImage.init()
    
    var downloadFrontImgName : UIImage?
    var downloadBackImgName : UIImage?
    //合成最后的一张图片
    var finalBackImgName : UIImage?
    
    var curModel:CQBussinessCardListModel!
    
    var frontClick = false
    var backClick = false
    
    var rotationFrontClick = false
    var rotationBackClick = false
    
    var commitDic = NSMutableDictionary.init()
    
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: CGFloat(SafeAreaTopHeight), width: kWidth, height: kHeight - CGFloat(SafeAreaTopHeight) - SafeAreaBottomHeight), style: UITableViewStyle.grouped)
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        //        table.backgroundColor = UIColor.white
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
        scrollView.backgroundColor = UIColor.white
        scrollView.tag = 1001
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        return scrollView
    }()
    
    lazy var footView: UIView = {
        let footView = UIView.init(frame: CGRect.init(x: 0, y:0, width: kWidth, height: AutoGetHeight(height: 110)))
        footView.backgroundColor = UIColor.white
        return footView
    }()
    
    
    lazy var footLab: UILabel = {
        let footLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: AutoGetWidth(width: 230), height: AutoGetHeight(height: 55)))
        footLab.text = " 名片自动保存到通讯录"
        footLab.textColor = UIColor.black
        footLab.textAlignment = .left
        footLab.font = kFontSize15
        return footLab
    }()
    
    lazy var sw: UISwitch = {
        let sw = UISwitch.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 68), y: AutoGetHeight(height: 12.5), width: AutoGetWidth(width: 53), height: AutoGetHeight(height: 30)))
        //        sw.tintColor = kLyGrayColor
                sw.isOn = true
        sw.tag = 100
        sw.addTarget(self, action: #selector(swClick(sender:)), for: .valueChanged)
        return sw
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
        self.initView()
        self.loadData()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func loadData()  {
        if type==0{
            //模型中取出数据
            loadNativeData()
            downloadImageData(front: self.curModel.frontPhoto, back: self.curModel.backPhoto)
        }else if type == 1{
            //详情进入界面,根据cardid刷新
            self.setUpRefresh()
        }else if type == 2{
            loadQRNativeData()
            downloadImageData(front: self.Mmod!.frontPhoto, back: self.Mmod!.backPhoto)
        }
    }
    
    func downloadImageData(front:String,back:String )  {
        if !front.isEmpty{
            SDWebImageManager.shared().imageDownloader?.downloadImage(with: URL(string: front), options: [], progress: { (receivedSize, expectedSize, imageURL) in
                
            }, completed: { (img, data, error, boo) in
                if let image = img{
                  self.downloadFrontImgName = image
                }
                
                
            })
        }
        
        if !back.isEmpty{
            SDWebImageManager.shared().imageDownloader?.downloadImage(with: URL(string: back), options: [], progress: { (receivedSize, expectedSize, imageURL) in
                
            }, completed: { (img, data, error, boo) in
                if let image = img{
                    self.downloadBackImgName = image
                }
            })
        }
    }
    
    func loadQRNativeData()  {
        self.dataArray.removeAll()
        self.nameArray.removeAll()
        if  let model = self.Mmod {
            if !model.realName.isEmpty{
                var nameArr = [String]()
                nameArr.append(model.realName)
                self.dataArray.append(nameArr)
                self.nameArray.append("姓名")
                self.commitDic.setValue(nameArr, forKey: "realName")
            }
            
            if let frontImg = model.frontImg{
                self.frontImg.image = frontImg
                self.downloadFrontImgName = frontImg
            }else{
                self.frontImg.sd_setImage(with: URL(string: model.frontPhoto), placeholderImage:UIImage.init(named: "mpz") )
            }
            
            if let backImg = model.backImg{
                self.backImg.image = backImg
                self.downloadBackImgName = backImg
            }else{
                self.backImg.sd_setImage(with: URL(string: model.backPhoto), placeholderImage:UIImage.init(named: "mpz") )
            }
            
            self.commitDic.setValue(model.frontPhoto, forKey: "frontPhoto")
            self.commitDic.setValue(model.backPhoto, forKey: "backPhoto")
            
            self.telArr.removeAll()
            for modelJson in model.mobile{
                self.telArr.append(modelJson)
            }
            if self.telArr.count > 0{
                self.dataArray.append(self.telArr)
                self.nameArray.append("手机")
                self.commitDic.setValue(self.telArr, forKey: "mobile")
            }
            
            self.phoneArray.removeAll()
            for modelJson in model.phone{
                self.phoneArray.append(modelJson)
            }
            if self.phoneArray.count > 0{
                self.dataArray.append(self.phoneArray)
                self.nameArray.append("电话")
                self.commitDic.setValue(self.phoneArray, forKey: "phone")
            }
            
            self.emailArray.removeAll()
            for modelJson in model.email{
                self.emailArray.append(modelJson)
            }
            if self.emailArray.count > 0{
                self.dataArray.append(self.emailArray)
                self.nameArray.append("邮箱")
                self.commitDic.setValue(self.emailArray, forKey: "email")
            }
            
            self.locaArr.removeAll()
            for modelJson in model.address{
                self.locaArr.append(modelJson)
            }
            if self.locaArr.count > 0{
                self.dataArray.append(self.locaArr)
                self.nameArray.append("地址")
                self.commitDic.setValue(self.locaArr, forKey: "address")
            }
            
            self.companyArray.removeAll()
            for modelJson in model.company{
                self.companyArray.append(modelJson)
            }
            if self.companyArray.count > 0{
                self.dataArray.append(self.companyArray)
                self.nameArray.append("公司")
                self.commitDic.setValue(self.companyArray, forKey: "company")
            }
            
            
            self.departmentArr.removeAll()
            for modelJson in model.department{
                self.departmentArr.append(modelJson)
            }
            if self.departmentArr.count > 0{
                self.dataArray.append(self.departmentArr)
                self.nameArray.append("部门")
                self.commitDic.setValue(self.departmentArr, forKey: "department")
            }
            
            self.positionArr.removeAll()
            for modelJson in model.position{
                self.positionArr.append(modelJson)
            }
            if self.positionArr.count > 0{
                self.dataArray.append(self.positionArr)
                self.nameArray.append("职位")
                self.commitDic.setValue(self.positionArr, forKey: "position")
            }
            
            self.webSiteArr.removeAll()
            for modelJson in model.website{
                self.webSiteArr.append(modelJson)
            }
            if self.webSiteArr.count > 0{
                self.dataArray.append(self.webSiteArr)
                self.nameArray.append("网址")
                self.commitDic.setValue(self.webSiteArr, forKey: "website")
            }
            
            if !model.remark.isEmpty{
                self.remarkArr.removeAll()
                self.remarkArr.append(model.remark)
                self.dataArray.append(self.remarkArr)
                self.nameArray.append("备注")
                self.commitDic.setValue(remarkArr, forKey: "remark")
            }
            
            self.table.reloadData()
        }else{
            
        }
    }
    func loadNativeData()  {
        self.dataArray.removeAll()
        self.nameArray.removeAll()
        if  let model = self.curModel {
            
            
            if !model.realName.isEmpty{
                var nameArr = [String]()
                nameArr.append(model.realName)
                self.dataArray.append(nameArr)
                self.nameArray.append("姓名")
                self.commitDic.setValue(nameArr, forKey: "realName")
            }
            
            self.telArr.removeAll()
            for modelJson in model.mobile{
                self.telArr.append(modelJson.stringValue)
            }
            if self.telArr.count > 0{
                self.dataArray.append(self.telArr)
                self.nameArray.append("手机")
                self.commitDic.setValue(self.telArr, forKey: "mobile")
            }
            
            self.phoneArray.removeAll()
            for modelJson in model.phone{
                self.phoneArray.append(modelJson.stringValue)
            }
            if self.phoneArray.count > 0{
                self.dataArray.append(self.phoneArray)
                self.nameArray.append("电话")
                self.commitDic.setValue(self.phoneArray, forKey: "phone")
            }
            
            self.emailArray.removeAll()
            for modelJson in model.email{
                self.emailArray.append(modelJson.stringValue)
            }
            if self.emailArray.count > 0{
                self.dataArray.append(self.emailArray)
                self.nameArray.append("邮箱")
                self.commitDic.setValue(self.emailArray, forKey: "email")
            }
            
            self.locaArr.removeAll()
            for modelJson in model.address{
                self.locaArr.append(modelJson.stringValue)
            }
            if self.locaArr.count > 0{
                self.dataArray.append(self.locaArr)
                self.nameArray.append("地址")
                self.commitDic.setValue(self.locaArr, forKey: "address")
            }
            
            self.companyArray.removeAll()
            for modelJson in model.companyArr{
                self.companyArray.append(modelJson.stringValue)
            }
            if self.companyArray.count > 0{
                self.dataArray.append(self.companyArray)
                self.nameArray.append("公司")
                self.commitDic.setValue(self.companyArray, forKey: "company")
            }
            
            
            self.departmentArr.removeAll()
            for modelJson in model.department{
                self.departmentArr.append(modelJson.stringValue)
            }
            if self.departmentArr.count > 0{
                self.dataArray.append(self.departmentArr)
                self.nameArray.append("部门")
                self.commitDic.setValue(self.departmentArr, forKey: "department")
            }
            
            self.positionArr.removeAll()
            for modelJson in model.positionArr{
                self.positionArr.append(modelJson.stringValue)
            }
            if self.positionArr.count > 0{
                self.dataArray.append(self.positionArr)
                self.nameArray.append("职位")
                self.commitDic.setValue(self.positionArr, forKey: "position")
            }
            
            self.webSiteArr.removeAll()
            for modelJson in model.website{
                self.webSiteArr.append(modelJson.stringValue)
            }
            if self.webSiteArr.count > 0{
                self.dataArray.append(self.webSiteArr)
                self.nameArray.append("网址")
                self.commitDic.setValue(self.webSiteArr, forKey: "website")
            }
            
            
            if !model.remark.isEmpty{
                self.remarkArr.removeAll()
                self.remarkArr.append(model.remark)
                self.dataArray.append(self.remarkArr)
                self.nameArray.append("备注")
                self.commitDic.setValue(self.remarkArr, forKey: "remark")
            }
            
            self.frontImg.sd_setImage(with: URL(string: model.frontPhoto), placeholderImage:UIImage.init(named: "mpz") )
            self.backImg.sd_setImage(with: URL(string: model.backPhoto), placeholderImage:UIImage.init(named: "mpz") )
            self.commitDic.setValue(model.frontPhoto, forKey: "frontPhoto")
            self.commitDic.setValue(model.backPhoto, forKey: "backPhoto")
            
            self.table.reloadData()
        }else{
            
        }
        
    }
    
    func initView()  {
        self.title = "编辑名片"
        self.view.backgroundColor = UIColor.colorWithHexString(hex: "#eaeaea")
        self.view.addSubview(self.table)
        self.table.register(CQAutoEditBCardCell.self, forCellReuseIdentifier: "CQAutoEditBCardCellId")
        self.table.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CQAutoEdictBCardView")
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.scrollView)
        let imageArr = ["mpz","mpz"]
        let titleArr = ["修改正面","修改背面"]
        for i in 0..<imageArr.count {
            if 0 == i{
                self.frontImg.frame = CGRect.init(x: kLeftDis + CGFloat(i) * kWidth, y: kLeftDis, width: kHaveLeftWidth, height: AutoGetHeight(height: 193))
                self.frontImg.isUserInteractionEnabled = true
                self.frontImg.contentMode = .scaleToFill
                self.frontImg.image = UIImage.init(named: imageArr[i])
                self.scrollView.addSubview(self.frontImg)
                //前图旋转按钮
                let rotationBut = UIButton(frame:  CGRect(x: kHaveLeftWidth-45, y: AutoGetHeight(height: 193)-45, width: 37, height: 37))
                rotationBut.tag = 0
                rotationBut.setImage(UIImage(named: "rotation"), for: UIControlState.normal)
                self.frontImg.addSubview(rotationBut)
                rotationBut.addTarget(self, action: #selector(rotationImg(sender:)), for: UIControlEvents.touchUpInside)
            }else if 1 == i{
                self.backImg.frame = CGRect.init(x: kLeftDis + CGFloat(i) * kWidth, y: kLeftDis, width: kHaveLeftWidth, height: AutoGetHeight(height: 193))
                self.backImg.contentMode = .scaleToFill
                self.backImg.isUserInteractionEnabled = true
                self.backImg.image = UIImage.init(named: imageArr[i])
                self.scrollView.addSubview(self.backImg)
                //后图旋转按钮
                let rotationBut = UIButton(frame:  CGRect(x:  kHaveLeftWidth-45, y: AutoGetHeight(height: 193)-45, width: 37, height: 37))
                rotationBut.tag = 1
                rotationBut.setImage(UIImage(named: "rotation"), for: UIControlState.normal)
                self.backImg.addSubview(rotationBut)
                rotationBut.addTarget(self, action: #selector(rotationImg(sender:)), for: UIControlEvents.touchUpInside)
            }
            
            if i == 1{
                let btn = UIButton.init(type: .custom)
                btn.frame = CGRect.init(x: kWidth - kLeftDis - AutoGetWidth(width: 80) + CGFloat(i) * kWidth, y: AutoGetHeight(height: 30), width: AutoGetWidth(width: 80), height: AutoGetHeight(height: 30))
                btn.setBackgroundImage(UIImage.init(named: "xg"), for: .normal)
                btn.setTitle(titleArr[i], for: .normal)
                btn.setTitleColor(UIColor.white, for: .normal)
                btn.tag = 500+i
                btn.titleLabel?.font = kFontSize12
                btn.addTarget(self, action: #selector(fixClick(sender:)), for: .touchUpInside)
                self.scrollView.addSubview(btn)
            }
        }
        self.scrollView.addSubview(self.pageControl)
        
        
        self.table.tableFooterView = self.footView
        self.footView.addSubview(self.footLab)
        self.footView.addSubview(self.sw)
        self.footView.addSubview(self.footLabs)
        self.footView.addSubview(self.sws)
        
        if STUserTool.account().crmUser == "false"{
            sws.isOn = false
            sws.isEnabled = false
        }else{
            sws.isOn = true
            sws.isEnabled = true
        }
        
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44))
        rightBtn.setTitle("完成", for: .normal)
        rightBtn.titleLabel?.font = kFontSize17
        rightBtn.setTitleColor(kBlueColor, for: .normal)
        rightBtn.addTarget(self, action: #selector(commitClick), for: .touchUpInside)
        
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        
    }
    //旋转z按钮
    @objc func rotationImg(sender:UIButton){
        if type == 2{
            if sender.tag == 0{

                if let front = downloadFrontImgName {
                    self.frontImg.image = UIImage.init(front, rotation: UIImageOrientation.right)
                    self.downloadFrontImgName = UIImage.init(front, rotation: UIImageOrientation.right)
                    self.Mmod!.frontImg = UIImage.init(front, rotation: UIImageOrientation.right)
                    self.rotationFrontClick = true
                }else{
                    SVProgressHUD.showInfo(withStatus: "图片为空")
                }
                
            }else{
                
                if let back = downloadBackImgName {
                    self.backImg.image = UIImage.init(back, rotation: UIImageOrientation.right)
                    self.downloadBackImgName = UIImage.init(back, rotation: UIImageOrientation.right)
                    self.Mmod!.backImg = UIImage.init(back, rotation: UIImageOrientation.right)
                    self.finalBackImgName =  self.downloadBackImgName
                    self.rotationBackClick = true
                }else{
                    SVProgressHUD.showInfo(withStatus: "图片为空")
                }
                
            }
        }else{
            if sender.tag == 0{
                
                if let front = downloadFrontImgName{
                    self.frontImg.image = UIImage.init(front, rotation: UIImageOrientation.right)
                    self.downloadFrontImgName = UIImage.init(front, rotation: UIImageOrientation.right)
                    self.rotationFrontClick = true
                }else{
                    SVProgressHUD.showInfo(withStatus: "图片为空")
                }
                
            }else{
                
                if let back = downloadBackImgName{
                    self.backImg.image = UIImage.init(back, rotation: UIImageOrientation.right)
                    self.downloadBackImgName = UIImage.init(back, rotation: UIImageOrientation.right)
                    self.finalBackImgName =  self.downloadBackImgName
                    self.rotationBackClick = true
                }else{
                    SVProgressHUD.showInfo(withStatus: "图片为空")
                }
                
            }
        }
        
        
       
    }
    

    @objc func fixClick(sender:UIButton)  {
        let camera = QRCameraViewController()
        camera.cateBut.isHidden = true
        camera.clickClosure = {[unowned self] xx in
            if sender.tag == 500{
                self.frontImgName = xx!
                self.frontClick = true
            }else{
                self.backImgName = xx!
                self.backClick = true
                self.backImg.image = xx!
                self.downloadBackImgName = xx!
                self.finalBackImgName = xx!
                self.Mmod?.backImg = xx!
            }
        }
        camera.isEdit = true
        camera.modalPresentationStyle = .fullScreen
        self.present(camera, animated: true, completion: nil)
        
    }
    
    @objc func swClick(sender:UISwitch)  {

    }
    
    @objc func commitClick()  {
        
        
        //添加字段
        self.commitDic.setValue(sw.isOn, forKey: "autoSave")
        
        if type == 2 {
        //切换模型
            switchModel()
            self.navigationController?.popViewController(animated: true)
        }else{
            //自动保存通讯录
            if sw.isOn == true {
                var name = ""
                if let realname = commitDic.value(forKey: "realName"){
                    let arr = realname as! [String]
                    name = arr.first!
                }else{
                    
                }
                let boo = LJContactManager.sharedInstance()?.deleteContacts(name)
                if boo! {
                    print("删了,然后添加一个新的")
                }else{
                    print("没删了,直接添加一个新的")
                }
                updatePhoneNum()
            }else{
                
            }
            
            
            
            //将重新字典的名字和备注都改为正常的string
            if let realname = commitDic.value(forKey: "realName"){
                let arr = realname as! [String]
                self.commitDic.setValue(arr.first, forKey: "realName")
            }else{
                self.commitDic.setValue("", forKey: "realName")
            }
            if let remark = commitDic.value(forKey: "remark"){
                let arr = remark as! [String]
                self.commitDic.setValue(arr.first, forKey: "remark")
            }else{
                self.commitDic.setValue("", forKey: "remark")
            }
            
            let dataStr = getJSONStringFromDictionary(dictionary: self.commitDic)
            print(dataStr)
            self.loadingPlay()
            self.createBussinessCardRequest(dataStr: dataStr)
            
          
            //自动保存crm
            if sws.isOn == true {
//                var dic = self.commitDic
//                dic.setValue(STUserTool.account().userID, forKey: "entityId")
                saveCrmContact(dataStr: dataStr)
            }else{
                
            }
            
            
            
        }
       
    }
    
    
    func switchModel(){
        
        
        //切换模型
        let mod = QRCardInfoModel()
        mod.autoSave = sw.isOn
        if let xx = commitDic.value(forKey: "realName") {
            mod.realName = (xx as! [String]).first
        }else{
                mod.realName  = ""
        }
      
        if let xx = commitDic.value(forKey: "remark"){
            mod.remark = (xx as! [String]).first
        }else{
            mod.remark = ""
        }
        if let modd = self.Mmod{
            mod.frontPhoto =  modd.frontPhoto
        }else{
            mod.frontPhoto = ""
        }
        if let modd = self.Mmod{
            mod.backPhoto =  modd.backPhoto
        }else{
            mod.backPhoto = ""
        }
        
        if let frontImg = self.Mmod!.frontImg{
            mod.frontImg =  frontImg
            mod.frontPhoto = ""
        }
        
        if let backImg = self.Mmod!.backImg{
            mod.backImg =  backImg
            mod.backPhoto = ""
        }
        //数组类
        
        if let xx = commitDic.value(forKey: "mobile"){
            mod.mobile = (xx as! [String])
        }else{
            mod.mobile = [String]()
        }
        if let xx = commitDic.value(forKey: "email"){
            mod.email = (xx as! [String])
        }else{
            mod.email = [String]()
        }
        if let xx = commitDic.value(forKey: "phone"){
            mod.phone = (xx as! [String])
        }else{
            mod.phone = [String]()
        }
        
        if let xx = commitDic.value(forKey: "address"){
            mod.address = (xx as! [String])
        }else{
            mod.address = [String]()
        }
        if let xx = commitDic.value(forKey: "company"){
            mod.company = (xx as! [String])
        }else{
            mod.company = [String]()
        }
        
        if let xx = commitDic.value(forKey: "department"){
            mod.department = (xx as! [String])
        }else{
            mod.department = [String]()
        }
        if let xx = commitDic.value(forKey: "position"){
            mod.position = (xx as! [String])
        }else{
            mod.position = [String]()
        }
        if let xx = commitDic.value(forKey: "website"){
            mod.website = (xx as! [String])
        }else{
            mod.website = [String]()
        }
        
        
        if self.backClick{

        }
        
        clickClosure!(mod,self.indexPaths!)
        
    }
    
    
//    func updatePhoneNum()  {
//        //更新到通讯录
//        let per = LJPerson()
//        //公司
//        if nameArray.contains("公司"){
//            var str = ""
//
//            for (index,data) in (self.curModel?.companyArr.enumerated())!{
//                str = str + (self.curModel?.companyArr[index].stringValue)!
//            }
//            per.organizationName = str
//        }
//        //部门
//        if nameArray.contains("部门"){
//            var str = ""
//            for (index,data) in (self.curModel?.positionArr.enumerated())!{
//                str = str + (self.curModel?.companyArr[index].stringValue)!
//            }
//            per.departmentName = str
//        }
//        //名字
//        per.familyName = self.curModel?.realName
//        //地址
//        var addressArr = [LJAddress]()
//        if nameArray.contains("地址"){
//            for (index,data) in (self.curModel?.address.enumerated())!{
//                let Maddress = LJAddress()
//                Maddress.street = self.curModel.address[index].stringValue
//                addressArr.append(Maddress)
//            }
//        }
//        per.addresses = addressArr
//        //url
//        var addressUrlArr = [LJUrlAddress]()
//        if nameArray.contains("网址"){
//            for (index,data) in (self.curModel?.website.enumerated())!{
//                let MUrladdress = LJUrlAddress()
//                MUrladdress.urlString = self.curModel?.website[index].stringValue
//                MUrladdress.label = CNLabelWork
//                addressUrlArr.append(MUrladdress)
//            }
//        }
//        per.urls = addressUrlArr
//        //备注
//        per.note = self.curModel?.remark
//        //email邮箱
//        var emailArr = [LJEmail]()
//        if nameArray.contains("邮箱"){
//            for (index,data) in (self.curModel?.email.enumerated())!{
//                let Memail = LJEmail()
//                Memail.email = self.curModel?.email[index].stringValue
//                Memail.label = CNLabelWork
//                emailArr.append(Memail)
//            }
//        }
//        per.emails = emailArr
//        //手机
//        var PhoneArr = [LJPhone]()
//        if nameArray.contains("手机"){
//            for (index,data) in (self.curModel?.mobile.enumerated())!{
//                let Mphone = LJPhone()
//                Mphone.phone = self.curModel?.mobile[index].stringValue
//                Mphone.label = CNLabelPhoneNumberMobile
//                PhoneArr.append(Mphone)
//            }
//        }
//        //电话
//        if nameArray.contains("电话"){
//            for (index,data) in (self.curModel?.phone.enumerated())!{
//                let Mphone = LJPhone()
//                Mphone.phone = self.curModel?.phone[index].stringValue
//                Mphone.label = CNLabelHome
//                PhoneArr.append(Mphone)
//            }
//        }
//        per.phones = PhoneArr
//        LJContactManager.sharedInstance()?.saveNewContact(withPhoneNum: per)
//    }
//
    
    //检测通讯录中是否有本手机号码和人
    

//        func searchPhone()->Int{
//            //var flag = 1
//            LJContactManager().accessContactsComplection { (boo, peoples) in
//                for (index,value) in (peoples?.enumerated())!{
//                    for (ind,val) in value.phones.enumerated(){
//                        for (i,v) in (self.myModel?.phone.enumerated())!{
//                            //有一个电话号码d就不保存
//                            if val.phone == v.stringValue {
//                                //包含电话号码
//                                self.flag = 100
//
//
//                            }else{
//                                //  self.updatePhoneNum()
//
//
//                            }
//
//                        }
//                    }
//                }
//            }
//
//            return flag
//        }

    
    func updatePhoneNum()  {
        //更新到通讯录
        let per = LJPerson()
        //名字
        if let realName = self.commitDic.value(forKey: "realName") {
            per.familyName =  (realName as! [String]).first
        }else{
            per.familyName = ""
        }
        //备注
        if let remark = self.commitDic.value(forKey: "remark"){
            per.note =  (remark as! [String]).first
        }else{
            per.note = ""
        }
        //公司
        if nameArray.contains("公司"){
            var str = ""
            var arr = [String]()
            arr = self.commitDic.value(forKey: "company") as! [String]
            for (_,data) in (arr.enumerated()){
                str = str + data
            }
            per.organizationName = str
        }
        //部门
        if nameArray.contains("部门"){
            var str = ""
            var arr = [String]()
            arr = self.commitDic.value(forKey: "position") as! [String]
            for (_,data) in (arr.enumerated()){
                str = str + data
            }
            per.departmentName = str
        }
        //地址
        var addressArr = [LJAddress]()
        if nameArray.contains("地址"){
            var arr = [String]()
            arr = self.commitDic.value(forKey: "address") as! [String]
            for (_,data) in arr.enumerated(){
                let Maddress = LJAddress()
                Maddress.street = data
                addressArr.append(Maddress)
            }
        }
        per.addresses = addressArr
        //url
        var addressUrlArr = [LJUrlAddress]()
        if nameArray.contains("网址"){
            var arr = [String]()
            arr = self.commitDic.value(forKey: "website") as! [String]
            for (_,data) in arr.enumerated(){
                let MUrladdress = LJUrlAddress()
                MUrladdress.urlString = data
                MUrladdress.label = CNLabelWork
                addressUrlArr.append(MUrladdress)
            }
        }
        per.urls = addressUrlArr
        //email邮箱
        var emailArr = [LJEmail]()
        if nameArray.contains("邮箱"){
            var arr = [String]()
            arr = self.commitDic.value(forKey: "email") as! [String]
            for (_,data) in arr.enumerated(){
                let Memail = LJEmail()
                Memail.email = data
                Memail.label = CNLabelWork
                emailArr.append(Memail)
            }
        }
        per.emails = emailArr
        //手机
        var PhoneArr = [LJPhone]()
        if nameArray.contains("手机"){
            var arr = [String]()
            arr = self.commitDic.value(forKey: "mobile") as! [String]
            for (_,data) in arr.enumerated(){
                let Mphone = LJPhone()
                Mphone.phone = data
                Mphone.label = CNLabelPhoneNumberMobile
                PhoneArr.append(Mphone)
            }
        }
        //电话
        if nameArray.contains("电话"){
            var arr = [String]()
            arr = self.commitDic.value(forKey: "phone") as! [String]
            for (_,data) in arr.enumerated(){
                let Mphone = LJPhone()
                Mphone.phone = data
                Mphone.label = CNLabelHome
                PhoneArr.append(Mphone)
            }
        }
        per.phones = PhoneArr
        LJContactManager.sharedInstance()?.saveNewContact(withPhoneNum: per)
    }
    
}

// MARK: - 网络请求  获取当前签到状态
extension CQAutoEditBussinessCardVC{
    
    fileprivate func setUpRefresh() {
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/crmBusinessCard/getCardInfo" ,
            type: .get,
            param: ["cardId":self.cardId],
            successCallBack: { (result) in
                guard let model = CQBussinessCardListModel.init(jsonData: result["data"]) else {
                    return
                }
            
                self.dataArray.removeAll()
                self.nameArray.removeAll()
                
                if !model.realName.isEmpty{
                    var nameArr = [String]()
                    nameArr.append(model.realName)
                    self.dataArray.append(nameArr)
                    self.nameArray.append("姓名")
                    self.commitDic.setValue(nameArr, forKey: "realName")
                }
                
                self.telArr.removeAll()
                for modelJson in model.mobile{
                    self.telArr.append(modelJson.stringValue)
                }
                if self.telArr.count > 0{
                    self.dataArray.append(self.telArr)
                    self.nameArray.append("手机")
                    self.commitDic.setValue(self.telArr, forKey: "mobile")
                }
                
                self.phoneArray.removeAll()
                for modelJson in model.phone{
                    self.phoneArray.append(modelJson.stringValue)
                }
                if self.phoneArray.count > 0{
                    self.dataArray.append(self.phoneArray)
                    self.nameArray.append("电话")
                    self.commitDic.setValue(self.phoneArray, forKey: "phone")
                }
                
                self.emailArray.removeAll()
                for modelJson in model.email{
                    self.emailArray.append(modelJson.stringValue)
                }
                if self.emailArray.count > 0{
                    self.dataArray.append(self.emailArray)
                    self.nameArray.append("邮箱")
                    self.commitDic.setValue(self.emailArray, forKey: "email")
                }
                
                self.locaArr.removeAll()
                for modelJson in model.address{
                    self.locaArr.append(modelJson.stringValue)
                }
                if self.locaArr.count > 0{
                    self.dataArray.append(self.locaArr)
                    self.nameArray.append("地址")
                    self.commitDic.setValue(self.locaArr, forKey: "address")
                }
                
                self.companyArray.removeAll()
                for modelJson in model.companyArr{
                    self.companyArray.append(modelJson.stringValue)
                }
                if self.companyArray.count > 0{
                    self.dataArray.append(self.companyArray)
                    self.nameArray.append("公司")
                    self.commitDic.setValue(self.companyArray, forKey: "company")
                }
                
                
                self.departmentArr.removeAll()
                for modelJson in model.department{
                    self.departmentArr.append(modelJson.stringValue)
                }
                if self.departmentArr.count > 0{
                    self.dataArray.append(self.departmentArr)
                    self.nameArray.append("部门")
                    self.commitDic.setValue(self.departmentArr, forKey: "department")
                }
                
                self.positionArr.removeAll()
                for modelJson in model.positionArr{
                    self.positionArr.append(modelJson.stringValue)
                }
                if self.positionArr.count > 0{
                    self.dataArray.append(self.positionArr)
                    self.nameArray.append("职位")
                    self.commitDic.setValue(self.positionArr, forKey: "position")
                }
                
                self.webSiteArr.removeAll()
                for modelJson in model.website{
                    self.webSiteArr.append(modelJson.stringValue)
                }
                if self.webSiteArr.count > 0{
                    self.dataArray.append(self.webSiteArr)
                    self.nameArray.append("网址")
                    self.commitDic.setValue(self.webSiteArr, forKey: "website")
                }
                
                if !model.remark.isEmpty{
                    self.remarkArr.removeAll()
                    self.remarkArr.append(model.remark)
                    self.dataArray.append(self.remarkArr)
                    self.nameArray.append("备注")
                    self.commitDic.setValue(self.remarkArr, forKey: "remark")
                }
                
                self.frontImg.sd_setImage(with: URL(string: model.frontPhoto), placeholderImage:UIImage.init(named: "mpz") )
                self.backImg.sd_setImage(with: URL(string: model.backPhoto), placeholderImage:UIImage.init(named: "mpz") )
                
                self.curModel = model
                //下载q正反面的图片
                self.downloadImageData(front: model.frontPhoto, back: model.backPhoto)
                //自动保存
                self.autoSave = model.autoSave
                self.sw.isOn = model.autoSave
                //
                self.table.reloadData()
                
        }) { (error) in
            self.table.reloadData()
        }
    }
    
    
    func saveCrmContact(dataStr:String){
        let userID = STUserTool.account().userID
        let urlUpload = "\(baseUrl)/crmBusinessCard/cardToCustomer"
        let headers = ["t_userId":userID,
                       "token":STUserTool.account().token]
        
        Alamofire.upload(multipartFormData: { formData in
            var param =   ["userId":userID,
                           "cardStr":dataStr]
            if self.type == 2{
                param = ["userId":userID,
                         "cardStr":dataStr]
            }else {
                param =  ["userId":userID,
                          "cardStr":dataStr]
            }
            
            DLog(param)
            
            for (key, value) in param {
                formData.append((value.data(using: .utf8)!), withName: key)
            }
        }, to: urlUpload, headers: headers, encodingCompletion: {encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    
                    self.loadingSuccess()
                    
                    guard let result = response.result.value else {
                        SVProgressHUD.showError(withStatus: "服务器有点问题")
                        return
                    }
                    let json = JSON(result)
                    if json["success"].boolValue {
                        SVProgressHUD.showInfo(withStatus: json["message"].stringValue)
                    } else {
                        SVProgressHUD.showError(withStatus: json["message"].stringValue)
                    }
                    print(json)
                }
            case .failure( _):
                self.loadingSuccess()
                
               
            }
        })
        
        
    }
    
    
    //上传文件
    @objc func createBussinessCardRequest(dataStr:String)  {
        
        let userID = STUserTool.account().userID
        let urlUpload = "\(baseUrl)/crmBusinessCard/saveCardInfo"
        let headers = ["t_userId":userID,
                       "token":STUserTool.account().token]
        Alamofire.upload(multipartFormData: { formData in
            var param =   ["createId":userID,
                           "cardId":self.cardId,
                           "data":dataStr]
            if self.type == 2{
                 param = ["createId":userID,
                                     "cardId":self.cardId,
                                     "data":dataStr,
                                     "frontPhoto":self.Mmod!.frontPhoto,
                                     "backPhoto":self.Mmod!.backPhoto]
            }else {
               param =  ["createId":userID,
                 "cardId":self.cardId,
                 "data":dataStr,
                 "frontPhoto":self.curModel.frontPhoto,
                 "backPhoto":self.curModel.backPhoto]
            }
 
            DLog(param)
            
                if self.rotationFrontClick {
                    let frontImageData = UIImageJPEGRepresentation(self.downloadFrontImgName!, 0.3)
                    formData.append(frontImageData!, withName: "frontPhoto", fileName:"frontPhoto.png", mimeType: "image/jpg")
                }else{
//                    let frontImageData = UIImageJPEGRepresentation(self.frontImgName, 0.3)
//                    formData.append(frontImageData!, withName: "frontPhoto", fileName:"frontPhoto.png", mimeType: "image/jpg")
                }
                
        
           
                if self.rotationBackClick || self.backClick{
                    let backImageData = UIImageJPEGRepresentation(self.finalBackImgName!, 0.3)
                    formData.append(backImageData!, withName: "backPhoto", fileName:"backPhoto.png", mimeType: "image/jpg")
                }else{
                   
                    
                }
//            if  {
//                let backImageData = UIImageJPEGRepresentation(self.backImgName, 0.3)
//                formData.append(backImageData!, withName: "backPhoto", fileName:"backPhoto.png", mimeType: "image/jpg")
//            }
            
                
            
            
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
                        SVProgressHUD.showInfo(withStatus: "添加成功")
                    } else {
                        SVProgressHUD.showError(withStatus: json["message"].stringValue)
                    }
                    print(json)
                    
                    var tempQrArr = [QRCardInfoModel]()
                    //for modalJson in json["data"] {
                        guard let qrmodal = QRCardInfoModel(jsonData: json["data"]) else {
                            return
                        }
                        tempQrArr.append(qrmodal)
                    //}
                    
                    self.loadingSuccess()
                    if self.type == 2{
                        self.navigationController?.popViewController(animated: true)
                    }else if self.type == 1{
                        let vc = CQBCardStoreStatusVC.init()
                        vc.type = 0
                        vc.recognizeStaues = true
                        vc.dataArray = tempQrArr
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else if self.type == 0{
                        let vc = CQBCardStoreStatusVC.init()
                        vc.type = 0
                        
                        vc.recognizeStaues = true
                        vc.dataArray = tempQrArr
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                   
                }
            case .failure( _):
                SVProgressHUD.showError(withStatus: "上传失败,请稍后重试")
                self.loadingSuccess()
                
                let vc = CQBCardStoreStatusVC.init()
                vc.recognizeStaues = true
                var tempPosition = [String]()
                for xx in self.curModel.positionArr {
                    let str = xx.stringValue
                    tempPosition.append(str)
                }
                
                var companyF = [String]()
                for xx in self.curModel.companyArr {
                    let str = xx.stringValue
                    companyF.append(str)
                }
                
                vc.dataArray = [QRCardInfoModel.init(realName: self.curModel.realName, posit: tempPosition, comp: companyF, icon: self.curModel.frontPhoto, cardId: self.curModel.cardId)]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
    

}

extension CQAutoEditBussinessCardVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CQAutoEditBCardCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "CQAutoEditBCardCellId")
        cell.refreshCellWithRequire(indexPath:indexPath)
        cell.refreshNameWithName(name:self.nameArray[indexPath.section],indexPath:indexPath)
        cell.txtFiled.prevText = self.dataArray[indexPath.section][indexPath.row]
        cell.editDelegate = self
        
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
        if section == 0{
            return AutoGetHeight(height: 10)
        }else{
            return AutoGetHeight(height: 0.01)
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 10)))
        header.backgroundColor = kProjectBgColor
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return AutoGetHeight(height: 10)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 10)))
        footer.backgroundColor = kProjectBgColor
        return footer
    }
}

extension CQAutoEditBussinessCardVC:UIScrollViewDelegate{
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = Int((scrollView.contentOffset.x + UIScreen.main.bounds.width / 2.0) / UIScreen.main.bounds.width)
        self.pageControl.frame = CGRect(x: (kWidth - AutoGetWidth(width: 36))/2 + kWidth * CGFloat(self.pageControl.currentPage), y: AutoGetHeight(height: 183), width: AutoGetWidth(width: 36), height: 10)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

extension CQAutoEditBussinessCardVC:CQBCardAutoEditDelegate{
    func autoEditDelegate(index: IndexPath, text: String) {
        self.dataArray[index.section][index.row] = text
        DLog(self.dataArray[index.section][index.row])
        let key = self.getKeyWithIndex(index: index)
        self.commitDic.setValue(self.dataArray[index.section], forKey: key)
    }
    
    func getKeyWithIndex(index: IndexPath) -> String {
        var key = ""
        if self.nameArray[index.section] == "姓名" {
            key = "realName"
        }else if self.nameArray[index.section] == "手机" {
            key = "mobile"
        }else if self.nameArray[index.section] == "电话" {
            key = "phone"
        }else if self.nameArray[index.section] == "邮箱" {
            key = "email"
        }else if self.nameArray[index.section] == "地址" {
            key = "address"
        }else if self.nameArray[index.section] == "公司" {
            key = "company"
        }else if self.nameArray[index.section] == "部门" {
            key = "department"
        }else if self.nameArray[index.section] == "职位" {
            key = "position"
        }else if self.nameArray[index.section] == "网址" {
            key = "website"
        }else if self.nameArray[index.section] == "备注" {
            key = "remark"
        }
        return key
    }
    
    
}


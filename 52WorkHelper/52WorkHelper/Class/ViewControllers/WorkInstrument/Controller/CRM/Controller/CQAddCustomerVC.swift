//
//  CQAddCustomerVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/8/13.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQAddCustomerVC: SuperVC {
    //声明闭包
    typealias clickBtnClosure = (_ reflash :String) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    
    var model = QRKeHuModel()
    //地址
    var address = ""
    //区域
    var area = ""
    //区域代码
    var areaCode = ""
    //城市
    var city = ""
   
    //客户id
    var customerId = ""
    //客户级别
    var level = ""
    //客户描述信息
    var message = ""
    ///客户名
    var name = ""
    //省市
    var province = ""
    //客户行业
    var trade = ""
    //行业编码
    var tradeCode = ""
    //跟进人数组
    //var userIds[] = ""
    
    //MARK:-联系人数组
    var contcts = [QRContactModel]()
    //跟进人id数组
    var userIds = ""
    //跟进人数组
    var TrackArray  = [CQDepartMentUserListModel]()
    //邮箱
    var email = ""
    //联系人
    var linkName = ""
    //联系人电话
    var linkPhone = ""
    //联系人id
    var linkmanId = ""
    //座机
    var officePhone = ""
    //职务
    var position = ""
    //备注
    var remark = ""
    //性别
    var sex = ""
    
    
    var lastHeight:CGFloat?
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight))
        headView.backgroundColor = kProjectBgColor
        return headView
    }()
    
    lazy var customerInfoLab: UILabel = {
        let customerInfoLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kHaveLeftWidth, height: AutoGetHeight(height: 18)))
        customerInfoLab.text = "客户信息"
        customerInfoLab.textColor = kLyGrayColor
        customerInfoLab.textAlignment = .left
        customerInfoLab.font = kFontSize10
        return customerInfoLab
    }()
    
    lazy var baseInformationV: UIView = {
        let baseInformationV = UIView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 18), width: kWidth, height: AutoGetHeight(height: 220)))
        baseInformationV.backgroundColor = UIColor.white
        return baseInformationV
    }()
    
    
    
    lazy var customerNamextView: CBTextView = {
        let name = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        name.text = "名称"
        name.textColor = UIColor.black
        name.textAlignment = .left
        name.font = kFontSize15
        
        self.baseInformationV.addSubview(name)
        
        let customerNamextView = CBTextView.init(frame:CGRect.init(x: name.right + kLeftDis, y: AutoGetHeight(height: 13), width: (kWidth - AutoGetWidth(width: 110) - 3 * kLeftDis), height: AutoGetHeight(height: 42)))
        customerNamextView.aDelegate = self
        customerNamextView.textView.backgroundColor = UIColor.white
        customerNamextView.textView.font = UIFont.systemFont(ofSize: 15)
        customerNamextView.textView.textColor = UIColor.black
        customerNamextView.textView.textAlignment = .right
        customerNamextView.placeHolder = "请输入客户名称(必填)"
        customerNamextView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        customerNamextView.textView.tag = 1
        return customerNamextView
    }()
    
    lazy var customerAddTxtView: CBTextView = {
        let address = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.customerNamextView.bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        address.text = "地址"
        address.textColor = UIColor.black
        address.textAlignment = .left
        address.font = kFontSize15
        self.baseInformationV.addSubview(address)
        
        let customerAddTxtView = CBTextView.init(frame:CGRect.init(x: address.right + kLeftDis, y:self.customerNamextView.bottom + AutoGetHeight(height: 13), width: (kWidth - AutoGetWidth(width: 110) - 3 * kLeftDis), height: AutoGetHeight(height: 42)))
        customerAddTxtView.aDelegate = self
        customerAddTxtView.textView.backgroundColor = UIColor.white
        customerAddTxtView.textView.font = UIFont.systemFont(ofSize: 15)
        customerAddTxtView.textView.textColor = UIColor.black
        customerAddTxtView.textView.textAlignment = .right
        customerAddTxtView.placeHolder = "输入客户地址"
        customerAddTxtView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        customerAddTxtView.textView.tag = 2
        return customerAddTxtView
    }()
    
    lazy var customerFromSelect: UILabel = {
        let name = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.customerAddTxtView.bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        name.text = "客户来源"
        name.textColor = UIColor.black
        name.textAlignment = .left
        name.font = kFontSize15
        self.baseInformationV.addSubview(name)
        
        let customerFromSelect = UILabel.init(frame: CGRect.init(x: name.right + kLeftDis, y: self.customerAddTxtView.bottom, width: kWidth - AutoGetWidth(width: 110) - 4 * kLeftDis - AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 55)))
        customerFromSelect.text = ""
        customerFromSelect.textColor = UIColor.black
        customerFromSelect.textAlignment = .right
        customerFromSelect.font = kFontSize15
        
        let selectImg = UIImageView.init(frame: CGRect.init(x: customerFromSelect.right + kLeftDis, y:self.customerAddTxtView.bottom + AutoGetHeight(height: 55 - 12)/2, width: AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 12)))
        selectImg.image = UIImage.init(named: "PersonAddressArrow")
        selectImg.isUserInteractionEnabled = true
        self.baseInformationV.addSubview(selectImg)
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: name.right , y: self.customerAddTxtView.bottom, width: kWidth - AutoGetWidth(width: 125), height: AutoGetHeight(height: 55))
        btn.addTarget(self, action: #selector(chooseCustomFrom), for: .touchUpInside)
        self.baseInformationV.addSubview(btn)
        return customerFromSelect
    }()
    
    lazy var customerLevelSelect: UILabel = {
        let name = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.customerFromSelect.bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        name.text = "客户级别"
        name.textColor = UIColor.black
        name.textAlignment = .left
        name.font = kFontSize15
        self.baseInformationV.addSubview(name)
        
        let customerLevelSelect = UILabel.init(frame: CGRect.init(x: name.right + kLeftDis, y: self.customerFromSelect.bottom, width: kWidth - AutoGetWidth(width: 110) - 4 * kLeftDis - AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 55)))
        customerLevelSelect.text = ""
        customerLevelSelect.textColor = UIColor.black
        customerLevelSelect.textAlignment = .right
        customerLevelSelect.font = kFontSize15
        
        let selectImg = UIImageView.init(frame: CGRect.init(x: customerFromSelect.right + kLeftDis, y:self.customerFromSelect.bottom + AutoGetHeight(height: 55 - 12)/2, width: AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 12)))
        selectImg.image = UIImage.init(named: "PersonAddressArrow")
        selectImg.isUserInteractionEnabled = true
        self.baseInformationV.addSubview(selectImg)
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: name.right , y: self.customerFromSelect.bottom, width: kWidth - AutoGetWidth(width: 125), height: AutoGetHeight(height: 55))
        btn.addTarget(self, action: #selector(chooseCustomLevel), for: .touchUpInside)
        self.baseInformationV.addSubview(btn)
        
        return customerLevelSelect
    }()
    
    lazy var customerContactLab: UILabel = {
        let customerContactLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.baseInformationV.bottom, width: kHaveLeftWidth, height: AutoGetHeight(height: 18)))
        customerContactLab.text = "联系人信息"
        customerContactLab.textColor = kLyGrayColor
        customerContactLab.textAlignment = .left
        customerContactLab.font = kFontSize10
        return customerContactLab
    }()

    //统一弄到一个view内
    lazy var contactBaseV: UIView = {
        let contactBaseV = UIView.init(frame: CGRect.init(x: 0, y: self.customerContactLab.bottom, width: kWidth, height: AutoGetHeight(height: 385)))
        contactBaseV.backgroundColor = kProjectBgColor
        return contactBaseV
    }()
    
   //添加联系人做成一个独立的view  删除就移除view 同时用一个属性标记移除 以便于删除数据
    lazy var contactV: CQCustomerContextView = {
        let contactV = CQCustomerContextView.init(frame: CGRect.init(x: 0, y: 0 , width: kWidth, height: AutoGetHeight(height: 385)),haveDeleteBtn:false)

        contactV.selectDelegate = self
        return contactV
    }()
    //联系人数组
    lazy var contactVArr = [CQCustomerContextView]()
    
    
    lazy var addContacterBtn: UIButton = {
        let addContacterBtn = UIButton.init(type: .custom)
        addContacterBtn.frame = CGRect.init(x: 0, y: self.contactBaseV.bottom, width: kWidth, height: AutoGetHeight(height: 44))
        addContacterBtn.setTitle("添加联系人 + ", for: .normal)
        addContacterBtn.backgroundColor = UIColor.white
        addContacterBtn.setTitleColor(kLightBlueColor, for: .normal)
        addContacterBtn.addTarget(self, action: #selector(addContacterClick), for: .touchUpInside)
        return addContacterBtn
    }()
    
    lazy var addFollowMenberLab: UILabel = {
        let addFollowMenberLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.addContacterBtn.bottom, width: kHaveLeftWidth, height: AutoGetHeight(height: 18)))
        addFollowMenberLab.text = "客户跟进人"
        addFollowMenberLab.textColor = kLyGrayColor
        addFollowMenberLab.textAlignment = .left
        addFollowMenberLab.font = kFontSize10
        return addFollowMenberLab
    }()
    
    lazy var attendPersonView: UIView = {
        let attendPersonView = UIView.init(frame: CGRect.init(x: 0, y:self.addFollowMenberLab.bottom + AutoGetHeight(height: 0), width: kWidth, height: AutoGetHeight(height: 145)))
        attendPersonView.backgroundColor = UIColor.white
        return attendPersonView
    }()
    
    lazy var attendPersonLab: UILabel = {
        let attendPersonLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 31), width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 15)))
        attendPersonLab.textColor = UIColor.black
        attendPersonLab.text = "添加客户跟进人"
        attendPersonLab.textAlignment = .left
        attendPersonLab.font = kFontSize15
        return attendPersonLab
    }()
    
    lazy var collectionView: UICollectionView = {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width: kHaveLeftWidth/5, height: AutoGetHeight(height: 75))
        layOut.minimumLineSpacing = 0
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: kLeftDis, y: self.attendPersonLab.bottom + AutoGetHeight(height: 14), width: kHaveLeftWidth, height: AutoGetHeight(height: 84)), collectionViewLayout: layOut)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(QRGenjinCollectionCell.self, forCellWithReuseIdentifier: "QRGenjinCellId")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let NotifMycation = NSNotification.Name(rawValue:"AddTracker")
        NotificationCenter.default.addObserver(self, selector: #selector(upDataChange(notif:)), name: NotifMycation, object: nil)
        
        self.view.backgroundColor = kProjectBgColor
        
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.customerInfoLab)
        self.headView.addSubview(self.baseInformationV)
        self.baseInformationV.addSubview(self.customerNamextView)
        self.baseInformationV.addSubview(self.customerAddTxtView)
        self.baseInformationV.addSubview(self.customerFromSelect)
        self.baseInformationV.addSubview(self.customerLevelSelect)
        
        for i in 0..<2 {
            let line = UIView.init(frame: CGRect.init(x: kLeftDis, y: self.customerAddTxtView.bottom - 0.5 + AutoGetHeight(height: 55) * CGFloat(i), width: kWidth - kLeftDis, height: 0.5))
            line.backgroundColor = kLineColor
            self.baseInformationV.addSubview(line)
        }
        
        self.headView.addSubview(self.customerContactLab)
        self.headView.addSubview(self.contactBaseV)
        self.contactBaseV.addSubview(self.contactV)
        //加入数组
        self.contactVArr.append(self.contactV)
   
        self.headView.addSubview(self.addContacterBtn)
        
        self.headView.addSubview(self.addFollowMenberLab)
        self.headView.addSubview(self.attendPersonView)
        self.attendPersonView.addSubview(self.attendPersonLab)
        self.attendPersonView.addSubview(self.collectionView)
        
       
        
        let rightBut = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(saveEdite))
        rightBut.title = "完成"
        rightBut.tintColor = kBlueC
        self.navigationItem.rightBarButtonItem = rightBut
        
        if customerId == "" {
            self.title = "新建客户"
             self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 54) + baseInformationV.tz_height + contactBaseV.tz_height + addContacterBtn.tz_height  + attendPersonView.tz_height )
        }else{
            self.title = "编辑客户"
            
            //客户,名称,地址,来源,级别 控件赋值
            self.customerNamextView.prevText = model.name
            self.customerAddTxtView.prevText = model.address
            self.customerFromSelect.text = model.message
            self.customerLevelSelect.text = model.level
            //属性赋值
            self.name = model.name
            self.address = model.address
            self.message = model.message
            self.level = model.level
            
            //加入联系人的模型,根据联系人数量穿甲多少个联系人的控件
//            var tempLianXi = [QRContactModel]()
            for (index,value) in model.crmLinkmans.enumerated(){
                if index == 0 {
                }else {
                  self.addContacterClick()
                    
                }
                self.contactVArr[index].contactModel = value
            }
           
            //将数据装换成trackModel然后计算出尺寸collerction
            //将模型改变成use模型
            var tempuser = [CQDepartMentUserListModel]()
            for xx in model.userData{
                let mod = CQDepartMentUserListModel(uId: xx.userId, realN: xx.realName, headImag: xx.headImage)
                print(xx.realName)
                tempuser.append(mod)
            }
            self.TrackArray = tempuser
           //布局
            self.collectionView.frame = CGRect(x: 0, y: Int(attendPersonLab.tz_bottom + AutoGetHeight(height: 14)), width: Int(kWidth), height: ((TrackArray.count)/5+1) * Int(AutoGetHeight(height: 75)) )
            self.attendPersonView.frame = CGRect(x: 0, y: Int(addFollowMenberLab.tz_bottom), width: Int(kWidth), height: Int(collectionView.tz_height + attendPersonLab.tz_bottom + AutoGetHeight(height: 14)))
            self.headView.frame =  CGRect(x: 0, y: 0, width: kWidth, height: baseInformationV.tz_height + addContacterBtn.tz_height +  AutoGetHeight(height: 54) + contactBaseV.tz_height + attendPersonView.tz_height)
            
        }
        
       
        
        
    }
    
    

    //接受通知
    //接收到后执行的方法
    @objc func upDataChange(notif: NSNotification) {
        print(notif)
        
        
        guard let arr: [CQDepartMentUserListModel] = notif.object as! [CQDepartMentUserListModel]? else { return }
        
        var temp = [CQDepartMentUserListModel]()
        for i in 0..<arr.count {
            //添加选中的模型
            temp.append(arr[i])
        }
        self.TrackArray = temp
        
        self.collectionView.reloadData()
        //
        var tempstr = ""
        for (_,value) in self.TrackArray.enumerated(){
            tempstr += value.userId + ","
        }
        if tempstr.last == ","{
            tempstr.removeLast()
        }
  //        self.followPerson = tempstr
//        //改变frame
        ///布局
        self.collectionView.frame = CGRect(x: 0, y: Int(attendPersonLab.tz_bottom + AutoGetHeight(height: 14)), width: Int(kWidth), height: ((TrackArray.count)/5+1) * Int(AutoGetHeight(height: 75)) )
        self.attendPersonView.frame = CGRect(x: 0, y: Int(addFollowMenberLab.tz_bottom), width: Int(kWidth), height: Int(collectionView.tz_height + attendPersonLab.tz_bottom + AutoGetHeight(height: 14)))
        self.headView.frame =  CGRect(x: 0, y: 0, width: kWidth, height: baseInformationV.tz_height + addContacterBtn.tz_height + AutoGetHeight(height: 54) + contactBaseV.tz_height + attendPersonView.tz_height)
        self.table.tableHeaderView = self.headView
        
    }
    
    
    deinit {
    }

    
    
    //MARK:-保存
    
    @objc func saveEdite(){
        //判断字段
        if name == ""  {
            SVProgressHUD.showInfo(withStatus: "请输入客户名称")
            return
        }
        print(contactV.contactModel.linkName)
        if contactV.contactModel.linkName == "" {
            SVProgressHUD.showInfo(withStatus: "第一个联系人的姓名")
            return
        }
        print(OCTool.checkTelNumber(contactV.contactModel.linkPhone))
        let mod = contactVArr.first?.contactModel
        if OCTool.checkTelNumber(mod?.linkPhone) == false {
            SVProgressHUD.showInfo(withStatus: "第一个联系人的电话格式错误")
            return
        }
//        if  OCTool.checkOfficeTel(mod?.officePhone) == false {
//            SVProgressHUD.showInfo(withStatus: "第一个联系人的座机格式错误")
//            return
//        }
        loadEditeOrAdd()
    }
    
    @objc func chooseCustomFrom()  {
        DLog("客户来源点击")
        let items = ["网络营销","电话营销","渠道代理","线下拜访","亲朋好友","会议营销","其他"]
        let vProperty = FWSheetViewProperty()
        vProperty.touchWildToHide = "1"
        let sheetView = FWSheetView.sheet(title:"", itemTitles: items, itemBlock: { [unowned self] (popupView, index, title) in
            //编辑商机
           self.message = items[index]
            self.customerFromSelect.text = items[index]
        }, cancenlBlock: {
            print("点击了取消")
        }, property: vProperty)
        sheetView.show()
        
    }
    
    @objc func chooseCustomLevel()  {
        DLog("客户级别点击")
        let items = ["潜在客户","初步接触","持续跟进","成交客户","忠诚客户","无效客户","其他"]
        let vProperty = FWSheetViewProperty()
        vProperty.touchWildToHide = "1"
        let sheetView = FWSheetView.sheet(title:"", itemTitles: items, itemBlock: {[unowned self]  (popupView, index, title) in
            //编辑商机
            self.level = items[index]
            self.customerLevelSelect.text = items[index]
            
            
        }, cancenlBlock: {
            print("点击了取消")
        }, property: vProperty)
        sheetView.show()
    }
    
    @objc func addContacterClick() {
        DLog("添加联系人点击")
        let contact =  CQCustomerContextView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 385) + CGFloat(self.contactVArr.count - 1) * AutoGetHeight(height: 403) , width: kWidth, height: AutoGetHeight(height: 403)), haveDeleteBtn: true)
        //记录当时的y值然后数组中的重新布局
        contact.arrIndex = self.contactVArr.count
        contact.deleteDalegate = self
        contact.selectDelegate = self
        self.contactBaseV.addSubview(contact)
        //加入数组
        self.contactVArr.append(contact)
        self.contactBaseV.frame = CGRect.init(x: 0, y: self.customerContactLab.bottom, width: kWidth, height: AutoGetHeight(height: 385) + CGFloat(self.contactVArr.count - 1) * AutoGetHeight(height: 403))
        self.addContacterBtn.frame = CGRect.init(x: 0, y: self.contactBaseV.bottom, width: kWidth, height: AutoGetHeight(height: 44))
        self.addFollowMenberLab.frame = CGRect.init(x: kLeftDis, y: self.addContacterBtn.bottom, width: kHaveLeftWidth, height: AutoGetHeight(height: 18))
        
        
        self.collectionView.frame = CGRect(x: 0, y: Int(attendPersonLab.tz_bottom + AutoGetHeight(height: 14)), width: Int(kWidth), height: ((TrackArray.count)/5+1) * Int(AutoGetHeight(height: 75)) )
        self.attendPersonView.frame = CGRect(x: 0, y: Int(addFollowMenberLab.tz_bottom), width: Int(kWidth), height: Int(collectionView.tz_height + attendPersonLab.tz_bottom + AutoGetHeight(height: 14)))
        self.headView.frame =  CGRect(x: 0, y: 0, width: kWidth, height: baseInformationV.tz_height + addContacterBtn.tz_height + AutoGetHeight(height: 54) + contactBaseV.tz_height + attendPersonView.tz_height)
        self.table.tableHeaderView = self.headView
    }

    //MARK:-请求
    func loadEditeOrAdd(){
        SVProgressHUD.show()
        //跟进人模型数组中截取到用户id数组
        var tempID = ""
        for (index,value) in TrackArray.enumerated(){
             tempID += value.userId + ","
            if index == TrackArray.count - 1{
                tempID.removeLast()
            }
        }
        self.userIds = tempID
        
        
        //获取联系人数组
        var temp = [[String :Any ]]()
         var tempArr = [QRContactModel]()
        for (_,value) in self.contactVArr.enumerated(){
            tempArr.append(value.contactModel)
        }
         self.contcts = tempArr
        
        if contcts.count>0{
            //将数组中的模型转成json
            for (_,xx) in contcts.enumerated() {
                let para = ["email":xx.email, "linkName":xx.linkName, "linkPhone":xx.linkPhone, "linkmanId":xx.linkmanId, "officePhone":xx.officePhone, "position":xx.position,"remark":xx.remark,"sex":xx.sex]
                     temp.append(para)
            }
        }
        let linkMans = JSON(temp)
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmCustomer/saveOrUpdateCrmCustomer", type:.post, param: ["address":address,"area":area,"areaCode":areaCode,"city":city,"customerId":customerId,"level":level,"message":message,"name":name,"province":province,"trade":trade,"tradeCode":tradeCode,"userId":userID,"userIds[]":self.userIds,"crmLinkmanData":linkMans,], successCallBack: { (result) in
            if result["success"].boolValue == true {
            SVProgressHUD.dismiss()
           
               //回调刷新
                
                if self.customerId == ""{
                     SVProgressHUD.showInfo(withStatus: "添加客户成功")
                }else{
                    SVProgressHUD.showInfo(withStatus: "编辑客户成功")
                }
                self.clickClosure!("yes")
                
            self.navigationController?.popViewController(animated: true)
            }
        
        }) { (error) in
            print(error)
            SVProgressHUD.showInfo(withStatus: "添加客户失败")
        }
        
        
    }
    

    
}


extension CQAddCustomerVC:CQCustomerContextViewSexSelectDelegate{
    func selectSEX(sexSelect: UILabel, fatherV: CQCustomerContextView) {
        //0未知1男2女
        let items = ["男","女"]
        let vProperty = FWSheetViewProperty()
        vProperty.touchWildToHide = "1"
        let sheetView = FWSheetView.sheet(title:"", itemTitles: items, itemBlock: { (popupView, index, title) in
            //编辑商机
           fatherV.contactModel.sex = "\(index)"
           sexSelect.text = items[index]
        }, cancenlBlock: {
            print("点击了取消")
        }, property: vProperty)
        sheetView.show()
    }
    

    
       
}


extension CQAddCustomerVC:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //判断有几个模型
      

        if  textView.tag == 1 {
            //客户名称
            self.name = textView.text
        }
        if  textView.tag == 2 {
            //地址
           self.address = textView.text
        }
    
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        
        if  textView.tag == 1 {
            //客户名称
            self.name = textView.text
        }
        if  textView.tag == 2 {
            //地址
            self.address = textView.text
        }

    }
}



// MARK: - 代理

extension CQAddCustomerVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.TrackArray.count+1
    }
    
}

extension CQAddCustomerVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QRGenjinCellId", for: indexPath) as! QRGenjinCollectionCell
        cell.location.isHidden = true
        if self.TrackArray.count == 0 {
            if indexPath.item == 0{
                cell.img.image = UIImage.init(named: "CQAddMenberIcon")
                cell.deleteBtn.isHidden = true
                cell.name.isHidden = true
            }
        }else {
            if indexPath.item == self.TrackArray.count {
                cell.img.image = UIImage.init(named: "CQAddMenberIcon")
                cell.deleteBtn.isHidden = true
                cell.name.isHidden = true
            }else {
                //  图片赋值
                let mod = self.TrackArray[indexPath.row]
                cell.img.sd_setImage(with: URL(string:mod.headImage), placeholderImage: UIImage(named:"personDefaultIcon"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
                cell.name.isHidden = false
                cell.name.text = mod.realName
                cell.deleteBtn.isHidden = false
                cell.deleteDelegate = self
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.TrackArray.count == 0 {
            if indexPath.item == 0 {
                //跳转通讯录
                let contact = QRAddressBookVC()
                contact.hasSelectModelArr = self.TrackArray
                contact.toType = ToAddressBookType.fromGenJin
                self.navigationController?.pushViewController(contact, animated: true)
            }
        }else{
            if indexPath.item == self.TrackArray.count{
                // 跳转通讯录
                let contact = QRAddressBookVC()
                contact.hasSelectModelArr = self.TrackArray
                contact.toType = ToAddressBookType.fromGenJin
                self.navigationController?.pushViewController(contact, animated: true)
            }else{
                
            }
        }
    }
}
extension CQAddCustomerVC:UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//     self.table.endEditing(true)
    }
}

extension CQAddCustomerVC :QRGenjinCollectionCellDeleteDelegate{
    func deletePublishPic(index: IndexPath) {
        self.TrackArray.remove(at: index.row)
        collectionView.reloadData()
    }
}
extension CQAddCustomerVC : CQCustomerContextViewDeleteDelegate{
    func delete(deleteBut: UIButton, fatherV: CQCustomerContextView) {
        //重新布局
        let indexx = fatherV.arrIndex
        self.contactVArr.remove(at: indexx!)
        //for循环重新处理各个的frame
        for (index,value) in self.contactVArr.enumerated(){
            if index == 0{
            value.frame =  CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 403))
            }else{
            value.frame =  CGRect(x: 0, y: AutoGetHeight(height: 385) + CGFloat(index-1) * AutoGetHeight(height: 403), width: kWidth, height: AutoGetHeight(height: 403))
            value.arrIndex = index
            }
        }
        //记录当时的y值然后数组中的重新布局
        
        self.contactBaseV.frame = CGRect.init(x: 0, y: self.customerContactLab.bottom, width: kWidth, height: AutoGetHeight(height: 385) + CGFloat(self.contactVArr.count - 1) * AutoGetHeight(height: 403))
        // self.lastHeight = self.contactBaseV.tz_height
        self.addContacterBtn.frame = CGRect.init(x: 0, y: self.contactBaseV.bottom, width: kWidth, height: AutoGetHeight(height: 44))
        self.addFollowMenberLab.frame = CGRect.init(x: kLeftDis, y: self.addContacterBtn.bottom, width: kHaveLeftWidth, height: AutoGetHeight(height: 18))
        
        
        self.collectionView.frame = CGRect(x: 0, y: Int(attendPersonLab.tz_bottom + AutoGetHeight(height: 14)), width: Int(kWidth), height: ((TrackArray.count)/5+1) * Int(AutoGetHeight(height: 75)) )
        self.attendPersonView.frame = CGRect(x: 0, y: Int(addFollowMenberLab.tz_bottom), width: Int(kWidth), height: Int(collectionView.tz_height + attendPersonLab.tz_bottom + AutoGetHeight(height: 14)))
        self.headView.frame =  CGRect(x: 0, y: 0, width: kWidth, height: baseInformationV.tz_height + addContacterBtn.tz_height + AutoGetHeight(height: 54) + contactBaseV.tz_height + attendPersonView.tz_height)
        self.table.tableHeaderView = self.headView
        
    }
}


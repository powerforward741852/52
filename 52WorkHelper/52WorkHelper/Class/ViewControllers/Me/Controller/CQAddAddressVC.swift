//
//  CQAddAddressVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/4.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

/// 地址编辑类型枚举
enum addressFrom {
    case add
    case update
    case detail
}

class CQAddAddressVC: SuperVC {

    var type:addressFrom?
    var entityId = ""//地址主键
    //datepicker一系列控件及参数
    var bgView = UIButton()
    
    //公共picker
    var pickView:UIPickerView?
    
    //所有地址数据集合
    var addressArray = [[String: AnyObject]]()
    
    //选择的省索引
    var provinceIndex = 0
    //选择的市索引
    var cityIndex = 0
    //选择的县索引
    var areaIndex = 0
    
    //选中联系人model
    var overTimeModel:CQDepartMentUserListModel?
    
    //选中城市
    var areaName = ""
    
    var rightBtn:UIButton?
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y:0 + AutoGetHeight(height: 13), width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        table.backgroundColor = UIColor.colorWithHexString(hex: "#f7f7f7")
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 0), width: kWidth, height: AutoGetHeight(height: 307)))
        headView.backgroundColor = UIColor.white
        return headView
    }()
    
    lazy var contactLab: UILabel = {
        let contactLab = UILabel.init(frame: CGRect.init(x:kLeftDis, y: 0, width: AutoGetWidth(width: 65), height: AutoGetHeight(height: 55)))
        contactLab.textColor = UIColor.black
        contactLab.text = "联系人"
        contactLab.textAlignment = .left
        contactLab.font = kFontSize15
        return contactLab
    }()
    
    lazy var contactField: MyTextField = {
        let contactField = MyTextField.init(frame: CGRect.init(x: self.contactLab.right + kLeftDis, y: 0, width: kWidth - AutoGetWidth(width: 110) - AutoGetWidth(width: 46), height: AutoGetHeight(height: 55)))
        contactField?.delegate = self
        contactField?.clearButtonMode = .never
        contactField?.keyBoardDelegate = self
        contactField?.font = kFontSize15
        contactField?.textColor = UIColor.black
        contactField?.tintColor = UIColor.black
        contactField?.placeholder = "请输入或选择联系人"
        contactField?.keyboardType = .default
        
        return contactField!
    }()
    
    lazy var contactBtn:UIButton = {
        let contactBtn = UIButton.init(type: .custom)
        contactBtn.frame = CGRect.init(x: kWidth-AutoGetWidth(width: 46), y: 0, width: AutoGetWidth(width: 46), height: AutoGetHeight(height: 55))
        contactBtn.setImage(UIImage.init(named: "PersonAddressContact"), for: .normal)
        contactBtn.addTarget(self, action: #selector(contactClick), for: .touchUpInside)
        return contactBtn
    }()
    
    lazy var telLab: UILabel = {
        let telLab = UILabel.init(frame: CGRect.init(x:kLeftDis, y: self.contactLab.bottom, width: AutoGetWidth(width: 65), height: AutoGetHeight(height: 55)))
        telLab.textColor = UIColor.black
        telLab.text = "手机号码"
        telLab.textAlignment = .left
        telLab.font = kFontSize15
        return telLab
    }()
    
    lazy var telField: MyTextField = {
        let telField = MyTextField.init(frame: CGRect.init(x: self.contactLab.right + kLeftDis, y: self.contactLab.bottom, width: kWidth - AutoGetWidth(width: 110) - AutoGetWidth(width: 38), height: AutoGetHeight(height: 55)))
        telField?.delegate = self
        telField?.clearButtonMode = .never
        telField?.keyBoardDelegate = self
        telField?.font = kFontSize15
        telField?.textColor = UIColor.black
        telField?.tintColor = UIColor.black
        telField?.placeholder = "请输入手机号"
        telField?.keyboardType = .numberPad
        
        return telField!
    }()
    
    lazy var chooseAreaLab: UILabel = {
        let chooseAreaLab = UILabel.init(frame: CGRect.init(x:kLeftDis, y: self.telLab.bottom, width: AutoGetWidth(width: 65), height: AutoGetHeight(height: 55)))
        chooseAreaLab.textColor = UIColor.black
        chooseAreaLab.text = "选择地区"
        chooseAreaLab.textAlignment = .left
        chooseAreaLab.font = kFontSize15
        return chooseAreaLab
    }()
    
    lazy var chooseAreaBtn: UIButton = {
        let chooseAreaBtn = UIButton.init(type: .custom)
        chooseAreaBtn.frame = CGRect.init(x: self.chooseAreaLab.right + kLeftDis, y: self.telLab.bottom, width: kWidth - AutoGetWidth(width: 95), height: AutoGetHeight(height: 55))
        chooseAreaBtn.setTitle("请选择地区", for: .normal)
        chooseAreaBtn.setTitleColor(kLyGrayColor, for: .normal)
        chooseAreaBtn.titleLabel?.textAlignment = .left
        chooseAreaBtn.titleLabel?.font = kFontSize15
        chooseAreaBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -AutoGetWidth(width: 200), bottom: 0, right: AutoGetWidth(width: 0))
        chooseAreaBtn.addTarget(self, action: #selector(chooseAreaClick), for: .touchUpInside)
        return chooseAreaBtn
    }()
    
    lazy var arrowBtn:UIButton = {
        let arrowBtn = UIButton.init(type: .custom)
        arrowBtn.frame = CGRect.init(x: kWidth-AutoGetWidth(width: 36.5), y: self.chooseAreaLab.bottom, width: AutoGetWidth(width: 36.5), height: AutoGetHeight(height: 55))
        arrowBtn.setImage(UIImage.init(named: "PersonAddressArrow"), for: .normal)
        return arrowBtn
    }()
    
    lazy var codeLab: UILabel = {
        let codeLab = UILabel.init(frame: CGRect.init(x:kLeftDis, y: self.chooseAreaLab.bottom, width: AutoGetWidth(width: 65), height: AutoGetHeight(height: 55)))
        codeLab.textColor = UIColor.black
        codeLab.text = "邮政编码"
        codeLab.textAlignment = .left
        codeLab.font = kFontSize15
        return codeLab
    }()
    
    lazy var codeField: MyTextField = {
        let codeField = MyTextField.init(frame: CGRect.init(x: self.contactLab.right + kLeftDis, y: self.chooseAreaLab.bottom, width: kWidth - AutoGetWidth(width: 110) - AutoGetWidth(width: 38), height: AutoGetHeight(height: 55)))
        codeField?.delegate = self
        codeField?.clearButtonMode = .never
        codeField?.keyBoardDelegate = self
        codeField?.font = kFontSize15
        codeField?.textColor = UIColor.black
        codeField?.tintColor = UIColor.black
        codeField?.placeholder = "请输入邮政编码"
        codeField?.keyboardType = .numberPad
        
        return codeField!
    }()
    
    lazy var detailAddressLab: UILabel = {
        let detailAddressLab = UILabel.init(frame: CGRect.init(x:kLeftDis, y: self.codeLab.bottom, width: AutoGetWidth(width: 65), height: AutoGetHeight(height: 55)))
        detailAddressLab.textColor = UIColor.black
        detailAddressLab.text = "详细地址"
        detailAddressLab.textAlignment = .left
        detailAddressLab.font = kFontSize15
        return detailAddressLab
    }()
    
   
    lazy var detailAddressTextView: CBTextView = {
        let detailAddressTextView = CBTextView.init(frame: CGRect.init(x: self.contactLab.right + kLeftDis, y: self.codeLab.bottom, width: kWidth - AutoGetWidth(width: 110) - AutoGetWidth(width: 38), height: AutoGetHeight(height: 87)))
        detailAddressTextView.aDelegate = self
        detailAddressTextView.textView.backgroundColor = UIColor.white
        detailAddressTextView.textView.font = UIFont.systemFont(ofSize: 15)
        detailAddressTextView.textView.textColor = UIColor.black
        
        detailAddressTextView.placeHolder = "请输入详细街道"
        detailAddressTextView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        
        return detailAddressTextView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //初始化数据
        let path = Bundle.main.path(forResource: "address", ofType:"plist")
        self.addressArray = NSArray(contentsOfFile: path!) as! Array
        
        
        
        if type == .add{
            self.title = "新增地址"
            rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
            rightBtn?.sizeToFit()
            rightBtn!.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
            rightBtn?.setTitle("保存", for: .normal)
            rightBtn?.setTitleColor(UIColor.colorWithHexString(hex: "#20afff"), for: .normal)
            rightBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            rightBtn?.addTarget(self, action: #selector(storeClick), for: .touchUpInside)
            let rightItem = UIBarButtonItem.init(customView: rightBtn!)
            self.navigationItem.rightBarButtonItem = rightItem
        }else if type == .update{
            self.title = "编辑地址"
            self.loadAddressDataRequest()
            rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
            rightBtn?.sizeToFit()
            rightBtn?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
            rightBtn?.setTitle("保存", for: .normal)
            rightBtn?.setTitleColor(UIColor.colorWithHexString(hex: "#20afff"), for: .normal)
            rightBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            rightBtn?.addTarget(self, action: #selector(storeClick), for: .touchUpInside)
            let rightItem = UIBarButtonItem.init(customView: rightBtn!)
            self.navigationItem.rightBarButtonItem = rightItem
        }else if type == .detail{
            self.title = "地址详情"
            self.loadAddressDataRequest()
            let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
            rightBtn.setImage(UIImage.init(named: "CQWorkInstrumentShare"), for: .normal)
            rightBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
            rightBtn.addTarget(self, action: #selector(deleteClick), for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)

        }
        
        
        
        
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.contactLab)
        self.headView.addSubview(self.contactField)
        self.headView.addSubview(self.contactBtn)
        self.headView.addSubview(self.telLab)
        self.headView.addSubview(self.telField)
        self.headView.addSubview(self.chooseAreaLab)
        self.headView.addSubview(self.chooseAreaBtn)
//        self.headView.addSubview(self.arrowBtn)
        self.headView.addSubview(self.codeLab)
        self.headView.addSubview(self.codeField)
        self.headView.addSubview(self.detailAddressLab)
        self.headView.addSubview(self.detailAddressTextView)
        
        self.initLineview()
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEditChanged(obj:)), name: Notification.Name.UITextViewTextDidChange, object: nil)
        
        let NotifMycation2 = NSNotification.Name(rawValue:"refreshAddAddressVC")
        NotificationCenter.default.addObserver(self, selector: #selector(overChange(notif:)), name: NotifMycation2, object: nil)
    }
    
    func initLineview()  {
        for i in 1..<5 {
            let line = UIView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 55) * CGFloat(i) - 0.5, width: kWidth - kLeftDis, height: 0.5))
            line.backgroundColor = kProjectBgColor
            self.headView.addSubview(line)
        }
    }
    
    @objc func storeClick()  {
        self.view.endEditing(true)
        var detail = self.detailAddressTextView.textView.text
        if self.detailAddressTextView.placeHolder == detail{
            detail = ""
        }
        if (self.contactField.text?.count)!>0 && (self.telField.text?.count)! > 0 && self.areaName.count > 0
            && (self.codeField.text?.count)! > 0 && (detail?.count)! > 0{
            guard let phoneNum = self.telField.text else {
                return
            }
            if cherkPhoneNum(num: phoneNum) {
                addAddressRequest()
            }else{
                SVProgressHUD.showInfo(withStatus: "请输入正确手机号")
            }
        }else{
            if (self.contactField.text?.isEmpty)! {
                SVProgressHUD.showInfo(withStatus: "请输入或选择联系人")
            }else if (self.telField.text?.isEmpty)! {
                SVProgressHUD.showInfo(withStatus: "请输入手机号")
            }else if self.areaName.isEmpty {
                SVProgressHUD.showInfo(withStatus: "请选择地区")
            }else if (self.codeField.text?.isEmpty)! {
                SVProgressHUD.showInfo(withStatus: "请输入邮政编码")
            }else if self.detailAddressTextView.prevText?.isEmpty == true{
                SVProgressHUD.showInfo(withStatus: "请输入详细街道")
            }
        }
        
        
        
        
    }
    
    @objc func deleteClick()  {
        addAddressRequest()
    }
    
    @objc func chooseAreaClick()  {
        self.initPickView(tag: 500)
        
    }
    
    @objc func contactClick()  {
        let vc = QRAddressBookVC.init()
        vc.toType = .fromContact
        vc.titleStr = "选择联系人"
        if self.overTimeModel != nil{
            vc.hasSelectModelArr = [self.overTimeModel] as! [CQDepartMentUserListModel]
        }
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
   
    //接收加班人
    @objc func overChange(notif: NSNotification) {
        guard let model: CQDepartMentUserListModel = notif.object as? CQDepartMentUserListModel else { return }
        
        self.overTimeModel = model
        self.contactField.text = model.realName
       self.loadData(userId: model.userId)
    }
    //数据加载
    func loadData(userId:String)  {
        
        SVProgressHUD.show()
    STNetworkTools.requestData(URLString:"\(baseUrl)/mailList/getPersonDetails" ,
            type: .get,
            param: ["userId": userId],
            successCallBack: { (result) in
                
//                guard let model = CQPersonInfoMationModel.init(jsonData: result["data"]) else {
//                    return
//                }
                
                guard let dModel = CQDepartMentUserListModel.init(jsonData: result["data"]) else {
                    return
                }
                self.telField.text = dModel.userName
                SVProgressHUD.dismiss()
                
        }) { (error) in
                SVProgressHUD.dismiss()
        }
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    
    func initShareView()  {
        let shareV = CQShareView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - CGFloat(SafeAreaBottomHeight)))
        shareV.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
        shareV.cqShareDelegate = self
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.addSubview(shareV)
    }
    
}

extension CQAddAddressVC:CQShareDelegate{
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
        
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: "xxxx",
                                          images : UIImage.init(named: "1024"),
                                          url : NSURL(string:"www.baidu.com") as URL?,
                                          title : "xxxx",
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


// Mark :添加发票请求
extension CQAddAddressVC{
    func addAddressRequest()  {
        let userID = STUserTool.account().userID
        var opt = ""
        if type == .add {
            opt = "add"
        }else if type == .update{
            opt = "update"
        }else if type == .detail{
          //  opt = "del"
          //分享
            initShareView()
            
            return
        }
        
        STNetworkTools.requestData(URLString: "\(baseUrl)/my/updateMyAddress",
            type: .post,
            param: ["emyeId":userID,
                    "addressCity":self.areaName,
                    "addressDetails": self.detailAddressTextView.prevText ?? "",
                    "cityCode":self.codeField.text ?? "",
                    "contactName":self.contactField.text ?? "",
                    "mobilePhone":self.telField.text ?? "",
                    "opt":opt,
                    "entityId":self.entityId],
            successCallBack: { (result) in
                if self.type == .add {
                    opt = "add"
                    SVProgressHUD.showInfo(withStatus: "添加成功")
                }else if  self.type == .update{
                    opt = "update"
                    SVProgressHUD.showInfo(withStatus: "更新成功")
                }else if  self.type == .detail{
                    opt = "del"
                    SVProgressHUD.showInfo(withStatus: "删除成功")
                }
                
                self.navigationController?.popViewController(animated: true)
        }) { (error) in
            
        }
    }
    
    func loadAddressDataRequest()  {
        
        STNetworkTools.requestData(URLString: "\(baseUrl)/my/getMyAddressInfo",
            type: .get,
            param: ["entityId":self.entityId],
            successCallBack: { (result) in
                guard let model = CQAddressModel.init(jsonData: result["data"]) else {
                    return
                }
                self.contactField.text = model.contactName
                self.telField.text = model.mobilePhone
                self.chooseAreaBtn.setTitle(model.addressCity, for: .normal)
                self.chooseAreaBtn.setTitleColor(UIColor.black, for: .normal)
                self.areaName = model.addressCity
                self.chooseAreaBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -AutoGetWidth(width: 150), bottom: 0, right: AutoGetWidth(width: 0))
                self.codeField.text = model.cityCode
                self.detailAddressTextView.prevText = model.addressDetails
        }) { (error) in
            
        }
    }
}

//  Mark:UIPickView构造    点击事件与datepicker共用
extension CQAddAddressVC{
    func initPickView(tag:Int)  {
        self.view.endEditing(true)
        bgView.frame = CGRect(x: 0, y: 64, width: kWidth, height: kHeight - 64)
        bgView.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
        self.view.addSubview(bgView)
        bgView.addTarget(self, action: #selector(removeBgView), for: .touchUpInside)
        
        let colorBgV = UIView.init(frame: CGRect.init(x: 0, y: bgView.tz_height - 240, width: kWidth, height: 240))
        colorBgV.backgroundColor = UIColor.white
        bgView.addSubview(colorBgV)
        
        let sureBtn = UIButton()
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(.black, for: .normal)
        sureBtn.frame = CGRect(x: kWidth - 60, y: 0, width: 60, height: 40)
        sureBtn.tag = 700 + tag
        colorBgV.addSubview(sureBtn)
        sureBtn.addTarget(self, action: #selector(sureClick(btn:)), for: .touchUpInside)
        
        let cancelBtn = UIButton()
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(.black, for: .normal)
        cancelBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        colorBgV.addSubview(cancelBtn)
        cancelBtn.addTarget(self, action: #selector(removeBgView(sender:)), for: .touchUpInside)
        
        self.pickView = UIPickerView.init(frame: CGRect.init(x: 0, y: 40, width: kWidth, height: 200))
        pickView?.delegate = self
        pickView?.dataSource = self
        pickView?.tag = 500 + tag
        pickView?.selectedRow(inComponent: 0)
        colorBgV.addSubview(pickView!)
    }
    
    @objc func removeBgView(sender: UIButton) {
        self.bgView.removeAllSubviews()
        self.bgView.removeFromSuperview()
        self.provinceIndex = 0
        self.cityIndex = 0
        self.areaIndex = 0
    }
    
    @objc func sureClick(btn:UIButton) {
        var message = ""
        //获取选中的省
        let p = self.addressArray[provinceIndex]
        let province = p["state"] as! String
        //获取选中的市
        let c = (p["cities"] as! NSArray)[cityIndex] as! [String:AnyObject]
        let city = c["city"] as! String
        //获取选中的县（地区）
        var area = ""
        if (c["areas"] as! [String]).count > 0{
            area = (c["areas"] as! [String])[areaIndex]
            message = "\(province) - \(city) - \(area)"
        }else{
            message = "\(province) - \(city) "
        }
        
        
        self.areaName = message
        self.chooseAreaBtn.setTitle(message, for: .normal)
        chooseAreaBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -AutoGetWidth(width: 130), bottom: 0, right: AutoGetWidth(width: 0))
        self.chooseAreaBtn.setTitleColor(UIColor.black, for: .normal)
        self.bgView.removeAllSubviews()
        self.bgView.removeFromSuperview()
        self.provinceIndex = 0
        self.cityIndex = 0
        self.areaIndex = 0
    }
}

//  MARK:pickViewDelegate
extension CQAddAddressVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.addressArray.count
        } else if component == 1 {
            let province = self.addressArray[provinceIndex]
            return province["cities"]!.count
        } else {
            let province = self.addressArray[provinceIndex]
            if let city = (province["cities"] as! NSArray)[cityIndex]
                as? [String: AnyObject] {
                return city["areas"]!.count
            } else {
                return 0
            }
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return self.addressArray[row]["state"] as? String
        }else if component == 1 {
            let province = self.addressArray[provinceIndex]
            let city = (province["cities"] as! NSArray)[row]
                as! [String: AnyObject]
            return city["city"] as? String
        }else {
            let province = self.addressArray[provinceIndex]
            let city = (province["cities"] as! NSArray)[cityIndex]
                as! [String: AnyObject]
            return (city["areas"] as! NSArray)[row] as? String
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            //根据列、行索引判断需要改变数据的区域
            switch (component) {
            case 0:
                provinceIndex = row;
                cityIndex = 0;
                areaIndex = 0;
                pickerView.reloadComponent(1);
                pickerView.reloadComponent(2);
                pickerView.selectRow(0, inComponent: 1, animated: false)
                pickerView.selectRow(0, inComponent: 2, animated: false)
            case 1:
                cityIndex = row;
                areaIndex = 0;
                pickerView.reloadComponent(2);
                pickerView.selectRow(0, inComponent: 2, animated: false)
            case 2:
                areaIndex = row;
            default:
                break;
            }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return kWidth/3
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return AutoGetHeight(height: 40)
    }
    
}

extension CQAddAddressVC:UITextFieldDelegate,KeyBoardDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    @objc func textFieldEditChanged(obj:Notification)  {
        
    }
    
    
}


extension CQAddAddressVC:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
}

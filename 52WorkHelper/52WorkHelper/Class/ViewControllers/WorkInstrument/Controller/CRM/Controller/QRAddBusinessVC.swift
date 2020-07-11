//
//  QRAddBusinessVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/7.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRAddBusinessVC: SuperVC {
    
    
    //声明闭包
    typealias clickBtnClosure = (_ text:String ) -> Void
    //把申明的闭包设置成属性
    var clickClosure : clickBtnClosure?
    
    
    //跟进人数组
    var TrackArray  = [CQDepartMentUserListModel]()
 
    var detailModel = QRDetailBusinessMdel()
     var lastHeight:CGFloat?
    //日期选择器
    var bgView = UIButton()
    var startTime = "" //开始时间
    var endTime = ""  //结束时间
    var carId:Int = 0  //车辆类型id
    var carName = ""  //车辆类型描述
    
    var businessTypeARR = [String]()
    var businessIDARR = [String]()
    var saleStageARR = [String]()
    //MARK:-  记录属性
    //商机名字
    var businessName = ""
    //商机类型
    var businessType = ""
    //商机概要
    var businessDetail = ""
    //客户名称
    var CustomerName = ""
    //预计金额
    var AmountMoney = ""
    //销售阶段
    var sale = ""
    //预计结单时间
    var end = ""
    //重要程度
    var important = ""
    //联系人
    var lianXi = ""
    //联系人主键
    var lianXiPerson = ""
    //
    var lianxiPhone = ""
    //竞争对手
    var competite = ""
    //跟进人
    var followPerson = ""
    //联系人mod
    var LianxirenMod = QRLianXiRenModel()
    //决策人姓名
    var decisionName = ""
    //决策人电话
    var decisionPhone = ""
    //客户主键
    var crmCustomer :String = ""
    //商机id
    var entityId = ""
    //opt
    var opt = "add"
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.delegate = self
        return table
    }()

    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight))
        headView.backgroundColor = UIColor.white
        return headView
    }()
    //第一行灰线
    lazy var customerInfoLab: UILabel = {
        let customerInfoLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kHaveLeftWidth, height: AutoGetHeight(height: 18)))
        customerInfoLab.text = ""
        customerInfoLab.textColor = kLyGrayColor
        customerInfoLab.textAlignment = .left
        customerInfoLab.font = kFontSize10
        return customerInfoLab
    }()
    //第一组容器
    lazy var baseInformationV: UIView = {
        let baseInformationV = UIView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 18), width: kWidth, height: AutoGetHeight(height: 495)))
        baseInformationV.backgroundColor = UIColor.white
        return baseInformationV
    }()
    //第一组视图
    lazy var customerNamextView: CBTextView = {
        let name = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        name.text = "商机名称"
        name.textColor = UIColor.black
        name.textAlignment = .left
        name.font = kFontSize15
        self.baseInformationV.addSubview(name)
        
        let customerNamextView = CBTextView.init(frame:CGRect.init(x: name.right + kLeftDis, y: AutoGetHeight(height: 13), width: (kWidth - AutoGetWidth(width: 110) - 3 * kLeftDis), height: AutoGetHeight(height: 42)))
        
        
        customerNamextView.textView.tag = 1
        customerNamextView.aDelegate = self
        customerNamextView.textView.backgroundColor = UIColor.white
        customerNamextView.textView.font = UIFont.systemFont(ofSize: 15)
        customerNamextView.textView.textColor = UIColor.black
        customerNamextView.textView.textAlignment = .right
        customerNamextView.placeHolder = "请输入商机名称(必填)"
        customerNamextView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        
        return customerNamextView
    }()
    
    lazy var customerCateSelect: UILabel = {
        let name = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.customerNamextView.bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        name.text = "商机类别"
        name.textColor = UIColor.black
        name.textAlignment = .left
        name.font = kFontSize15
        self.baseInformationV.addSubview(name)
        
        let customerFromSelect = UILabel.init(frame: CGRect.init(x: name.right + kLeftDis, y: self.customerNamextView.bottom, width: kWidth - AutoGetWidth(width: 110) - 4 * kLeftDis - AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 55)))
        customerFromSelect.text = "选择商机类型(必填)"
        customerFromSelect.textColor = UIColor.lightGray
        customerFromSelect.textAlignment = .right
        customerFromSelect.font = kFontSize15
        
        let selectImg = UIImageView.init(frame: CGRect.init(x: customerFromSelect.right + kLeftDis, y:self.customerNamextView.bottom + AutoGetHeight(height: 55 - 12)/2, width: AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 12)))
        selectImg.image = UIImage.init(named: "PersonAddressArrow")
        selectImg.isUserInteractionEnabled = true
        self.baseInformationV.addSubview(selectImg)
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: name.right , y: self.customerNamextView.bottom, width: kWidth - AutoGetWidth(width: 125), height: AutoGetHeight(height: 55))
        btn.addTarget(self, action: #selector(chooseBusinessCate), for: .touchUpInside)
        self.baseInformationV.addSubview(btn)
        return customerFromSelect
    }()
    
    lazy var customerDetailTxtView: CBTextView = {
        let address = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.customerCateSelect.bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        address.text = "商机概要"
        address.textColor = UIColor.black
        address.textAlignment = .left
        address.font = kFontSize15
        self.baseInformationV.addSubview(address)

        let customerAddTxtView = CBTextView.init(frame:CGRect.init(x: address.right + kLeftDis, y:self.customerCateSelect.bottom + AutoGetHeight(height: 13), width: (kWidth - AutoGetWidth(width: 110) - 3 * kLeftDis), height: AutoGetHeight(height: 42)))
        //MARK:- 代理
        customerAddTxtView.textView.tag = 2
        customerAddTxtView.aDelegate = self
        customerAddTxtView.textView.backgroundColor = UIColor.white
        customerAddTxtView.textView.font = UIFont.systemFont(ofSize: 15)
        customerAddTxtView.textView.textColor = UIColor.black
        customerAddTxtView.textView.textAlignment = .right
        customerAddTxtView.placeHolder = "输入商机概要"
        customerAddTxtView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")

        return customerAddTxtView
    }()
    //   4
    lazy var customerName: UILabel = {
        let name = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.customerDetailTxtView.bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        name.text = "客户名称"
        name.textColor = UIColor.black
        name.textAlignment = .left
        name.font = kFontSize15
        self.baseInformationV.addSubview(name)
        
        let customerFromSelect = UILabel.init(frame: CGRect.init(x: name.right + kLeftDis, y: self.customerDetailTxtView.bottom, width: kWidth - AutoGetWidth(width: 110) - 4 * kLeftDis - AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 55)))
        customerFromSelect.text = "请选择(必选)"
        customerFromSelect.textColor = UIColor.lightGray
        customerFromSelect.textAlignment = .right
        customerFromSelect.font = kFontSize15
        
        
        let selectImg = UIImageView.init(frame: CGRect.init(x: customerFromSelect.right + kLeftDis, y:self.customerDetailTxtView.bottom + AutoGetHeight(height: 55 - 12)/2, width: AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 12)))
        selectImg.image = UIImage.init(named: "PersonAddressArrow")
        selectImg.isUserInteractionEnabled = true
        self.baseInformationV.addSubview(selectImg)
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: name.right , y: self.customerDetailTxtView.bottom, width: kWidth - AutoGetWidth(width: 125), height: AutoGetHeight(height: 55))
        btn.addTarget(self, action: #selector(chooseCustomName), for: .touchUpInside)
        self.baseInformationV.addSubview(btn)
        return customerFromSelect
    }()

    //预计金额
    lazy var estimateMoney: CBTextView = {
        let address = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.customerName.bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        address.text = "预计金额"
        address.textColor = UIColor.black
        address.textAlignment = .left
        address.font = kFontSize15
        self.baseInformationV.addSubview(address)
        
        let customerAddTxtView = CBTextView.init(frame:CGRect.init(x: address.right + kLeftDis-10, y:self.customerName.bottom + AutoGetHeight(height: 13), width: (kWidth - AutoGetWidth(width: 110) - 3 * kLeftDis), height: AutoGetHeight(height: 42)))
        //MARK:- 代理
        customerAddTxtView.textView.tag = 3
        customerAddTxtView.aDelegate = self
        customerAddTxtView.textView.backgroundColor = UIColor.white
        customerAddTxtView.textView.font = UIFont.systemFont(ofSize: 15)
        customerAddTxtView.textView.textColor = UIColor.black
        customerAddTxtView.textView.textAlignment = .right
        customerAddTxtView.textView.keyboardType = .numberPad
        customerAddTxtView.placeHolder = "输入金额(必填)"
        customerAddTxtView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        
        
        let yuan = UILabel.init(frame: CGRect.init(x: customerAddTxtView.right, y: self.customerName.bottom, width: AutoGetWidth(width: 15), height: AutoGetHeight(height: 55)))
        yuan.text = "元"
        yuan.textColor = UIColor.black
        yuan.textAlignment = .center
        yuan.font = kFontSize16
        self.baseInformationV.addSubview(yuan)
        
        return customerAddTxtView
    }()
    
    //销售阶段
    lazy var saleTime: UILabel = {
        let name = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.estimateMoney.bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        name.text = "销售阶段"
        name.textColor = UIColor.black
        name.textAlignment = .left
        name.font = kFontSize15
        self.baseInformationV.addSubview(name)
        
        let customerFromSelect = UILabel.init(frame: CGRect.init(x: name.right + kLeftDis, y: self.estimateMoney.bottom, width: kWidth - AutoGetWidth(width: 110) - 4 * kLeftDis - AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 55)))
        customerFromSelect.text = "请选择(必选)"
        customerFromSelect.textColor = UIColor.lightGray
        customerFromSelect.textAlignment = .right
        customerFromSelect.font = kFontSize15
        
        let selectImg = UIImageView.init(frame: CGRect.init(x: customerFromSelect.right + kLeftDis, y:self.estimateMoney.bottom + AutoGetHeight(height: 55 - 12)/2, width: AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 12)))
        selectImg.image = UIImage.init(named: "PersonAddressArrow")
        selectImg.isUserInteractionEnabled = true
        self.baseInformationV.addSubview(selectImg)
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: name.right , y: self.estimateMoney.bottom, width: kWidth - AutoGetWidth(width: 125), height: AutoGetHeight(height: 55))
        btn.addTarget(self, action: #selector(saleStage), for: .touchUpInside)
        self.baseInformationV.addSubview(btn)
        return customerFromSelect
    }()
    //预计结单时间
    lazy var estimateEndTime: UILabel = {
        let name = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.saleTime.bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        name.text = "预计结单时间"
        name.textColor = UIColor.black
        name.textAlignment = .left
        name.font = kFontSize15
        self.baseInformationV.addSubview(name)
        
        let customerFromSelect = UILabel.init(frame: CGRect.init(x: name.right + kLeftDis, y: self.saleTime.bottom, width: kWidth - AutoGetWidth(width: 110) - 4 * kLeftDis - AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 55)))
        customerFromSelect.text = "请选择(必选)"
        customerFromSelect.textColor = UIColor.lightGray
        customerFromSelect.textAlignment = .right
        customerFromSelect.font = kFontSize15
        
        let selectImg = UIImageView.init(frame: CGRect.init(x: customerFromSelect.right + kLeftDis, y:self.saleTime.bottom + AutoGetHeight(height: 55 - 12)/2, width: AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 12)))
        selectImg.image = UIImage.init(named: "PersonAddressArrow")
        selectImg.isUserInteractionEnabled = true
        self.baseInformationV.addSubview(selectImg)
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: name.right , y: self.saleTime.bottom, width: kWidth - AutoGetWidth(width: 125), height: AutoGetHeight(height: 55))
        btn.addTarget(self, action: #selector(endtime), for: .touchUpInside)
        self.baseInformationV.addSubview(btn)
        return customerFromSelect
    }()
    //重要程度
    lazy var importantce: UILabel = {
        let name = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.estimateEndTime.bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        name.text = "重要程度"
        name.textColor = UIColor.black
        name.textAlignment = .left
        name.font = kFontSize15
        self.baseInformationV.addSubview(name)
        
        let customerFromSelect = UILabel.init(frame: CGRect.init(x: name.right + kLeftDis, y: self.estimateEndTime.bottom, width: kWidth - AutoGetWidth(width: 110) - 4 * kLeftDis - AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 55)))
        customerFromSelect.text = "请选择(必选)"
        customerFromSelect.textColor = UIColor.lightGray
        customerFromSelect.textAlignment = .right
        customerFromSelect.font = kFontSize15
        
        let selectImg = UIImageView.init(frame: CGRect.init(x: customerFromSelect.right + kLeftDis, y:self.estimateEndTime.bottom + AutoGetHeight(height: 55 - 12)/2, width: AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 12)))
        selectImg.image = UIImage.init(named: "PersonAddressArrow")
        selectImg.isUserInteractionEnabled = true
        self.baseInformationV.addSubview(selectImg)
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: name.right , y: self.estimateEndTime.bottom, width: kWidth - AutoGetWidth(width: 125), height: AutoGetHeight(height: 55))
        btn.addTarget(self, action: #selector(importance), for: .touchUpInside)
        self.baseInformationV.addSubview(btn)
        return customerFromSelect
    }()
    //联系人
    lazy var contact: UILabel = {
        let name = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.importantce.bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        name.text = "联系人"
        name.textColor = UIColor.black
        name.textAlignment = .left
        name.font = kFontSize15
        self.baseInformationV.addSubview(name)
        
        let customerFromSelect = UILabel.init(frame: CGRect.init(x: name.right + kLeftDis, y: self.importantce.bottom, width: kWidth - AutoGetWidth(width: 110) - 4 * kLeftDis - AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 55)))
        customerFromSelect.text = "请选择(必选)"
        customerFromSelect.textColor = UIColor.lightGray
        customerFromSelect.textAlignment = .right
        customerFromSelect.font = kFontSize15
        
        let selectImg = UIImageView.init(frame: CGRect.init(x: customerFromSelect.right + kLeftDis, y:self.importantce.bottom + AutoGetHeight(height: 55 - 12)/2, width: AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 12)))
        selectImg.image = UIImage.init(named: "PersonAddressArrow")
        selectImg.isUserInteractionEnabled = true
        self.baseInformationV.addSubview(selectImg)
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: name.right , y: self.importantce.bottom, width: kWidth - AutoGetWidth(width: 125), height: AutoGetHeight(height: 55))
        btn.addTarget(self, action: #selector(lianXiRen), for: .touchUpInside)
        self.baseInformationV.addSubview(btn)
        return customerFromSelect
    }()
        //添加联系人
    lazy var addContacterBtn: UIButton = {
        let addContacterBtn = UIButton.init(type: .custom)
        addContacterBtn.frame = CGRect.init(x: 0, y: self.baseInformationV.bottom, width: kWidth, height: AutoGetHeight(height: 40))
        addContacterBtn.setTitle("添加联系人 + ", for: .normal)
        addContacterBtn.backgroundColor = UIColor.white
        addContacterBtn.setTitleColor(kLightBlueColor, for: .normal)
        addContacterBtn.addTarget(self, action: #selector(addContacterClick), for: .touchUpInside)
        return addContacterBtn
    }()
    

    //第2组标签
    lazy var customerContactLab: UILabel = {
        let customerContactLab = UILabel.init(frame: CGRect.init(x: 0, y: self.addContacterBtn.bottom, width: kWidth, height: AutoGetHeight(height: 18)))
        customerContactLab.text = "   "
        customerContactLab.textColor = kLyGrayColor
        customerContactLab.textAlignment = .left
        customerContactLab.backgroundColor = kProjectBgColor
        customerContactLab.font = kFontSize10
        return customerContactLab
    }()

    
    //统一弄到一个view内
    lazy var contactBaseV: UIView = {
        let contactBaseV = UIView.init(frame: CGRect.init(x: 0, y: baseInformationV.bottom, width: kWidth, height: AutoGetHeight(height: 110)))
        contactBaseV.backgroundColor = UIColor.white
        return contactBaseV
    }()
    
    //添加联系人做成一个独立的view  删除就移除view 同时用一个属性标记移除 以便于删除数据
    lazy var addLianXi: CBTextView = {
        let name = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        name.text = "联系人名字"
        name.textColor = UIColor.black
        name.textAlignment = .left
        name.font = kFontSize15
        self.contactBaseV.addSubview(name)
        
        let customerNamextView = CBTextView.init(frame:CGRect.init(x: name.right + kLeftDis, y: AutoGetHeight(height: 13), width: (kWidth - AutoGetWidth(width: 110) - 3 * kLeftDis), height: AutoGetHeight(height: 42)))
        
        
        customerNamextView.textView.tag = 5
        customerNamextView.aDelegate = self
        customerNamextView.textView.backgroundColor = UIColor.white
        customerNamextView.textView.font = UIFont.systemFont(ofSize: 15)
        customerNamextView.textView.textColor = UIColor.black
        customerNamextView.textView.textAlignment = .right
        customerNamextView.placeHolder = "联系人名字"
        customerNamextView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        
        return customerNamextView
    }()
    //联系人电话
    lazy var addLianXiPhone: CBTextView = {
        let name = UILabel.init(frame: CGRect.init(x: kLeftDis, y: addLianXi.bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        name.text = "联系人电话"
        name.textColor = UIColor.black
        name.textAlignment = .left
        name.font = kFontSize15
        self.contactBaseV.addSubview(name)
        
        let customerNamextView = CBTextView.init(frame:CGRect.init(x: name.right + kLeftDis, y:addLianXi.bottom + AutoGetHeight(height: 13), width: (kWidth - AutoGetWidth(width: 110) - 3 * kLeftDis), height: AutoGetHeight(height: 42)))
        
        
        customerNamextView.textView.tag = 6
        customerNamextView.aDelegate = self
        customerNamextView.textView.backgroundColor = UIColor.white
        customerNamextView.textView.font = UIFont.systemFont(ofSize: 15)
        customerNamextView.textView.textColor = UIColor.black
        customerNamextView.textView.textAlignment = .right
        customerNamextView.placeHolder = "联系人电话"
        customerNamextView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        
        return customerNamextView
    }()
    
    
    
    
    
    //第2组容器
    lazy var secondView: UIView = {
        let secondV = UIView.init(frame: CGRect.init(x: 0, y: self.customerContactLab.bottom, width: kWidth, height: AutoGetHeight(height: 220)))
        secondV.backgroundColor = UIColor.white
        return secondV
    }()
    
    //竞争对手
    lazy var jinZheng: CBTextView = {
        let address = UILabel.init(frame: CGRect.init(x: kLeftDis, y: jueChePhone.bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        address.text = "竞争对手"
        address.textColor = UIColor.black
        address.textAlignment = .left
        address.font = kFontSize15
        self.secondView.addSubview(address)
        
        let customerAddTxtView = CBTextView.init(frame:CGRect.init(x: address.right + kLeftDis, y: jueChePhone.bottom+AutoGetHeight(height: 13), width: (kWidth - AutoGetWidth(width: 110) - 3 * kLeftDis), height: AutoGetHeight(height: 42)))
        customerAddTxtView.textView.tag = 4
        customerAddTxtView.aDelegate = self
        customerAddTxtView.textView.backgroundColor = UIColor.white
        customerAddTxtView.textView.font = UIFont.systemFont(ofSize: 15)
        customerAddTxtView.textView.textColor = UIColor.black
        customerAddTxtView.textView.textAlignment = .right
        customerAddTxtView.placeHolder = "输入竞争对手(多个用逗号隔开)"
        customerAddTxtView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        return customerAddTxtView
    }()
    
    //决策人姓名
    lazy var jueCheRen: CBTextView = {
        let address = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        address.text = "决策人姓名"
        address.textColor = UIColor.black
        address.textAlignment = .left
        address.font = kFontSize15
        self.secondView.addSubview(address)
        
        let customerAddTxtView = CBTextView.init(frame:CGRect.init(x: address.right + kLeftDis, y: AutoGetHeight(height: 13), width: (kWidth - AutoGetWidth(width: 110) - 3 * kLeftDis), height: AutoGetHeight(height: 42)))
       
        customerAddTxtView.textView.tag = 7
        customerAddTxtView.aDelegate = self
        customerAddTxtView.textView.backgroundColor = UIColor.white
        customerAddTxtView.textView.font = UIFont.systemFont(ofSize: 15)
        customerAddTxtView.textView.textColor = UIColor.black
        customerAddTxtView.textView.textAlignment = .right
        customerAddTxtView.placeHolder = "输入决策人姓名"
        customerAddTxtView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        return customerAddTxtView
    }()
    //决策人电话
    lazy var jueChePhone: CBTextView = {
        let address = UILabel.init(frame: CGRect.init(x: kLeftDis, y: jueCheRen.bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        address.text = "决策人电话"
        address.textColor = UIColor.black
        address.textAlignment = .left
        address.font = kFontSize15
        self.secondView.addSubview(address)
        
        let customerAddTxtView = CBTextView.init(frame:CGRect.init(x: address.right + kLeftDis, y: jueCheRen.bottom+AutoGetHeight(height: 13), width: (kWidth - AutoGetWidth(width: 110) - 3 * kLeftDis), height: AutoGetHeight(height: 42)))
        //MARK:- 代理
        customerAddTxtView.textView.tag = 8
        customerAddTxtView.aDelegate = self
        customerAddTxtView.textView.backgroundColor = UIColor.white
        customerAddTxtView.textView.font = UIFont.systemFont(ofSize: 15)
        customerAddTxtView.textView.textColor = UIColor.black
        customerAddTxtView.textView.textAlignment = .right
        customerAddTxtView.placeHolder = "输入决策人电话"
        customerAddTxtView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        return customerAddTxtView
    }()
    
    
    //跟进人
    lazy var genJin: UILabel = {
        let name = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.jinZheng.bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        name.text = "跟进人"
        name.textColor = UIColor.black
        name.textAlignment = .left
        name.font = kFontSize15
        self.secondView.addSubview(name)
        
        let customerFromSelect = UILabel.init(frame: CGRect.init(x: name.right + kLeftDis, y: self.jinZheng.bottom, width: kWidth - AutoGetWidth(width: 110) - 4 * kLeftDis - AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 55)))
        customerFromSelect.text = "请选择"
        customerFromSelect.textColor = UIColor.lightGray
        customerFromSelect.textAlignment = .right
        customerFromSelect.font = kFontSize15
        
        let selectImg = UIImageView.init(frame: CGRect.init(x: customerFromSelect.right + kLeftDis, y:self.jinZheng.bottom + AutoGetHeight(height: 55 - 12)/2, width: AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 12)))
        selectImg.image = UIImage.init(named: "PersonAddressArrow")
        selectImg.isUserInteractionEnabled = true
        self.secondView.addSubview(selectImg)
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: name.right , y: self.jinZheng.bottom, width: kWidth - AutoGetWidth(width: 125), height: AutoGetHeight(height: 55))
        btn.addTarget(self, action: #selector(GenJinRen), for: .touchUpInside)
        self.secondView.addSubview(btn)
        return customerFromSelect
    }()
    
    
    lazy var collectionView: UICollectionView = {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width: (kHaveLeftWidth)/5, height: 75)
        layOut.sectionInset = UIEdgeInsetsMake(0, kLeftDis, 0, kLeftDis)
        layOut.minimumLineSpacing = 0
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        
        
        let collectionView = UICollectionView(frame:  CGRect(x: 0, y: secondView.bottom, width: kWidth, height: 150), collectionViewLayout: layOut)
      // layOut.headerReferenceSize = CGSize(width: kWidth, height: 44)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(QRGenjinCollectionCell.self, forCellWithReuseIdentifier: "QRGenjinCellId")
        collectionView.register(QRheadcell.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "head1")
        return collectionView
    }()
    
    
    lazy var footerView :UIView = {
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: 260))
        headView.backgroundColor = UIColor.white
        return footerView
    }()
//    lazy var collectionView1: QRAddTrackPersonVC = {
//        let TrackPerson = QRAddTrackPersonVC()
//        //赋值跟进人数量
//       // TrackPerson.
//
//        return TrackPerson
//    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //添加通知
        let NotifMycation = NSNotification.Name(rawValue:"AddTracker")
        NotificationCenter.default.addObserver(self, selector: #selector(upDataChange(notif:)), name: NotifMycation, object: nil)
        
        
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.customerInfoLab)
        self.headView.addSubview(self.baseInformationV)
        
        self.baseInformationV.addSubview(self.customerNamextView)
        self.baseInformationV.addSubview(self.customerCateSelect)
        self.baseInformationV.addSubview(self.customerDetailTxtView)
        self.baseInformationV.addSubview(self.customerName)
        self.baseInformationV.addSubview(self.estimateMoney)
        self.baseInformationV.addSubview(self.saleTime)
        self.baseInformationV.addSubview(self.estimateEndTime)
        self.baseInformationV.addSubview(self.importantce)
        self.baseInformationV.addSubview(self.contact)
        self.headView.addSubview(addContacterBtn)
        
        for i in 0..<9 {
            let line = UIView.init(frame: CGRect.init(x: kLeftDis, y: self.customerNamextView.bottom - 0.5 + AutoGetHeight(height: 55) * CGFloat(i), width: kWidth - kLeftDis, height: 0.5))
            line.backgroundColor = kLineColor
            self.baseInformationV.addSubview(line)
        }
        
        
        
         self.lastHeight = AutoGetHeight(height: 495)
        //第2组空隙
         self.headView.addSubview(self.customerContactLab)
        //第2组
        self.headView.addSubview(self.secondView)
        self.secondView.addSubview(self.jueCheRen)
        self.secondView.addSubview(self.jueChePhone)
        self.secondView.addSubview(self.jinZheng)
        self.secondView.addSubview(self.genJin)
        for i in 0..<3 {
            let line = UIView.init(frame: CGRect.init(x: kLeftDis, y: self.jueCheRen.bottom - 0.5 + AutoGetHeight(height: 55) * CGFloat(i), width: kWidth - kLeftDis, height: 0.5))
            line.backgroundColor = kLineColor
            self.secondView.addSubview(line)
        }
        
        self.headView.addSubview(collectionView)
        
        self.table.tableHeaderView = headView
        let but = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.done, target: self, action: #selector(baoCun))
        but.tintColor = kBlueC
        navigationItem.rightBarButtonItem = but
        loadBusinessType()
        loadSaleStage()
        //添加footerview
     //   self.table.tableFooterView = self.footerView
        
        
        if opt != "edit" {
            //新建商机
            self.title = "新建商机"
        }else{
            //编辑商机
            self.title = "编辑商机"
            //为控件赋值
            self.customerNamextView.prevText = detailModel.businessName
            self.customerDetailTxtView.prevText = detailModel.businessRemark
            self.customerName.text = detailModel.crmCustomerName
            self.estimateMoney.prevText = detailModel.estimatedAmount
            self.saleTime.text = detailModel.salesStage
            self.estimateEndTime.text = detailModel.closeDate
            if detailModel.importance == "0" {
                self.importantce.text = "重要"
            }else{
                self.importantce.text = "普通"
            }
            self.contact.text = detailModel.linkPersonName
            self.jueCheRen.prevText = detailModel.decisionName
            self.jueChePhone.prevText = detailModel.decisionPhone
            self.jinZheng.prevText = detailModel.competitor
            
            //跟进人
            //属性赋值
            self.businessName = (detailModel.businessName)!
            self.businessDetail = (detailModel.businessRemark)!
            self.businessType = detailModel.businessType
            self.CustomerName = (detailModel.crmCustomerName)!
            self.AmountMoney = (detailModel.estimatedAmount)!
            self.competite = (detailModel.competitor)!
            self.decisionPhone = (detailModel.decisionPhone)!
            self.end = (detailModel.closeDate)!
            self.crmCustomer = (detailModel.crmCustomer)!
            self.important = (detailModel.importance)!
            self.sale = (detailModel.salesStage)!
        
            //跟进人缺少
            self.followPerson = detailModel.followPerson
            //联系人()
            self.lianXiPerson = detailModel.linkPerson
            self.lianXi = (detailModel.linkPersonName)!
            self.lianxiPhone = (detailModel.linkPersonPhone)!
            self.decisionName = (detailModel.decisionName)!
            
            //商机id
            self.entityId = detailModel.entityId
            //
            
            //将模型改变成use模型
             var tempuser = [CQDepartMentUserListModel]()
            for xx in detailModel.model{
                let mod = CQDepartMentUserListModel(uId: xx.followEmployeeId, realN: xx.followPersonListName, headImag: xx.followPersonListImage)
                tempuser.append(mod)
            }
            self.TrackArray = tempuser
        }
        
        
        self.collectionView.frame = CGRect(x: 0, y: Int(secondView.tz_bottom), width: Int(kWidth), height: ((TrackArray.count)/5+1)*75)
        self.headView.frame =  CGRect(x: 0, y: 0, width: kWidth, height: baseInformationV.tz_height+addContacterBtn.tz_height+secondView.tz_height+collectionView.tz_height+AutoGetHeight(height: 36))
        
        
    }
    
    
    
    //MARK:-加载商机类型
    func loadBusinessType(){
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmBusiness/getCrmBusinessType", type: .get, param: ["emyeId":userID
                                                                                                               ], successCallBack: { (result) in
                                                            var typeStr = [String]()
                                                          var typeId = [String]()
                                                                                                                for xx in result["data"].arrayValue{
                                                               typeId.append(xx["businessType"].stringValue)
                                                            typeStr.append(xx["businessTypeName"].stringValue)                                                    }
                                      self.businessIDARR = typeId
                                        self.businessTypeARR = typeStr
                                                                                                                if self.opt == "edit"{                                                            for (index,value) in self.businessIDARR.enumerated(){
                                                                                                                    print(value)
                                                                                                                    if "\(value)" == self.detailModel.businessType{
                                                                                                                        self.customerCateSelect.text = self.businessTypeARR[index]
                                                                                                                    }
                                                                                                                }
                                                                                                                }
                   
                                                                                                                
        }) { (result) in
            
            
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
        self.followPerson = tempstr
        
        
        //改变frame
        self.collectionView.frame =  CGRect(x: 0, y: Int(secondView.tz_bottom), width: Int(kWidth), height: ((TrackArray.count)/5+1)*75 )
        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: baseInformationV.tz_height + contactBaseV.tz_height + secondView.tz_height + AutoGetHeight(height: 36)+collectionView.tz_height)
        self.table.tableHeaderView = self.headView
        
    }
    
    
    //MARK:-加载销售阶段
    func loadSaleStage(){
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmBusiness/getCrmBusinessSalesStage", type: .get, param: ["emyeId":userID
            ], successCallBack: { (result) in
                //var typeStr = [String]()
                var  tempSaleStage = [String]()
                for xx in result["data"].arrayValue{
                    tempSaleStage.append(xx["salesStage"].stringValue)
                  //  typeStr.append(xx["businessTypeName"].stringValue)
                }
                self.saleStageARR = tempSaleStage
               // self.businessTypeARR = typeStr
                
                
        }) { (result) in
            
            
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    //MARK:-加载联系人
    func loadLianXiRen(){
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmBusiness/getCrmLinkmanList", type: .get, param: ["crmCustomer":crmCustomer,
            ], successCallBack: { (result) in
               
                var  tempSaleStage = [String]()
                for xx in result["data"].arrayValue{
                    tempSaleStage.append(xx["salesStage"].stringValue)
                }
                self.saleStageARR = tempSaleStage
            
                
                
        }) { (result) in
            
        }
    }
    //MARK:- 保存
    func saveAddBusiness()  {
        SVProgressHUD.show(withStatus: "添加商机中...")
        //self.loadingPlay()
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmBusiness/operateCrmBusiness", type: .post, param: ["businessName":businessName,"businessRemark":businessDetail,"businessType":businessType,"closeDate":end,"competitor":competite,"crmCustomer":crmCustomer,"estimatedAmount":AmountMoney,"followPerson":followPerson,"importance":important,"linkName":lianXi,"linkPerson":lianXiPerson,"linkPhone":lianxiPhone,"opt":opt,"salesStage":sale,"emyeId":userID,"decisionName":decisionName,"decisionPhone":decisionPhone,"entityId":entityId  ], successCallBack: { (result) in
            
            if result["success"].boolValue == true{
               // self.loadingSuccess()
                SVProgressHUD.showInfo(withStatus: "添加商机成功")
                SVProgressHUD.dismiss()
                self.clickClosure!("ss")
                self.navigationController?.popViewController(animated: true)
            }
            
            
        }) { (error) in
               SVProgressHUD.showInfo(withStatus: "添加商机失败")
               self.loadingSuccess()
        }
    }
    
    
    
}
//MARK:-  点击事件
extension QRAddBusinessVC{
   
    
    
    
    @objc func chooseBusinessCate()  {
        DLog("商机类别")
        let items = self.businessTypeARR
        let vProperty = FWSheetViewProperty()
        vProperty.touchWildToHide = "1"
        let sheetView = FWSheetView.sheet(title:"", itemTitles: items, itemBlock: { [unowned self] (popupView, index, title) in
            //编辑商机
            self.customerCateSelect.text = items[index]
            self.businessType = self.businessIDARR[index]
        }, cancenlBlock: {
            print("点击了取消")
        }, property: vProperty)
        sheetView.show()
        
        
    }
    
    @objc func chooseCustomName()  {
        DLog("客户名称")
        let kehulist = QRKeHuList()
        kehulist.clickClosure = {[unowned self] a,b in
            self.customerName.text = a
            self.CustomerName = a!
            self.crmCustomer = b
        }
        self.navigationController?.pushViewController(kehulist, animated: true)
    }
    
    @objc func saleStage(){
        DLog("销售阶段")
        let items = self.saleStageARR
        let vProperty = FWSheetViewProperty()
        vProperty.touchWildToHide = "1"
        let sheetView = FWSheetView.sheet(title:"", itemTitles: items, itemBlock: {[unowned self]  (popupView, index, title) in
            //编辑商机
                self.sale = items[index]
                self.saleTime.text = items[index]
            
        }, cancenlBlock: {
            print("点击了取消")
        }, property: vProperty)
        sheetView.show()
        
    }
    @objc func endtime(){
        self.initDatePickView(tag: 200)
      
    }
    @objc func importance(){
        DLog("重要程度")
        let items = ["重要","普通"]
        let vProperty = FWSheetViewProperty()
        vProperty.touchWildToHide = "1"
        let sheetView = FWSheetView.sheet(title:"", itemTitles: items, itemBlock: { [unowned self] (popupView, index, title) in
            //编辑商机
            if index == 0{
                self.important = "0"
            }else{
                self.important = "1"
            }
                self.importantce.text = items[index]
            
        }, cancenlBlock: {
            print("点击了取消")
        }, property: vProperty)
        sheetView.show()
    }
    @objc func lianXiRen(){
        DLog("联系人")
        let lxr = QRLianXiRenListVC()
        if crmCustomer == ""{
            SVProgressHUD.showInfo(withStatus: "请先选择客户名称")
            return
        }
        lxr.crmCustomer = crmCustomer
        lxr.clickClosure = {[unowned self] mod in
            self.LianxirenMod = mod
            self.lianXi = mod.linkName
            self.lianXiPerson = mod.linkPerson
            self.contact.text = mod.linkName
            self.backToLianXiRenList()
        }
        
        self.navigationController?.pushViewController(lxr, animated: true)
    }
    @objc func GenJinRen(){
        DLog("跟进人")
        
        //跳转通讯录
//        let contact = AddressBookVC()
//        contact.hasSelectModelArr = self.TrackArray
//        contact.toType = ToAddressBookType.fromGenJin
        
        let contact = QRAddressBookVC()
        contact.titleStr = "跟进人"
        contact.hasSelectModelArr = self.TrackArray
        contact.toType = ToAddressBookType.fromGenJin
        self.navigationController?.pushViewController(contact, animated: true)
        
    }
    @objc func baoCun(){
        if self.businessName == "" {
            SVProgressHUD.showInfo(withStatus: "请输入商机名称")
            return
        }
        if self.businessType == "" {
            SVProgressHUD.showInfo(withStatus: "请选择商机类型")
            return
        }
        if self.CustomerName == "" {
            SVProgressHUD.showInfo(withStatus: "请输入客户名称")
            return
        }
        if self.AmountMoney == "" {
            SVProgressHUD.showInfo(withStatus: "请输入预计金额")
            return
        }
        if self.sale == "" {
            SVProgressHUD.showInfo(withStatus: "请输入销售阶段")
            return
        }
        if self.important == "" {
            SVProgressHUD.showInfo(withStatus: "请选择重要程度")
            return
        }
        if self.lianXi == "" {
            SVProgressHUD.showInfo(withStatus: "请选择联系人")
            return
        }
        if self.businessType == "" {
            SVProgressHUD.showInfo(withStatus: "请选择商机类型")
            return
        }
        
        saveAddBusiness()
        
    }
    
    @objc func addContacterClick() {
        DLog("添加联系人点击")
        //置空联系人
        self.lianXi = ""
        self.contact.text = ""
       //添加but
        self.headView.addSubview(self.contactBaseV)
        self.contactBaseV.addSubview(self.addLianXi)
        self.contactBaseV.addSubview(self.addLianXiPhone)
        self.lastHeight = self.contactBaseV.bottom
        
        self.addContacterBtn.removeFromSuperview()
        self.customerContactLab.frame = CGRect.init(x: 0, y: self.contactBaseV.bottom, width: kWidth, height: AutoGetHeight(height: 18))
        self.secondView.frame = CGRect.init(x: 0, y:self.customerContactLab.bottom, width: kWidth, height: AutoGetHeight(height: 220))
       
        self.collectionView.frame = CGRect(x: 0, y: Int(secondView.tz_bottom), width: Int(kWidth), height: ((TrackArray.count)/5+1)*75+44)
        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: baseInformationV.tz_height + contactBaseV.tz_height + secondView.tz_height + AutoGetHeight(height: 36)+collectionView.tz_height)
        self.table.tableHeaderView = self.headView
    }
    
    //选择联系人回来之后调用这个方法取消联系人
    func backToLianXiRenList(){
       self.contactBaseV.removeFromSuperview()
       //重新修改frame
        self.headView.addSubview(self.addContacterBtn)
        self.customerContactLab.frame = CGRect.init(x: 0, y: self.addContacterBtn.bottom, width: kWidth, height: AutoGetHeight(height: 18))
        self.secondView.frame = CGRect.init(x: 0, y:self.customerContactLab.bottom, width: kWidth, height: AutoGetHeight(height: 220))
         collectionView.frame = CGRect(x: 0, y: Int(secondView.tz_bottom), width: Int(kWidth), height: ((TrackArray.count)/5+1)*75+44)
        
        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: baseInformationV.tz_height +  addContacterBtn.tz_height + secondView.tz_height + AutoGetHeight(height: 18)+collectionView.tz_height)
        self.table.tableHeaderView = self.headView
       
    }
    
    
}
extension QRAddBusinessVC:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        
        if  textView.tag == 1 {
            //商机名称
            self.businessName = textView.text
        }
        if  textView.tag == 2 {
            //商机概要
           self.businessDetail = textView.text
        }
        if  textView.tag == 3 {
            //预计金额
            self.AmountMoney = textView.text
        }
        if  textView.tag == 4 {
            //竞争对手
            self.competite = textView.text
        }
        if  textView.tag == 5 {
            //联系人
            self.lianXi = textView.text
        }
        if  textView.tag == 6 {
            //联系人电话
            self.lianxiPhone = textView.text
        }
        if  textView.tag == 7 {
            //竞争对手
            self.decisionName = textView.text
        }
        if  textView.tag == 8 {
            //竞争对手
            self.decisionPhone = textView.text
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if  textView.tag == 1 {
            //商机名称
            self.businessName = textView.text
            print(textView.text)
        }
        if  textView.tag == 2 {
            //商机概要
            self.businessDetail = textView.text
        }
        if  textView.tag == 3 {
            //预计金额
            self.AmountMoney = textView.text
        }
        if  textView.tag == 4 {
            //竞争对手
            self.competite = textView.text
        }
        if  textView.tag == 5 {
            //联系人
            self.lianXi = textView.text
        }
        if  textView.tag == 6 {
            //联系人电话
            self.lianxiPhone = textView.text
        }
        if  textView.tag == 7 {
            //竞争对手
            self.decisionName = textView.text
        }
        if  textView.tag == 8 {
            //竞争对手
            self.decisionPhone = textView.text
        }
        
    }
    
    
}


extension QRAddBusinessVC :QRGenjinCollectionCellDeleteDelegate{
    func deletePublishPic(index: IndexPath) {
        self.TrackArray.remove(at: index.row)
        collectionView.reloadData()
    }
    
}


extension QRAddBusinessVC:UITableViewDelegate{
    
    
}


extension QRAddBusinessVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
      return TrackArray.count+1
    }
    
}

extension QRAddBusinessVC: UICollectionViewDelegate {
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





extension QRAddBusinessVC{
    func initDatePickView(tag:Int)  {
        let currentTag = tag - 200
        self.view.endEditing(true)
        bgView.frame = CGRect(x: 0, y: SafeAreaTopHeight, width: kWidth, height: kHeight - SafeAreaTopHeight - SafeAreaBottomHeight)
        bgView.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
        self.view.addSubview(bgView)
        bgView.addTarget(self, action: #selector(removeBgView), for: .touchUpInside)
        
        let colorBgV = UIView.init(frame: CGRect.init(x: 0, y: bgView.frame.size.height - 240, width: kWidth, height: 240))
        colorBgV.backgroundColor = UIColor.white
        bgView.addSubview(colorBgV)
        
        let space = UIView.init(frame: CGRect.init(x: 0, y: colorBgV.bottom, width: kWidth, height: SafeAreaBottomHeight))
        space.backgroundColor = UIColor.white
        bgView.addSubview(space)
        
        let sureBtn = UIButton()
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(.black, for: .normal)
        sureBtn.frame = CGRect(x: kWidth - 60, y: 0, width: 60, height: 40)
        sureBtn.tag = 700 + currentTag
        colorBgV.addSubview(sureBtn)
        sureBtn.addTarget(self, action: #selector(sureClick(btn:)), for: .touchUpInside)
        
        let cancelBtn = UIButton()
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(.black, for: .normal)
        cancelBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        colorBgV.addSubview(cancelBtn)
        cancelBtn.addTarget(self, action: #selector(removeBgView(sender:)), for: .touchUpInside)
        
        //创建日期选择器
        let datePicker = UIDatePicker(frame: CGRect(x:0, y: 40, width:kWidth, height:200))
        //将日期选择器区域设置为中文，则选择器日期显示为中文
        datePicker.locale = Locale(identifier: "zh_CN")
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .white
        datePicker.tag = 10086 + currentTag
        //注意：action里面的方法名后面需要加个冒号“：”
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        colorBgV.addSubview(datePicker)
    }
    
    @objc func removeBgView(sender: UIButton) {
        // self.bgView.removeAllSubviews()
        self.bgView.removeFromSuperview()
    }
    
    @objc func sureClick(btn:UIButton) {
        
       //截止日期需要大于现在
        
        //  self.bgView.removeAllSubviews()
         self.bgView.removeFromSuperview()
        if compareDate(){
            SVProgressHUD.showInfo(withStatus: "截单时间必须大于当前时间")
        }else{
            print(endTime)
            //赋值
            self.estimateEndTime.text =  endTime
            self.end = endTime
        }
        
        print("xxxx\(self.endTime)")
        if self.endTime == ""{
            let formatter = DateFormatter()
             formatter.dateFormat = "yyyy-MM-dd"
            let now = Date()
           let nowTime = formatter.string(from: now)
            self.estimateEndTime.text =  nowTime
            self.end = nowTime
        }
        
        
        
    }
    
    //日期选择器响应方法
    @objc func dateChanged(datePicker : UIDatePicker){
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd"
        endTime = formatter.string(from: datePicker.date)
        
    }
    
    func compareDate() -> Bool {
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd"
        let EDate:Date?
        let now = Date()

        EDate = formatter.date(from: endTime)
        if EDate == nil {
           // SVProgressHUD.showInfo(withStatus: "截止日期大于今日")
            return false
        }
        let result:ComparisonResult = (now.compare(EDate!))
        
        if result == .orderedAscending || result == .orderedSame {
            return false
        }
        return true
    }
}






extension QRAddBusinessVC:UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
      //  self.table.endEditing(true)
    }
}


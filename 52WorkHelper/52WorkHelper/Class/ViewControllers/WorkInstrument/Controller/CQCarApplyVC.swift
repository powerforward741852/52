//
//  CQCarApplyVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/7/2.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQCarApplyVC: SuperVC {

    var userArray = [CQDepartMentUserListModel]()
    //datepicker一系列控件及参数
    var bgView = UIButton()
    var startTime = "" //开始时间
    var endTime = ""  //结束时间
    var carId:Int = 0  //车辆类型id
    var carName = ""  //车辆类型描述
    //提交表单
    var formStr = ""
    //车辆模型
    var carModel:CQCarsModel?
    //车辆名
    var car = ""
    //
    var isFromMyApplyVC = false
    var dataDic:NSDictionary?
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight + AutoGetHeight(height: 40)))
        headView.backgroundColor = kProjectBgColor
        return headView
    }()
    
    lazy var titleView: UIView = {
        let titleView = UIView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 404-55)))
        titleView.backgroundColor = UIColor.white
        return titleView
    }()
    lazy var titleXingLab: UILabel = {
        let titleXingLab = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: AutoGetWidth(width: 30), height: AutoGetHeight(height: 55)))
        titleXingLab.textColor = UIColor.red
        titleXingLab.text = "*"
        titleXingLab.textAlignment = .center
        titleXingLab.font = kFontSize15
        return titleXingLab
    }()
    lazy var titleLab: UILabel = {
        let titleLab = UILabel.init(frame: CGRect.init(x: titleXingLab.right, y: 0, width: AutoGetWidth(width: 55), height: AutoGetHeight(height: 55)))
        titleLab.textColor = UIColor.black
        titleLab.text = "目的地"
        titleLab.textAlignment = .left
        titleLab.font = kFontSize15
        return titleLab
    }()
    
    lazy var titleField: MyTextField = {
        let titleField = MyTextField.init(frame: CGRect.init(x: self.titleLab.right, y: 0 , width: kWidth - kLeftDis - AutoGetWidth(width: 80), height: AutoGetHeight(height: 55)))
        titleField?.delegate = self
        titleField?.clearButtonMode = .never
        titleField?.keyBoardDelegate = self
        titleField?.font = kFontSize15
        titleField?.textColor = UIColor.black
        titleField?.tintColor = UIColor.black
        titleField?.placeholder = "请填写地点"
        titleField?.keyboardType = .default
        
        return titleField!
    }()
    
    lazy var contentXingLab: UILabel = {
        let contentXingLab = UILabel.init(frame: CGRect.init(x: 0, y: self.titleLab.bottom, width: AutoGetWidth(width: 30), height: AutoGetHeight(height: 55)))
        contentXingLab.textColor = UIColor.red
        contentXingLab.text = "*"
        contentXingLab.textAlignment = .center
        contentXingLab.font = kFontSize15
        return contentXingLab
    }()
    lazy var contentLab: UILabel = {
        let contentLab = UILabel.init(frame: CGRect.init(x: contentXingLab.right, y: self.titleLab.bottom, width: AutoGetWidth(width: 55), height: AutoGetHeight(height: 55)))
        contentLab.textColor = UIColor.black
        contentLab.text = "事由"
        contentLab.textAlignment = .left
        contentLab.font = kFontSize15
        return contentLab
    }()
    
    lazy var contentField: MyTextField = {
        let contentField = MyTextField.init(frame: CGRect.init(x: self.titleLab.right, y: self.titleField.bottom , width: kWidth - kLeftDis - AutoGetWidth(width: 80), height: AutoGetHeight(height: 55)))
        contentField?.delegate = self
        contentField?.clearButtonMode = .never
        contentField?.keyBoardDelegate = self
        contentField?.font = kFontSize15
        contentField?.textColor = UIColor.black
        contentField?.tintColor = UIColor.black
        contentField?.placeholder = "请填写用车事由"
        contentField?.keyboardType = .default
        
        return contentField!
    }()
    
    lazy var xingStartLab: UILabel = {
        let xingStartLab = UILabel.init(frame: CGRect.init(x: 0, y: self.contentLab.bottom, width: AutoGetWidth(width: 30), height: AutoGetHeight(height: 55)))
        xingStartLab.textColor = UIColor.red
        xingStartLab.text = "*"
        xingStartLab.textAlignment = .center
        xingStartLab.font = kFontSize15
        return xingStartLab
    }()
    
    lazy var startLab: UILabel = {
        let startLab = UILabel.init(frame: CGRect.init(x: self.xingStartLab.right, y: self.contentLab.bottom, width: AutoGetWidth(width: 80), height: AutoGetHeight(height: 55)))
        startLab.textColor = UIColor.black
        startLab.text = "开始时间"
        startLab.textAlignment = .left
        startLab.font = kFontSize15
        return startLab
    }()
    
    lazy var startBtn: UIButton = {
        let startBtn = UIButton.init(type: .custom)
        startBtn.frame = CGRect.init(x: AutoGetWidth(width: 110), y: self.contentLab.bottom, width: kWidth - AutoGetWidth(width: 125), height: AutoGetHeight(height: 55))
        startBtn.setTitle("请选择开始时间", for: .normal)
        startBtn.setTitleColor(kLyGrayColor, for: .normal)
        startBtn.addTarget(self, action: #selector(startClick(btn:)), for: .touchUpInside)
        startBtn.tag = 200
        startBtn.titleLabel?.font = kFontSize15
        startBtn.titleEdgeInsets = UIEdgeInsetsMake(0, AutoGetWidth(width: 100), 0, 0)
        
        let arrowImg = UIImageView.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 131.5), y: AutoGetHeight(height: 21.5), width: AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 12)))
        arrowImg.image = UIImage.init(named: "PersonAddressArrow")
        startBtn.addSubview(arrowImg)
        return startBtn
    }()
    
    lazy var xingEndLab: UILabel = {
        let xingEndLab = UILabel.init(frame: CGRect.init(x: 0, y: self.xingStartLab.bottom, width: AutoGetWidth(width: 30), height: AutoGetHeight(height: 55)))
        xingEndLab.textColor = UIColor.red
        xingEndLab.text = "*"
        xingEndLab.textAlignment = .center
        xingEndLab.font = kFontSize15
        return xingEndLab
    }()
    
    lazy var endLab: UILabel = {
        let endLab = UILabel.init(frame: CGRect.init(x: self.xingEndLab.right, y: self.startLab.bottom, width: AutoGetWidth(width: 80), height: AutoGetHeight(height: 55)))
        endLab.textColor = UIColor.black
        endLab.text = "结束时间"
        endLab.textAlignment = .left
        endLab.font = kFontSize15
        return endLab
    }()
    
    lazy var endBtn: UIButton = {
        let endBtn = UIButton.init(type: .custom)
        endBtn.frame = CGRect.init(x: AutoGetWidth(width: 110), y: self.startLab.bottom, width: kWidth - AutoGetWidth(width: 125), height: AutoGetHeight(height: 55))
        endBtn.setTitle("请选择结束时间", for: .normal)
        endBtn.setTitleColor(kLyGrayColor, for: .normal)
        endBtn.addTarget(self, action: #selector(endClick(btn:)), for: .touchUpInside)
        endBtn.tag = 201
        endBtn.titleLabel?.font = kFontSize15
        endBtn.titleEdgeInsets = UIEdgeInsetsMake(0, AutoGetWidth(width: 100), 0, 0)
        
        let arrowImg = UIImageView.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 131.5), y: AutoGetHeight(height: 21.5), width: AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 12)))
        arrowImg.image = UIImage.init(named: "PersonAddressArrow")
        endBtn.addSubview(arrowImg)
        return endBtn
    }()
    
    lazy var chooseCarTypeLab: UILabel = {
        let chooseCarTypeLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.endBtn.bottom, width: AutoGetWidth(width: 80), height: AutoGetHeight(height: 55)))
        chooseCarTypeLab.textColor = UIColor.black
        chooseCarTypeLab.text = "车辆类型"
        chooseCarTypeLab.textAlignment = .left
        chooseCarTypeLab.font = kFontSize15
        return chooseCarTypeLab
    }()
    
    lazy var chooseCarTypeBtn: UIButton = {
        let chooseCarTypeBtn = UIButton.init(type: .custom)
        chooseCarTypeBtn.frame = CGRect.init(x: AutoGetWidth(width: 95), y: self.endLab.bottom, width: kWidth - AutoGetWidth(width: 110), height: AutoGetHeight(height: 55))
        chooseCarTypeBtn.setTitle("请选择", for: .normal)
        chooseCarTypeBtn.setTitleColor(kLyGrayColor, for: .normal)
        chooseCarTypeBtn.addTarget(self, action: #selector(chooseCarTypeClick), for: .touchUpInside)
        chooseCarTypeBtn.titleLabel?.font = kFontSize15
        chooseCarTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, AutoGetWidth(width: 180), 0, 0)
        
        let arrowImg = UIImageView.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 116.5), y: AutoGetHeight(height: 21.5), width: AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 12)))
        arrowImg.image = UIImage.init(named: "PersonAddressArrow")
        chooseCarTypeBtn.addSubview(arrowImg)
        return chooseCarTypeBtn
    }()
    
    lazy var chooseCarXingLab: UILabel = {
        let chooseCarXingLab = UILabel.init(frame: CGRect.init(x: 0, y: self.endBtn.bottom, width: AutoGetWidth(width: 30), height: AutoGetHeight(height: 55)))
        chooseCarXingLab.textColor = UIColor.red
        chooseCarXingLab.text = "*"
        chooseCarXingLab.textAlignment = .center
        chooseCarXingLab.font = kFontSize15
        return chooseCarXingLab
    }()
    lazy var chooseCarLab: UILabel = {
        let chooseCarLab = UILabel.init(frame: CGRect.init(x: chooseCarXingLab.right, y: self.endBtn.bottom, width: AutoGetWidth(width: 80), height: AutoGetHeight(height: 55)))
        chooseCarLab.textColor = UIColor.black
        chooseCarLab.text = "车辆"
        chooseCarLab.textAlignment = .left
        chooseCarLab.font = kFontSize15
        return chooseCarLab
    }()
    
    lazy var chooseCarBtn: UIButton = {
        let chooseCarBtn = UIButton.init(type: .custom)
        chooseCarBtn.frame = CGRect.init(x: AutoGetWidth(width: 95), y: self.endBtn.bottom, width: kWidth - AutoGetWidth(width: 110), height: AutoGetHeight(height: 55))
        chooseCarBtn.setTitle("请选择", for: .normal)
        chooseCarBtn.setTitleColor(kLyGrayColor, for: .normal)
        chooseCarBtn.addTarget(self, action: #selector(chooseCarClick), for: .touchUpInside)
        chooseCarBtn.titleLabel?.font = kFontSize15
        chooseCarBtn.titleEdgeInsets = UIEdgeInsetsMake(0, AutoGetWidth(width: 165), 0, 0)
        
        let arrowImg = UIImageView.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 116.5), y: AutoGetHeight(height: 21.5), width: AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 12)))
        arrowImg.image = UIImage.init(named: "PersonAddressArrow")
        chooseCarBtn.addSubview(arrowImg)
        return chooseCarBtn
    }()
    
    lazy var descriV: UIView = {
        let descriV = UIView.init(frame: CGRect.init(x: kLeftDis, y: self.chooseCarBtn.bottom + AutoGetHeight(height: 14), width: kHaveLeftWidth, height: AutoGetHeight(height: 40)))
        descriV.backgroundColor = UIColor.colorWithHexString(hex: "#f2f6fc")
        descriV.layer.cornerRadius = 3
        return descriV
    }()
    
    lazy var desLab: UILabel = {
        let desLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kHaveLeftWidth - 2 * kLeftDis, height: AutoGetHeight(height: 40)))
        desLab.textColor = UIColor.colorWithHexString(hex: "#8b8b8b")
        desLab.text = "注：请先选择用车时段，系统会根据时间列出空闲车辆"
        desLab.textAlignment = .left
        desLab.font = kFontSize11
        return desLab
    }()
    
    lazy var attendPersonView: UIView = {
        let attendPersonView = UIView.init(frame: CGRect.init(x: 0, y:self.titleView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 145)))
        attendPersonView.backgroundColor = UIColor.white
        return attendPersonView
    }()
    lazy var attendPersonXingLab: UILabel = {
        let attendPersonXingLab = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: AutoGetWidth(width: 30), height: AutoGetHeight(height: 55)))
        attendPersonXingLab.textColor = UIColor.red
        attendPersonXingLab.text = "*"
        attendPersonXingLab.textAlignment = .center
        attendPersonXingLab.font = kFontSize15
        return attendPersonXingLab
    }()
    
    lazy var attendPersonLab: UILabel = {
        let attendPersonLab = UILabel.init(frame: CGRect.init(x: attendPersonXingLab.right, y: AutoGetHeight(height: 18), width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 15)))
        attendPersonLab.textColor = UIColor.black
        attendPersonLab.text = "审批人"
        attendPersonLab.textAlignment = .left
        attendPersonLab.font = kFontSize15
        return attendPersonLab
    }()
    
    
    lazy var collectionView: UICollectionView = {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width: kHaveLeftWidth/4, height: AutoGetHeight(height: 75))
        layOut.minimumLineSpacing = 0
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        //        layOut.headerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 38))
        //        layOut.footerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 11))
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: kLeftDis, y: self.attendPersonLab.bottom + AutoGetHeight(height: 14), width: kHaveLeftWidth, height: AutoGetHeight(height: 84)), collectionViewLayout: layOut)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(CQWriteReportCell.self, forCellWithReuseIdentifier: "CQWriteReportCellId")
        return collectionView
    }()
    
    lazy var footView: UIView = {
        let footView = UIView.init(frame: CGRect.init(x: 0, y: kHeight - AutoGetHeight(height: 64), width: kWidth, height:  AutoGetHeight(height: 64)))
        footView.backgroundColor = UIColor.white
        return footView
    }()
    
    lazy var submitBtn: UIButton = {
        let submitBtn = UIButton.init(type: .custom)
        submitBtn.frame = CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 8), width: kHaveLeftWidth, height: AutoGetHeight(height: 48))
        submitBtn.backgroundColor = kLightBlueColor
        submitBtn.setTitle("提 交", for: .normal)
        submitBtn.setTitleColor(UIColor.white, for: .normal)
        submitBtn.layer.cornerRadius = 3
        submitBtn.addTarget(self, action: #selector(submitClick), for: .touchUpInside)
        return submitBtn
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "派车"
        
        self.getApprovalPersonsRequest()
        
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
    
        self.headView.addSubview(self.titleView)
        self.titleView.addSubview(self.titleXingLab)
        self.titleView.addSubview(self.titleLab)
        self.titleView.addSubview(self.titleField)
        self.titleView.addSubview(self.contentXingLab)
        self.titleView.addSubview(self.contentLab)
        self.titleView.addSubview(self.contentField)
        self.titleView.addSubview(self.xingStartLab)
        self.titleView.addSubview(self.startLab)
        self.titleView.addSubview(self.startBtn)
        self.titleView.addSubview(self.xingEndLab)
        self.titleView.addSubview(self.endLab)
        self.titleView.addSubview(self.endBtn)
//        self.titleView.addSubview(self.chooseCarTypeLab)
//        self.titleView.addSubview(self.chooseCarTypeBtn)
        self.titleView.addSubview(self.chooseCarXingLab)
        self.titleView.addSubview(self.chooseCarLab)
        self.titleView.addSubview(self.chooseCarBtn)
        self.titleView.addSubview(self.descriV)
        self.descriV.addSubview(self.desLab)
        self.headView.addSubview(self.attendPersonView)
        self.attendPersonView.addSubview(self.attendPersonXingLab)
        self.attendPersonView.addSubview(self.attendPersonLab)
        self.attendPersonView.addSubview(self.collectionView)
//        self.view.addSubview(self.footView)
//        self.footView.addSubview(self.submitBtn)
        
        if self.isFromMyApplyVC{
            self.titleField.text = dataDic?["destination"] as? String
            self.contentField.text = dataDic?["applyReason"] as? String
            self.startBtn.setTitle(dataDic?["startDate"] as? String, for: .normal)
            self.startTime = (dataDic?["startDate"] as? String)!
            self.endBtn.setTitle(dataDic?["endDate"] as? String, for: .normal)
            self.endTime = (dataDic?["endDate"] as? String)!
            if dataDic?["carType"] as? NSNumber == 1{
              //  self.carName = "商务车"
                self.carId = dataDic?["carType"] as? NSNumber as! Int
            }else if dataDic?["carType"] as? NSNumber == 2{
              //  self.carName = "货车"
                self.carId = dataDic?["carType"] as? NSNumber as! Int
            }else if dataDic?["carType"] as? NSNumber == 3{
              //  self.carName = "客车"
                self.carId = dataDic?["carType"] as? NSNumber as! Int
            }
           // self.chooseCarTypeBtn.setTitle(self.carName, for: .normal)
            let arr = dataDic!["pbulicCar"] as! NSDictionary
            self.car = (arr["name"] as? String)!
            self.carModel = CQCarsModel.init(name: arr["name"] as! String, carId: arr["entityId"] as! String)
            self.chooseCarBtn.setTitle(arr["name"] as? String, for: .normal)
            
        }
        
        for i in 1..<6 {
            let lineView = UIView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 55) * CGFloat(i), width: kWidth, height: 0.5))
            lineView.backgroundColor = kLineColor
            self.titleView.addSubview(lineView)
        }
        
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 44))
        rightBtn.sizeToFit()
        rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, -6)
        rightBtn.setTitle("提交", for: .normal)
        rightBtn.setTitleColor(kBlueColor, for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rightBtn.addTarget(self, action: #selector(submitClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func startClick(btn:UIButton)  {
        self.initDatePickView(tag:btn.tag)
    }
    
    @objc func endClick(btn:UIButton)  {
        self.initDatePickView(tag:btn.tag)
    }
    
    @objc func chooseCarTypeClick()  {
//        let vc = CQCarTypeVC()
//        vc.selectDelegate = self
//        self.navigationController?.pushViewController(vc, animated: true)
        let carView = QRCarTypeTabView.creatCarTypeTabView()
        carView.clickClosure = {[unowned self] id,carMod in
            self.carId = id
//            self.carModel = carMod
//            self.car = carMod.carNumber
//            self.chooseCarBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
//            self.chooseCarBtn.setTitle(carMod.carNumber, for: UIControlState.normal)
                    let vc = CQChooseCarVC()
                    vc.startDate = self.startTime
                    vc.endDate = self.endTime
                    vc.carType = self.carId
                    vc.selectDelegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
        }
        carView.showPopView()
    }
    
    @objc func chooseCarClick()  {
        if self.startTime.isEmpty {
            SVProgressHUD.showInfo(withStatus: "请选择开始时间")
            return
        }else if self.endTime.isEmpty {
            SVProgressHUD.showInfo(withStatus: "请选择结束时间")
            return
        }
         self.chooseCarTypeClick()
//        else if self.carName.isEmpty{
//            SVProgressHUD.showInfo(withStatus: "请选择车辆类型")
//            return
//        }
//        let vc = CQChooseCarVC()
//        vc.startDate = startTime
//        vc.endDate = endTime
//        vc.carType = self.carId
//        vc.selectDelegate = self
//        self.navigationController?.pushViewController(vc, animated: true)
       
    }
    
    @objc func submitClick()  {
        let dic = ["businessApplyDatas":[["destination":self.titleField.text ?? "",
                                          "applyReason":self.contentField.text ?? "",
                                          "startDate":self.startTime,
                                          "endDate":self.endTime,
                                          "carType":self.carId,
                                          "pbulicCar":["entityId":self.carModel?.entityId,
                                                       "name":self.carModel?.carNumber]]]]
        
        if self.endTime.count > 0 && self.startTime.count > 0 && (self.titleField.text?.count)! > 0 && (self.contentField.text?.count)! > 0 && self.car.count > 0{
            self.formStr = getJSONStringFromDictionary(dictionary: dic as NSDictionary)
            self.loadingPlay()
            self.applySubmitRequest(data: self.formStr)
        }else{
            if (self.titleField.text?.isEmpty)!{
                SVProgressHUD.showInfo(withStatus: "请填写地点")
            }else if (self.contentField.text?.isEmpty)!{
                SVProgressHUD.showInfo(withStatus: "请填写用车事由")
            }else if self.startTime.isEmpty{
                SVProgressHUD.showInfo(withStatus: "请选择开始时间")
            }else if self.endTime.isEmpty{
                SVProgressHUD.showInfo(withStatus: "请选择结束时间")
            }else if self.car.isEmpty{
                SVProgressHUD.showInfo(withStatus: "请选择车辆")
            }
//            else if self.carName.isEmpty{
//                SVProgressHUD.showInfo(withStatus: "请选择车辆类型")
//            }
        }
        
        
    }
    
    
}

extension CQCarApplyVC{
    //提交
    func applySubmitRequest(data:String) {
        let userId = STUserTool.account().userID
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/applySubmit" ,
            type: .post,
            param: ["approvalBusinessId":"",
                    "businessApplyId":"",
                    "businessCode":"B_CL",
                    "copyPersonIds":"",
                    "emyeId":userId,
                    "formData":data],
            successCallBack: { (result) in
                self.loadingSuccess()
                SVProgressHUD.showSuccess(withStatus: "发布成功")
                if self.isFromMyApplyVC{
                    for v in (self.navigationController?.viewControllers)!{
                        if v is CQMeSubmitVC{
                            NotificationCenter.default.post(name: NSNotification.Name.init("refreshMeApplyUI"), object: nil)
                            self.navigationController?.popToViewController(v, animated: true)
                        }
                    }
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
        }) { (error) in
            self.loadingSuccess()
        }
    }
    
    //获得审批人
    func getApprovalPersonsRequest() {
        let userId = STUserTool.account().userID
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getApplyApprovalPersons" ,
            type: .post,
            param: ["approvalBusinessId":"",
                    "businessCode":"B_CL",
                    "emyeId":userId,
                    "vacationTypeId":""],
            successCallBack: { (result) in
              
                var arr = [CQDepartMentUserListModel]()
                
                self.userArray.removeAll()
                
                for modalJson in result["data"]["approvalFlowPersonUnitJsonList"].arrayValue  {
                    guard let modal = CQDepartMentUserListModel(jsonData: JSON(modalJson)) else {
                        return
                    }
                    DLog(modal)
                    arr.append(modal)
                }
                
                self.userArray = arr
                
                self.collectionView.reloadData()
        }) { (error) in
            
        }
    }
}

// MARK:datapicker构造及点击事件
extension CQCarApplyVC{
    func initDatePickView(tag:Int)  {
        let currentTag = tag - 200
        self.view.endEditing(true)
       // bgView.frame = CGRect(x: 0, y: 64, width: kWidth, height: kHeight - 64)
        bgView.frame = CGRect(x: 0, y: SafeAreaTopHeight, width: kWidth, height: kHeight - SafeAreaTopHeight - SafeAreaBottomHeight)
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
        datePicker.datePickerMode = .dateAndTime
        datePicker.backgroundColor = .white
        datePicker.tag = 10086 + currentTag
        //注意：action里面的方法名后面需要加个冒号“：”
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        colorBgV.addSubview(datePicker)
        
        let whiteV = UIView(frame:  CGRect(x: 0, y: datePicker.bottom, width: kWidth, height: SafeAreaBottomHeight))
        whiteV.backgroundColor = UIColor.white
        colorBgV.addSubview(whiteV)
    }
    
    @objc func removeBgView(sender: UIButton) {
        self.bgView.removeAllSubviews()
        self.bgView.removeFromSuperview()
    }
//    let startDate = Date(dateString: startTime, format: "yyyy-MM-dd HH:mm")
//    let endDate = Date(dateString: endTime, format: "yyyy-MM-dd HH:mm")
//    if endDate.isEarlier(than: startDate){
//    SVProgressHUD.showInfo(withStatus: "结束时间需要大于开始时间,请重新选择")
//    endTime = ""
//    self.endChooseLab.text = ""
    @objc func sureClick(btn:UIButton) {
        
        if btn.tag == 700 {
        
            let btn:UIButton = self.view.viewWithTag(200) as! UIButton
            btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 100))
            if startTime.isEmpty{
                let now = Date()
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
                self.startTime = dateFormat.string(from: now)
                btn.setTitle(startTime, for: .normal)
            }else{
                btn.setTitle(startTime, for: .normal)
            }
            
            btn.titleLabel?.font = kFontSize15
            btn.setTitleColor(UIColor.black, for: UIControlState.normal)
            
            if !endTime.isEmpty {
                if self.compareDate(){
                    
                }else{
                    btn.setTitle("", for: .normal)
                    self.startTime = ""
                    SVProgressHUD.showInfo(withStatus: "结束时间必须大于开始时间")
                }
            }
            
        }else if btn.tag == 701 {
            
            let btn:UIButton = self.view.viewWithTag(201) as! UIButton
            btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -AutoGetWidth(width: 100))
            if endTime.isEmpty{
                let now = Date()
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
                self.endTime = dateFormat.string(from: now)
                btn.setTitle(endTime, for: .normal)
            }else{
                btn.setTitle(endTime, for: .normal)
            }
            btn.titleLabel?.font = kFontSize15
            btn.setTitleColor(UIColor.black, for: UIControlState.normal)
            if !startTime.isEmpty {
                if self.compareDate() {
                    
                }else{
                    btn.setTitle("", for: .normal)
                    self.endTime = ""
                    SVProgressHUD.showInfo(withStatus: "结束时间必须大于开始时间")
                }
            }
            
        }
        self.bgView.removeAllSubviews()
        self.bgView.removeFromSuperview()
    }
    
    //日期选择器响应方法
    @objc func dateChanged(datePicker : UIDatePicker){
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        if datePicker.tag == 10086 {
            startTime = formatter.string(from: datePicker.date)
        }else{
            endTime = formatter.string(from: datePicker.date)
        }
    }
    
    func compareDate() -> Bool {
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let BDate:Date?
        let EDate:Date?
        BDate = formatter.date(from: startTime)
        EDate = formatter.date(from: endTime)
        let result:ComparisonResult = (BDate?.compare(EDate!))!
        if result == .orderedDescending || result == .orderedSame {
            return false
        }
        return true
    }
}

extension CQCarApplyVC:UITextFieldDelegate,KeyBoardDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    @objc func textFieldEditChanged(obj:Notification)  {
        
    }
}

// MARK: - 代理

extension CQCarApplyVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userArray.count
    }
    
}

extension CQCarApplyVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQWriteReportCellId", for: indexPath) as! CQWriteReportCell
        cell.nameLab.text = self.userArray[indexPath.item].realName
        cell.img.sd_setImage(with: URL(string: self.userArray[indexPath.item].headImage ), placeholderImage:UIImage.init(named: "personDefaultIcon") )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension CQCarApplyVC:CQCarTypeSelectDelegate{
    func carTypeSelect(carType: Int,name:String) {
        if self.carId==carId && self.carName==name{
            
        }else{
            self.carId = carType
            self.carName =  name
            self.chooseCarTypeBtn.setTitle(self.carName, for: .normal)
            self.chooseCarTypeBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            self.chooseCarBtn.setTitle("", for: UIControlState.normal)
        }
       
    }
}

extension CQCarApplyVC:CQRoomSelectDelegate{
    func selectRoom(model: CQChooseRoomModel) {
        
    }
}

extension CQCarApplyVC:CQCarSelectDelegate{
    func selectCar(model: CQCarsModel) {
        self.carModel = model
        self.car = model.carNumber
        self.chooseCarBtn.setTitle(self.car, for: .normal)
        self.chooseCarBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        
    }
}

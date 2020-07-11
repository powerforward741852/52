//
//  NCQApprovelVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/10/15.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit
import AVKit
import AssetsLibrary
import MediaPlayer
import MobileCoreServices


class NCQApprovelVC: SuperVC {
    
    
    //加班结束时间提醒
    var isOverTime : Bool = false
    //外出传值
    var curLatitude : Double?
    var curLongitude : Double?
    var addressRemark = ""
    var outReason = ""
    
    weak var rootLayout :TGLinearLayout!
    var businessCode = ""
    var approvalBusinessId = ""
    var approvelArray = [CQCopyForModel]() //审核列表
    var copyArray = [CQDepartMentUserListModel]() //抄送人列表
    var copyCollectionLayout:CQCopyToLayout!
    //标题
    var titleStr = ""
    //抄送人id和名字
    var userIdArr = [String]()
    var userNameArr = [String]()
    
    //
    var curType = ""  //当前界面类型
    
    
    //选中开始时间
    var startTime = ""
    //选中结束时间
    var endTime = ""
    //请假类型
    var vacationTypeId:Int = -1
    //请假类型数组
    var leaveDataArray = [String]()
    //请假类型id数组
    var leaveIdArray = [Int]()
    
    //
    
    var startTimeLayout:CQStartSelectLayout!
    var endTimeLayout:CQEndSelectLayout!
    
    //请假layout
    var leaveLayout:CQLeaveTypeLayout!
    //时长layout
    var durationLayout:CQDurationLayout!
    //我的假期layout
    var myLeaveLayout:CQMyVocationBalanceLayout!
    //是否更新请假(加班，外出)审批人
    var isChangeApproveler = false
    //时长
    var duration = ""
    //当前全部视图得出总高度
    var viewHeight:CGFloat! = AutoGetHeight(height: 88)
    //上次抄送人高度
    var lastCopyCollectionHeight:CGFloat!
    //补卡时间layout
    var modifyTimeLayout:CQModeifyTimeLayout!
    //补卡时间
    var modifyTime = ""
    //交通工具类型id
    var traficTypeId = ""
    //是否往返
    var isBanck:Bool!
    //出发城市
    var fromCity = ""
    //到达城市
    var toCity = ""
    //出差总时长
    var travalDay:Double = 0.00 //出差时间
    //出差天数layout
    var bussinessDayLayout:CQBussinessDayLayout!
    //交通数组
    var traficArray = [NCQApprovelModel]()
    //往返数组
    var backArray = [CQBackModel]()
    //时长字典数组
    var durationDic = [NSMutableDictionary]()
    //出差计算所得时长
    var totalDay:Double = 0.00
    //checkBox数组
    var checkBoxArray = [NCQApprovelModel]()
    
    //审批人抄送人申请id
    var detailBid = ""
    //从我提交的详情进
    var isFromApplyDetail = false
    //
    var isFromSubmitDetail = false
    //审批人layout
    var approvelCollectionLayout:CQApproverLayout!
    //人员选择model
    var personModel:CQDepartMentUserListModel?
    //部门选择layout
    var departMentLayout:CQDepartmentLayout!
    
    //上传类型
    var flag = ""
    //上传图片数组
    var photoArray = [UIImage]()
    
    //上传文件名数组
    var uploadFileNameArray = [String]()
    //上传文件url数组
    var uploadUrlArray = [String]()
    //上传文件model数组
    var uploadModelArray = [NCQApprovelDetailModel]()
    //上传文件layout
    var uploadLayout:CQAttachUpLoadLayout!
    
    //外勤头部地址控件
    lazy var locationV : UIView = {
        let locationV = UIView(frame:  CGRect(x: 0, y: SafeAreaTopHeight, width: kWidth, height: AutoGetHeight(height: 35)))
        locationV.backgroundColor = kProjectBgColor
        return locationV
    }()
    
    lazy var img : UIImageView = {
        let img = UIImageView(frame:  CGRect(x: AutoGetHeight(height: 15), y: AutoGetHeight(height: 17/2), width: AutoGetHeight(height: 15), height: AutoGetHeight(height: 18)))
        img.image = UIImage(named: "FieldPersonelLocation")
        return img
    }()
    
    lazy var locationTitle :UILabel = {
        let big = UILabel(title: "厦门市软件园二期", textColor: UIColor.black, fontSize: 14)
        big.frame = CGRect(x: img.right+7, y: 0, width: kWidth-img.right-7, height: AutoGetHeight(height: 35))
        big.textAlignment = .left
        big.numberOfLines = 2
        return big
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.isFromApplyDetail{
            self.loadSubmitDetailData()
        }else{
            self.setUpRefresh()
        }
        
        
        self.initView()
        
        
    }
    
    func initView()  {
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
        self.title = self.titleStr
        //        self.headView.tg_width.equal(.wrap)
        self.headView.tg_height.equal(.wrap)
        //如果一个非布局父视图里面有布局子视图，那么这个非布局父视图也是可以将高度和宽度设置为.wrap的，他表示的意义是这个非布局父视图的尺寸由里面的布局子视图的尺寸来决定的。还有一个场景是非布局父视图是一个UIScrollView。他是左右滚动的，但是滚动视图的高度是由里面的布局子视图确定的，而宽度则是和窗口保持一致。这样只需要将滚动视图的宽度设置为和屏幕保持一致，高度设置为.wrap，并且把一个水平线性布局添加到滚动视图即可。
        let rootLayout = TGLinearLayout(.vert)
        rootLayout.tg_height.equal(.wrap)
        rootLayout.tg_width.equal(.wrap)
        //        rootLayout.tg_padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        rootLayout.tg_zeroPadding = false   //这个属性设置为false时表示当布局视图的尺寸是wrap也就是由子视图决定时并且在没有任何子视图是不会参与布局视图高度的计算的。您可以在这个DEMO的测试中将所有子视图都删除掉，看看效果，然后注释掉这句代码看看效果。
        //        rootLayout.tg_vspace = 5
        self.headView.addSubview(rootLayout)
        self.rootLayout = rootLayout
        
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 44))
        rightBtn.setTitle("提交", for: .normal)
        rightBtn.setTitleColor(kBlueColor, for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rightBtn.contentHorizontalAlignment = .right
        rightBtn.addTarget(self, action: #selector(submitClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        
        
        self.initNotif()
        
    }
    
    func initNotif()  {
        //开始时间
        NotificationCenter.default.addObserver(self, selector: #selector(checkStartTime(notif:)), name: NSNotification.Name.init("startTimeValue"), object: nil)
        //结束时间
        NotificationCenter.default.addObserver(self, selector: #selector(checkEndTime(notif:)), name: NSNotification.Name.init("endTimeValue"), object: nil)
        //假期类型
        NotificationCenter.default.addObserver(self, selector: #selector(checkVocationType(notif:)), name: NSNotification.Name.init("vacationTypeIdValue"), object: nil)
        //时间选择后  时长
        NotificationCenter.default.addObserver(self, selector: #selector(checkModifyTime(notif:)), name: NSNotification.Name.init("ModifyTimeValue"), object: nil)
        //交通工具
        NotificationCenter.default.addObserver(self, selector: #selector(checkTraficType(notif:)), name: NSNotification.Name.init("traficIdIdValue"), object: nil)
        //是否往返
        NotificationCenter.default.addObserver(self, selector: #selector(checkBackType(notif:)), name: NSNotification.Name.init("backValue"), object: nil)
        //出发城市
        NotificationCenter.default.addObserver(self, selector: #selector(fromCityType(notif:)), name: NSNotification.Name.init("fromCityValue"), object: nil)
        //到达城市
        NotificationCenter.default.addObserver(self, selector: #selector(toCityType(notif:)), name: NSNotification.Name.init("toCityValue"), object: nil)
        //出差时长
        NotificationCenter.default.addObserver(self, selector: #selector(travelDaySum(notif:)), name: NSNotification.Name.init("travelDayValue"), object: nil)
        //高
        NotificationCenter.default.addObserver(self, selector: #selector(addHeight(notif:)), name: NSNotification.Name.init("addHeight"), object: nil)
        //高
        NotificationCenter.default.addObserver(self, selector: #selector(shortHeight(notif:)), name: NSNotification.Name.init("shortHeight"), object: nil)
        //同行人
        NotificationCenter.default.addObserver(self, selector: #selector(personChangeHeight(notif:)), name: NSNotification.Name.init("togherPersonChosseValue"), object: nil)
       // NotificationCenter.default.addObserver(self, selector: #selector(personChangeHeight(notif:)), name: NSNotification.Name.init("together"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(hiddenTheKeyBoard(notif:)), name: NSNotification.Name.init("cancelKeyBoard"), object: nil)
        //这应该是选择部门
        NotificationCenter.default.addObserver(self, selector: #selector(checkBoxValue(notif:)), name: NSNotification.Name.init("checkBoxValue"), object: nil)
        //审批人
//        let NotifMycation = NSNotification.Name(rawValue:"refreshSupplyCell")
//        NotificationCenter.default.addObserver(self, selector: #selector(upDataChange(notif:)), name: NotifMycation, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(upDataChange(notif:)), name: NSNotification.Name.init("AddTracker"), object: nil)
        
        //抄送人
        NotificationCenter.default.addObserver(self, selector: #selector(changeCopyArrayData(notif:)), name: NSNotification.Name.init("changeCopyNum"), object: nil)
        
        
        
        //删除文件
        NotificationCenter.default.addObserver(self, selector: #selector(deleteFileAction(notif:)), name: NSNotification.Name.init("fileDelete"), object: nil)
        //出差多行程的字典
        NotificationCenter.default.addObserver(self, selector: #selector(chuChaiChangePeoData(notif:)), name: NSNotification.Name.init("chuChaiAdd"), object: nil)
        //开始时间
        NotificationCenter.default.addObserver(self, selector: #selector(checkStartTime(notif:)), name: NSNotification.Name.init("startTimeValue"), object: nil)
        //结束时间
        NotificationCenter.default.addObserver(self, selector: #selector(checkEndTime(notif:)), name: NSNotification.Name.init("endTimeValue"), object: nil)
        //出差时长
        NotificationCenter.default.addObserver(self, selector: #selector(travelDaySum(notif:)), name: NSNotification.Name.init("travelDayValue"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init("startTimeValue"), object: nil)
//         NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init("endTimeValue"), object: nil)
//        //出差时长
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init("travelDayValue"), object: nil)
//        NotificationCenter.default.removeObserver(self)
//        self.initNotif()
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //点击事件处理
    @objc func submitClick()  {
        var dicArr = [Any]()
        let dic = NSMutableDictionary.init()
        for v in self.rootLayout.subviews{
            if self.curType == "business"{
                if v is CQTextInputLayout{
                    if (v as! CQTextInputLayout).required{
                        var txtL = ""
                        txtL = (v as! CQTextInputLayout).textView.textView.text
                        if txtL == (v as! CQTextInputLayout).textView.placeHolder{
                            txtL = ""
                        }
                        if  txtL.count <= 0 {
                            SVProgressHUD.showError(withStatus: "带*为必填项，请输入完整")
                            return
                        }
                    }
                    
                    dic.setObject((v as! CQTextInputLayout).textView.textView.text, forKey:(v as! CQTextInputLayout).curName as NSCopying)
                    
                }else if v is CQBussinessDayLayout{
                    if (v as! CQBussinessDayLayout).required{
                        if self.totalDay == 0.00 {
                            SVProgressHUD.showError(withStatus: "带*为必填项，请输入完整")
                            return
                        }
                    }
                    
                    dic.setObject(self.totalDay, forKey:(v as! CQBussinessDayLayout).curName as NSCopying)
                }else if v is CQChoosePersonLayout{
                    if (v as! CQChoosePersonLayout).required{
                        if (v as! CQChoosePersonLayout).dataArray.count <= 0{
                            SVProgressHUD.showError(withStatus: "带*为必填项，请输入完整")
                            return
                        }
                    }
                    var curArr = [NSMutableDictionary]()
                    for model in (v as! CQChoosePersonLayout).dataArray{
                        let contentDic = NSMutableDictionary.init()
                        contentDic.setValue(model.userId, forKey: "entityId")
                        contentDic.setValue(model.realName, forKey: "name")
                        contentDic.setValue(model.headImage, forKey: "url")
                        curArr.append(contentDic)
                    }
                    
                    dic.setObject(curArr, forKey: (v as! CQChoosePersonLayout).curName as NSCopying)
                }
            }else {
                if v is CQLeaveTypeLayout{
                    if (v as! CQLeaveTypeLayout).required{
                        if (v as! CQLeaveTypeLayout).curSelectTitle.isEmpty{
                            SVProgressHUD.showError(withStatus: "带*为必填项，请输入完整")
                            return
                        }
                    }
                    dic.setObject((v as! CQLeaveTypeLayout).vacationTypeId!, forKey: (v as! CQLeaveTypeLayout).curName as NSCopying)
                }else if v is CQStartSelectLayout{
                    if (v as! CQStartSelectLayout).required{
                        if (v as! CQStartSelectLayout).startTime.isEmpty{
                            SVProgressHUD.showError(withStatus: "带*为必填项，请输入完整")
                            return
                        }
                    }
                    
                    dic.setObject((v as! CQStartSelectLayout).startTime, forKey:(v as! CQStartSelectLayout).curName as NSCopying)
                }else if v is CQEndSelectLayout{
                    if (v as! CQEndSelectLayout).required{
                        if (v as! CQEndSelectLayout).endTime.isEmpty{
                            SVProgressHUD.showError(withStatus: "带*为必填项，请输入完整")
                            return
                        }
                    }
                    
                    dic.setObject((v as! CQEndSelectLayout).endTime, forKey:(v as! CQEndSelectLayout).curName as NSCopying)
                }else if v is CQDurationLayout{
                    if (v as! CQDurationLayout).required{
                        if (v as! CQDurationLayout).duration.isEmpty{
                            SVProgressHUD.showError(withStatus: "带*为必填项，请输入完整")
                            return
                        }
                    }
                    
                    dic.setObject(self.duration, forKey:(v as! CQDurationLayout).curName as NSCopying)
                }else if v is CQTextInputLayout{
                    if (v as! CQTextInputLayout).required{
                        var txtL = ""
                        txtL = (v as! CQTextInputLayout).textView.textView.text
                        if txtL == (v as! CQTextInputLayout).textView.placeHolder{
                            txtL = ""
                        }
                        if  txtL.count <= 0 {
                            SVProgressHUD.showError(withStatus: "带*为必填项，请输入完整")
                            return
                        }
                    }
                    
                    dic.setObject((v as! CQTextInputLayout).textView.textView.text, forKey:(v as! CQTextInputLayout).curName as NSCopying)
                    
                }else if v is CQModeifyTimeLayout{
                    if (v as! CQModeifyTimeLayout).required{
                        if self.modifyTime.isEmpty{
                            SVProgressHUD.showError(withStatus: "带*为必填项，请输入完整")
                            return
                        }
                    }
                    
                    dic.setObject(self.modifyTime, forKey:(v as! CQModeifyTimeLayout).curName as NSCopying)
                }else if v is CQTraficLayout{
                    if (v as! CQTraficLayout).required{
                        if self.traficTypeId.isEmpty{
                            SVProgressHUD.showError(withStatus: "带*为必填项，请输入完整")
                            return
                        }
                    }
                    
                    dic.setObject(self.traficTypeId, forKey:(v as! CQTraficLayout).curName as NSCopying)
                }else if v is CQIsBackLayout{
                    if (v as! CQIsBackLayout).required{
                        if (v as! CQIsBackLayout).curSelectTitle.isEmpty{
                            SVProgressHUD.showError(withStatus: "带*为必填项，请输入完整")
                            return
                        }
                    }
                    
                    dic.setObject(self.isBanck, forKey:(v as! CQIsBackLayout).curName as NSCopying)
                }else if v is CQFromCityLayout{
                    if (v as! CQFromCityLayout).required{
                        if (v as! CQFromCityLayout).curSelectTitle.isEmpty{
                            SVProgressHUD.showError(withStatus: "带*为必填项，请输入完整")
                            return
                        }
                    }
                    
                    dic.setObject(self.fromCity, forKey:(v as! CQFromCityLayout).curName as NSCopying)
                }else if v is CQToCityLayout{
                    if (v as! CQToCityLayout).required{
                        if (v as! CQToCityLayout).curSelectTitle.isEmpty{
                            SVProgressHUD.showError(withStatus: "带*为必填项，请输入完整")
                            return
                        }
                    }
                    
                    dic.setObject(self.toCity, forKey:(v as! CQToCityLayout).curName as NSCopying)
                }else if v is CQBussinessDayLayout{
                    if (v as! CQBussinessDayLayout).required{
                        if self.travalDay == 0.00{
                            SVProgressHUD.showError(withStatus: "带*为必填项，请输入完整")
                            return
                        }
                    }
                    dic.setObject(self.totalDay, forKey:(v as! CQBussinessDayLayout).curName as NSCopying)
                }else if v is CQTelNumLayout{
                    if (v as! CQTelNumLayout).required{
                        if (((v as! CQTelNumLayout).viewWithTag(401) as! UITextField).text?.isEmpty)! {
                            SVProgressHUD.showError(withStatus: "带*为必填项，请输入完整")
                            return
                        }
                    }
                    dic.setObject(((v as! CQTelNumLayout).viewWithTag(401) as! UITextField).text!, forKey:(v as! CQTelNumLayout).curName as NSCopying)
                }else if v is CQCountInputLayout{
                    if (v as! CQCountInputLayout).required{
                        if (((v as! CQCountInputLayout).viewWithTag(401) as! UITextField).text?.isEmpty)! {
                            SVProgressHUD.showError(withStatus: "带*为必填项，请输入完整")
                            return
                        }
                    }
                    dic.setObject(((v as! CQCountInputLayout).viewWithTag(401) as! UITextField).text!, forKey:(v as! CQCountInputLayout).curName as NSCopying)
                }else if v is CQCheckBoxLayout{
                    if (v as! CQCheckBoxLayout).required{
                        if (v as! CQCheckBoxLayout).postValue.isEmpty {
                            SVProgressHUD.showError(withStatus: "带*为必填项，请输入完整")
                            return
                        }
                    }
                    dic.setObject((v as! CQCheckBoxLayout).postValue, forKey:(v as! CQCheckBoxLayout).curName as NSCopying)
                }else if v is CQDateChooseLayout{
                    if (v as! CQDateChooseLayout).required{
                        if (v as! CQDateChooseLayout).defualtv.isEmpty {
                            SVProgressHUD.showError(withStatus: "带*为必填项，请输入完整")
                            return
                        }
                    }
                    dic.setObject((v as! CQDateChooseLayout).defualtv, forKey:(v as! CQDateChooseLayout).curName as NSCopying)
                }else if v is CQAreaChooseLayout{
                    if (v as! CQAreaChooseLayout).required{
                        if (v as! CQAreaChooseLayout).curSelectTitle.isEmpty {
                            SVProgressHUD.showError(withStatus: "带*为必填项，请输入完整")
                            return
                        }
                    }
                    dic.setObject((v as! CQAreaChooseLayout).curSelectTitle, forKey:(v as! CQAreaChooseLayout).curName as NSCopying)
                }else if v is CQPersonChooseLayout{
                    if (v as! CQPersonChooseLayout).required{
                        if (v as! CQPersonChooseLayout).dataArray.count <= 0 {
                            SVProgressHUD.showError(withStatus: "带*为必填项，请输入完整")
                            return
                        }
                    }
                    var curArr = [NSMutableDictionary]()
                    for model in (v as! CQPersonChooseLayout).dataArray{
                        let contentDic = NSMutableDictionary.init()
                        if model.realName.isEmpty{
                            contentDic.setValue(model.entityId, forKey: "entityId")
                            contentDic.setValue(model.name, forKey: "name")
                            contentDic.setValue(model.url, forKey: "url")
                        }else{
                            contentDic.setValue(model.userId, forKey: "entityId")
                            contentDic.setValue(model.realName, forKey: "name")
                            contentDic.setValue(model.headImage, forKey: "url")
                        }
                        curArr.append(contentDic)
                    }
                    dic.setObject(curArr, forKey:(v as! CQPersonChooseLayout).curName as NSCopying)
                }else if v is CQDepartmentLayout{
                    if (v as! CQDepartmentLayout).required{
                        if (v as! CQDepartmentLayout).dataArray.count <= 0 {
                            SVProgressHUD.showError(withStatus: "带*为必填项，请输入完整")
                            return
                        }
                    }
                    var curArr = [NSMutableDictionary]()
                    for model in (v as! CQDepartmentLayout).dataArray{
                        let contentDic = NSMutableDictionary.init()
                        if model.departmentName.isEmpty{
                            contentDic.setValue(model.entityId, forKey: "entityId")
                            contentDic.setValue(model.name, forKey: "name")
                        }else{
                            contentDic.setValue(model.departmentId, forKey: "entityId")
                            contentDic.setValue(model.departmentName, forKey: "name")
                        }
                        curArr.append(contentDic)
                    }
                    dic.setObject(curArr, forKey:(v as! CQDepartmentLayout).curName as NSCopying)
                }else if v is CQAttachUpLoadLayout{
//                    if (v as! CQAttachUpLoadLayout).required{
//                        if (v as! CQAttachUpLoadLayout).dataArray.count <= 0 {
//                            SVProgressHUD.showError(withStatus: "带*为必填项，请输入完整")
//                            return
//                        }
//                    }
                    var curArr = [NSMutableDictionary]()
                    for model in (v as! CQAttachUpLoadLayout).dataArray{
                        let contentDic = NSMutableDictionary.init()
                        if model.fileName.isEmpty{
                            contentDic.setValue(model.name, forKey: "name")
                            contentDic.setValue(model.flieUrl, forKey: "flieUrl")
                        }else{
                            contentDic.setValue(model.fileName, forKey: "name")
                            contentDic.setValue(model.fileUrl, forKey: "flieUrl")
                        }
                        
                        curArr.append(contentDic)
                    }
                    dic.setObject(curArr, forKey:(v as! CQAttachUpLoadLayout).curName as NSCopying)
                }
            }
        }
        let personDic = NSMutableDictionary.init()
        var detailArr = [NSMutableDictionary]()
        if self.curType == "leave"{
            personDic.setValue(STUserTool.account().userID as NSCopying, forKey: "entityId")
            personDic.setValue(STUserTool.account().realName as NSCopying, forKey:"name")
            personDic.setValue(STUserTool.account().headImage as NSCopying, forKey: "url")
            dic.setValue(personDic, forKey: "leavePerson")
        }else if self.curType == "overtime"{
            personDic.setValue(STUserTool.account().userID as NSCopying, forKey: "entityId")
            personDic.setValue(STUserTool.account().realName as NSCopying, forKey:"name")
            personDic.setValue(STUserTool.account().headImage as NSCopying, forKey: "url")
            dic.setValue(personDic, forKey: "extraPerson")
        }else if self.curType == "business"{
            let contentDic:NSMutableDictionary = NSMutableDictionary.init()
            contentDic.setValue(self.traficTypeId, forKey: "transport")
            contentDic.setValue(self.isBanck, forKey: "isBack")
            contentDic.setValue(self.fromCity, forKey: "fromCity")
            contentDic.setValue(self.toCity, forKey: "toCity")
            contentDic.setValue(self.startTime, forKey: "startTime")
            contentDic.setValue(self.endTime, forKey: "endTime")
            contentDic.setValue(self.duration, forKey: "duration")
            detailArr.append(contentDic)
            
            for v in self.rootLayout.subviews{
                if v is CQAddTravelLayout{
                    for subV in v.subviews{
                        if subV.tag == 10086{
                            for hardV in subV.subviews{
                                if hardV is CQTravelListLayout{
                                    let contentDic:NSMutableDictionary = NSMutableDictionary.init()
                                    contentDic.setValue((hardV as! CQTravelListLayout).traficId, forKey: "transport")
                                    contentDic.setValue((hardV as! CQTravelListLayout).isBack, forKey: "isBack")
                                    contentDic.setValue((hardV as! CQTravelListLayout).fromCity, forKey: "fromCity")
                                    contentDic.setValue((hardV as! CQTravelListLayout).toCity, forKey: "toCity")
                                    contentDic.setValue((hardV as! CQTravelListLayout).startTime, forKey: "startTime")
                                    contentDic.setValue((hardV as! CQTravelListLayout).endTime, forKey: "endTime")
                                    contentDic.setValue((hardV as! CQTravelListLayout).duration, forKey: "duration")
                                    detailArr.append(contentDic)
                                }
                            }
                        }
                    }
                }
            }
            
            dic.setValue(detailArr, forKey: "businessDetail")
        }
       
        
        dicArr.append(dic)
        DLog(dicArr)
        let formDic = ["businessApplyDatas":dicArr]
        DLog(formDic)
        let formStr = getJSONStringFromDictionary(dictionary: formDic as NSDictionary)
        self.loadingPlay()
        self.applySubmitRequest(data: formStr)
    }
    
    @objc func chuChaiChangePeoData(notif:NSNotification){
        
    }
    
    
    
    //收到开始时间参数
    @objc func checkStartTime(notif: NSNotification) {
        guard let timeStr:String = notif.object as! String? else { return }
        self.startTime = timeStr
        DLog(self.startTime)
        if self.curType == "leave"{
            if !self.startTime.isEmpty && !self.endTime.isEmpty && (self.vacationTypeId > 0){
                self.getLeaveTimeRequest()
                self.isChangeApproveler = true
            }
        }
        else if self.curType == "overtime" || self.curType == "outWork"{
            if !self.startTime.isEmpty && !self.endTime.isEmpty {
                self.isChangeApproveler = true
                if self.curType == "outWork"{
                    self.calculateDurationRequest(type: "outWork", start: self.startTime, end:self.endTime , i: 0)
                }else{
                    //判断是否结束天是否是当天
                    if isOverTime == true {
                        let startDate = Date(dateString: self.startTime, format: "yyyy-MM-dd HH:mm")
                        let endDate = Date(dateString: self.endTime, format: "yyyy-MM-dd HH:mm")
                        if endDate.isSameDay(date: startDate){
                            
                        }else{
                             SVProgressHUD.showInfo(withStatus: "加班开始时间与结束时间必须在当天,请重新选择")
                            self.endTime = ""
                            let endBtn = self.endTimeLayout.viewWithTag(200) as! UIButton
                            endBtn.setTitle("", for: .normal)
                            return
                        }

                    }
                    
                    self.calculateDurationRequest(type: "extra", start: self.startTime, end:self.endTime , i: 0)
                }
                self.getApprovalPersonsRequest()
                
            }
        }else if self.curType == "business"{
            if !self.startTime.isEmpty && !self.endTime.isEmpty {
                self.isChangeApproveler = true
                self.calculateDurationRequest(type: "businessTravel", start: startTime, end: endTime,i:0)
                
            }
        }
    }
    
    //收到结束时间参数
    @objc func checkEndTime(notif: NSNotification) {
        guard let timeStr:String = notif.object as! String? else { return }
        self.endTime = timeStr
        DLog(self.endTime)
        if self.curType == "leave"{
            if !self.startTime.isEmpty && !self.endTime.isEmpty && (self.vacationTypeId > 0){
                self.getLeaveTimeRequest()
                self.isChangeApproveler = true
            }
        }
        else if self.curType == "overtime" || self.curType == "outWork"{
            if !self.startTime.isEmpty && !self.endTime.isEmpty {
                self.isChangeApproveler = true
                if self.curType == "outWork"{
                    self.calculateDurationRequest(type: "outWork", start: self.startTime, end:self.endTime , i: 0)
                }else{
                    //判断是否结束天是否是当天
                    if isOverTime == true {
                        let startDate = Date(dateString: self.startTime, format: "yyyy-MM-dd HH:mm")
                        let endDate = Date(dateString: self.endTime, format: "yyyy-MM-dd HH:mm")
                        if endDate.isSameDay(date: startDate){
                            
                        }else{
                            SVProgressHUD.showInfo(withStatus: "加班开始时间与结束时间必须在当天,请重新选择")
                            self.endTime = ""
                            let endBtn = self.endTimeLayout.viewWithTag(200) as! UIButton
                            endBtn.setTitle("", for: .normal)
                            return
                        }

                    }
                    
                     self.calculateDurationRequest(type: "extra", start: self.startTime, end:self.endTime , i: 0)
                }
                self.getApprovalPersonsRequest()
            }
        }else if self.curType == "business"{
            if !self.startTime.isEmpty && !self.endTime.isEmpty {
                self.isChangeApproveler = true
                self.calculateDurationRequest(type: "businessTravel", start: startTime, end: endTime,i:0)
               // self.getApprovalPersonsRequest()
              
            }
        }
        
    }
    
    //收到请假类型参数
    @objc func checkVocationType(notif: NSNotification) {
        guard let type:Int = notif.object as! Int? else { return }
        self.vacationTypeId = type
        DLog(self.vacationTypeId)
        if self.curType == "leave"{
            if !self.startTime.isEmpty && !self.endTime.isEmpty && (self.vacationTypeId > 0){
                self.getLeaveTimeRequest()
                self.isChangeApproveler = true
            }
        }
    }
    
    //收到交通工具类型参数
    @objc func checkTraficType(notif: NSNotification) {
        guard let type:String = notif.object as! String? else { return }
        self.traficTypeId = type
        DLog(self.traficTypeId)
    }
    
    //收到是否往返类型参数
    @objc func checkBackType(notif: NSNotification) {
        guard let type:Bool = notif.object as! Bool? else { return }
        self.isBanck = type
        DLog(self.isBanck)
    }

    //出发城市参数
    @objc func fromCityType(notif: NSNotification) {
        guard let type:String = notif.object as! String? else { return }
        self.fromCity = type
        DLog(self.fromCity)
    }
    
    //到达城市参数
    @objc func toCityType(notif: NSNotification) {
        guard let type:String = notif.object as! String? else { return }
        self.toCity = type
        DLog(self.toCity)
    }
    
    //出差时长
    @objc func travelDaySum(notif: NSNotification) {
        var day = 0.00
        day += self.travalDay
        for v in self.rootLayout.subviews{
            if v is CQAddTravelLayout{
                for subV in v.subviews{
                    if subV.tag == 10086{
                        for hardV in subV.subviews{
                            if hardV is CQTravelListLayout{
                                day += (hardV as! CQTravelListLayout).travalDay
                            }
                        }
                    }
                }
            }
        }
        self.totalDay = day
        let btn = self.bussinessDayLayout.viewWithTag(200) as! UIButton
        btn.setTitle(String.init(format: "%.1f", day) + "天", for: .normal)
     
        ///刷新人
        var aId = ""
        if isFromApplyDetail {
            aId = self.detailBid
        }else{
            aId = self.approvalBusinessId
        }
        let userId = STUserTool.account().userID
         var formData = ""
//        let dic = ["businessApplyDatas":[["startTime":self.startTime,
//                                          "isBack": self.isBanck,
//                                          "transport":"subway",
//                                          "fromCity":self.fromCity,
//                                          "travelReason":"",
//                                          "toCity":self.toCity,
//                                          "duration":self.duration,
//                                          "travelDays":String.init(format: "%.1f", day),
//                                          "endTime":self.endTime,
//                                          "travelPerson":["entityId":userId]]]]
        let dic = ["businessApplyDatas":[["travelDays":String.init(format: "%.1f", day),
                                          "travelPerson":["entityId":userId]]]]
        formData = getJSONStringFromDictionary(dictionary: dic as NSDictionary)
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getApplyApprovalPersons" ,
            type: .post,
            param: ["approvalBusinessId":aId,
                    "businessCode":self.businessCode,
                    "emyeId":userId,
                    "formData":formData],
            successCallBack: { (result) in
                
                self.copyArray.removeAll()
                self.userIdArr.removeAll()
                //审核人列表
                var approvalArr = [CQCopyForModel]()
                for modalJson in result["data"]["approvalFlowPersonUnitJsonList"].arrayValue  {
                    guard let modal = CQCopyForModel(jsonData: JSON(modalJson)) else {
                        return
                    }
                    approvalArr.append(modal)
                }
                
                //抄送人列表
                var copyToArr = [CQDepartMentUserListModel]()
                for modalJson in result["data"]["copyFlowPersonUnitJsonList"].arrayValue  {
                    guard let modal = CQDepartMentUserListModel(jsonData: JSON(modalJson)) else {
                        return
                    }
                    copyToArr.append(modal)
                }
                
                for model in copyToArr{
                    self.copyArray.append(CQDepartMentUserListModel.init(uId: model.approverId, realN: model.realName, headImag: model.headImage))
                }
                
                for model in self.copyArray {
                    self.userIdArr.append(model.userId)
                }
                
                
                let collection =  self.approvelCollectionLayout.viewWithTag(801) as! UICollectionView
                self.approvelCollectionLayout.dataArray = approvalArr
                collection.reloadData()
                let copyCollection = self.copyCollectionLayout.viewWithTag(801) as! UICollectionView
                self.copyCollectionLayout.dataArray = self.copyArray
                copyCollection.reloadData()
                self.headView.frame =  CGRect.init(x: 0, y: 0, width: kWidth, height: self.viewHeight)
                self.table.tableHeaderView = self.headView
                self.table.reloadData()
        }) { (error) in
            
            self.table.tableHeaderView = self.headView
            self.table.reloadData()
        }
    }
    
    //收到补卡时间参数
    @objc func checkModifyTime(notif: NSNotification) {
        guard let type:String = notif.object as! String? else { return }
        self.modifyTime = type
        DLog(self.modifyTime)
        
    }
    
    //接收到同行人 personChangeHeight
    @objc func personChangeHeight(notif: NSNotification) {
        guard let type:CGFloat = notif.object as! CGFloat? else { return }
        self.viewHeight += type
        DLog(self.viewHeight)
        self.headView.frame =  CGRect.init(x: 0, y: 0, width: kWidth, height: self.viewHeight)
        self.table.tableHeaderView = self.headView
        self.table.reloadData()
    }
    
    //隐藏键盘
    @objc func hiddenTheKeyBoard(notif: NSNotification) {
        self.view.endEditing(true)
    }
    
    //高度增加
    @objc func addHeight(notif: NSNotification) {
        self.viewHeight += AutoGetHeight(height: 405)
        self.headView.frame =  CGRect.init(x: 0, y: 0, width: kWidth, height: self.viewHeight)
        self.table.tableHeaderView = self.headView
        self.table.reloadData()
    }
    
    //高度减少
    @objc func shortHeight(notif: NSNotification) {
        self.viewHeight -= AutoGetHeight(height: 405)
        self.headView.frame =  CGRect.init(x: 0, y: 0, width: kWidth, height: self.viewHeight)
        self.table.tableHeaderView = self.headView
        self.table.reloadData()
        
    }
    
    //checkBox数据接收
    @objc func checkBoxValue(notif: NSNotification) {
        
    }
    
    //文件删除
    @objc func deleteFileAction(notif: NSNotification) {
        guard let arr:[NCQApprovelDetailModel] = notif.object as! [NCQApprovelDetailModel]? else { return }
        self.uploadModelArray.removeAll()
        self.uploadModelArray = arr
        let lastHeight = self.uploadLayout.tableHeight
        let curHeight = self.uploadLayout.reloadDataWithArray()
        self.viewHeight = self.viewHeight + (curHeight - lastHeight)
    }
    
    //接收到后执行的方法
    @objc func upDataChange(notif: NSNotification) {
        
        guard let arr: [CQDepartMentUserListModel] = notif.object as! [CQDepartMentUserListModel]? else { return }
        self.userIdArr.removeAll()
        self.copyArray.removeAll()
        for i in 0..<arr.count {
            self.userIdArr.append(arr[i].userId)
            self.copyArray.append(arr[i])
        }
        
        self.copyCollectionLayout.dataArray = self.copyArray
        self.copyCollectionLayout.reloadCollectionData()
        self.viewHeight = self.viewHeight + (self.copyCollectionLayout.collectionHeight - self.lastCopyCollectionHeight)
        self.lastCopyCollectionHeight = self.copyCollectionLayout.collectionHeight
        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: self.viewHeight)
        self.table.reloadData()
    }
    
    
    
    //更换同行人数组数据
    @objc func changeCopyArrayData(notif: NSNotification) {
        
        guard let arr: [CQDepartMentUserListModel] = notif.object as! [CQDepartMentUserListModel]? else { return }
        self.copyArray = arr
        self.userIdArr.removeAll()
        for model in self.copyArray {
            self.userIdArr.append(model.userId)
        }
        self.copyCollectionLayout.reloadCollectionData()
        self.viewHeight = self.viewHeight + (self.copyCollectionLayout.collectionHeight - self.lastCopyCollectionHeight)
        self.lastCopyCollectionHeight = self.copyCollectionLayout.collectionHeight
        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: self.viewHeight)
        self.table.reloadData()
    }
    
    //懒加载控件
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - AutoGetHeight(height: 0)), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight))
        headView.backgroundColor = UIColor.white
        return headView
    }()
    
   
}

extension NCQApprovelVC{
    fileprivate func setUpRefresh() {
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/businessForApply" ,
            type: .get,
            param: ["businessCode":self.businessCode,
                    "emyeId":userID,
                    "approvalBusinessId":self.approvalBusinessId],
            successCallBack: { (result) in
                guard let model = NCQApprovelModel.init(jsonData: result["data"]) else {
                    return
                }
                
                let str = model.formContent
                
                
                
                if !str.isEmpty {
                    let formData:Data = str.data(using: String.Encoding.utf8)!
                    guard let array = JSON(formData).arrayObject as? [[String: AnyObject]] else {
                        return
                    }

                    for i in 0..<array.count{
                        let arr = array[i]
                        let dic = arr["widget"]
                        let jsonStr = JSON.init(dic!)
                        
                        guard let contentModel = NCQApprovelModel.init(jsonData: jsonStr) else {
                            return
                        }
                        
                        
                        
                        var subWidgetArray = [NCQApprovelModel]()
                        for modalJson in contentModel.subWidget {
                            guard let modal = NCQApprovelModel(jsonData: modalJson) else {
                                return
                            }
                            subWidgetArray.append(modal)
                        }
                        if 0 == i{
                            self.curType = contentModel.type
                            if contentModel.type == "overtime"{
                                self.isOverTime = true
                            }else{
                                self.isOverTime = false
                            }
                        }
                        
                        
                        if self.curType == "leave"{
                            self.getVocationTypeRequest()
                        }
                        
                        for subModel in subWidgetArray{
                            if subModel.type == "select" {
//                                let layout = CQSelectLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, dataSource: subModel.dataSource)
                                if subModel.name == "vacationType"{
                                
                                    self.leaveLayout = CQLeaveTypeLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, typeArray:self.leaveDataArray,typeIdArray:self.leaveIdArray,vacationTypeId:-1)
                                    self.rootLayout.addSubview(self.leaveLayout)
                                    
                                    self.myLeaveLayout = CQMyVocationBalanceLayout.init(orientation: .horz, name: "", type: "", title: "", prompt: "", require: false)
                                    self.myLeaveLayout.leaveDeleagte = self
                                    self.rootLayout.addSubview(self.myLeaveLayout)
                                    
                                    self.viewHeight += AutoGetHeight(height: 115)
                                    DLog(self.viewHeight)
                                }
                                
                                
                            }else if subModel.type == "date"{
                                if subModel.name == "startTime"{
                                    let layout = CQStartSelectLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required,startTime:"")
                                    self.viewHeight += AutoGetHeight(height: 55)
                                    self.rootLayout.addSubview(layout)
                                    self.rootLayout.addSubview(self.addLineVLayout())
                                    if self.curType == "leave" || self.curType == "overtime"{
                                       self.startTimeLayout = layout
                                    }
                                    
                                    DLog(self.viewHeight)
                                }else if subModel.name == "endTime" {
                                    let layout = CQEndSelectLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required,endTime:"")
                                    self.rootLayout.addSubview(layout)
                                    self.viewHeight += AutoGetHeight(height: 55)
                                    self.rootLayout.addSubview(self.addLineVLayout())
                                    if self.curType == "leave" || self.curType == "overtime"{
                                         self.endTimeLayout = layout
                                    }
                                   
                                    DLog(self.viewHeight)
                                }else if subModel.name == "modifyTime"{
                                    self.modifyTimeLayout = CQModeifyTimeLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, dataFormat:subModel.dataFormat,curSelectTitle:self.modifyTime)
                                    self.rootLayout.addSubview(self.modifyTimeLayout)
                                    self.viewHeight += AutoGetHeight(height: 55)
                                    self.rootLayout.addSubview(self.addLineVLayout())
                                }
                            }else if subModel.type == "duration" {
                                self.durationLayout = CQDurationLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, unit:subModel.unit,duration:"0")
                                self.viewHeight += AutoGetHeight(height: 55)
                                self.rootLayout.addSubview(self.durationLayout)
                                self.rootLayout.addSubview(self.addLineVLayout())
                                DLog(self.viewHeight)
                            }else if subModel.type == "text" {
                                let layout = CQTextInputLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required,preText:"")
                                self.viewHeight += AutoGetHeight(height: 109+55)
                                self.rootLayout.addSubview(layout)
                                DLog(self.viewHeight)
                            }else if subModel.type == "person" {
                                if subModel.name == "extraPerson"{
                                    let layout = CQChoosePersonLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, isReplace: false,dataArray:[CQDepartMentUserListModel.init(uId: STUserTool.account().userID, realN: STUserTool.account().realName, headImag: STUserTool.account().headImage)])
                                    let nowHeight = AutoGetHeight(height: 55) + layout.collectionHeight
                                    self.viewHeight += nowHeight
                                    self.rootLayout.addSubview(layout)
                                    DLog(self.viewHeight)
                                }else if subModel.name == "togetherPerson"{
                                    let arr = [CQDepartMentUserListModel]()
                                    let layout = CQChoosePersonLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, isReplace: true,dataArray:arr)
                                    layout.chooseDelegate = self
                                    let nowHeight = AutoGetHeight(height: 55) + layout.collectionHeight
                                    self.viewHeight += nowHeight
                                    self.rootLayout.addSubview(layout)
                                    DLog(self.viewHeight)
                                }
                            }else if subModel.type == "checkbox" {
                                if subModel.name == "transport"{
                                    for modalJson in subModel.dataSource {
                                        guard let modal = NCQApprovelModel(jsonData: modalJson) else {
                                            return
                                        }
                                        self.traficArray.append(modal)
                                    }
                                    let layout = CQTraficLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, dataSource: self.traficArray,traficId:"")
                                    self.rootLayout.addSubview(layout)
                                    self.viewHeight += AutoGetHeight(height: 55)
                                    DLog(self.viewHeight)
                                }else if subModel.name == "isBack"{
                                    for modalJson in subModel.dataSource {
                                        guard let modal = CQBackModel(jsonData: modalJson) else {
                                            return
                                        }
                                        self.backArray.append(modal)
                                    }
                                    let layout = CQIsBackLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, dataSource: self.backArray)
                                    self.rootLayout.addSubview(layout)
                                    self.viewHeight += AutoGetHeight(height: 55)
                                    DLog(self.viewHeight)
                                }
                            }else if subModel.type == "sub" {
                                if subModel.name == "sub"{
                                    let layout = CQSubLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title)
                                    self.rootLayout.addSubview(layout)
                                    self.viewHeight += AutoGetHeight(height: 20)
                                    DLog(self.viewHeight)
                                }
                            }else if subModel.type == "area" {
                                if subModel.name == "fromCity"{
                                    let layout = CQFromCityLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required,dataFormat:subModel.dataFormat)
                                    self.rootLayout.addSubview(layout)
                                    self.viewHeight += AutoGetHeight(height: 55)
                                    DLog(self.viewHeight)
                                }else if subModel.name == "toCity"{
                                    let layout = CQToCityLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required,dataFormat:subModel.dataFormat)
                                    self.rootLayout.addSubview(layout)
                                    self.viewHeight += AutoGetHeight(height: 55)
                                    DLog(self.viewHeight)
                                }
                            }else if subModel.type == "formular" {
                                if subModel.name == "travelDays"{
                                    self.rootLayout.addSubview(self.addGrayViewContentLayout(height: AutoGetHeight(height: 13)))
                                    self.viewHeight += AutoGetHeight(height: 13)
                                    
                                    self.bussinessDayLayout = CQBussinessDayLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, formula: subModel.formula,duration:"0.0天")
                                    self.rootLayout.addSubview(self.bussinessDayLayout)
                                    self.viewHeight += AutoGetHeight(height: 55)
                                    DLog(self.viewHeight)
                                }
                            }else if subModel.type == "addDetail" {
                                if subModel.name == "addDetail"{
                                    let layout = CQAddTravelLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title,traficArray:self.traficArray,backArray:self.backArray)
                                    self.rootLayout.addSubview(layout)
                                    self.viewHeight += AutoGetHeight(height: 55)
                                    DLog(self.viewHeight)
                                }
                            }
                            
                          //  self.rootLayout.addSubview(self.addLineVLayout())
                        }
                        //数组
                        if contentModel.type == "text" {
                            let layout = CQTextInputLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required,preText:"")
                            self.viewHeight += AutoGetHeight(height: 109+55)
                            self.rootLayout.addSubview(layout)
                            DLog(self.viewHeight)
                        }else if contentModel.type == "phnoeNum"{
                            let layout = CQTelNumLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, phoneType: contentModel.phoneType, validate: contentModel.validate, telNum: "")
                            self.viewHeight += AutoGetHeight(height: 55)
                            self.rootLayout.addSubview(layout)
                        }else if contentModel.type == "numText"{
                            let layout = CQCountInputLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, unit: contentModel.unit, isCalculate: contentModel.isCalculate, textCount: "")
                            self.viewHeight += AutoGetHeight(height: 55)
                            self.rootLayout.addSubview(layout)
                        }else if contentModel.type == "money"{
                            let layout = CQCountInputLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, unit: contentModel.unit, isCalculate: contentModel.isCalculate, textCount: "")
                            self.viewHeight += AutoGetHeight(height: 55)
                            self.rootLayout.addSubview(layout)
                        }else if contentModel.type == "upperMoney"{
                            let layout = CQTelNumLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, phoneType: contentModel.phoneType, validate: contentModel.validate, telNum: "")
                            self.viewHeight += AutoGetHeight(height: 55)
                            self.rootLayout.addSubview(layout)
                        }else if contentModel.type == "checkbox" {
                            if contentModel.name == "transport"{
                                for modalJson in contentModel.dataSource {
                                    guard let modal = NCQApprovelModel(jsonData: modalJson) else {
                                        return
                                    }
                                    self.traficArray.append(modal)
                                }
                                let layout = CQTraficLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, dataSource: self.traficArray,traficId:"")
                                self.rootLayout.addSubview(layout)
                                self.viewHeight += AutoGetHeight(height: 55)
                                DLog(self.viewHeight)
                            }else if contentModel.name == "isBack"{
                                for modalJson in contentModel.dataSource {
                                    guard let modal = CQBackModel(jsonData: modalJson) else {
                                        return
                                    }
                                    self.backArray.append(modal)
                                }
                                let layout = CQIsBackLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, dataSource: self.backArray)
                                self.rootLayout.addSubview(layout)
                                self.viewHeight += AutoGetHeight(height: 55)
                                DLog(self.viewHeight)
                            }else{
                                for modalJson in contentModel.dataSource {
                                    guard let modal = NCQApprovelModel(jsonData: modalJson) else {
                                        return
                                    }
                                    self.checkBoxArray.append(modal)
                                    let layout = CQCheckBoxLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, dataSource: self.checkBoxArray,defualtv:"",single:contentModel.single)
                                    self.rootLayout.addSubview(layout)
                                    self.viewHeight += AutoGetHeight(height: 55)
                                    DLog(self.viewHeight)
                                }
                            }
                        }else if contentModel.type == "email"{
                            let layout = CQTelNumLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, phoneType: contentModel.phoneType, validate: contentModel.validate, telNum: "")
                            self.viewHeight += AutoGetHeight(height: 55)
                            self.rootLayout.addSubview(layout)
                        }else if contentModel.type == "date"{
                            if contentModel.name == "startTime"{
                                let layout = CQStartSelectLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required,startTime:"")
                                self.viewHeight += AutoGetHeight(height: 55)
                                self.rootLayout.addSubview(layout)
                                DLog(self.viewHeight)
                            }else if contentModel.name == "endTime"{
                                let layout = CQEndSelectLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required,endTime:"")
                                self.rootLayout.addSubview(layout)
                                self.viewHeight += AutoGetHeight(height: 55)
                                DLog(self.viewHeight)
                            }else if contentModel.name == "modifyTime"{
                                self.modifyTimeLayout = CQModeifyTimeLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, dataFormat:contentModel.dataFormat,curSelectTitle:self.modifyTime)
                                self.rootLayout.addSubview(self.modifyTimeLayout)
                                self.viewHeight += AutoGetHeight(height: 55)
                            }else {
                                let layout = CQDateChooseLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, dataFormat: contentModel.dataFormat, defualtv: "")
                                self.rootLayout.addSubview(layout)
                                self.viewHeight += AutoGetHeight(height: 55)
                            }
                        }else if contentModel.type == "certificate"{
                            let layout = CQTelNumLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, phoneType: contentModel.phoneType, validate: contentModel.validate, telNum: "")
                            self.viewHeight += AutoGetHeight(height: 55)
                            self.rootLayout.addSubview(layout)
                        }else if contentModel.type == "area" {
                            if contentModel.name == "fromCity"{
                                let layout = CQFromCityLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required,dataFormat:contentModel.dataFormat)
                                self.rootLayout.addSubview(layout)
                                self.viewHeight += AutoGetHeight(height: 55)
                                DLog(self.viewHeight)
                            }else if contentModel.name == "toCity"{
                                let layout = CQToCityLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required,dataFormat:contentModel.dataFormat)
                                self.rootLayout.addSubview(layout)
                                self.viewHeight += AutoGetHeight(height: 55)
                                DLog(self.viewHeight)
                            }else{
                                let layout = CQAreaChooseLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, dataFormat: contentModel.dataFormat,curSelectTitle:"")
                                self.rootLayout.addSubview(layout)
                                self.viewHeight += AutoGetHeight(height: 55)
                                DLog(self.viewHeight)
                            }
                        }else if contentModel.type == "person" {
                            if contentModel.name == "extraPerson"{
                                let layout = CQChoosePersonLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, isReplace: false,dataArray:[CQDepartMentUserListModel.init(uId: STUserTool.account().userID, realN: STUserTool.account().realName, headImag: STUserTool.account().headImage)])
                                let nowHeight = AutoGetHeight(height: 55) + layout.collectionHeight
                                self.viewHeight += nowHeight
                                self.rootLayout.addSubview(layout)
                                DLog(self.viewHeight)
                            }else if contentModel.name == "togetherPerson"{
                                let arr = [CQDepartMentUserListModel]()
                                let layout = CQChoosePersonLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, isReplace: true,dataArray:arr)
                                layout.chooseDelegate = self
                                let nowHeight = AutoGetHeight(height: 55) + layout.collectionHeight
                                self.viewHeight += nowHeight
                                self.rootLayout.addSubview(layout)
                                DLog(self.viewHeight)
                            }else{
                                let arr = [CQDepartMentUserListModel]()
                                let layout = CQPersonChooseLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, dataArray: arr, single: contentModel.single,isFix:false)
                                layout.personDelegate = self
                                let nowHeight = AutoGetHeight(height: 55) + layout.collectionHeight
                                self.viewHeight += nowHeight
                                self.rootLayout.addSubview(layout)
                                DLog(self.viewHeight)
                            }
                        }else if contentModel.type == "department"{
                            let arr = [CQAddressBookModel]()
                            self.departMentLayout = CQDepartmentLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, dataArray: arr, single: contentModel.single,isDetail:false)
                            self.departMentLayout.departDelagte = self
                            let nowHeight = AutoGetHeight(height: 55) + self.departMentLayout.collectionHeight
                            self.viewHeight += nowHeight
                            self.rootLayout.addSubview(self.departMentLayout)
                            DLog(self.viewHeight)
                        }else if contentModel.type == "formular"{
                            let layout = CQDurationLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, unit:contentModel.unit,duration:"")
                            self.viewHeight += AutoGetHeight(height: 55)
                            self.rootLayout.addSubview(layout)
                            DLog(self.viewHeight)
                        }else if contentModel.type == "remark" {
                            let layout = CQRemarkLayout.init(orientation: .horz, name:contentModel.name , type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt)
                            self.viewHeight += layout.vHeight
                            self.rootLayout.addSubview(layout)
                            DLog(self.viewHeight)
                        }else if contentModel.type == "sub"{
                            let layout = CQSubLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title)
                            self.rootLayout.addSubview(layout)
                            self.viewHeight += AutoGetHeight(height: 20)
                            DLog(self.viewHeight)
                        }
                        else if contentModel.type == "attach"{
                            let dataArray = [NCQApprovelDetailModel]()
                            self.uploadLayout = CQAttachUpLoadLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required,dataArray:dataArray,isFix:false)
                            self.uploadLayout.uploadDelegate = self
                            self.rootLayout.addSubview(self.uploadLayout)
                            self.viewHeight += AutoGetHeight(height: 170)
                            DLog(self.viewHeight)
                        }
                        
                    }
                }
                
                self.getApprovalPersonsRequest()
                self.table.reloadData()
                
                
                
        }) { (error) in
            self.table.reloadData()
            
        }
    }
    
    
    //获得审批人
    func getApprovalPersonsRequest() {
        let userId = STUserTool.account().userID
        var aId = ""
        if isFromApplyDetail {
            aId = self.detailBid
        }else{
            aId = self.approvalBusinessId
        }
        
        var formData = ""
        if self.isChangeApproveler{
            if self.curType == "leave"{
                let dic = ["businessApplyDatas":[["startTime":self.startTime,
                                                  "vacationType":self.vacationTypeId,
                                                  "duration":self.duration,
                                                  "endTime":self.endTime,
                                                  "leavePerson":["entityId":userId]]]]
                formData = getJSONStringFromDictionary(dictionary: dic as NSDictionary)
            }else if self.curType == "overtime" {
                let dic = ["businessApplyDatas":[["startTime":self.startTime,
                                                  "duration":self.duration,
                                                  "endTime":self.endTime,
                                                  "extraPerson":["entityId":userId]]]]
                formData = getJSONStringFromDictionary(dictionary: dic as NSDictionary)
            }else if self.curType == "outWork" {
                let dic = ["businessApplyDatas":[["startTime":self.startTime,
                                                  "duration":self.duration,
                                                  "endTime":self.endTime,
                                                  "outPerson":["entityId":userId]]]]
                formData = getJSONStringFromDictionary(dictionary: dic as NSDictionary)
            }else if self.curType == "business" {

//                NotificationCenter.default.post(name: NSNotification.Name.init("chuChaiAdd"), object: nil)
                return
            }

        
        }
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getApplyApprovalPersons" ,
            type: .post,
            param: ["approvalBusinessId":aId,
                    "businessCode":self.businessCode,
                    "emyeId":userId,
                    "formData":formData],
            successCallBack: { (result) in
                
              
                self.copyArray.removeAll()
                self.userIdArr.removeAll()
                //审核人列表
                var approvalArr = [CQCopyForModel]()
                for modalJson in result["data"]["approvalFlowPersonUnitJsonList"].arrayValue  {
                    guard let modal = CQCopyForModel(jsonData: JSON(modalJson)) else {
                        return
                    }
                    approvalArr.append(modal)
                }
                
                //抄送人列表
                var copyToArr = [CQDepartMentUserListModel]()
                for modalJson in result["data"]["copyFlowPersonUnitJsonList"].arrayValue  {
                    guard let modal = CQDepartMentUserListModel(jsonData: JSON(modalJson)) else {
                        return
                    }
                    copyToArr.append(modal)
                }
                
                for model in copyToArr{
                    self.copyArray.append(CQDepartMentUserListModel.init(uId: model.approverId, realN: model.realName, headImag: model.headImage))
                }

                for model in self.copyArray {
                    self.userIdArr.append(model.userId)
                }
                
                if !self.isChangeApproveler{
                    self.rootLayout.addSubview(self.addGrayViewContentLayout(height: AutoGetHeight(height: 13)))
                    self.viewHeight += AutoGetHeight(height: 13)
                    DLog(self.viewHeight)
                    self.approvelCollectionLayout = CQApproverLayout.init(orientation: .horz, name: "approver", type: "collection", title: "审批人", prompt: "", require: true, dataArray: approvalArr)
                    self.rootLayout.addSubview(self.approvelCollectionLayout)
                    self.viewHeight = self.approvelCollectionLayout.collectionHeight + AutoGetHeight(height: 55) + self.viewHeight
                    DLog(self.viewHeight)
                    self.rootLayout.addSubview(self.addGrayViewContentLayout(height: AutoGetHeight(height: 13)))
                    self.viewHeight += AutoGetHeight(height: 13)
                    DLog(self.viewHeight)
                    self.copyCollectionLayout = CQCopyToLayout.init(orientation: .horz, name: "cppy", type: "collection", title: "抄送人", prompt: "审批通过后,通知抄送人", require: false, dataArray: self.copyArray)
                    self.copyCollectionLayout.copyChooseDelegate = self
                    self.rootLayout.addSubview(self.copyCollectionLayout)
                    self.lastCopyCollectionHeight = self.copyCollectionLayout.collectionHeight
                    self.viewHeight = self.copyCollectionLayout.collectionHeight + AutoGetHeight(height: 55) + self.viewHeight
                    DLog(self.viewHeight)
                    if self.curType == "modify"{
                        self.rootLayout.addSubview(self.addGrayViewContentLayout(height: AutoGetHeight(height: 13)))
                        self.viewHeight += AutoGetHeight(height: 13)
                        let modifyLayout = CQModifyTimeActionLayout.init(orientation: .horz, name: "", type: "", title: "", prompt: "补卡申请", require: false)
                        modifyLayout.modifyDelegate = self
                        self.rootLayout.addSubview(modifyLayout)
                        self.viewHeight += AutoGetHeight(height: 55)
                        self.rootLayout.addSubview(self.addLineVLayout())
                    }
                }
                
                let collection =  self.approvelCollectionLayout.viewWithTag(801) as! UICollectionView
                self.approvelCollectionLayout.dataArray = approvalArr
                collection.reloadData()
                let copyCollection = self.copyCollectionLayout.viewWithTag(801) as! UICollectionView
                self.copyCollectionLayout.dataArray = self.copyArray
                copyCollection.reloadData()
                self.headView.frame =  CGRect.init(x: 0, y: 0, width: kWidth, height: self.viewHeight)
                self.table.tableHeaderView = self.headView
                self.table.reloadData()
        }) { (error) in
            
            self.table.tableHeaderView = self.headView
            self.table.reloadData()
        }
    }
    
    
    //获取请假类型
    func getVocationTypeRequest() {
        let userID = STUserTool.account().userID
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getAllVacationType" ,
            type: .get,
            param: ["emyeId":userID],
            successCallBack: { (result) in
                var leaveUnitArray = [String]()
                let arr = result["data"].arrayValue
                
                self.leaveIdArray.removeAll()
                self.leaveDataArray.removeAll()
                for dic in arr {
                    let leaveDic = dic.dictionaryValue
                    self.leaveDataArray.append((leaveDic["text"]?.stringValue)!)
                    self.leaveIdArray.append((leaveDic["value"]?.intValue)!)
                    leaveUnitArray.append((leaveDic["vacationUnit"]?.stringValue)!)
                }
                self.leaveLayout.modelArray = self.leaveDataArray
                self.leaveLayout.idArray = self.leaveIdArray
                
                if self.isFromApplyDetail{
                    var leaveStr = ""
                    var unit = ""
                    if self.vacationTypeId >= 0{
                        for i in 0..<self.leaveIdArray.count{
                            if self.leaveIdArray[i] == self.vacationTypeId{
                                leaveStr = self.leaveDataArray[i]
                                unit = leaveUnitArray[i]
                                if unit == "1"{
                                    let btn = self.durationLayout.viewWithTag(200) as! UIButton
                                    btn.setTitle(self.duration + "小时", for: .normal)
                                }else if unit == "2"{
                                    let btn = self.durationLayout.viewWithTag(200) as! UIButton
                                    btn.setTitle(self.duration + "半天天", for: .normal)
                                }else if unit == "3"{
                                    let btn = self.durationLayout.viewWithTag(200) as! UIButton
                                    btn.setTitle(self.duration + "天", for: .normal)
                                }
                            }
                        }
                    }
                    self.leaveLayout.curSelectTitle = leaveStr
                    let btn = self.leaveLayout.viewWithTag(200) as! UIButton
                    btn.setTitle(leaveStr, for: .normal)
                    
                }
                
                
                var tempArray = [CQMyLeaveListModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQMyLeaveListModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                
                var yearTime = "0"
                var tiaoxiu = "0"
                for mod in tempArray{
                    if mod.text == "年假"{
                        yearTime = mod.balanceNumber
                    }else if mod.text == "调休"{
                        tiaoxiu = mod.balanceNumber
                    }
                }
                self.myLeaveLayout.year = yearTime
                self.myLeaveLayout.xiu = tiaoxiu
                let lab = self.myLeaveLayout.viewWithTag(100) as! UILabel
                lab.text = "年假: 剩余" + yearTime + "天" + "   调休: 剩余" + tiaoxiu + "小时"
        }) { (error) in
            
        }
    }
    
    
    //获取请假申请总时长
    func getLeaveTimeRequest() {
        let userID = STUserTool.account().userID
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getLeaveDuration" ,
            type: .get,
            param: ["emyeId":userID,
                    "startTime":self.startTime,
                    "endTime":self.endTime,
                    "vacationTypeId":self.vacationTypeId],
            successCallBack: { (result) in
                self.duration = result["data"]["duration"].stringValue
                let vocationUnit = result["data"]["unit"].stringValue
                let timeInter = self.duration + vocationUnit
                
                let btn = self.durationLayout.viewWithTag(200) as! UIButton
                btn.setTitle(timeInter, for: .normal)
                
                self.getApprovalPersonsRequest()
        }) { (error) in
            //100114
            if error["code"] == 100114{
                print("错误")
                // self.startTime = ""
                // let startBtn = self.startTimeLayout.viewWithTag(200) as! UIButton
                //startBtn.setTitle("", for: .normal)
                self.endTime = ""
                let endBtn = self.endTimeLayout.viewWithTag(200) as! UIButton
                endBtn.setTitle("", for: .normal)
            }
            
//            let startDate = Date(dateString: self.startTime, format: "yyyy-MM-dd HH:mm")
//            let endDate = Date(dateString: self.endTime, format: "yyyy-MM-dd HH:mm")
//            if  endDate.isEarlier(than: startDate){
//                // self.startTime = ""
//                self.endTime = ""
//                // let startBtn = self.startTimeLayout.viewWithTag(200) as! UIButton
//                //startBtn.setTitle("", for: .normal)
//                let endBtn = self.endTimeLayout.viewWithTag(200) as! UIButton
//                endBtn.setTitle("", for: .normal)
//            }
//            endDate.isSameDay(date: startDate)
            
        }
    }
    
    //提交
    func applySubmitRequest(data:String) {
        let userId = STUserTool.account().userID
        var userIdStr = ""
        if self.userIdArr.count > 0 {
            for i in 0..<self.userIdArr.count{
                if 0 == i{
                    userIdStr = self.userIdArr[i]
                }else{
                    userIdStr = userIdStr + "," + self.userIdArr[i]
                }
            }
        }
        var aId = ""
        if self.isFromApplyDetail{
            aId = self.detailBid
        }else{
            aId = self.approvalBusinessId
        }
        var businessId = ""
        if self.isFromSubmitDetail{
            businessId = self.approvalBusinessId
        }else{
            businessId = ""
        }
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/applySubmit" ,
            type: .post,
            param: ["approvalBusinessId":aId,
                    "businessApplyId":businessId,
                    "businessCode":self.businessCode,
                    "copyPersonIds":userIdStr,
                    "emyeId":userId,
                    "formData":data],
            successCallBack: { (result) in
                self.loadingSuccess()
                SVProgressHUD.showSuccess(withStatus: "发布成功")
                
                if self.isFromSubmitDetail{
                    for v in (self.navigationController?.viewControllers)!{
                        if v is CQMeSubmitVC{
                            NotificationCenter.default.post(name: NSNotification.Name.init("refreshMeApplyUI"), object: nil)
                            self.navigationController?.popToViewController(v, animated: true)
                            NotificationCenter.default.removeObserver(self)
                        }
                    }
                }else{
                       NotificationCenter.default.removeObserver(self)
                    self.navigationController?.popViewController(animated: true)
                }
        }) { (error) in
            self.loadingSuccess()
        }
    }
    
    
    //获取出差外出时长
    func calculateDurationRequest(type:String,start:String,end:String,i:Int) {
        
        let userId = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/calculateDuration" ,
            type: .get,
            param: ["emyeId":userId,
                    "endTime":end,
                    "startTime":start,
                    "type":type],
            successCallBack: { (result) in
                if type == "outWork" || type == "extra"{
                    self.duration = result["data"]["duration"].stringValue
                    let vocationUnit = result["data"]["unit"].stringValue
                    let timeInter = self.duration + vocationUnit
                    
                    let btn = self.durationLayout.viewWithTag(200) as! UIButton
                    btn.setTitle(timeInter, for: .normal)
                }else if type == "businessTravel"{
                    self.travalDay = result["data"]["duration"].doubleValue
                    
                    self.duration = result["data"]["duration"].stringValue
                    let vocationUnit = result["data"]["unit"].stringValue
                    let timeInter = self.duration + vocationUnit
                    
                    if 0 == i {
                        let btn = self.durationLayout.viewWithTag(200) as! UIButton
                        btn.setTitle(timeInter, for: .normal)
                    }
                    
                    var day = 0.00
                    day += self.travalDay
                    for v in self.rootLayout.subviews{
                        if v is CQAddTravelLayout{
                            for subV in v.subviews{
                                if subV.tag == 10086{
                                    for hardV in subV.subviews{
                                        if hardV is CQTravelListLayout{
                                            day += (hardV as! CQTravelListLayout).travalDay
                                        }
                                    }
                                }
                            }
                        }
                    }
                    self.totalDay = day
//                    let btn = self.bussinessDayLayout.viewWithTag(200) as! UIButton
//                    btn.setTitle(String.init(format: "%.1f", day) + "天", for: .normal)
                    //self.getApprovalPersonsRequest()
                    NotificationCenter.default.post(name: NSNotification.Name.init("travelDayValue"), object: nil)
                }
                
                
        }) { (error) in
            
        }
    }
    
    
}

//从我的提交详情进入
extension NCQApprovelVC{
    // MARK:request
    fileprivate func loadSubmitDetailData() {
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/approval/getMyApplyDetail",
            type: .get,
            param: ["emyeId":userID,
                    "businessApplyId":self.approvalBusinessId],
            successCallBack: { (result) in
                
                guard let model = NCQApprovelModel.init(jsonData: result["data"]) else {
                    return
                }
                
                let str = model.formContent

                //解析表单数据
                let formDataStr = model.formData
                let dataDic = getDictionaryFromJSONString(jsonString: formDataStr)
                let dataArray = dataDic["businessApplyDatas"] as! NSArray
                let dataJson = JSON.init(dataArray[0])
                guard let dataModel = NCQApprovelDetailModel.init(jsonData: dataJson) else {
                    return
                }
                
                //解析出差表单数据
                var bussinessDetailArray = [NCQApprovelDetailModel]()
                for modelJson in dataModel.businessDetail{
                    guard let businessModel = NCQApprovelDetailModel.init(jsonData: modelJson) else {
                        return
                    }
                    bussinessDetailArray.append(businessModel)
                }
                var oneBusinessModel:NCQApprovelDetailModel!
                if bussinessDetailArray.count > 0{
                    oneBusinessModel = bussinessDetailArray[0]
                }
                
                if !str.isEmpty {
                    let formData:Data = str.data(using: String.Encoding.utf8)!
                    guard let array = JSON(formData).arrayObject as? [[String: AnyObject]] else {
                        return
                    }
                    
                    for i in 0..<array.count{
                        let arr = array[i]
                        let dic = arr["widget"]
                        let jsonStr = JSON.init(dic!)
                        
                        guard let contentModel = NCQApprovelModel.init(jsonData: jsonStr) else {
                            return
                        }
                        
                        
                        var subWidgetArray = [NCQApprovelModel]()
                        for modalJson in contentModel.subWidget {
                            guard let modal = NCQApprovelModel(jsonData: modalJson) else {
                                return
                            }
                            subWidgetArray.append(modal)
                        }
                        if 0 == i{
                            self.curType = contentModel.type
                            if contentModel.type == "overtime"{
                                self.isOverTime = true
                            }else{
                                self.isOverTime = false
                            }
                        }
                        
                        
                        if self.curType == "leave"{
                            self.getVocationTypeRequest()
                        }
                        
                        self.title = model.businessName
                        
                        for subModel in subWidgetArray{
                            if subModel.type == "select" {
                                if subModel.name == "vacationType"{
                                    
                                    self.leaveLayout = CQLeaveTypeLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, typeArray:self.leaveDataArray,typeIdArray:self.leaveIdArray,vacationTypeId:Int(dataModel.vacationType)!)
                                    self.vacationTypeId = Int(dataModel.vacationType)!
                                    self.rootLayout.addSubview(self.leaveLayout)
                                    
                                    self.myLeaveLayout = CQMyVocationBalanceLayout.init(orientation: .horz, name: "", type: "", title: "", prompt: "", require: false)
                                    self.myLeaveLayout.leaveDeleagte = self
                                    self.rootLayout.addSubview(self.myLeaveLayout)
                                    
                                    self.viewHeight += AutoGetHeight(height: 115)
                                    DLog(self.viewHeight)
                                }
                                
                                
                            }else if subModel.type == "date"{
                                if subModel.name == "startTime"{
                                    if self.curType == "business"{
                                        let layout = CQStartSelectLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt:subModel.prompt , require: subModel.required,startTime:oneBusinessModel.startTime)
                                        self.startTime = oneBusinessModel.startTime
                                        self.viewHeight += AutoGetHeight(height: 55)
                                        self.rootLayout.addSubview(layout)
                                    }else{
                                        let layout = CQStartSelectLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt:subModel.prompt , require: subModel.required,startTime:dataModel.startTime)
                                        self.startTime = dataModel.startTime
                                        self.viewHeight += AutoGetHeight(height: 55)
                                        self.rootLayout.addSubview(layout)
                                
                                        if self.curType == "leave" || self.curType == "overtime"{
                                            self.startTimeLayout = layout
                                        }
                                    }
                                    DLog(self.viewHeight)
                                }else if subModel.name == "endTime"{
                                    if self.curType == "business"{
                                        let layout = CQEndSelectLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required,endTime:oneBusinessModel.endTime)
                                        self.endTime = oneBusinessModel.endTime
                                        self.rootLayout.addSubview(layout)
                                        self.viewHeight += AutoGetHeight(height: 55)
                                        
                                    }else{
                                        let layout = CQEndSelectLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required,endTime:dataModel.endTime)
                                        self.endTime = dataModel.endTime
                                        self.rootLayout.addSubview(layout)
                                        self.viewHeight += AutoGetHeight(height: 55)
                                        if self.curType == "leave" || self.curType == "overtime"{
                                            self.endTimeLayout = layout
                                        }
                                    }
                                    DLog(self.viewHeight)
                                }else if subModel.name == "modifyTime"{
                                    self.modifyTimeLayout = CQModeifyTimeLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, dataFormat:subModel.dataFormat,curSelectTitle:dataModel.modifyTime)
                                    self.modifyTime = dataModel.modifyTime
                                    self.rootLayout.addSubview(self.modifyTimeLayout)
                                    self.viewHeight += AutoGetHeight(height: 55)
                                }
                            }else if subModel.type == "duration" {
                                if self.curType == "business"{
                                    self.durationLayout = CQDurationLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, unit: subModel.unit,duration:oneBusinessModel.duration)
                                    self.duration = oneBusinessModel.duration
                                    self.travalDay = Double(oneBusinessModel.duration)!
                                    self.viewHeight += AutoGetHeight(height: 55)
                                    self.rootLayout.addSubview(self.durationLayout)
                                }else{
                                    self.durationLayout = CQDurationLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, unit: subModel.unit,duration:dataModel.duration)
                                    self.duration = dataModel.duration
                                    self.viewHeight += AutoGetHeight(height: 55)
                                    self.rootLayout.addSubview(self.durationLayout)
                                }
                                
                                DLog(self.viewHeight)
                            }else if subModel.type == "text" {
                                if subModel.name == "leaveReason"{
                                    let layout = CQTextInputLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required,preText:dataModel.leaveReason)
                                    self.viewHeight += AutoGetHeight(height: 109+55)
                                    self.rootLayout.addSubview(layout)
                                }else if subModel.name == "modifyReason"{
                                    let layout = CQTextInputLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required,preText:dataModel.modifyReason)
                                    self.viewHeight += AutoGetHeight(height: 109+55)
                                    self.rootLayout.addSubview(layout)
                                }else if subModel.name == "travelReason"{
                                    let layout = CQTextInputLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required,preText:dataModel.travelReason)
                                    self.viewHeight += AutoGetHeight(height: 109+55)
                                    self.rootLayout.addSubview(layout)
                                }else if subModel.name == "remark"{
                                    let layout = CQTextInputLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required,preText:dataModel.remark)
                                    self.viewHeight += AutoGetHeight(height: 109+55)
                                    self.rootLayout.addSubview(layout)
                                }
                                
                                DLog(self.viewHeight)
                            }else if subModel.type == "person" {
                                if subModel.name == "extraPerson"{
                                    let layout = CQChoosePersonLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: dataModel.name, require: subModel.required, isReplace: false,dataArray:[CQDepartMentUserListModel.init(uId: STUserTool.account().userID, realN: STUserTool.account().realName, headImag: STUserTool.account().headImage)])
                                    let nowHeight = AutoGetHeight(height: 55) + layout.collectionHeight
                                    self.viewHeight += nowHeight
                                    self.rootLayout.addSubview(layout)
                                    DLog(self.viewHeight)
                                }else if subModel.name == "togetherPerson"{
                                    let personArr = dataModel.togetherPerson
                                    var personModelArray = [NCQApprovelDetailModel]()
                                    for modelJson in personArr{
                                        guard let modal = NCQApprovelDetailModel(jsonData: modelJson) else {
                                            return
                                        }
                                        personModelArray.append(modal)
                                    }
                                    var toghterArr = [CQDepartMentUserListModel]()
                                    for model in personModelArray{
                                        let tModel = CQDepartMentUserListModel.init(uId: model.entityId, realN: model.name, headImag: model.url)
                                        toghterArr.append(tModel)
                                    }
                                    let layout = CQChoosePersonLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, isReplace: true,dataArray:toghterArr)
                                    layout.chooseDelegate = self
                                    let nowHeight = AutoGetHeight(height: 55) + layout.collectionHeight
                                    self.viewHeight += nowHeight
                                    self.rootLayout.addSubview(layout)
                                    DLog(self.viewHeight)
                                }
                            }else if subModel.type == "checkbox" {
                                if subModel.name == "transport"{
                                    for modalJson in subModel.dataSource {
                                        guard let modal = NCQApprovelModel(jsonData: modalJson) else {
                                            return
                                        }
                                        self.traficArray.append(modal)
                                    }
                                    if self.curType == "business"{
                                        let layout = CQTraficLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, dataSource: self.traficArray,traficId:oneBusinessModel.transport)
                                        self.traficTypeId = oneBusinessModel.transport
                                        self.rootLayout.addSubview(layout)
                                        self.viewHeight += AutoGetHeight(height: 55)
                                    }else{
                                        let layout = CQTraficLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, dataSource: self.traficArray,traficId:dataModel.transport)
                                        self.traficTypeId = dataModel.transport
                                        self.rootLayout.addSubview(layout)
                                        self.viewHeight += AutoGetHeight(height: 55)
                                    }
                                    
                                    DLog(self.viewHeight)
                                }else if subModel.name == "isBack"{
                                    for modalJson in subModel.dataSource {
                                        guard let modal = CQBackModel(jsonData: modalJson) else {
                                            return
                                        }
                                        self.backArray.append(modal)
                                    }
                                    
                                    if self.curType == "business"{
                                        var str = ""
                                        if oneBusinessModel.isBack{
                                            str = "往返"
                                        }else {
                                            str = "单程"
                                        }
                                        let layout = CQIsBackLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: str, require: subModel.required, dataSource: self.backArray)
                                        self.isBanck = oneBusinessModel.isBack
                                        self.rootLayout.addSubview(layout)
                                        self.viewHeight += AutoGetHeight(height: 55)
                                    }else{
                                        var str = ""
                                        if dataModel.isBack{
                                            str = "往返"
                                        }else {
                                            str = "单程"
                                        }
                                        let layout = CQIsBackLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: str, require: subModel.required, dataSource: self.backArray)
                                        self.isBanck = dataModel.isBack
                                        self.rootLayout.addSubview(layout)
                                        self.viewHeight += AutoGetHeight(height: 55)
                                    }
                                    
                                    
                                    DLog(self.viewHeight)
                                }
                            }else if subModel.type == "sub" {
                                if subModel.name == "sub"{
                                    let layout = CQSubLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title)
                                    self.rootLayout.addSubview(layout)
                                    self.viewHeight += AutoGetHeight(height: 20)
                                    DLog(self.viewHeight)
                                }
                            }else if subModel.type == "area" {
                                if subModel.name == "fromCity"{
                                    if self.curType == "business"{
                                        let layout = CQFromCityLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: oneBusinessModel.fromCity, require: subModel.required,dataFormat:subModel.dataFormat)
                                        self.fromCity = oneBusinessModel.fromCity
                                        self.rootLayout.addSubview(layout)
                                        self.viewHeight += AutoGetHeight(height: 55)
                                    }else{
                                        let layout = CQFromCityLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: dataModel.fromCity, require: subModel.required,dataFormat:subModel.dataFormat)
                                        self.fromCity = dataModel.fromCity
                                        self.rootLayout.addSubview(layout)
                                        self.viewHeight += AutoGetHeight(height: 55)
                                    }
                                    
                                    DLog(self.viewHeight)
                                }else if subModel.name == "toCity"{
                                    if self.curType == "business"{
                                        let layout = CQToCityLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: oneBusinessModel.toCity, require: subModel.required,dataFormat:subModel.dataFormat)
                                        self.toCity = oneBusinessModel.toCity
                                        self.rootLayout.addSubview(layout)
                                        self.viewHeight += AutoGetHeight(height: 55)
                                    }else{
                                        let layout = CQToCityLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: dataModel.toCity, require: subModel.required,dataFormat:subModel.dataFormat)
                                        self.toCity = dataModel.toCity
                                        self.rootLayout.addSubview(layout)
                                        self.viewHeight += AutoGetHeight(height: 55)
                                    }
                                    
                                    DLog(self.viewHeight)
                                }
                            }else if subModel.type == "formular" {
                                if subModel.name == "travelDays"{
                                    self.rootLayout.addSubview(self.addGrayViewContentLayout(height: AutoGetHeight(height: 13)))
                                    self.viewHeight += AutoGetHeight(height: 13)
                                    
                                    self.bussinessDayLayout = CQBussinessDayLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, formula: subModel.formula,duration:dataModel.travelDays + "天")
                                    self.totalDay = Double(dataModel.travelDays)!
                                    self.rootLayout.addSubview(self.bussinessDayLayout)
                                    self.viewHeight += AutoGetHeight(height: 55)
                                    DLog(self.viewHeight)
                                }
                            }else if subModel.type == "addDetail" {
                                if subModel.name == "addDetail"{
                                    let layout = CQAddTravelLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title,traficArray:self.traficArray,backArray:self.backArray)
                                    self.rootLayout.addSubview(layout)
                                    self.viewHeight += AutoGetHeight(height: 55)
                                    
                                    bussinessDetailArray.remove(at: 0)
                                    for model in bussinessDetailArray{
                                        for v in layout.actionLayout.subviews{
                                            if v.tag == 1000{
                                                v.removeFromSuperview()
                                            }
                                        }
                                        let travelLayout = CQTravelListLayout.init(orientation: .horz, name: "行程", type: "行程", title:"行程" + "\(self.index)"  , viewTag: layout.index + 100,traficArray:self.traficArray,backArray:self.backArray)
                                        layout.actionLayout.addSubview(travelLayout)
                                        layout.actionLayout.addSubview(layout.addAddLayout())
                                        layout.index += 1
                                        NotificationCenter.default.post(name: NSNotification.Name.init("addHeight"), object: nil)
                                        
                                        let traficBtn = travelLayout.viewWithTag(200) as! UIButton
                                        var message = ""
                                        if !model.transport.isEmpty{
                                            for traModel in self.traficArray{
                                                if traModel.value == model.transport{
                                                    message = traModel.text
                                                }
                                            }
                                        }
                                        traficBtn.setTitle(message, for: .normal)
                                        travelLayout.traficId = model.transport
                                        
                                        let isBackBtn = travelLayout.viewWithTag(201) as! UIButton
                                        if model.isBack{
                                            isBackBtn.setTitle("往返", for: .normal)
                                        }else{
                                            isBackBtn.setTitle("单程", for: .normal)
                                        }
                                        travelLayout.isBack = model.isBack
                                        
                                        let fromBtn = travelLayout.viewWithTag(202) as! UIButton
                                        fromBtn.setTitle(model.fromCity, for: .normal)
                                        travelLayout.fromCity = model.fromCity
                                        
                                        let toBtn = travelLayout.viewWithTag(203) as! UIButton
                                        toBtn.setTitle(model.toCity, for: .normal)
                                        travelLayout.toCity = model.toCity
                                        
                                        let startBtn = travelLayout.viewWithTag(204) as! UIButton
                                        startBtn.setTitle(model.startTime, for: .normal)
                                        travelLayout.startTime = model.startTime
                                        
                                        let endBtn = travelLayout.viewWithTag(205) as! UIButton
                                        endBtn.setTitle(model.endTime, for: .normal)
                                        travelLayout.endTime = model.endTime
                                        
                                        let durationBtn = travelLayout.viewWithTag(206) as! UIButton
                                        durationBtn.setTitle(model.duration + "天", for: .normal)
                                        travelLayout.duration = model.duration
                                    }
                                    
                                    
                                    
                                    DLog(self.viewHeight)
                                }
                            }
                            
                            self.rootLayout.addSubview(self.addLineVLayout())
                        }
                        if self.curType == "leave"{
                            let arr = dataJson[contentModel.name].arrayValue
                            var curArr = [NCQApprovelDetailModel]()
                            for modelJson in arr{
                                guard let modal = NCQApprovelDetailModel(jsonData: modelJson) else {
                                    return
                                }
                                curArr.append(modal)
                            }
                            self.uploadLayout = CQAttachUpLoadLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required,dataArray:curArr,isFix:true)
                            self.uploadLayout.uploadDelegate = self
                            self.rootLayout.addSubview(self.uploadLayout)
                            let height = self.uploadLayout.reloadDataWithArray()
                            self.viewHeight = self.viewHeight + AutoGetHeight(height: 170) + height
                            DLog(self.viewHeight)
                        }
                        //数组
                        if contentModel.type == "text" {
                            let layout = CQTextInputLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required,preText:dataJson[contentModel.name].stringValue)
                            self.viewHeight += AutoGetHeight(height: 109+55)
                            self.rootLayout.addSubview(layout)
                            DLog(self.viewHeight)
                        }else if contentModel.type == "phnoeNum"{
                            let layout = CQTelNumLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, phoneType: contentModel.phoneType, validate: contentModel.validate, telNum: dataJson[contentModel.name].stringValue)
                            self.viewHeight += AutoGetHeight(height: 55)
                            self.rootLayout.addSubview(layout)
                        }else if contentModel.type == "numText"{
                            let layout = CQCountInputLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, unit: contentModel.unit, isCalculate: contentModel.isCalculate, textCount: dataJson[contentModel.name].stringValue)
                            self.viewHeight += AutoGetHeight(height: 55)
                            self.rootLayout.addSubview(layout)
                        }else if contentModel.type == "money"{
                            let layout = CQCountInputLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, unit: contentModel.unit, isCalculate: contentModel.isCalculate, textCount: dataJson[contentModel.name].stringValue)
                            self.viewHeight += AutoGetHeight(height: 55)
                            self.rootLayout.addSubview(layout)
                        }else if contentModel.type == "upperMoney"{
                            let layout = CQTelNumLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, phoneType: contentModel.phoneType, validate: contentModel.validate, telNum: dataJson[contentModel.name].stringValue)
                            self.viewHeight += AutoGetHeight(height: 55)
                            self.rootLayout.addSubview(layout)
                        }else if contentModel.type == "checkbox" {
                            if contentModel.name == "transport"{
                                for modalJson in contentModel.dataSource {
                                    guard let modal = NCQApprovelModel(jsonData: modalJson) else {
                                        return
                                    }
                                    self.traficArray.append(modal)
                                }
                                let layout = CQTraficLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, dataSource: self.traficArray,traficId:"")
                                self.rootLayout.addSubview(layout)
                                self.viewHeight += AutoGetHeight(height: 55)
                                DLog(self.viewHeight)
                            }else if contentModel.name == "isBack"{
                                for modalJson in contentModel.dataSource {
                                    guard let modal = CQBackModel(jsonData: modalJson) else {
                                        return
                                    }
                                    self.backArray.append(modal)
                                }
                                let layout = CQIsBackLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, dataSource: self.backArray)
                                self.rootLayout.addSubview(layout)
                                self.viewHeight += AutoGetHeight(height: 55)
                                DLog(self.viewHeight)
                            }else{
                                for modalJson in contentModel.dataSource {
                                    guard let modal = NCQApprovelModel(jsonData: modalJson) else {
                                        return
                                    }
                                    self.checkBoxArray.append(modal)
                                }
                                var defaultStr = ""
                                for model in self.checkBoxArray{
                                    if model.value == dataJson[contentModel.name].stringValue{
                                        defaultStr = model.text
                                    }
                                }
                                let layout = CQCheckBoxLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, dataSource: self.checkBoxArray,defualtv:defaultStr,single:contentModel.single)
                                layout.postValue = dataJson[contentModel.name].stringValue
                                self.rootLayout.addSubview(layout)
                                self.viewHeight += AutoGetHeight(height: 55)
                                DLog(self.viewHeight)
                            }
                        }else if contentModel.type == "email"{
                            let layout = CQTelNumLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, phoneType: contentModel.phoneType, validate: contentModel.validate, telNum: dataJson[contentModel.name].stringValue)
                            self.viewHeight += AutoGetHeight(height: 55)
                            self.rootLayout.addSubview(layout)
                        }else if contentModel.type == "date"{
                            if contentModel.name == "startTime"{
                                let layout = CQStartSelectLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required,startTime:dataJson[contentModel.name].stringValue)
                                self.viewHeight += AutoGetHeight(height: 55)
                                self.rootLayout.addSubview(layout)
                                DLog(self.viewHeight)
                            }else if contentModel.name == "endTime"{
                                let layout = CQEndSelectLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required,endTime:dataJson[contentModel.name].stringValue)
                                self.rootLayout.addSubview(layout)
                                self.viewHeight += AutoGetHeight(height: 55)
                                DLog(self.viewHeight)
                            }else if contentModel.name == "modifyTime"{
                                self.modifyTimeLayout = CQModeifyTimeLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, dataFormat:contentModel.dataFormat,curSelectTitle:dataJson[contentModel.name].stringValue)
                                self.rootLayout.addSubview(self.modifyTimeLayout)
                                self.viewHeight += AutoGetHeight(height: 55)
                            }else {
                                let layout = CQDateChooseLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, dataFormat: contentModel.dataFormat, defualtv: dataJson[contentModel.name].stringValue)
                                self.rootLayout.addSubview(layout)
                                self.viewHeight += AutoGetHeight(height: 55)
                            }
                        }else if contentModel.type == "certificate"{
                            let layout = CQTelNumLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, phoneType: contentModel.phoneType, validate: contentModel.validate, telNum: dataJson[contentModel.name].stringValue)
                            self.viewHeight += AutoGetHeight(height: 55)
                            self.rootLayout.addSubview(layout)
                        }else if contentModel.type == "area" {
                            if contentModel.name == "fromCity"{
                                let layout = CQFromCityLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required,dataFormat:contentModel.dataFormat)
                                self.rootLayout.addSubview(layout)
                                self.viewHeight += AutoGetHeight(height: 55)
                                DLog(self.viewHeight)
                            }else if contentModel.name == "toCity"{
                                let layout = CQToCityLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required,dataFormat:contentModel.dataFormat)
                                self.rootLayout.addSubview(layout)
                                self.viewHeight += AutoGetHeight(height: 55)
                                DLog(self.viewHeight)
                            }else{
                                let layout = CQAreaChooseLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, dataFormat: contentModel.dataFormat,curSelectTitle:dataJson[contentModel.name].stringValue)
                                self.rootLayout.addSubview(layout)
                                self.viewHeight += AutoGetHeight(height: 55)
                                DLog(self.viewHeight)
                            }
                        }else if contentModel.type == "person" {
                            if contentModel.name == "extraPerson"{
                                let layout = CQChoosePersonLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, isReplace: false,dataArray:[CQDepartMentUserListModel.init(uId: STUserTool.account().userID, realN: STUserTool.account().realName, headImag: STUserTool.account().headImage)])
                                let nowHeight = AutoGetHeight(height: 55) + layout.collectionHeight
                                self.viewHeight += nowHeight
                                self.rootLayout.addSubview(layout)
                                DLog(self.viewHeight)
                            }else if contentModel.name == "togetherPerson"{
                                let arr = [CQDepartMentUserListModel]()
                                let layout = CQChoosePersonLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, isReplace: true,dataArray:arr)
                                layout.chooseDelegate = self
                                let nowHeight = AutoGetHeight(height: 55) + layout.collectionHeight
                                self.viewHeight += nowHeight
                                self.rootLayout.addSubview(layout)
                                DLog(self.viewHeight)
                            }else{
                                let arr = dataJson[contentModel.name].arrayValue
                                var curArr = [CQDepartMentUserListModel]()
                                for modelJson in arr{
                                    guard let modal = CQDepartMentUserListModel(jsonData: modelJson) else {
                                        return
                                    }
                                    curArr.append(modal)
                                }
                                let layout = CQPersonChooseLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, dataArray: curArr, single: contentModel.single,isFix:true)
                                layout.personDelegate = self
                                let nowHeight = AutoGetHeight(height: 55) + layout.collectionHeight
                                self.viewHeight += nowHeight
                                self.rootLayout.addSubview(layout)
                                DLog(self.viewHeight)
                            }
                        }else if contentModel.type == "department"{
                            let arr = dataJson[contentModel.name].arrayValue
                            var curArr = [CQAddressBookModel]()
                            for modelJson in arr{
                                guard let modal = CQAddressBookModel(jsonData: modelJson) else {
                                    return
                                }
                                curArr.append(modal)
                            }
                            self.departMentLayout = CQDepartmentLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, dataArray: curArr, single: contentModel.single,isDetail:false)
                            self.departMentLayout.departDelagte = self
                            let nowHeight = AutoGetHeight(height: 55) + self.departMentLayout.collectionHeight
                            self.viewHeight += nowHeight
                            self.rootLayout.addSubview(self.departMentLayout)
                            DLog(self.viewHeight)
                        }else if contentModel.type == "formular"{
                            let layout = CQDurationLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, unit:contentModel.unit,duration:dataJson[contentModel.name].stringValue)
                            self.viewHeight += AutoGetHeight(height: 55)
                            self.rootLayout.addSubview(layout)
                            DLog(self.viewHeight)
                        }else if contentModel.type == "remark" {
                            let layout = CQRemarkLayout.init(orientation: .horz, name:contentModel.name , type: contentModel.type, title: contentModel.title, prompt: dataJson[contentModel.name].stringValue)
                            self.viewHeight += layout.vHeight
                            self.rootLayout.addSubview(layout)
                            DLog(self.viewHeight)
                        }else if contentModel.type == "sub"{
                            let layout = CQSubLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title)
                            self.rootLayout.addSubview(layout)
                            self.viewHeight += AutoGetHeight(height: 20)
                            DLog(self.viewHeight)
                        }
                        else if contentModel.type == "attach"{
                            let arr = dataJson[contentModel.name].arrayValue
                            var curArr = [NCQApprovelDetailModel]()
                            for modelJson in arr{
                                guard let modal = NCQApprovelDetailModel(jsonData: modelJson) else {
                                    return
                                }
                                curArr.append(modal)
                            }
                            self.uploadLayout = CQAttachUpLoadLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required,dataArray:curArr,isFix:true)
                            self.uploadLayout.uploadDelegate = self
                            self.rootLayout.addSubview(self.uploadLayout)
                            let height = self.uploadLayout.reloadDataWithArray()
                            self.viewHeight = self.viewHeight + AutoGetHeight(height: 170) + height
                            DLog(self.viewHeight)
                        }
                        
                        
                        
                        
                    }
                }
                
                self.getApprovalPersonsRequest()
                self.table.reloadData()
                
        }) { (error) in
        }
    }
    
   
}

//layout控件
extension NCQApprovelVC{
    //分割线
    internal func addLineVLayout() -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(kWidth)
        wrapContentLayout.addSubview(self.addLineView())
        return wrapContentLayout
    }
   
    
    //灰色区域
    internal func addGrayViewContentLayout(height:CGFloat) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(height)
        wrapContentLayout.tg_width.equal(kWidth)
        wrapContentLayout.backgroundColor = kProjectBgColor
        
        return wrapContentLayout
    }
    
}

//界面控件
extension NCQApprovelVC{
    @objc internal func addLineView() -> UIView {
        let lineV = UIView.init()
        lineV.backgroundColor = kProjectBgColor
        lineV.tg_left.equal(AutoGetWidth(width: 15))
        lineV.tg_height.equal(0.5)
        lineV.tg_width.equal(kWidth - AutoGetWidth(width: 15))
        return lineV
    }
    
}


//控件代理
extension NCQApprovelVC:NCQCopyDelegate{
    func goToChooseCopyFor(dataArray: [CQDepartMentUserListModel]) {
//        let vc = AddressBookVC.init()
//        vc.toType = .fromSupply
        
        let vc = QRAddressBookVC.init()
        vc.toType = .fromGenJin
        vc.titleStr = "选择想要抄送的对象"
        vc.hasSelectModelArr = dataArray
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension NCQApprovelVC:LeaveBalanceDelegate{
    func myLeaveClick() {
        let vc = CQMyLeaveListVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension NCQApprovelVC:CQModifyDelegate{
    func goToModifyVC() {
        let vc = CQCardApplyVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension NCQApprovelVC:CQTogtherPersonDelegate{
    func chooseTogtherPerson(dataArray: [CQDepartMentUserListModel]) {
//        let vc = AddressBookVC.init()
//        vc.toType = .fromTogetherPerson
        
        let vc = QRAddressBookVC.init()
        vc.toType = .fromTogetherPerson
        vc.titleStr = "选择想要抄送的对象"
        vc.hasSelectModelArr = dataArray
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension NCQApprovelVC:CQPersonSingleChooseDelegate{
    func personChooseAction(dataArray: [CQDepartMentUserListModel]) {
        let vc = AddressBookVC.init()
        vc.toType = .fromOverTime
        if self.personModel != nil{
            vc.hasSelectModelArr = [self.personModel] as! [CQDepartMentUserListModel]
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//部门选择
extension NCQApprovelVC:chooseDepartMentDelegate{
    func chooseDepartMent() {
        let vc = AddressBookVC.init()
        vc.toType = .fromChooseDepart
        
//        let vc = QRAddressBookVC.init()
//        vc.toType = .fromChooseDepart
//        vc.titleStr = "选择部门"
        vc.selectDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//部门选择
extension NCQApprovelVC:CQDepartMentSelectDelegate{
    func selectCell(model: CQAddressBookModel) {
        self.departMentLayout.selectDepartStr = model.departmentName
        self.departMentLayout.reloadCollectionData(model: model)
    }
}


//Mark  attachUploadDelegate
extension NCQApprovelVC:CQAttachUploadDelegate{
    func attachUploadAction() {
        self.takePhoto()
    }
}


//关于图片视频上传
extension NCQApprovelVC{
    func takePhoto() {
        
        
        let alertSheet = UIAlertController(title: "", message: "请选择上传类型", preferredStyle: UIAlertControllerStyle.actionSheet)
        // 2 命令（样式：退出Cancel，警告Destructive-按钮标题为红色，默认Default）
        let cancelAction = UIAlertAction(title: "取消", style:  .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "上传图片", style:  .default, handler:{
            action in
            self.photoLib()
        })
        
        let archiveAction = UIAlertAction(title: "上传视频", style: .default, handler: {
            action in
            self.videoLib()
        })
        
        alertSheet.addAction(cancelAction)
        alertSheet.addAction(deleteAction)
        alertSheet.addAction(archiveAction)
        // 3 跳转
        self.present(alertSheet, animated: true, completion: nil)
    }
    
    
    //图库 - 照片
    func photoLib(){
        //
        flag = "图片"
        //判断设置是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //弹出控制器，显示界面
            self.present(picker, animated: true, completion: nil)
        }else{
            print("读取相册错误")
        }
    }
    
    
    //图库 - 视频
    func videoLib(){
        flag = "视频"
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            //初始化图片控制器
            let imagePicker = UIImagePickerController()
            //设置代理
            imagePicker.delegate = self
            //指定图片控制器类型
            imagePicker.sourceType = .photoLibrary;
            //只显示视频类型的文件
            imagePicker.mediaTypes =  [kUTTypeMovie as String]
            //不需要编辑
            imagePicker.allowsEditing = false
            //弹出控制器，显示界面
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            print("读取相册错误")
        }
    }
    
    
    /// 转换视频
    ///
    /// - Parameters:
    ///   - inputPath: 输入url
    ///   - outputPath:输出url
    func transformMoive(inputPath:String,outputPath:String){
        
        
        let avAsset:AVURLAsset = AVURLAsset(url: URL.init(fileURLWithPath: inputPath), options: nil)
        let assetTime = avAsset.duration
        
        let duration = CMTimeGetSeconds(assetTime)
        print("视频时长 \(duration)");
        let compatiblePresets = AVAssetExportSession.exportPresets(compatibleWith: avAsset)
        if compatiblePresets.contains(AVAssetExportPresetLowQuality) {
            let exportSession:AVAssetExportSession = AVAssetExportSession.init(asset: avAsset, presetName: AVAssetExportPresetMediumQuality)!
            let existBool = FileManager.default.fileExists(atPath: outputPath)
            if existBool {
            }
            exportSession.outputURL = URL.init(fileURLWithPath: outputPath)
            
            
            exportSession.outputFileType = AVFileType.mp4
            exportSession.shouldOptimizeForNetworkUse = true;
            exportSession.exportAsynchronously(completionHandler: {
                
                switch exportSession.status{
                    
                case .failed:
                    
                    print("失败...\(String(describing: exportSession.error?.localizedDescription))")
                    break
                case .cancelled:
                    print("取消")
                    break;
                case .completed:
                    print("转码成功")
                    let mp4Path = URL.init(fileURLWithPath: outputPath)
                    //                    self.uploadVideo(mp4Path: mp4Path,type:"file")
                    self.uploadImage(type: "file", name: "", urlPath: mp4Path)
                    break;
                default:
                    print("..")
                    break;
                }
            })
        }
    }
}

extension NCQApprovelVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if flag == "视频" {
            
            //获取选取的视频路径
            let videoURL = info[UIImagePickerControllerMediaURL] as! URL
            let pathString = videoURL.path
            print("视频地址：\(pathString)")
            //图片控制器退出
            self.dismiss(animated: true, completion: nil)
            let outpath = NSHomeDirectory() + "/Documents/\(Date().timeIntervalSince1970).mp4"
            //视频转码
            self.transformMoive(inputPath: pathString, outputPath: outpath)
        }else{
            //flag = "图片"
            self.photoArray.removeAll()
            //获取选取后的图片
            let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.photoArray.append(pickedImage)
            //上传
            self.uploadImage(type: "image", name: "",urlPath:nil)
            //图片控制器退出
            self.dismiss(animated: true, completion:nil)
        }
        
    }
    
    
}

//图片上传 与 视频 上传
extension NCQApprovelVC{
    //上传文件
    @objc func uploadImage(type:String,name:String,urlPath:URL?)  {
        let userID = STUserTool.account().userID
        let urlUpload = "\(baseUrl)/approval/uploadFile"
        let headers = ["t_userId":userID,
                       "token":STUserTool.account().token]
        SVProgressHUD.show()
        Alamofire.upload(multipartFormData: { formData in
            let param = ["emyeId":userID]
            
            //            if self.photoArray.count <= 10 && self.photoArray.count>0 {
            //                self.photoArray.removeLast()
            //            }
            
            let now = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
            var current = ""
            current = dateFormat.string(from: now)
            let realName = STUserTool.account().realName
            var name = ""
            name = realName + " " + current + ".png"
            DLog(name)
            if type == "image"{
                for index in 0..<self.photoArray.count {
                    let imageData = UIImageJPEGRepresentation(self.photoArray[index], 0.3)
                    formData.append(imageData!, withName: "file", fileName:name, mimeType: "image/jpg")
                }
            }else{
                //                for index in 0..<self.photoArray.count {
                let vidioName = realName + current + ".mp4"
                formData.append(urlPath!, withName: "file", fileName: vidioName, mimeType: "video/mp4")
                //                }
            }
            
            for (key, value) in param {
                formData.append((value.data(using: .utf8)!), withName: key)
            }
        }, to: urlUpload, headers: headers, encodingCompletion: {encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    SVProgressHUD.dismiss()
                    let js = JSON.init(response.data as Any)
                    let model = NCQApprovelDetailModel.init(jsonData: js)
                    for modeljson in model!.data{
                        let dModel = NCQApprovelDetailModel.init(jsonData: modeljson)
                        DLog(dModel!.fileName)
                        if self.uploadFileNameArray.count <= 9{
                            self.uploadFileNameArray.append(dModel!.fileName)
                            self.uploadUrlArray.append(dModel!.fileUrl)
                            self.uploadModelArray.append(dModel!)
                            self.uploadLayout.dataArray = self.uploadModelArray
                            let lastHeight = self.uploadLayout.tableHeight
                            let curHeight = self.uploadLayout.reloadDataWithArray()
                            self.viewHeight = self.viewHeight + (curHeight - lastHeight)
                        }else{
                            SVProgressHUD.showError(withStatus: "最多上传9个文件")
                        }
                        
                    }
                    
                    SVProgressHUD.showSuccess(withStatus: "上传成功")
                }
            case .failure( _):
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "上传失败,请稍后重试")
            }
        })
    }
    
    //上传视频到服务器
    func uploadVideo(mp4Path : URL,type:String){
        let userID = STUserTool.account().userID
        let urlUpload = "\(baseUrl)/approval/uploadFile"
        let headers = ["t_userId":userID,
                       "token":STUserTool.account().token,
                       "type":type]
        SVProgressHUD.show()
        Alamofire.upload(
            //同样采用post表单上传
            multipartFormData: { multipartFormData in
                let param = ["emyeId":userID]
                multipartFormData.append(mp4Path, withName: "file", fileName: "123456.mp4", mimeType: "video/mp4")
                
                for (key, value) in param {
                    multipartFormData.append((value.data(using: .utf8)!), withName: key)
                }
                
                //服务器地址
        },to:urlUpload,headers:headers ,encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                //json处理
                upload.responseJSON { response in
                    
                    SVProgressHUD.dismiss()
                    //解包
                    guard let result = response.result.value else { return }
                    print("json:\(result)")
                }
                //上传进度
                upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                    print("视频上传进度: \(progress.fractionCompleted)")
                }
            case .failure(let encodingError):
                print(encodingError)
                
                SVProgressHUD.dismiss()
            }
        })
    }
}


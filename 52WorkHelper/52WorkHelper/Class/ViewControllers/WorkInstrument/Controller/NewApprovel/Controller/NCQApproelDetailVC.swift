//
//  NCQApproelDetailVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/10/28.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit

class NCQApproelDetailVC: SuperVC {

    weak var rootLayout :TGLinearLayout!
    //标题
    var titleStr = ""
    var businessApplyId = ""
    //审批业务主键(用于驳回重新提交时，查询审批人和抄送人接口)
    var approvalBusinessId = ""
    //审批人列表
    var approveListArray = [NCQApprovelDetailModel]()
    //抄送人列表
    var copyPersonListArray = [NCQApprovelDetailModel]()
    //业务编码
    var businessCode = ""
    //界面高度
    var viewHeight:CGFloat = 88
    //从哪里进入此界面 从我提交的
    var isFromMeSubmit = false
    //从哪里进入此界面 从抄送给我
    var isFromCopyToMe = false
    //从哪里进入此界面 从我已审批的进入
    var isFromMeHasApprovel = false
    ////从哪里进入此界面  从待我审批的进入
    var isFromWaitApprovel = false
    //交通工具数组
    var traficArray = [NCQApprovelDetailModel]()
    //申请状态码(0-审核中，1-审核通过，2-被驳回，3-已撤销，4-已销假(请假申请))
    var applyStatusCode = ""
    //车数据
    var carDic:NSDictionary?
    //房数据
    var meetingDic:NSDictionary?
    //外出数据
    var workOutDic:NSDictionary?
    //备注视图
    var remarkView:CQApprovalRemarkView?
    //点击推送进入
    var isFromApp = false
    //请假类型
    var vacationType = ""
    //请假时长layout
    var vacationLayout:CQApprovelContentLayout!
    //标记无效按钮
    lazy var uselessBut :UIButton = {
        let uselessBut = UIButton(frame:  CGRect(x: kWidth/3, y: AutoGetWidth(width: 10), width: kWidth/3, height: AutoGetWidth(width: 35)))
        uselessBut.setTitle("标记无效", for: UIControlState.normal)
        uselessBut.backgroundColor = kBlueC
        uselessBut.setTitleColor(UIColor.white, for: UIControlState.normal)
        uselessBut.layer.cornerRadius = AutoGetWidth(width: 11)//kWidth/3/9
        uselessBut.isHidden = false
        uselessBut.addTarget(self, action: #selector(uselessClick), for: UIControlEvents.touchUpInside)
        return uselessBut
    }()
    lazy var uselessView :UIView = {
        let uselessView = UIButton(frame:  CGRect(x: 0, y: kHeight-SafeAreaBottomHeight-AutoGetWidth(width: 55), width: kWidth, height: AutoGetWidth(width: 55)))
        uselessView.backgroundColor = UIColor.white
       
        return uselessView
    }()
    
    
    //底部按钮
    lazy var bottomView :UIView = {
        let bottomView = UIView(frame:  CGRect(x: 0, y: kHeight-SafeAreaBottomHeight-49, width: kWidth, height: 49+SafeAreaBottomHeight))
        bottomView.backgroundColor = kProjectBgColor
        
        return bottomView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isFromApp {
            self.navigationItem.leftBarButtonItem = self.barBackButton()
        }
    }
    
    
    
    
    
    //标记无效
    @objc func uselessClick(){
        loadingPlay()
        print("标记无效")
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/markInvalidOUtApply" ,
            type: .get,
            param: ["businessApplyId":self.businessApplyId],
            successCallBack: { (result) in
              //  let panduan = result["data"]["needApproval"].boolValue
                
                NotificationCenter.default.post(name: NSNotification.Name.init("refleshAllreadySignUseless"), object: nil)
                self.navigationController?.popViewController(animated: true)
               self.loadingSuccess()
        }) { (error) in
            self.loadingSuccess()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
        
        if self.isFromCopyToMe{//从抄送
            let urlStr = "\(baseUrl)/approval/getMyCopyInfo"
            self.title = self.titleStr
            self.loadDatas(urlStr: urlStr, type: "")
        }else if self.isFromMeHasApprovel{//从我已审批的
            let urlStr = "\(baseUrl)/approval/getApprovalDetail"
            self.title = "审批流程"
            self.loadDatas(urlStr: urlStr, type: "1")
        }else if self.isFromMeSubmit{//从我提交的
            self.title = self.titleStr
            self.loadData()
        }else if self.isFromWaitApprovel{
            
            self.title = "审批流程"
            let urlStr = "\(baseUrl)/approval/getApprovalDetail"
            self.loadDatas(urlStr: urlStr, type: "2")
        }
        
        
        self.headView.tg_height.equal(.wrap)
        self.headView.tg_width.equal(.wrap)
        let rootLayout = TGLinearLayout(.vert)
        rootLayout.tg_height.equal(.wrap)
        rootLayout.tg_width.equal(.wrap)
        //        rootLayout.tg_padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        rootLayout.tg_zeroPadding = false   //这个属性设置为false时表示当布局视图的尺寸是wrap也就是由子视图决定时并且在没有任何子视图是不会参与布局视图高度的计算的。您可以在这个DEMO的测试中将所有子视图都删除掉，看看效果，然后注释掉这句代码看看效果。
        //        rootLayout.tg_vspace = 5
        self.headView.addSubview(rootLayout)
        self.rootLayout = rootLayout
    }
    
    @objc func returnClick()  {
        if self.applyStatusCode == "0" {
            self.cancelApplyRequest()
        }else{
            if self.businessCode == "B_CL"{
                let vc = CQCarApplyVC()
                vc.dataDic = self.carDic
                vc.isFromMyApplyVC = true
                self.navigationController?.pushViewController(vc, animated: true)
            }else if self.businessCode == "B_HYS"{
                let vc = CQMeetingRommBookVC()
                vc.resultFormDict = self.meetingDic
                vc.isFromMyApplyVC = true
                self.navigationController?.pushViewController(vc, animated: true)
            }else if self.businessCode == "B_WCTQXB"{
                let vc = CQEarlyWorkOutVC()
                vc.textView.prevText = (self.workOutDic!["outReason"] as! String)
                vc.outReason = self.workOutDic!["outReason"] as! String
                vc.businessApplyId = self.businessApplyId
                vc.isFromMyApplyVC = true
                self.navigationController?.pushViewController(vc, animated: true)
            }else if self.businessCode == "B_QJ" {
                if (self.applyStatusCode == "3" || self.applyStatusCode == "2"){
                    let vc = NCQApprovelVC()
                    //该审批的id
                    vc.approvalBusinessId = self.businessApplyId
                    //撤销的审批用来获取抄送人和审批人的id
                    vc.detailBid = self.approvalBusinessId
                    vc.isFromSubmitDetail = true
                    vc.isFromApplyDetail = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let alertVC = UIAlertController.init(title: "", message: "你确定销假么？", preferredStyle: UIAlertControllerStyle.alert)
                    let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
                    let okAction = UIAlertAction.init(title: "确定", style: .default) { (action) in
                        self.cancelLeaveApply()
                    }
                    alertVC.addAction(cancelAction)
                    alertVC.addAction(okAction)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }else{
                let vc = NCQApprovelVC()
                vc.approvalBusinessId = self.businessApplyId
                vc.detailBid = self.approvalBusinessId
                vc.isFromSubmitDetail = true
                vc.isFromApplyDetail = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }

    @objc func deciedeClick(btn:UIButton) {
        if 10086 == btn.tag {
            remarkView = CQApprovalRemarkView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), viewTitle: "同意", isAgree: true,placeHolder:"请输入备注(选填)")
            remarkView?.cqRemarkDelegate = self
            remarkView?.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
            let app = UIApplication.shared.delegate as! AppDelegate
            app.window?.addSubview(remarkView!)
        }else if 10087 == btn.tag{
            remarkView = CQApprovalRemarkView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), viewTitle: "驳回", isAgree: false,placeHolder:"请输入备注(必填)")
            remarkView?.cqRemarkDelegate = self
            remarkView?.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
            let app = UIApplication.shared.delegate as! AppDelegate
            app.window?.addSubview(remarkView!)
        }else if 10088 == btn.tag{
            remarkView = CQApprovalRemarkView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), viewTitle: "转交", isAgree: false,placeHolder:"请输入备注(必填)")
            remarkView?.cqRemarkDelegate = self
            remarkView?.isTurnSomeOne = true
            remarkView?.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
            let app = UIApplication.shared.delegate as! AppDelegate
            app.window?.addSubview(remarkView!)
        }
    }
    
    
    //MARK 懒加载控件
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - AutoGetHeight(height: 0)), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - AutoGetHeight(height: 0)))
        return headView
    }()
    
    lazy var returnBtn: UIButton = {
        let returnBtn = UIButton.init(type: .custom)
        returnBtn.frame = CGRect.init(x: 0, y: kHeight - AutoGetHeight(height: 49) - CGFloat(SafeAreaBottomHeight), width: kWidth, height: AutoGetHeight(height: 49))
        returnBtn.setTitle("撤销", for: .normal)
        returnBtn.setTitleColor(kLightBlueColor, for: .normal)
        returnBtn.backgroundColor = UIColor.white
        returnBtn.layer.borderWidth = 0.5
        returnBtn.layer.borderColor = kProjectBgColor.cgColor
        returnBtn.addTarget(self, action: #selector(returnClick), for: .touchUpInside)
        return returnBtn
    }()
    
}


//MARK 数据加载
extension NCQApproelDetailVC{
    
    // MARK:request
    fileprivate func loadData() {
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/approval/getMyApplyDetail",
            type: .get,
            param: ["emyeId":userID,
                    "businessApplyId":self.businessApplyId],
            successCallBack: { (result) in
                
                guard let model = NCQApprovelDetailModel(jsonData: result["data"]) else {
                    return
                }
                
                self.approvalBusinessId = model.approvalBusinessId
                self.businessCode = model.businessCode
                
                //审批进度列表
                var approveArr = [NCQApprovelDetailModel]()
                for copyJson in model.approverList{
                    let copyModel = NCQApprovelDetailModel(jsonData: copyJson)
                    approveArr.append(copyModel!)
                }
                
                self.approveListArray = approveArr
                
                //抄送人列表
                var copyPersonListArr = [NCQApprovelDetailModel]()
                for copyJson in model.copyPersonList{
                    let copyModel = NCQApprovelDetailModel(jsonData: copyJson)
                    copyPersonListArr.append(copyModel!)
                }
                
                self.copyPersonListArray = copyPersonListArr
                
                //底部按钮显示状态  申请状态码(0-审核中，1-审核通过，2-被驳回，3-已撤销，4-已销假(请假申请))
                self.applyStatusCode = model.applyStatusCode
                self.businessCode = model.businessCode
                if self.isFromMeSubmit{
                    if self.applyStatusCode == "0"{
                        self.view.addSubview(self.returnBtn)
                        self.returnBtn.setTitle("撤销", for: .normal)
                    }else if self.applyStatusCode == "1"{
                        if self.businessCode == "B_QJ"{
                            self.view.addSubview(self.returnBtn)
                            self.returnBtn.setTitle("销假", for: .normal)
                        }
                    }else if self.applyStatusCode == "2"{
                        self.view.addSubview(self.returnBtn)
                        self.returnBtn.setTitle("已被驳回 请修改申请", for: .normal)
                    }else if self.applyStatusCode == "3"{
                        self.view.addSubview(self.returnBtn)
                        self.returnBtn.setTitle("已撤销 请修改申请", for: .normal)
                    }else if self.applyStatusCode == "4"{
//                        self.view.addSubview(self.returnBtn)
                    }
                }
                
                
                
                //加载头部 从我提交进入
                if self.isFromMeSubmit{
                    let headLayout = CQApprovelDetailHeaderLayout.init(orientation: .horz, name: "", type: "", title: "", prompt: "", require: false, content: "", imageUrl: model.headImage,statusStr:model.statusDesc)
                    self.rootLayout.addSubview(headLayout)
                    self.viewHeight += AutoGetHeight(height: 70)
                    DLog(self.viewHeight)
                }
                
                
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
                
                
                //解析派车表单数据
                
                
                //生成派车界面
                if model.businessCode == "B_CL"{
                    self.title = "我的派车"
                    let resultFormDict = dataArray[0] as! NSDictionary
                    self.carDic = resultFormDict
                    
                    let desLayout = CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "目的地", prompt: "", require: false, content: dataModel.destination)
                    self.rootLayout.addSubview(desLayout)
                    self.viewHeight += desLayout.viewHeight
                    DLog(self.viewHeight)
                    
                    let remarkLayout = CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "事由", prompt: "", require: false, content: dataModel.applyReason)
                    self.rootLayout.addSubview(remarkLayout)
                    self.viewHeight += remarkLayout.viewHeight
                    DLog(self.viewHeight)
                    
                    let startLayout = CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "开始时间", prompt: "", require: false, content: dataModel.startDate)
                    self.rootLayout.addSubview(startLayout)
                    self.viewHeight += startLayout.viewHeight
                    DLog(self.viewHeight)
                    
                    let endLayout = CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "结束时间", prompt: "", require: false, content: dataModel.endDate)
                    self.rootLayout.addSubview(endLayout)
                    self.viewHeight += endLayout.viewHeight
                    DLog(self.viewHeight)
                    
                    var carType = ""
                    if dataModel.carType == "1"{
                        carType = "商务车"
                    }else if dataModel.carType == "2"{
                        carType = "货车"
                    }else if dataModel.carType == "3"{
                        carType = "客车"
                    }
                    let carTypeLayout = CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "车辆类型", prompt: "", require: false, content: carType)
                    self.rootLayout.addSubview(carTypeLayout)
                    self.viewHeight += carTypeLayout.viewHeight
                    DLog(self.viewHeight)
                    
                    guard let pbulicCarModel = NCQApprovelDetailModel.init(jsonData: dataModel.pbulicCar) else {
                        return
                    }
                    let carLayout = CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "车辆", prompt: "", require: false, content: pbulicCarModel.name)
                    self.rootLayout.addSubview(carLayout)
                    self.viewHeight += carLayout.viewHeight
                    DLog(self.viewHeight)
                }else if model.businessCode == "B_HYS"{ //生成会议室界面
                    self.title = "我的会议室"
                    let resultFormDict = dataArray[0] as! NSDictionary
                    self.meetingDic = resultFormDict
                    
                    let titleLayout = CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "主题", prompt: "", require: false, content: dataModel.meetingTitle)
                    self.rootLayout.addSubview(titleLayout)
                    self.viewHeight += titleLayout.viewHeight
                    DLog(self.viewHeight)
                    
                    let remarkLayout = CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "概要", prompt: "", require: false, content: dataModel.outLine)
                    self.rootLayout.addSubview(remarkLayout)
                    self.viewHeight += remarkLayout.viewHeight
                    DLog(self.viewHeight)
                    
                    let startLayout = CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "开始时间", prompt: "", require: false, content: dataModel.startDate)
                    self.rootLayout.addSubview(startLayout)
                    self.viewHeight += startLayout.viewHeight
                    DLog(self.viewHeight)
                    
                    let endLayout = CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "结束时间", prompt: "", require: false, content: dataModel.endDate)
                    self.rootLayout.addSubview(endLayout)
                    self.viewHeight += endLayout.viewHeight
                    DLog(self.viewHeight)
                    
                    guard let roomModel = NCQApprovelDetailModel.init(jsonData: dataModel.meetingRoom) else {
                        return
                    }
                    let roomLayout = CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "会议室", prompt: "", require: false, content: roomModel.name)
                    self.rootLayout.addSubview(roomLayout)
                    self.viewHeight += roomLayout.viewHeight
                    DLog(self.viewHeight)
                }else if model.businessCode == "B_WCTQXB"{
                    //self.title = "外出提前下班"
                    let resultFormDict = dataArray[0] as! NSDictionary
                    self.workOutDic = resultFormDict
                    
                    let titleLayout = CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "提前下班理由", prompt: "", require: false, content: dataModel.outReason)
                    self.rootLayout.addSubview(titleLayout)
                    self.viewHeight += titleLayout.viewHeight
                    DLog(self.viewHeight)
                    
                    let remarkLayout = CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "外出地址", prompt: "", require: false, content: dataModel.addressRemark)
                    self.rootLayout.addSubview(remarkLayout)
                    self.viewHeight += remarkLayout.viewHeight
                    DLog(self.viewHeight)

                }
                
                
                //解析表单
                let formContentStr = model.formContent
                if !formContentStr.isEmpty{
                    let formContentData = formContentStr.data(using: String.Encoding.utf8)!
                    guard let array = JSON(formContentData).arrayObject as? [[String: AnyObject]] else {
                        return
                    }
                    
                    //获取["widget"]内的数据 然后用contentModel去映射它
                    for i in 0..<array.count{
                        let arr = array[i]
                        let dic = arr["widget"]
                        let jsonStr = JSON.init(dic!)
//                        DLog(dic)
                        guard let contentModel = NCQApprovelDetailModel.init(jsonData: jsonStr) else {
                            return
                        }
                        
                        //遍历contentModel内的subwidght  然后把数据保存在subWidgetArray内
                        var subWidgetArray = [NCQApprovelDetailModel]()
                        for modalJson in contentModel.subWidget {
                            guard let modal = NCQApprovelDetailModel(jsonData: modalJson) else {
                                return
                            }
                            subWidgetArray.append(modal)
                        }
                        
                        
                        
                        if contentModel.type == "leave"{
                            let layout = CQApprovelContentLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: "所在部门", prompt: contentModel.prompt, require: contentModel.required, content: model.departmentName)
                            self.rootLayout.addSubview(layout)
                            self.viewHeight += layout.viewHeight
                            DLog(self.viewHeight)
                        }
                        
                        //这里是遍历subWidgetArray内的元素  判断对应的控件
                        for subModel in subWidgetArray{
                            if subModel.type == "select"{
                                if subModel.name == "vacationType"{
                                    let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.vacationType)
                                    self.vacationType = dataModel.vacationType
                                    self.rootLayout.addSubview(layout)
                                    self.viewHeight += layout.viewHeight
                                    DLog(self.viewHeight)
                                }
                            }else if subModel.type == "date"{
                                if subModel.name == "startTime"{
                                    if contentModel.type == "business"{
                                        let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: oneBusinessModel.startTime)
                                        self.rootLayout.addSubview(layout)
                                        self.viewHeight += layout.viewHeight
                                    }else {
                                        let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.startTime)
                                        self.rootLayout.addSubview(layout)
                                        self.viewHeight += layout.viewHeight
                                    }
                                    
                                    DLog(self.viewHeight)
                                }else if subModel.name == "endTime"{
                                    if contentModel.type == "business"{
                                        let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: oneBusinessModel.endTime)
                                        self.rootLayout.addSubview(layout)
                                        self.viewHeight += layout.viewHeight
                                    }else{
                                        if result["data"]["isShowEndTime"].boolValue == true{
                                            let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.endTime)
                                            self.rootLayout.addSubview(layout)
                                             self.viewHeight += layout.viewHeight
                                        }else{
                                            let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: "")
                                            self.rootLayout.addSubview(layout)
                                            self.viewHeight += layout.viewHeight
                                        }
                                        

                                    }
                                    DLog(self.viewHeight)
                                }else if subModel.name == "modifyTime"{
                                    let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.modifyTime)
                                    self.rootLayout.addSubview(layout)
                                    self.viewHeight += layout.viewHeight
                                    DLog(self.viewHeight)
                                }
                            }else if subModel.type == "duration"{
                                if subModel.name == "duration"{
                                    if contentModel.type == "business"{
                                        let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: oneBusinessModel.duration + "天")
                                        self.rootLayout.addSubview(layout)
                                        self.viewHeight += layout.viewHeight
                                    }else if contentModel.type == "leave"{
                                        self.getLeaveTypeRequest()
                                        self.vacationLayout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.duration)
                                        self.rootLayout.addSubview(self.vacationLayout)
                                        self.viewHeight += self.vacationLayout.viewHeight
                                    }else if contentModel.type == "outWork" || contentModel.type == "overtime"{
                                        
                                        if contentModel.type == "outWork" {
                                            
                                            if result["data"]["isShowEndTime"].boolValue == true{
                                                let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.duration + "小时")
                                                self.rootLayout.addSubview(layout)
                                                self.viewHeight += layout.viewHeight
                                            }else{
                                                let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: "")
                                                self.rootLayout.addSubview(layout)
                                                self.viewHeight += layout.viewHeight
                                            }
                                           
                                        }else{
                                            let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.duration + "小时")
                                            self.rootLayout.addSubview(layout)
                                            self.viewHeight += layout.viewHeight
                                        }
                                        
                                        
                                        
                                       
                                    }
                                    
                                    DLog(self.viewHeight)
                                }
                            }else if subModel.type == "text"{
                                if subModel.name == "leaveReason"{
                                    let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.leaveReason)
                                    self.rootLayout.addSubview(layout)
                                    self.viewHeight += layout.viewHeight
                                    DLog(self.viewHeight)
                                }else if subModel.name == "modifyReason"{
                                    let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.modifyReason)
                                    self.rootLayout.addSubview(layout)
                                    self.viewHeight += layout.viewHeight
                                    DLog(self.viewHeight)
                                }else if subModel.name == "travelReason"{
                                    let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.travelReason)
                                    self.rootLayout.addSubview(layout)
                                    self.viewHeight += layout.viewHeight
                                    DLog(self.viewHeight)
                                }else if subModel.name == "remark"{
                                    let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.remark)
                                    self.rootLayout.addSubview(layout)
                                    self.viewHeight += layout.viewHeight
                                    DLog(self.viewHeight)
                                }
                            }else if subModel.type == "person"{
                                if subModel.name == "extraPerson"{
                                    guard let personModel = NCQApprovelDetailModel.init(jsonData: dataModel.extraPerson) else {
                                        return
                                    }
                                    let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: personModel.name)
                                    self.rootLayout.addSubview(layout)
                                    self.viewHeight += layout.viewHeight
                                    DLog(self.viewHeight)
                                }else if subModel.name == "togetherPerson"{
                                    let personArr = dataModel.togetherPerson
                                    var personModelArray = [CQDepartMentUserListModel]()
                                    for modelJson in personArr{
                                        guard let modal = CQDepartMentUserListModel(jsonData: modelJson) else {
                                            return
                                        }
                                        personModelArray.append(modal)
                                    }
                                    let layout = CQShowPersonLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required,dataArray:personModelArray,isDetail:true)
                                    self.rootLayout.addSubview(layout)
                                    self.viewHeight += layout.collectionHeight
                                    DLog(self.viewHeight)
                                }
                            }else if subModel.type == "sub" {
                                if subModel.name == "sub"{
                                    if contentModel.type == "business"{
                                        let layout = CQSubLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title + "\(bussinessDetailArray.count)")
                                        self.rootLayout.addSubview(layout)
                                        self.viewHeight += AutoGetHeight(height: 20)
                                    }else{
                                        let layout = CQSubLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title )
                                        self.rootLayout.addSubview(layout)
                                        self.viewHeight += AutoGetHeight(height: 20)
                                    }
                                    
                                    DLog(self.viewHeight)
                                }
                            }else if subModel.type == "checkbox"{
                                if subModel.name == "isBack"{
                                    if contentModel.type == "business"{
                                        var str = ""
                                        if oneBusinessModel.isBack{
                                            str = "往返"
                                        }else{
                                            str = "单程"
                                        }
                                        let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content:str)
                                        self.rootLayout.addSubview(layout)
                                        self.viewHeight += layout.viewHeight
                                    }else{
                                        var str = ""
                                        if dataModel.isBack{
                                            str = "往返"
                                        }else{
                                            str = "单程"
                                        }
                                        let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: str)
                                        self.rootLayout.addSubview(layout)
                                        self.viewHeight += layout.viewHeight
                                    }
                                    
                                    DLog(self.viewHeight)
                                }else if subModel.name == "transport"{
                                    
                                    for modalJson in subModel.dataSource {
                                        guard let modal = NCQApprovelDetailModel(jsonData: modalJson) else {
                                            return
                                        }
                                        self.traficArray.append(modal)
                                    }
                                    
                                    let layout = CQTranSportLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: oneBusinessModel.transport,traficArray:self.traficArray)
                                    self.rootLayout.addSubview(layout)
                                    self.viewHeight += layout.viewHeight
                                }
                            }else if subModel.type == "area"{
                                if subModel.name == "fromCity"{
                                    if contentModel.type == "business"{
                                        let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: oneBusinessModel.fromCity)
                                        self.rootLayout.addSubview(layout)
                                        self.viewHeight += layout.viewHeight
                                    }else{
                                        let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.fromCity)
                                        self.rootLayout.addSubview(layout)
                                        self.viewHeight += layout.viewHeight
                                    }
                                    
                                    DLog(self.viewHeight)
                                }else if subModel.name == "toCity"{
                                    if contentModel.type == "business"{
                                        let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: oneBusinessModel.toCity)
                                        self.rootLayout.addSubview(layout)
                                        self.viewHeight += layout.viewHeight
                                    }else{
                                        let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.toCity)
                                        self.rootLayout.addSubview(layout)
                                        self.viewHeight += layout.viewHeight
                                    }
                                    
                                    DLog(self.viewHeight)
                                }
                            }else if subModel.type == "formular"{
                                if subModel.name == "travelDays"{
                                    let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.travelDays + "天")
                                    self.rootLayout.addSubview(layout)
                                    self.viewHeight += layout.viewHeight
                                    DLog(self.viewHeight)
                                }
                            }else if subModel.type == "addDetail"{
                                if subModel.name == "addDetail"{
                                    
                                    bussinessDetailArray.removeFirst()
                                    for addModel in bussinessDetailArray{
                                        
                                        let layout = CQBussinessAddLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, transport: addModel.transport, isBack: addModel.isBack, fromCity: addModel.fromCity, toCity: addModel.toCity, startTime: addModel.startTime, endTime: addModel.endTime, duration: addModel.duration + "天",traficArray:self.traficArray)
                                        self.rootLayout.addSubview(layout)
                                        self.viewHeight += AutoGetHeight(height: 350)
                                    }
                                    
                                    DLog(self.viewHeight)
                                }
                            }
                        }
                        
                        
                        
                        if contentModel.type == "person"{
                            let personArr = dataJson[contentModel.name].arrayValue
                            var personModelArray = [CQDepartMentUserListModel]()
                            for modelJson in personArr{
                                guard let modal = CQDepartMentUserListModel(jsonData: modelJson) else {
                                    return
                                }
                                personModelArray.append(modal)
                            }
                            let layout = CQShowPersonLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required,dataArray:personModelArray,isDetail:true)
                            self.rootLayout.addSubview(layout)
                            self.viewHeight += layout.collectionHeight
                            DLog(self.viewHeight)
                        }else if contentModel.type == "leave" || contentModel.type == "outWork" || contentModel.type == "business" || contentModel.type == "overtime" || contentModel.type == "modify"{
                            
                        }else if contentModel.type == "attach"{
                            let personArr = dataJson[contentModel.name].arrayValue
                            var personModelArray = [NCQApprovelDetailModel]()
                            for modelJson in personArr{
                                guard let modal = NCQApprovelDetailModel(jsonData: modelJson) else {
                                    return
                                }
                                personModelArray.append(modal)
                            }
                            let layout = CQHasPornLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required,dataArray:personModelArray)
                            layout.goDelegate = self
                            let nowHeight = AutoGetHeight(height: 55) * CGFloat(personModelArray.count + 1)
                            self.viewHeight += nowHeight
                            self.rootLayout.addSubview(layout)
                            DLog(self.viewHeight)
                        }else if contentModel.type == "department"{
                            let personArr = dataJson[contentModel.name].arrayValue
                            var personModelArray = [CQAddressBookModel]()
                            for modelJson in personArr{
                                guard let modal = CQAddressBookModel(jsonData: modelJson) else {
                                    return
                                }
                                personModelArray.append(modal)
                            }
                            let layout = CQDepartmentLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, dataArray: personModelArray, single: contentModel.single,isDetail:true)
                            let nowHeight = AutoGetHeight(height: 55) + layout.collectionHeight
                            self.viewHeight += nowHeight
                            self.rootLayout.addSubview(layout)
                            DLog(self.viewHeight)
                        }else if contentModel.type == "sub"{
                            let layout = CQSubLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title )
                            self.rootLayout.addSubview(layout)
                            self.viewHeight += AutoGetHeight(height: 20)
                        }else{
                            if contentModel.type == "checkbox" {
                                var curTitle = ""
                                for modelJson in contentModel.dataSource{
                                    let model = NCQApprovelDetailModel.init(jsonData: modelJson)
                                    if dataJson[contentModel.name].stringValue == model!.value{
                                        curTitle = model!.text
                                    }
                                }
                                let layout = CQApprovelContentLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, content: curTitle)
                                self.rootLayout.addSubview(layout)
                                self.viewHeight += layout.viewHeight
                                DLog(self.viewHeight)
                            }else{
                                let layout = CQApprovelContentLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, content: dataJson[contentModel.name].stringValue)
                                self.rootLayout.addSubview(layout)
                                self.viewHeight += layout.viewHeight
                                DLog(self.viewHeight)
                            }
                        }
                        
                    }
                    
                }
                
                self.rootLayout.addSubview(self.addGrayViewContentLayout(height: AutoGetHeight(height: 13)))
                self.viewHeight += AutoGetHeight(height: 13)
                for i in 0..<self.approveListArray.count{
                    if self.isFromMeSubmit{//从我提交的进
                        let firModel = self.approveListArray[i]
                        let layout = CQApprovelCellLayout.init(orientation: .horz, realName: firModel.realName, headImage: firModel.headImage, approveTime: firModel.approveTime, approvalResultRemark: firModel.approvalResultRemark, approvalResult: firModel.approvalResult)
                        self.rootLayout.addSubview(layout)
                        self.viewHeight += AutoGetHeight(height: 55)
                    }else if self.isFromCopyToMe{//我抄送给我的进
                        if 0 == i{
                            let firModel = self.approveListArray[i]
                            let layout = CQCopyToMeBeginLayout.init(orientation: .horz, realName: firModel.realName, headImage: firModel.headImage, approveTime: firModel.approveTime, approvalResultRemark: firModel.approvalResultRemark, approvalResult: firModel.approvalResult)
                            self.rootLayout.addSubview(layout)
                            self.viewHeight += AutoGetHeight(height: 55)
                        }else{
                            let firModel = self.approveListArray[i]
                            let layout = CQApprovelCellLayout.init(orientation: .horz, realName: firModel.realName, headImage: firModel.headImage, approveTime: firModel.approveTime, approvalResultRemark: firModel.approvalResultRemark, approvalResult: firModel.approvalResult)
                            self.rootLayout.addSubview(layout)
                            self.viewHeight += AutoGetHeight(height: 55)
                        }
                    }else{
                        if 0 == i{
                            let firModel = self.approveListArray[i]
                            let layout = CQBeginApplyLayout.init(orientation: .horz, realName: firModel.realName, headImage: firModel.headImage, approveTime: firModel.approveTime, approvalResultRemark: firModel.approvalResultRemark, approvalResult: firModel.approvalResult)
                            self.rootLayout.addSubview(layout)
                            self.viewHeight += AutoGetHeight(height: 55)
                        }else{
                            let firModel = self.approveListArray[i]
                            let layout = CQApprovelCellLayout.init(orientation: .horz, realName: firModel.realName, headImage: firModel.headImage, approveTime: firModel.approveTime, approvalResultRemark: firModel.approvalResultRemark, approvalResult: firModel.approvalResult)
                            self.rootLayout.addSubview(layout)
                            self.viewHeight += AutoGetHeight(height: 55)
                        }
                    }
                }
                
                if self.copyPersonListArray.count > 0{
                    self.rootLayout.addSubview(self.addGrayViewContentLayout(height: AutoGetHeight(height: 13)))
                    self.viewHeight += AutoGetHeight(height: 13)
                    DLog(self.viewHeight)
                    let copyCollectionLayout = CQCopyPersonLayout.init(orientation: .horz, name: "cppy", type: "collection", title: "抄送人", prompt: "审批通过后,通知抄送人", require: false, dataArray: self.copyPersonListArray)
                    self.rootLayout.addSubview(copyCollectionLayout)
                    self.viewHeight = copyCollectionLayout.collectionHeight + AutoGetHeight(height: 55) + self.viewHeight
                    DLog(self.viewHeight)
                }
               
                
                self.viewHeight += AutoGetHeight(height: 10)
                self.headView.frame =  CGRect.init(x: 0, y: 0, width: kWidth, height: self.viewHeight)
                self.table.tableHeaderView = self.headView
                self.table.reloadData()
        }) { (error) in
            
        }
        
    }
    
    //获取所有请假类型
    func getLeaveTypeRequest() {
        let userID = STUserTool.account().userID
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getAllVacationType" ,
            type: .get,
            param: ["emyeId":userID],
            successCallBack: { (result) in
                var textArray = [String]()
                var valueArray = [String]()
                var unitArray = [String]()
                for modalJson in result["data"].arrayValue {
                    
                    let model = modalJson.dictionaryValue
                    textArray.append((model["text"]?.stringValue)!)
                    valueArray.append((model["value"]?.stringValue)!)
                    unitArray.append((model["vacationUnit"]?.stringValue)!)
                }
                //请假单位(1-小时，2-半天，3-天)
                var unit = ""
                for i in 0..<valueArray.count{
                    if valueArray[i] == self.vacationType{
                        unit = unitArray[i]
                        if unit == "1"{
                            let lab = self.vacationLayout.viewWithTag(100) as! UILabel
                            lab.text = self.vacationLayout.content + "小时"
                        }else if unit == "2"{
                            let lab = self.vacationLayout.viewWithTag(100) as! UILabel
                            lab.text = self.vacationLayout.content + "半天"
                        }else if unit == "3"{
                            let lab = self.vacationLayout.viewWithTag(100) as! UILabel
                            lab.text = self.vacationLayout.content + "天"
                        }
                    }
                }
                
        }) { (error) in
            
        }
    }
    //判断是否可以设置无效
    
    fileprivate func loadUseless() {
        let userId = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getOutWorkApprovalStatus",
            type: .get,
            param: ["emyeId":userId],
            successCallBack: { (result) in
             //  let panduan = result["data"]["needApproval"].boolValue
                if result["data"]["needApproval"].boolValue{
                    //无标记
                }else{
                    //有标记
//                    let locationLayout = TGLinearLayout(.horz)
//                    locationLayout.tg_width.equal(kWidth)
//                    locationLayout.tg_height.equal(.wrap)
//                    locationLayout.addSubview(self.uselessView)
//                    self.rootLayout.addSubview(locationLayout)
                    self.uselessView.addSubview(self.uselessBut)
                    self.viewHeight += AutoGetHeight(height: 55)
                    self.uselessBut.isHidden = false
                    self.view.addSubview(self.uselessView)
                }
        }) { (error) in
            
        }
    }
    
    
    //从抄送 或者 我已审批  或者 等待我审批进入
    // MARK:request
    fileprivate func loadDatas(urlStr:String,type:String) {
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: urlStr,
                                   type: .get,
                                   param: ["emyeId":userID,
                                           "businessApplyId":self.businessApplyId,
                                           "type":type],
                                   successCallBack: { (result) in
                                    
                                    guard let model = NCQApprovelDetailModel(jsonData: result["data"]) else {
                                        return
                                    }
                                    
                                    self.approvalBusinessId = model.approvalBusinessId
                                    self.businessCode = model.businessCode
                                   
                                  //  if model.myApprovalResult == "审批中"  {
                                      if model.applyStatusCode == "0"  {
                                       // self.view.addSubview(self.bottomView)
                                        
                                        let titleArr = ["同意","驳回","转交"]
                                        for i in 0..<titleArr.count{
                                            let btn = UIButton.init(type: .custom)
                                            btn.frame = CGRect.init(x: kWidth/CGFloat(titleArr.count) * CGFloat(i), y: kHeight - AutoGetHeight(height: 49) - CGFloat(SafeAreaBottomHeight), width: kWidth/CGFloat(titleArr.count), height: AutoGetHeight(height: 49)+CGFloat(SafeAreaBottomHeight))
                                            btn.setTitle(titleArr[i], for: .normal)
                                            btn.setTitleColor(kLightBlueColor, for: .normal)
                                            btn.backgroundColor = UIColor.white
                                            btn.tag = 10086 + i
                                            btn.addTarget(self, action: #selector(self.deciedeClick(btn:)), for: .touchUpInside)
                                            let line = UIView(frame:  CGRect(x: 0, y: 0, width: btn.width, height: 0.7))
                                            line.backgroundColor = kProjectBgColor
                                            btn.addSubview(line)
//                                            self.bottomView.addSubview(btn)
//                                           self.view.bringSubview(toFront: self.bottomView)
                                            self.view.addSubview(btn)
                                            self.view.bringSubview(toFront: btn)
                                        }
  
                                    }else{
                                        if self.businessCode == "B_WC" && self.isFromCopyToMe == false{
                                            self.loadUseless()
                                        }else{
                                            
                                        }
                                    }
                                    
                                    
                                    //审批进度列表
                                    var approveArr = [NCQApprovelDetailModel]()
                                    for copyJson in model.approverList{
                                        let copyModel = NCQApprovelDetailModel(jsonData: copyJson)
                                        approveArr.append(copyModel!)
                                    }
                                    
                                    self.approveListArray = approveArr
                                    
                                    
                                    //加载头部
                                    
                                    let headLayout = CQApprovelDetailHeaderLayout.init(orientation: .horz, name: model.submitTime, type: "", title: model.realName, prompt: "", require: false, content: "", imageUrl: model.headImage,statusStr:model.departmentName + " " + model.positionName)
                                    self.rootLayout.addSubview(headLayout)
                                    self.viewHeight += AutoGetHeight(height: 70)
                                    DLog(self.viewHeight)
                                    
                                    
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
                                    
                                    
                                    //解析派车表单数据
                                    
                                    
                                    //生成派车界面
                                    if model.businessCode == "B_CL"{
                                        self.title = "我的派车"
                                        let resultFormDict = dataArray[0] as! NSDictionary
                                        self.carDic = resultFormDict
                                        
                                        let desLayout = CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "目的地", prompt: "", require: false, content: dataModel.destination)
                                        self.rootLayout.addSubview(desLayout)
                                        self.viewHeight += desLayout.viewHeight
                                        DLog(self.viewHeight)
                                        
                                        let remarkLayout = CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "事由", prompt: "", require: false, content: dataModel.applyReason)
                                        self.rootLayout.addSubview(remarkLayout)
                                        self.viewHeight += remarkLayout.viewHeight
                                        DLog(self.viewHeight)
                                        
                                        let startLayout = CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "开始时间", prompt: "", require: false, content: dataModel.startDate)
                                        self.rootLayout.addSubview(startLayout)
                                        self.viewHeight += startLayout.viewHeight
                                        DLog(self.viewHeight)
                                        
                                        let endLayout = CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "结束时间", prompt: "", require: false, content: dataModel.endDate)
                                        self.rootLayout.addSubview(endLayout)
                                        self.viewHeight += endLayout.viewHeight
                                        DLog(self.viewHeight)
                                        
                                        var carType = ""
                                        if dataModel.carType == "1"{
                                            carType = "商务车"
                                        }else if dataModel.carType == "2"{
                                            carType = "货车"
                                        }else if dataModel.carType == "3"{
                                            carType = "客车"
                                        }
                                        let carTypeLayout = CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "车辆类型", prompt: "", require: false, content: carType)
                                        self.rootLayout.addSubview(carTypeLayout)
                                        self.viewHeight += carTypeLayout.viewHeight
                                        DLog(self.viewHeight)
                                        
                                        guard let pbulicCarModel = NCQApprovelDetailModel.init(jsonData: dataModel.pbulicCar) else {
                                            return
                                        }
                                        let carLayout = CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "车辆", prompt: "", require: false, content: pbulicCarModel.name)
                                        self.rootLayout.addSubview(carLayout)
                                        self.viewHeight += carLayout.viewHeight
                                        DLog(self.viewHeight)
                                    }else if model.businessCode == "B_HYS"{ //生成会议室界面
                                        self.title = "我的会议室"
                                        let resultFormDict = dataArray[0] as! NSDictionary
                                        self.meetingDic = resultFormDict
                                        
                                        let titleLayout = CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "主题", prompt: "", require: false, content: dataModel.meetingTitle)
                                        self.rootLayout.addSubview(titleLayout)
                                        self.viewHeight += titleLayout.viewHeight
                                        DLog(self.viewHeight)
                                        
                                        let remarkLayout = CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "概要", prompt: "", require: false, content: dataModel.outLine)
                                        self.rootLayout.addSubview(remarkLayout)
                                        self.viewHeight += remarkLayout.viewHeight
                                        DLog(self.viewHeight)
                                        
                                        let startLayout = CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "开始时间", prompt: "", require: false, content: dataModel.startDate)
                                        self.rootLayout.addSubview(startLayout)
                                        self.viewHeight += startLayout.viewHeight
                                        DLog(self.viewHeight)
                                        
                                        let endLayout = CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "结束时间", prompt: "", require: false, content: dataModel.endDate)
                                        self.rootLayout.addSubview(endLayout)
                                        self.viewHeight += endLayout.viewHeight
                                        DLog(self.viewHeight)
                                        
                                        guard let roomModel = NCQApprovelDetailModel.init(jsonData: dataModel.meetingRoom) else {
                                            return
                                        }
                                        let roomLayout = CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "会议室", prompt: "", require: false, content: roomModel.name)
                                        self.rootLayout.addSubview(roomLayout)
                                        self.viewHeight += roomLayout.viewHeight
                                        DLog(self.viewHeight)
                                    }else if model.businessCode == "B_WCTQXB"{
                                        //self.title = "外出提前下班"
                                        let resultFormDict = dataArray[0] as! NSDictionary
                                        self.workOutDic = resultFormDict
                                        
                                        let titleLayout = CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "提前下班理由", prompt: "", require: false, content: dataModel.outReason)
                                        self.rootLayout.addSubview(titleLayout)
                                        self.viewHeight += titleLayout.viewHeight
                                        DLog(self.viewHeight)
                                        
                                        let remarkLayout = CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "外出地址", prompt: "", require: false, content: dataModel.addressRemark)
                                        self.rootLayout.addSubview(remarkLayout)
                                        self.viewHeight += remarkLayout.viewHeight
                                        DLog(self.viewHeight)
                                        
                                    }
                                    
                                    
                                    
                                    //解析表单
                                    let formContentStr = model.formContent
                                    if !formContentStr.isEmpty{
                                        let formContentData = formContentStr.data(using: String.Encoding.utf8)!
                                        guard let array = JSON(formContentData).arrayObject as? [[String: AnyObject]] else {
                                            return
                                        }
                                        
                                        for i in 0..<array.count{
                                            let arr = array[i]
                                            let dic = arr["widget"]
                                            let jsonStr = JSON.init(dic!)
                                            //                        DLog(dic)
                                            guard let contentModel = NCQApprovelDetailModel.init(jsonData: jsonStr) else {
                                                return
                                            }
                                            
                                            var subWidgetArray = [NCQApprovelDetailModel]()
                                            for modalJson in contentModel.subWidget {
                                                guard let modal = NCQApprovelDetailModel(jsonData: modalJson) else {
                                                    return
                                                }
                                                subWidgetArray.append(modal)
                                            }
                                            
                                        
                                            for subModel in subWidgetArray{
                                                if subModel.type == "select"{
                                                    if subModel.name == "vacationType"{
                                                        let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.vacationType)
                                                        self.vacationType = dataModel.vacationType
                                                        self.rootLayout.addSubview(layout)
                                                        self.viewHeight += layout.viewHeight
                                                        DLog(self.viewHeight)
                                                    }
                                                }else if subModel.type == "date"{
                                                    if subModel.name == "startTime"{
                                                        if contentModel.type == "business"{
                                                            let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: oneBusinessModel.startTime)
                                                            self.rootLayout.addSubview(layout)
                                                            self.viewHeight += layout.viewHeight
                                                        }else {
                                                            let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.startTime)
                                                            self.rootLayout.addSubview(layout)
                                                            self.viewHeight += layout.viewHeight
                                                        }
                                                        
                                                        DLog(self.viewHeight)
                                                    }else if subModel.name == "endTime"{
                                                        if contentModel.type == "business"{
                                                            let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: oneBusinessModel.endTime)
                                                            self.rootLayout.addSubview(layout)
                                                            self.viewHeight += layout.viewHeight
                                                        }else{
                                                            if result["data"]["isShowEndTime"].boolValue == true{
                                                                let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.endTime)
                                                                self.rootLayout.addSubview(layout)
                                                                self.viewHeight += layout.viewHeight
                                                            }else{
                                                                let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: "")
                                                                self.rootLayout.addSubview(layout)
                                                                self.viewHeight += layout.viewHeight
                                                            }
                                                            
                                                        }
                                                        DLog(self.viewHeight)
                                                    }else if subModel.name == "modifyTime"{
                                                        let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.modifyTime)
                                                        self.rootLayout.addSubview(layout)
                                                        self.viewHeight += layout.viewHeight
                                                        DLog(self.viewHeight)
                                                    }
                                                }else if subModel.type == "duration"{
                                                    if subModel.name == "duration"{
                                                        if contentModel.type == "business"{
                                                            let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: oneBusinessModel.duration + "天")
                                                            self.rootLayout.addSubview(layout)
                                                            self.viewHeight += layout.viewHeight
                                                        }else if contentModel.type == "leave"{
                                                            self.getLeaveTypeRequest()
                                                            self.vacationLayout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.duration)
                                                            self.rootLayout.addSubview(self.vacationLayout)
                                                            self.viewHeight += self.vacationLayout.viewHeight
                                                        }else if contentModel.type == "outWork" || contentModel.type == "overtime"{
                                                            
                                                            if contentModel.type == "outWork" {
                                                    
                                                                if result["data"]["isShowEndTime"].boolValue == true{
                                                                    
                                                                    let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.duration + "小时")
                                                                    self.rootLayout.addSubview(layout)
                                                                    self.viewHeight += layout.viewHeight
                                                                    
                                                                    
                                                                }else{
                                                                    let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: "")
                                                                    self.rootLayout.addSubview(layout)
                                                                    self.viewHeight += layout.viewHeight
                                                                }
                                                                
                                                            }else{
                                                                let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.duration + "小时")
                                                                self.rootLayout.addSubview(layout)
                                                                self.viewHeight += layout.viewHeight
                                                            }
                                                            
                                                            
                                                           
                                                        }
                                                        
                                                        DLog(self.viewHeight)
                                                    }
                                                }else if subModel.type == "text"{
                                                    if subModel.name == "leaveReason"{
                                                        let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.leaveReason)
                                                        self.rootLayout.addSubview(layout)
                                                        self.viewHeight += layout.viewHeight
                                                        DLog(self.viewHeight)
                                                    }else if subModel.name == "modifyReason"{
                                                        let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.modifyReason)
                                                        self.rootLayout.addSubview(layout)
                                                        self.viewHeight += layout.viewHeight
                                                        DLog(self.viewHeight)
                                                    }else if subModel.name == "travelReason"{
                                                        let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.travelReason)
                                                        self.rootLayout.addSubview(layout)
                                                        self.viewHeight += layout.viewHeight
                                                        DLog(self.viewHeight)
                                                    }else if subModel.name == "remark"{
                                                        let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.remark)
                                                        self.rootLayout.addSubview(layout)
                                                        self.viewHeight += layout.viewHeight
                                                        DLog(self.viewHeight)
                                                    }
                                                }else if subModel.type == "person"{
                                                    if subModel.name == "extraPerson"{
                                                        guard let personModel = NCQApprovelDetailModel.init(jsonData: dataModel.extraPerson) else {
                                                            return
                                                        }
                                                        let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: personModel.name)
                                                        self.rootLayout.addSubview(layout)
                                                        self.viewHeight += layout.viewHeight
                                                        DLog(self.viewHeight)
                                                    }else if subModel.name == "togetherPerson"{
                                                        let personArr = dataModel.togetherPerson
                                                        var personModelArray = [CQDepartMentUserListModel]()
                                                        for modelJson in personArr{
                                                            guard let modal = CQDepartMentUserListModel(jsonData: modelJson) else {
                                                                return
                                                            }
                                                            personModelArray.append(modal)
                                                        }
                                                        let layout = CQShowPersonLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required,dataArray:personModelArray,isDetail:true)
                                                        self.rootLayout.addSubview(layout)
                                                        self.viewHeight += layout.collectionHeight
                                                        DLog(self.viewHeight)
                                                    }
                                                }else if subModel.type == "sub" {
                                                    if subModel.name == "sub"{
                                                        if contentModel.type == "business"{
                                                            let layout = CQSubLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title + "\(bussinessDetailArray.count)")
                                                            self.rootLayout.addSubview(layout)
                                                            self.viewHeight += AutoGetHeight(height: 20)
                                                        }else{
                                                            let layout = CQSubLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title )
                                                            self.rootLayout.addSubview(layout)
                                                            self.viewHeight += AutoGetHeight(height: 20)
                                                        }
                                                        
                                                        DLog(self.viewHeight)
                                                    }
                                                }else if subModel.type == "checkbox"{
                                                    if subModel.name == "isBack"{
                                                        if contentModel.type == "business"{
                                                            var str = ""
                                                            if oneBusinessModel.isBack{
                                                                str = "往返"
                                                            }else{
                                                                str = "单程"
                                                            }
                                                            let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content:str)
                                                            self.rootLayout.addSubview(layout)
                                                            self.viewHeight += layout.viewHeight
                                                        }else{
                                                            var str = ""
                                                            if dataModel.isBack{
                                                                str = "往返"
                                                            }else{
                                                                str = "单程"
                                                            }
                                                            let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: str)
                                                            self.rootLayout.addSubview(layout)
                                                            self.viewHeight += layout.viewHeight
                                                        }
                                                        
                                                        DLog(self.viewHeight)
                                                    }else if subModel.name == "transport"{
                                                        
                                                        for modalJson in subModel.dataSource {
                                                            guard let modal = NCQApprovelDetailModel(jsonData: modalJson) else {
                                                                return
                                                            }
                                                            self.traficArray.append(modal)
                                                        }
                                                        
                                                        let layout = CQTranSportLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: oneBusinessModel.transport,traficArray:self.traficArray)
                                                        self.rootLayout.addSubview(layout)
                                                        self.viewHeight += layout.viewHeight
                                                    }
                                                }else if subModel.type == "area"{
                                                    if subModel.name == "fromCity"{
                                                        if contentModel.type == "business"{
                                                            let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: oneBusinessModel.fromCity)
                                                            self.rootLayout.addSubview(layout)
                                                            self.viewHeight += layout.viewHeight
                                                        }else{
                                                            let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.fromCity)
                                                            self.rootLayout.addSubview(layout)
                                                            self.viewHeight += layout.viewHeight
                                                        }
                                                        
                                                        DLog(self.viewHeight)
                                                    }else if subModel.name == "toCity"{
                                                        if contentModel.type == "business"{
                                                            let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: oneBusinessModel.toCity)
                                                            self.rootLayout.addSubview(layout)
                                                            self.viewHeight += layout.viewHeight
                                                        }else{
                                                            let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.toCity)
                                                            self.rootLayout.addSubview(layout)
                                                            self.viewHeight += layout.viewHeight
                                                        }
                                                        
                                                        DLog(self.viewHeight)
                                                    }
                                                }else if subModel.type == "formular"{
                                                    if subModel.name == "travelDays"{
                                                        let layout = CQApprovelContentLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, prompt: subModel.prompt, require: subModel.required, content: dataModel.travelDays + "天")
                                                        self.rootLayout.addSubview(layout)
                                                        self.viewHeight += layout.viewHeight
                                                        DLog(self.viewHeight)
                                                    }
                                                }else if subModel.type == "addDetail"{
                                                    if subModel.name == "addDetail"{
                                                        
                                                        bussinessDetailArray.removeFirst()
                                                        for addModel in bussinessDetailArray{
                                                            
                                                            let layout = CQBussinessAddLayout.init(orientation: .horz, name: subModel.name, type: subModel.type, title: subModel.title, transport: addModel.transport, isBack: addModel.isBack, fromCity: addModel.fromCity, toCity: addModel.toCity, startTime: addModel.startTime, endTime: addModel.endTime, duration: addModel.duration + "天",traficArray:self.traficArray)
                                                            self.rootLayout.addSubview(layout)
                                                            self.viewHeight += AutoGetHeight(height: 350)
                                                        }
                                                        
                                                        DLog(self.viewHeight)
                                                    }
                                                }
                                            }
                                            
                                            if contentModel.type == "person"{
                                                let personArr = dataJson[contentModel.name].arrayValue
                                                var personModelArray = [CQDepartMentUserListModel]()
                                                for modelJson in personArr{
                                                    guard let modal = CQDepartMentUserListModel(jsonData: modelJson) else {
                                                        return
                                                    }
                                                    personModelArray.append(modal)
                                                }
                                                let layout = CQShowPersonLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required,dataArray:personModelArray,isDetail:true)
                                                self.rootLayout.addSubview(layout)
                                                self.viewHeight += layout.collectionHeight
                                                DLog(self.viewHeight)
                                            }else if contentModel.type == "leave" || contentModel.type == "outWork" || contentModel.type == "business" || contentModel.type == "overtime" || contentModel.type == "modify"{
                                                
                                            }else if contentModel.type == "attach"{
                                                let personArr = dataJson[contentModel.name].arrayValue
                                                var personModelArray = [NCQApprovelDetailModel]()
                                                for modelJson in personArr{
                                                    guard let modal = NCQApprovelDetailModel(jsonData: modelJson) else {
                                                        return
                                                    }
                                                    personModelArray.append(modal)
                                                }
                                                let layout = CQHasPornLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required,dataArray:personModelArray)
                                                layout.goDelegate = self
                                                let nowHeight = AutoGetHeight(height: 55) * CGFloat(personModelArray.count + 1)
                                                self.viewHeight += nowHeight
                                                self.rootLayout.addSubview(layout)
                                                DLog(self.viewHeight)
                                            }else if contentModel.type == "department"{
                                                let personArr = dataJson[contentModel.name].arrayValue
                                                var personModelArray = [CQAddressBookModel]()
                                                for modelJson in personArr{
                                                    guard let modal = CQAddressBookModel(jsonData: modelJson) else {
                                                        return
                                                    }
                                                    personModelArray.append(modal)
                                                }
                                                let layout = CQDepartmentLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, dataArray: personModelArray, single: contentModel.single,isDetail:true)
                                                let nowHeight = AutoGetHeight(height: 55) + layout.collectionHeight
                                                self.viewHeight += nowHeight
                                                self.rootLayout.addSubview(layout)
                                                DLog(self.viewHeight)
                                            }else if contentModel.type == "sub"{
                                                let layout = CQSubLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title )
                                                self.rootLayout.addSubview(layout)
                                                self.viewHeight += AutoGetHeight(height: 20)
                                            }else{
                                                if contentModel.type == "checkbox" {
                                                    var curTitle = ""
                                                    for modelJson in contentModel.dataSource{
                                                        let model = NCQApprovelDetailModel.init(jsonData: modelJson)
                                                        if dataJson[contentModel.name].stringValue == model!.value{
                                                            curTitle = model!.text
                                                        }
                                                    }
                                                    let layout = CQApprovelContentLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, content: curTitle)
                                                    self.rootLayout.addSubview(layout)
                                                    self.viewHeight += layout.viewHeight
                                                    DLog(self.viewHeight)
                                                }else{
                                                    let layout = CQApprovelContentLayout.init(orientation: .horz, name: contentModel.name, type: contentModel.type, title: contentModel.title, prompt: contentModel.prompt, require: contentModel.required, content: dataJson[contentModel.name].stringValue)
                                                    self.rootLayout.addSubview(layout)
                                                    self.viewHeight += layout.viewHeight
                                                    DLog(self.viewHeight)
                                                }
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                    self.rootLayout.addSubview(self.addGrayViewContentLayout(height: AutoGetHeight(height: 13)))
                                    self.viewHeight += AutoGetHeight(height: 13)
                                    for i in 0..<self.approveListArray.count{
                                        //我抄送给我的进
                                        if self.isFromCopyToMe{
                                            if 0 == i{
                                                let firModel = self.approveListArray[i]
                                                let layout = CQCopyToMeBeginLayout.init(orientation: .horz, realName: firModel.realName, headImage: firModel.headImage, approveTime: firModel.approveTime, approvalResultRemark: firModel.approvalResultRemark, approvalResult: firModel.approvalResult)
                                                self.rootLayout.addSubview(layout)
                                                self.viewHeight += AutoGetHeight(height: 55)
                                            }else{
                                                let firModel = self.approveListArray[i]
                                                let layout = CQApprovelCellLayout.init(orientation: .horz, realName: firModel.realName, headImage: firModel.headImage, approveTime: firModel.approveTime, approvalResultRemark: firModel.approvalResult, approvalResult: firModel.approvalResultRemark)
                                                self.rootLayout.addSubview(layout)
                                                self.viewHeight += AutoGetHeight(height: 55)
                                            }
                                        }else if self.isFromMeHasApprovel || self.isFromWaitApprovel{
                                            if 0 == i{
                                                let firModel = self.approveListArray[i]
                                                let layout = CQBeginApplyLayout.init(orientation: .horz, realName: firModel.realName, headImage: firModel.headImage, approveTime: /*firModel.approveTime*/ "", approvalResultRemark: firModel.approvalResultRemark, approvalResult: firModel.approvalResult)
                                                self.rootLayout.addSubview(layout)
                                                self.viewHeight += AutoGetHeight(height: 55)
                                            }else{
                                                let firModel = self.approveListArray[i]
                                                let layout = CQApprovelCellLayout.init(orientation: .horz, realName: firModel.realName, headImage: firModel.headImage, approveTime: firModel.approveTime, approvalResultRemark: firModel.approvalResult, approvalResult: firModel.approvalResultRemark)
                                                if self.isFromWaitApprovel && (i == (self.approveListArray.count - 1)){
                                                    let lab = layout.viewWithTag(1002) as! UILabel
                                                    lab.textColor = kGoldYellowColor
                                                    lab.adjustsFontSizeToFitWidth = true
                                                }
                                                self.rootLayout.addSubview(layout)
                                                self.viewHeight += AutoGetHeight(height: 55)
                                            }
                                            
                                           
                                        }
                                       
                                    }
                                    //
//                                    if self.isFromMeHasApprovel && self.businessCode == "B_WCTQXB"{
//                                        self.loadUseless()
//                                    }

                                    self.headView.frame =  CGRect.init(x: 0, y: 0, width: kWidth, height: self.viewHeight)
                                    self.table.tableHeaderView = self.headView
                                    self.table.reloadData()
        }) { (error) in
            
        }
    }
        
    
    
    //撤销申请
    func cancelApplyRequest() {
        let alertVC = UIAlertController.init(title: "", message: "你确定撤销么？", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction.init(title: "确定", style: .default) { (action) in
            STNetworkTools.requestData(URLString:"\(baseUrl)/approval/cancelApply" ,
                type: .get,
                param: ["businessApplyId":self.businessApplyId],
                successCallBack: { (result) in
                    
                    SVProgressHUD.showSuccess(withStatus: "撤销成功")
                    NotificationCenter.default.post(name: NSNotification.Name.init("refreshMeApplyUI"), object: nil)
                    self.navigationController?.popViewController(animated: true)
            }) { (error) in
                
            }
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    //审批
    func approvalRequest(approvalResult:Bool,remark:String) {
        let userID = STUserTool.account().userID
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/approveDoing" ,
            type: .get,
            param: ["emyeId":userID,
                    "businessApplyId":self.businessApplyId,
                    "approvalResult":approvalResult,
                    "approvalRemark":remark],
            successCallBack: { (result) in
                SVProgressHUD.showSuccess(withStatus: "审批成功")
                NotificationCenter.default.post(name: NSNotification.Name.init("refreshNotAgreeVC"), object: nil)
                if self.isFromApp{
                    self.dismiss(animated: true, completion: nil)
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
        }) { (error) in
            
        }
    }
    
    
    //销假
    func cancelLeaveApply() {
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/cancelLeaveApply" ,
            type: .get,
            param: ["businessApplyId":self.businessApplyId],
            successCallBack: { (result) in
                SVProgressHUD.showSuccess(withStatus: "销假成功")
                NotificationCenter.default.post(name: NSNotification.Name.init("refreshNotAgreeVC"), object: nil)
                for v in (self.navigationController?.viewControllers)!{
                    if v is CQMeSubmitVC{
                        NotificationCenter.default.post(name: NSNotification.Name.init("refreshMeApplyUI"), object: nil)
                        self.navigationController?.popViewController(animated: true)
                        self.navigationController?.popToViewController(v, animated: true)
                    }
                }
        }) { (error) in
            
        }
    }
    
   
}


//layout控件
extension NCQApproelDetailVC{
    
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

//MARK 界面代理
extension NCQApproelDetailVC:CQApprovalRemarkDelegate{
    func getApprovelDoing(remark: String,isAgree:Bool) {
        self.remarkView?.removeFromSuperview()
        if (self.remarkView?.isTurnSomeOne)!{
//            let vc = AddressBookVC.init()
//            vc.toType = .fromTurnSomeOne
            
            let vc = QRAddressBookVC.init()
            vc.toType = .fromContact
            vc.titleStr = "选择转交人"
            vc.remark = remark
            vc.businessApplyId = self.businessApplyId
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.approvalRequest(approvalResult: isAgree,remark:remark)
        }
    }
}


//上传文件点击代理
extension NCQApproelDetailVC:CQHasPornDelegate{
    func goToWebDetail(model: NCQApprovelDetailModel) {
        let vc = CQWebVC()
        let url = imagePreUrl + model.flieUrl
//        let url = "http://192.168.1.33:9094/asst_52/business/file/20181119/3dc67813-9a20-42e6-b8e0-39ffcfb56464.mp4"
        vc.urlStr = url
        vc.titleStr = model.name
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

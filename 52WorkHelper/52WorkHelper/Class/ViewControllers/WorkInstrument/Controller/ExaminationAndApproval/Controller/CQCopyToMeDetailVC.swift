//
//  CQCopyToMeDetailVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/20.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

/// 
enum ToApplyDetailType {
    case copyToMe
    case notAgree
    case hasAgree
    case fromApply
}

class CQCopyToMeDetailVC: SuperVC {

    
    
    weak var rootLayout :TGLinearLayout!
    var businessApplyId = ""
    var dataArray:CQCopyToMeDetailModel?
    var approveListArray = [CQCopyToMeApproverlistModel]()
    var headerModel:CQCopyToMeApproverlistModel?
    var toType:ToApplyDetailType?
    var selfType = ""
    var remarkView:CQApprovalRemarkView?
    var startTime = "" //开始时间
    var endTime = "" //结束时间
    var vocationType:NSNumber? //请假类型
    var businessDetailCount = 0
    var isFromApp = false
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight))
        headView.backgroundColor = UIColor.white
        return headView
    }()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y:0, width: kWidth, height: kHeight ), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        table.backgroundColor = kProjectBgColor
//        table.delegate = self
//        table.dataSource = self
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
        
        //
        if self.toType == .notAgree {
            let titleArr = ["同意","驳回","转交"]
            for i in 0..<titleArr.count{
                let btn = UIButton.init(type: .custom)
                btn.frame = CGRect.init(x: kWidth/CGFloat(titleArr.count) * CGFloat(i), y: kHeight  - AutoGetHeight(height: 49) - CGFloat(SafeAreaBottomHeight), width: kWidth/CGFloat(titleArr.count), height: AutoGetHeight(height: 49))
                btn.setTitle(titleArr[i], for: .normal)
                btn.setTitleColor(kLightBlueColor, for: .normal)
                btn.backgroundColor = UIColor.white
                btn.tag = 10086 + i
                btn.addTarget(self, action: #selector(deciedeClick(btn:)), for: .touchUpInside)
                self.headView.addSubview(btn)
                self.headView.bringSubview(toFront: btn)
            }
            let urlStr = "\(baseUrl)/approval/getApprovalDetail"
            self.setUpRefresh(urlStr: urlStr,type: "2")
        }else if self.toType == .hasAgree{
            let urlStr = "\(baseUrl)/approval/getApprovalDetail"
            self.table.frame =  CGRect.init(x: 0, y:0, width: kWidth, height: kHeight)
            self.setUpRefresh(urlStr: urlStr,type: "1")
        }else if self.toType == .copyToMe{
            let urlStr = "\(baseUrl)/approval/getMyCopyInfo"
            self.table.frame =  CGRect.init(x: 0, y:0, width: kWidth, height: kHeight)
            self.setUpRefresh(urlStr: urlStr,type:"")
        }else if self.toType == .fromApply{
            let urlStr = "\(baseUrl)/approval/getMyApplyDetail"
            self.table.frame =  CGRect.init(x: 0, y:0, width: kWidth, height: kHeight)
            self.setUpRefresh(urlStr: urlStr,type:"")
        }
        
        self.headView.tg_height.equal(.wrap)
        let rootLayout = TGLinearLayout(.vert)
        rootLayout.tg_height.equal(.wrap)
        rootLayout.tg_width.equal(.wrap)
        //        rootLayout.tg_padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        rootLayout.tg_zeroPadding = false   //这个属性设置为false时表示当布局视图的尺寸是wrap也就是由子视图决定时并且在没有任何子视图是不会参与布局视图高度的计算的。您可以在这个DEMO的测试中将所有子视图都删除掉，看看效果，然后注释掉这句代码看看效果。
        //        rootLayout.tg_vspace = 5
        self.headView.addSubview(rootLayout)
        self.rootLayout = rootLayout
        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isFromApp {
            self.navigationItem.leftBarButtonItem = self.barBackButton()
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

}

extension CQCopyToMeDetailVC:CQApprovalRemarkDelegate{
    func getApprovelDoing(remark: String,isAgree:Bool) {
        self.remarkView?.removeFromSuperview()
        if (self.remarkView?.isTurnSomeOne)!{
            let vc = AddressBookVC.init()
            vc.toType = .fromTurnSomeOne
//            let vc = QRAddressBookVC.init()
//            vc.toType = .fromContact
            vc.remark = remark
            vc.businessApplyId = self.businessApplyId
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.approvalRequest(approvalResult: isAgree,remark:remark)
        }
        
//        NotificationCenter.default.post(name: NSNotification.Name.init("refreshIndexRowData"), object: nil)
    }
}

extension CQCopyToMeDetailVC{
    fileprivate func setUpRefresh(urlStr:String,type:String) {
        // MARK:header
//        let STHeader = CQRefreshHeader {
            self.loadDatas(urlStr: urlStr,type:type)
//        }
        
//        self.table.mj_header = STHeader
//        self.table.mj_header.beginRefreshing()
    }
    // MARK:request
    fileprivate func loadDatas(urlStr:String,type:String) {
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: urlStr,
            type: .get,
            param: ["emyeId":userID,
                    "businessApplyId":self.businessApplyId,
                    "type":type],
            successCallBack: { (result) in
                guard let model = CQCopyToMeDetailModel(jsonData: result["data"]) else {
                    return
                }
                
              
                
                self.rootLayout.addSubview(self.addIconImageLayout(image: model.headImage, tag: 3333))
                if self.toType == .fromApply {
                    self.rootLayout.addSubview(self.addNameLabLayout(name: STUserTool.account().realName, tag: 100))
                }else {
                    self.rootLayout.addSubview(self.addNameLabLayout(name: model.realName, tag: 100))
                }
                
                self.rootLayout.addSubview(self.addjobLabLayout(job: model.departmentName + " " + model.positionName, tag: 101))
                self.rootLayout.addSubview(self.addTimeLayout(time: model.submitTime, tag: 102))
                self.rootLayout.addSubview(self.addLineLayout())
                
                let str = model.formContent
                let resultStr = model.formData
                let resultDic = getDictionaryFromJSONString(jsonString: resultStr)
                DLog(resultDic)
                let resultArr = resultDic["businessApplyDatas"] as! NSArray
                DLog(resultArr)
                
                
                
                if model.businessCode == "B_CL"{
                    
                    self.title = "审批流程"
                    
                    
                    let resultFormDict = resultArr[0] as! NSDictionary
                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 320, leftTitle:"目的地", rightTitle:resultFormDict["destination"] as! String))
                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 321, leftTitle:"事由", rightTitle:resultFormDict["applyReason"] as! String))
                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 322, leftTitle:"开始时间", rightTitle:resultFormDict["startDate"] as! String))
                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 323, leftTitle:"结束时间", rightTitle:resultFormDict["endDate"] as! String))
                    var carType = ""
                    if resultFormDict["carType"] as! NSNumber == 1{
                        carType = "商务车"
                    }else if resultFormDict["carType"] as! NSNumber == 2{
                        carType = "货车"
                    }else if resultFormDict["carType"] as! NSNumber == 3{
                        carType = "客车"
                    }
                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 324, leftTitle:"车辆类型", rightTitle:carType))
                    let arr = resultFormDict["pbulicCar"] as! NSDictionary
                    let carNum = arr["name"] as! String
                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 325, leftTitle:"车辆", rightTitle:carNum))
                    self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 214))
                }else if model.businessCode == "B_HYS"{
                    self.title = "审批流程"
                    let resultFormDict = resultArr[0] as! NSDictionary
                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 326, leftTitle:"主题", rightTitle:resultFormDict["meetingTitle"] as! String))
                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 327, leftTitle:"概要", rightTitle:resultFormDict["outLine"] as! String))
                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 328, leftTitle:"开始时间", rightTitle:resultFormDict["startDate"] as! String))
                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 329, leftTitle:"结束时间", rightTitle:resultFormDict["endDate"] as! String))
                    let arr = resultFormDict["meetingRoom"] as! NSDictionary
                    let room = arr["name"] as! String
                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 330, leftTitle:"会议室", rightTitle:room))
                    self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 204))
                }
                
                
                //审批进度列表
                var approveArr = [CQCopyToMeApproverlistModel]()
                for copyJson in model.approverList{
                    let copyModel = CQCopyToMeApproverlistModel(jsonData: copyJson)
                    approveArr.append(copyModel!)
                }
               
                self.approveListArray = approveArr

                
                
                if !str.isEmpty {
                    let formData:Data = str.data(using: String.Encoding.utf8)!
                    guard let array = JSON(formData).arrayObject as? [[String: AnyObject]] else {
                        return
                    }
                    
                    
                    
                    for i in 0..<array.count{
                        let arr = array[i]
                        let dic = arr["widget"]
                        
                        
                        if 0 == i{
                            
                            self.selfType = (dic!["type"] as? String)!
                            if self.selfType == "leave" || self.selfType == "outWork" || self.selfType == "business" || self.selfType == "overtime" || self.selfType == "modify"{
                                let formArr = dic!["subWidget"]
                                let a = formArr as! NSArray
                                let resultFormDict = resultArr[i] as! NSDictionary
                                var businessDetail:NSMutableArray = NSMutableArray.init()
                                if self.selfType == "business"{
                                    businessDetail = resultFormDict["businessDetail"] as! NSMutableArray
                                }
                                
                                if self.selfType == "leave"{
                                    self.vocationType = ((resultFormDict["vacationType"] as! Int) as NSNumber)
                                    self.startTime = resultFormDict["startTime"] as! String
                                    self.endTime = resultFormDict["endTime"] as! String
                                    
                                }
                                
                                if self.toType == .copyToMe{
                                    
                                }else{
                                    self.title = "审批流程"
                                }
                                
                                if a.count > 0{
                                    
                                    for forDict in a {
                                        let formDict = forDict as! NSDictionary
                                        let formName = formDict["name"] as! String
                                        
                                        if formName == "vacationType"  {
                                            self.rootLayout.addSubview(self.addCellContentLayout(tag: 300, leftTitle: formDict["title"] as! String, rightTitle: ""))
                                            self.getLeaveTypeRequest(title:formDict["title"] as! String,time:(resultFormDict["vacationType"] as! NSNumber))
                                        }else if formName == "startTime"  {
                                            if self.selfType == "business"{
                                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 302, leftTitle: formDict["title"] as! String, rightTitle: (businessDetail[0] as! NSDictionary)["startTime"] as! String))
                                            }else{
                                                
                                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 302, leftTitle: formDict["title"] as! String, rightTitle: resultFormDict["startTime"] as! String ))
                                            }
                                            
                                        }else if formName == "endTime"  {
                                            if self.selfType == "business"{
                                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 303, leftTitle: formDict["title"] as! String, rightTitle: (businessDetail[0] as! NSDictionary)["endTime"] as! String))
                                            }else{
                                                
                                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 303, leftTitle: formDict["title"] as! String, rightTitle: resultFormDict["endTime"] as! String ))
                                            }
                                            
                                        }else if formName == "duration"  {
                                            if self.selfType == "leave"{
                                                
                                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 304, leftTitle:formDict["title"] as! String, rightTitle:resultFormDict["duration"] as! String + model.vacationUnitDesc ))
                                            }else{
                                                if self.selfType == "business"{
                                                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 304, leftTitle: formDict["title"] as! String, rightTitle:(businessDetail[0] as! NSDictionary)["duration"] as! String + (formDict["unit"] as! String)))
                                                }else{
                                                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 304, leftTitle: formDict["title"] as! String, rightTitle:String.init(format: "%@", resultFormDict["duration"] as! String + (formDict["unit"] as! String))))
                                                }
                                            }
                                            
                                            
                                        }else if formName == "leaveReason"  {
                                            self.rootLayout.addSubview(self.addCellContentNumberLinesLayout(tag: 304, leftTitle: formDict["title"] as! String, rightTitle: resultFormDict["leaveReason"] as! String ))
                                        }else if formName == "extraPerson"  {
                                            self.rootLayout.addSubview(self.addCellContentLayout(tag: 305, leftTitle: formDict["title"] as! String, rightTitle: (resultFormDict["extraPerson"] as! NSDictionary)["name"] as! String ))
                                        }else if formName == "travelReason"  {
                                            self.rootLayout.addSubview(self.addCellContentLayout(tag: 306, leftTitle: formDict["title"] as! String, rightTitle: resultFormDict["travelReason"] as! String  ))
                                        }else if formName == "transport"  {
                                            
                                            if self.selfType == "business"{
                                                var tranStr = ""
                                                if ((businessDetail[0] as! NSDictionary)["transport"] as! String) == "plan"{
                                                    tranStr = "飞机"
                                                }else if ((businessDetail[0] as! NSDictionary)["transport"] as! String) == "subway"{
                                                    tranStr = "货车"
                                                }else if ((businessDetail[0] as! NSDictionary)["transport"] as! String) == "bus"{
                                                    tranStr = "汽车"
                                                }else{
                                                    tranStr = "其他"
                                                }
                                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 313, leftTitle:formDict["title"] as! String, rightTitle:tranStr))
                                            }
                                        }else if formName == "isBack"  {
                                            var backLab = ""
                                            if self.selfType == "business"{
                                                if (businessDetail[0] as! NSDictionary)["isBack"] as! Bool{
                                                    backLab = "往返"
                                                }else{
                                                    backLab = "单程"
                                                }
                                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 314, leftTitle:formDict["title"] as! String, rightTitle:backLab))
                                            }
                                        }else if formName == "fromCity"  {
                                            if self.selfType == "business"{
                                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 315, leftTitle:formDict["title"] as! String, rightTitle:(businessDetail[0] as! NSDictionary)["fromCity"] as! String))
                                            }
                                        }else if formName == "toCity"  {
                                            if self.selfType == "business"{
                                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 316, leftTitle:formDict["title"] as! String, rightTitle:(businessDetail[0] as! NSDictionary)["toCity"] as! String))
                                            }
                                        }else if formName == "travelDays"  {
                                            if self.selfType == "business"{
                                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 317, leftTitle:formDict["title"] as! String, rightTitle:resultFormDict["travelDays"] as! String))
                                            }
                                        }else if formName == "remark"  {
                                            if resultFormDict["remark"] != nil{
                                                self.rootLayout.addSubview(self.addCellContentNumberLinesLayout(tag: 312, leftTitle: formDict["title"] as! String, rightTitle: resultFormDict["remark"] as! String))
                                            }
                                            
                                        }else if formName == "togetherPerson"  {
                                            let togetherArr = resultFormDict["togetherPerson"] as! NSArray
                                            var togetherPersonNameArr = [String]()
                                            for togetherDic in togetherArr{
                                                let tDic = togetherDic as! NSDictionary
                                                togetherPersonNameArr.append(tDic["name"] as! String)
                                            }
                                            var togetherPersonName = ""
                                            for i in 0..<togetherPersonNameArr.count{
                                                if 0 == i{
                                                    togetherPersonName = togetherPersonNameArr[i]
                                                }else{
                                                    togetherPersonName = togetherPersonName + "," + togetherPersonNameArr[i]
                                                }
                                            }
                                            
                                            self.rootLayout.addSubview(self.addCellContentNumberLinesLayout(tag: 313, leftTitle: formDict["title"] as! String, rightTitle:togetherPersonName ))
                                        }else if formName == "travelPerson"  {
                                            let togetherArr = resultFormDict["travelPerson"] as! NSArray
                                            var togetherPersonNameArr = [String]()
                                            for togetherDic in togetherArr{
                                                let tDic = togetherDic as! NSDictionary
                                                togetherPersonNameArr.append(tDic["name"] as! String)
                                            }
                                            var togetherPersonName = ""
                                            for name in togetherPersonNameArr{
                                                togetherPersonName = togetherPersonName + name
                                            }
                                            
                                            self.rootLayout.addSubview(self.addCellContentNumberLinesLayout(tag: 314, leftTitle: formDict["title"] as! String, rightTitle:togetherPersonName ))
                                        }
                                        else if formName == "modifyTime"  {
                                            self.rootLayout.addSubview(self.addCellContentNumberLinesLayout(tag: 316, leftTitle: formDict["title"] as! String, rightTitle: resultFormDict["modifyTime"] as! String ))
                                        }else if formName == "modifyReason"  {
                                            self.rootLayout.addSubview(self.addCellContentNumberLinesLayout(tag: 317, leftTitle: formDict["title"] as! String, rightTitle: resultFormDict["modifyReason"] as! String ))
                                        }else if formName == "sub" {
                                            self.rootLayout.addSubview(self.addGrayLabContentLayout(tag:318,title:formDict["title"] as! String + " 0"))
                                        }else if formName == "addDetail"{
                                            if businessDetail.count > 1 {
                                                businessDetail.removeObject(at: 0)
                                                self.businessDetailCount = businessDetail.count
                                                for i in 0..<businessDetail.count{
                                                    
                                                    self.rootLayout.addSubview(self.addGrayLabContentLayout(tag:332,title:"行程 " + "\(i + 1)"))
                                                    var tranStr = ""
                                                    if ((businessDetail[i] as! NSDictionary)["transport"] as! String) == "plan"{
                                                        tranStr = "飞机"
                                                    }else if ((businessDetail[i] as! NSDictionary)["transport"] as! String) == "subway"{
                                                        tranStr = "货车"
                                                    }else if ((businessDetail[i] as! NSDictionary)["transport"] as! String) == "bus"{
                                                        tranStr = "汽车"
                                                    }else{
                                                        tranStr = "其他"
                                                    }
                                                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 333, leftTitle:"交通工具", rightTitle:tranStr))
                                                    var isback = ""
                                                    if (businessDetail[i] as! NSDictionary)["isBack"] as! Bool{
                                                        isback = "往返"
                                                    }else{
                                                        isback = "单程"
                                                    }
                                                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 334, leftTitle:"单程往返", rightTitle:isback))
                                                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 335, leftTitle:"出发城市", rightTitle:(businessDetail[i] as! NSDictionary)["fromCity"] as! String))
                                                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 336, leftTitle:"目的城市", rightTitle:(businessDetail[i] as! NSDictionary)["toCity"] as! String))
                                                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 337, leftTitle: "开始时间", rightTitle: (businessDetail[i] as! NSDictionary)["startTime"] as! String))
                                                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 338, leftTitle: "结束时间", rightTitle: (businessDetail[i] as! NSDictionary)["endTime"] as! String))
                                                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 339, leftTitle: "时长(天)", rightTitle:(businessDetail[i] as! NSDictionary)["duration"] as! String + "天"))
                                                    
                                                }
                                                self.rootLayout.addSubview(self.addGrayLabContentLayout(tag: 340, title: ""))
                                                
                                            }
                                        }
                                        
                                    }
                                }
                            }
                            }
                            
                        let resultFormDict = resultArr[0] as! NSDictionary
                        if dic!["type"] as! String == "phnoeNum"  {
                            if resultFormDict["phnoeNum1"] != nil{
                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 331, leftTitle:dic!["title"] as! String , rightTitle:resultFormDict["phnoeNum1"] as! String ))
                            }else{
                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 331, leftTitle:dic!["title"] as! String , rightTitle:"" ))
                            }
                            
                        }else if dic!["type"] as! String == "numText"  {
                            self.rootLayout.addSubview(self.addCellContentLayout(tag: 332, leftTitle:dic!["title"] as! String , rightTitle:resultFormDict["numText0"] as! String ))
                        }else if dic!["type"] as! String == "person"  {
                            if resultFormDict["person3"] != nil {
                                if (resultFormDict["person3"] as! NSDictionary)["name"] != nil{
                                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 333, leftTitle:dic!["title"] as! String , rightTitle:"" ))
                                }else {
                                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 333, leftTitle:dic!["title"] as! String , rightTitle:""))
                                }
                                
                            }else{
                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 333, leftTitle:dic!["title"] as! String , rightTitle:""))
                            }
                            
                        }else if dic!["type"] as! String == "department"  {
                            if resultFormDict["department5"] != nil{
                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 334, leftTitle:dic!["title"] as! String , rightTitle:(resultFormDict["department5"] as! NSDictionary)["name"] as! String ))
                            }else{
                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 334, leftTitle:dic!["title"] as! String , rightTitle:""))
                            }
                            
                        }
                            //                                            else if dic!["name"] as! String == "sub6"  {
                            //                                                self.rootLayout.addSubview(self.addGrayLabContentLayout(tag:337,title: dic!["title"] as! String))
                            //                                            }
                        else if dic!["type"] as! String == "select"  {
                            let arr = dic!["dataSource"] as! NSArray
                            var str = ""
                            for i in 0..<arr.count{
                                let dataDic = arr[i] as! NSDictionary
                                if (resultFormDict["select7"] as! NSNumber) == (dataDic["value"] as! NSNumber){
                                    str = dataDic["text"] as! String
                                }
                            }
                            
                            self.rootLayout.addSubview(self.addCellContentLayout(tag: 335, leftTitle:dic!["title"] as! String , rightTitle:str))
                        }else if dic!["type"] as! String == "upperMoney"  {
                            if resultFormDict["upperMoney0"] != nil{
                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 336, leftTitle:dic!["title"] as! String , rightTitle:(resultFormDict["upperMoney0"] as! String )))
                            }else{
                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 336, leftTitle:dic!["title"] as! String , rightTitle:""))
                            }
                            
                        }else if dic!["type"] as! String == "text"  {
                            if resultFormDict["text1"] != nil{
                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 337, leftTitle:dic!["title"] as! String , rightTitle:(resultFormDict["text1"] as! String )))
                            }else{
                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 337, leftTitle:dic!["title"] as! String , rightTitle:""))
                            }
                            
                        }
                        
                    }
                }
               
                self.rootLayout.addSubview(self.addGrayLabContentLayout(tag: 2221, title: ""))
                for i in 0..<self.approveListArray.count{
                    let model = self.approveListArray[i]
                    if 0 == i{
                        self.rootLayout.addSubview(self.addFirstTableViewLayout(tag: 2222+i, time: model.approveTime,  status: model.approvalResult))
                    }else{
                        self.rootLayout.addSubview(self.addTableViewLayout(tag: 2222+i, time: model.approveTime, name: model.realName, status: model.approvalResult))
                    }
                }
                
                self.table.reloadData()
                
        }) { (error) in
            self.table.reloadData()
        }
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
                self.navigationController?.popViewController(animated: true)
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
                    "vacationTypeId":self.vocationType ?? 0],
            successCallBack: { (result) in
              self.rootLayout.addSubview(self.addCellContentLayout(tag: 303, leftTitle: "请假时长", rightTitle: result["data"]["duration"].stringValue + result["data"]["unit"].stringValue ))
        }) { (error) in
            
        }
    }
    
    //获取所有请假类型
    func getLeaveTypeRequest(title:String,time:NSNumber) {
        let userID = STUserTool.account().userID
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getAllVacationType" ,
            type: .get,
            param: ["emyeId":userID],
            successCallBack: { (result) in
                var textArray = [String]()
                var valueArray = [NSNumber]()
                for modalJson in result["data"].arrayValue {
                    
                    let model = modalJson.dictionaryValue
                    textArray.append((model["text"]?.stringValue)!)
                    valueArray.append((model["value"]?.numberValue)!)
                }
                
                //                let arr = formDict["dataSource"] as! NSArray
                //                var str = ""
                //                for i in 0..<arr.count{
                //                    let dataDic = arr[i] as! NSDictionary
                //                    if (resultFormDict["vacationType"] as! NSNumber) == (dataDic["value"] as! NSNumber){
                //                        str = dataDic["text"] as! String
                //                    }
                //                }
                var str = ""
                for i in 0..<valueArray.count{
                    if valueArray[i] == time{
                        str = textArray[i]
                    }
                }
                
                for wrap in self.rootLayout.subviews{
                    if 300 == wrap.tag{
                        for subV in wrap.subviews{
                            if 200 == subV.tag{
                                let lab:UILabel = subV as! UILabel
                                lab.text = str
                            }
                        }
                    }
                }
                
        }) { (error) in
            
        }
    }
}

//Mark 各个水平模块

extension CQCopyToMeDetailVC{
    //内容 从300开始
    internal func addCellContentLayout(tag:Int,leftTitle:String,rightTitle:String) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tg_top.equal(AutoGetHeight(height: 5))
//        wrapContentLayout.tg_bottom.equal(AutoGetHeight(height: 5))
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addHaveLeftDisLable(leftTitle, tag: 100))
        wrapContentLayout.addSubview(self.addRightLeftDisLable(rightTitle, tag: 200))
        return wrapContentLayout
    }
    
    //内容 从500开始
    internal func addCellContentNumberLinesLayout(tag:Int,leftTitle:String,rightTitle:String) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addHaveLeftDisLable(leftTitle, tag: 100))
        wrapContentLayout.addSubview(self.addRightLeftDisNumberLinesLable(rightTitle, tag: 400))
        return wrapContentLayout
    }
    
    //灰色留白（行程）
    internal func addGrayLabContentLayout(tag:Int,title:String) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(kWidth)
        wrapContentLayout.backgroundColor = kProjectBgColor
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addHaveLeftDisLable(title, tag: 2222))
        let lab = wrapContentLayout.viewWithTag(2222) as! UILabel
        lab.tg_height.equal(AutoGetHeight(height: 20))
        lab.textColor = kLyGrayColor
        return wrapContentLayout
    }
    
    //生成头像
    internal func addIconImageLayout(image:String,tag:Int) -> TGLinearLayout{
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addIconImageView(image: image,tag: tag))
        
        return wrapContentLayout
    }
    
    //生成用户名
    internal func addNameLabLayout(name:String,tag:Int) -> TGLinearLayout{
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addNameLab(title: name))
        
        return wrapContentLayout
    }
    
    //生成工作
    internal func addjobLabLayout(job:String,tag:Int) -> TGLinearLayout{
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addjobLab(time: job))
        
        return wrapContentLayout
    }
    
    //生成时间
    internal func addTimeLayout(time:String,tag:Int) -> TGLinearLayout{
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addtimeLab(time: time))
        
        return wrapContentLayout
    }
    
    //生成线条
    internal func addLineLayout() -> TGLinearLayout{
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        
        wrapContentLayout.addSubview(self.addLineView())
        
        return wrapContentLayout
    }
    
    //内容 cong1600开始
    internal func addFirstTableViewLayout(tag:Int,time:String,status:String) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addHaveLeftDisLable(status, tag: 54))
        let lab = wrapContentLayout.viewWithTag(54) as! UILabel
        lab.tg_left.equal(kLeftDis)
        lab.tg_width.equal(kWidth/2 - kLeftDis)
        lab.tg_height.equal(AutoGetHeight(height: 30))
        lab.tg_top.equal(AutoGetHeight(height: 5))
        lab.textColor = UIColor.black
        wrapContentLayout.addSubview(self.addTimeLable(time, tag: 2002, leftDis: kLeftDis))
        let timeLab = wrapContentLayout.viewWithTag(2002) as! UILabel
        timeLab.tg_height.equal(AutoGetHeight(height: 30))
        timeLab.tg_top.equal(AutoGetHeight(height: 5))
        return wrapContentLayout
    }
    
    //内容 cong1600开始
    internal func addTableViewLayout(tag:Int,time:String,name:String,status:String) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addIconView())
        wrapContentLayout.addSubview(self.addTableCellLable(name, width:(kWidth - AutoGetWidth(width: 61) - kWidth/2)/2, tag: 2000, leftDis: AutoGetWidth(width: 5)))
        wrapContentLayout.addSubview(self.addTableCellLable(status, width: (kWidth - AutoGetWidth(width: 61) - kWidth/2)/2 , tag: 2001, leftDis: AutoGetWidth(width: 5)))
        wrapContentLayout.addSubview(self.addTimeLableCell(time, tag: 2002, leftDis: kLeftDis))
        return wrapContentLayout
    }
}

//控件
extension CQCopyToMeDetailVC{
    //有左边距的lab 从100开始
    @objc internal func addHaveLeftDisLable(_ title:String, tag:NSInteger) -> UILabel{
        let lab = UILabel.init()
        lab.text = title
        lab.font = kFontSize15
        lab.textAlignment = .left
        lab.textColor = kLyGrayColor
        lab.tag = tag
        lab.numberOfLines = 0
        //        lab.adjustsFontSizeToFitWidth =  true
        lab.tg_left.equal(kLeftDis)
        lab.tg_width.equal(AutoGetWidth(width: 85))
        lab.tg_height.equal(30)
        return lab
    }
    
    //有右边距的lab 从200开始
    @objc internal func addRightLeftDisLable(_ title:String, tag:NSInteger) -> UILabel{
        let lab = UILabel.init()
        lab.text = title
        lab.font = kFontSize15
        lab.textAlignment = .left
        lab.textColor = UIColor.black
        lab.tag = tag
        lab.numberOfLines = 0
        //        lab.adjustsFontSizeToFitWidth =  true
        //        lab.tg_right.equal(kLeftDis)
        lab.tg_width.equal(kWidth - AutoGetWidth(width: 100))
        lab.tg_height.equal(30)
        return lab
    }
    
    
    //有右边距的lab 从400开始
    @objc internal func addRightLeftDisNumberLinesLable(_ title:String, tag:NSInteger) -> UILabel{
        let lab = UILabel.init()
        lab.text = title
        lab.font = kFontSize15
        lab.textAlignment = .left
        lab.textColor = UIColor.black
        lab.numberOfLines = 0
        lab.tag = tag
        //        lab.adjustsFontSizeToFitWidth =  true
        lab.tg_width.equal(.wrap)
        lab.tg_height.equal(30)
        return lab
    }
    
    
   
    
    //计算高度
    func getTextHeigh(textStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        let normalText: String = textStr
        let size = CGSize.init(width: width, height: 1000)
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context:nil).size
        return stringSize.height
    }
    
    
    @objc internal func addIconImageView(image:String,tag:Int) -> UIImageView {
        
        let img = UIImageView.init()
        img.tg_top.equal(AutoGetHeight(height: 18))
        img.tg_left.equal(kLeftDis)
        img.tag = tag
        img.tg_width.equal(AutoGetWidth(width: 36))
        img.tg_height.equal(AutoGetWidth(width: 36))
        img.sd_setImage(with: URL(string:image), placeholderImage:UIImage.init(named: "personDefaultIcon"))
        
        return img
    }
    
    @objc internal func addNameLab(title:String) -> UILabel {
        
        let nameLab = UILabel.init()
        nameLab.tg_top.equal(-AutoGetHeight(height: 33.5))
        nameLab.tg_left.equal( AutoGetWidth(width: 63))
        nameLab.tg_width.equal(kWidth - AutoGetWidth(width: 78))
        nameLab.tg_height.equal(AutoGetHeight(height: 16))
        nameLab.text = title
        nameLab.textColor = UIColor.black
        nameLab.textAlignment = .left
        nameLab.font = kFontSize16
        return nameLab
    }
    
    @objc internal func addjobLab(time:String) -> UILabel {
        
        let jobLab = UILabel.init()
        jobLab.tg_top.equal(-AutoGetHeight(height: 13))
        jobLab.tg_left.equal(AutoGetWidth(width: 63))
        jobLab.tg_width.equal(kWidth - AutoGetWidth(width: 78))
        jobLab.tg_height.equal(AutoGetHeight(height: 11))
        jobLab.text = time
        jobLab.textColor = kGoldYellowColor
        jobLab.textAlignment = .left
        jobLab.font = kFontSize11
        return jobLab
    }
    
    @objc internal func addtimeLab(time:String) -> UILabel {
        
        let timeLab = UILabel.init()
        timeLab.tg_top.equal(-AutoGetHeight(height: 33.5))
        timeLab.tg_right.equal( AutoGetWidth(width: 15))
        timeLab.tg_width.equal(kWidth - kLeftDis)
        timeLab.tg_height.equal(AutoGetHeight(height: 11))
        timeLab.text = time
        timeLab.textColor = kLyGrayColor
        timeLab.textAlignment = .right
        timeLab.font = kFontSize11
        return timeLab
    }
    
    
    @objc internal func addLineView() -> UIView {
        
        let lineView = UIView.init()
        lineView.tg_top.equal(AutoGetHeight(height: 13))
        lineView.tg_left.equal(AutoGetWidth(width: 13))
        lineView.tg_width.equal(kWidth - AutoGetWidth(width: 13))
        lineView.tg_height.equal(0.5)
        lineView.backgroundColor = kLineColor
        return lineView
    }
    
    //图片
    @objc internal func addIconView() -> UIImageView{
        let img = UIImageView.init()
        img.image = UIImage.init(named: "personDefaultIcon")
        img.tg_left.equal(kLeftDis)
        img.tg_top.equal(kLeftDis)
        img.tg_width.equal(AutoGetWidth(width:36))
        img.tg_height.equal(AutoGetWidth(width: 36))
        return img
    }
    
    //据左边距tag1500
    @objc internal func addTableCellLable(_ title:String,width:CGFloat, tag:NSInteger,leftDis:CGFloat) -> UILabel{
        let lab = UILabel.init()
        lab.text = title
        if title == "审批中"{
            lab.textColor = kGoldYellowColor
        }else{
            lab.textColor = UIColor.black
        }
        
        lab.font = kFontSize15
        lab.textAlignment = .left
        lab.tag = tag
        lab.tg_left.equal(leftDis)
        lab.adjustsFontSizeToFitWidth = true
        lab.tg_width.equal(AutoGetWidth(width: width))
        lab.tg_height.equal(AutoGetHeight(height: 62))
        return lab
    }
    
    
    //时间
    @objc internal func addTimeLable(_ title:String, tag:NSInteger,leftDis:CGFloat) -> UILabel{
        let lab = UILabel.init()
        lab.text = title
        lab.font = kFontSize15
        lab.textAlignment = .right
        lab.textColor = kLyGrayColor
        lab.tag = tag
        lab.tg_right.equal(leftDis)
        lab.tg_width.equal((kWidth - 2*leftDis)/2)
        lab.tg_height.equal(AutoGetHeight(height: 62))
        return lab
    }
    
    //cell时间
    @objc internal func addTimeLableCell(_ title:String, tag:NSInteger,leftDis:CGFloat) -> UILabel{
        let lab = UILabel.init()
        lab.text = title
        lab.font = kFontSize15
        lab.textAlignment = .right
        lab.textColor = kLyGrayColor
        lab.tag = tag
        lab.tg_right.equal(leftDis)
        lab.tg_width.equal(kWidth - leftDis - (kWidth - AutoGetWidth(width: 61) - kWidth/2) - AutoGetWidth(width: 71))
        lab.tg_height.equal(AutoGetHeight(height: 62))
        return lab
    }
    
}



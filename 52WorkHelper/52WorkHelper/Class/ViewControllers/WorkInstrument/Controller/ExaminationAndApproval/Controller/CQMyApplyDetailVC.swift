//
//  CQMyApplyDetailVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/21.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQMyApplyDetailVC: SuperVC {

    weak var rootLayout :TGLinearLayout!
    var businessApplyId = ""
    var selfType = ""
    var approveListArray = [CQCopyToMeApproverlistModel]()
    var copyPersonListArray = [CQCopyToMeApproverlistModel]()
    var applyStatusCode = ""
    var businessCode = ""
    var carDic:NSDictionary?
    var meetingDic:NSDictionary?
    var businessDetailCount = 0
    var approvalBusinessId = ""
    var startTime = "" //开始时间
    var endTime = "" //结束时间
    var vocationType:NSNumber? //请假类型
    var vocationDuration = ""
    var vacationUnit = ""
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - AutoGetHeight(height: 49)), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - AutoGetHeight(height: 49)))
        return headView
    }()
    
    
    lazy var returnBtn: UIButton = {
        let returnBtn = UIButton.init(type: .custom)
        returnBtn.frame = CGRect.init(x: 0, y: kHeight - AutoGetHeight(height: 49), width: kWidth, height: AutoGetHeight(height: 49))
        returnBtn.setTitle("撤销", for: .normal)
        returnBtn.setTitleColor(kLightBlueColor, for: .normal)
        returnBtn.backgroundColor = UIColor.white
        returnBtn.layer.borderWidth = 0.5
        returnBtn.layer.borderColor = kLyGrayColor.cgColor
        returnBtn.addTarget(self, action: #selector(returnClick), for: .touchUpInside)
        return returnBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.automaticallyAdjustsScrollViewInsets = false
        self.loadData()
        
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
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
        
        self.view.addSubview(self.returnBtn)
        
    }
    
    @objc func returnClick()  {
        if self.applyStatusCode == "0"{
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
            }else{
                let vc = CQSupplyVC()
                vc.approvalBusinessId = self.businessApplyId
                vc.detailBid = self.approvalBusinessId
                vc.isFromSubmitDetail = true
                vc.isFromApplyDetail = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }

}

extension CQMyApplyDetailVC{
    // MARK:request
    fileprivate func loadData() {
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/approval/getMyApplyDetail",
                                   type: .get,
                                   param: ["emyeId":userID,
                                           "businessApplyId":self.businessApplyId],
                                   successCallBack: { (result) in
                                    guard let model = CQMyApplyFormatModel(jsonData: result["data"]) else {
                                        return
                                    }
                                    
                                    
                                    self.approvalBusinessId = model.approvalBusinessId
                                    
                                    //审批进度列表
                                    var approveArr = [CQCopyToMeApproverlistModel]()
                                    for copyJson in model.approverList{
                                        let copyModel = CQCopyToMeApproverlistModel(jsonData: copyJson)
                                        approveArr.append(copyModel!)
                                    }
                              
                                    self.approveListArray = approveArr
                                    
                                    //按钮状态
                                    self.applyStatusCode = model.applyStatusCode
                                    if self.applyStatusCode == "0"{
                                       self.returnBtn.setTitle("撤销", for: .normal)
                                    }else if self.applyStatusCode == "2" || self.applyStatusCode == "3" || self.applyStatusCode == "4"{
                                        self.returnBtn.setTitle("已撤销 请修改申请", for: .normal)
                                    }else{
                                        self.returnBtn.isHidden = true
                                    }
                                    
                                    
                                    //抄送人列表
                                    var copyPersonListArr = [CQCopyToMeApproverlistModel]()
                                    for copyJson in model.copyPersonList{
                                        let copyModel = CQCopyToMeApproverlistModel(jsonData: copyJson)
                                        copyPersonListArr.append(copyModel!)
                                    }
                                    
                                    self.copyPersonListArray = copyPersonListArr
//                                    DLog(self.copyPersonListArray.count)
                                
                                    let contentStr = model.formContent
                                    let resultStr = model.formData
                                    let resultDic = self.getDictionaryFromJSONString(jsonString: resultStr)
//                                    DLog(resultDic)
                                    let resultArr = resultDic["businessApplyDatas"] as! NSArray
//                                    DLog(resultArr)
                                    DLog(model.businessCode)
                                    self.businessCode = model.businessCode
                                    
                                    self.rootLayout.addSubview(self.addIconImageLayout(image: model.headImage, tag: 3333))
                                    self.rootLayout.addSubview(self.addNameLabLayout(name: "我", tag: 100))
                                    self.rootLayout.addSubview(self.addTimeLabLayout(time: model.statusDesc, tag: 101))
                                    self.rootLayout.addSubview(self.addLineLayout())
                                    
                                    if model.businessCode == "B_CL"{
                                        self.title = "我的派车"
                                        let resultFormDict = resultArr[0] as! NSDictionary
                                        self.carDic = resultFormDict
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
                                    }else if model.businessCode == "B_HYS"{
                                        self.title = "我的会议室"
                                        let resultFormDict = resultArr[0] as! NSDictionary
                                        self.meetingDic = resultFormDict
                                        self.rootLayout.addSubview(self.addCellContentLayout(tag: 326, leftTitle:"主题", rightTitle:resultFormDict["meetingTitle"] as! String))
                                        self.rootLayout.addSubview(self.addCellContentLayout(tag: 327, leftTitle:"概要", rightTitle:resultFormDict["outLine"] as! String))
                                        self.rootLayout.addSubview(self.addCellContentLayout(tag: 328, leftTitle:"开始时间", rightTitle:resultFormDict["startDate"] as! String))
                                        self.rootLayout.addSubview(self.addCellContentLayout(tag: 329, leftTitle:"结束时间", rightTitle:resultFormDict["endDate"] as! String))
                                        let arr = resultFormDict["meetingRoom"] as! NSDictionary
                                        let room = arr["name"] as! String
                                        self.rootLayout.addSubview(self.addCellContentLayout(tag: 330, leftTitle:"会议室", rightTitle:room))
                                    }
                                    
                                    
//                                    self.rootLayout.addSubview(self.addIconImageLayout(image: model.headImage, tag: 3333))
//                                    self.rootLayout.addSubview(self.addNameLabLayout(name: "我", tag: 100))
//                                    self.rootLayout.addSubview(self.addTimeLabLayout(time: model.statusDesc, tag: 101))
//                                    self.rootLayout.addSubview(self.addLineLayout())
                                    
                                    if !contentStr.isEmpty{
                                        let formData:Data = contentStr.data(using: String.Encoding.utf8)!
                                        guard let array = JSON(formData).arrayObject as? [[String: AnyObject]] else {
                                            return
                                        }
                                        for i in 0..<array.count{
                                            let arr = array[i]
                                            let dic = arr["widget"]
                                            if 0 == i{
                                                self.selfType = (dic!["type"] as? String)!
                                                if self.selfType == "leave"{
                                                    self.title = "我的请假"
                                                }else if self.selfType == "outWork"{
                                                    self.title = "我的外出"
                                                }else if self.selfType == "business"{
                                                    self.title = "我的出差"
                                                }else if self.selfType == "overtime"{
                                                    self.title = "我的加班"
                                                }else if self.selfType == "modify"{
                                                    self.title = "我的补卡"
                                                }else{
                                                    self.title = "我的金额合同"
                                                }
                                                
                                                if self.selfType == "leave" || self.selfType == "outWork" || self.selfType == "business" || self.selfType == "overtime" || self.selfType == "modify"{
                                                    let formArr = dic!["subWidget"]
                                                    
                                                    
                                                    let a = formArr as! NSArray
                                                    let resultFormDict = resultArr[i] as! NSDictionary
                                                    if self.selfType == "leave"{
                                                        self.vocationType = ((resultFormDict["vacationType"] as! Int) as NSNumber)
                                                        self.startTime = resultFormDict["startTime"] as! String
                                                        self.endTime = resultFormDict["endTime"] as! String
                                                        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getLeaveDuration" ,
                                                            type: .get,
                                                            param: ["emyeId":userID,
                                                                    "startTime":self.startTime,
                                                                    "endTime":self.endTime,
                                                                    "vacationTypeId":self.vocationType ?? 0],
                                                            successCallBack: { (result) in
                                                                self.vocationDuration = result["data"]["duration"].stringValue
                                                                self.vacationUnit = result["data"]["unit"].stringValue
                                                                
                                                        }) { (error) in
                                                            
                                                        }
                                                    }
                                                    
                                                    
                                                    var businessDetail:NSMutableArray = NSMutableArray.init()
                                                    if self.selfType == "business"{
                                                        businessDetail = resultFormDict["businessDetail"] as! NSMutableArray
                                                    }
                                                    
                                                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 300, leftTitle: "所在部门", rightTitle: model.departmentName))
                                                    
                                                    if a.count > 0{
                                                        
                                                        for forDict in a {
                                                            let formDict = forDict as! NSDictionary
                                                            let formName = formDict["name"] as! String
                                                            if formName == "vacationType"  {
                                                                
                                                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 301, leftTitle: formDict["title"] as! String, rightTitle: ""))
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
                                                                }
                                                                else{
                                                                    if self.selfType == "business"{
                                                                        self.rootLayout.addSubview(self.addCellContentLayout(tag: 304, leftTitle: formDict["title"] as! String, rightTitle:(businessDetail[0] as! NSDictionary)["duration"] as! String + (formDict["unit"] as! String)))
                                                                    }else{
                                                                        self.rootLayout.addSubview(self.addCellContentLayout(tag: 304, leftTitle: formDict["title"] as! String, rightTitle:String.init(format: "%@", resultFormDict["duration"] as! String + (formDict["unit"] as! String))))
                                                                    }
                                                                }
                                                            }else if formName == "leaveReason"  {
                                                                self.rootLayout.addSubview(self.addCellContentNumberLinesLayout(tag: 305, leftTitle: formDict["title"] as! String, rightTitle: resultFormDict["leaveReason"] as! String ))
                                                            }else if formName == "extraPerson"  {
                                                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 307, leftTitle:formDict["title"] as! String, rightTitle:(resultFormDict["extraPerson"] as! NSDictionary)["name"] as! String ))
                                                            }else if formName == "modifyTime"  {
                                                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 308, leftTitle:formDict["title"] as! String, rightTitle:resultFormDict["modifyTime"] as! String))
                                                            }else if formName == "modifyReason"  {
                                                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 309, leftTitle:formDict["title"] as! String, rightTitle:resultFormDict["modifyReason"] as! String))
                                                            }else if formName == "travelReason"  {
                                                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 310, leftTitle:formDict["title"] as! String, rightTitle:resultFormDict["travelReason"] as! String))
                                                            }else if formName == "sub" {
                                                                if self.selfType == "business"{
                                                                    self.rootLayout.addSubview(self.addGrayLabContentLayout(tag:311,title:formDict["title"] as! String + " 0"))
                                                                }else{
                                                                    self.rootLayout.addSubview(self.addGrayLabContentLayout(tag:311,title: formDict["title"] as! String))
                                                                }
                                                            }
                                                                //                                                        else if formName == "travelReason"  {
                                                                //                                                            self.rootLayout.addSubview(self.addCellContentLayout(tag: 312, leftTitle:formDict["title"] as! String, rightTitle:resultFormDict["travelReason"] as! String))
                                                                //                                                        }
                                                            else if formName == "transport"  {
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
                                                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 318, leftTitle:formDict["title"] as! String, rightTitle:resultFormDict["remark"] as! String))
                                                            }else if formName == "togetherPerson"  {
                                                                var together = ""
                                                                if self.selfType == "business"{
                                                                    let arr = resultFormDict["togetherPerson"] as! NSArray
                                                                    for i in 0..<arr.count{
                                                                        if 0 == i{
                                                                            together = (arr[i] as! NSDictionary)["name"] as! String
                                                                        }else{
                                                                            together = together + "," + ((arr[i] as! NSDictionary)["name"] as! String)
                                                                        }
                                                                    }
                                                                    
                                                                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 319, leftTitle:formDict["title"] as! String, rightTitle:together))
                                                                }
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
                                                                    
                                                                }
                                                            }
                                                            
                                                            
                                                        }
                                                    }
                                                }
                                            }
                                            
                                            
                                            
                                            
                                            let resultFormDict = resultArr[0] as! NSDictionary
                                            if dic!["type"] as! String == "phnoeNum"  {
                                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 331, leftTitle:dic!["title"] as! String , rightTitle:resultFormDict["phnoeNum1"] as! String ))
                                            }else if dic!["type"] as! String == "numText"  {
                                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 332, leftTitle:dic!["title"] as! String , rightTitle:resultFormDict["numText0"] as! String ))
                                            }else if dic!["type"] as! String == "person"  {
                                                let name = ((resultFormDict["person3"] as! NSDictionary)["name"])
                                                if (name is NSNull) {
                                                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 333, leftTitle:dic!["title"] as! String , rightTitle:"" ))
                                                }else{
                                                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 333, leftTitle:dic!["title"] as! String , rightTitle:(resultFormDict["person3"] as! NSDictionary)["name"] as! String ))
                                                }
                                                
                                            }else if dic!["type"] as! String == "department"  {
                                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 334, leftTitle:dic!["title"] as! String , rightTitle:(resultFormDict["department5"] as! NSDictionary)["name"] as! String ))
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
                                                self.rootLayout.addSubview(self.addCellContentLayout(tag: 336, leftTitle:dic!["title"] as! String , rightTitle:(resultFormDict["upperMoney0"] as! String )))
                                            }else if dic!["name"] as! String == "text2"  {
                                                if resultFormDict["text2"] != nil{
                                                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 338, leftTitle:dic!["title"] as! String , rightTitle:(resultFormDict["text2"] as! String )))
                                                }else{
                                                    self.rootLayout.addSubview(self.addCellContentLayout(tag: 338, leftTitle:dic!["title"] as! String , rightTitle:""))
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
                                   
                                    self.rootLayout.addSubview(self.addGrayViewLayout(tag: 700)) //灰色从700开始
                                    for i in 0..<self.approveListArray.count{
                                        let model = self.approveListArray[i]
                                        if model.realName == STUserTool.account().realName{
                                            self.rootLayout.addSubview(self.addTableViewLayout(tag: 2222+i, time: model.approveTime, name:"我", status: model.approvalResultRemark,imageUrl: model.headImage))
                                        }else{
                                            self.rootLayout.addSubview(self.addTableViewLayout(tag: 2222+i, time: model.approveTime, name: model.realName, status: model.approvalResult,imageUrl: model.headImage))
                                        }
                                    }
                                    if self.selfType == "business"{
                                        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: self.headView.sd_height + CGFloat(self.businessDetailCount + 1) * AutoGetHeight(height: 380) + CGFloat(self.copyPersonListArray.count/4 + 1) * AutoGetHeight(height: 78) + AutoGetHeight(height: 100))
                                    }else if self.selfType == "leave"{
                                        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight + CGFloat(self.approveListArray.count) * AutoGetHeight(height: 62) - AutoGetHeight(height: 300))
                                    }else {
                                        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight + CGFloat(self.approveListArray.count) * AutoGetHeight(height: 62) + AutoGetHeight(height: 100))
                                    }
//                                    self.table.tableHeaderView = self.headView
                                    self.rootLayout.addSubview(self.addGrayViewLayout(tag: 701)) //灰色从700开始
                                    if self.copyPersonListArray.count > 0{
                                        self.rootLayout.addSubview(self.addCollectionViewContentLayout(tag: 306, height: AutoGetHeight(height: 78)  + CGFloat(self.copyPersonListArray.count/4 + 1) * AutoGetHeight(height: 78), collectionTag: 1000))
                                        self.rootLayout.tg_height.equal(.wrap)
                                        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: self.headView.sd_height + CGFloat(self.copyPersonListArray.count/4 + 1) * AutoGetHeight(height: 78) + AutoGetHeight(height: 100))
//
//
                                        let collectionLayout = self.rootLayout.viewWithTag(306)
                                        for v in (collectionLayout?.subviews)!{
                                            if v.tag == 1000{
                                                let collection = v as! UICollectionView
                                                collection.reloadData()
                                                DLog(collection.frame.origin.y)
                                                DLog(self.headView.frame.size.height)
                                            }
                                        }
                                        
                                    }
                                    
                                    
                                    self.table.tableHeaderView = self.headView
                                    self.table.reloadData()
                                    
        }) { (error) in
        }
    }
    
    /// JSONString转换为字典
    ///
    /// - Parameter jsonString:
    /// - Returns:
    func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        
        let jsonData:Data = jsonString.data(using: .utf8)!
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
        
        
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
                self.vocationDuration = result["data"]["duration"].stringValue
                self.vacationUnit = result["data"]["unit"].stringValue
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
                    if 301 == wrap.tag{
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

extension CQMyApplyDetailVC{
    //内容 从300开始
    internal func addCellContentLayout(tag:Int,leftTitle:String,rightTitle:String) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_top.equal(AutoGetHeight(height: 5))
//        wrapContentLayout.tg_bottom.equal(AutoGetHeight(height: 5))
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
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
    
    //灰色水平布局
    internal func addGrayViewLayout(tag:Int) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addGrayView())
        return wrapContentLayout
    }
    
    //内容 cong1600开始
    internal func addTableViewLayout(tag:Int,time:String,name:String,status:String,imageUrl:String) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addIconView(imageUrl:imageUrl))
        wrapContentLayout.addSubview(self.addTableCellLable(name, width:AutoGetWidth(width: 75), tag: 2000, leftDis: AutoGetWidth(width: 10)))
        wrapContentLayout.addSubview(self.addTableCellLable(status, width: AutoGetWidth(width: 75) , tag: 2001, leftDis: AutoGetWidth(width: 10)))
        wrapContentLayout.addSubview(self.addTimeLable(time, tag: 2002, leftDis: AutoGetWidth(width: 10)))
        return wrapContentLayout
    }
    
  
    
    //collectionView
    internal func addCollectionViewContentLayout(tag:Int,height:CGFloat,collectionTag:Int) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(height)
        wrapContentLayout.tag = tag
        
        
        wrapContentLayout.addSubview(self.addCollectionView(leftDis: kLeftDis, delegate: self, dataSource: self, tag: collectionTag,height:height))
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
//        lab.tg_height.equal(AutoGetHeight(height: 20))
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
    
    //生成时间
    internal func addTimeLabLayout(time:String,tag:Int) -> TGLinearLayout{
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addTimeLab(time: time))
        
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
}

//控件
extension CQMyApplyDetailVC{
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
    
    //灰白
    @objc internal func addGrayView() -> UIView{
        let view = UIView.init()
        view.backgroundColor = kProjectBgColor
        view.tg_width.equal(AutoGetWidth(width: kWidth))
        view.tg_height.equal(AutoGetHeight(height: 13))
        return view
    }
    
    //图片
    @objc internal func addIconView(imageUrl:String) -> UIImageView{
        let img = UIImageView.init()
        img.sd_setImage(with: URL(string: imageUrl), placeholderImage:UIImage.init(named: "personDefaultIcon") )
        img.layer.cornerRadius = AutoGetWidth(width: 18)
        img.clipsToBounds = true
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
        lab.tg_width.equal(width)
        lab.tg_height.equal(AutoGetHeight(height: 62))
        return lab
    }
    
    
    //时间
    @objc internal func addTimeLable(_ title:String, tag:NSInteger,leftDis:CGFloat) -> UILabel{
        let lab = UILabel.init()
        lab.text = title
        lab.font = kFontSize15
        lab.textAlignment = .right
        lab.textColor = UIColor.lightGray
        lab.tag = tag
        lab.tg_left.equal(leftDis)
        lab.tg_width.equal(kWidth - 2 * AutoGetWidth(width: 75) - AutoGetWidth(width: 30) - AutoGetWidth(width: 51) - kLeftDis)
        lab.tg_height.equal(AutoGetHeight(height: 62))
        return lab
    }
    
    //collectionView
    @objc internal func addCollectionView(leftDis:CGFloat,delegate:UICollectionViewDelegate,dataSource:UICollectionViewDataSource,tag:Int,height:CGFloat) -> UICollectionView {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width:kHaveLeftWidth/4, height:AutoGetHeight(height: 75))
        layOut.minimumLineSpacing = 10
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        layOut.headerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 38))
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kHaveLeftWidth, height:height), collectionViewLayout: layOut)
        collectionView.tg_left.equal(leftDis)
        collectionView.tg_width.equal(kWidth - 2*leftDis)
        collectionView.tg_height.equal(.wrap)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        collectionView.tag = tag
        
        collectionView.register(CQWriteReportCell.self, forCellWithReuseIdentifier: "CQWriteReportCellId")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "myApplyDetailHeader")
        return collectionView
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
        img.layer.cornerRadius = AutoGetWidth(width: 18)
        img.clipsToBounds = true
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
    
    @objc internal func addTimeLab(time:String) -> UILabel {
        
        let timeLab = UILabel.init()
        timeLab.tg_top.equal(-AutoGetHeight(height: 13))
        timeLab.tg_left.equal(AutoGetWidth(width: 63))
        timeLab.tg_width.equal(kWidth - AutoGetWidth(width: 78))
        timeLab.tg_height.equal(AutoGetHeight(height: 11))
        timeLab.text = time
        timeLab.textColor = kGoldYellowColor
        timeLab.textAlignment = .left
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
}


//  MARK:UICollectionViewDelegate
extension CQMyApplyDetailVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.copyPersonListArray.count
    }
    
}

extension CQMyApplyDetailVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQWriteReportCellId", for: indexPath) as! CQWriteReportCell
        let model = self.copyPersonListArray[indexPath.item]
        cell.img.sd_setImage(with: URL(string: model.headImage ), placeholderImage:UIImage.init(named: "personDefaultIcon") )
        cell.nameLab.text = model.realName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var header:UICollectionReusableView!
        if kind == UICollectionElementKindSectionHeader {
            header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "myApplyDetailHeader", for: indexPath)
            
            let lab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: AutoGetWidth(width: 75), height: AutoGetHeight(height: 38)))
            lab.text = "抄送人"
            lab.textAlignment = .left
            lab.textColor = UIColor.black
            lab.font = kFontSize15
            header.addSubview(lab)
            
            let lab1 = UILabel.init(frame: CGRect.init(x: lab.right + AutoGetWidth(width: 5), y: 0, width: AutoGetWidth(width: 200), height: AutoGetHeight(height: 38)))
            lab1.text = "审批通过后，通知抄送人"
            lab1.textAlignment = .left
            lab1.textColor = kLyGrayColor
            lab1.font = kFontSize15
            header.addSubview(lab1)
        }
        
        return header
    }
    
}

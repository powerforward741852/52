//
//  NCQApprovelDetailModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/10/28.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit

class NCQApprovelDetailModel: NSObject {

    //审批人列表
    var approverList:[JSON]
    //审批业务主键(用于驳回重新提交时，查询审批人和抄送人接口)
    var approvalBusinessId = ""
    //申请状态码(0-审核中，1-审核通过，2-被驳回，3-已撤销，4-已销假(请假申请))
    var applyStatusCode = ""
    //业务编码
    var businessCode = ""
    //业务名称
    var businessName = ""
    //抄送人列表
    var copyPersonList:[JSON]
    //表单内容
    var formContent = ""
    //form数据json
    var formData = ""
    //头像路径
    var headImage = ""
    //申请状态描述
    var statusDesc = ""
    //出差总天数
    var totalDuration = ""
    //出差总时长数
    var totalTravelDays = ""
    //请假单位，1-小时，2-半天，3-天
    var vacationUnit = ""
    //请假单位描述
    var vacationUnitDesc = ""
    //申请人部门1
    var departmentName = ""
    //申请人职位
    var positionName = ""
    
    
    //审批数组内容
    //审批结果
    var approvalResult = ""
    //审批意见
    var approvalResultRemark = ""
    //审批时间
    var approveTime = ""
    //姓名
    var realName = ""
    //提交时间
    var submitTime = ""
    //主键
    var entity = ""
    //是否显示结束时间
    var isShowEndTime = true
    
    //套件控件里的子控件
    var subWidget:[JSON]
    var prompt = ""
    var required = false
    var dataFormat = ""
    var dataSource:[JSON]
    var unit = ""
    var formula = ""
    var name = ""
    var type = ""
    var title = ""
    //dataSource数据
    var text = ""
    var value = ""
    var timeMode = ""
    var useBalance = ""
    
    //formData中的数据
    var vacationType = ""
    var startTime = ""
    var endTime = ""
    var leaveReason = ""
    var leavePerson:[JSON]
    var duration = ""
    var url = ""
    
    var extraPerson:JSON
    var togetherPerson:[JSON]
    
    var text1 = ""
    var text2 = ""
    var text0 = ""
    var modifyTime = ""
    var modifyReason = ""
    var businessDetail:[JSON]
    var isBack:Bool
    var fromCity = ""
    var toCity = ""
    
    var transport = ""
    var travelDays = ""
    var remark = ""
    var travelReason = ""
    
    //派车
    var applyReason = ""
    var startDate = ""
    var endDate = ""
    var pbulicCar:JSON
    var carType = ""
    var destination = ""
    
    var businessApplyDatas:[JSON]
    
    //外出
    var LongitudeValue = ""
    var LatitudeValue = ""
    var addressRemark = ""
    var outReason = ""
    
    
    //会议室
    var meetingTitle = ""
    var outLine = ""
    var meetingRoom:JSON
    
    var entityId = ""
    
    //文件名称
    var fileName = ""
    //文件路径
    var fileUrl = ""
    //
    var flieUrl = ""
    
    //
    var data:[JSON]
    
    
    var single = false
    
    //我的申请结果
    var myApprovalResult = ""
    
    init?(jsonData: JSON) {
        
        isShowEndTime = jsonData["isShowEndTime"].boolValue
        approverList = jsonData["approverList"].arrayValue
        approvalBusinessId = jsonData["approvalBusinessId"].stringValue
        applyStatusCode = jsonData["applyStatusCode"].stringValue
        businessCode = jsonData["businessCode"].stringValue
        businessName = jsonData["businessName"].stringValue
        copyPersonList = jsonData["copyPersonList"].arrayValue
        formContent = jsonData["formContent"].stringValue
        formData = jsonData["formData"].stringValue
        headImage = jsonData["headImage"].stringValue
        statusDesc = jsonData["statusDesc"].stringValue
        totalDuration = jsonData["totalDuration"].stringValue
        totalTravelDays = jsonData["totalTravelDays"].stringValue
        vacationUnitDesc = jsonData["vacationUnitDesc"].stringValue
        departmentName = jsonData["departmentName"].stringValue
        positionName = jsonData["positionName"].stringValue
        
        approvalResult = jsonData["approvalResult"].stringValue
        approvalResultRemark = jsonData["approvalResultRemark"].stringValue
        approveTime = jsonData["approveTime"].stringValue
        realName = jsonData["realName"].stringValue
        submitTime = jsonData["submitTime"].stringValue
        entity = jsonData["entity"].stringValue
     
        subWidget = jsonData["subWidget"].arrayValue
        name = jsonData["name"].stringValue
        type = jsonData["type"].stringValue
        title = jsonData["title"].stringValue
        prompt = jsonData["prompt"].stringValue
        required = jsonData["required"].boolValue
        dataFormat = jsonData["dataFormat"].stringValue
        unit = jsonData["unit"].stringValue
        formula = jsonData["formula"].stringValue
        dataSource = jsonData["dataSource"].arrayValue
        
        text = jsonData["text"].stringValue
        value = jsonData["value"].stringValue
        vacationUnit = jsonData["vacationUnit"].stringValue
        timeMode = jsonData["timeMode"].stringValue
        useBalance = jsonData["useBalance"].stringValue
        
        vacationType = jsonData["vacationType"].stringValue
        startTime = jsonData["startTime"].stringValue
        endTime = jsonData["endTime"].stringValue
        leaveReason = jsonData["leaveReason"].stringValue
        duration = jsonData["duration"].stringValue
        leavePerson = jsonData["leavePerson"].arrayValue
        url = jsonData["url"].stringValue
        
        
        extraPerson = jsonData["extraPerson"]
        togetherPerson = jsonData["togetherPerson"].arrayValue
        text1 = jsonData["text1"].stringValue
        text2 = jsonData["text2"].stringValue
        text0 = jsonData["text0"].stringValue
        modifyTime = jsonData["modifyTime"].stringValue
        modifyReason = jsonData["modifyReason"].stringValue
        businessDetail = jsonData["businessDetail"].arrayValue
        isBack = jsonData["isBack"].boolValue
        fromCity = jsonData["fromCity"].stringValue
        toCity = jsonData["toCity"].stringValue
        transport = jsonData["transport"].stringValue
        travelDays = jsonData["travelDays"].stringValue
        travelReason = jsonData["travelReason"].stringValue
        remark = jsonData["remark"].stringValue
        
        
        //派车
        pbulicCar = jsonData["pbulicCar"]
        applyReason = jsonData["applyReason"].stringValue
        startDate = jsonData["startDate"].stringValue
        endDate = jsonData["endDate"].stringValue
        carType = jsonData["carType"].stringValue
        destination = jsonData["destination"].stringValue
        
        businessApplyDatas = jsonData["businessApplyDatas"].arrayValue
        
        //会议室
        meetingRoom = jsonData["meetingRoom"]
        meetingTitle = jsonData["meetingTitle"].stringValue
        outLine = jsonData["outLine"].stringValue
        
        entityId = jsonData["entityId"].stringValue
        
        fileName = jsonData["fileName"].stringValue
        fileUrl = jsonData["fileUrl"].stringValue
        flieUrl = jsonData["flieUrl"].stringValue
        data = jsonData["data"].arrayValue
        
        single = jsonData["single"].boolValue
        myApprovalResult = jsonData["myApprovalResult"].stringValue
        //外出
        LongitudeValue = jsonData["LongitudeValue"].stringValue
        LatitudeValue = jsonData["LatitudeValue"].stringValue
        addressRemark = jsonData["addressRemark"].stringValue
        outReason = jsonData["outReason"].stringValue
        
    }
}

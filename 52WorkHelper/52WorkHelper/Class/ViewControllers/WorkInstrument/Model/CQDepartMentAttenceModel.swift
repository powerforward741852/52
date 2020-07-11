//
//  CQDepartMentAttenceModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/9/12.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQDepartMentAttenceModel: NSObject {

    //上午上班打卡时间
    var amStart = ""
    var amStartSource = ""
    //上午下班打卡时间
    var amEnd = ""
    var amEndSource = ""
    //下午下班打卡时间
    var pmEnd = ""
    var pmEndSource = ""
    //下午上班打卡时间
    var pmStart = ""
    var pmStartSource = ""
    
    
    //部门id
    var departmentId = ""
    //部门名称
    var departmentName = ""
    //某日期    
    var dayTime = ""
    //某日期星期几
    var weekOfDate = ""
    //头像    
    var headImage = ""
    //考勤id
    var attendanceRecordId = ""
    //真实姓名
    var realName = ""
    //类型名称
    var typeName = ""
    //类型名称备注
    var typeNameRemark = ""
    //上下班未签
    var typeNameTotal = ""
    //leaveData
    var leaveData:[JSON]
    //开始时间
    var startTime = ""
    //结束时间
    var endTime = ""
    //entityId
    var entityId = ""
    //userId
    var userId = ""
    //地址备注
    var addressRemark = ""
    //创建人的用户头像地址
    var createUserHeadImage = ""
    //创建人的用户id
    var createUserId = ""
    //创建人的用户真实姓名
    var createUserRealName = ""
    //距离
    var distance = ""
    //历史位置id
    var historyPositionId = ""
    //坐标纬度
    var latitudeValue = 0.0
    //坐标经度
    var longitudeValue = 0.0
    //创建人的职位名称
    var positionName = ""
    //历史位置类别
    var type = ""
    //更新时间
    var updateDate = ""
    //签到时间
    var signDate = ""
    
    //考勤统计数据列表(包括请假出差外出的审批申请)
    var statisticData:[JSON]

    //祝福选中状态
    var isSelected : Bool = false
    
    
    //祝福图片
    
    var imgUrl = ""
    var backGroundImageId = ""
   
    
    init?(jsonData: JSON) {
        
        imgUrl = jsonData["imgUrl"].stringValue
        backGroundImageId = jsonData["backGroundImageId"].stringValue
        
        entityId = jsonData["entityId"].stringValue
        userId = jsonData["userId"].stringValue
        
        amStart = jsonData["amStart"].stringValue
        amEnd = jsonData["amEnd"].stringValue
        pmStart = jsonData["pmStart"].stringValue
        pmEnd = jsonData["pmEnd"].stringValue
        
        amStartSource = jsonData["amStartSource"].stringValue
        amEndSource = jsonData["amEndSource"].stringValue
        pmStartSource = jsonData["pmStartSource"].stringValue
        pmEndSource = jsonData["pmEndSource"].stringValue
        
        departmentId = jsonData["departmentId"].stringValue
        departmentName = jsonData["departmentName"].stringValue
       
        
        dayTime = jsonData["dayTime"].stringValue
        weekOfDate = jsonData["weekOfDate"].stringValue
        
        headImage = jsonData["headImage"].stringValue
        attendanceRecordId = jsonData["attendanceRecordId"].stringValue
        realName = jsonData["realName"].stringValue
        typeName = jsonData["typeName"].stringValue
        typeNameRemark = jsonData["typeNameRemark"].stringValue
        typeNameTotal = jsonData["typeNameTotal"].stringValue
        leaveData = jsonData["leaveData"].arrayValue
        startTime = jsonData["startTime"].stringValue
        endTime = jsonData["endTime"].stringValue
        
        addressRemark = jsonData["addressRemark"].stringValue
        createUserHeadImage = jsonData["createUserHeadImage"].stringValue
        createUserId = jsonData["createUserId"].stringValue
        createUserRealName = jsonData["createUserRealName"].stringValue
        distance = jsonData["distance"].stringValue
        historyPositionId = jsonData["historyPositionId"].stringValue
        latitudeValue = jsonData["latitudeValue"].doubleValue
        longitudeValue = jsonData["longitudeValue"].doubleValue
        positionName = jsonData["positionName"].stringValue
        type = jsonData["type"].stringValue
        updateDate = jsonData["updateDate"].stringValue
        signDate = jsonData["signDate"].stringValue
        
        statisticData = jsonData["statisticData"].arrayValue
    }
}

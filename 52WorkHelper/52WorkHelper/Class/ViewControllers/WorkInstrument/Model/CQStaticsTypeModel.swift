//
//  CQStaticsTypeModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/24.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQStaticsTypeModel: NSObject {

    //异常状态
    var attendanceAbnormal = ""
    //异常状态描述
    var attendanceAbnormalDesc = ""
    //打卡时间或者时间段描述
    var attendanceTime = ""
    //打卡类型
    var attendanceType = ""
    //星期几
    var dayOfWeek = ""
    //早退(分钟)
    var earlyTime = ""
    //主键
    var entityId = ""
    //迟到(分钟)
    var laterTime = ""
    //加班、请假时长(时)
    var overTime     = ""
    //签到、请假申请提交日期
    var recordDate = ""
    //签到类型（1,2,3）、请假（4）类型
    var recordType = ""
    //签到、请假类型描述
    var recordTypeDesc = ""
    //补卡说明
    var supplyAttendance = ""
    //休息天数
    var restDays = ""
    //外勤次数
    var outsideOfficeNumber = ""
    
    init?(jsonData: JSON) {
        
        
        attendanceAbnormal = jsonData["attendanceAbnormal"].stringValue
        attendanceAbnormalDesc = jsonData["attendanceAbnormalDesc"].stringValue
        attendanceTime = jsonData["attendanceTime"].stringValue
        attendanceType = jsonData["attendanceType"].stringValue
        dayOfWeek = jsonData["dayOfWeek"].stringValue
        earlyTime = jsonData["earlyTime"].stringValue
        entityId = jsonData["entityId"].stringValue
        laterTime = jsonData["laterTime"].stringValue
        overTime = jsonData["overTime"].stringValue
        recordDate = jsonData["recordDate"].stringValue
        recordType = jsonData["recordType"].stringValue
        recordTypeDesc = jsonData["recordTypeDesc"].stringValue
        supplyAttendance = jsonData["supplyAttendance"].stringValue
        restDays = jsonData["restDays"].stringValue
        outsideOfficeNumber = jsonData["outsideOfficeNumber"].stringValue
    }
}

//
//  CQStasticsModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/23.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQStasticsModel: NSObject {

    //缺勤次数
    var absenceFromDutyNumber = ""
    //旷工次数
    var absenteeismNumber = ""
    //出勤天数
    var attendanceWorkCountDays = ""
    //早退次数
    var earlyRetreatNumber = ""
    //早退时间(分钟)
    var earlyRetreatTime = ""
    //头像
    var headImage = ""
    //迟到次数
    var laterNumber = ""
    //迟到时间(分钟)
    var laterTime = ""
    //请假时长
    var leaveHour = ""
    //外勤次数
    var outsideOfficeNumber = ""
    //加班时间(时)
    var overTime = ""
    //真实姓名
    var realName = ""
    //休息天数
    var restDays = ""
    //补卡次数
    var supplyAttendanceNumber = ""
    
    init?(jsonData: JSON) {
        
        
        absenceFromDutyNumber = jsonData["absenceFromDutyNumber"].stringValue
        absenteeismNumber = jsonData["absenteeismNumber"].stringValue
        attendanceWorkCountDays = jsonData["attendanceWorkCountDays"].stringValue
        earlyRetreatNumber = jsonData["earlyRetreatNumber"].stringValue
        earlyRetreatTime = jsonData["earlyRetreatTime"].stringValue
        headImage = jsonData["headImage"].stringValue
        laterNumber = jsonData["laterNumber"].stringValue
        laterTime = jsonData["laterTime"].stringValue
        leaveHour = jsonData["leaveHour"].stringValue
        outsideOfficeNumber = jsonData["outsideOfficeNumber"].stringValue
        overTime = jsonData["overTime"].stringValue
        realName = jsonData["realName"].stringValue
        restDays = jsonData["restDays"].stringValue
        supplyAttendanceNumber = jsonData["supplyAttendanceNumber"].stringValue
        
    }
}

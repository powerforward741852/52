//
//  CQRankModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/24.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQRankModel: NSObject {

    
    //考勤记录主键
    var attendanceRecordId = ""
    //修改后的id
    var dayStatisticsRecordId = ""
    
    //考勤时间
    var attendanceTime = ""
    //员工部门
    var departmentName = ""
    //员工主键
    var emyeId = ""
    //头像
    var headImage = ""
    //点赞数量
    var likeCount = ""
    //点赞标志(true-是，false-否)
    var likeSign:Bool
    //真实姓名
    var realName = ""
    //排序值    
    var sort = ""
    var positionName = ""
    
    init?(jsonData: JSON) {
        positionName = jsonData["positionName"].stringValue
        dayStatisticsRecordId = jsonData["dayStatisticsRecordId"].stringValue
        attendanceRecordId = jsonData["attendanceRecordId"].stringValue
        attendanceTime = jsonData["attendanceTime"].stringValue
        departmentName = jsonData["departmentName"].stringValue
        emyeId = jsonData["emyeId"].stringValue
        headImage = jsonData["headImage"].stringValue
        likeCount = jsonData["likeCount"].stringValue
        likeSign = jsonData["likeSign"].boolValue
        realName = jsonData["realName"].stringValue
        sort = jsonData["sort"].stringValue
    }
}

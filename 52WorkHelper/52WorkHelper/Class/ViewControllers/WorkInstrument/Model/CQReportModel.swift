//
//  CQReportModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/13.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQReportModel: NSObject {

    //汇报发布人时间
    var createTime = ""
    //汇报发布人的用户头像地址
    var createUserHeadImage = ""
    //汇报发布人的用户id
    var createUserId = ""
    //汇报发布人的用户真实姓名
    var createUserRealName = ""
    //日报-已完成工作
    var hasdoWork = ""
    //需要的帮助与支持
    var needHelp = ""
    //下周/下月工作计划
    var nextWorkPlan = ""
    //汇报id
    var personnelReportId = ""
    //是否已读
    var readSign:Bool!
    //汇报类型
    var reportType = ""
    //日报-需要协调的工作
    var teamWork = ""
    //本周/本月工作内容
    var thisWorkContent = ""
    //本周/本月工作总结
    var thisWorkSummary = ""
    //日报-需要协调的工作
    var undoWork = ""

    //已完成日程详情
    var donePlanContentData:[JSON]
    //未完成日程详情
    var undoPlanContentData:[JSON]
    
    init?(jsonData: JSON) {
        
        
        createTime = jsonData["createTime"].stringValue
        createUserHeadImage = jsonData["createUserHeadImage"].stringValue
        createUserId = jsonData["createUserId"].stringValue
        createUserRealName = jsonData["createUserRealName"].stringValue
        hasdoWork = jsonData["hasdoWork"].stringValue
        needHelp = jsonData["needHelp"].stringValue
        nextWorkPlan = jsonData["nextWorkPlan"].stringValue
        personnelReportId = jsonData["personnelReportId"].stringValue
        readSign = jsonData["readSign"].boolValue
        reportType = jsonData["reportType"].stringValue
        teamWork = jsonData["teamWork"].stringValue
        thisWorkContent = jsonData["thisWorkContent"].stringValue
        thisWorkSummary = jsonData["thisWorkSummary"].stringValue
        undoWork = jsonData["undoWork"].stringValue
        donePlanContentData = jsonData["donePlanContentData"].arrayValue
        undoPlanContentData = jsonData["undoPlanContentData"].arrayValue
    }
}

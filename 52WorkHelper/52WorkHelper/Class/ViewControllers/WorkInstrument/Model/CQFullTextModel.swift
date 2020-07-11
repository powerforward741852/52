//
//  CQFullTextModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/13.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQFullTextModel: NSObject {

   
    //汇报发布人的用户头像地址
    var createUserHeadImage = ""
    //汇报发布人的用户id
    var createUserId = ""
    //汇报发布人的用户真实姓名
    var createUserRealName = ""
    //日报-已完成工作
    var hasdoWork = ""
    //是否创建者
    var isCreateUser = ""
    //需要的帮助与支持
    var needHelp = ""
    //下周/下月工作计划
    var nextWorkPlan = ""
    //汇报id
    var personnelReportId = ""
    //已读人数
    var readNum = ""
    //汇报类型
    var reportType = ""
    //日报-需要协调的工作
    var teamWork = ""
    //本周/本月工作内容
    var thisWorkContent = ""
    //本周/本月工作总结
    var thisWorkSummary = ""
    //未读人数
    var unReadNum = ""
    //日报-需要协调的工作
    var undoWork = ""
    //接收汇报人的用户头像地址
    var headImage = ""
    //接收汇报人的用户真实姓名
    var realName = ""
    //接收汇报人的用户id
    var userId = ""
    //创建日期
    var createTime = ""
    //附件id
    var attachmentId = ""
    //附件(原)文件名
    var attachmentOldName = ""
    //附件大小    
    var attachmentSize = ""
    //附件地址
    var attachmentPath = ""
    
    init?(jsonData: JSON) {
        
        
        createUserHeadImage = jsonData["createUserHeadImage"].stringValue
        createUserId = jsonData["createUserId"].stringValue
        createUserRealName = jsonData["createUserRealName"].stringValue
        hasdoWork = jsonData["hasdoWork"].stringValue
        isCreateUser = jsonData["isCreateUser"].stringValue
        needHelp = jsonData["needHelp"].stringValue
        nextWorkPlan = jsonData["nextWorkPlan"].stringValue
        personnelReportId = jsonData["personnelReportId"].stringValue
        readNum = jsonData["readNum"].stringValue
        reportType = jsonData["reportType"].stringValue
        teamWork = jsonData["teamWork"].stringValue
        thisWorkContent = jsonData["thisWorkContent"].stringValue
        thisWorkSummary = jsonData["thisWorkSummary"].stringValue
        unReadNum = jsonData["unReadNum"].stringValue
        undoWork = jsonData["undoWork"].stringValue
        headImage = jsonData["headImage"].stringValue
        realName = jsonData["realName"].stringValue
        userId = jsonData["userId"].stringValue
        createTime = jsonData["createTime"].stringValue
        attachmentId = jsonData["attachmentId"].stringValue
        attachmentOldName = jsonData["attachmentOldName"].stringValue
        attachmentSize = jsonData["attachmentSize"].stringValue
        attachmentPath = jsonData["attachmentPath"].stringValue
    }
}

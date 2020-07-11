//
//  CQTaskModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/29.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQTaskModel: NSObject {

    //任务发布人的用户头像地址
    var createUserHeadImage = ""
    //任务发布人的用户id
    var createUserId = ""
    //任务发布人的用户真实姓名
    var createUserRealName = ""
    //截止(过期)时间
    var deadLine = ""
    //任务状态
    var finishStatus = ""
    //任务id
    var personnelTaskId = ""
    //优先等级
    var priorityLevel = ""
    //任务名称    
    var taskName = ""
    //未完成的原因
    var undoReason = ""
    //任务发布人时间
    var createTime = ""
    //是否创建者
    var isCreateUser:Bool
    //任务内容
    var taskContent = ""
    //参与任务人员数组
    var userData:[JSON]
    var picurlData = [String]()
    
   
    
    
    init?(jsonData: JSON) {
        var temppic = [String]()
        for (_,val) in jsonData["picurlData"].arrayValue.enumerated(){
            temppic.append(val.stringValue)
        }
        picurlData  = temppic
        
        createUserHeadImage = jsonData["createUserHeadImage"].stringValue
        createUserId = jsonData["createUserId"].stringValue
        createUserRealName = jsonData["createUserRealName"].stringValue
        deadLine = jsonData["deadLine"].stringValue
        finishStatus = jsonData["finishStatus"].stringValue
        personnelTaskId = jsonData["personnelTaskId"].stringValue
        priorityLevel = jsonData["priorityLevel"].stringValue
        taskName = jsonData["taskName"].stringValue
        undoReason = jsonData["undoReason"].stringValue
        createTime = jsonData["createTime"].stringValue
        isCreateUser = jsonData["isCreateUser"].boolValue
        taskContent = jsonData["taskContent"].stringValue
        userData = jsonData["userData"].arrayValue
 
    }
    
}

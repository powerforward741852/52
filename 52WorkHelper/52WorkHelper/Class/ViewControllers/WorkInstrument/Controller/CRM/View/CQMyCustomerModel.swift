//
//  CQMyCustomerModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/8/6.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQMyCustomerModel: NSObject {
    //客户id
    var customerId = ""
    //最后跟进时间
    var lastFollowDate = ""
    //客户级别
    var level =  ""
    //客户信息来源
    var message = ""
    //客户名称
    var name = ""
    //负责人(客户经理)
    var principal = ""
    //
    
    
    
    //日程统计详情模型
    var status: String!
    var creater: String!
    var title: String!
    var endDate: String!
    var entityId: String!
    var startDate: String!
    
    init?(jsonData: JSON) {
        
        
        
        
        customerId = jsonData["customerId"].stringValue
        lastFollowDate = jsonData["lastFollowDate"].stringValue
        level = jsonData["level"].stringValue
        message = jsonData["message"].stringValue
        name = jsonData["name"].stringValue
        principal = jsonData["principal"].stringValue

        
        //日程统计模型
        status = jsonData["status"].stringValue
        creater = jsonData["creater"].stringValue
        title = jsonData["title"].stringValue
        endDate = jsonData["endDate"].stringValue
        entityId = jsonData["entityId"].stringValue
        startDate = jsonData["startDate"].stringValue
    }
    
}

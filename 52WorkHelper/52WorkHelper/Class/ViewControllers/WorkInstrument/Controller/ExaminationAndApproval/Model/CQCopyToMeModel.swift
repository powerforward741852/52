//
//  CQCopyToMeModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/20.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQCopyToMeModel: NSObject {

    //业务申请主键
    var entityId = ""
    //头像
    var headImage = ""
    //开始日期(yyyy-MM-dd)
    var startTime = ""
    
    //结束日期(yyyy-MM-dd)
    var endTime = ""
    //申请全称
    var nameApply = ""
    //是否已读(true-已读，false-未读)
    var readSign:Bool
    
    init?(jsonData: JSON) {
        
        
        entityId = jsonData["entityId"].stringValue
        headImage = jsonData["headImage"].stringValue
        startTime = jsonData["startTime"].stringValue
        endTime = jsonData["endTime"].stringValue
        nameApply = jsonData["nameApply"].stringValue
        readSign = jsonData["readSign"].boolValue
        
    }
    
}

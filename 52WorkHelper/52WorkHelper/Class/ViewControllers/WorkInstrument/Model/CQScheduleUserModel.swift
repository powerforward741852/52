//
//  CQScheduleUserModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/13.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQScheduleUserModel: NSObject {

    //是否同意
    var agreeSign = ""
    //同意或不同意时间
    var agreeYesOrNoTime = ""
    //参与日程人员的用户头像地址
    var headImage = ""
    //参与日程人员的用户真实姓名
    var realName = ""
    //不同意原因
    var unagreeReason = ""
    //参与日程人员的用户id    
    var userId = ""
    
    init?(jsonData: JSON) {
        
        
        agreeSign = jsonData["agreeSign"].stringValue
        agreeYesOrNoTime = jsonData["agreeYesOrNoTime"].stringValue
        headImage = jsonData["headImage"].stringValue
        realName = jsonData["realName"].stringValue
        unagreeReason = jsonData["unagreeReason"].stringValue
        userId = jsonData["userId"].stringValue
        
    }
}

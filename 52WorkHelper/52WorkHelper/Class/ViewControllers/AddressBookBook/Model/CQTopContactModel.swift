//
//  CQTopContactModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/14.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQTopContactModel: NSObject {

    //部门id
    var departmentId = ""
    //部门名称
    var departmentName = ""
    //    用户头像地址
    var headImage = ""
    //    职位id
    var positionId = ""
    //    职位名称
    var positionName = ""
    //    用户真实姓名
    var realName = ""
    //    用户id
    var userId = ""
    
    
    init?(jsonData: JSON) {
        
        departmentId = jsonData["departmentId"].stringValue
        departmentName = jsonData["departmentName"].stringValue
        headImage = jsonData["headImage"].stringValue
        positionId = jsonData["positionId"].stringValue
        positionName = jsonData["positionName"].stringValue
        realName = jsonData["realName"].stringValue
        userId = jsonData["userId"].stringValue
    }
}

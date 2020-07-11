//
//  CQExaModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/30.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQExaModel: NSObject {

    //图标路径
    var businessIcon = ""
    //业务名称
    var businessName = ""
    //员工主键
    var entityId = ""
    //
    var businessCode = ""
    
    init?(jsonData: JSON) {
        
        
        businessIcon = jsonData["businessIcon"].stringValue
        businessName = jsonData["businessName"].stringValue
        entityId = jsonData["entityId"].stringValue
        businessCode = jsonData["businessCode"].stringValue
    }
}

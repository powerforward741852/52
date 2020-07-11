//
//  CQFilterApplyModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/7/9.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQFilterApplyModel: NSObject {

    
    //业务申请主键
    var businessName = ""
    //状态描述
    var entityId = ""
  
    
    init?(jsonData: JSON) {
        
        
        businessName = jsonData["businessName"].stringValue
        entityId = jsonData["entityId"].stringValue
        
    }
    
}

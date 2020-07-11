//
//  CQCardApplyListModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/25.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQCardApplyListModel: NSObject {

    
    //业务申请主键
    var businessApplyId = ""
    //状态描述
    var statusDesc = ""
    //申请通过日期
    var updateDate = ""
    
    init?(jsonData: JSON) {
        
        
        businessApplyId = jsonData["businessApplyId"].stringValue
        statusDesc = jsonData["statusDesc"].stringValue
        updateDate = jsonData["updateDate"].stringValue
       
    }
    
}

//
//  CQMyApplyListModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/20.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQMyApplyListModel: NSObject {

    //申请全名
    var applyName = ""
    //业务申请主键
    var businessApplyId = ""
    //审批状态    
    var statusDesc = ""
   
    //提交时间
    var updateDate = ""
    
    
    init?(jsonData: JSON) {
        
        
        applyName = jsonData["applyName"].stringValue
        businessApplyId = jsonData["businessApplyId"].stringValue
        statusDesc = jsonData["statusDesc"].stringValue
        updateDate = jsonData["updateDate"].stringValue
    }
}

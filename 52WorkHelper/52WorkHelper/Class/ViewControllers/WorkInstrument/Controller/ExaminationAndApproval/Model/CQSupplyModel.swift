//
//  CQSupplyModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/30.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQSupplyModel: NSObject {

    //审批人列表
    var approvalFlowPersonUnitJsonList:[JSON]
    //抄送人列表
    var copyFlowPersonUnitJsonList:[JSON]
    //表单主键
    var businessFormId = ""
    //表单内容
    var formContent = ""

    

    init?(jsonData: JSON) {
        
        
        approvalFlowPersonUnitJsonList = jsonData["approvalFlowPersonUnitJsonList"].arrayValue
        copyFlowPersonUnitJsonList = jsonData["copyFlowPersonUnitJsonList"].arrayValue
        businessFormId = jsonData["businessFormId"].stringValue
        formContent = jsonData["formContent"].stringValue

    }
}

//
//  CQMyApplyFormatModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/21.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQMyApplyFormatModel: NSObject {

    //申请状态码(0-审核中，1-审核通过，2-被驳回，3-已撤销，4-已销假(请假申请))
    var applyStatusCode = ""
    //审批状态列表
    var approverList:[JSON]
    //表单主键
    var businessCode = ""
    //业务名称
    var businessName = ""
    //部门名称
    var departmentName = ""
    //
    var copyPersonList:[JSON]
    //formContent的json
    var formContent = ""
    //formData的json
    var formData = ""
    //
    var headImage = ""
    //申请状态描述
    var statusDesc = ""
    //出差总天数
    var totalDuration = ""
    //出差总时长
    var totalTravelDays = ""
    
    //approvalBusinessId
    var approvalBusinessId = ""
    //
    var vacationUnitDesc = ""
    
    init?(jsonData: JSON) {
        
        
        applyStatusCode = jsonData["applyStatusCode"].stringValue
        approverList = jsonData["approverList"].arrayValue
        businessCode = jsonData["businessCode"].stringValue
        businessName = jsonData["businessName"].stringValue
        copyPersonList = jsonData["copyPersonList"].arrayValue
        departmentName = jsonData["departmentName"].stringValue
        formContent = jsonData["formContent"].stringValue
        formData = jsonData["formData"].stringValue
        headImage = jsonData["headImage"].stringValue
        statusDesc = jsonData["statusDesc"].stringValue
        totalDuration = jsonData["totalDuration"].stringValue
        totalTravelDays = jsonData["totalTravelDays"].stringValue
        approvalBusinessId = jsonData["approvalBusinessId"].stringValue
        vacationUnitDesc = jsonData["vacationUnitDesc"].stringValue
    }
    
}

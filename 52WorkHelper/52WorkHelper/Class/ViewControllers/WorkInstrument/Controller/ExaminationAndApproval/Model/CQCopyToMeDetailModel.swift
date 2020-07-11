//
//  CQCopyToMeDetailModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/21.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQCopyToMeDetailModel: NSObject {

    //申请状态码(0-审核中，1-审核通过，2-被驳回，3-已撤销，4-已销假(请假申请))
    var applyStatusCode = ""
    //审批状态列表
    var approverList:[JSON]
    //表单主键
    var businessCode = ""
    //部门名称
    var departmentName = ""
    //formContent的json
    var formContent = ""
    //formData的json
    var formData = ""
    //
    var headImage = ""
    //职位名称
    var positionName = ""
    //申请人姓名
    var realName = ""
    //提交时间    
    var submitTime = ""
    var vacationUnitDesc = ""
    
    init?(jsonData: JSON) {
        
        
        applyStatusCode = jsonData["applyStatusCode"].stringValue
        approverList = jsonData["approverList"].arrayValue
        businessCode = jsonData["businessCode"].stringValue
        departmentName = jsonData["departmentName"].stringValue
        formContent = jsonData["formContent"].stringValue
        formData = jsonData["formData"].stringValue
        headImage = jsonData["headImage"].stringValue
        positionName = jsonData["positionName"].stringValue
        realName = jsonData["realName"].stringValue
        submitTime = jsonData["submitTime"].stringValue
        vacationUnitDesc = jsonData["vacationUnitDesc"].stringValue
    }
    
}

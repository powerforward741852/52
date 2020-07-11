//
//  CQNeedMeAgreeModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/30.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQNeedMeAgreeModel: NSObject {

    //审批结果，true-同意，false-驳回
    var approvalResult = ""
    //审批状态描述
    var approvalResultDesc = ""
    //审批意见
    var approvalResultRemark = ""
    //业务申请主键
    var entityId = ""
    //申请人头像
    var headImage = ""
    //申请全名(xxx的xxx申请)
    var nameApply = ""
    
    //审批时间
    var approveTime = ""
    
    //上传时间
    var updateDate = ""
    
    init?(jsonData: JSON) {
        
        
        approvalResult = jsonData["approvalResult"].stringValue
        approvalResultDesc = jsonData["approvalResultDesc"].stringValue
        approvalResultRemark = jsonData["approvalResultRemark"].stringValue
        entityId = jsonData["entityId"].stringValue
        headImage = jsonData["headImage"].stringValue
        nameApply = jsonData["nameApply"].stringValue
        approveTime = jsonData["approveTime"].stringValue
        updateDate = jsonData["updateDate"].stringValue
    }
    
}

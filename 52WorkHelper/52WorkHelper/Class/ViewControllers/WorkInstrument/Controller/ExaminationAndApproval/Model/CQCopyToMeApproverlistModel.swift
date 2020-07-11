//
//  CQCopyToMeApproverlistModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/21.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQCopyToMeApproverlistModel: NSObject {

    //审批结果描述
    var approvalResult = ""
    //审批时间
    var approveTime = ""
    //审批人头像
    var headImage = ""
    //审批人姓名
    var realName = ""
    //审批状态
    var approvalResultRemark = ""
    //主键
    var entity = ""
    
    init?(jsonData: JSON) {
        
        
        approvalResult = jsonData["approvalResult"].stringValue
        approveTime = jsonData["approveTime"].stringValue
        headImage = jsonData["headImage"].stringValue
        realName = jsonData["realName"].stringValue
        entity = jsonData["entity"].stringValue
        approvalResultRemark = jsonData["approvalResultRemark"].stringValue
    }
}

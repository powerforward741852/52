//
//  QRBusinessModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/6.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRBusinessModel: NSObject {

    //商机名字
    var businessName = ""
    //预计结单时间
    var closeDate = ""
    //主键
    var entityId = ""
    //预计金额
    var estimatedAmount = ""
    //重要程度 0：重要 1：普通
    var importance = -1
    //客户名称
    var name = ""
    //客户负责人
    var personInCharge = ""
    //销售阶段
    var salesStage = ""

    
    init?(jsonData : JSON) {
        businessName = jsonData["businessName"].stringValue
        closeDate = jsonData["closeDate"].stringValue
        entityId = jsonData["entityId"].stringValue
        estimatedAmount = jsonData["estimatedAmount"].stringValue
        importance = jsonData["importance"].intValue
        name = jsonData["name"].stringValue
        personInCharge = jsonData["personInCharge"].stringValue
        salesStage = jsonData["salesStage"].stringValue
    }
    
}

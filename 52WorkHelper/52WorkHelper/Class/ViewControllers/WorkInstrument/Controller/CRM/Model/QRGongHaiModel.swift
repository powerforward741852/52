//
//  QRGongHaiModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/16.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRGongHaiModel: NSObject {
    
    //客户id
    var customerId = ""
    //最后跟进时间
    var lastFollowDate = ""
    //跟进级别
    var level = ""
    //客户信息
    var message = ""
    //客户名称
    var name = ""
    //负责人
    var principal = ""
    
    init?(jsonData: JSON) {
        customerId = jsonData["customerId"].stringValue
        lastFollowDate = jsonData["lastFollowDate"].stringValue
        level = jsonData["level"].stringValue
        message = jsonData["message"].stringValue
        name = jsonData["name"].stringValue
        principal = jsonData["principal"].stringValue
}
}

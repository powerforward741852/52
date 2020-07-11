//
//  CQAddressModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/13.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQAddressModel: NSObject {

    //地址
    var address = ""
    // 联系人
    var contactName = ""
    // 地址主键
    var entityId = ""
    //地址详情
    var addressDetails = ""
    //地址邮编
    var cityCode = ""
    //手机号
    var mobilePhone = ""
    //
    var addressCity = ""
    init?(jsonData: JSON) {
        
        address = jsonData["address"].stringValue
        contactName = jsonData["contactName"].stringValue
        entityId = jsonData["entityId"].stringValue
        addressDetails = jsonData["addressDetails"].stringValue
        cityCode = jsonData["cityCode"].stringValue
        mobilePhone = jsonData["mobilePhone"].stringValue
        addressCity = jsonData["addressCity"].stringValue
        
        
    }
}

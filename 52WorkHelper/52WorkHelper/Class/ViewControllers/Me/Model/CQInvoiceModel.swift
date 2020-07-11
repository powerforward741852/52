//
//  CQInvoiceModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/13.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQInvoiceModel: NSObject {

    
    //主键
    var entityId = ""
    //名称
    var invoiceName = ""
    //发票类型(1-个人，2-单位)
    var invoiceType = ""
    //类型描述
    var invoiceTypeDesc = ""
    //开户银行
    var accountBank = ""
    //   开户账号
    var accountNumber = ""
    //单位地址
    var companyAddress = ""
    //税号
    var invoiceNumber = ""
    //电话
    var phoneNumber = ""
    
    init?(jsonData: JSON) {

        entityId = jsonData["entityId"].stringValue
        invoiceName = jsonData["invoiceName"].stringValue
        invoiceType = jsonData["invoiceType"].stringValue
        invoiceTypeDesc = jsonData["invoiceTypeDesc"].stringValue
        accountBank = jsonData["accountBank"].stringValue
        accountNumber = jsonData["accountNumber"].stringValue
        companyAddress = jsonData["companyAddress"].stringValue
        invoiceNumber = jsonData["invoiceNumber"].stringValue
        phoneNumber = jsonData["phoneNumber"].stringValue
    }
}

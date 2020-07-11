//
//  CQBussinessCardListModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2019/1/11.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class CQBussinessCardListModel: NSObject {

    //名片列表
    //名片ID
    var cardId = ""
    //公司
    var company = ""
    //正面照片
    var frontPhoto = ""
    //职位
    var position = ""
    //姓名
    var realName = ""
    //备注
    var remark = ""
    
    //名片详情
    //背面照片
    var backPhoto = ""
    //部门
    var department:[JSON]
    //地址
    var address:[JSON]
    //邮箱
    var email:[JSON]
    //手机
    var mobile:[JSON]
    //电话
    var phone:[JSON]
    //职位
    var positionArr:[JSON]
    //网址
    var website:[JSON]
    //公司
    var companyArr:[JSON]
    
    var autoSave : Bool = true
    
    
    init?(jsonData: JSON) {
        cardId = jsonData["cardId"].stringValue
        company = jsonData["company"].stringValue
        frontPhoto = jsonData["frontPhoto"].stringValue
        position = jsonData["position"].stringValue
        realName = jsonData["realName"].stringValue
        remark = jsonData["remark"].stringValue
        autoSave = jsonData["autoSave"].boolValue
        
        backPhoto = jsonData["backPhoto"].stringValue
        department = jsonData["department"].arrayValue
        address = jsonData["address"].arrayValue
        email = jsonData["email"].arrayValue
        mobile = jsonData["mobile"].arrayValue
        phone = jsonData["phone"].arrayValue
        positionArr = jsonData["position"].arrayValue
        website = jsonData["website"].arrayValue
        companyArr = jsonData["company"].arrayValue
    }

}

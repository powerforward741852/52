//
//  QRContactModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/19.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRContactModel: NSObject {
    //邮箱
    var email = ""
    //联系人
    var linkName = ""
    //联系人电话
    var linkPhone = ""
    //联系人id
    var linkmanId = ""
    //座机
    var officePhone = ""
    //职务
    var position = ""
    //备注
    var remark = ""
    //性别
    var sex = "0"
    
    
    init?(jsonData: JSON) {
        email = jsonData["email"].stringValue
        linkName = jsonData["linkName"].stringValue
        linkPhone = jsonData["linkPhone"].stringValue
        linkmanId = jsonData["linkmanId"].stringValue
        officePhone = jsonData["officePhone"].stringValue
        position = jsonData["position"].stringValue
        remark = jsonData["remark"].stringValue
        sex = jsonData["sex"].stringValue
    }
    
    override init() {
        super.init()
    }
    
}

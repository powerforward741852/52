//
//  CQPersonInfoMationModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/2.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQPersonInfoMationModel: NSObject {

    //部门id
    var departmentId = ""
    //部门名称
    var departmentName = ""
    //邮箱
    var eMail = ""
    //用户性别
    var employeeSex = ""
    //    用户头像地址
    var headImage = ""
    //固定电话
    var phoneNumber = ""
    //    职位id
    var positionId = ""
    //    职位名称
    var positionName = ""
    //通讯地址
    var postalAddress = ""
    //    用户真实姓名
    var realName = ""
    //用户名（手机号）
    var userName = ""
    //    工号
    var workNumber = ""
    
    
    init?(jsonData: JSON) {
        
        departmentId = jsonData["departmentId"].stringValue
        departmentName = jsonData["departmentName"].stringValue
        eMail = jsonData["eMail"].stringValue
        employeeSex = jsonData["employeeSex"].stringValue
        headImage = jsonData["headImage"].stringValue
        phoneNumber = jsonData["phoneNumber"].stringValue
        positionId = jsonData["positionId"].stringValue
        positionName = jsonData["positionName"].stringValue
        postalAddress = jsonData["postalAddress"].stringValue
        realName = jsonData["realName"].stringValue
        userName = jsonData["userName"].stringValue
        workNumber = jsonData["workNumber"].stringValue
    }
}

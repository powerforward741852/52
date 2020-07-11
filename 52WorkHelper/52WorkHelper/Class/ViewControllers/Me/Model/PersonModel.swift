//
//  PersonModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/11.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class PersonModel: NSObject {

    //部门名称
    var departmentName = ""
    //        员工性别(男，女)
    var employeeSex = ""
    //        头像
    var headImage = ""
    //    职位名称
    var positionName = ""
    //    用户真实姓名
    var realName = ""

    //邮箱
    var eMail = ""
    //通讯地址
    var postalAddress = ""
    //员工主键
    var emyeId = ""
    //    电话
    var phoneNumber = ""
    //qq
    var qqNumber = ""
    //微信号
    var wechatNumber = ""
    //微信图片路径
    var wechatPic = ""
    //个人说明
    var personalStatement = ""
    //    工号
    var workNumber = ""
    // 手机
    var userName = ""
    // 验证码发送时间
    var sendtime = ""
    //验证码
    var verifyCode = ""
    
    //帮助主键
    var entityId = ""
    //帮助标题
    var articleTitle = ""
    
    //生日
     var birthDate = ""
    //农历还是公历
    var birthDateType = ""
    
    init?(jsonData: JSON) {
        birthDateType = jsonData["birthDateType"].stringValue
        birthDate = jsonData["birthDate"].stringValue
        departmentName = jsonData["departmentName"].stringValue
        headImage = jsonData["headImage"].stringValue
        positionName = jsonData["positionName"].stringValue
        realName = jsonData["realName"].stringValue
        employeeSex = jsonData["employeeSex"].stringValue
        
        eMail = jsonData["eMail"].stringValue
        postalAddress = jsonData["postalAddress"].stringValue
        emyeId = jsonData["emyeId"].stringValue
        phoneNumber = jsonData["phoneNumber"].stringValue
        workNumber = jsonData["workNumber"].stringValue
        userName = jsonData["userName"].stringValue
        
        qqNumber = jsonData["qqNumber"].stringValue
        wechatNumber = jsonData["wechatNumber"].stringValue
        wechatPic = jsonData["wechatPic"].stringValue
        personalStatement = jsonData["personalStatement"].stringValue
        
        entityId = jsonData["entityId"].stringValue
        articleTitle = jsonData["articleTitle"].stringValue
    }
}

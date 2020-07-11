//
//  CQLoginUser.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/4/28.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQLoginUser: NSObject,NSCoding {

    
    //用户token
    var token = ""
    //用户ID
    var userID = ""
    //手机号
    var userName = ""
    //用户名称
    var realName = ""
    //用户头像
    var headImage = ""
    //通知名称
    var noticeUseName = ""
    //通知图标
    var noticeUserHeadImg = ""
    //通知id
    var noticeUserId = ""
    // 是否有下级员工
    var isSubordinate = "false"
    
    var crmUser = "false"
    //未完成工作
//    var untreatedWorkUseName = ""
    //未完成图标
//    var untreatedWorkUserHeadImg = ""
    //未完成id
//    var untreatedWorkUserId = ""
    
    //系统通知
//    var systemUseName = ""
    //系统通知图标
//    var systemUserHeadImg = ""
    //系统通知id
//    var systemUserId = ""
     var departmentId = ""
    
    
    init?(jsonData: JSON) {
        
        crmUser = jsonData["crmUser"].stringValue
        departmentId = jsonData["departmentId"].stringValue
        isSubordinate = jsonData["isSubordinate"].stringValue
        token = jsonData["token"].stringValue
        userID = jsonData["userId"].stringValue
        userName = jsonData["userName"].stringValue
        realName = jsonData["realName"].stringValue
        headImage = jsonData["headImage"].stringValue
        
        noticeUserHeadImg = jsonData["noticeUserHeadImg"].stringValue
        noticeUseName = jsonData["noticeUseName"].stringValue
        noticeUserId = jsonData["noticeUserId"].stringValue
        
//        systemUseName = jsonData["systemUseName"].stringValue
//        systemUserHeadImg = jsonData["systemUserHeadImg"].stringValue
//        systemUserId = jsonData["systemUserId"].stringValue
        
//        untreatedWorkUseName = jsonData["untreatedWorkUseName"].stringValue
//        untreatedWorkUserHeadImg = jsonData["untreatedWorkUserHeadImg"].stringValue
//        untreatedWorkUserId = jsonData["untreatedWorkUserId"].stringValue
        
        
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
        
        if aDecoder.decodeObject(forKey: "isSubordinate") == nil{
          
            isSubordinate = "false"
        }else{
            isSubordinate = (aDecoder.decodeObject(forKey: "isSubordinate") as! String )
        }
        
        if aDecoder.decodeObject(forKey: "crmUser") == nil{

            crmUser = "false"
        }else{
            crmUser = (aDecoder.decodeObject(forKey: "crmUser") as! String  )
        }
        
        if aDecoder.decodeObject(forKey: "departmentId") == nil{
            departmentId = "39"
        }else{
            departmentId = (aDecoder.decodeObject(forKey: "departmentId") as! String  )
        }
        
       // departmentId = aDecoder.decodeObject(forKey: "departmentId") as! String
        
        token = aDecoder.decodeObject(forKey: "token") as! String
        userID = aDecoder.decodeObject(forKey: "id") as! String
        userName = aDecoder.decodeObject(forKey: "userName") as! String
        realName = aDecoder.decodeObject(forKey: "realName") as! String
        headImage = aDecoder.decodeObject(forKey: "headImage") as! String
        
        noticeUseName = aDecoder.decodeObject(forKey: "noticeUseName") as! String
        noticeUserHeadImg = aDecoder.decodeObject(forKey: "noticeUserHeadImg") as! String
        noticeUserId = aDecoder.decodeObject(forKey: "noticeUserId") as! String
        
//        systemUseName = aDecoder.decodeObject(forKey: "systemUseName") as! String
//        systemUserHeadImg = aDecoder.decodeObject(forKey: "systemUserHeadImg") as! String
//        systemUserId = aDecoder.decodeObject(forKey: "systemUserId") as! String
        
//        untreatedWorkUseName = aDecoder.decodeObject(forKey: "untreatedWorkUseName") as! String
//        untreatedWorkUserHeadImg = aDecoder.decodeObject(forKey: "untreatedWorkUserHeadImg") as! String
//        untreatedWorkUserId = aDecoder.decodeObject(forKey: "untreatedWorkUserId") as! String
        
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(realName, forKey: "departmentId")
        aCoder.encode(isSubordinate, forKey: "isSubordinate")
        aCoder.encode(crmUser, forKey: "crmUser")
        aCoder.encode(userID, forKey: "id")
        aCoder.encode(userName, forKey: "userName")
        aCoder.encode(realName, forKey: "realName")
        aCoder.encode(headImage, forKey: "headImage")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(noticeUseName, forKey: "noticeUseName")
        aCoder.encode(noticeUserHeadImg, forKey: "noticeUserHeadImg")
        aCoder.encode(noticeUserId, forKey: "noticeUserId")
//        aCoder.encode(systemUseName, forKey: "systemUseName")
//        aCoder.encode(systemUserHeadImg, forKey: "systemUserHeadImg")
//        aCoder.encode(systemUserId, forKey: "systemUserId")
//        aCoder.encode(untreatedWorkUseName, forKey: "untreatedWorkUseName")
//        aCoder.encode(untreatedWorkUserHeadImg, forKey: "untreatedWorkUserHeadImg")
//        aCoder.encode(untreatedWorkUserId, forKey: "untreatedWorkUserId")
     
        
    }
}

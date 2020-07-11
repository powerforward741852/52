//
//  CQDepartMentUserListModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/11.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQDepartMentUserListModel: NSObject,NSCoding {

    
    //部门id
    var departmentId = ""
    //部门名称
    var departmentName = ""
    //    用户头像地址
    var headImage = ""
    //    职位id
    var positionId = ""
    //    职位名称
    var positionName = ""
    //    用户真实姓名
    var realName = ""
    //    用户id
    var userId = ""
    
    //
    var approverId = ""
    var userName = ""
    var url = ""
    var name = ""
    var entityId = ""
    
    init?(jsonData: JSON) {
        userName = jsonData["userName"].stringValue
        departmentId = jsonData["departmentId"].stringValue
        departmentName = jsonData["departmentName"].stringValue
        headImage = jsonData["headImage"].stringValue
        positionId = jsonData["positionId"].stringValue
        positionName = jsonData["positionName"].stringValue
        realName = jsonData["realName"].stringValue
        userId = jsonData["userId"].stringValue
        approverId = jsonData["approverId"].stringValue
        url = jsonData["url"].stringValue
        name = jsonData["name"].stringValue
        entityId = jsonData["entityId"].stringValue
    }
    
    init(uId:String,realN:String,headImag:String) {
        self.userId = uId
        self.realName = realN
        self.headImage = headImag
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
        departmentId = aDecoder.decodeObject(forKey: "departmentId") as! String
        departmentName = aDecoder.decodeObject(forKey: "departmentName") as! String
        headImage = aDecoder.decodeObject(forKey: "headImage") as! String
        
        positionId = aDecoder.decodeObject(forKey: "positionId") as! String
        positionName = aDecoder.decodeObject(forKey: "positionName") as! String
        realName = aDecoder.decodeObject(forKey: "realName") as! String
        userId = aDecoder.decodeObject(forKey: "userId") as! String
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(departmentId, forKey: "departmentId")
        aCoder.encode(departmentName, forKey: "departmentName")
        aCoder.encode(headImage, forKey: "headImage")
        aCoder.encode(positionId, forKey: "positionId")
        aCoder.encode(positionName, forKey: "positionName")
        aCoder.encode(realName, forKey: "realName")
        aCoder.encode(userId, forKey: "userId")
        
    }
    
}

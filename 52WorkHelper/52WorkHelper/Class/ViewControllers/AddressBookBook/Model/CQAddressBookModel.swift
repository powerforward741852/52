//
//  CQAddressBookModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/11.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQAddressBookModel: NSObject {

    //部门id
    var departmentId = ""
    //部门名称
    var departmentName = ""
    //    部门拥有的员工数量
    var haveUserNum = ""
    
    //子部门id
    var childDepartmentId = ""
    //子部门名称
    var childDepartmentName = ""
    //子部门拥有的员工数
    var childDepartmentHaveUserNum = ""
    
    var name = ""
    var entityId = ""
    
    
    init?(jsonData: JSON) {
        
        departmentId = jsonData["departmentId"].stringValue
        departmentName = jsonData["departmentName"].stringValue
        haveUserNum = jsonData["haveUserNum"].stringValue
        childDepartmentId = jsonData["childDepartmentId"].stringValue
        childDepartmentName = jsonData["childDepartmentName"].stringValue
        childDepartmentHaveUserNum = jsonData["childDepartmentHaveUserNum"].stringValue
        name = jsonData["name"].stringValue
        entityId = jsonData["entityId"].stringValue
    }
    
    init?(name:String,dId:String){
        departmentId = dId
        departmentName = name
    }
    
}

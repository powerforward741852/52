//
//  CQDepartmnetModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/11.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQDepartmnetModel: NSObject {

    
    //部门拥有的子部门列表
    var childDepartmentData: [JSON]
    //部门拥有的员工列表
    var userData:[JSON]
    
    init?(jsonData: JSON) {
        
        childDepartmentData = jsonData["childDepartmentData"].arrayValue
        
        userData = jsonData["userData"].arrayValue
    }
}

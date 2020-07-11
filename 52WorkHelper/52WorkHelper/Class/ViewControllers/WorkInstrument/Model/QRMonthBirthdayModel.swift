//
//  QRMonthBirthdayModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/5/31.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class QRMonthBirthdayModel : NSObject {
    var dateStr = ""
    var employees = [QREmployeesModel]()
    init?(jsonData: JSON) {
        dateStr = jsonData["dateStr"].stringValue
        
        var tempEmployees = [QREmployeesModel]()
        for employee in jsonData["employees"].arrayValue{
            let mod = QREmployeesModel(jsonData: employee)
            tempEmployees.append(mod!)
        }
        employees = tempEmployees
    }
}
class QREmployeesModel : NSObject {
    var employeeSex = ""
    var id = ""
    var headImage = ""
    var realName = ""
    var userName = ""
    var workNumber = ""
    init?(jsonData: JSON) {
        employeeSex = jsonData["employeeSex"].stringValue
        id = jsonData["id"].stringValue
        headImage = jsonData["headImage"].stringValue
        userName = jsonData["userName"].stringValue
        realName = jsonData["realName"].stringValue
        workNumber = jsonData["workNumber"].stringValue
    }
   
    init(uId:String,realN:String,headImag:String) {
        self.id = uId
        self.realName = realN
        self.headImage = headImag
    }
}

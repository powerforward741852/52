//
//  QRCardInfoModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/1/21.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRCardInfoModel: NSObject {
    var address: [String]!
    var mobile: [String]!
    var phone: [String]!
    var position: [String]!
    var company: [String]!
    var email: [String]!
    var website: [String]!
    var department: [String]!
    var remark: String!
    var realName: String!
    var backPhoto: String!
    var frontPhoto: String!
    var cardId = ""
    var autoSave = true
    var backImg: UIImage?
    var frontImg: UIImage?
    
    init?(jsonData: JSON) {
        autoSave = jsonData["autoSave"].boolValue
        cardId = jsonData["cardId"].stringValue
        remark = jsonData["remark"].stringValue
        realName = jsonData["realName"].stringValue
        frontPhoto = jsonData["frontPhoto"].stringValue
        backPhoto = jsonData["backPhoto"].stringValue
        var tempAddress = [String]()
        for xx in jsonData["address"].arrayValue {
            let str = xx.stringValue
            tempAddress.append(str)
        }
        self.address = tempAddress
        
        var tempMobile = [String]()
        for xx in jsonData["mobile"].arrayValue {
            let str = xx.stringValue
            tempMobile.append(str)
        }
        self.mobile = tempMobile
        
        var tempPhone = [String]()
        for xx in jsonData["phone"].arrayValue {
            let str = xx.stringValue
            tempPhone.append(str)
        }
        self.phone = tempPhone
        
        var tempPosition = [String]()
        for xx in jsonData["position"].arrayValue {
            let str = xx.stringValue
            tempPosition.append(str)
        }
        self.position = tempPosition
        
        var tempCompany = [String]()
        for xx in jsonData["company"].arrayValue {
            let str = xx.stringValue
            tempCompany.append(str)
        }
        self.company = tempCompany
        
        var tempEmail = [String]()
        for xx in jsonData["email"].arrayValue {
            let str = xx.stringValue
            tempEmail.append(str)
        }
        self.email = tempEmail
        
        
        var tempWebsite = [String]()
        for xx in jsonData["websit"].arrayValue {
            let str = xx.stringValue
            tempWebsite.append(str)
        }
        self.website = tempWebsite
        
        var tempDepartment = [String]()
        for xx in jsonData["department"].arrayValue {
            let str = xx.stringValue
            tempDepartment.append(str)
        }
        self.department = tempDepartment
    }
    
    
    override init() {
        super.init()
    }
    
    init(realName:String,posit:[String],comp:[String],icon:String,cardId:String) {
        self.realName = realName
        self.position = posit
        self.company = comp
        self.frontPhoto = icon
        self.cardId = cardId
    }
}


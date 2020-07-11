//
//  QRKeHuModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/23.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRKeHuModel: NSObject {
    
    var province: String = ""
    
    var creator: String!
    var creatorId :String!
    var principalHeadImage :String!
    var principal: String!
    var principalId: String!
    var creatorHeadImage :String!
    
    var customerId: String!
    var contractNum: String!
    var city: String!

    var followRecordNum: String!
    var sampleAreaNum: String!
    var trade: String!
    var isSubordinates: String!
    var name: String!
    var level: String!
    var message: String!
    var area: String!
    var lastFollowDate: String!
    var createDate: String!
    var businessNum: String!
    var address: String!

    var crmLinkmans = [QRContactModel]()
    var userData = [QRGonghaiGenjinModel]()
    
    init?(jsonData: JSON) {
        province = jsonData["province"].stringValue
        creator = jsonData["creator"].stringValue
        principal = jsonData["principal"].stringValue
        creatorId = jsonData["creatorId"].stringValue
        principalId = jsonData["principalId"].stringValue
        creatorHeadImage = jsonData["creatorHeadImage"].stringValue
        principalHeadImage = jsonData["principalHeadImage"].stringValue
        customerId = jsonData["customerId"].stringValue
        contractNum = jsonData["contractNum"].stringValue
        city = jsonData["city"].stringValue
        followRecordNum = jsonData["followRecordNum"].stringValue
        sampleAreaNum = jsonData["sampleAreaNum"].stringValue
        trade = jsonData["trade"].stringValue
        isSubordinates = jsonData["isSubordinates"].stringValue
        name = jsonData["name"].stringValue
        level = jsonData["level"].stringValue
        message = jsonData["message"].stringValue
        area = jsonData["area"].stringValue
        lastFollowDate = jsonData["lastFollowDate"].stringValue
        createDate = jsonData["createDate"].stringValue
        businessNum = jsonData["businessNum"].stringValue
        address = jsonData["address"].stringValue
  
            var tempLink = [QRContactModel]()
        for xx in jsonData["crmLinkmans"].arrayValue {
            let mod = QRContactModel(jsonData: xx)
            tempLink.append(mod!)
        }
            self.crmLinkmans = tempLink
        
        var tempfollow = [QRGonghaiGenjinModel]()
        for xx in jsonData["userData"].arrayValue {
            let mod = QRGonghaiGenjinModel(jsonData: xx)
            tempfollow.append(mod!)
        }
        self.userData = tempfollow
        
    }
    
    
    override init() {
        super.init()
    }
    
    
}

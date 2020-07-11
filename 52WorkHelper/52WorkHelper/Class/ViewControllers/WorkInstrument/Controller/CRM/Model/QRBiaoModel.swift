//
//  QRBiaoModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/6.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRBiaoModel: NSObject {
    var commodityId = ""
    var commodityName = ""
    var commodityPrice = ""
    var commodityUnitName = ""
    var number = ""
    var total = ""
    
    init?(jsonData : JSON) {
        commodityId = jsonData["commodityId"].stringValue
        commodityName = jsonData["commodityName"].stringValue
        commodityPrice = jsonData["commodityPrice"].stringValue
        commodityUnitName = jsonData["commodityUnitName"].stringValue
        number = jsonData["number"].stringValue
        total = jsonData["total"].stringValue
        
    }
}

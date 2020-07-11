//
//  QRGoodListModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/6.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRGoodListModel: NSObject {
    //商品主键
    var commodityId = ""
    //商品名
    var commodityName = ""
    //单价
    var commodityUnitName = ""
    //数量
    var number = ""
    //总价
    var total = ""
    
    
    init?(jsonData : JSON) {
        commodityId = jsonData["commodityId"].stringValue
        commodityName = jsonData["commodityName"].stringValue
        commodityUnitName = jsonData["commodityUnitName"].stringValue
        number = jsonData["number"].stringValue
        total = jsonData["total"].stringValue
        
    }
    

}

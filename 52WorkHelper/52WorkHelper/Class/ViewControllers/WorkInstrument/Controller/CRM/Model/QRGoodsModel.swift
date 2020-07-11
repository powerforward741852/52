//
//  QRGoodsModel.swift
//  test
//
//  Created by 秦榕 on 2018/9/8.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit

class QRGoodsModel: NSObject {
    //商品分类
    var commodityCategoryName = ""
    //商品名称
    var commodityName = ""
    //商品价格
    var commodityPrice = ""
    //商品单位名称
    var commodityUnitName = ""
    //员工主键
    var entityId = ""
    //总销量
    var  totalNumber = ""
    
    init?(jsonData : JSON) {
        commodityCategoryName = jsonData["commodityCategoryName"].stringValue
        commodityName = jsonData["commodityName"].stringValue
        commodityPrice = jsonData["commodityPrice"].stringValue
        commodityUnitName = jsonData["commodityUnitName"].stringValue
        entityId = jsonData["entityId"].stringValue
        totalNumber = jsonData["totalNumber"].stringValue
        
    }
   
}

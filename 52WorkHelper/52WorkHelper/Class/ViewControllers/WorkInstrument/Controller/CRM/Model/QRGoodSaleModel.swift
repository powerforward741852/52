//
//  QRGoodSaleModel.swift
//  test
//
//  Created by 秦榕 on 2018/9/8.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit

class QRGoodSaleModel: NSObject {
    //商品编码
    var  commodityCode = ""
    //商品名称
    var  commodityName = ""
    //客户名称
    var  customerName = ""
    //商品主键
    var  entityId = ""
    //销售数量
    var  saleNumber = ""
    //下单日期
    var  startDate = ""
    
    init?(jsonData : JSON) {
        commodityCode = jsonData["commodityCode"].stringValue
        commodityName = jsonData["commodityName"].stringValue
        customerName = jsonData["customerName"].stringValue
        entityId = jsonData["entityId"].stringValue
        saleNumber = jsonData["saleNumber"].stringValue
        startDate = jsonData["startDate"].stringValue
    }
    
    
    
}

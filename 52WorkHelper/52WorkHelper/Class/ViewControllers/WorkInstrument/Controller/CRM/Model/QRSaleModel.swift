//
//  QRSaleModel.swift
//  test
//
//  Created by 秦榕 on 2018/9/8.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit

class QRSaleModel: NSObject {
    //月销售额
   var monthSaleNumber = ""
    //月
   var monthSales = ""
    init?(jsonData : JSON) {
        monthSaleNumber = jsonData["monthSaleNumber"].stringValue
        monthSales = jsonData["monthSales"].stringValue
        
        
    }
     init(str:String,str1:String) {
        monthSaleNumber = str
        monthSales = str1
    }
    
}

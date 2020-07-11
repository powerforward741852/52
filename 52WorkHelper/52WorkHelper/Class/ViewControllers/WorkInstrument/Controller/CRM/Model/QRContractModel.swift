//
//  QRContractModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/4.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRContractModel: NSObject {

        //商品名字
        var customerName = ""
        //截止日期
        var endDate = ""
        //数量
        var entityId = ""
        //开始时间
        var startDate = ""
        //title
        var title = ""
    
        init?(jsonData : JSON) {
         customerName = jsonData["customerName"].stringValue
         endDate = jsonData["endDate"].stringValue
         entityId = jsonData["entityId"].stringValue
         startDate = jsonData["startDate"].stringValue
         title = jsonData["title"].stringValue
        }
}

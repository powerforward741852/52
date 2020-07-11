//
//  QRBirthModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/19.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRBirthModel: NSObject {
    // 当月出生的人的总数
    var countSum : String!
    //月份
    var month : String!
    //示例用的姓名
    var name : String!
    //时间
    var date : String!
    //内容
    var content : String!
    //id
    var contentId : String!
    //来自
    
    init?(jsonData: JSON) {
        
    
        contentId = jsonData["contentId"].stringValue
        date = jsonData["date"].stringValue
        content = jsonData["content"].stringValue
        
        countSum = jsonData["countSum"].stringValue
        month = jsonData["month"].stringValue
        name = jsonData["name"].stringValue
        
    }
}

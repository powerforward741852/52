//
//  CQFormModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/1.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQFormModel: NSObject {

    
    //名
    var name = ""
    //标题
    var title = ""
    //请选择(必填项)
    var prompt = ""
    //类型
    var type = ""
    //是否必填
    var required = ""
    //数据源
    var dataSource = ""
    //各个控件
    var subWidget:[JSON]
    
    init?(jsonData: JSON) {
        
        
        name = jsonData["name"].stringValue
        title = jsonData["title"].stringValue
        prompt = jsonData["prompt"].stringValue
        type = jsonData["type"].stringValue
        required = jsonData["required"].stringValue
        subWidget = jsonData["subWidget"].arrayValue
    }
}

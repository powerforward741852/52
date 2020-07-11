//
//  CQCopyForModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/1.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQCopyForModel: NSObject {

    //主键
    var approverId = ""
    //头像
    var headImage = ""
    //等级
    var level = ""
    //姓名
    var realName = ""
    
    
    
    init?(jsonData: JSON) {
        
        
        approverId = jsonData["approverId"].stringValue
        headImage = jsonData["headImage"].stringValue
        level = jsonData["level"].stringValue
        realName = jsonData["realName"].stringValue
        
    }
}

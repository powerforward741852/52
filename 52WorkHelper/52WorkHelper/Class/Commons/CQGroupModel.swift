//
//  CQGroupModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/7/5.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQGroupModel: NSObject {

    //groupId
    var groupId = ""
    //
    var groupName = ""
    //
    var headImage = ""
    
    init?(jsonData: JSON) {
        
        
        groupId = jsonData["groupId"].stringValue
        groupName = jsonData["groupName"].stringValue
        headImage = jsonData["headImage"].stringValue
    }
    
}


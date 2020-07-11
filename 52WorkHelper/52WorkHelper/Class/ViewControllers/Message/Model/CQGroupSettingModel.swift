//
//  CQGroupSettingModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/15.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQGroupSettingModel: NSObject {

    
    //群组名称
    var groupName = ""
    //    群成员人数
    var groupUserNum = ""
    //    是否是群主
    var isGroupHost = ""
    //    群组成员信息
    
    //用户头像地址
    var headImage = ""
    //用户真实姓名
    var realName = ""
    // 用户id
    var userId = ""
    
    var  userData:[JSON]
    
    init?(jsonData: JSON) {
        
        
        groupName = jsonData["groupName"].stringValue
        groupUserNum = jsonData["groupUserNum"].stringValue
        isGroupHost = jsonData["isGroupHost"].stringValue
        userData = jsonData[" userData"].arrayValue
        headImage = jsonData["headImage"].stringValue
        realName = jsonData["realName"].stringValue
        userId = jsonData["userId"].stringValue
    }
}

//
//  QRGonghaiGenjinModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/17.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRGonghaiGenjinModel: NSObject {

    // 跟进人用户id
    var  userId = ""
    //跟进人用户真实姓名
    var  headImage = ""
    //用户真实姓名
    var  realName = ""
    //跟进人用户id
    var  followId = ""
    
    init?(jsonData : JSON) {
        followId = jsonData["followId"].stringValue
        realName = jsonData["realName"].stringValue
        headImage = jsonData["headImage"].stringValue
        userId = jsonData["userId"].stringValue
    }
    override init() {
        super.init()
    }
    
}

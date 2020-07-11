//
//  QRPresentModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/22.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRPresentModel: NSObject {
    //总数字
    var countNum = ""
    //
    var entityId = ""
    //礼物图片
    var  giftImage = ""
    //礼物名
    var  name = ""
    //剩余
    var  overplus = ""
    //状态
    var receiceStatus : Bool = false
    
    init?(jsonData: JSON) {
        
        //同事圈
        countNum = jsonData["countNum"].stringValue
        entityId = jsonData["entityId"].stringValue
        giftImage = jsonData["giftImage"].stringValue
        name = jsonData["name"].stringValue
        overplus = jsonData["overplus"].stringValue
       receiceStatus = jsonData["receiceStatus"].boolValue
        
      
    }
}

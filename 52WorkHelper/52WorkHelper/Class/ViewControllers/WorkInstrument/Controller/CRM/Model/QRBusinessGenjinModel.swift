//
//  QRBusinessGenjinModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/22.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRBusinessGenjinModel: NSObject {
  
    
   
   // 跟进人用户头像
    var followPersonListImage = ""
    //用户真实姓名
    var followPersonListName  = ""
    //跟进人用户id
    var followEmployeeId = ""
    
    
    init?(jsonData : JSON) {
        followPersonListImage = jsonData["followEmployeeHeadImage"].stringValue
        followPersonListName = jsonData["followEmployeeName"].stringValue
        followEmployeeId = jsonData["followEmployeeId"].stringValue
    }
    
}

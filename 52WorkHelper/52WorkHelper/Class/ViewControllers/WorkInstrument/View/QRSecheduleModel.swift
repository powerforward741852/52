//
//  QRSecheduleModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2020/3/23.
//  Copyright © 2020 chenqihang. All rights reserved.
//

import UIKit

class QRSecheduleModel: NSObject {
        var planItemContent = ""
        var schedulePlanItemId = ""
        var finishStatus = true
        var rowHeight : CGFloat = 55
        
       init?(jsonData: JSON) {
           planItemContent = jsonData["planItemContent"].stringValue
          schedulePlanItemId = jsonData["schedulePlanItemId"].stringValue
        if jsonData["finishStatus"].stringValue == "1"{
             finishStatus = false
        }else{
             finishStatus = true
        }
           
    }
    
    init(isCompleted:Bool,content:String) {
        self.planItemContent = content
        self.finishStatus = isCompleted
    }
}

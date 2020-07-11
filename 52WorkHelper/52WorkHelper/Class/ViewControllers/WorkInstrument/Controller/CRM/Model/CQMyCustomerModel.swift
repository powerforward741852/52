//
//  CQMyCustomerModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/8/6.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQMyCustomerModel: NSObject {

    var customerId = ""
    
    init?(jsonData: JSON) {
        
        customerId = jsonData["customerId"].stringValue
    }
    
}

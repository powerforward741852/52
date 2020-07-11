//
//  CQBackModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/10/26.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit

class CQBackModel: NSObject {
    
    var text = ""
    var value:Bool
    
    
    
    init?(jsonData: JSON) {
        
        
        
        text = jsonData["text"].stringValue
        value = jsonData["value"].boolValue
    }
}

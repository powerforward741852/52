//
//  QRLianXiRenModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/17.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRLianXiRenModel: NSObject {
  
    //联系人姓名
    var linkName = ""
    //联系人主键
    var linkPerson = ""
    //联系人电话
    var linkPhone = ""
    
    init?(jsonData: JSON) {
        linkName = jsonData["linkName"].stringValue
        linkPerson = jsonData["linkPerson"].stringValue
        linkPhone = jsonData["linkPhone"].stringValue
        
    }
    override init() {
        super.init()
    }
    
}

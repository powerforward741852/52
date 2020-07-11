//
//  QRGenJinRenModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/12.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRGenJinRenModel: NSObject {
    
    
    //跟进人头像
    var followEmployeeHeadImage: String!
    //id
    var followEmployeeId :String!
    //跟进人名称
    var followEmployeeName: String!
    
    init?(jsonData : JSON) {
        followEmployeeHeadImage = jsonData["followEmployeeHeadImage"].stringValue
        followEmployeeName = jsonData["followEmployeeName"].stringValue
    }
    
    override init() {
        super.init()
    }

}

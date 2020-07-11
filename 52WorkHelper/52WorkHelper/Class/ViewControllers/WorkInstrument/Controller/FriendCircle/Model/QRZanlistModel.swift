//
//  QRZanlistModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/19.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRZanlistModel: NSObject {
    var admirNum: String!
    var number: String!
    var headImage: String!
    var realName: String!
    var positionName:String!
    init?(jsonData: JSON) {
        positionName = jsonData["positionName"].stringValue
        headImage = jsonData["headImage"].stringValue
        admirNum = jsonData["admirNum"].stringValue
        realName = jsonData["realName"].stringValue
        number = jsonData["number"].stringValue
        
    }
    override init(){
        super.init()
    }
   
}

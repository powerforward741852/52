//
//  QRHistoryImageModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/10/12.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRHistoryImageModel: NSObject {
    
    var businessName: String!
    var customerName: String!
    var commentNum: String!
    var followRecordId: String!
    var createUserRealName: String!
    var createUserHeadImage: String!
    var followMethod: String!
    var address: String!
    var evaluate: String!
    var createUserId: String!
    var createTime: String!
    var finishStatus: String!
    var picurlData: [String]!
    
    init?(jsonData: JSON) {
        businessName = jsonData["businessName"].stringValue
        customerName = jsonData["customerName"].stringValue
        commentNum = jsonData["commentNum"].stringValue
        followRecordId = jsonData["followRecordId"].stringValue
        createUserRealName = jsonData["createUserRealName"].stringValue
        createUserHeadImage = jsonData["createUserHeadImage"].stringValue
        followMethod = jsonData["followMethod"].stringValue
        address = jsonData["address"].stringValue
        createTime = jsonData["createTime"].stringValue
        finishStatus = jsonData["finishStatus"].stringValue
        evaluate = jsonData["evaluate"].stringValue
        createUserId = jsonData["createUserId"].stringValue
        //图片
        
        //
            var temparr = [String]()
        for xx in jsonData["picurlData"].arrayValue{
            let str = xx.stringValue
            temparr.append(str)
        }
           picurlData = temparr
        
        
    }
}

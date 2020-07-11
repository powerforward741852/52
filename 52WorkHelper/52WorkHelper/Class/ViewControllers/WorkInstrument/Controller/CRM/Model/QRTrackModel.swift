//
//  QRTrackModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/12.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRTrackModel: NSObject {
    
    
    
    var personImage: String!
    var images: [String]!
    var followTime: String!
    var followEntityId: String!
    var personName: String!
    var evaluate: String!
    var commentCount: String!
    
    init?(jsonData : JSON) {
        commentCount = jsonData["commentCount"].stringValue
        evaluate = jsonData["evaluate"].stringValue
        followEntityId = jsonData["followEntityId"].stringValue
        followTime = jsonData["followTime"].stringValue
        //循环遍历
        var temp = [String]()
        for xx in jsonData["images"].arrayValue{
          let str = xx.stringValue
            temp.append(str)
        }
        images = temp
        //images = jsonData["images"]
        personImage = jsonData["personImage"].stringValue
        personName = jsonData["personName"].stringValue
    }
    
    
    
    
//        //评论数量
//        var  commentCount = ""
//        //评价
//        var  evaluate = ""
//        //跟进记录主键
//        var  followEntityId = ""
//        //跟进时间
//        var  followTime = ""
//        //图片
//        var  images = ""
//        //跟进人头像
//        var  personImage = ""
//        //跟进人名称
//        var  personName = ""
    
//    init?(jsonData : JSON) {
//        commentCount = jsonData["commentCount"].stringValue
//        evaluate = jsonData["evaluate"].stringValue
//        followEntityId = jsonData["followEntityId"].stringValue
//        followTime = jsonData["followTime"].stringValue
//        images = jsonData["images"].stringValue
//        personImage = jsonData["personImage"].stringValue
//        personName = jsonData["personName"].stringValue
//    }

    
}

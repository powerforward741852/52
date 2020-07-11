//
//  CQCommentModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/13.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQCommentModel: NSObject {

    
    //评论内容
    var commentContent = ""
    //评论发布时间
    var commentTime = ""
    //用户头像地址
    var headImage = ""
    //用户真实姓名
    var realName = ""
    //用户id
    var userId = ""
    
    var path = ""
    var imagePaths = [String]()
    
    var rowHeight : CGFloat = 0
    init?(jsonData: JSON) {
        
        var temparr = [String]()
        for xx in jsonData["imagePaths"].arrayValue{
            let str = xx.stringValue
            temparr.append(str)
        }
        imagePaths = temparr
        
        commentContent = jsonData["commentContent"].stringValue
        commentTime = jsonData["commentTime"].stringValue
        headImage = jsonData["headImage"].stringValue
        realName = jsonData["realName"].stringValue
        userId = jsonData["userId"].stringValue
        path = jsonData["path"].stringValue
        
    }
}

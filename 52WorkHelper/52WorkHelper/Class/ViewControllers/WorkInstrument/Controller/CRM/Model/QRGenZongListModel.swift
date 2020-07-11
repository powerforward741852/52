//
//  QRGenZongListModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/13.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRGenZongListModel: NSObject {
   //评论发布时间
    var  commentTime = ""
    //评论内容
    var  content = ""
    //用户头像地址
    var  headImage = ""
    //用户真实姓名
    var  realName = ""
    //用户id
    var  userId = ""
    
        init?(jsonData : JSON) {
            commentTime = jsonData["commentTime"].stringValue
            content = jsonData["content"].stringValue
            headImage = jsonData["headImage"].stringValue
            realName = jsonData["realName"].stringValue
            userId = jsonData["userId"].stringValue
        }
    
    
}

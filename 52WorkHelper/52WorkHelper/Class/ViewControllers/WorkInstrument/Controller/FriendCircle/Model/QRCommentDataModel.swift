//
//  QRCommentDataModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/5.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRCommentDataModel: NSObject {
    //评论内容
    var commentContent: String!
    //评论id
    var circleCommentId: String!
    //同事圈评论被回复人-真实姓名
    var commentUserTo: String!
    //同事圈评论被回复人-真实姓名
    var commentUserFrom: String!

    init?(jsonData: JSON) {
        circleCommentId = jsonData["circleCommentId"].stringValue
        commentContent = jsonData["commentContent"].stringValue
        commentUserFrom = jsonData["commentUserFrom"].stringValue
        commentUserTo = jsonData["commentUserTo"].stringValue
    }
    override init() {
        super.init()
    }
}

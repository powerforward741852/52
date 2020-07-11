//
//  CQWorkMateCircleModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/19.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQWorkMateCircleModel: NSObject {

    //同事圈内容
    var articleContent = ""
    //同事圈id
    var circleArticleId = ""
    //同事圈评论列表
    var commentData:[JSON]
    //同事圈评论id
    var  circleCommentId = ""
    //同事圈评论内容
    var  commentContent = ""
    //   同事圈评论发布人或回复人-真实姓名
    var  commentUserFrom = ""
    //同事圈评论被回复人-真实姓名
    var  commentUserTo = ""
    //同事圈已发布时长(已发布多久时间)
    var differTime = ""
    //同事圈发布人-用户头像地址
    var headImage = ""
    //是否点赞状态
    var laudStatus:Bool
    //同事圈点赞数
    var laudNum = ""
    //同事圈点赞用户列表
    var laudUserData:[JSON]
    //同事圈图片列表
    var picurlData:[JSON]
    //同事圈发布人-用户真实姓名
    var realName = ""
    var iconImg = ""
    
    init?(jsonData: JSON) {
        
   //同事圈
        articleContent = jsonData["articleContent"].stringValue
        circleArticleId = jsonData["circleArticleId"].stringValue
        commentData = jsonData["commentData"].arrayValue
        circleCommentId = jsonData["circleCommentId"].stringValue
        commentContent = jsonData["commentContent"].stringValue
        commentUserFrom = jsonData["commentUserFrom"].stringValue
        commentUserTo = jsonData["commentUserTo"].stringValue

        differTime = jsonData["differTime"].stringValue
        headImage = jsonData["headImage"].stringValue
        laudStatus = jsonData["laudStatus"].boolValue
        laudNum = jsonData["laudNum"].stringValue
        laudUserData = jsonData["laudUserData"].arrayValue
        picurlData = jsonData["picurlData"].arrayValue
        realName = jsonData["realName"].stringValue
        iconImg = jsonData["headImg"].stringValue
    }
}

//
//  CQTaskUserModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/29.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQTaskUserModel: NSObject {

    //用户参与任务状态
    var finishStatus = ""
    //完成或不完成时间
    var finishYesOrNoTime = ""
    //参与任务人员的用户头像地址
    var headImage = ""
    //参与任务人员的用户真实姓名
    var realName = ""
    //未完成的原因
    var undoReason = ""
    //参与任务人员的用户id
    var userId = ""
    
    //完成状态 boolean
    var finishSign:Bool
    
    //完成时间
    var finishTime = ""
    //留言id
    var  partakeId = ""
    var commentData: [QRCommentDataModel]!
    var rowHeight : CGFloat = 0

    init?(jsonData: JSON) {
        
        partakeId = jsonData["partakeId"].stringValue
        finishStatus = jsonData["finishStatus"].stringValue
        finishYesOrNoTime = jsonData["finishYesOrNoTime"].stringValue
        headImage = jsonData["headImage"].stringValue
        realName = jsonData["realName"].stringValue
        undoReason = jsonData["undoReason"].stringValue
        userId = jsonData["userId"].stringValue
        finishSign = jsonData["finishSign"].boolValue
        finishTime = jsonData["finishTime"].stringValue
        
        
        
        //d评论模型数组
        var tempComment = [QRCommentDataModel]()
        for (_,value) in jsonData["commentData"].arrayValue.enumerated() {
            let tempMod = QRCommentDataModel.init(jsonData: value)
            tempComment.append(tempMod!)
        }
        commentData = tempComment
        
//        let mod = QRCommentDataModel()
//        mod.commentUserTo = "to"
//        mod.commentUserFrom = "from"
//        mod.circleCommentId = "id"
//        mod.commentContent = "asdajsdhakdskjas"
//        commentData = [mod]
    }
    
}

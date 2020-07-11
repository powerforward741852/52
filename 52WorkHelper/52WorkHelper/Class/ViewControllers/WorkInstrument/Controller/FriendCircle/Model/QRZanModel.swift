//
//  QRZanModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/19.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRZanModel: NSObject {
    var content: String!
    var positionName: String!
    var id: String!
    var realName: String!
    var updateDate: String!
    var picurlData: [String]!
    var createDate: String!
    var headImg: String!
    var admireNum:String!
    var createName:String!
    var laudStatus:Bool = false
    var toUserId:String = ""
    //点赞数
    var laudNum: String!
    //评论
    var commentData: [QRCommentDataModel]!
    //点赞人信息
    var laudUserData: [String]!
    var page: Int?
    //行高
    var rowHeight : CGFloat = 0
    
    init?(jsonData: JSON) {
        toUserId = jsonData["toUserId"].stringValue
        createName = jsonData["createName"].stringValue
        admireNum = jsonData["admireNum"].stringValue
        content = jsonData["content"].stringValue
        positionName = jsonData["positionName"].stringValue
        realName = jsonData["realName"].stringValue
        id = jsonData["id"].stringValue
        updateDate = jsonData["v"].stringValue
        createDate = jsonData["createDate"].stringValue
        headImg = jsonData["headImg"].stringValue
        laudStatus = jsonData["laudStatus"].boolValue
        var temp = [String]()
        for val in jsonData["picurlData"].arrayValue{
            temp.append(val.stringValue)
        }
        picurlData = temp
        
        
        //d评论模型数组
        laudNum = jsonData["laudNum"].stringValue
        var tempComment = [QRCommentDataModel]()
        for (_,value) in jsonData["commentData"].arrayValue.enumerated() {
            let tempMod = QRCommentDataModel.init(jsonData: value)
            tempComment.append(tempMod!)
        }
        commentData = tempComment
        //数组
        var tempUser = [String]()
        for (_,value) in jsonData["laudUserData"].arrayValue.enumerated() {
            tempUser.append(value.stringValue)
        }
        laudUserData = tempUser
        
    }
    override init() {
        super.init()
    }
}

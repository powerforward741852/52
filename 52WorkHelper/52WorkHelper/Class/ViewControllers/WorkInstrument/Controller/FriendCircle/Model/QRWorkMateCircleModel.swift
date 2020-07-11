//
//  QRWorkMateCircleModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/5.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRWorkMateCircleModel: NSObject {
    //同事圈已发布时长(已发布多久时间)
    var differTime: String!
    //同事圈id
    var circleArticleId: String!
    //同事圈发布人-用户真实姓名
    var realName: String!
    //articleContent
    var articleContent: String!
    //头像
    var headImg: String!
    //点赞状态
    var laudStatus: Bool!
    //点赞数
    var laudNum: String!
    //评论
    var commentData: [QRCommentDataModel]!
    //点赞人信息
    var laudUserData: [String]!
    //图片
    var picurlData: [String]!
    //
    var createUserId:String = ""
    //t页数
    var page: Int?
    
    //行高
    var rowHeight : CGFloat = 0
    
    
    //进入的类型0喜讯 1心声
    var manageType : Int = 3
    
    //我收到的/发送到
    var toUserId: String!
    var content: String!
    var updateDate: String!
    var entityId: String
    var personList : [CQDepartMentAttenceModel]!
    var childJson : [CQDepartMentAttenceModel]!
    var admirRealName : String!
    var deleteSign: Int = 0
    var type: Int = 0
    var createDate: String!
    var createId: String!
    var entityStatus: Bool = false
    
    
    //喜讯
    var headImage : String!
    var id : String
    var positionName : String
    
    //心声
    
    init?(jsonData: JSON) {
        
        //喜讯
        headImage = jsonData["headImage"].stringValue
        id = jsonData["id"].stringValue
        positionName = jsonData["positionName"].stringValue
        
        //我发送的
        toUserId = jsonData["toUserId"].stringValue
        content = jsonData["content"].stringValue
        updateDate = jsonData["updateDate"].stringValue
        entityId = jsonData["entityId"].stringValue
        deleteSign = jsonData["deleteSign"].intValue
        type = jsonData["type"].intValue
        createDate = jsonData["createDate"].stringValue
        createId = jsonData["createId"].stringValue
        entityStatus = jsonData["entityStatus"].boolValue
        var tempPeo = [CQDepartMentAttenceModel]()
        for (_,value) in jsonData["personList"].arrayValue.enumerated() {
            let tempMod = CQDepartMentAttenceModel.init(jsonData: value)
            tempPeo.append(tempMod!)
        }
        personList = tempPeo
        
        //祝福
        var tempChild = [CQDepartMentAttenceModel]()
        for (_,value) in jsonData["childJson"].arrayValue.enumerated() {
            let tempMod = CQDepartMentAttenceModel.init(jsonData: value)
            tempChild.append(tempMod!)
        }
        childJson = tempChild
        
        admirRealName = jsonData["admirRealName"].stringValue
        
        //同事圈
        articleContent = jsonData["articleContent"].stringValue
        circleArticleId = jsonData["circleArticleId"].stringValue
        differTime = jsonData["differTime"].stringValue
        headImg = jsonData["headImg"].stringValue
        laudStatus = jsonData["laudStatus"].boolValue
        laudNum = jsonData["laudNum"].stringValue
        realName = jsonData["realName"].stringValue
        //数组
        var tempUser = [String]()
        for (_,value) in jsonData["laudUserData"].arrayValue.enumerated() {
            tempUser.append(value.stringValue)
        }
        laudUserData = tempUser
        //图片数组
        var tempPicur = [String]()
        for (_,value) in jsonData["picurlData"].arrayValue.enumerated() {
            tempPicur.append(value.stringValue)
        }
        picurlData = tempPicur
        
        //d评论模型数组
        var tempComment = [QRCommentDataModel]()
        for (_,value) in jsonData["commentData"].arrayValue.enumerated() {
           let tempMod = QRCommentDataModel.init(jsonData: value)
            tempComment.append(tempMod!)
        }
        commentData = tempComment
        
        createUserId = jsonData["createUserId"].stringValue
        
    }
}

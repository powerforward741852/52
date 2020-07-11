//
//  CQSmileWallModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/8/24.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQSmileWallModel: NSObject {

    //笑脸墙发布时间
    var createTime = ""
    //笑脸墙发布人的用户头像地址
    var createUserHeadImage = ""
    //笑脸墙发布人的用户id
    var createUserId = ""
    //笑脸墙发布人的用户真实姓名
    var createUserRealName = ""
    //笑脸墙图片地址
    var imageUrl = ""
    //点赞数
    var laudNum = ""
    //点赞状态
    var laudStatus:Bool
    //笑脸墙id
    var smileWallId = ""
    //是否允许x删除
    var isAllowDelete = false
    
    //获取今天是否出差情况
    //业务申请id
    var businessApplyId = ""
    //业务申请名称
    var businessApplyName = ""
    
    init?(jsonData: JSON) {
        
        isAllowDelete = jsonData["isAllowDelete"].boolValue
        createTime = jsonData["createTime"].stringValue
        createUserHeadImage = jsonData["createUserHeadImage"].stringValue
        createUserId = jsonData["createUserId"].stringValue
        createUserRealName = jsonData["createUserRealName"].stringValue
        imageUrl = jsonData["imageUrl"].stringValue
        laudNum = jsonData["laudNum"].stringValue
        laudStatus = jsonData["laudStatus"].boolValue
        smileWallId = jsonData["smileWallId"].stringValue
        
        
        businessApplyId = jsonData["businessApplyId"].stringValue
        businessApplyName = jsonData["businessApplyName"].stringValue
    }
    
    init(uId:String,laudStatus:Bool) {
        self.smileWallId = uId
        self.laudStatus = laudStatus
    }
}

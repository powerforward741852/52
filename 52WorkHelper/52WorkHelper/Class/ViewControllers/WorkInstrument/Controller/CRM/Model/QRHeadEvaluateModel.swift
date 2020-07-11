//
//  QRHeadEvaluateModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/13.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRHeadEvaluateModel: NSObject {
    //跟进记录所属商机名称
    var businessName: String!
    //跟进记录所属客户名称
    var customerName: String!
    //跟进记录的评论数量
    var commentNum: String!
    //跟进记录id
    var followRecordId: String!
    //跟进记录发布人的用户真实姓名
    var createUserRealName: String!
    //跟进记录发布人的用户头像地址
    var createUserHeadImage: String!
    //跟进方式
    var followMethod: String!
    //    地址
    var address: String!
    //主要活动评价
    var evaluate: String!
    //跟进记录发布人的用户id
    var createUserId: String!
      //  跟进记录发布人时间
    var createTime: String!
    //完成情况
    var finishStatus: String!
    //跟进记录图片数组
    var picurlData: [String]!
    
    init?(jsonData : JSON) {
        businessName = jsonData["businessName"].stringValue
        customerName = jsonData["customerName"].stringValue
        commentNum = jsonData["commentNum"].stringValue
        followRecordId = jsonData["followRecordId "].stringValue
        createUserRealName = jsonData["createUserRealName"].stringValue
        createUserHeadImage = jsonData["createUserHeadImage"].stringValue
        address = jsonData["address"].stringValue
        followMethod = jsonData["followMethod"].stringValue
        evaluate = jsonData["evaluate"].stringValue
        createUserId = jsonData["createUserId"].stringValue
        createTime = jsonData["createTime"].stringValue
        finishStatus = jsonData["finishStatus"].stringValue
      //  picurlData = jsonData["picurlData"].stringValue
        //循环遍历
        var temp = [String]()
        for xx in jsonData["picurlData"].arrayValue{
            let str = xx.stringValue
            temp.append(str)
        }
        picurlData = temp
    }
    
}

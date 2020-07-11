//
//  QRGongHaiDetaiModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/17.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRGongHaiTractModel: NSObject {
    //地址
    var address = ""
    //跟进记录的评论数量
    var commentNum = ""
    //发布时间
    var createTime = ""
    
    //发布人头像
    var createUserHeadImage = ""
    //发布人id
    var createUserId = ""
    //跟进记录发布人的用户真实姓名
    var createUserRealName = ""
    //跟进记录所属客户名称
    var customerName = ""
    //主要活动评价
    var evaluate = ""
    //完成情况
    var finishStatus = ""
    //跟进方式
    var followMethod = ""
    //跟进记录id
    var followRecordId = ""
    //图片数组
    var picurlData = [String]()
        init?(jsonData: JSON) {
        address = jsonData["address"].stringValue
        commentNum = jsonData["commentNum"].stringValue
        createTime = jsonData["createTime"].stringValue
        createUserHeadImage = jsonData["createUserHeadImage"].stringValue
        createUserId = jsonData["createUserId"].stringValue
        createUserRealName = jsonData["createUserRealName"].stringValue
        customerName = jsonData["customerName"].stringValue
        evaluate = jsonData["evaluate"].stringValue
        finishStatus = jsonData["finishStatus"].stringValue
        followMethod = jsonData["followMethod"].stringValue
        followRecordId = jsonData["followRecordId"].stringValue
          
            var temp = [String]()
            for xx in jsonData["picurlData"].arrayValue{
                temp.append(xx.stringValue)
            }
            self.picurlData = temp
            
    }
    
    
}

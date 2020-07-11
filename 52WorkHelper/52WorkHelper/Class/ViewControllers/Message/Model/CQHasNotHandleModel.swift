//
//  CQHasNotHandleModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/6.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQHasNotHandleModel: NSObject {

    //未处理工作已发布时长(已发布多久时间)    
    var differTime = ""
    //未处理工作头像地址
    var headImage = ""
    //未处理工作发布时间
    var publishTime = ""
    //已读标记
    var readSign:Bool
    //未处理工作id
    var untreatedWorkId = ""
    //详情主键;关联实体的ID
    var workId = ""
    //未处理工作标题
    var workName = ""
    //未处理工作类型
    var workType = ""
    var timestr = ""
    
    init?(jsonData: JSON) {
        
        
        differTime = jsonData["differTime"].stringValue
        headImage = jsonData["headImage"].stringValue
        publishTime = jsonData["publishTime"].stringValue
        readSign = jsonData["readSign"].boolValue
        untreatedWorkId = jsonData["untreatedWorkId"].stringValue
        workId = jsonData["workId"].stringValue
        workName = jsonData["workName"].stringValue
        workType = jsonData["workType"].stringValue
        
    }
    
   
    
    
}

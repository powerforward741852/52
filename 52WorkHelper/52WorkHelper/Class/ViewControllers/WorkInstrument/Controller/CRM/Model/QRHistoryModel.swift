//
//  QRHistoryModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/19.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRHistoryModel: NSObject {
    //创建时间
    var createTime = ""
    //历史编辑记录发布人的用户头像地址
    var createUserHeadImage = ""
    //历史编辑记录发布人的用户id
    var createUserId = ""
    //历史编辑记录发布人的用户真实姓名
    var createUserRealName = ""
    //更新(编辑)记录数组
    var editRecordData = [String]()
    //历史编辑记录id
    var historyId = ""
    init?(jsonData: JSON) {
        createTime = jsonData["createTime"].stringValue
        createUserHeadImage = jsonData["createUserHeadImage"].stringValue
        createUserId = jsonData["createUserId"].stringValue
        createUserRealName = jsonData["createUserRealName"].stringValue
        
        for xx in jsonData["editRecordData"].arrayValue{
            let str = xx.stringValue
            print(str)
            editRecordData.append(str)
        }
       
        
        
        historyId = jsonData["historyId"].stringValue
      
    }
    
}

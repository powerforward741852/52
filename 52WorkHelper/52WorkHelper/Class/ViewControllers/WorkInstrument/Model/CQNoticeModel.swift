//
//  CQNoticeModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/9.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQNoticeModel: NSObject {

    //通知公告主键
    var entityId = ""
    //时间
    var createDate = ""
    //通知公告标题
    var articleTitle = ""
    //通知公告图片url
    var  noticeUrl = ""
    //已读标记
    var readSign:Bool?
    
    //是否生日祝福
    var isBirthwish = false
    
    init?(jsonData: JSON) {
        
        readSign = jsonData["readSign"].boolValue
        entityId = jsonData["entityId"].stringValue
        createDate = jsonData["createDate"].stringValue
        articleTitle = jsonData["articleTitle"].stringValue
        noticeUrl = jsonData["noticeUrl"].stringValue
        isBirthwish = jsonData["isBirthwish"].boolValue
    }
}

//
//  CQSmallWebModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/9.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQSmallWebModel: NSObject {

    //微网站主键
    var entityId = ""
    //图片路径
    var imgUrl = ""
    //微网站标题
    var siteTitle = ""
    //微网站网址
    var siteUrl = ""
    //网站详情
    var siteContent = ""
    
    
    init?(jsonData: JSON) {
        
        
        entityId = jsonData["entityId"].stringValue
        imgUrl = jsonData["imgUrl"].stringValue
        siteTitle = jsonData["siteTitle"].stringValue
        siteUrl = jsonData["siteUrl"].stringValue
        siteContent = jsonData["siteContent"].stringValue
    }
}

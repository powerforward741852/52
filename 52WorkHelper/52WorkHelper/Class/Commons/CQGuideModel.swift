//
//  CQGuideModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/28.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQGuideModel: NSObject {
    
   
   
    //登录引导页id
    var startImageId = ""
    //登录引导页图片地址    
    var startImageUrl = ""

    //媒体分类
    var entityId = ""
    var projectName = ""
    init?(jsonData: JSON) {
      
        
        entityId = jsonData["entityId"].stringValue
        projectName = jsonData["projectName"].stringValue
        startImageId = jsonData["startImageId"].stringValue
        startImageUrl = jsonData["startImageUrl"].stringValue
        
    }
    override init() {
        
    }
    
}

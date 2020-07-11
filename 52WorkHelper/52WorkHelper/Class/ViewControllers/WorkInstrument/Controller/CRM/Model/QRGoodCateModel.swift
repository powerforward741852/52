//
//  QRGoodCateModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/10.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRGoodCateModel: NSObject {
    //分类id
    var  categoryId  = ""
    //分类名字
    var categoryName = ""
    
    init?(jsonData : JSON) {
        categoryId = jsonData["categoryId"].stringValue
        categoryName = jsonData["categoryName"].stringValue
    }
}

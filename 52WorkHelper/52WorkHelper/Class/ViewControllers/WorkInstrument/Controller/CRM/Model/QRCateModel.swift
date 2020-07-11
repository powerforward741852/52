//
//  QRCateModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/21.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRCateModel: NSObject {
    //类别名称
    var categoryName = ""
    //自定义客户分类id
    var customerCategoryId = ""
    init?(jsonData: JSON) {
        categoryName = jsonData["categoryName"].stringValue
        customerCategoryId = jsonData["customerCategoryId"].stringValue
    }
    
}

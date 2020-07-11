//
//  QRFileModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/17.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRFileModel: NSObject {
   //附件id
    var attachmentId = ""
    //附件(原)文件名
    var attachmentOldName = ""
    //附件发布时间
    var createTime = ""
    init?(jsonData: JSON) {
        attachmentId = jsonData["attachmentId"].stringValue
        attachmentOldName = jsonData["attachmentOldName"].stringValue
        createTime = jsonData["createTime"].stringValue
    }
    
}

//
//  QRDetailAttachmentModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/6.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRDetailAttachmentModel: NSObject {
    
    //附件路径
    var attachementUrl = ""
    //文件名称号
    var fileName = ""
    
    
    
    init?(jsonData : JSON) {
        attachementUrl = jsonData["attachementUrl"].stringValue
        fileName = jsonData["fileName"].stringValue
        
        
    }
}

//
//  QROutRecorderModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/5/28.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class QROutRecorderModel: NSObject {
    //结束时间
    var endDate = ""
    //外出详情
    var outContent = ""
    //开始时间
    var startDate = ""
    //外出图片
    var outImages = [String]()
    
    var  rowheight:CGFloat  = 0
    init?(jsonData: JSON) {
       
        var temppic = [String]()
        for (_,val) in jsonData["outImages"].arrayValue.enumerated(){
            temppic.append(val.stringValue)
        }
        outImages = temppic
        startDate = jsonData["startDate"].stringValue
        outContent = jsonData["outContent"].stringValue
        endDate = jsonData["endDate"].stringValue
       
    }
    override init() {
        
    }
}

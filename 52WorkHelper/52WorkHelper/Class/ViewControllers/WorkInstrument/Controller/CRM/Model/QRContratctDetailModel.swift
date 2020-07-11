//
//  QRContratctDetailModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/5.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRContratctDetailModel: NSObject {
   
//    amount = "<null>";
//    attachmentList = "<null>";
//    customerName = "\U86cb\U9ec4\U6e20\U9053\U5546";
//    endDate = "";
//    isDelete = 1;
//    number = "";
//    remark = "";
//    startDate = "";
//    title = "\U5408\U540c82011111";

    
    //合同金额
    var amount = ""
    //附件列表
    var attachmentList = [String]()
    var attachementUrl = [String]()
    var fileName = [String]()
    //商品列表
   // var commodityList :[JSON]
    
    //客户名
    var customerName = ""
    //开始时间
    var startDate = ""
    //截止日期
    var endDate = ""
    
    //是否删除(true-可以，false-不可以)
    var isDelete :Bool?
    //合同编号
    var number = ""
    //合同备注
    var remark = ""
    //合同标题
    var title = ""
    

    init?(jsonData : JSON) {
       // commodityList = jsonData["commodityList"].arrayValue
        //attachmentList = jsonData["attachmentList"].arrayValue
        amount = jsonData["amount"].stringValue
        customerName = jsonData["customerName"].stringValue
        endDate = jsonData["endDate"].stringValue
        remark = jsonData["remark"].stringValue
        startDate = jsonData["startDate"].stringValue
        title = jsonData["title"].stringValue
        number = jsonData["number"].stringValue
        isDelete = jsonData["isDelete"].boolValue
        var tempImg = [String]()
        var tempName = [String]()
        for xx in jsonData["attachmentList"].arrayValue {
            tempName.append(xx["fileName"].stringValue)
            tempImg.append(xx["attachementUrl"].stringValue)
        }
        attachementUrl = tempImg
        fileName = tempName
        
    }
}

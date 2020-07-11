//
//  QRDetailBusinessMdel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/11.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRDetailBusinessMdel: NSObject {
   //商机名
    var businessName: String!
   //跟进人主键列表
    var followPerson: String!
    //联系人名
    var linkPersonPhone: String!
    //决策人名
    var decisionName: String!
   //
    var followPersonListImage = [String]()
    
    var followPersonListName  = [String]()
    
    var followEmployeeId = [String]()
    //跟进人模型数组
    var model = [QRBusinessGenjinModel]()
    //var followModel =
    
    //决策人电话
    var decisionPhone: String!
   //联系人
    var linkPerson: String!
    //商机概要
    var businessRemark: String!
    //预计结单时间
    var closeDate: String!
    //竞争者
    var competitor: String!
     //预计商机金额
    var estimatedAmount: String!
    //客户名称
    var crmCustomerName: String!
    //商机类型主键
    var businessType:  String!
    //销售阶段
    var salesStage: String!
    //联系人姓名
    var linkPersonName: String!
    //重要程度
    var importance: String!
    //合同数量
    var contractCount: Int = 0
    //联系人数量
    var linkmanCount: Int = 0
    //客户
    var crmCustomer: String!
    //是否可以删除
    var isCanOperate: Bool = false
    //商机主键
    var entityId = ""
    
    init?(jsonData : JSON) {
        businessName = jsonData["businessName"].stringValue
        followPerson = jsonData["followPerson"].stringValue
        linkPersonPhone = jsonData["linkPersonPhone"].stringValue
        decisionName = jsonData["decisionName"].stringValue
        decisionPhone = jsonData["decisionPhone"].stringValue
        linkPerson = jsonData["linkPerson"].stringValue
        businessRemark = jsonData["businessRemark"].stringValue
        closeDate = jsonData["closeDate"].stringValue
        competitor = jsonData["competitor"].stringValue
        estimatedAmount = jsonData["estimatedAmount"].stringValue
        salesStage = jsonData["salesStage"].stringValue
        crmCustomerName = jsonData["crmCustomerName"].stringValue
        businessType = jsonData["businessType"].stringValue
        salesStage = jsonData["salesStage"].stringValue
        
        linkPersonName = jsonData["linkPersonName"].stringValue
        importance = jsonData["importance"].stringValue
        contractCount = jsonData["contractCount"].intValue
        linkmanCount = jsonData["linkmanCount"].intValue
        crmCustomer = jsonData["crmCustomer"].stringValue
        isCanOperate = jsonData["isCanOperate"].boolValue
        entityId = jsonData["entityId"].stringValue
        
            var tempimg = [String]()
            var tempname = [String]()
            var tempid = [String]()
        
        for xx in jsonData["followPersonList"].arrayValue{
            tempimg.append(xx["followEmployeeHeadImage"].stringValue)
            tempname.append(xx["followEmployeeName"].stringValue)
            tempid.append(xx["followEmployeeId"].stringValue)
        }
         followPersonListName = tempname
        followPersonListImage = tempimg
        followEmployeeId = tempid
    
          var tempmod = [QRBusinessGenjinModel]()
        for xx in jsonData["followPersonList"].arrayValue{
           let mod = QRBusinessGenjinModel(jsonData: xx)
            tempmod.append(mod!)
        }
           model = tempmod
        
        
    }

    
    override init() {
        super.init()
    }
}

//
//  NCQApprovelModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/10/18.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit

class NCQApprovelModel: NSObject {

    //审批人列表
    var approvalFlowPersonUnitJsonList:[JSON]
    //抄送人列表
    var copyFlowPersonUnitJsonList:[JSON]
    //表单主键
    var businessFormId = ""
    //表单内容
    var formContent = ""
    
    
    //formContent内的内容
    
    var name = ""
    var type = ""
    var title = ""
    //套件控件里的子控件
    var subWidget:[JSON]
    var prompt = ""
    var required = false
    var dataFormat = ""
    var dataSource:[JSON]
    var unit = ""
    var formula = ""
    
    //dataSource数据
    var text = ""
    var value = ""
    var vacationUnit = ""
    var timeMode = ""
    var useBalance = ""
    
    var businessDetail:[JSON]
    
    //form数据json
    var formData = ""
    
    //表名
    var businessName = ""
    
    //手机类型 0 手机，1座机
    var phoneType = ""
    //是否需要验证格式
    var validate = false
    //是否能加入公式计算 true 可，false：不可
    var isCalculate = false
    //默认值
    var defualtv = ""
    //单选或多项 true：单选，false：多选
    var single = false
    
    init?(jsonData: JSON) {
        
        
        approvalFlowPersonUnitJsonList = jsonData["approvalFlowPersonUnitJsonList"].arrayValue
        copyFlowPersonUnitJsonList = jsonData["copyFlowPersonUnitJsonList"].arrayValue
        businessFormId = jsonData["businessFormId"].stringValue
        formContent = jsonData["formContent"].stringValue
        
        
        name = jsonData["name"].stringValue
        type = jsonData["type"].stringValue
        title = jsonData["title"].stringValue
        prompt = jsonData["prompt"].stringValue
        required = jsonData["required"].boolValue
        dataFormat = jsonData["dataFormat"].stringValue
        unit = jsonData["unit"].stringValue
        formula = jsonData["formula"].stringValue
        
        subWidget = jsonData["subWidget"].arrayValue
        dataSource = jsonData["dataSource"].arrayValue
        
        text = jsonData["text"].stringValue
        value = jsonData["value"].stringValue
        vacationUnit = jsonData["vacationUnit"].stringValue
        timeMode = jsonData["timeMode"].stringValue
        useBalance = jsonData["useBalance"].stringValue
        
        businessDetail = jsonData["businessDetail"].arrayValue
        
        formData = jsonData["formData"].stringValue
        businessName = jsonData["businessName"].stringValue
        
        
        phoneType = jsonData["phoneType"].stringValue
        validate = jsonData["validate"].boolValue
        isCalculate = jsonData["isCalculate"].boolValue
        defualtv = jsonData["defualtv"].stringValue
        single = jsonData["single"].boolValue
    }
}

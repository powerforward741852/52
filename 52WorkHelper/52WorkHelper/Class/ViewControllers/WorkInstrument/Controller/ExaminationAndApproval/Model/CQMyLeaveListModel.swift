//
//  CQMyLeaveListModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/9/12.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQMyLeaveListModel: NSObject {

    //余额值
    var balanceNumber = ""
    //余额发放方式(1-手动发放，2-每年自动发放，3-按加班时长发放)
    var balanceRule = ""
    //余额发动方式名称
    var balanceRuleName = ""
    //名称
    var text = ""
    //请假模式(1-工作日，2-自然日)
    var timeMode = ""
    //请假模式(请假时长方式)名称
    var timeModeName = ""
    //请假单位(1-小时，2-半天，3-天)
    var vacationUnit = ""
    //请假单位名称
    var vacationUnitName = ""
    //假期类型主键    
    var value = ""
    //是否启用假期余额，true-使用
    var useBalance = ""
    
    init?(jsonData: JSON) {
            //        let jsonStr = ["balanceNumber":65];
        
        let  doubleVar = jsonData["balanceNumber"].floatValue
        let balanceNumberStr =  String(format: "%.1f", doubleVar)
        balanceNumber = balanceNumberStr //JSON(jsonStr)["balanceNumber"].stringValue//jsonData["balanceNumber"].stringValue
        
        
        
        
        balanceRule = jsonData["balanceRule"].stringValue
        balanceRuleName = jsonData["balanceRuleName"].stringValue
        text = jsonData["text"].stringValue
        timeMode = jsonData["timeMode"].stringValue
        timeModeName = jsonData["timeModeName"].stringValue
        useBalance = jsonData["useBalance"].stringValue
        vacationUnit = jsonData["vacationUnit"].stringValue
        vacationUnitName = jsonData["vacationUnitName"].stringValue
        value = jsonData["value"].stringValue
       
    }
}

extension Float {
    /// 小数点后如果只是0，显示整数，如果不是，显示原来的值
        var cleanZero : String {
                return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
            }
 
}

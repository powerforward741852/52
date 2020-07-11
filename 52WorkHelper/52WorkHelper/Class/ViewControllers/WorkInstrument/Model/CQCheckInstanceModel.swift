//
//  CQCheckInstanceModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/7.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQCheckInstanceModel: NSObject {

    //修改接口后数据
    //考勤数据列表
    var attendanceList:[JSON]
    //异常类型描述
    var abnormalDesc = ""
    //下班提前打卡时间，在这之前为早退
    var amEndEarlyRule = ""
    //签到时间
    var attendanceTime = ""
    //    “签到” “签退”
    var prompt = ""
    //是否申请补卡
    var isModifyApply = false
    //    “打卡签到” “打卡签退”
    var pushAttendance = ""
    //    “上班时间” “下班时间”
    var ruleDesc = ""
    // 规定 签到/签退时间 "HH:mm:ss"
    var ruleTime = ""
    //    考勤状态(“上班中”)
    var attendanceStatus = ""
    //是否自动考勤(true-是，false-否)
    var autoSign = ""
    //下班提前打卡时间，在这之前为早退
    var pmEndEarlyRule = ""
    
    var isAttendance = false
    //打卡来源
    var sourceType = ""
    
    
    /*
    //上午签退时间
    var amEnd = ""
    //上午签退异常描述(1-迟到，2早退，3-旷工，4-缺勤)
    var amEndAbnormal = ""
  
    //规定上午签退时间
    var amEndRule = ""
    //上午签到时间
    var amStart = ""
    //规定上午签到时间
    var amStartRule = ""
    //上午签到异常描述(1-迟到，2早退，3-旷工，4-缺勤)
    var  amStartAbnormal = ""
    //规定考勤次数(2-上午签到，下午签退；4-上午签到，上午签退，下午签到，下午签退)
    var attendanceModel = ""
    
    //下午签退时间
    var pmEnd = ""
    //下午签退异常描述(1-迟到，2早退，3-旷工，4-缺勤)
    var pmEndAbnormal = ""
    
    //规定下午签退时间
    var pmEndRule = ""
    //下午签到时间
    var pmStart = ""
    //下午签到异常描述(1-迟到，2早退，3-旷工，4-缺勤)
    var pmStartAbnormal = ""
    //规定下午签到时间
    var pmStartRule = ""
    */
    init?(jsonData: JSON) {
        sourceType = jsonData["sourceType"].stringValue
        attendanceList = jsonData["attendanceList"].arrayValue
        abnormalDesc = jsonData["abnormalDesc"].stringValue
        amEndEarlyRule = jsonData["amEndEarlyRule"].stringValue
        attendanceTime = jsonData["attendanceTime"].stringValue
        prompt = jsonData["prompt"].stringValue
        pushAttendance = jsonData["pushAttendance"].stringValue
        ruleDesc = jsonData["ruleDesc"].stringValue
        ruleTime = jsonData["ruleTime"].stringValue
        attendanceStatus = jsonData["attendanceStatus"].stringValue
        autoSign = jsonData["autoSign"].stringValue
        pmEndEarlyRule = jsonData["pmEndEarlyRule"].stringValue
        isModifyApply = jsonData["isModifyApply"].boolValue
        isAttendance = jsonData["isAttendance"].boolValue
//        amEnd = jsonData["amEnd"].stringValue
//        amEndAbnormal = jsonData["amEndAbnormal"].stringValue
//        amEndRule = jsonData["amEndRule"].stringValue
//        amStart = jsonData["amStart"].stringValue
//        amStartAbnormal = jsonData["amStartAbnormal"].stringValue
//        amStartRule = jsonData["amStartRule"].stringValue
//        attendanceModel = jsonData["attendanceModel"].stringValue
//        pmEnd = jsonData["pmEnd"].stringValue
//        pmEndAbnormal = jsonData["pmEndAbnormal"].stringValue
//        pmEndRule = jsonData["pmEndRule"].stringValue
//        pmStart = jsonData["pmStart"].stringValue
//        pmStartAbnormal = jsonData["pmStartAbnormal"].stringValue
//        pmStartRule = jsonData["pmStartRule"].stringValue
    }
}

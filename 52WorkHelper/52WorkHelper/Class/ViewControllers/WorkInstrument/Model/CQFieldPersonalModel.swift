//
//  CQFieldPersonalModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/8.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQFieldPersonalModel: NSObject {

    
    //地址备注
    var addressRemark = ""
    //考勤id
    var attendanceRecordId = ""
    //公司上午下班打卡时间
    var baseAmEnd = ""
    //公司坐标纬度
    var baseLatitudeValue = ""
    //公司坐标经度
    var baseLongitudeValue = ""
    //公司考勤地图半径
    var baseMapRadius = ""
    //公司下午下班打卡时间
    var basePmEnd = ""
    //公司打卡模式
    var basePunchCardMode = ""
    //坐标纬度
    var latitudeValue = ""
    //坐标经度
    var longitudeValue = ""
    //外勤提前时间
    var outGrace = ""
    //外勤地图半径
    var outRadius = ""
    //打卡消息
    var punchMsg = ""
    //打卡时间
    var punchTime = ""
    //拜访对象
    var visitPartner = ""
    //工作详情
    var detailsContent = ""
    //图片地址
    var picurlData : [String]!
    
    init?(jsonData: JSON) {
        visitPartner = jsonData["visitPartner"].stringValue
        detailsContent = jsonData["detailsContent"].stringValue
        var temppicurlData = [String]()
        for xx in jsonData["picurlData"].arrayValue {
            let str = xx.stringValue
            temppicurlData.append(str)
        }
        self.picurlData = temppicurlData
        
        addressRemark = jsonData["addressRemark"].stringValue
        attendanceRecordId = jsonData["attendanceRecordId"].stringValue
        baseAmEnd = jsonData["baseAmEnd"].stringValue
        baseLatitudeValue = jsonData["baseLatitudeValue"].stringValue
        baseLongitudeValue = jsonData["baseLongitudeValue"].stringValue
        baseMapRadius = jsonData["baseMapRadius"].stringValue
        basePmEnd = jsonData["basePmEnd"].stringValue
        basePunchCardMode = jsonData["basePunchCardMode"].stringValue
        latitudeValue = jsonData["latitudeValue"].stringValue
        longitudeValue = jsonData["longitudeValue"].stringValue
        outGrace = jsonData["outGrace"].stringValue
        outRadius = jsonData["outRadius"].stringValue
        punchMsg = jsonData["punchMsg"].stringValue
        punchTime = jsonData["punchTime"].stringValue
        
    }
}

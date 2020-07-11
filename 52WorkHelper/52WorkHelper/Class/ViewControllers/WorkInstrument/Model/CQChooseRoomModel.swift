//
//  CQChooseRoomModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/7/2.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQChooseRoomModel: NSObject {

    //是否可预约
    var isOrder:Bool?
    //会议室id
    var meetingRoomId = ""
    //会议室预约详情
    var orderDetails:[JSON]?
    //会议室楼层
    var roomFloor = ""
    //会议室名称
    var roomName = ""
    //会议室规模
    var roomSize = ""
    //某时间段
    var dateTime = ""
    //设备
    var roomEquipment = ""
    //    会议室布局
    var roomLayout = ""
    //会议室容量
    var personSize = ""
    //会议室备注
    var roomRemark = ""
    
    
    init?(jsonData: JSON) {
        
        isOrder = jsonData["isOrder"].boolValue
        meetingRoomId = jsonData["meetingRoomId"].stringValue
        orderDetails = jsonData["orderDetails"].arrayValue
        roomFloor = jsonData["roomFloor"].stringValue
        roomName = jsonData["roomName"].stringValue
        roomSize = jsonData["roomSize"].stringValue
        dateTime = jsonData["dateTime"].stringValue
        roomEquipment = jsonData["roomEquipment"].stringValue
        roomLayout = jsonData["roomLayout"].stringValue
        personSize = jsonData["personSize"].stringValue
        roomRemark = jsonData["roomRemark"].stringValue
    }
    
    init(name:String,meetingRoomId:String) {
        self.meetingRoomId = meetingRoomId
        self.roomName = name
    }
    
}

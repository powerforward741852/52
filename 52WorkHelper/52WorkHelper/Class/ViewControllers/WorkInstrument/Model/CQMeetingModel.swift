//
//  CQMeetingModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/8.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQMeetingModel: NSObject {

    //会议室id
    var meetingRoomId = ""
    //会议室楼层
    var roomFloor = ""
    //会议室名称
    var roomName = ""
    //会议室规模    
    var roomSize = ""
  
    
    init?(jsonData: JSON) {
        
        
        meetingRoomId = jsonData["meetingRoomId"].stringValue
        roomFloor = jsonData["roomFloor"].stringValue
        roomName = jsonData["roomName"].stringValue
        roomSize = jsonData["roomSize"].stringValue

    }
}

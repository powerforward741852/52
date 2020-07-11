//
//  CQScheduleModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/13.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQScheduleModel: NSObject {

    
    //地址备注
    var addressRemark = ""
    //提前X分钟提醒
    var alertLimit = ""
    //留言(评论)总人数
    var commentUserNum = ""
    //结束时间
    var endDate = ""
    //是否创建(发布)者
    var isCreateUser:Bool
    //日程详情
    var planContent = ""
    //日程列表
    var planItemData = [QRSecheduleModel]()
    
    //日程标题
    var planTitle = ""
    //开始时间
    var startDate = ""
    //日程参与人员的用户信息
    var userData:[JSON]
    
    //日程状态
    var finishStatus = ""
    //日程id
    var schedulePlanId = ""
    //开始时间是上午还是下午
    var startDatePMorAM = ""
    //开始时间是上午还是下午
    var id = ""
    //日程类型
    var planType = ""
    //会议日程使用的会议室id
    var meetingRoomId = ""
    //会议日程使用的会议室名称
    var meetingRoomName = ""
    //主持人
    var hostUser = ""
    var imgFiles = [String]()
    
    var audioFiles = [QRSoundModel]()
    //外出记录s模型数组
    var outRecordJsons  = [QROutRecorderModel]()
    //    是否为收到的日程
    var reciveRemark = false
    
    var rowHeight: CGFloat = 70
    
    init?(jsonData: JSON) {
        
        
        var tempplanItemData = [QRSecheduleModel]()
              for (_,val) in jsonData["planItemData"].arrayValue.enumerated(){
                  let mod = QRSecheduleModel(jsonData: val)
                  tempplanItemData.append(mod!)
              }
            planItemData = tempplanItemData
        
        
       // 外出记录模型数组
        var tempOut = [QROutRecorderModel]()
        for (_,val) in jsonData["outRecordJsons"].arrayValue.enumerated(){
            let mod = QROutRecorderModel(jsonData: val)
            tempOut.append(mod!)
        }
        outRecordJsons = tempOut
        //音频模型数组
        var tempAudio = [QRSoundModel]()
        for (_,val) in jsonData["audioFiles"].arrayValue.enumerated(){
            let mod = QRSoundModel()
            mod.soundFilePath = val.stringValue
            mod.second = Int((LGSoundRecorder.shareInstance()?.audioDuration(fromURL:val.stringValue)) ?? 1.0)
            tempAudio.append(mod)
        }
        audioFiles = tempAudio
        //图片模型数组
        var temppic = [String]()
        for (_,val) in jsonData["imgFiles"].arrayValue.enumerated(){
            temppic.append(val.stringValue)
        }
        imgFiles = temppic
        id = jsonData["id"].stringValue
        reciveRemark = jsonData["reciveRemark"].boolValue
        addressRemark = jsonData["addressRemark"].stringValue
        alertLimit = jsonData["alertLimit"].stringValue
        commentUserNum = jsonData["commentUserNum"].stringValue
        endDate = jsonData["endDate"].stringValue
        isCreateUser = jsonData["isCreateUser"].boolValue
        planContent = jsonData["planContent"].stringValue
        planTitle = jsonData["planTitle"].stringValue
        startDate = jsonData["startDate"].stringValue
        userData = jsonData["userData"].arrayValue
        
        finishStatus = jsonData["finishStatus"].stringValue
        schedulePlanId = jsonData["schedulePlanId"].stringValue
        startDatePMorAM = jsonData["startDatePMorAM"].stringValue
        planType = jsonData["planType"].stringValue
        meetingRoomId = jsonData["meetingRoomId"].stringValue
        meetingRoomName = jsonData["meetingRoomName"].stringValue
        hostUser = jsonData["hostUser"].stringValue
    }
    
    

}

//class QRScheduleListData: NSObject {
//
//      var schedulePlanItemId = ""
//      var planItemContent = ""
//      var finishStatus = ""
//    init?(jsonData: JSON) {
//          schedulePlanItemId = jsonData["schedulePlanItemId"].stringValue
//          planItemContent = jsonData["planItemContent"].stringValue
//          finishStatus = jsonData["finishStatus"].stringValue
//      }
//
//}

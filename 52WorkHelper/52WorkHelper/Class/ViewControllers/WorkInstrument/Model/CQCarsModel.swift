//
//  CQCarsModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/7/2.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQCarsModel: NSObject {

    //司机
    var carDriver = ""
    //车牌号
    var carNumber = ""
    //类型描述
    var carTypeDesc = ""
    //车辆主键
    var entityId = ""
    //车品牌
    var carName = ""
    //车况
    var carCondition = ""
    //乘坐人数
    var personSize = ""
    //手机号
    var carDriverUserName = ""
    //司机头像
    var carDriverHeadImg = ""
    
    init?(jsonData: JSON) {
        
        carDriver = jsonData["carDriver"].stringValue
        carNumber = jsonData["carNumber"].stringValue
        carTypeDesc = jsonData["carTypeDesc"].stringValue
        entityId = jsonData["entityId"].stringValue
        carName = jsonData["carName"].stringValue
        carCondition = jsonData["carCondition"].stringValue
        personSize = jsonData["personSize"].stringValue
        carDriverUserName = jsonData["carDriverUserName"].stringValue
        carDriverHeadImg = jsonData["carDriverHeadImg"].stringValue
    }
    
    init(name:String,carId:String) {
        self.carNumber = name
        self.entityId = carId
    }
    
    override init() {
       
    }
    
}

//
//  CQBussinessAddLayout.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/10/29.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit

class CQBussinessAddLayout: TGLinearLayout {

    var curName = ""
    var type = ""
    var curTitle = ""
    
    var actionLayout:TGLinearLayout!
    var traficArray = [NCQApprovelDetailModel]()
    var transport = ""
    var isBack = false
    var fromCity = ""
    var toCity = ""
    var startTime = ""
    var endTime = ""
    var duration = ""
    convenience init(orientation: TGOrientation,name:String,type:String,title:String,transport:String,isBack:Bool,fromCity:String,toCity:String,startTime:String,endTime:String,duration:String,traficArray:[NCQApprovelDetailModel]) {
        self.init(frame: CGRect.zero, orientation: orientation, name: name, type: type, title: title, transport: transport, isBack: isBack, fromCity: fromCity, toCity: toCity, startTime: startTime, endTime: endTime, duration: duration,traficArray:traficArray)
    }
    
    init(frame: CGRect, orientation: TGOrientation,name:String,type:String,title:String,transport:String,isBack:Bool,fromCity:String,toCity:String,startTime:String,endTime:String,duration:String,traficArray:[NCQApprovelDetailModel]) {
        super.init(frame: frame, orientation: orientation)
        
        self.actionLayout = TGLinearLayout(.vert)
        actionLayout.tg_width.equal(.wrap)
        actionLayout.tg_height.equal(.wrap)
        self.addSubview(actionLayout)
        
        self.tg_height.equal(.wrap)
        self.tg_width.equal(kWidth)
        self.curName = name
        self.type = type
        self.curTitle = title
        self.transport = transport
        self.isBack = isBack
        self.fromCity = fromCity
        self.toCity = toCity
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.traficArray = traficArray
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()  {
        
        self.actionLayout.addSubview(CQSubLayout.init(orientation: .horz, name: "行程", type: "sub", title: "行程"))
        var value = ""
        for model in self.traficArray{
            if model.value == self.transport{
                value = model.text
            }
        }
        self.transport = value
        self.actionLayout.addSubview(CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "交通工具", prompt: "", require: false, content: value))
        if self.isBack{
            self.actionLayout.addSubview(CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "单程往返", prompt: "", require: false, content: "往返"))
        }else{
            self.actionLayout.addSubview(CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "单程往返", prompt: "", require: false, content: "单程"))
        }
        self.actionLayout.addSubview(CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "出发城市", prompt: "", require: false, content: self.fromCity))
        self.actionLayout.addSubview(CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "目的城市", prompt: "", require: false, content: self.toCity))
        self.actionLayout.addSubview(CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "开始时间", prompt: "", require: false, content: self.startTime))
        self.actionLayout.addSubview(CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "结束时间", prompt: "", require: false, content: self.endTime))
        self.actionLayout.addSubview(CQApprovelContentLayout.init(orientation: .horz, name: "", type: "", title: "时长(天)", prompt: "", require: false, content: self.duration))
    }
    
    
}




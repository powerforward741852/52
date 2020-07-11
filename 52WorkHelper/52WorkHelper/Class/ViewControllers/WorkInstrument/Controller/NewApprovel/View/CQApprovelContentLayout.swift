//
//  CQApprovelContentLayout.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/10/28.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit

class CQApprovelContentLayout: TGLinearLayout {

    var curName = ""
    var type = ""
    var curTitle = ""
    var prompt = ""
    var required = false
    var content = ""
    var viewHeight:CGFloat = 0
    
    
    convenience init(orientation: TGOrientation,name:String,type:String,title:String,prompt:String,require:Bool,content:String) {
        self.init(frame: CGRect.zero, orientation: orientation, name: name, type: type, title: title, prompt: prompt, require: require,content:content)
        
    }
    
    init(frame: CGRect, orientation: TGOrientation,name:String,type:String,title:String,prompt:String,require:Bool,content:String) {
        super.init(frame: frame, orientation: orientation)
        self.tg_height.equal(.wrap)
        self.tg_width.equal(kWidth)
        self.curName = name
        self.type = type
        self.curTitle = title
        self.prompt = prompt
        self.required = require
        self.content = content
        
        if self.curName == "vacationType"{
            self.getLeaveTypeRequest(time: content)
        }else{
            self.initView()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()  {
        self.addSubview(self.addxingLable())
        self.addSubview(self.addTitleLable(title: self.content))
    }
    
    
}


// Mark 整个界面可能用到的控件
extension CQApprovelContentLayout{
    
    
    //*号 在非必填时 隐藏
    @objc internal func addxingLable() -> UILabel{
        let lab = UILabel.init()
        lab.font = kFontSize15
        lab.textAlignment = .left
        lab.textColor = kLyGrayColor
        lab.tg_height.equal(.wrap)
        lab.tg_width.equal(AutoGetWidth(width: 100))
        lab.tg_left.equal(AutoGetWidth(width: 15))
        lab.tg_top.equal(AutoGetHeight(height: 15))
        lab.text = self.curTitle
        return lab
    }
    
    @objc internal func addTitleLable(title:String) -> UILabel{
        let lab = UILabel.init()
        lab.text = self.content
        lab.font = kFontSize15
        lab.textAlignment = .left
        lab.textColor = UIColor.black
        lab.tg_width.equal(kWidth - AutoGetWidth(width: 150))
        lab.tg_left.equal(AutoGetWidth(width: 20))
        lab.numberOfLines = 0
        lab.contentMode = .topLeft
        lab.tag = 100
        let labHeight = getTextHeight(text: self.content, font: kFontSize15, width: kWidth - AutoGetWidth(width: 150)) + AutoGetHeight(height: 10)
        lab.tg_height.equal(labHeight)
        lab.tg_top.equal(AutoGetHeight(height: 10))
        self.viewHeight = labHeight + AutoGetHeight(height: 10)
        return lab
    }
    
}

extension CQApprovelContentLayout{
    //获取所有请假类型
    func getLeaveTypeRequest(time:String) {
        let userID = STUserTool.account().userID
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getAllVacationType" ,
            type: .get,
            param: ["emyeId":userID],
            successCallBack: { (result) in
                var textArray = [String]()
                var valueArray = [String]()
                for modalJson in result["data"].arrayValue {
                    
                    let model = modalJson.dictionaryValue
                    textArray.append((model["text"]?.stringValue)!)
                    valueArray.append((model["value"]?.stringValue)!)
                }

                for i in 0..<valueArray.count{
                    if valueArray[i] == time{
                        self.content = textArray[i]
                    }
                }
                
                self.initView()
                
        }) { (error) in
            
        }
    }
}


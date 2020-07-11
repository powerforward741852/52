//
//  CQAddTravelLayout.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/10/26.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit

class CQAddTravelLayout: TGLinearLayout {

    var curName = ""
    var type = ""
    var curTitle = ""
    
    var actionLayout:TGLinearLayout!
    //记录当前为哪个行程
    var index = 2
    
    //交通数组
    var traficArray = [NCQApprovelModel]()
    //往返数组
    var backArray = [CQBackModel]()
    
    convenience init(orientation: TGOrientation,name:String,type:String,title:String,traficArray:[NCQApprovelModel],backArray:[CQBackModel]) {
        self.init(frame: CGRect.zero, orientation: orientation, name: name, type: type, title: title,traficArray:traficArray,backArray:backArray)
        
    }
    
    init(frame: CGRect, orientation: TGOrientation,name:String,type:String,title:String,traficArray:[NCQApprovelModel],backArray:[CQBackModel]) {
        super.init(frame: frame, orientation: orientation)
        
        self.actionLayout = TGLinearLayout(.vert)
        actionLayout.tg_width.equal(.wrap)
        actionLayout.tg_height.equal(.wrap)
        actionLayout.tag = 10086
        self.addSubview(actionLayout)
        
        self.tg_height.equal(.wrap)
        self.tg_width.equal(kWidth)
        self.curName = name
        self.type = type
        self.curTitle = title
        self.traficArray = traficArray
        self.backArray = backArray
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()  {
        self.actionLayout.addSubview(self.addAddLayout())
    }
    
    @objc func handleAction()  {
        NotificationCenter.default.post(name: NSNotification.Name.init("cancelKeyBoard"), object: nil)
        for v in self.actionLayout.subviews{
            if v.tag == 1000{
                v.removeFromSuperview()
            }
        }
        let layout = CQTravelListLayout.init(orientation: .horz, name: "行程", type: "行程", title:"行程" + "\(self.index)"  , viewTag: index + 100,traficArray:self.traficArray,backArray:self.backArray)
        self.actionLayout.addSubview(layout)
        self.actionLayout.addSubview(self.addAddLayout())
        self.index += 1
        NotificationCenter.default.post(name: NSNotification.Name.init("addHeight"), object: nil)
    }
    
    
}

//layout
extension CQAddTravelLayout{
    //标题
    internal func addAddLayout() -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(kWidth)
        wrapContentLayout.tag = 1000
        wrapContentLayout.addSubview(self.addSelectBtn())
        
        return wrapContentLayout
    }
}

// Mark 整个界面可能用到的控件
extension CQAddTravelLayout{
    @objc internal func addSelectBtn() -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.addTarget(self ,action:#selector(handleAction), for:.touchUpInside)
        btn.setTitle( " 增加行程" ,for:.normal)
        btn.titleLabel!.font = kFontSize15
        btn.setTitleColor(kLightBlueColor, for: .normal)
        btn.setImage(UIImage.init(named: "PersonAddressAdd"), for: .normal)
        btn.tag = 200
        btn.tg_height.equal(AutoGetHeight(height: 55))
        btn.tg_width.equal(kWidth)
        return btn
    }
    
}

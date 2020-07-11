//
//  CQTextInputLayout.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/10/22.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit

class CQTextInputLayout: TGLinearLayout {

    var curName = ""
    var type = ""
    var curTitle = ""
    var prompt = ""
    var required = false
    
    var actionLayout:TGLinearLayout!
    var textView:CBTextView!
    var preText = ""
    
    convenience init(orientation: TGOrientation,name:String,type:String,title:String,prompt:String,require:Bool,preText:String) {
        self.init(frame: CGRect.zero, orientation: orientation, name: name, type: type, title: title, prompt: prompt, require: require,preText:preText)
        
    }
    
    init(frame: CGRect, orientation: TGOrientation,name:String,type:String,title:String,prompt:String,require:Bool,preText:String) {
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
        self.prompt = prompt
        self.required = require
        self.preText = preText
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()  {
        self.actionLayout.addSubview(self.addTitleLayout())
        self.actionLayout.addSubview(self.addTextContentLayout(placeHolder: self.curTitle, preText: self.preText))
    }
    
    
}



// Mark 整个界面可能用到的控件
extension CQTextInputLayout{
    
    //*号 在非必填时 隐藏
    @objc internal func addxingLable() -> UILabel{
        let lab = UILabel.init()
        lab.font = kFontSize15
        lab.textAlignment = .left
        lab.textColor = UIColor.red
        lab.tg_height.equal(AutoGetHeight(height: 55))
        lab.tg_left.equal(AutoGetWidth(width: 15))
        if self.required{
            lab.tg_width.equal(AutoGetWidth(width: 20))
            lab.text = "*"
        }else{
            lab.tg_width.equal(AutoGetWidth(width: 20))
            lab.text = ""
        }
        return lab
    }
    
    @objc internal func addTitleLable(title:String) -> UILabel{
        let lab = UILabel.init()
        lab.text = title
        lab.font = kFontSize15
        lab.textAlignment = .left
        lab.textColor = UIColor.black
        let labWidth = getTexWidth(textStr: title, font: kFontSize15, height: AutoGetHeight(height: 15)) + AutoGetWidth(width: 10)
        lab.tg_width.equal(labWidth)
        lab.tg_height.equal(AutoGetHeight(height: 55))
        return lab
    }
    
    //标题
    internal func addTitleLayout() -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(kWidth)
        wrapContentLayout.addSubview(self.addxingLable())
        wrapContentLayout.addSubview(self.addTitleLable(title: self.curTitle))
        
        return wrapContentLayout
    }
    
    
    @objc internal func addtextContentView(leftDis:CGFloat,placeHolder:String,pretext:String) -> CBTextView {
        textView = CBTextView.init()
        textView.backgroundColor = UIColor.white
        textView.tg_left.equal(leftDis)
        textView.tg_width.equal(kWidth - 2*leftDis)
        textView.tg_height.equal(AutoGetHeight(height: 109))
        textView.aDelegate = self
        textView.textView.backgroundColor = UIColor.white
        textView.textView.font = kFontSize15
        textView.textView.textColor = UIColor.black
        textView.layer.borderColor = kLyGrayColor.cgColor
//        textView.layer.borderWidth = 0.5
//        textView.layer.cornerRadius = 2
        textView.placeHolder = "请输入" + placeHolder
        textView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        if !pretext.isEmpty {
            textView.prevText = pretext
        }
        
        return textView
    }
    
    
    //请假事由
    internal func addTextContentLayout(placeHolder:String,preText:String) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        
        wrapContentLayout.addSubview(self.addtextContentView(leftDis: AutoGetWidth(width: 32),placeHolder:placeHolder, pretext: preText ))
        
        return wrapContentLayout
    }

}


extension CQTextInputLayout:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
}

//
//  CQTelNumLayout.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/11/5.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit
//电话号码，手机号码，大写金额,邮箱
class CQTelNumLayout: TGLinearLayout {

    var curName = ""
    var type = ""
    var curTitle = ""
    var prompt = ""
    var required = false
    var phoneType = ""
    var validate = false
    var telNum = ""

    
    convenience init(orientation: TGOrientation,name:String,type:String,title:String,prompt:String,require:Bool,phoneType:String,validate:Bool,telNum:String) {
        self.init(frame: CGRect.zero, orientation: orientation, name: name, type: type, title: title, prompt: prompt, require: require,phoneType:phoneType,validate:validate,telNum:telNum)
        
    }
    
    init(frame: CGRect, orientation: TGOrientation,name:String,type:String,title:String,prompt:String,require:Bool,phoneType:String,validate:Bool,telNum:String) {
        super.init(frame: frame, orientation: orientation)
        self.tg_height.equal(.wrap)
        self.tg_width.equal(kWidth)
        self.curName = name
        self.type = type
        self.curTitle = title
        self.prompt = prompt
        self.required = require
        self.phoneType = phoneType
        self.validate = validate
        self.telNum = telNum
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()  {
        self.addSubview(self.addxingLable())
        self.addSubview(self.addTitleLable(title: self.curTitle))
//        if !self.telNum.isEmpty{
            self.addSubview(self.addFieldInput(placeHolder: self.prompt, text: self.telNum))
//        }
    }
    
    
}

// Mark 整个界面可能用到的控件
extension CQTelNumLayout{
    
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
//        let labWidth = getTexWidth(textStr: title, font: kFontSize15, height: AutoGetHeight(height: 15)) + AutoGetWidth(width: 10)
        lab.tg_width.equal(AutoGetWidth(width: 85))
        lab.tg_height.equal(AutoGetHeight(height: 55))
        return lab
    }
    
    @objc internal func addFieldInput(placeHolder:String,text:String) -> MyTextField {
        let textField = MyTextField.init()
        textField.tg_width.equal(kWidth - AutoGetWidth(width: 135))
//        textField.tg_right.equal(kLeftDis)
        textField.tg_height.equal(AutoGetHeight(height: 55))
        textField.placeholder = placeHolder
        textField.keyboardType = .numberPad
        textField.delegate = self
        textField.keyBoardDelegate = self
        textField.clearButtonMode = .never
        textField.font = kFontSize15
        textField.contentHorizontalAlignment = .right
        textField.textAlignment = .right
        textField.textColor = UIColor.black
        textField.tintColor = UIColor.black
        textField.text = text
        textField.tag = 401
        return textField
    }
    
}

extension CQTelNumLayout:UITextFieldDelegate,KeyBoardDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if self.isInputRuleNotBlank(str: string) || string == ""{
            return true
        }else{
            SVProgressHUD.showInfo(withStatus: "不支持emoji表情")
            return false
        }
    }
    
    func isInputRuleNotBlank(str:String)->Bool{
        let pattern = "^[a-zA-Z\\u4E00-\\u9FA5\\d]*$"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch = pred.evaluate(with: str)
        if !isMatch{
            let other = "➋➌➍➎➏➐➑➒"
            let len = str.count
            for i in 0..<len{
                let tmpStr = str as NSString
                let tmpOther = other as NSString
                let c = tmpStr.character(at: i)
                
                if !((isalpha(Int32(c))) > 0 || (isalnum(Int32(c))) > 0 || ((Int(c) == "_".hashValue)) || (Int(c) == "-".hashValue) || ((c >= 0x4e00 && c <= 0x9fa6)) || (tmpOther.range(of: str).location != NSNotFound)) {
                    return false
                }
                return true
            }
        }
        return isMatch
    }
    
    func isInputRuleAndBlank(str:String)->Bool{
        let pattern = "^[a-zA-Z\\u4E00-\\u9FA5\\d\\s]*$"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch = pred.evaluate(with: str)
        return isMatch
    }
    
    func disable_emoji(str:String)->String{
        let regex = try!NSRegularExpression.init(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]", options: .caseInsensitive)
        
        let modifiedString = regex.stringByReplacingMatches(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange.init(location: 0, length: str.count), withTemplate: "")
        return modifiedString
    }
    
    
    
    func getSubString(str:String) -> String{
        if str.count>120{
            SVProgressHUD.showInfo(withStatus: "最多输入120个字")
            //            return str[0..<(120)]
            return (str as NSString).substring(with: NSRange.init(location: 0, length: 120))
        }
        return str
    }
    
    @objc func textFieldEditChanged(obj:Notification)  {
        
    }
    
}

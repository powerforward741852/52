//
//  CQScheduleUnagreeView.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/7.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol CQScheduleReasonDelegate : NSObjectProtocol{
    func disagreeForReason(txt:String)
}

class CQScheduleUnagreeView: UIView {

    var textViewEditing:Bool = false
    weak var reasonDelegate:CQScheduleReasonDelegate?
    lazy var bgView: UIView = {
        let bgView = UIView.init(frame: CGRect.init(x: 0, y: kHeight - AutoGetHeight(height: 240), width: kWidth, height: AutoGetHeight(height: 240)))
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton.init(type: .custom)
        cancelBtn.frame = CGRect.init(x: 0, y: 5, width: AutoGetWidth(width: 60), height: AutoGetHeight(height: 30))
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor.black, for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        return cancelBtn
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton.init(type: .custom)
        sureBtn.frame = CGRect.init(x: kWidth - AutoGetWidth(width: 60), y: 5, width: AutoGetWidth(width: 60), height: AutoGetHeight(height: 30))
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(UIColor.black, for: .normal)
        sureBtn.addTarget(self, action: #selector(sureClick), for: .touchUpInside)
        return sureBtn
    }()
    
    lazy var titleLab: UILabel = {
        let titleLab = UILabel.init(frame: CGRect.init(x: kWidth/3, y: 0, width: kWidth/3, height: AutoGetHeight(height: 30)))
        titleLab.text = "原因"
        titleLab.textColor = UIColor.black
        titleLab.textAlignment = .center
        titleLab.font = kFontSize15
        return titleLab
    }()
    
    lazy var textView: CBTextView = {
        let textView = CBTextView.init(frame: CGRect.init(x: AutoGetWidth(width: 15), y:self.titleLab.bottom + AutoGetWidth(width: 13), width: kWidth - AutoGetWidth(width: 30), height: AutoGetHeight(height: 150)))
        textView.aDelegate = self
        textView.textView.backgroundColor = UIColor.white
        textView.textView.font = UIFont.systemFont(ofSize: 15)
        textView.textView.textColor = UIColor.black
        
        textView.placeHolder = "请输入原因"
        textView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp()  {
        self.addSubview(self.bgView)
        self.bgView.addSubview(cancelBtn)
        self.bgView.addSubview(self.sureBtn)
        self.bgView.addSubview(self.titleLab)
        self.bgView.addSubview(self.textView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification:Notification)  {
        self.textViewEditing = true
        self.frame = UIScreen.main.bounds
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let aValue:NSValue = userInfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRect = aValue.cgRectValue
        let height:CGFloat = CGFloat(keyboardRect.size.height)
        self.bgView.frame = CGRect.init(x: 0, y: kHeight - height - AutoGetHeight(height: 200), width: kWidth, height: AutoGetHeight(height: 200))
        
    }
    
    @objc func keyboardWillHide(notification:Notification)  {
        self.bgView.frame = CGRect.init(x: 0, y: kHeight  - AutoGetHeight(height: 200), width: kWidth, height: AutoGetHeight(height: 200))
    }
    
    @objc func dismissView()  {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (finished:Bool) in
            self.removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        let point = touch.location(in: self)
        if point.x < self.bgView.frame.origin.x || point.x > self.bgView.frame.origin.x || point.y < self.bgView.frame.origin.y || point.y > self.bgView.frame.origin.y {
            if self.textViewEditing{
                self.textView.resignFirstResponder()
                self.textViewEditing = false
            }else{
                UIView.animate(withDuration: 0.3, animations: {
                    self.alpha = 0
                }) { (finished:Bool) in
                    self.removeFromSuperview()
                }
            }
            
        }
    }
    
    @objc func cancelClick()  {
        self.dismissView()
    }
    
    @objc func sureClick()  {
        if self.reasonDelegate != nil && !self.textView.textView.text.isEmpty{
            var text = self.textView.textView.text
            if text == self.textView.placeHolder{
                text = ""
            }
            if (text?.count)! > 0 {
                self.reasonDelegate?.disagreeForReason(txt: self.textView.textView.text)
            }else{
                SVProgressHUD.showInfo(withStatus: "请输入原因")
            }
        }
    }
    
    

}

extension CQScheduleUnagreeView:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
}


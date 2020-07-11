//
//  CQApprovalRemarkView.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/25.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol CQApprovalRemarkDelegate : NSObjectProtocol {
    func getApprovelDoing(remark:String,isAgree:Bool)
}

class CQApprovalRemarkView: UIView {
    var isTurnSomeOne = false
    var viewTitle = ""
    weak var cqRemarkDelegate:CQApprovalRemarkDelegate?
    var isAgree:Bool?
    var placeHolder = ""
    var isFromIndex = false
    lazy var bgView: UIView = {
        let bgView = UIView.init(frame: CGRect.init(x: (kWidth - AutoGetWidth(width: 270))/2, y: AutoGetHeight(height: 180), width: AutoGetWidth(width: 270), height: AutoGetHeight(height: 200)))
        bgView.backgroundColor = UIColor.white
        bgView.layer.cornerRadius = 3
        bgView.clipsToBounds = true
        return bgView
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: 0, y: 0, width:AutoGetWidth(width: 270), height: AutoGetHeight(height: 50)))
        
        nameLab.backgroundColor = kLightBlueColor
        nameLab.textAlignment = .center
        nameLab.font = kFontSize15
        nameLab.textColor = UIColor.white
        return nameLab
    }()

    lazy var textView: CBTextView = {
        let textView = CBTextView.init(frame: CGRect.init(x: AutoGetWidth(width: 15), y:self.nameLab.bottom , width: self.bgView.width - AutoGetWidth(width: 30), height: AutoGetHeight(height: 100)))
        textView.aDelegate = self
        textView.textView.backgroundColor = UIColor.white
        textView.textView.font = UIFont.systemFont(ofSize: 15)
        textView.textView.textColor = UIColor.black
        
        textView.placeHolder = self.placeHolder
        textView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        
        return textView
    }()
    
    init(frame: CGRect,viewTitle:String,isAgree:Bool,placeHolder:String) {
        super.init(frame: frame)
        self.viewTitle = viewTitle
        self.isAgree = isAgree
        self.placeHolder = placeHolder
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp()  {
        
        self.addSubview(self.bgView)
        self.bgView.addSubview(self.nameLab)
        self.nameLab.text = self.viewTitle
        self.bgView.addSubview(self.textView)
        
        let titleArr = ["取消","确定"]
        for i in 0..<2 {
            let btn = UIButton.init(type: .custom)
            btn.frame = CGRect.init(x: AutoGetWidth(width: 135) * CGFloat(i), y: self.textView.bottom, width: AutoGetWidth(width: 135), height: AutoGetHeight(height: 50))
            btn.setTitle(titleArr[i], for: .normal)
            if 0 == i{
                btn.setTitleColor(UIColor.red, for: .normal)
            }else{
                btn.setTitleColor(UIColor.black, for: .normal)
            }
            btn.tag = 100 + i
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: UIControlEvents.touchUpInside)
            self.bgView.addSubview(btn)
        }
        
    }
    
    @objc func btnClick(btn:UIButton) {
        if 100 == btn.tag {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }) { (finished:Bool) in
                self.removeFromSuperview()
            }
        }else{
            var txt = self.textView.textView.text
            if self.textView.placeHolder == txt{
                txt = ""
            }
            if !self.isFromIndex{
                if !isAgree!{
                    if (txt?.count)! > 0 {
                        if self.cqRemarkDelegate != nil{
                            self.cqRemarkDelegate?.getApprovelDoing(remark: txt!,isAgree: self.isAgree!)
                        }
                    }else{
                        SVProgressHUD.showInfo(withStatus: "请输入备注")
                    }
                }else{
                    if self.cqRemarkDelegate != nil{
                        self.cqRemarkDelegate?.getApprovelDoing(remark: txt!,isAgree: self.isAgree!)
                    }
                }
            }else{
                if (txt?.count)! > 0 {
                        if self.cqRemarkDelegate != nil{
                            self.cqRemarkDelegate?.getApprovelDoing(remark: txt!,isAgree: self.isAgree!)
                        }
                }else{
                        SVProgressHUD.showInfo(withStatus: "请输入群名称")
                }
            }
            
            
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        let point = touch.location(in: self)
        if point.x < self.bgView.frame.origin.x || point.x > self.bgView.frame.origin.x || point.y < self.bgView.frame.origin.y || point.y > self.bgView.frame.origin.y {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }) { (finished:Bool) in
                self.removeFromSuperview()
            }
        }
    }
}

extension CQApprovalRemarkView:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
}

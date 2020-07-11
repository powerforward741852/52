//
//  CQVersionView.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/7/20.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol CQVersionUpdataClickDelegate :NSObjectProtocol{
    func versionUpdataAction(url:String)
}

class CQVersionView: UIView {

    var urlStr = ""
    weak var vDelegate:CQVersionUpdataClickDelegate?
    //强转更新
    init(frame:CGRect,title:String,message:String,urlStr:String) {
        super.init(frame: frame)
        self.urlStr = urlStr
        self.initView()
    }
    //非强制更新
    init(title:String,message:String,urlStr:String) {
        super.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHeight))
        self.urlStr = urlStr
        self.initViewF()
    }
    
    func initViewF()  {
        self.addSubview(self.bgView)
        self.bgView.addSubview(self.titleLab)
        self.bgView.addSubview(self.messageLab)
        self.bgView.addSubview(self.goBtn)
        self.bgView.addSubview(self.cancelBtn)
        goBtn.frame = CGRect(x: AutoGetHeight(height: 5), y: self.messageLab.bottom + AutoGetHeight(height: 5), width: (bgView.width-AutoGetWidth(width: 20))/2, height: AutoGetHeight(height: 40))
        cancelBtn.frame = CGRect(x: goBtn.right+AutoGetHeight(height: 10), y: goBtn.mj_y, width: goBtn.width, height: goBtn.mj_h)
    }
    
    func initView()  {
        self.addSubview(self.bgView)
        self.bgView.addSubview(self.titleLab)
        self.bgView.addSubview(self.messageLab)
        self.bgView.addSubview(self.goBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func goClick()  {
        if self.vDelegate != nil{
            self.vDelegate?.versionUpdataAction(url: self.urlStr)
        }
    }
    
    @objc func goCancel()  {
//        if self.vDelegate != nil{
//            self.vDelegate?.versionUpdataAction(url: self.urlStr)
//        }
        self.dismiss()
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView.init(frame: CGRect.init(x: AutoGetWidth(width: 40), y: AutoGetHeight(height: 260), width: kWidth - AutoGetWidth(width: 80), height:AutoGetHeight(height: 180)))
        bgView.layer.cornerRadius = 8
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    
    lazy var titleLab: UILabel = {
        let titleLab = UILabel.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 8), width: kWidth - AutoGetWidth(width: 80), height: AutoGetHeight(height: 30)))
        titleLab.text = "新版本通知"
        titleLab.textColor = UIColor.black
        titleLab.textAlignment = .center
        titleLab.font = kFontSize17
        return titleLab
    }()
    
    lazy var messageLab: UILabel = {
        let messageLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.titleLab.bottom + AutoGetHeight(height: 5), width: kWidth - AutoGetWidth(width: 80) - 2 * kLeftDis, height: AutoGetHeight(height: 70)))
        messageLab.text = "现在就去更新"
        messageLab.textColor = kLyGrayColor
        messageLab.textAlignment = .left
        messageLab.numberOfLines = 0
        messageLab.font = kFontSize15
        return messageLab
    }()
    
    lazy var goBtn: UIButton = {
        let goBtn = UIButton.init(type: .custom)
        goBtn.frame = CGRect.init(x: kLeftDis, y: self.messageLab.bottom + AutoGetHeight(height: 5), width: kWidth - 2 * kLeftDis - AutoGetWidth(width: 80), height: AutoGetHeight(height: 49))
        goBtn.setTitle("去AppStore更新", for: .normal)
        goBtn.setTitleColor(UIColor.white, for: .normal)
        goBtn.backgroundColor = kLightBlueColor
        goBtn.layer.cornerRadius = 3
        goBtn.titleLabel?.font = kFontSize15
        goBtn.addTarget(self, action: #selector(goClick), for: .touchUpInside)
        return goBtn
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton.init(type: .custom)
        cancelBtn.frame = CGRect.init(x: kLeftDis, y: self.messageLab.bottom + AutoGetHeight(height: 5), width: kWidth - 2 * kLeftDis - AutoGetWidth(width: 80), height: AutoGetHeight(height: 49))
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor.white, for: .normal)
        cancelBtn.backgroundColor = kLightBlueColor
        cancelBtn.layer.cornerRadius = 3
        cancelBtn.titleLabel?.font = kFontSize15
        cancelBtn.addTarget(self, action: #selector(goCancel), for: .touchUpInside)
        return cancelBtn
    }()
}

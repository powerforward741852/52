//
//  CQCheckAddantenceView.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/4/26.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit


protocol SignForWorkDelegate : NSObjectProtocol{
    func signActionComplete()
    func finishWorkActionComplete(time:String,ruleTime:String)
}

class CQCheckAddantenceView: UIView {

    
    weak var signDelegate:SignForWorkDelegate?
    var currentTime = ""
    var amStartRule = ""
    var signOutTime = ""
    
    var dataArray: [CQCheckInstanceModel]? {
        didSet {
            self.initView(dataArr:self.dataArray!)
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: AutoGetWidth(width: 317), height: AutoGetHeight(height: 309)))
        scrollView.clipsToBounds = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        let now = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "HH:mm:ss"
        currentTime = dateFormat.string(from: now)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func initView(dataArr:[CQCheckInstanceModel]) {
        self.addSubview(self.scrollView)
        scrollView.contentSize = CGSize.init(width: AutoGetWidth(width: 74) + AutoGetWidth(width: 317) * CGFloat((self.dataArray?.count)!), height: AutoGetHeight(height: 309))
        
        for i  in 0..<dataArr.count {
            let btnV = UIImageView.init(frame: CGRect.init(x: AutoGetWidth(width: 37) + AutoGetWidth(width: 317) * CGFloat(i) , y: AutoGetHeight(height: 24), width: AutoGetWidth(width: 302), height: AutoGetHeight(height: 261)))
            btnV.image = UIImage.init(named: "checkOutBg")
            btnV.isUserInteractionEnabled = true
            
            let model:CQCheckInstanceModel?
            if 0 == i {
                model = self.dataArray?[i]
                let lab1 = UILabel.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 30), width: AutoGetWidth(width: 302), height: AutoGetHeight(height: 18)))
                lab1.font = UIFont.systemFont(ofSize: 18)
                let ruleStr = model!.ruleTime as NSString
                let ruleSubStr = ruleStr.substring(with: NSRange.init(location: 0, length: 5))
                lab1.text = model!.ruleDesc + " " + ruleSubStr
                lab1.textAlignment = .center
//                btnV.addSubview(lab1)
                
                let btn1 = UIButton.init(type: UIButtonType.custom)
                btn1.frame = CGRect.init(x: (AutoGetWidth(width: 302) - AutoGetWidth(width: 124))/2, y: lab1.bottom + AutoGetHeight(height: 26), width: AutoGetWidth(width: 124), height: AutoGetWidth(width: 124))
                btn1.layer.cornerRadius = AutoGetWidth(width: 62)
                btn1.clipsToBounds = true
                btn1.tag = 300 + i
                if model!.attendanceTime.count < 1{
                    if model?.prompt == "缺勤"{
                        btn1.setTitle("补卡", for: .normal)
                    }else{
                        btn1.setTitle(model?.prompt, for: .normal)
                    }
                }else if model!.attendanceTime.count > 4 {
                    btn1.isUserInteractionEnabled = false
                    btn1.setTitle(((model?.attendanceTime)! as NSString).substring(with: NSRange.init(location: 0, length: 5)), for: .normal)
                }else{
                    btn1.isUserInteractionEnabled = false
                    btn1.setTitle(model?.attendanceTime, for: .normal)
                }
                btn1.titleLabel?.font = kFontSize21
                
                btn1.titleLabel?.textAlignment = .center
                
                btn1.addTarget(self, action: #selector(signClick(btn:)), for: UIControlEvents.touchUpInside)
                btnV.addSubview(btn1)
                
                let staL = UILabel.init(frame: CGRect.init(x: 0, y: btn1.bottom + AutoGetHeight(height: 25), width: AutoGetWidth(width: 302), height: AutoGetHeight(height: 14)))
                staL.textAlignment = .center
                if (model?.pushAttendance.count)! > 0{
                    staL.text = model!.pushAttendance
                }else{
                    staL.text = model!.abnormalDesc
                }
                
                if model?.abnormalDesc == "迟到" || model?.abnormalDesc == "旷工" || model?.abnormalDesc == "早退"{
                    btn1.setBackgroundImage(UIImage.init(named: "pmBg"), for: UIControlState.normal)
                }else{
                    btn1.setBackgroundImage(UIImage.init(named: "amBg"), for: UIControlState.normal)
                }
                
                staL.font = UIFont.systemFont(ofSize: 14)
                staL.textColor = UIColor.colorWithHexString(hex: "#a9a9a9")
                btnV.addSubview(staL)
            }else if 1 == i {
                model = self.dataArray?[i]
                let lab1 = UILabel.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 30), width: AutoGetWidth(width: 302), height: AutoGetHeight(height: 18)))
                lab1.font = UIFont.systemFont(ofSize: 18)
                let ruleStr = model!.ruleTime as NSString
                let ruleSubStr = ruleStr.substring(with: NSRange.init(location: 0, length: 5))
                lab1.text = model!.ruleDesc + " " + ruleSubStr
                lab1.textAlignment = .center
//                btnV.addSubview(lab1)
                
                let btn1 = UIButton.init(type: UIButtonType.custom)
                btn1.frame = CGRect.init(x: (AutoGetWidth(width: 302) - AutoGetWidth(width: 124))/2, y: lab1.bottom + AutoGetHeight(height: 26), width: AutoGetWidth(width: 124), height: AutoGetWidth(width: 124))
                btn1.layer.cornerRadius = AutoGetWidth(width: 62)
                btn1.clipsToBounds = true
                btn1.tag = 300 + i
                if model!.attendanceTime.count < 1{
                    if model?.prompt == "缺勤"{
                        btn1.setTitle("补卡", for: .normal)
                    }else{
                        btn1.setTitle(model?.prompt, for: .normal)
                    }
                }else{
                    self.signOutTime = (model?.attendanceTime)!
                    btn1.isUserInteractionEnabled = false
                    btn1.setTitle(((model?.attendanceTime)! as NSString).substring(with: NSRange.init(location: 0, length: 5)), for: .normal)
                }
                btn1.titleLabel?.font = kFontSize21
                btn1.titleLabel?.textAlignment = .center
                if model?.abnormalDesc == "迟到" || model?.abnormalDesc == "旷工" || model?.abnormalDesc == "早退"{
                    btn1.setBackgroundImage(UIImage.init(named: "pmBg"), for: UIControlState.normal)
                }else{
                    btn1.setBackgroundImage(UIImage.init(named: "amBg"), for: UIControlState.normal)
                }
                btn1.addTarget(self, action: #selector(workFinishClick(btn:)), for: UIControlEvents.touchUpInside)
                btnV.addSubview(btn1)
                
                let staL = UILabel.init(frame: CGRect.init(x: 0, y: btn1.bottom + AutoGetHeight(height: 25), width: AutoGetWidth(width: 302), height: AutoGetHeight(height: 14)))
                staL.textAlignment = .center
                if (model?.pushAttendance.count)! > 0{
                    staL.text = model!.pushAttendance
                }else{
                    staL.text = model!.abnormalDesc
                }
                staL.font = UIFont.systemFont(ofSize: 14)
                staL.textColor = UIColor.colorWithHexString(hex: "#a9a9a9")
                btnV.addSubview(staL)
            }else if 2 == i {
                model = self.dataArray?[i]
                let lab1 = UILabel.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 30), width: AutoGetWidth(width: 302), height: AutoGetHeight(height: 18)))
                lab1.font = UIFont.systemFont(ofSize: 18)
                let ruleStr = model!.ruleTime as NSString
                let ruleSubStr = ruleStr.substring(with: NSRange.init(location: 0, length: 5))
                lab1.text = model!.ruleDesc + " " + ruleSubStr
                lab1.textAlignment = .center
//                btnV.addSubview(lab1)
                
                let btn1 = UIButton.init(type: UIButtonType.custom)
                btn1.frame = CGRect.init(x: (AutoGetWidth(width: 302) - AutoGetWidth(width: 124))/2, y: lab1.bottom + AutoGetHeight(height: 26), width: AutoGetWidth(width: 124), height: AutoGetWidth(width: 124))
                btn1.layer.cornerRadius = AutoGetWidth(width: 62)
                btn1.clipsToBounds = true
                btn1.tag = 300 + i
                btn1.titleLabel?.font = kFontSize21
                if model!.attendanceTime.count < 1{
                    if model?.prompt == "缺勤"{
                        btn1.setTitle("补卡", for: .normal)
                    }else{
                        btn1.setTitle(model?.prompt, for: .normal)
                    }
                }else{
                    btn1.isUserInteractionEnabled = false
                    btn1.setTitle(((model?.attendanceTime)! as NSString).substring(with: NSRange.init(location: 0, length: 5)), for: .normal)
                }
                
                btn1.titleLabel?.textAlignment = .center
                if model?.abnormalDesc == "迟到" || model?.abnormalDesc == "旷工" || model?.abnormalDesc == "早退"{
                    btn1.setBackgroundImage(UIImage.init(named: "pmBg"), for: UIControlState.normal)
                }else{
                    btn1.setBackgroundImage(UIImage.init(named: "amBg"), for: UIControlState.normal)
                }
                btn1.addTarget(self, action: #selector(signClick(btn:)), for: UIControlEvents.touchUpInside)
                btnV.addSubview(btn1)
                
                let staL = UILabel.init(frame: CGRect.init(x: 0, y: btn1.bottom + AutoGetHeight(height: 25), width: AutoGetWidth(width: 302), height: AutoGetHeight(height: 14)))
                staL.textAlignment = .center
                if (model?.pushAttendance.count)! > 0{
                    staL.text = model!.pushAttendance
                }else{
                    staL.text = model!.abnormalDesc
                }
                
                staL.font = UIFont.systemFont(ofSize: 14)
                staL.textColor = UIColor.colorWithHexString(hex: "#a9a9a9")
                btnV.addSubview(staL)
            }else if 3 == i {
                model = self.dataArray?[i]
                let lab1 = UILabel.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 30), width: AutoGetWidth(width: 302), height: AutoGetHeight(height: 18)))
                lab1.font = UIFont.systemFont(ofSize: 18)
                let ruleStr = model!.ruleTime as NSString
                let ruleSubStr = ruleStr.substring(with: NSRange.init(location: 0, length: 5))
                lab1.text = model!.ruleDesc + " " + ruleSubStr
                lab1.textAlignment = .center
//                btnV.addSubview(lab1)
                
                let btn1 = UIButton.init(type: UIButtonType.custom)
                btn1.frame = CGRect.init(x: (AutoGetWidth(width: 302) - AutoGetWidth(width: 124))/2, y: lab1.bottom + AutoGetHeight(height: 26), width: AutoGetWidth(width: 124), height: AutoGetWidth(width: 124))
                btn1.layer.cornerRadius = AutoGetWidth(width: 62)
                btn1.clipsToBounds = true
                btn1.tag = 300 + i
                btn1.titleLabel?.font = kFontSize21
                if model!.attendanceTime.count < 1{
                    if model?.prompt == "缺勤"{
                        btn1.setTitle("补卡", for: .normal)
                    }else{
                        btn1.setTitle(model?.prompt, for: .normal)
                    }
                }else{
                    self.signOutTime = (model?.attendanceTime)!
                    btn1.isUserInteractionEnabled = false
                    btn1.setTitle(((model?.attendanceTime)! as NSString).substring(with: NSRange.init(location: 0, length: 5)), for: .normal)
                }
                btn1.titleLabel?.textAlignment = .center
                if model?.abnormalDesc == "迟到" || model?.abnormalDesc == "旷工" || model?.abnormalDesc == "早退"{
                    btn1.setBackgroundImage(UIImage.init(named: "pmBg"), for: UIControlState.normal)
                }else{
                    btn1.setBackgroundImage(UIImage.init(named: "amBg"), for: UIControlState.normal)
                }
                btn1.addTarget(self, action: #selector(workFinishClick(btn:)), for: UIControlEvents.touchUpInside)
                btnV.addSubview(btn1)
                
                let staL = UILabel.init(frame: CGRect.init(x: 0, y: btn1.bottom + AutoGetHeight(height: 25), width: AutoGetWidth(width: 302), height: AutoGetHeight(height: 14)))
                staL.textAlignment = .center
                if (model?.pushAttendance.count)! > 0{
                    staL.text = model!.pushAttendance
                }else{
                    staL.text = model!.abnormalDesc
                }
                staL.font = UIFont.systemFont(ofSize: 14)
                staL.textColor = UIColor.colorWithHexString(hex: "#a9a9a9")
                btnV.addSubview(staL)
            }
            
            self.scrollView.addSubview(btnV)
        }
    }
    
    @objc func signClick(btn:UIButton) {
        if signDelegate != nil {
            signDelegate?.signActionComplete()
        }
    }
    
    @objc func workFinishClick(btn:UIButton)  {
        let time = self.dataArray![btn.tag - 300].ruleTime
        if signDelegate != nil {
            signDelegate?.finishWorkActionComplete(time: self.signOutTime,ruleTime: time)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

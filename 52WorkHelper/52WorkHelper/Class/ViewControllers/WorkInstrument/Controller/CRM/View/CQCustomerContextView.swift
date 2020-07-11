//
//  CQCustomerContextView.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/8/20.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol CQCustomerContextViewSexSelectDelegate : NSObjectProtocol{
    func selectSEX(sexSelect:UILabel ,fatherV:CQCustomerContextView)
    
}

protocol CQCustomerContextViewDeleteDelegate : NSObjectProtocol{
    func delete(deleteBut:UIButton ,fatherV:CQCustomerContextView)
}

class CQCustomerContextView: UIView {
    weak var deleteDalegate : CQCustomerContextViewDeleteDelegate?
    weak var selectDelegate : CQCustomerContextViewSexSelectDelegate?
    var haveDeleteBtn:Bool?
    var arrIndex :Int?
    var contactModel = QRContactModel(){
        didSet{
            
            self.nameTxtView.prevText = contactModel.linkName
            self.emailTxtView.prevText = contactModel.email
            if contactModel.sex == "1"{
                self.sexFromSelect.text = "男"
            }else if contactModel.sex == "2"{
                self.sexFromSelect.text = "女"
            }else{
                self.sexFromSelect.text = "未知"
            }
            
            self.telTxtView.prevText = contactModel.linkPhone
            self.phoneTxtView.prevText = contactModel.officePhone
            self.postionTxtView.prevText = contactModel.position
            self.subTxtView.prevText = contactModel.remark
        }
    }
    
    init(frame: CGRect,haveDeleteBtn:Bool) {
        super.init(frame: frame)
        self.haveDeleteBtn = haveDeleteBtn
        self.backgroundColor = UIColor.white
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        self.addSubview(self.deleteBtn)
        if self.haveDeleteBtn!{
            self.deleteBtn.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 18))
        }else{
            self.deleteBtn.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 0))
            self.deleteBtn.isHidden =  true
        }
        
        self.addSubview(self.nameTxtView)
        self.addSubview(self.telTxtView)
        self.addSubview(self.phoneTxtView)
        self.addSubview(self.postionTxtView)
        self.addSubview(self.sexFromSelect)
        self.addSubview(self.emailTxtView)
        self.addSubview(self.subTxtView)

        for i in 0..<7 {
            let line = UIView.init(frame: CGRect.init(x: kLeftDis, y:self.nameTxtView.bottom - 0.5 + AutoGetHeight(height: 55) * CGFloat(i), width: kWidth - kLeftDis, height: 0.5))
            line.backgroundColor = kLineColor
            self.addSubview(line)
        }
    }
    
    @objc func chooseSexFrom()  {
        DLog("性别点击")
        self.selectDelegate?.selectSEX(sexSelect: sexFromSelect, fatherV: self)
    }
    
    
    @objc func deleteContacterClick() {
        DLog("删除联系人点击")
        self.removeFromSuperview()
        self.deleteDalegate?.delete(deleteBut: deleteBtn, fatherV: self)
    }
    
    lazy var deleteBtn: UIButton = {
        let deleteBtn = UIButton.init(type: .custom)
        deleteBtn.frame = CGRect.init(x: kWidth - AutoGetWidth(width: 70), y: 0, width: AutoGetWidth(width: 55), height: AutoGetHeight(height: 18))
        deleteBtn.setTitle("删除", for: .normal)
        deleteBtn.setTitleColor(kLightBlueColor, for: .normal)
        deleteBtn.backgroundColor = kProjectBgColor
        deleteBtn.titleLabel?.font = kFontSize10
        deleteBtn.addTarget(self, action: #selector(deleteContacterClick), for: .touchUpInside)
        return deleteBtn
    }()
    
    lazy var nameTxtView: CBTextView = {
        let name = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.deleteBtn.bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        name.text = "姓名"
        name.textColor = UIColor.black
        name.textAlignment = .left
        name.font = kFontSize15
        self.addSubview(name)
        
        let nameTxtView = CBTextView.init(frame:CGRect.init(x: name.right + kLeftDis, y:self.deleteBtn.bottom + AutoGetHeight(height: 13), width: (kWidth - AutoGetWidth(width: 110) - 3 * kLeftDis), height: AutoGetHeight(height: 42)))
        nameTxtView.aDelegate = self
        nameTxtView.textView.backgroundColor = UIColor.white
        nameTxtView.textView.font = UIFont.systemFont(ofSize: 15)
        nameTxtView.textView.textColor = UIColor.black
        nameTxtView.textView.textAlignment = .right
        nameTxtView.placeHolder = "请输入联系人姓名"
        nameTxtView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        nameTxtView.textView.tag = 1
        return nameTxtView
    }()
    
    lazy var telTxtView: CBTextView = {
        let name = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.nameTxtView.bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        name.text = "手机"
        name.textColor = UIColor.black
        name.textAlignment = .left
        name.font = kFontSize15
        self.addSubview(name)
        
        let telTxtView = CBTextView.init(frame:CGRect.init(x: name.right + kLeftDis, y:self.nameTxtView.bottom + AutoGetHeight(height: 13), width: (kWidth - AutoGetWidth(width: 110) - 3 * kLeftDis), height: AutoGetHeight(height: 42)))
        telTxtView.aDelegate = self
        telTxtView.textView.backgroundColor = UIColor.white
        telTxtView.textView.font = UIFont.systemFont(ofSize: 15)
        telTxtView.textView.textColor = UIColor.black
        telTxtView.textView.textAlignment = .right
        telTxtView.placeHolder = "请输入联系人手机"
        telTxtView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        telTxtView.textView.tag = 2
        return telTxtView
    }()
    
    lazy var phoneTxtView: CBTextView = {
        let name = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.telTxtView.bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        name.text = "座机"
        name.textColor = UIColor.black
        name.textAlignment = .left
        name.font = kFontSize15
        self.addSubview(name)
        
        let phoneTxtView = CBTextView.init(frame:CGRect.init(x: name.right + kLeftDis, y:self.telTxtView.bottom + AutoGetHeight(height: 13), width: (kWidth - AutoGetWidth(width: 110) - 3 * kLeftDis), height: AutoGetHeight(height: 42)))
        phoneTxtView.aDelegate = self
        phoneTxtView.textView.backgroundColor = UIColor.white
        phoneTxtView.textView.font = UIFont.systemFont(ofSize: 15)
        phoneTxtView.textView.textColor = UIColor.black
        phoneTxtView.textView.textAlignment = .right
        phoneTxtView.placeHolder = "请输入联系人座机"
        phoneTxtView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        phoneTxtView.textView.tag = 3
        return phoneTxtView
    }()
    
    lazy var postionTxtView: CBTextView = {
        let name = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.phoneTxtView.bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        name.text = "职位"
        name.textColor = UIColor.black
        name.textAlignment = .left
        name.font = kFontSize15
        self.addSubview(name)
        
        let postionTxtView = CBTextView.init(frame:CGRect.init(x: name.right + kLeftDis, y:self.phoneTxtView.bottom + AutoGetHeight(height: 13), width: (kWidth - AutoGetWidth(width: 110) - 3 * kLeftDis), height: AutoGetHeight(height: 42)))
        postionTxtView.aDelegate = self
        postionTxtView.textView.backgroundColor = UIColor.white
        postionTxtView.textView.font = UIFont.systemFont(ofSize: 15)
        postionTxtView.textView.textColor = UIColor.black
        postionTxtView.textView.textAlignment = .right
        postionTxtView.placeHolder = "请输入联系人职务"
        postionTxtView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        postionTxtView.textView.tag = 4
        return postionTxtView
    }()
    
    lazy var sexFromSelect: UILabel = {
        let name = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.postionTxtView.bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        name.text = "性别"
        name.textColor = UIColor.black
        name.textAlignment = .left
        name.font = kFontSize15
        self.addSubview(name)
        
        let sexFromSelect = UILabel.init(frame: CGRect.init(x: name.right + kLeftDis, y: self.postionTxtView.bottom, width: kWidth - AutoGetWidth(width: 110) - 4 * kLeftDis - AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 55)))
        sexFromSelect.text = ""
        sexFromSelect.textColor = UIColor.black
        sexFromSelect.textAlignment = .right
        sexFromSelect.font = kFontSize15
        sexFromSelect.tag = 7
        let selectImg = UIImageView.init(frame: CGRect.init(x: sexFromSelect.right + kLeftDis, y:self.postionTxtView.bottom + AutoGetHeight(height: 55 - 12)/2, width: AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 12)))
        selectImg.image = UIImage.init(named: "PersonAddressArrow")
        selectImg.isUserInteractionEnabled = true
        self.addSubview(selectImg)
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: name.right , y: self.postionTxtView.bottom, width: kWidth - AutoGetWidth(width: 125), height: AutoGetHeight(height: 55))
        btn.addTarget(self, action: #selector(chooseSexFrom), for: .touchUpInside)
        self.addSubview(btn)
        
        
        return sexFromSelect
    }()
    
    lazy var emailTxtView: CBTextView = {
        let name = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.sexFromSelect.bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        name.text = "邮箱"
        name.textColor = UIColor.black
        name.textAlignment = .left
        name.font = kFontSize15
        self.addSubview(name)
        
        let emailTxtView = CBTextView.init(frame:CGRect.init(x: name.right + kLeftDis, y:self.sexFromSelect.bottom + AutoGetHeight(height: 13), width: (kWidth - AutoGetWidth(width: 110) - 3 * kLeftDis), height: AutoGetHeight(height: 42)))
        emailTxtView.aDelegate = self
        emailTxtView.textView.backgroundColor = UIColor.white
        emailTxtView.textView.font = UIFont.systemFont(ofSize: 15)
        emailTxtView.textView.textColor = UIColor.black
        emailTxtView.textView.textAlignment = .right
        emailTxtView.placeHolder = "请输入联系人邮箱"
        emailTxtView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        emailTxtView.textView.tag = 5
        return emailTxtView
    }()
    
    lazy var subTxtView: CBTextView = {
        let name = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.emailTxtView.bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        name.text = "备注"
        name.textColor = UIColor.black
        name.textAlignment = .left
        name.font = kFontSize15
        self.addSubview(name)
        
        let subTxtView = CBTextView.init(frame:CGRect.init(x: name.right + kLeftDis, y:self.emailTxtView.bottom + AutoGetHeight(height: 13), width: (kWidth - AutoGetWidth(width: 110) - 3 * kLeftDis), height: AutoGetHeight(height: 42)))
        subTxtView.aDelegate = self
        subTxtView.textView.backgroundColor = UIColor.white
        subTxtView.textView.font = UIFont.systemFont(ofSize: 15)
        subTxtView.textView.textColor = UIColor.black
        subTxtView.textView.textAlignment = .right
        subTxtView.placeHolder = "请输入联系人备注"
        subTxtView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        subTxtView.textView.tag = 6
        return subTxtView
    }()
    
    
}

extension CQCustomerContextView:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        
        if  textView.tag == 1 {
            //联系人姓名
            self.contactModel.linkName = textView.text
        }
        if  textView.tag == 2 {
            //电话
            self.contactModel.linkPhone = textView.text
        }
        if  textView.tag == 3 {
            //座机
            self.contactModel.officePhone = textView.text
        }
        if  textView.tag == 4 {
            //职位
            self.contactModel.position = textView.text
        }
        if  textView.tag == 5 {
            //email
            self.contactModel.email = textView.text
        }
        if  textView.tag == 6 {
           //备注
            self.contactModel.remark = textView.text
        }
        
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if  textView.tag == self.tag+1 {
            //联系人姓名
            self.contactModel.linkName = textView.text
        }
        if  textView.tag == self.tag+2 {
            //电话
            self.contactModel.linkPhone = textView.text
        }
        if  textView.tag == self.tag+3 {
            //座机
            self.contactModel.officePhone = textView.text
        }
        if  textView.tag == self.tag+4 {
            //职位
            self.contactModel.position = textView.text
        }
        if  textView.tag == self.tag+5 {
            //email
            self.contactModel.email = textView.text
        }
        if  textView.tag == self.tag+6 {
            //备注
            self.contactModel.remark = textView.text
        }
        
        
    }
}

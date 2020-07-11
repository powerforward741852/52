//
//  CQSelectLayout.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/10/18.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit

class CQSelectLayout: TGLinearLayout {

    var curName = ""
    var type = ""
    var curTitle = ""
    var prompt = ""
    var required = false
    var dataArray = [JSON]()
    var modelArray = [NCQApprovelModel]()
    
    //选择视图
   var bgView = UIButton()
    //公共picker
    var pickView:UIPickerView?
    
    //选择的省索引
    var provinceIndex = 0
    //选择的市索引
    var cityIndex = 0
    //选择的县索引
    var areaIndex = 0
    
    var curSelectTitle = ""
    var startTime = ""
    var endTime = ""
    var vacationTypeId:Int?
    
    convenience init(orientation: TGOrientation,name:String,type:String,title:String,prompt:String,require:Bool,dataSource:[JSON]) {
        self.init(frame: CGRect.zero, orientation: orientation, name: name, type: type, title: title, prompt: prompt, require: require, dataSource: dataSource)

    }

    init(frame: CGRect, orientation: TGOrientation,name:String,type:String,title:String,prompt:String,require:Bool,dataSource:[JSON]) {
        super.init(frame: frame, orientation: orientation)
        self.tg_height.equal(.wrap)
        self.tg_width.equal(kWidth)
        self.curName = name
        self.type = type
        self.curTitle = title
        self.prompt = prompt
        self.required = require
        self.dataArray = dataSource

        
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()  {
        self.addSubview(self.addxingLable())
        self.addSubview(self.addTitleLable(title: self.curTitle))
        self.addSubview(self.addSelectBtn(title: self.prompt))
        self.addSubview(self.addArrowBtn())
    }
    
    @objc func handleAction()  {
        NotificationCenter.default.post(name: NSNotification.Name.init("cancelKeyBoard"), object: nil)
        for modalJson in self.dataArray {
            guard let modal = NCQApprovelModel(jsonData: modalJson) else {
                return
            }
            self.modelArray.append(modal)
        }
        
        self.initPickView()
    }
    
    func initPickView()  {
        bgView.frame = CGRect(x: 0, y: SafeAreaTopHeight, width: kWidth, height: kHeight - SafeAreaTopHeight )
        bgView.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
        self.superview?.superview?.superview?.superview?.addSubview(bgView)
        bgView.addTarget(self, action: #selector(removeBgView), for: .touchUpInside)
        
        let colorBgV = UIView.init(frame: CGRect.init(x: 0, y: bgView.tz_height - 260, width: kWidth, height: 260))
        colorBgV.backgroundColor = UIColor.white
        bgView.addSubview(colorBgV)
        
        let sureBtn = UIButton()
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(.black, for: .normal)
        sureBtn.frame = CGRect(x: kWidth - 60, y: 10, width: 60, height: 50)
        colorBgV.addSubview(sureBtn)
        sureBtn.addTarget(self, action: #selector(sureClick), for: .touchUpInside)
        
        let cancelBtn = UIButton()
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(.black, for: .normal)
        cancelBtn.frame = CGRect(x: 0, y: 10, width: 60, height: 50)
        colorBgV.addSubview(cancelBtn)
        cancelBtn.addTarget(self, action: #selector(removeBgView), for: .touchUpInside)
        
        if self.curName == "startTime" || self.curName == "endTime"{
            //创建日期选择器
            let datePicker = UIDatePicker(frame: CGRect(x:0, y: 60, width:kWidth, height:166))
            //将日期选择器区域设置为中文，则选择器日期显示为中文
            datePicker.locale = Locale(identifier: "zh_CN")
            //        datePicker.locale = NSLocale.system
            datePicker.calendar = Calendar.current
            datePicker.datePickerMode = .dateAndTime
            datePicker.backgroundColor = .white
            //注意：action里面的方法名后面需要加个冒号“：”
            datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
            colorBgV.addSubview(datePicker)
        }else{
            self.pickView = UIPickerView.init(frame: CGRect.init(x: 0, y: 60, width: kWidth, height: 200))
            pickView?.delegate = self
            pickView?.dataSource = self
            pickView?.selectedRow(inComponent: 0)
            colorBgV.addSubview(pickView!)
        }
        
        
    }
    
    @objc func sureClick() {
        
        let btn:UIButton = self.viewWithTag(200) as! UIButton
        if self.curName == "vacationType"{
            self.curSelectTitle = self.modelArray[(pickView?.selectedRow(inComponent: 0))!].text
            btn.setTitle( self.curSelectTitle, for: .normal)
            NotificationCenter.default.post(name: NSNotification.Name.init("vacationTypeIdValue"), object: self.modelArray[(pickView?.selectedRow(inComponent: 0))!].value)
        }else if self.curName == "startTime"{
            
            btn.setTitle(startTime, for: .normal)
        }else if self.curName == "endTime"{
            btn.setTitle(endTime, for: .normal)
        }
        
        
        self.bgView.removeAllSubviews()
        self.bgView.removeFromSuperview()
        self.provinceIndex = 0
        self.cityIndex = 0
        self.areaIndex = 0
    }
    
    @objc func removeBgView() {
        self.bgView.removeAllSubviews()
        self.bgView.removeFromSuperview()
        self.provinceIndex = 0
        self.cityIndex = 0
        self.areaIndex = 0
    }
    
    
    //日期选择器响应方法
    @objc func dateChanged(datePicker : UIDatePicker){
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        if self.curName == "startTime" {
            startTime = formatter.string(from: datePicker.date)
        }else if self.curName == "endTime" {
            endTime = formatter.string(from: datePicker.date)
        }
    }
    
}

//pick代理
extension CQSelectLayout:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.modelArray.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        
        return self.modelArray[row].text
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        return kWidth
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return AutoGetHeight(height: 40)
    }
}

// Mark 整个界面可能用到的控件
extension CQSelectLayout{
    
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
        let labWidth = getTexWidth(textStr: title, font: kFontSize15, height: AutoGetHeight(height: 15))  + AutoGetWidth(width: 10)
        lab.tg_width.equal(labWidth)
        lab.tg_height.equal(AutoGetHeight(height: 55))
        return lab
    }
    
    @objc internal func addSelectBtn(title:String) -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.addTarget(self ,action:#selector(handleAction), for:.touchUpInside)
        btn.setTitle(title ,for:.normal)
        btn.titleLabel!.font = kFontSize15
        btn.setTitleColor(kLyGrayColor, for: .normal)
        btn.contentHorizontalAlignment = .right
        btn.tag = 200
        btn.tg_height.equal(AutoGetHeight(height: 55))
        btn.tg_width.equal(kWidth - AutoGetWidth(width: 131.5))
        return btn
    }
    
    @objc internal func addArrowBtn() -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "PersonAddressArrow"), for: .normal)
        btn.tg_height.equal(AutoGetHeight(height: 55))
        btn.tg_width.equal(AutoGetWidth(width: 12.5))
        return btn
    }
    
}

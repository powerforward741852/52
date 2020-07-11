//
//  QRDatePickerView.swift
//  test1
//
//  Created by 秦榕 on 2018/12/27.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit
protocol QRDatePickerViewDelegate {
    func datePickerSelectedValue(dpicker:QRDatePickerView,time:String,date:Date)
}
class QRDatePickerView: UIView {
    
    let QRSafeAreaTopHeight:CGFloat = ( UIScreen.main.bounds.height == 812.0 || UIScreen.main.bounds.height == 896 ? 88 : 64)
    let QRSafeAreaStateTopHeight:CGFloat = ( UIScreen.main.bounds.height == 812.0 || UIScreen.main.bounds.height == 896 ? 44 : 20)
    let QRSafeAreaBottomHeight:CGFloat = (UIScreen.main.bounds.height == 812.0 || UIScreen.main.bounds.height == 896 ? 34 : 0)
    let QRSafeTabbarBottomHeight:CGFloat = (UIScreen.main.bounds.height == 812.0 || UIScreen.main.bounds.height == 896 ? 83.0 : 49.0)
    let QRWidth:CGFloat = UIScreen.main.bounds.width
    let QRHeight:CGFloat = UIScreen.main.bounds.height
    var datePic = UIDatePicker()
    var endTime = ""
    var delegate : QRDatePickerViewDelegate?
    
    var myDataFormat = "yyyy-MM-dd"
    var dateMode = UIDatePicker.Mode.date
    var dateCalendarIdentity = Calendar.Identifier.gregorian
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    class func creatPickerView() -> QRDatePickerView {
        let pickerView = QRDatePickerView(frame:  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        pickerView.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.7)
        let tapGes = UITapGestureRecognizer(target: pickerView, action: #selector(tapTouchIn))
        pickerView.addGestureRecognizer(tapGes)
        pickerView.setUpUi()
        return pickerView
    }
    
    
    func setUpUi(){
        let colorBgV = UIView.init(frame: CGRect.init(x: 0, y: self.frame.size.height - 240 - QRSafeAreaBottomHeight, width: QRWidth, height: 240))
        colorBgV.backgroundColor = UIColor.white
        self.addSubview(colorBgV)
        //适配iponex下巴
        let xiaBaBgV = UIView.init(frame: CGRect.init(x: 0, y: colorBgV.bottom, width: QRWidth, height: QRSafeAreaBottomHeight))
        xiaBaBgV.backgroundColor = UIColor.white
        self.addSubview(xiaBaBgV)
        //确认按钮
        let sureBtn = UIButton()
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(.black, for: .normal)
        sureBtn.frame = CGRect(x: QRWidth - 60, y: 0, width: 60, height: 40)
        colorBgV.addSubview(sureBtn)
        sureBtn.addTarget(self, action: #selector(sureClick(btn:)), for: .touchUpInside)
        //取消按钮
        let cancelBtn = UIButton()
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(.black, for: .normal)
        cancelBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        colorBgV.addSubview(cancelBtn)
        cancelBtn.addTarget(self, action: #selector(removeBgView(sender:)), for: .touchUpInside)
        //创建日期选择器
        let datePicker = UIDatePicker(frame: CGRect(x:0, y: 40, width:QRWidth, height:200))
        self.datePic = datePicker
        //将日期选择器区域设置为中文，则选择器日期显示为中文
        datePicker.locale = Locale(identifier: "zh_CN")
        datePicker.calendar = Calendar(identifier: dateCalendarIdentity)
        datePicker.datePickerMode = dateMode
        datePicker.backgroundColor = .white
        
        //注意：action里面的方法名后面需要加个冒号“：”
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        colorBgV.addSubview(datePicker)
    }
    //日期选择器响应方法
    @objc func dateChanged(datePicker : UIDatePicker){
        //更新提醒时间文本框
        let formatter = DateFormatter()
        formatter.dateFormat = myDataFormat
        endTime = formatter.string(from: datePicker.date)
    }
    @objc func removeBgView(sender: UIButton) {
        self.dismissPicker()
    }
    
    @objc func sureClick(btn:UIButton) {
        if endTime == ""{
            let formatter = DateFormatter()
            formatter.dateFormat = myDataFormat
            endTime = formatter.string(from: datePic.date)
        }
        
        self.delegate?.datePickerSelectedValue(dpicker: self,time: endTime,date:datePic.date)
        self.dismissPicker()
    }
    
    func showPicker(){
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.addSubview(self)
    }
    func dismissPicker(){
        self.removeFromSuperview()
    }
    @objc func tapTouchIn(){
       self.dismissPicker()
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

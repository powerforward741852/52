//
//  QRBirthdaySettingVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/5/28.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class QRBirthdaySettingVC: SuperVC {

    
    @IBOutlet weak var gongLiBut: UIButton!
    
    @IBOutlet weak var yingLiBut: UIButton!
    
    @IBOutlet weak var selectOne: UIButton!
    var selectIndex: Int = 1111
    
    @IBOutlet weak var selectTwo: UIButton!
    var timeStr = ""
    var timeDate : Date?
    
    var birthDate = ""
    var birthDateOld = ""
    //1公历2农历
    var birthDateType = "1"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = kProjectBgColor
        
        gongLiBut.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
        yingLiBut.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
        selectOne.isSelected = true
        
        if timeStr == ""{
          //未设置时
            timeDate = Date()
        }else{
          //设置时将时间装换成农历和阴历
            timeDate = Date(dateString: self.timeStr, format: "yyyy-MM-dd")
            let str = solarToLunar(year: timeDate!.year, month: timeDate!.month, day: timeDate!.day)
            birthDateOld = str
            yingLiBut.setTitle(str, for: UIControlState.normal)
            yingLiBut.setTitleColor(UIColor.black, for: UIControlState.normal)
            //农历转公历
            gongLiBut.setTitle(timeStr, for: UIControlState.normal)
            gongLiBut.setTitleColor(UIColor.black, for: UIControlState.normal)
            
        }
        
        if birthDateType == "1" || birthDateType == ""{
            selectGongliAction(selectOne)
        }else{
            selectGongliAction(selectTwo)
        }
        
        
        
        let RightButton = UIButton(frame:  CGRect(x: 0, y: 0, width: 60, height: 30))
        RightButton.setTitle("保存", for: UIControlState.normal)
        RightButton.addTarget(self, action: #selector(jumpIn), for: UIControlEvents.touchUpInside)
        RightButton.titleLabel?.font = kFontSize17
        RightButton.setTitleColor(kBlueColor, for: UIControlState.normal)
        RightButton.sizeToFit()
        RightButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: -7)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: RightButton)
    }
    
    @objc func jumpIn(){
        
        if selectIndex == 1111{
            birthDateType = "1"
        }else{
            birthDateType = "2"
        }
        if timeStr.count != 0{
//            birthDate = selectOne.titleLabel!.text
//            birthDateOld = selectTwo.titleLabel!.text
        }else{
            SVProgressHUD.showInfo(withStatus: "请选择生日")
            return
        }
        
        let userId = STUserTool.account().userID
        SVProgressHUD.show()
        STNetworkTools.requestData(URLString:"\(baseUrl)/loginModule/updateUserBirthDate" ,
            type: .post,
            param: ["birthDate":timeStr,"birthDateType":birthDateType,"userId":userId],
            successCallBack: { (result) in
              SVProgressHUD.dismiss()
              SVProgressHUD.showInfo(withStatus: result["message"].stringValue)
              self.navigationController?.popViewController(animated: true)
                
            
        }) { (error) in
            SVProgressHUD.dismiss()
            
        }
    }
    
    
    @IBOutlet weak var thirdView: UIView!
    
    @IBAction func gongLiAction(_ sender: Any) {
        //弹窗
        let dataPicker = QRDatePickerView.creatPickerView()
        dataPicker.delegate = self
        dataPicker.tag = 1111
        dataPicker.datePic.date = timeDate!
        dataPicker.showPicker()
        
    }
   
    @IBAction func yingLiAction(_ sender: Any) {
        let dataPicker = QRDatePickerView.creatPickerView()
        dataPicker.delegate = self
        dataPicker.tag = 2222
        dataPicker.datePic.date = timeDate!
        dataPicker.showPicker()
        dataPicker.datePic.calendar = Calendar(identifier: .chinese)
    }
    
    @IBAction func selectGongliAction(_ sender: UIButton) {
        
        if sender.isSelected == false{
            sender.isSelected = true
        }else{
        }
        //取消另一个的选中
        for (_,value) in thirdView.subviews.enumerated() {
            if value.isKind(of: UIButton.self){

                if  value == sender {

                }else{
                    (value as! UIButton).isSelected = false
                }
            }
        }
        self.selectIndex = sender.tag
    }
    
    
    
    
}
extension QRBirthdaySettingVC: QRDatePickerViewDelegate{
    func datePickerSelectedValue(dpicker: QRDatePickerView, time: String,date:Date) {
        if dpicker.tag == 1111{
            gongLiBut.setTitle(time, for: UIControlState.normal)
            gongLiBut.setTitleColor(UIColor.black, for: UIControlState.normal)
            self.timeDate = date
            self.timeStr = time
            //公历转农历
            let str = solarToLunar(year: date.year, month: date.month, day: date.day)
            birthDateOld = str
            yingLiBut.setTitle(str, for: UIControlState.normal)
            yingLiBut.setTitleColor(UIColor.black, for: UIControlState.normal)
            
            
            
        }else{
            let str = solarToLunar(year: date.year, month: date.month, day: date.day)
            birthDateOld = str
            yingLiBut.setTitle(str, for: UIControlState.normal)
            yingLiBut.setTitleColor(UIColor.black, for: UIControlState.normal)
            self.timeDate = date
            self.timeStr = time
            //农历转公历
            gongLiBut.setTitle(time, for: UIControlState.normal)
            gongLiBut.setTitleColor(UIColor.black, for: UIControlState.normal)
            
            
        }
       
    }
    
    
}


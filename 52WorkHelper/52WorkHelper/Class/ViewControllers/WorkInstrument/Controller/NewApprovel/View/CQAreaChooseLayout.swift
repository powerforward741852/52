//
//  CQAreaChooseLayout.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/11/5.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit

class CQAreaChooseLayout: TGLinearLayout {

    var curName = ""
    var type = ""
    var curTitle = ""
    var prompt = ""
    var required = false
    var dataFormat = ""
    var addressArray = [[String: AnyObject]]()
    
    //选择视图
    var bgView = UIButton()
    //公共picker
    var pickView:UIPickerView?
    var curSelectTitle = ""
    
    //选择的省索引
    var provinceIndex = 0
    //选择的市索引
    var cityIndex = 0
    //选择的县索引
    var areaIndex = 0
    
    convenience init(orientation: TGOrientation,name:String,type:String,title:String,prompt:String,require:Bool,dataFormat:String,curSelectTitle:String) {
        self.init(frame: CGRect.zero, orientation: orientation, name: name, type: type, title: title, prompt: prompt, require: require,dataFormat:dataFormat,curSelectTitle:curSelectTitle)
        
    }
    
    init(frame: CGRect, orientation: TGOrientation,name:String,type:String,title:String,prompt:String,require:Bool,dataFormat:String,curSelectTitle:String) {
        super.init(frame: frame, orientation: orientation)
        self.tg_height.equal(.wrap)
        self.tg_width.equal(kWidth)
        self.curName = name
        self.type = type
        self.curTitle = title
        self.prompt = prompt
        self.required = require
        self.dataFormat = dataFormat
        self.curSelectTitle = curSelectTitle
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()  {
        self.addSubview(self.addxingLable())
        self.addSubview(self.addTitleLable(title: self.curTitle))
        if !self.curSelectTitle.isEmpty{
            self.addSubview(self.addSelectBtn(title: self.curSelectTitle))
        }else{
            self.addSubview(self.addSelectBtn(title: self.prompt))
        }
        self.addSubview(self.addArrowBtn())
    }
    
    @objc func handleAction()  {
        NotificationCenter.default.post(name: NSNotification.Name.init("cancelKeyBoard"), object: nil)
        //初始化数据
        let path = Bundle.main.path(forResource: "address", ofType:"plist")
        self.addressArray = NSArray(contentsOfFile: path!) as! Array
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
        
        self.pickView = UIPickerView.init(frame: CGRect.init(x: 0, y: 60, width: kWidth, height: 166))
        pickView?.delegate = self
        pickView?.dataSource = self
        pickView?.selectedRow(inComponent: 0)
        colorBgV.addSubview(pickView!)
        
    }
    
    @objc func sureClick() {
        //获取选中的省
        let p = self.addressArray[provinceIndex]
        let province = p["state"] as! String
        //获取选中的市
        let c = (p["cities"] as! NSArray)[cityIndex] as! [String:AnyObject]
        let city = c["city"] as! String
        //获取选中的县（地区）
        var area = ""
        if (c["areas"] as! [String]).count > 0{
            area = (c["areas"] as! [String])[areaIndex]
            self.curSelectTitle = "\(province) - \(city) - \(area)"
        }else{
            self.curSelectTitle = "\(province) - \(city) "
        }
        let btn:UIButton = self.viewWithTag(200) as! UIButton
        btn.setTitle( self.curSelectTitle, for: .normal)
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
    
    
}

//pick代理
extension CQAreaChooseLayout:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return self.addressArray.count
        } else if component == 1 {
            let province = self.addressArray[provinceIndex]
            return province["cities"]!.count
        } else {
            let province = self.addressArray[provinceIndex]
            if let city = (province["cities"] as! NSArray)[cityIndex]
                as? [String: AnyObject] {
                return city["areas"]!.count
            } else {
                return 0
            }
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return self.addressArray[row]["state"] as? String
        }else if component == 1 {
            let province = self.addressArray[provinceIndex]
            let city = (province["cities"] as! NSArray)[row]
                as! [String: AnyObject]
            return city["city"] as? String
        }else {
            let province = self.addressArray[provinceIndex]
            let city = (province["cities"] as! NSArray)[cityIndex]
                as! [String: AnyObject]
            return (city["areas"] as! NSArray)[row] as? String
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //根据列、行索引判断需要改变数据的区域
        switch (component) {
        case 0:
            provinceIndex = row;
            cityIndex = 0;
            areaIndex = 0;
            pickerView.reloadComponent(1);
            pickerView.reloadComponent(2);
            pickerView.selectRow(0, inComponent: 1, animated: false)
            pickerView.selectRow(0, inComponent: 2, animated: false)
        case 1:
            cityIndex = row;
            areaIndex = 0;
            pickerView.reloadComponent(2);
            pickerView.selectRow(0, inComponent: 2, animated: false)
        case 2:
            areaIndex = row;
        default:
            break;
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        return kWidth/3
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return AutoGetHeight(height: 40)
    }
}

// Mark 整个界面可能用到的控件
extension CQAreaChooseLayout{
    
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
    
    @objc internal func addSelectBtn(title:String) -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.addTarget(self ,action:#selector(handleAction), for:.touchUpInside)
        btn.setTitle(title ,for:.normal)
        btn.titleLabel!.font = kFontSize15
        btn.setTitleColor(kLyGrayColor, for: .normal)
        btn.contentHorizontalAlignment = .right
        btn.tag = 200
        btn.tg_height.equal(AutoGetHeight(height: 55))
        btn.tg_width.equal(kWidth - AutoGetWidth(width: 140))
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


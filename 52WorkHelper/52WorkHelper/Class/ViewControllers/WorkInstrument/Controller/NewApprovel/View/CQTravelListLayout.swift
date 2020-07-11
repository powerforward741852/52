//
//  CQTravelListLayout.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/10/26.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit

class CQTravelListLayout: TGLinearLayout {

    var curName = ""
    var type = ""
    var curTitle = ""
    var viewTag = 0
    var actionLayout:TGLinearLayout!
    var dic : NSDictionary?
    //选择视图
    var bgView = UIButton()
    //公共picker
    var pickView:UIPickerView?
    //交通类型
    var traficId = ""
    //交通名
    var traficName = ""
    //交通数组
    var traficArray = [NCQApprovelModel]()
    //往返名称
    var backName = ""
    //是否往返
    var isBack:Bool!
    //往返数组
    var backArray = [CQBackModel]()
    //出发城市
    var fromCity = ""
    //到达城市
    var toCity = ""
    //城市数组
    var addressArray = [[String: AnyObject]]()
    //选择的省索引
    var provinceIndex = 0
    //选择的市索引
    var cityIndex = 0
    //选择的县索引
    var areaIndex = 0
    //开始时间
    var startTime = ""
    //结束时间
    var endTime = ""
    //是否开始时间变化
    var hasStartChange = false
    //是否结束时间变化
    var hasEndChange = false
    //时长
    var duration = ""
    //出差总时长
    var travalDay:Double = 0.00 //出差时间
    
    convenience init(orientation: TGOrientation,name:String,type:String,title:String,viewTag:Int,traficArray:[NCQApprovelModel],backArray:[CQBackModel]) {
        self.init(frame: CGRect.zero, orientation: orientation, name: name, type: type, title: title,viewTag:viewTag,traficArray:traficArray,backArray:backArray)
        
    }
    
    init(frame: CGRect, orientation: TGOrientation,name:String,type:String,title:String,viewTag:Int,traficArray:[NCQApprovelModel],backArray:[CQBackModel]) {
        super.init(frame: frame, orientation: orientation)
        
        self.actionLayout = TGLinearLayout(.vert)
        actionLayout.tg_width.equal(.wrap)
        actionLayout.tg_height.equal(.wrap)
        self.addSubview(actionLayout)
        
        self.tg_height.equal(.wrap)
        self.tg_width.equal(kWidth)
        self.curName = name
        self.type = type
        self.curTitle = title
        self.viewTag = viewTag
        self.traficArray = traficArray
        self.backArray = backArray
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()  {
        self.actionLayout.addSubview(self.addSubLayout())
        self.actionLayout.addSubview(self.addTraficLayout())
        self.actionLayout.addSubview(self.addIsBackLayout())
        self.actionLayout.addSubview(self.addFromCityLayout())
        self.actionLayout.addSubview(self.addToCityLayout())
        self.actionLayout.addSubview(self.addStartTimeLayout())
        self.actionLayout.addSubview(self.addEndTimeLayout())
        self.actionLayout.addSubview(self.addDurationLayout())
    }
    
    @objc func handleAction(sender:UIButton) {
        if sender.tag == 207{
            self.removeAllSubviews()
            self.removeFromSuperview()
            NotificationCenter.default.post(name: NSNotification.Name.init("shortHeight"), object: nil)
        }else if sender.tag == 200{
            self.initPickView(pickTag: sender.tag + 500)
        }else if sender.tag == 201{
            self.initPickView(pickTag: sender.tag + 500)
        }else if sender.tag == 202 || sender.tag == 203{
            //初始化数据
            let path = Bundle.main.path(forResource: "address", ofType:"plist")
            self.addressArray = NSArray(contentsOfFile: path!) as! Array
            self.initPickView(pickTag: sender.tag + 500)
        }else if sender.tag == 204 || sender.tag == 205{
            self.initPickView(pickTag: sender.tag + 500)
        }
    }
    
    func initPickView(pickTag:Int)  {
        bgView.frame = CGRect(x: 0, y: SafeAreaTopHeight, width: kWidth, height: kHeight - SafeAreaTopHeight)
        bgView.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
        self.superview?.superview?.superview?.superview?.superview?.superview?.addSubview(bgView)
        bgView.addTarget(self, action: #selector(removeBgView), for: .touchUpInside)
        
        let colorBgV = UIView.init(frame: CGRect.init(x: 0, y: bgView.tz_height - 260, width: kWidth, height: 260))
        colorBgV.backgroundColor = UIColor.white
        bgView.addSubview(colorBgV)
        
        let sureBtn = UIButton()
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(.black, for: .normal)
        sureBtn.frame = CGRect(x: kWidth - 60, y: 10, width: 60, height: 50)
        colorBgV.addSubview(sureBtn)
        sureBtn.tag = 100 + pickTag
        sureBtn.addTarget(self, action: #selector(sureClick(sender:)), for: .touchUpInside)
        
        let cancelBtn = UIButton()
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(.black, for: .normal)
        cancelBtn.frame = CGRect(x: 0, y: 10, width: 60, height: 50)
        colorBgV.addSubview(cancelBtn)
        cancelBtn.addTarget(self, action: #selector(removeBgView), for: .touchUpInside)
        
        if pickTag == 704 || pickTag == 705{
            //创建日期选择器
            let datePicker = UIDatePicker(frame: CGRect(x:0, y: 60, width:kWidth, height:166))
            //将日期选择器区域设置为中文，则选择器日期显示为中文
            datePicker.locale = Locale(identifier: "zh_CN")
            //        datePicker.locale = NSLocale.system
            datePicker.calendar = Calendar.current
            datePicker.datePickerMode = .dateAndTime
            datePicker.backgroundColor = .white
            datePicker.tag = pickTag
            //注意：action里面的方法名后面需要加个冒号“：”
            datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
            colorBgV.addSubview(datePicker)
        }else{
            self.pickView = UIPickerView.init(frame: CGRect.init(x: 0, y: 60, width: kWidth, height: 166))
            pickView?.delegate = self
            pickView?.dataSource = self
            pickView?.tag = pickTag
            pickView?.selectedRow(inComponent: 0)
            colorBgV.addSubview(pickView!)
        }
        
        
    }
    
    @objc func sureClick(sender:UIButton) {
        if sender.tag == 800{
            let btn:UIButton = self.viewWithTag(200) as! UIButton
            self.traficName = self.traficArray[(pickView?.selectedRow(inComponent: 0))!].text
            btn.setTitle( self.traficName, for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            self.traficId = self.traficArray[(pickView?.selectedRow(inComponent: 0))!].value
        }else if sender.tag == 801{
            let btn:UIButton = self.viewWithTag(201) as! UIButton
            self.backName = self.backArray[(pickView?.selectedRow(inComponent: 0))!].text
            btn.setTitle( self.backName, for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            self.isBack = self.backArray[(pickView?.selectedRow(inComponent: 0))!].value
        }else if sender.tag == 802 || sender.tag == 803{
            //获取选中的省
            let p = self.addressArray[provinceIndex]
            let province = p["state"] as! String
            //获取选中的市
            let c = (p["cities"] as! NSArray)[cityIndex] as! [String:AnyObject]
            let city = c["city"] as! String
            //获取选中的县（地区）
            var area = ""
            var message = ""
            if (c["areas"] as! [String]).count > 0{
                area = (c["areas"] as! [String])[areaIndex]
                message = "\(province) - \(city) - \(area)"
            }else{
                message = "\(province) - \(city) "
            }
            if sender.tag == 802{
                self.fromCity = message
                let btn:UIButton = self.viewWithTag(202) as! UIButton
                btn.setTitleColor(UIColor.black, for: .normal)
                btn.setTitle( message, for: .normal)
            }else if sender.tag == 803{
                self.toCity = message
                let btn:UIButton = self.viewWithTag(203) as! UIButton
                btn.setTitleColor(UIColor.black, for: .normal)
                btn.setTitle( message, for: .normal)
            }
            
        }else if sender.tag == 804{
            
            if !self.hasStartChange{
                let now = Date()
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
                self.startTime = dateFormat.string(from: now)
            }
            let btn:UIButton = self.viewWithTag(204) as! UIButton
            btn.setTitle(startTime, for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            self.hasStartChange = false
            
        }else if sender.tag == 805{
            if !self.hasEndChange{
                let now = Date()
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
                self.endTime = dateFormat.string(from: now)
            }
            let btn:UIButton = self.viewWithTag(205) as! UIButton
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.setTitle(endTime, for: .normal)
            self.hasEndChange = false
        }
        
        if !self.startTime.isEmpty && !self.endTime.isEmpty{
            self.calculateDurationRequest(type: "businessTravel", start: self.startTime, end: self.endTime, i: 0)

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
        if datePicker.tag == 704{
            startTime = formatter.string(from: datePicker.date)
            self.hasStartChange = true
        }else if datePicker.tag == 705{
            endTime = formatter.string(from: datePicker.date)
            self.hasEndChange = true
        }
        
        
    }
}

//dataload
extension CQTravelListLayout{
    //获取出差外出时长
    func calculateDurationRequest(type:String,start:String,end:String,i:Int) {
        
        let userId = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/calculateDuration" ,
            type: .get,
            param: ["emyeId":userId,
                    "endTime":end,
                    "startTime":start,
                    "type":type],
            successCallBack: { (result) in
                if type == "businessTravel"{
                    self.travalDay = result["data"]["duration"].doubleValue
                    NotificationCenter.default.post(name: NSNotification.Name.init("travelDayValue"), object: nil)
                    self.duration = result["data"]["duration"].stringValue
                    let vocationUnit = result["data"]["unit"].stringValue
                    let timeInter = self.duration + vocationUnit
                    
                    
                    let btn = self.viewWithTag(206) as! UIButton
                    btn.setTitle(timeInter, for: .normal)
                    btn.setTitleColor(UIColor.black, for: UIControlState.normal)
                    
                }
          
        }) { (error) in
            
        }
    }
}

//layout
extension CQTravelListLayout{
    
    //标题 207
    internal func addSubLayout() -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(kWidth)
        wrapContentLayout.backgroundColor = kProjectBgColor
        
        wrapContentLayout.addSubview(self.addSubTitleLable(title: self.curTitle))
        wrapContentLayout.addSubview(self.addDeleteBtn(title: "删除", btnTag: 207))
        return wrapContentLayout
    }
    //交通工具 200
    internal func addTraficLayout() -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(kWidth)
        
        wrapContentLayout.addSubview(self.addxingLable())
        wrapContentLayout.addSubview(self.addTitleLable(title: "交通工具"))
        wrapContentLayout.addSubview(self.addSelectBtn(title: "(必填)",btnTag:200))
        wrapContentLayout.addSubview(self.addArrowBtn())
        
        return wrapContentLayout
    }
    
    //单程往返 201
    internal func addIsBackLayout() -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(kWidth)
        
        wrapContentLayout.addSubview(self.addxingLable())
        wrapContentLayout.addSubview(self.addTitleLable(title: "单程往返"))
        wrapContentLayout.addSubview(self.addSelectBtn(title: "(必填)",btnTag:201))
        wrapContentLayout.addSubview(self.addArrowBtn())
        
        return wrapContentLayout
    }
    
    //出发城市 202
    internal func addFromCityLayout() -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(kWidth)
        
        wrapContentLayout.addSubview(self.addxingLable())
        wrapContentLayout.addSubview(self.addTitleLable(title: "出发城市"))
        wrapContentLayout.addSubview(self.addSelectBtn(title: "请选择城市(必填)",btnTag:202))
        wrapContentLayout.addSubview(self.addArrowBtn())
        
        return wrapContentLayout
    }
    
    //到达城市 203
    internal func addToCityLayout() -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(kWidth)
        
        wrapContentLayout.addSubview(self.addxingLable())
        wrapContentLayout.addSubview(self.addTitleLable(title: "到达城市"))
        wrapContentLayout.addSubview(self.addSelectBtn(title: "请选择城市(必填)",btnTag:203))
        wrapContentLayout.addSubview(self.addArrowBtn())
        
        return wrapContentLayout
    }
    
    //开始时间 204
    internal func addStartTimeLayout() -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(kWidth)
        
        wrapContentLayout.addSubview(self.addxingLable())
        wrapContentLayout.addSubview(self.addTitleLable(title: "开始时间"))
        wrapContentLayout.addSubview(self.addSelectBtn(title: "请选择(必填)",btnTag:204))
        wrapContentLayout.addSubview(self.addArrowBtn())
        
        return wrapContentLayout
    }
    
    //开始时间 205
    internal func addEndTimeLayout() -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(kWidth)
        
        wrapContentLayout.addSubview(self.addxingLable())
        wrapContentLayout.addSubview(self.addTitleLable(title: "结束时间"))
        wrapContentLayout.addSubview(self.addSelectBtn(title: "请选择(必填)",btnTag:205))
        wrapContentLayout.addSubview(self.addArrowBtn())
        
        return wrapContentLayout
    }
    
    //时长 206
    internal func addDurationLayout() -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(kWidth)
        
        wrapContentLayout.addSubview(self.addxingLable())
        wrapContentLayout.addSubview(self.addTitleLable(title: "时长"))
        wrapContentLayout.addSubview(self.addDurationBtn(title: "0天",btnTag:206))
        
        return wrapContentLayout
    }
}

// Mark 整个界面可能用到的控件
extension CQTravelListLayout{
    @objc internal func addSubTitleLable(title:String) -> UILabel{
        let lab = UILabel.init()
        lab.text = title
        lab.font = kFontSize14
        lab.textAlignment = .left
        lab.textColor = kLyGrayColor
//        let labWidth = getTexWidth(textStr: title, font: kFontSize15, height: AutoGetHeight(height: 15))
        lab.tg_width.equal(AutoGetWidth(width: 55))
        lab.tg_left.equal(AutoGetWidth(width: 15))
        lab.tg_height.equal(AutoGetHeight(height: 15))
        return lab
    }
    
    //*号 在非必填时 隐藏
    @objc internal func addxingLable() -> UILabel{
        let lab = UILabel.init()
        lab.font = kFontSize15
        lab.textAlignment = .left
        lab.textColor = UIColor.red
        lab.tg_height.equal(AutoGetHeight(height: 55))
        lab.tg_left.equal(AutoGetWidth(width: 15))
        lab.tg_width.equal(AutoGetWidth(width: 20))
        lab.text = "*"
        return lab
    }
    
    @objc internal func addTitleLable(title:String) -> UILabel{
        let lab = UILabel.init()
        lab.text = title
        lab.font = kFontSize15
        lab.textAlignment = .left
        lab.textColor = UIColor.black
        let labWidth = getTexWidth(textStr: title, font: kFontSize15, height: AutoGetHeight(height: 15)) + AutoGetWidth(width: 10)
        lab.tg_width.equal(labWidth)
        lab.tg_height.equal(AutoGetHeight(height: 55))
        return lab
    }
    
    @objc internal func addSelectBtn(title:String,btnTag:Int) -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.addTarget(self ,action:#selector(handleAction(sender:)), for:.touchUpInside)
        btn.setTitle(title ,for:.normal)
        btn.titleLabel!.font = kFontSize15
        btn.setTitleColor(kLyGrayColor, for: .normal)
        btn.contentHorizontalAlignment = .right
        btn.tag = btnTag
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
    
    
    @objc internal func addDurationBtn(title:String,btnTag:Int) -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(title ,for:.normal)
        btn.titleLabel!.font = kFontSize15
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.contentHorizontalAlignment = .right
        btn.tag = btnTag
        btn.tg_left.equal(AutoGetWidth(width: 15))
        btn.tg_height.equal(AutoGetHeight(height: 55))
        btn.tg_width.equal(kWidth - AutoGetWidth(width: 120))
        return btn
    }
    
    @objc internal func addDeleteBtn(title:String,btnTag:Int) -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.addTarget(self ,action:#selector(handleAction(sender:)), for:.touchUpInside)
        btn.setTitle(title ,for:.normal)
        btn.titleLabel!.font = kFontSize14
        btn.setTitleColor(kLightBlueColor, for: .normal)
        btn.contentHorizontalAlignment = .right
        btn.tag = btnTag
        btn.tg_height.equal(AutoGetHeight(height: 15))
        btn.tg_width.equal(kWidth - AutoGetWidth(width: 91.5))
        return btn
    }
}


//pick代理
extension CQTravelListLayout:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 702 || pickerView.tag == 703{
            return 3
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 700{
            return self.traficArray.count
        }else if pickerView.tag == 702 || pickerView.tag == 703{
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
        return self.backArray.count //701
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 700{
            return self.traficArray[row].text
        }else if pickerView.tag == 702 || pickerView.tag == 703{
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
        return self.backArray[row].text //701
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 702 || pickerView.tag == 703{
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
        
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if pickerView.tag == 702 || pickerView.tag == 703{
            return kWidth/3
        }
        return kWidth
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return AutoGetHeight(height: 40)
    }
}

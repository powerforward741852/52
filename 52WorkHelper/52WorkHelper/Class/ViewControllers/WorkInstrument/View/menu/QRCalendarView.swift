//
//  QRCalendarView.swift
//  test
//
//  Created by 秦榕 on 2019/4/23.
//  Copyright © 2019年 qq. All rights reserved.
//

import UIKit

class QRCalendarView: UIView {
    //选择时间段
    var isSelectDayRange : Bool = false
    var wYear : Int?
    var wMonth : Int?
    var wWeak : Int?
    
    
    //现在的日期
    var CVNowTime : CVDate!
    
    //开始日期与结束e日期
    var startTime : String = ""
    var endTime : String = ""
    //
    var CVstartTime : CVDate!
    var CVendTime : CVDate!
    var isSelected : Bool = false
    var isFirstSelected : Bool = false
    var fatherV : QRDropRightView?
    //声明闭包
    typealias clickBtnClosure = (_ startDataStr : String,_ endDataStr : String) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    
    //日历主视图
    var titleLab:UILabel!
    var calendarView:CVCalendarView!
    var currentCalendar:Calendar!
    //星期菜单栏
    var menuView:CVCalendarMenuView!

    
    
    var dataStr : String?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func creatPopview() -> QRCalendarView {
        let calendarView = QRCalendarView(frame:  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        calendarView.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.7)
        calendarView.setUpUi()
        
        return calendarView
    }
    
    func setUpUi(){
        
        //背景
        let backGroundView = UIView(frame:  CGRect(x: 0, y: 0, width: kWidth -  AutoGetHeight(height: 30), height: AutoGetHeight(height: 300)))
        backGroundView.backgroundColor = UIColor.white
        backGroundView.center = CGPoint(x: kWidth/2, y: kHeight/2)
        backGroundView.layer.cornerRadius = 10
        backGroundView.clipsToBounds = true
        self.addSubview(backGroundView)
      
        //日期标题
        let lab = UILabel(title: "2019年04月")
        lab.textColor  = UIColor.black
        lab.font = kFontSize15
        lab.frame = CGRect(x: (kWidth-AutoGetWidth(width: 150))/2, y: 0, width: AutoGetWidth(width: 120), height: AutoGetHeight(height: 40))
        lab.textAlignment = .center
        self.titleLab = lab
        backGroundView.addSubview(lab)
        
        //日历view
        currentCalendar = Calendar.init(identifier: .gregorian)
        //初始化的时候导航栏显示当年当月
        titleLab.text = CVDate(date: Date(), calendar: currentCalendar).globalDescription
        //初始化星期菜单栏
        menuView = CVCalendarMenuView(frame: CGRect(x:0, y:lab.bottom, width:kWidth-AutoGetHeight(height: 30), height:AutoGetHeight(height: 35)))
        //添加左右按钮
        let leftBtn = UIButton(frame:  CGRect(x: lab.left-AutoGetHeight(height: 40), y: AutoGetHeight(height: 10), width: AutoGetHeight(height: 40), height: AutoGetHeight(height: 20)))
        leftBtn.setTitle("<", for: UIControlState.normal)
        leftBtn.titleLabel?.font = kFontSize16
        leftBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        backGroundView.addSubview(leftBtn)
        leftBtn.addTarget(self, action: #selector(leftAction), for: UIControlEvents.touchUpInside)
        
        let rightBtn = UIButton(frame:  CGRect(x: lab.right, y: AutoGetHeight(height: 10), width: AutoGetHeight(height: 40), height: AutoGetHeight(height: 20)))
        rightBtn.setTitle(">", for: UIControlState.normal)
        rightBtn.titleLabel?.font = kFontSize16
        rightBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        backGroundView.addSubview(rightBtn)
        rightBtn.addTarget(self, action: #selector(rightAction), for: UIControlEvents.touchUpInside)
        
      //  初始化日历主视图
        calendarView = CVCalendarView(frame: CGRect(x:0, y:menuView.bottom, width:kWidth-AutoGetHeight(height: 30), height:AutoGetHeight(height: 185)))
        //星期菜单栏代理
        menuView.menuViewDelegate = self
        calendarView.calendarDelegate = self
        backGroundView.addSubview(menuView)
        backGroundView.addSubview(calendarView)
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
        
      
        //取消按钮
        let BKBtn = UIButton(frame:  CGRect(x: AutoGetHeight(height: 20), y: AutoGetHeight(height: 260), width: AutoGetHeight(height: 50), height: AutoGetHeight(height: 30)))
        BKBtn.setTitle("取消", for: UIControlState.normal)
        BKBtn.titleLabel?.font = kFontSize16
        BKBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        backGroundView.addSubview(BKBtn)
        BKBtn.addTarget(self, action: #selector(cancelB), for: UIControlEvents.touchUpInside)
        let sureBtn = UIButton(frame:  CGRect(x: kWidth-AutoGetWidth(width: 20+30+50), y: AutoGetHeight(height: 260), width: AutoGetHeight(height: 50), height: AutoGetHeight(height: 30)))
        sureBtn.titleLabel?.font = kFontSize16
        sureBtn.setTitle("确定", for: UIControlState.normal)
        sureBtn.setTitleColor(kBlueC, for: UIControlState.normal)
        backGroundView.addSubview(sureBtn)
        sureBtn.addTarget(self, action: #selector(sureB), for: UIControlEvents.touchUpInside)
        
    }
    
    
    @objc func leftAction(){
        self.calendarView.loadPreviousView()
    }
    @objc func rightAction(){
       self.calendarView.loadNextView()
    }
   
    
    @objc func closeWindow(){
        self.dismissPopView()
    }
    
    @objc func cancelB(){
        self.dismissPopView()
    }
    @objc func sureB(){
        if isSelectDayRange{
            if CVstartTime != nil && CVendTime != nil{
                startTime = ((CVstartTime?.convertedDate()!)?.format(with: "yyyy-MM-dd"))! + " 00:00:01"
                endTime = ((CVendTime?.convertedDate()!)?.format(with: "yyyy-MM-dd"))! + " 23:59:59"
             
            }
           
            
            if startTime == "" || endTime == ""{
                //当天的结束时间
                startTime = ((CVstartTime?.convertedDate()!)?.format(with: "yyyy-MM-dd"))! + " 00:00:01"
               let dayendTime = ((CVstartTime?.convertedDate()!)?.format(with: "yyyy-MM-dd"))! + " 23:59:59"
                clickClosure!(startTime,dayendTime)
                fatherV?.startTime = CVstartTime
                fatherV?.endTiem = CVstartTime
            }else{
                clickClosure!(startTime,endTime)
                fatherV?.startTime = CVstartTime
                fatherV?.endTiem = CVendTime
            }
        }else{
            if startTime == "" || endTime == ""{
               
            }else{
                 clickClosure!(startTime,endTime)
            }
        }
       self.dismissPopView()
      
    }
    
    func showPopView(){
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.addSubview(self)
        
    }
    
    func dismissPopView(){
        self.removeFromSuperview()
    }
    func refreshMonth() {
        for weekV in  self.calendarView.contentController.presentedMonthView.weekViews{
            for dayView in weekV.dayViews {
              //  removeCircleLabel(dayView)
                dayView.setupDotMarker()
                dayView.preliminarySetup()
                //                dayView.supplementarySetup()
                //                dayView.topMarkerSetup()
                //                dayView.interactionSetup()
                //                dayView.labelSetup()
            }
        }
    }
}
extension QRCalendarView : CVCalendarViewDelegate,CVCalendarMenuViewDelegate{
    //视图模式
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    //每周的第一天
    func firstWeekday() -> Weekday {
        //从星期一开始
        return .monday
    }
    //每个日期上面是否添加横线(连在一起就形成每行的分隔线)
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return false
    }
    //切换月的时候日历是否自动选择某一天（本月为今天，其它月为第一天）
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return false
    }
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .veryShort
    }

    func presentedDateUpdated(_ date: CVDate) {
        //导航栏显示当前日历的年月
        titleLab.text = date.globalDescription
        CVNowTime = date
      //  self.calendarView.commitCalendarViewUpdate()
        //self.calendarView.contentController.refreshPresentedMonth()
        self.refreshMonth()
    }
    

    
    //日期选择响应
    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        //选择日期
        let date = dayView.date.convertedDate()!
        let selectFormatter = DateFormatter()
        selectFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = selectFormatter.string(from: date)
        wYear = dayView.date.year
        wMonth = dayView.date.month
        wWeak = dayView.date.week
      //  self.calendarView.commitCalendarViewUpdate()
        if self.isSelectDayRange {
            //选择时间段
            //获取开始日期 - 获取结束日期
            if isSelected == true {
              self.CVstartTime = dayView.date
              self.CVendTime = nil
              self.isSelected = false
              self.isFirstSelected = true
            }else{
                if isFirstSelected == true{
                    //如果后者小于前者
                    let start = CVstartTime?.convertedDate()
                    let end = dayView.date.convertedDate()!
                    if (start?.isLater(than: end))!{
                        self.CVendTime = self.CVstartTime
                        self.CVstartTime = dayView.date
                         self.isSelected = true
                    }else if (start?.isSameDay(date: end))!{
                         //self.CVendTime = dayView.date
                    }else{
                         self.CVendTime = dayView.date
                         self.isSelected = true
                    }
                   
                   
                }else{
                    self.CVstartTime = dayView.date
                    self.isFirstSelected = true
                }
            }
           self.refreshMonth()
            //self.calendarView.contentController.refreshPresentedMonth()
           
        }else{
            //选择天
            startTime = dateStr + " 00:00:01"
            endTime = dateStr + " 23:59:59"
        }
        //选择周
        
    }
//    func spaceBetweenDayViews() -> CGFloat {
//        //消除
//        return 0
//    }
//    func latestSelectableDate() -> Date {
//        return Date()
//    }
//    func earliestSelectableDate() -> Date {
//        var dayComponents = DateComponents()
//        dayComponents.day = -1000
//        let lastDate = currentCalendar.date(byAdding: dayComponents, to: Date())
//        return lastDate!
//    }
//    func shouldSelectRange() -> Bool {
//        return isSelectDayRange
//    }
//    //时间段选择完毕
//    func didSelectRange(from startDayView: DayView, to endDayView: DayView) {
//        // 创建一个日期格式器
//        let dformatter = DateFormatter()
//        dformatter.dateFormat = "yyyy-MM-dd"
//        print("开始时间：\(dformatter.string(from: startDayView.date.convertedDate()!))")
//        print("结束时间：\(dformatter.string(from: endDayView.date.convertedDate()!))")
//        self.startTime = dformatter.string(from: startDayView.date.convertedDate()!) + " 00:00:01"
//        self.endTime = dformatter.string(from: endDayView.date.convertedDate()!) + " 23:59:59"
//    }
//
//    func maxSelectableRange() -> Int {
//        return 1000
//    }

    func shouldSelectDayView(_ dayView: DayView) -> Bool {
        return true
    }
    //不显示当前选择月的日期
    func shouldShowWeekdaysOut() -> Bool {
        return false
    }
    

    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {

        if !dayView.isHidden && dayView.date != nil {
            if CVstartTime != nil && CVendTime != nil{
              let start = CVstartTime?.convertedDate()
              let end = CVendTime?.convertedDate()
              let day = dayView.date.convertedDate()!
              let period = TimePeriod(beginning: start, end: end)
              let iscontain = period.contains(day, interval: .closed)
                if iscontain{
                    return true
                }else{
                    return false
                }

            }

        }
        return false
    }

//    //注日期使用的样式
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
          var view:CVAuxiliaryView
        
        
        if CVstartTime != nil && CVendTime != nil{
            if CVstartTime.day ==  CVendTime.day && CVstartTime.year ==  CVendTime.year && CVstartTime.month ==  CVendTime.month{
                view = CVAuxiliaryView(dayView: dayView, rect: dayView.frame,
                                       shape: CVShape.circle)
                view.fillColor = kAlpaRGB(r: 58, g: 104, b: 240, a: 1)
                return view
            }else if CVstartTime.day ==  dayView.date.day  && CVstartTime.year ==  dayView.date.year && CVstartTime.month ==  dayView.date.month{
                view = CVAuxiliaryView(dayView: dayView, rect: dayView.frame,
                                                   shape: CVShape.rightFlag)
                view.fillColor = kAlpaRGB(r: 58, g: 104, b: 240, a: 1)
                return view
            }else if CVendTime.day ==  dayView.date.day && CVendTime.year ==  dayView.date.year && CVendTime.month ==  dayView.date.month{
                view = CVAuxiliaryView(dayView: dayView, rect: dayView.frame,
                                       shape: CVShape.leftFlag)
                view.fillColor = kAlpaRGB(r: 58, g: 104, b: 240, a: 1)
                return view
            }else{
                view = CVAuxiliaryView(dayView: dayView, rect: dayView.frame,
                                       shape: CVShape.rect)
                view.fillColor = kAlpaRGB(r: 58, g: 104, b: 240, a: 1)
                return view
            }
        }else{
            return UIView(frame:  CGRect(x: 0, y: 0, width: 0, height: 0))
        }
        
    }


    
}

//
//  QRWorkmateScheduleVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/4/22.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRWorkmateScheduleVC: SuperVC {
    
    //选中联系人model
    var overTimeModel:CQDepartMentUserListModel?
    
    var pageNum = 1
    
    var curIndex:NSInteger = 0
    //当前选择用户id
    var curUserId = ""
    
    //星期菜单栏
    var menuView:CVCalendarMenuView!
    //日历主视图
    var calendarView:CVCalendarView!
    
    var currentCalendar:Calendar!
    //选择日期
    var dateStr = ""
    
    var morningData = [CQScheduleModel]()
    var afternoonData = [CQScheduleModel]()
    
    var scheduleArray = [String]()
    
    var preDayView:CVCalendarDayView?
    
    var lastBtn:UIButton?
    
    var navBar : QRNavbarView?

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y:CGFloat(SafeAreaTopHeight)  , width: kWidth, height: kHeight - CGFloat(SafeAreaTopHeight)))
        scrollView.contentSize = CGSize.init(width: kWidth, height:kHeight - CGFloat(SafeAreaTopHeight) - CGFloat(SafeAreaBottomHeight) )
        scrollView.backgroundColor = kProjectBgColor
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.tag = 1001
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
      //  scrollView.isScrollEnabled = false
        return scrollView
    }()

    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 329)))
        headView.backgroundColor = UIColor.white
        return headView
    }()
    
    lazy var chooseDateBtn: UIButton = {
        let chooseDateBtn = UIButton.init(type: .custom)
        chooseDateBtn.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 44))
        chooseDateBtn.setTitle("2018年3月", for: .normal)
        chooseDateBtn.setTitleColor(UIColor.black, for: .normal)
        chooseDateBtn.titleLabel?.font = kFontSize18
        chooseDateBtn.layer.borderColor = kProjectBgColor.cgColor
        chooseDateBtn.layer.borderWidth = 1
        
        
        //添加左右按钮
        let leftBtn = UIButton(frame:  CGRect(x: kWidth/2-AutoGetHeight(height: 90), y: AutoGetHeight(height: 12), width: AutoGetHeight(height: 40), height: AutoGetHeight(height: 20)))
        leftBtn.setTitle("<", for: UIControlState.normal)
        leftBtn.titleLabel?.font = kFontSize16
        leftBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        chooseDateBtn.addSubview(leftBtn)
        leftBtn.addTarget(self, action: #selector(leftAction), for: UIControlEvents.touchUpInside)
        
        let rightBtn = UIButton(frame:  CGRect(x: kWidth/2+AutoGetWidth(width: 50), y: AutoGetHeight(height: 12), width: AutoGetHeight(height: 40), height: AutoGetHeight(height: 20)))
        rightBtn.setTitle(">", for: UIControlState.normal)
        rightBtn.titleLabel?.font = kFontSize16
        rightBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        chooseDateBtn.addSubview(rightBtn)
        rightBtn.addTarget(self, action: #selector(rightAction), for: UIControlEvents.touchUpInside)
        
        return chooseDateBtn
    }()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: self.headView.bottom , width: kWidth, height: kHeight  - self.headView.frame.size.height  - AutoGetHeight(height: 65) - CGFloat(SafeAreaBottomHeight)), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.backgroundColor = kProjectBgColor
        table.delegate = self
        table.dataSource = self
        table.separatorColor = kLineColor
        table.tag = 100086
        table.separatorInset = UIEdgeInsets.init(top: 0, left: AutoGetWidth(width: 97), bottom: 0, right: 0)
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.scrollView)
        self.initScheduleView()
    
    }
  
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.menuView.commitMenuViewUpdate()
        self.calendarView.commitCalendarViewUpdate()
    }
    

    func initScheduleView()  {
        self.scrollView.addSubview(self.headView)
        self.headView.addSubview(self.chooseDateBtn)
        self.scrollView.addSubview(self.table)
      
        self.loadData(uid: self.curUserId)
        self.getSchedulePlanByMonthListRequest()
        
        self.table.register(CQScheduleCell.self, forCellReuseIdentifier: "CQScheduleCellId")
        self.table.register(QRScheduleNewCell.self, forCellReuseIdentifier: "QRScheduleNewCellId")
        self.table.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CQScheduleHeader")
        
        self.initCalView()
        
    }
    
    func initCalView()  {
        currentCalendar = Calendar.init(identifier: .gregorian)
        //初始化的时候导航栏显示当年当月
        self.chooseDateBtn.setTitle(CVDate(date: Date(), calendar: currentCalendar).globalDescription, for: .normal)
        
        //初始化星期菜单栏
        self.menuView = CVCalendarMenuView(frame: CGRect(x:0, y:self.chooseDateBtn.bottom, width:kWidth, height:AutoGetHeight(height: 35)))
        
        //初始化日历主视图
        self.calendarView = CVCalendarView(frame: CGRect(x:0, y:self.menuView.bottom + AutoGetHeight(height: 10), width:kWidth, height:AutoGetHeight(height: 240)))
        //星期菜单栏代理
        self.menuView.menuViewDelegate = self
        
        //将菜单视图和日历视图添加到主视图上
        self.headView.addSubview(menuView)
        self.headView.addSubview(calendarView)
        
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isHidden = false
         self.navBar?.removeFromSuperview()
         self.navBar = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isHidden = true
        let nav = Bundle.main.loadNibNamed("QRHeadNavView", owner: nil, options: nil)?.last as! QRNavbarView
        nav.titleLab.text = title
        nav.frame =  CGRect(x: 0, y: 0, width: kWidth, height: SafeAreaTopHeight)
        self.view.addSubview(nav)
        view.bringSubview(toFront: nav)
        self.navBar = nav
        nav.rightBut.setTitle("我的日程", for: UIControlState.normal)
        nav.rightBut.titleLabel?.font = kFontSize17
        nav.rightBut.setTitleColor(kBlueColor, for: .normal)
        nav.clickClosure = {type in
            if type == .back{
               NotificationCenter.default.post(name: NSNotification.Name.init("popFromMate"), object: nil)
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        
    }
    deinit {
        print("deinit")
    }
}


extension QRWorkmateScheduleVC{
    func loadData(uid:String) {
        let userID = STUserTool.account().userID
        if self.dateStr == "" {
            let now = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            self.dateStr = dateFormat.string(from: now)
        }
        
        STNetworkTools.requestData(URLString: "\(baseUrl)/schedule/getSchedulePlanByDayList",
            type: .get,
            param: ["userId":self.curUserId,
                    "loginUserId":userID,
                    "date":self.dateStr],
            successCallBack: { (result) in
                var amArray = [CQScheduleModel]()
                var bmArray = [CQScheduleModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQScheduleModel(jsonData: modalJson) else {
                        return
                    }
                    if modal.startDatePMorAM == "0"{
                        amArray.append(modal)
                    }else{
                        bmArray.append(modal)
                    }
                }
                self.morningData = amArray
                self.afternoonData = bmArray
                
                self.table.reloadData()
        }) { (error) in
            
        }
    }
    
    
    @objc func leftAction(){
        self.calendarView.loadPreviousView()
    }
    @objc func rightAction(){
        self.calendarView.loadNextView()
    }
    
    
    
    //按月份查询
    func getSchedulePlanByMonthList(dataStr:String) {
       // let userID = self.curUserId
       let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/schedule/getSchedulePlanByMonthList" ,
            type: .get,
            param: ["userId":self.curUserId,
                    "loginUserId":userID,
                    "date":dataStr],
            successCallBack: { (result) in
                
                //请假
                var leaveArray = [String]()
                for modalJson in result["data"]["leaveData"].arrayValue {
                    leaveArray.append(modalJson.stringValue)
                }
                //会议
                var meetArray = [String]()
                for modalJson in result["data"]["meetingscheduleData"].arrayValue {
                    meetArray.append(modalJson.stringValue)
                }
                //外出
                var outWorkArray = [String]()
                for modalJson in result["data"]["outWorkData"].arrayValue {
                    outWorkArray.append(modalJson.stringValue)
                }
                //日程
                var tempScheduleArray = [String]()
                for modalJson in result["data"]["schedulePlanData"].arrayValue {
                    tempScheduleArray.append(modalJson.stringValue)
                }
                self.scheduleArray = tempScheduleArray
                //出差
                var travelArray = [String]()
                for modalJson in result["data"]["travelData"].arrayValue {
                    travelArray.append(modalJson.stringValue)
                }
                
                //日历代理
                self.calendarView.calendarDelegate = self
                var num:Int?
                for v in self.calendarView.contentController.presentedMonthView.weekViews{
                    
                    for i in 0..<v.dayViews.count{
                        
                        let dayView = v.dayViews[i]
                        dayView.statuesLab.textColor = kGoldYellowColor
                        
                        
                        for dateStr in leaveArray{
                            let str = dateStr as NSString
                            num = Int(str.substring(with: NSRange.init(location: 8, length: 2)))
                            DLog(num)
                            
                            if Int(dayView.dayLabel.text!) == num {
                                dayView.statuesLab.text = "假"
                            }
                        }
                        
                        for dateStr in meetArray{
                            let str = dateStr as NSString
                            num = Int(str.substring(with: NSRange.init(location: 8, length: 2)))
                            DLog(num)
                            
                            if Int(dayView.dayLabel.text!) == num {
                                dayView.statuesLab.text = "会"
                            }
                        }
                        
                        for dateStr in outWorkArray{
                            let str = dateStr as NSString
                            num = Int(str.substring(with: NSRange.init(location: 8, length: 2)))
                            DLog(num)
                            
                            if Int(dayView.dayLabel.text!) == num {
                                dayView.statuesLab.text = "外"
                            }
                        }
                        
                        //                        for dateStr in scheduleArray{
                        //                            let str = dateStr as NSString
                        //                            num = Int(str.substring(with: NSRange.init(location: 8, length: 2)))
                        //                            DLog(num)
                        //
                        //                            if Int(dayView.dayLabel.text!) == num {
                        //                                dayView.statuesLab.text = "日"
                        //                            }
                        //                        }
                        
                        for dateStr in travelArray{
                            let str = dateStr as NSString
                            num = Int(str.substring(with: NSRange.init(location: 8, length: 2)))
                            DLog(num)
                            
                            if Int(dayView.dayLabel.text!) == num {
                                dayView.statuesLab.text = "差"
                            }
                        }
                        
                        var comps = DateComponents.init()
                        comps.year = dayView.date.year
                        comps.month = dayView.date.month
                        comps.weekOfMonth = dayView.date.week
                        comps.day = dayView.date.day
                        
                        let dateSt = DAYUtils.localCalendar()?.date(from: comps)
                        dayView.localDayLab.text =  DAYUtils.lunar(forSolarYear: dateSt)
                        
                    }
                }
               // self.calendarView.contentController.refreshPresentedMonth()
                self.refreshMonth()
                self.calendarView.commitCalendarViewUpdate()
        }) { (error) in
            
        }
    }
    func refreshMonth() {
        for weekV in  self.calendarView.contentController.presentedMonthView.weekViews{
            for dayView in weekV.dayViews {
                //   removeCircleLabel(dayView)
                dayView.setupDotMarker()
                //                dayView.preliminarySetup()
                //                dayView.supplementarySetup()
                //                dayView.topMarkerSetup()
                //                dayView.interactionSetup()
                //                dayView.labelSetup()
            }
        }
    }
    
   
    
    func getSchedulePlanByMonthListRequest() {
        let userID = STUserTool.account().userID
        var data = self.dateStr
        if data == "" {
            let now = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM"
            data = dateFormat.string(from: now)
        }else{
            let str = data as! NSMutableString
            let newStr = str.substring(to: 7)
            data = newStr
        }
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/schedule/getSchedulePlanByMonthList" ,
            type: .get,
            param: ["userId":self.curUserId,
                    "loginUserId":userID,
                    "date":data],
            successCallBack: { (result) in
               
                //请假
                var leaveArray = [String]()
                for modalJson in result["data"]["leaveData"].arrayValue {
                    leaveArray.append(modalJson.stringValue)
                }
                //会议
                var meetArray = [String]()
                for modalJson in result["data"]["meetingscheduleData"].arrayValue {
                    meetArray.append(modalJson.stringValue)
                }
                //外出
                var outWorkArray = [String]()
                for modalJson in result["data"]["outWorkData"].arrayValue {
                    outWorkArray.append(modalJson.stringValue)
                }
                //日程
                var tempScheduleArray = [String]()
                for modalJson in result["data"]["schedulePlanData"].arrayValue {
                    tempScheduleArray.append(modalJson.stringValue)
                }
                self.scheduleArray = tempScheduleArray
                //出差
                var travelArray = [String]()
                for modalJson in result["data"]["travelData"].arrayValue {
                    travelArray.append(modalJson.stringValue)
                }
                
                //日历代理
                self.calendarView.calendarDelegate = self
                var num:Int?
                for v in self.calendarView.contentController.presentedMonthView.weekViews{
                    
                    for i in 0..<v.dayViews.count{
                        
                        let dayView = v.dayViews[i]
                        dayView.statuesLab.textColor = kGoldYellowColor
                        
                        
                        for dateStr in leaveArray{
                            let str = dateStr as NSString
                            num = Int(str.substring(with: NSRange.init(location: 8, length: 2)))
                            DLog(num)
                            
                            if Int(dayView.dayLabel.text!) == num {
                                dayView.statuesLab.text = "假"
                            }
                        }
                        
                        for dateStr in meetArray{
                            let str = dateStr as NSString
                            num = Int(str.substring(with: NSRange.init(location: 8, length: 2)))
                            DLog(num)
                            
                            if Int(dayView.dayLabel.text!) == num {
                                dayView.statuesLab.text = "会"
                            }
                        }
                        
                        for dateStr in outWorkArray{
                            let str = dateStr as NSString
                            num = Int(str.substring(with: NSRange.init(location: 8, length: 2)))
                            DLog(num)
                            
                            if Int(dayView.dayLabel.text!) == num {
                                dayView.statuesLab.text = "外"
                            }
                        }
                        
                        //                        for dateStr in scheduleArray{
                        //                            let str = dateStr as NSString
                        //                            num = Int(str.substring(with: NSRange.init(location: 8, length: 2)))
                        //                            DLog(num)
                        //
                        //                            if Int(dayView.dayLabel.text!) == num {
                        //                                dayView.statuesLab.text = "日"
                        //                            }
                        //                        }
                        
                        for dateStr in travelArray{
                            let str = dateStr as NSString
                            num = Int(str.substring(with: NSRange.init(location: 8, length: 2)))
                            DLog(num)
                            
                            if Int(dayView.dayLabel.text!) == num {
                                dayView.statuesLab.text = "差"
                            }
                        }
                        
                        var comps = DateComponents.init()
                        comps.year = dayView.date.year
                        comps.month = dayView.date.month
                        comps.weekOfMonth = dayView.date.week
                        comps.day = dayView.date.day
                        
                        let dateSt = DAYUtils.localCalendar()?.date(from: comps)
                        dayView.localDayLab.text =  DAYUtils.lunar(forSolarYear: dateSt)
                        
                    }
                }
                
                self.calendarView.commitCalendarViewUpdate()
        }) { (error) in
            
        }
    }
    
    //删除日程请求
    func loadDeleteScheduleRequest(scheduleId:String) {
        SVProgressHUD.show()
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/schedule/deleteSchedule" ,
            type: .post,
            param: ["userId":userID,"scheduleId":scheduleId],
            successCallBack: { (result) in
                if result["success"].boolValue{
                    SVProgressHUD.showInfo(withStatus: result["message"].stringValue)
                }
                SVProgressHUD.dismiss()
                self.loadData(uid: self.curUserId)
                
        }) { (error) in
            
        }
    }
}

// Mark:日历代理
extension QRWorkmateScheduleVC: CVCalendarViewDelegate,CVCalendarMenuViewDelegate {
    //视图模式
    func presentationMode() -> CalendarMode {
        //使用月视图
        return .monthView
    }
    
    //每周的第一天
    func firstWeekday() -> Weekday {
        //从星期一开始
        return .sunday
    }
    
    func presentedDateUpdated(_ date: CVDate) {
        //导航栏显示当前日历的年月
        self.chooseDateBtn.setTitle(date.globalDescription, for: .normal)
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM"
        let dataStr = dateFormat.string(from: date.convertedDate()!)
        print(dataStr)
        self.getSchedulePlanByMonthList(dataStr: dataStr)
        
//        for v in self.calendarView.contentController.presentedMonthView.weekViews{
//            for i in 0..<v.dayViews.count{
//                let dayView = v.dayViews[i]
//                var comps = DateComponents.init()
//                comps.year = dayView.date.year
//                comps.month = dayView.date.month
//                comps.weekOfMonth = dayView.date.week
//                comps.day = dayView.date.day
//
//                let dateSt = DAYUtils.localCalendar()?.date(from: comps)
//                dayView.localDayLab.text =  DAYUtils.lunar(forSolarYear: dateSt)
//            }
//        }
    }
    
    //每个日期上面是否添加横线(连在一起就形成每行的分隔线)
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return false
    }
    
    //切换月的时候日历是否自动选择某一天（本月为今天，其它月为第一天）
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return false
    }
    
    //日期选择响应
    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        
        //获取日期
        let date = dayView.date.convertedDate()!
        
        /*
         // 创建一个日期格式器
         let dformatter = DateFormatter()
         dformatter.dateFormat = "yyyy年MM月dd日"
         let message = "当前选择的日期是：\(dformatter.string(from: date))"
         //将选择的日期弹出显示
         let alertController = UIAlertController(title: "", message: message,
         preferredStyle: .alert)
         let okAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
         alertController.addAction(okAction)
         self.present(alertController, animated: true, completion: nil)
         */
        let selectFormatter = DateFormatter()
        selectFormatter.dateFormat = "yyyy-MM-dd"
        self.dateStr = selectFormatter.string(from: date)
        
        self.loadData(uid:self.curUserId)
        if !dayView.isCurrentDay{
            self.calendarView.isUserInteractionEnabled = false
            self.perform(#selector(fixColor), with: self, afterDelay: 1.0)
        }else{
            self.preDayView?.dayLabel.textColor = .white
        }
        DLog(dayView.bounds)
    }
    
    @objc func fixColor()  {
        preDayView?.dayLabel.textColor = .red
        self.calendarView.isUserInteractionEnabled = true
    }
    
    func shouldSelectDayView(_ dayView: DayView) -> Bool {
        
        return true
    }
    
    //不显示当前选择月的日期
    func shouldShowWeekdaysOut() -> Bool {
        return false
    }
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .veryShort
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
//        if !dayView.isHidden && dayView.date != nil{
//            //判断日期是否满足要求
//            if dayView.isCurrentDay {
//                self.preDayView = dayView
//                return true
//            }else{
//                return false
//            }
//        }
//        return false
         return true
    }
    
    //日期使用格式
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        //红色圆形背景
        if let date = dayView.date{
            dayView.localDayLab.text =  DAYUtils.lunar(forSolarYear: date.convertedDate())
            if date.day ==  Date().day && date.year ==  Date().year && date.month ==  Date().month{
                //    红色圆形背景
                let circleView = CVAuxiliaryView.init(dayView: dayView, rect: CGRect.init(x: 0, y: 0, width: 28, height: 28), shape: CVShape.rect)
                circleView.center = dayView.center
                circleView.fillColor = .clear
                circleView.layer.borderColor = UIColor.red.cgColor
                circleView.layer.borderWidth = 1
                circleView.layer.cornerRadius = 14
                
                self.preDayView = dayView
                return circleView
                
            }else{
                return UIView()
            }
        }else{
            return UIView()
        }
//        let circleView = CVAuxiliaryView.init(dayView: dayView, rect: CGRect.init(x: 0, y: 0, width: 28, height: 28), shape: CVShape.rect)
//        circleView.center = dayView.center
//        circleView.fillColor = .clear
//        circleView.layer.borderColor = UIColor.red.cgColor
//        circleView.layer.borderWidth = 1
//        circleView.layer.cornerRadius = 14
//
//        return circleView
    }
    
    //该日期视图是否有标记点
    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
        
        var curStr = ""
        if !dayView.isHidden && dayView.date != nil{
            //获取日期
            let date = dayView.date.convertedDate()!
            let selectFormatter = DateFormatter()
            selectFormatter.dateFormat = "yyyy-MM-dd"
            curStr = selectFormatter.string(from: date)
            for dateStr in self.scheduleArray{
                if dateStr == curStr{
                    return true
                }
            }
        }
        return false
    }
    
    //返回相应日期视图各个标记点的颜色数组(每个日期最多3个点)
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
        return [kGoldYellowColor]
    }
    
    //    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
    //        return 3
    //    }
    
    func dotMarker(moveOffsetOnDayView dayView: DayView) -> CGFloat {
        return 15
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: DayView) -> Bool {
        return false
    }
}


extension QRWorkmateScheduleVC:UIScrollViewDelegate{
  
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if 100086 == scrollView.tag  {
            DLog(scrollView.contentOffset.y)
            if scrollView.contentOffset.y > 0 {
                UIView.animate(withDuration: 0.3, animations: {
                    
                }) { (finish:Bool) in
                    if self.curIndex == 0 {
                        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 139))
                        self.calendarView.frame = CGRect(x:0, y:self.menuView.bottom + AutoGetHeight(height: 10), width:kWidth, height:AutoGetHeight(height: 60))
                        self.table.frame = CGRect.init(x: 0, y: self.headView.bottom, width: kWidth, height: kHeight - self.headView.frame.size.height - AutoGetHeight(height: 65) )
                        self.calendarView.changeMode(.weekView)
                    }
                    
                }
            }else if scrollView.contentOffset.y < 0{
                UIView.animate(withDuration: 0.3, animations: {
                    
                }) { (finish:Bool) in
                    if self.curIndex == 0 {
                        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 329))
                        self.calendarView.frame = CGRect(x:0, y:self.menuView.bottom + AutoGetHeight(height: 10), width:kWidth, height:AutoGetHeight(height: 240))
                        self.table.frame = CGRect.init(x: 0, y: self.headView.bottom, width: kWidth, height: kHeight - self.headView.frame.size.height - AutoGetHeight(height: 65))
                        self.calendarView.changeMode(.monthView)
                        self.getSchedulePlanByMonthListRequest()
                    }
                }
            }
        }
    }
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if 100086 == scrollView.tag  {
//            if scrollView.contentOffset.y > 0 {
//                UIView.animate(withDuration: 0.3, animations: {
//
//                }) { (finish:Bool) in
//                        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 139))
//                        self.calendarView.frame = CGRect(x:0, y:self.menuView.bottom + AutoGetHeight(height: 10), width:kWidth, height:AutoGetHeight(height: 60))
//                        self.table.frame = CGRect.init(x: 0, y: self.headView.bottom, width: kWidth, height: kHeight - self.headView.frame.size.height - AutoGetHeight(height: 65) - SafeAreaBottomHeight)
//                        self.calendarView.changeMode(.weekView)
//                }
//            }else if scrollView.contentOffset.y < 0{
//                UIView.animate(withDuration: 0.3, animations: {
//
//                }) { (finish:Bool) in
//                        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 329))
//                        self.calendarView.frame = CGRect(x:0, y:self.menuView.bottom + AutoGetHeight(height: 10), width:kWidth, height:AutoGetHeight(height: 240))
//                        self.table.frame = CGRect.init(x: 0, y: self.headView.bottom, width: kWidth, height: kHeight - self.headView.frame.size.height - AutoGetHeight(height: 65) - SafeAreaBottomHeight)
//                        self.calendarView.changeMode(.monthView)
//                }
//            }
//        }
//    }
}

// Mark:tableDelegate
extension QRWorkmateScheduleVC:UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
}

extension QRWorkmateScheduleVC:UITableViewDataSource{
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return UITableViewCellEditingStyle.delete
//    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        //删除CQScheduleModel
//        var id = ""
//        if 0 == indexPath.section {
//            id = self.morningData[indexPath.row].schedulePlanId
//        }else{
//            id = self.afternoonData[indexPath.row].schedulePlanId
//            
//        }
//        
//        self.loadDeleteScheduleRequest(scheduleId: id)
//    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if 1 == section {
            return self.afternoonData.count
        }
        return self.morningData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQScheduleCellId") as! CQScheduleCell
        cell.accessoryType = .none
        if 0 == indexPath.section {
            cell.model = self.morningData[indexPath.row]
        }else{
            cell.model = self.afternoonData[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model:CQScheduleModel?
        if 0 == indexPath.section {
            model = self.morningData[indexPath.row]
        }else{
            model = self.afternoonData[indexPath.row]
        }
        let vc = CQScheduleDetailVC.init()
        vc.schedulePlanId = model!.schedulePlanId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoGetHeight(height: 70)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AutoGetHeight(height: 51)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 51)))
        header.backgroundColor = kProjectBgColor
        let bgView = UIView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 38)))
        bgView.backgroundColor = UIColor.white
        header.addSubview(bgView)
        
        let lab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kHaveLeftWidth, height: AutoGetHeight(height: 38)))
        if section == 1 {
            lab.text = "下午"
        }else{
            lab.text = "上午"
        }
        lab.textAlignment = .left
        lab.textColor = UIColor.black
        lab.font = kFontSize15
        bgView.addSubview(lab)
        
        let line = UIView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 51) - 0.5, width: kWidth, height: 0.5))
        line.backgroundColor = kLineColor
        header.addSubview(line)
        return header
    }
    
    
}

// Mark:添加按钮代理
extension QRWorkmateScheduleVC:CQScheduleSelectDelegate{
    func pushToDetailThroughType(btn: UIButton) {
        if 400 == btn.tag{
            let vc = CQCreateScheduleVC.init()
            vc.type = .save
            self.navigationController?.pushViewController(vc, animated: true)
        }else if 401 == btn.tag{
            let vc = CQCreateMeetingVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = CQCreateTaskVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

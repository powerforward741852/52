//
//  CQScheduleVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/10.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQScheduleVC: SuperVC {

    var isFromTask = false
    //选中联系人model
    var overTimeModel:CQDepartMentUserListModel?
    
    var pageNum = 1
    
    var taskDataArray = [CQTaskModel]()
    
    var curIndex:NSInteger?
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
    
    //titleView
    lazy var btnView: UIView = {
        let btnView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height:  40))
        btnView.backgroundColor = UIColor.white
       
        return btnView
    }()
    let titleArr = ["日程","任务"]
    var btnArr = [UIButton]()
    var lastBtn:UIButton?
    lazy var lineView: UIView = {
        let lineView = UIView.init(frame: CGRect.init(x: 0, y: 38, width: 50, height: 2))
        lineView.backgroundColor = kLightBlueColor
        return lineView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y:CGFloat(SafeAreaTopHeight)  , width: kWidth, height: kHeight - CGFloat(SafeAreaTopHeight)))
        scrollView.contentSize = CGSize.init(width: kWidth * 2, height:kHeight - CGFloat(SafeAreaTopHeight) - CGFloat(SafeAreaBottomHeight) )
        scrollView.backgroundColor = kProjectBgColor
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
       // scrollView.backgroundColor = UIColor.black
        scrollView.tag = 1001
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = false
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
        
        chooseDateBtn.addTarget(self, action: #selector(chooseDateClick), for: .touchUpInside)
        
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
        let table = UITableView.init(frame: CGRect.init(x: 0, y: self.headView.bottom , width: kWidth, height: kHeight  - self.headView.frame.size.height  - AutoGetHeight(height: 65) - AutoGetHeight(height: 55) - CGFloat(SafeAreaBottomHeight)), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.backgroundColor = kProjectBgColor
        table.delegate = self
        table.dataSource = self
        table.separatorColor = kLineColor
        table.tag = 1000
        table.separatorInset = UIEdgeInsets.init(top: 0, left: AutoGetWidth(width: 97), bottom: 0, right: 0)
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    
    lazy var BtnView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = UIColor.white
        whiteView.frame =  CGRect(x: 0, y: kHeight - CGFloat(SafeAreaTopHeight) - CGFloat(SafeAreaBottomHeight) - AutoGetHeight(height: 55) , width: kWidth, height: AutoGetHeight(height: 55) + CGFloat(SafeAreaBottomHeight) )
        whiteView.addSubview(workmateBtn)
        whiteView.isHidden = true
        return whiteView
    }()
    
    lazy var workmateBtn: UIButton = {
        let workmateBtn = UIButton.init(type: .custom)
        workmateBtn.frame = CGRect.init(x: kLeftDis, y: 5 , width: kHaveLeftWidth, height: AutoGetHeight(height: 45))
        workmateBtn.setTitle("同事日程", for: .normal)
        workmateBtn.setTitleColor(UIColor.white, for: .normal)
        workmateBtn.backgroundColor = kLightBlueColor
        workmateBtn.layer.cornerRadius = 3
        workmateBtn.addTarget(self, action: #selector(workmateClick), for: .touchUpInside)
        workmateBtn.isHidden = true
        return workmateBtn
    }()
    
    
    
    lazy var taskView: UIView = {
        let taskView = UIView.init(frame: CGRect.init(x: kWidth, y: 0, width: kWidth, height: AutoGetHeight(height: 68)))
        taskView.backgroundColor = kProjectBgColor
        return taskView
    }()
    
    lazy var taskBtn: UIButton = {
        let taskBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 55)))
        taskBtn.backgroundColor = UIColor.white
        taskBtn.addTarget(self, action: #selector(myPublishTask), for: UIControlEvents.touchUpInside)
        return taskBtn
    }()
    
    lazy var taskLab: UILabel = {
        let taskLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kWidth/2, height: AutoGetHeight(height: 55)))
        taskLab.text = "我发布的任务"
        taskLab.textAlignment = .left
        taskLab.font = kFontSize15
        taskLab.textColor = UIColor.black
        taskLab.isUserInteractionEnabled = true
        return taskLab
    }()
    
    lazy var taskImg: UIImageView = {
        let taskImg = UIImageView.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 21.5), y: AutoGetHeight(height: 21.5), width: AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 12)))
        taskImg.image = UIImage.init(named: "PersonAddressArrow")
        taskImg.isUserInteractionEnabled = true
        return taskImg
    }()
    
    lazy var taskTable: CQTaskTable = {
        let taskTable = CQTaskTable.init(frame: CGRect.init(x: kWidth, y: self.taskView.bottom, width: kWidth, height: kHeight - AutoGetHeight(height: 68)), style: UITableViewStyle.plain)
        taskTable.selectDelegate = self
        return taskTable
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnView.addSubview(self.lineView)
        initBtn()
        self.navigationItem.titleView = self.btnView
        
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.scrollView)
        self.initScheduleView()
        self.initTaskView()
        if isFromTask {
            self.scrollView.setContentOffset(CGPoint.init(x: kWidth, y: 0), animated: true)
            btnClick(btn: self.btnArr[1])
            self.curIndex = 1
        }else{
            self.curIndex = 0
            btnClick(btn: self.btnArr[0])
        }
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 19, height: 19))
        rightBtn.setImage(UIImage.init(named: "FriendAdd"), for: .normal)
        rightBtn.addTarget(self, action: #selector(addClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
       
        
        let NotifMycation = NSNotification.Name(rawValue:"refreshAddAddressVC")
        NotificationCenter.default.addObserver(self, selector: #selector(overChange(notif:)), name: NotifMycation, object: nil)
    }
    deinit {
       NotificationCenter.default.removeObserver(self)
    }
    //生成btn群
    func initBtn()  {
        for i in 0..<2 {
            let btn = UIButton.init(type: .custom)
            btn.frame = CGRect.init(x: 50 * CGFloat(i), y: 0, width: 50, height: 38)
            btn.setTitle(titleArr[i], for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.tag = 300+i
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            btn.setTitleColor(kLightBlueColor, for: .selected)
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.titleLabel?.font = kFontSize15
            self.btnView.addSubview(btn)
            self.btnArr.append(btn)
        }
    }
    //点击事件
    @objc func btnClick(btn:UIButton)  {
        if lastBtn?.tag != btn.tag {
            lastBtn?.setTitleColor(UIColor.black, for: .normal)
            lastBtn?.titleLabel?.font = kFontSize15
            btn.titleLabel?.font = kFontBoldSize17
            btn.setTitleColor(kLightBlueColor, for: .normal)
            lastBtn = btn
            let xx =  50 * CGFloat(btn.tag - 300)
            UIView.animate(withDuration: 0.25) {
                self.lineView.frame = CGRect.init(x: xx, y: 38, width: 50, height: 2)
            }
            self.scrollView.setContentOffset(CGPoint.init(x: kWidth * CGFloat(btn.tag - 300), y: 0), animated: true)
            curIndex = btn.tag - 300
        }
    }
    
    @objc func leftAction(){
        self.calendarView.loadPreviousView()
    }
    @objc func rightAction(){
        self.calendarView.loadNextView()
    }
    
    func initScheduleView()  {
        self.scrollView.addSubview(self.headView)
        self.headView.addSubview(self.chooseDateBtn)
        self.scrollView.addSubview(self.table)
        self.curUserId = STUserTool.account().userID
        self.loadData(uid: self.curUserId)
        self.getSchedulePlanByMonthListRequest()
        
        self.table.register(CQScheduleCell.self, forCellReuseIdentifier: "CQScheduleCellId")
        self.table.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CQScheduleHeader")
        
        self.initCalView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUI(notification:)), name: NSNotification.Name(rawValue: "refreshScheduleUI"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(workMateUI(notification:)), name: NSNotification.Name(rawValue: "postUserIdToScheduleVC"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(popFromMate(notification:)), name: NSNotification.Name(rawValue: "popFromMate"), object: nil)
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
        self.calendarView.calendarAppearanceDelegate = self
        //将菜单视图和日历视图添加到主视图上
        self.headView.addSubview(menuView)
        self.headView.addSubview(calendarView)
        self.scrollView.addSubview(self.BtnView)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func initTaskView()  {
        self.setUpRefresh()
        self.scrollView.addSubview(self.taskView)
        self.taskView.addSubview(self.taskBtn)
        self.taskBtn.addSubview(self.taskLab)
        self.taskBtn.addSubview(self.taskImg)
        self.scrollView.addSubview(self.taskTable)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTaskUI(notification:)), name: NSNotification.Name.init("refreshTaskUI"), object: nil)
    }
    
    @objc func viewControllChange(_ sender: Any)  {
        let segment = sender as! UISegmentedControl
        self.curIndex = segment.selectedSegmentIndex
        self.scrollView.contentOffset = CGPoint.init(x: kWidth * CGFloat(curIndex!), y: 0)
    }
    
    //同事日程
    @objc func workMateUI(notification:Notification)  {
        guard let str: String = notification.object as! String? else { return }
        self.curUserId = str
        self.loadData(uid: self.curUserId)

    }
    //同事日程会来
    @objc func popFromMate(notification:Notification){
        self.navigationController?.popToViewController(self, animated: false)
         self.jumpIn()
    }
    //详情通知刷新UI
    @objc func refreshUI(notification:Notification)  {
        self.loadData(uid: self.curUserId)
    }
    //详情通知刷新UI
    @objc func refreshTaskUI(notification:Notification)  {
        self.setUpRefresh()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.menuView.commitMenuViewUpdate()
        self.calendarView.commitCalendarViewUpdate()
    }
    
    @objc func addClick()  {
        initSelectView()
    }
    
    @objc func myPublishTask()  {
        let vc = CQMyRecieveTaskVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func initSelectView()  {
        let selectView = CQScheduleSelectView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight))
        selectView.cqSelectDelegate = self
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.addSubview(selectView)
    }
    
    @objc func chooseDateClick()  {
    }
    
    @objc func workmateClick()  {
//        let vc = AddressBookVC()
//        vc.toType = .fromSchedule
//        self.navigationController?.pushViewController(vc, animated: true)
        
        self.jumpIn()
        
    }
    func jumpIn(){
        //let vc = AddressBookVC.init()
        let vc = QRAddressBookVC.init()
        vc.toType = .fromContact
        if self.overTimeModel != nil{
            vc.hasSelectModelArr = [self.overTimeModel] as! [CQDepartMentUserListModel]
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //接收加班人
    @objc func overChange(notif: NSNotification) {
        guard let model: CQDepartMentUserListModel = notif.object as? CQDepartMentUserListModel else { return }
        self.overTimeModel = model
        let vc = QRWorkmateScheduleVC()
        vc.title = model.realName + "的日程"
        vc.curUserId = model.userId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}

extension CQScheduleVC{
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
            param: ["userId":uid,
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
    
    fileprivate func setUpRefresh() {
        // MARK:header
        let STHeader = CQRefreshHeader {[unowned self] in
            self.loadTaskDatas(moreData: false)
        }
        // MARK:footer
        let STFooter = CQRefreshFooter {[unowned self] in
            self.loadTaskDatas(moreData: true)
        }
        self.taskTable.mj_header = STHeader
        self.taskTable.mj_footer = STFooter
        self.taskTable.mj_header.beginRefreshing()
    }
    // MARK:request
    fileprivate func loadTaskDatas(moreData: Bool) {
        if moreData {
            pageNum += 1
        } else {
            pageNum = 1
        }
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/personnelTask/getPersonnelTaskByPage" ,
            type: .get,
            param: ["userId":userID,
                    "currentPage":pageNum,
                    "rows":"10",
                    "searchmode":"2"],
            successCallBack: { (result) in
                var tempArray = [CQTaskModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQTaskModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                
                if moreData {
                    self.taskDataArray.append(contentsOf: tempArray)
                } else {
                    self.taskDataArray = tempArray
                }
                //刷新表格
                self.taskTable.mj_header.endRefreshing()
                self.taskTable.mj_footer.endRefreshing()
                
                self.taskTable.dataArray = self.taskDataArray
                self.taskTable.reloadData()
                //分页控制
                let total = result["total"].intValue
                if self.taskDataArray.count == total {
                    self.taskTable.mj_footer.endRefreshingWithNoMoreData()
                }else {
                    self.taskTable.mj_footer.resetNoMoreData()
                }
                
        }) { (error) in
            self.taskTable.reloadData()
            self.taskTable.mj_header.endRefreshing()
            self.taskTable.mj_footer.endRefreshing()
        }
    }
    
    //按月份查询
    func getSchedulePlanByMonthList(dataStr:String) {
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/schedule/getSchedulePlanByMonthList" ,
            type: .get,
            param: ["userId":userID,
                    "loginUserId":self.curUserId,
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
                          //  DLog(num)
                            
                            if Int(dayView.dayLabel.text!) == num {
                                dayView.statuesLab.text = "假"
                            }
                        }
                        
                        for dateStr in meetArray{
                            let str = dateStr as NSString
                            num = Int(str.substring(with: NSRange.init(location: 8, length: 2)))
                         //   DLog(num)
                            
                            if Int(dayView.dayLabel.text!) == num {
                                dayView.statuesLab.text = "会"
                            }
                        }
                        
                        for dateStr in outWorkArray{
                            let str = dateStr as NSString
                            num = Int(str.substring(with: NSRange.init(location: 8, length: 2)))
                        //    DLog(num)
                            
                            if Int(dayView.dayLabel.text!) == num {
                                dayView.statuesLab.text = "外"
                            }
                        }
                        
                        
                      
                        
                        for dateStr in travelArray{
                            let str = dateStr as NSString
                            num = Int(str.substring(with: NSRange.init(location: 8, length: 2)))
                        //    DLog(num)
                            
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
            param: ["userId":userID,
                    "loginUserId":self.curUserId,
                    "date":data],
            successCallBack: { (result) in
                if !result["data"]["isHaveAuthority"].boolValue{
                    self.workmateBtn.isHidden = true
                    self.BtnView.isHidden = true
                }else{
                    self.workmateBtn.isHidden = false
                    self.BtnView.isHidden = false
                }
//                self.workmateBtn.isHidden = false
//                self.BtnView.isHidden = false
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
                // self.scheduleArray.append(contentsOf: tempScheduleArray)
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
                           // DLog(num)
                            
                            if Int(dayView.dayLabel.text!) == num {
                                dayView.statuesLab.text = "假"
                            }
                        }
                        
                        for dateStr in meetArray{
                            let str = dateStr as NSString
                            num = Int(str.substring(with: NSRange.init(location: 8, length: 2)))
                         //   DLog(num)
                            
                            if Int(dayView.dayLabel.text!) == num {
                                dayView.statuesLab.text = "会"
                            }
                        }
                        
                        for dateStr in outWorkArray{
                            let str = dateStr as NSString
                            num = Int(str.substring(with: NSRange.init(location: 8, length: 2)))
                        //    DLog(num)
                            
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
                        //    DLog(num)
                            
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
extension CQScheduleVC: CVCalendarViewDelegate,CVCalendarMenuViewDelegate,CVCalendarViewAppearanceDelegate {
    
//    func dayLabelWeekdaySelectedTextColor() -> UIColor {
//        return  UIColor.white
//    }
//    func dayLabelPresentWeekdayTextColor() -> UIColor {
//        return  UIColor.black
//    }
    
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
        print("zaza" + dataStr)
        self.getSchedulePlanByMonthList(dataStr: dataStr)
        //        self.calendarView.commitCalendarViewUpdate()
        //        self.calendarView.contentController.refreshPresentedMonth()
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
//
//    func shouldSelectRange() -> Bool {
//        return true
//    }
//    //时间段选择完毕
//    func didSelectRange(from startDayView: DayView, to endDayView: DayView) {
//        // 创建一个日期格式器
//
//    }
//    func maxSelectableRange() -> Int {
//        return 1000
//    }
    //不显示当前选择月的日期
    func shouldShowWeekdaysOut() -> Bool {
        return false
    }
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .veryShort
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        
         return true
    }
    
    //日期使用格式
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {

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
        return  [kGoldYellowColor]//[kBlueC]//
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


extension CQScheduleVC:UIScrollViewDelegate{
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if 1001 == scrollView.tag {
            let index = scrollView.contentOffset.x / scrollView.frame.width
            btnClick(btn: btnArr[Int(index)])
            self.curIndex = Int(index)
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if 1000 == scrollView.tag  {
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
//        if 1000 == scrollView.tag  {
//          //  DLog(scrollView.contentOffset.y)
//            if scrollView.contentOffset.y > 0 {
//                UIView.animate(withDuration: 0.3, animations: {
//
//                }) { (finish:Bool) in
//                    if self.curIndex == 0 {
//                        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 139))
//                        self.calendarView.frame = CGRect(x:0, y:self.menuView.bottom + AutoGetHeight(height: 10), width:kWidth, height:AutoGetHeight(height: 60))
//                        self.table.frame = CGRect.init(x: 0, y: self.headView.bottom, width: kWidth, height: kHeight - self.headView.frame.size.height - AutoGetHeight(height: 65) - AutoGetHeight(height: 55) - SafeAreaBottomHeight)
//                        self.calendarView.changeMode(.weekView)
//                    }
//
//                }
//            }else if scrollView.contentOffset.y < 0{
//                UIView.animate(withDuration: 0.3, animations: {
//
//                }) { (finish:Bool) in
//                    if self.curIndex == 0 {
//                        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 329))
//                        self.calendarView.frame = CGRect(x:0, y:self.menuView.bottom + AutoGetHeight(height: 10), width:kWidth, height:AutoGetHeight(height: 240))
//                        self.table.frame = CGRect.init(x: 0, y: self.headView.bottom, width: kWidth, height: kHeight - self.headView.frame.size.height - AutoGetHeight(height: 65) - AutoGetHeight(height: 55) - SafeAreaBottomHeight)
//                        self.calendarView.changeMode(.monthView)
//
//                       //self.getSchedulePlanByMonthListRequest()
//                    }
//                }
//            }
//        }
//    }
}

// Mark:tableDelegate
extension CQScheduleVC:UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
}

extension CQScheduleVC:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //删除CQScheduleModel
        var id = ""
        if 0 == indexPath.section {
            id = self.morningData[indexPath.row].schedulePlanId
        }else{
            id = self.afternoonData[indexPath.row].schedulePlanId

        }

        self.loadDeleteScheduleRequest(scheduleId: id)
    }

    
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
extension CQScheduleVC:CQScheduleSelectDelegate{
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

extension CQScheduleVC:CQTaskSelectDelegate{
    func pushToDetailVC(personnelTaskId: String) {
        let vc = CQTaskDetailVC()
        vc.personnelTaskId = personnelTaskId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}



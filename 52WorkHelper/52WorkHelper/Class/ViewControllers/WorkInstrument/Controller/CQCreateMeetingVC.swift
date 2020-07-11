//
//  CQCreateMeetingVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/18.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

// 编辑日程类型枚举
enum EditMeetingType {
    case save
    case update
}


class CQCreateMeetingVC: SuperVC {
    var type:EditMeetingType?
    var rightItem:UIBarButtonItem?
    var bgView = UIButton()
    var timeString = ""
    var startTime = ""
    var endTime = ""
    var userArray = [CQDepartMentUserListModel]()
    var aletStr = ""
    var alertBgView = UIButton()
    var pickView:UIPickerView?
    var pickData = ["15分钟","30分钟","1小时","1天"]
    var userIdArr = [String]()
    var userNameArr = [String]()
    var schedulePlanId = ""
    var meetingRoomArray = [CQChooseRoomModel]()
    var roomModel:CQChooseRoomModel?
    var roomName = ""
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.backgroundColor = kProjectBgColor
        table.separatorStyle = .none
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight + AutoGetHeight(height: 110)))
        headView.backgroundColor = kProjectBgColor
        return headView
    }()
    
    lazy var titleView: UIView = {
        let titleView = UIView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 8), width: kWidth, height: AutoGetHeight(height: 55)))
        titleView.backgroundColor = UIColor.white
        return titleView
    }()
    
    lazy var titleLab: UILabel = {
        let titleLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: AutoGetWidth(width: 55), height: AutoGetHeight(height: 55)))
        titleLab.textColor = UIColor.black
        titleLab.text = "主题"
        titleLab.textAlignment = .left
        titleLab.font = kFontSize15
        return titleLab
    }()
    
    lazy var titleTextView: CBTextView = {
        let titleTextView = CBTextView.init(frame: CGRect.init(x: self.titleLab.right, y: AutoGetHeight(height: 10) , width: kWidth - kLeftDis - AutoGetWidth(width: 80), height: AutoGetHeight(height: 45)))
        titleTextView.aDelegate = self
        titleTextView.textView.backgroundColor = UIColor.white
        titleTextView.textView.font = UIFont.systemFont(ofSize: 15)
        titleTextView.textView.textColor = UIColor.black
        
        titleTextView.placeHolder = "请输入会议主题."
        titleTextView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        
        return titleTextView
    }()
    
    lazy var timeView: UIView = {
        let timeView = UIView.init(frame: CGRect.init(x: 0, y:self.titleView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 110)))
        timeView.backgroundColor = UIColor.white
        let line = UIView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 55) - 0.5, width: kWidth - kLeftDis, height: 0.5))
        line.backgroundColor = kLineColor
        timeView.addSubview(line)
        return timeView
    }()
    
    lazy var beginLab: UILabel = {
        let beginLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        beginLab.textColor = UIColor.black
        beginLab.text = "开始时间"
        beginLab.textAlignment = .left
        beginLab.font = kFontSize15
        return beginLab
    }()
    
    lazy var startChooseLab: UILabel = {
        let startChooseLab = UILabel.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 180), y: 0, width: AutoGetWidth(width: 150), height: AutoGetHeight(height: 55)))
        startChooseLab.textColor = kLyGrayColor
        startChooseLab.text = "请选择"
        startChooseLab.textAlignment = .right
        startChooseLab.font = kFontSize15
        return startChooseLab
    }()
    
    lazy var startArrow: UIImageView = {
        let startArrow = UIImageView.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 21.5), y: AutoGetHeight(height: 21.5), width: AutoGetWidth(width: 6.6), height: AutoGetHeight(height: 12)))
        startArrow.image = UIImage.init(named: "PersonAddressArrow")
        return startArrow
    }()
    
    lazy var startBtn: UIButton = {
        let startBtn = UIButton.init(type: .custom)
        startBtn.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 55))
        startBtn.addTarget(self, action: #selector(timeChoose(btn:)), for: .touchUpInside)
        startBtn.tag = 600
        return startBtn
    }()
    
    lazy var endLab: UILabel = {
        let endLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.beginLab.bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        endLab.textColor = UIColor.black
        endLab.text = "结束时间"
        endLab.textAlignment = .left
        endLab.font = kFontSize15
        return endLab
    }()
    
    lazy var endChooseLab: UILabel = {
        let endChooseLab = UILabel.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 180), y: self.beginLab.bottom, width: AutoGetWidth(width: 150), height: AutoGetHeight(height: 55)))
        endChooseLab.textColor = kLyGrayColor
        endChooseLab.text = "请选择"
        endChooseLab.textAlignment = .right
        endChooseLab.font = kFontSize15
        return endChooseLab
    }()
    
    lazy var endArrow: UIImageView = {
        let endArrow = UIImageView.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 21.5), y: self.beginLab.bottom + AutoGetHeight(height: 21.5), width: AutoGetWidth(width: 6.6), height: AutoGetHeight(height: 12)))
        endArrow.image = UIImage.init(named: "PersonAddressArrow")
        return endArrow
    }()
    
    lazy var endBtn: UIButton = {
        let endBtn = UIButton.init(type: .custom)
        endBtn.frame = CGRect.init(x: 0, y: self.startBtn.bottom, width: kWidth, height: AutoGetHeight(height: 55))
        endBtn.addTarget(self, action: #selector(timeChoose(btn:)), for: .touchUpInside)
        endBtn.tag = 601
        return endBtn
    }()
    
    lazy var meetingView: UIView = {
        let meetingView = UIView.init(frame: CGRect.init(x: 0, y:self.timeView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 240)))
        meetingView.backgroundColor = UIColor.white
        let line = UIView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 55) - 0.5, width: kWidth - kLeftDis, height: 0.5))
        line.backgroundColor = kLineColor
        meetingView.addSubview(line)
        
        let line1 = UIView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 110) - 0.5, width: kWidth - kLeftDis, height: 0.5))
        line1.backgroundColor = kLineColor
        meetingView.addSubview(line1)
        return meetingView
    }()
    
    lazy var chooseRoomLab: UILabel = {
        let chooseRoomLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        chooseRoomLab.textColor = UIColor.black
        chooseRoomLab.text = "选择会议室"
        chooseRoomLab.textAlignment = .left
        chooseRoomLab.font = kFontSize15
        return chooseRoomLab
    }()
    
    lazy var chooseRoomSelectLab: UILabel = {
        let chooseRoomSelectLab = UILabel.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 180), y: 0, width: AutoGetWidth(width: 150), height: AutoGetHeight(height: 55)))
        chooseRoomSelectLab.textColor = kLyGrayColor
        chooseRoomSelectLab.text = "请选择"
        chooseRoomSelectLab.textAlignment = .right
        chooseRoomSelectLab.font = kFontSize15
        return chooseRoomSelectLab
    }()
    
    lazy var chooseArrow: UIImageView = {
        let chooseArrow = UIImageView.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 21.5), y:  AutoGetHeight(height: 21.5), width: AutoGetWidth(width: 6.6), height: AutoGetHeight(height: 12)))
        chooseArrow.image = UIImage.init(named: "PersonAddressArrow")
        return chooseArrow
    }()
    
    lazy var chooseRoomBtn: UIButton = {
        let chooseRoomBtn = UIButton.init(type: .custom)
        chooseRoomBtn.frame = CGRect.init(x: 0, y: 0 , width: kWidth, height: AutoGetHeight(height: 55))
        chooseRoomBtn.addTarget(self, action: #selector(roomChoose), for: .touchUpInside)
        chooseRoomBtn.tag = 602
        return chooseRoomBtn
    }()
    
    lazy var masterLab: UILabel = {
        let masterLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.chooseRoomLab.bottom, width: AutoGetWidth(width: 65), height: AutoGetHeight(height: 55)))
        masterLab.textColor = UIColor.black
        masterLab.text = "主持人"
        masterLab.textAlignment = .left
        masterLab.font = kFontSize15
        return masterLab
    }()
    
    lazy var masterField: MyTextField = {
        let masterField = MyTextField.init(frame: CGRect.init(x: self.masterLab.right, y: self.chooseRoomLab.bottom , width: kWidth - kLeftDis - AutoGetWidth(width: 80), height: AutoGetHeight(height: 55)))
        masterField?.delegate = self
        masterField?.clearButtonMode = .never
        masterField?.keyBoardDelegate = self
        masterField?.font = kFontSize15
        masterField?.textColor = UIColor.black
        masterField?.tintColor = UIColor.black
        masterField?.placeholder = "请填写主持人"
        masterField?.keyboardType = .default
        
        return masterField!
    }()
    
    lazy var contentLab: UILabel = {
        let contentLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.masterLab.bottom + AutoGetHeight(height: 18), width: AutoGetWidth(width: 120), height: AutoGetHeight(height: 15)))
        contentLab.textColor = UIColor.black
        contentLab.text = "会议内容"
        contentLab.textAlignment = .left
        contentLab.font = kFontSize15
        return contentLab
    }()
    
    lazy var textView: CBTextView = {
        let textView = CBTextView.init(frame: CGRect.init(x: AutoGetWidth(width: 15), y:self.contentLab.bottom + AutoGetWidth(width: 13), width: kWidth - AutoGetWidth(width: 30), height: AutoGetHeight(height: 71)))
        textView.aDelegate = self
        textView.textView.backgroundColor = UIColor.white
        textView.textView.font = UIFont.systemFont(ofSize: 15)
        textView.textView.textColor = UIColor.black
        
        textView.placeHolder = "请输入会议内容."
        textView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        
        return textView
    }()
    
    lazy var attendPersonView: UIView = {
        let attendPersonView = UIView.init(frame: CGRect.init(x: 0, y:self.meetingView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 145)))
        attendPersonView.backgroundColor = UIColor.white
        return attendPersonView
    }()
    
    lazy var attendPersonLab: UILabel = {
        let attendPersonLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 18), width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 15)))
        attendPersonLab.textColor = UIColor.black
        attendPersonLab.text = "参与人员"
        attendPersonLab.textAlignment = .left
        attendPersonLab.font = kFontSize15
        return attendPersonLab
    }()
    
    lazy var collectionView: UICollectionView = {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width: kHaveLeftWidth/4, height: AutoGetHeight(height: 75))
        layOut.minimumLineSpacing = 0
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        //        layOut.headerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 38))
        //        layOut.footerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 11))
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: kLeftDis, y: self.attendPersonLab.bottom + AutoGetHeight(height: 14), width: kHaveLeftWidth, height: AutoGetHeight(height: 84)), collectionViewLayout: layOut)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(CQWriteReportCell.self, forCellWithReuseIdentifier: "CQWriteReportCellId")
        return collectionView
    }()
    
    lazy var alertV: UIView = {
        let alertV = UIView.init(frame: CGRect.init(x: 0, y:self.attendPersonView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 55)))
        alertV.backgroundColor = UIColor.white
        return alertV
    }()
    
    lazy var alertLab: UILabel = {
        let alertLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: AutoGetWidth(width: 55), height: AutoGetHeight(height: 55)))
        alertLab.textColor = UIColor.black
        alertLab.text = "提醒"
        alertLab.textAlignment = .left
        alertLab.font = kFontSize15
        return alertLab
    }()
    
    lazy var earlyChooseLab: UILabel = {
        let earlyChooseLab = UILabel.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 180), y: 0, width: AutoGetWidth(width: 150), height: AutoGetHeight(height: 55)))
        earlyChooseLab.textColor = kLyGrayColor
        earlyChooseLab.text = "请选择提醒时间"
        earlyChooseLab.textAlignment = .right
        earlyChooseLab.font = kFontSize15
        return earlyChooseLab
    }()
    
    lazy var earlyArrow: UIImageView = {
        let earlyArrow = UIImageView.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 21.5), y: AutoGetHeight(height: 21.5), width: AutoGetWidth(width: 6.6), height: AutoGetHeight(height: 12)))
        earlyArrow.image = UIImage.init(named: "PersonAddressArrow")
        return earlyArrow
    }()
    
    lazy var earlyBtn: UIButton = {
        let endBtn = UIButton.init(type: .custom)
        endBtn.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 55))
        endBtn.addTarget(self, action: #selector(earlyChoose), for: .touchUpInside)
        return endBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        if self.type == .update {
             self.title = "编辑会议"
            self.initView()
            self.loadData()
        }else{
             self.title = "新建会议"
            self.initView()
        }
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        rightBtn.setTitle("完成", for: .normal)
        rightBtn.sizeToFit()
        rightBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        rightBtn.setTitleColor(UIColor.colorWithHexString(hex: "#20afff"), for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        rightBtn.addTarget(self, action: #selector(storeClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        let NotifMycation = NSNotification.Name(rawValue:"refreshReportCell")
        NotificationCenter.default.addObserver(self, selector: #selector(upDataChange(notif:)), name: NotifMycation, object: nil)
    }
    
    func initView()  {
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.titleView)
        self.titleView.addSubview(self.titleLab)
        self.titleView.addSubview(self.titleTextView)
        self.headView.addSubview(self.timeView)
        self.timeView.addSubview(self.beginLab)
        self.timeView.addSubview(self.startChooseLab)
        self.timeView.addSubview(self.startArrow)
        self.timeView.addSubview(self.endLab)
        self.timeView.addSubview(self.endChooseLab)
        self.timeView.addSubview(self.endArrow)
        self.timeView.addSubview(self.startBtn)
        self.timeView.addSubview(self.endBtn)
        self.headView.addSubview(self.meetingView)
        self.meetingView.addSubview(self.chooseRoomLab)
        self.meetingView.addSubview(self.chooseRoomSelectLab)
        self.meetingView.addSubview(self.chooseArrow)
        self.meetingView.addSubview(self.chooseRoomBtn)
        self.meetingView.addSubview(self.masterLab)
        self.meetingView.addSubview(self.masterField)
        self.meetingView.addSubview(self.contentLab)
        self.meetingView.addSubview(self.textView)
        self.headView.addSubview(self.attendPersonView)
        self.attendPersonView.addSubview(self.attendPersonLab)
        self.attendPersonView.addSubview(self.collectionView)
        self.headView.addSubview(self.alertV)
        self.alertV.addSubview(self.alertLab)
        self.alertV.addSubview(self.earlyChooseLab)
        self.alertV.addSubview(self.earlyArrow)
        self.alertV.addSubview(self.earlyBtn)
        
        NotificationCenter.default.addObserver(self, selector: #selector(upDataChange(notif:)), name: NSNotification.Name.init("refreshCreateMeetingCell"), object: nil)
       // NotificationCenter.default.addObserver(self, selector: #selector(upDataChange(notif:)), name: NSNotification.Name.init("AddTracker"), object: nil)
        
    }
    
    @objc func storeClick()  {
        var planContent = self.textView.textView.text
        if planContent == self.textView.placeHolder {
            planContent = ""
        }
        var titleContent = self.titleTextView.textView.text
        if titleContent == self.titleTextView.placeHolder {
            titleContent = ""
        }
        if (titleContent?.count)!>0 && self.aletStr.count > 0 && self.startTime.count > 0 && self.endTime.count > 0 && self.chooseRoomSelectLab.text != "请选择" &&  (planContent?.count)! > 0 && (self.masterField.text?.count)! > 0 {
            self.loadingPlay()
            self.editScheduleRequest()
        }else{
            if (titleContent?.isEmpty)! {
                SVProgressHUD.showInfo(withStatus: "请输入会议主题")
            }else if self.startTime.isEmpty {
                SVProgressHUD.showInfo(withStatus: "请选择会议开始时间")
            }else if self.endTime.isEmpty {
                SVProgressHUD.showInfo(withStatus: "请选择会议结束时间")
            }else if (self.chooseRoomSelectLab.text == "请选择") {
                SVProgressHUD.showInfo(withStatus: "请选择会议室")
            }else if (self.masterField.text?.isEmpty)!{
                SVProgressHUD.showInfo(withStatus: "请输入会议主持人")
            }else if (planContent?.isEmpty)! {
                SVProgressHUD.showInfo(withStatus: "请输入会议内容")
            }else if self.aletStr.isEmpty {
                SVProgressHUD.showInfo(withStatus: "请选择提醒时间")
            }
        }
        
    }
    
    deinit {
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    //接收到后执行的方法
    @objc func upDataChange(notif: NSNotification) {
        
        guard let arr: [CQDepartMentUserListModel] = notif.object as! [CQDepartMentUserListModel]? else { return }
        
        self.userIdArr.removeAll()
        self.userNameArr.removeAll()
        self.userArray.removeAll()
        
        for i in 0..<arr.count {
            self.userIdArr.append(arr[i].userId)
            self.userNameArr.append(arr[i].realName)
            self.userArray.append(arr[i])
        }
        
        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
        self.table.tableHeaderView = self.headView
        self.attendPersonView.frame = CGRect.init(x: 0, y:self.meetingView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 70) + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
        self.collectionView.frame = CGRect.init(x: kLeftDis, y: self.attendPersonLab.bottom + AutoGetHeight(height: 14), width: kHaveLeftWidth, height: AutoGetHeight(height: 14) + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
        self.alertV.frame =  CGRect.init(x: 0, y:self.attendPersonView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 55))
        self.collectionView.reloadData()
    }
    
    @objc func timeChoose(btn:UIButton)  {
        let tag = btn.tag - 600
        self.view.endEditing(true)
        bgView.frame = CGRect(x: 0, y: SafeAreaTopHeight, width: kWidth, height: kHeight - SafeAreaTopHeight-SafeAreaBottomHeight)
        bgView.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
        self.view.addSubview(bgView)
        bgView.addTarget(self, action: #selector(removeBgView), for: .touchUpInside)
        
        let pickBg = UIView.init(frame: CGRect.init(x: 0, y:bgView.frame.size.height - 40 - 200 , width: kWidth, height: 240))
        pickBg.backgroundColor = UIColor.white
        bgView.addSubview(pickBg)
        
        let sureBtn = UIButton()
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(.black, for: .normal)
        sureBtn.frame = CGRect(x: kWidth - 60, y: 0, width: 60, height: 40)
        sureBtn.tag = 700 + tag
        pickBg.addSubview(sureBtn)
        sureBtn.addTarget(self, action: #selector(sureClick(btn:)), for: .touchUpInside)
        
        let cancelBtn = UIButton()
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(.black, for: .normal)
        cancelBtn.frame = CGRect(x: 0, y:0, width: 60, height: 40)
        pickBg.addSubview(cancelBtn)
        cancelBtn.addTarget(self, action: #selector(removeBgView(sender:)), for: .touchUpInside)
        
        //创建日期选择器
        let datePicker = UIDatePicker(frame: CGRect(x:0, y:40, width:kWidth, height:200))
        //将日期选择器区域设置为中文，则选择器日期显示为中文
        datePicker.locale = Locale(identifier: "zh_CN")
        datePicker.datePickerMode = .dateAndTime
        datePicker.backgroundColor = .white
        //注意：action里面的方法名后面需要加个冒号“：”
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        pickBg.addSubview(datePicker)
        
        let whiteV = UIView(frame:  CGRect(x: 0, y: datePicker.bottom, width: kWidth, height: SafeAreaBottomHeight))
        whiteV.backgroundColor = UIColor.white
        pickBg.addSubview(whiteV)
    }
    
    @objc func sureClick(btn:UIButton) {
        if btn.tag == 700 {
            startTime = timeString
            if startTime.isEmpty{
                let now = Date()
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
                self.startTime = dateFormat.string(from: now)
            }
            self.startChooseLab.text = startTime
        }else if btn.tag == 701 {
            endTime = timeString
            if endTime.isEmpty{
                let now = Date()
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
                self.endTime = dateFormat.string(from: now)
            }
            self.endChooseLab.text = endTime
        }
        self.bgView.removeAllSubviews()
        self.bgView.removeFromSuperview()
    }
    
    //日期选择器响应方法
    @objc func dateChanged(datePicker : UIDatePicker){
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        timeString = formatter.string(from: datePicker.date)
    }
    
    @objc func removeBgView(sender: UIButton) {
        self.bgView.removeAllSubviews()
        self.bgView.removeFromSuperview()
    }
    
    @objc func roomChoose()  {
        if self.startTime.isEmpty {
            SVProgressHUD.showInfo(withStatus: "请选择开始时间")
            return
        }else if self.endTime.isEmpty {
            SVProgressHUD.showInfo(withStatus: "请选择结束时间")
            return
        }
        let vc = CQChooseRoomVC()
        vc.startDate = self.startTime
        vc.endDate = self.endTime
        vc.selectDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func earlyChoose()  {
        self.initPick()
    }
}


// Mark :编辑会议室请求
extension CQCreateMeetingVC{
    func editScheduleRequest()  {
        let userID = STUserTool.account().userID
        var opt = ""
        if type == .save {
            opt = "save"
        }else if type == .update{
            opt = "update"
            for model in self.userArray{
                self.userIdArr.append(model.userId)
            }
        }
        
        STNetworkTools.requestData(URLString: "\(baseUrl)/schedule/saveOrUpdateSchedulePlan",
            type: .post,
            param: ["userId":userID,
                    "alertLimit":self.aletStr,
                    "userIds":self.userIdArr,
                    "endDate":endTime,
                    "planContent":self.textView.textView.text ?? "",
                    "planTitle":self.titleTextView.prevText ?? "",
                    "startDate":startTime,
                    "operateMode":opt,
                    "schedulePlanId":self.schedulePlanId,
                    "planType":"2",
                    "hostUser":self.masterField.text ?? "",
                    "meetingRoomId":self.roomModel?.meetingRoomId ?? 0],
            successCallBack: { (result) in
                self.loadingSuccess()
                SVProgressHUD.showInfo(withStatus: "添加成功")
                //刷新日程首页
                NotificationCenter.default.post(name: NSNotification.Name.init("refreshScheduleUI"), object: nil)
                self.navigationController?.popViewController(animated: true)
        }) { (error) in
            self.loadingSuccess()
        }
    }
    
    func loadData() {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/schedule/getSchedulePlanDetails" ,
            type: .get,
            param: ["schedulePlanId":self.schedulePlanId,
                    "userId":userID],
            successCallBack: { (result) in
                guard let model = CQScheduleModel.init(jsonData: result["data"]) else {
                    return
                }
                self.titleTextView.prevText = model.planTitle
            
                //日期样式
                let startStr:NSString = model.startDate as NSString
                let st = startStr.substring(with: NSRange.init(location: 11, length: 5))
                self.startChooseLab.text = st
                let endStr:NSString = model.endDate as NSString
                let et = endStr.substring(with: NSRange.init(location: 11, length: 5))
                self.endChooseLab.text = et
                self.chooseRoomSelectLab.text = model.meetingRoomName
                self.masterField.text = model.hostUser
                self.textView.prevText = model.planContent
                
                var arr = [CQDepartMentUserListModel]()
                
                self.userArray.removeAll()
                
                for modalJson in result["data"]["userData"].arrayValue  {
                    guard let modal = CQDepartMentUserListModel(jsonData: JSON(modalJson)) else {
                        return
                    }
                    DLog(modal)
                    arr.append(modal)
                }
                
                self.userArray = arr
                
                self.earlyChooseLab.text = "提前15分钟提醒"
                self.collectionView.reloadData()
                self.table.reloadData()
                
        }) { (error) in
            
        }
    }
}



extension CQCreateMeetingVC:UITextFieldDelegate,KeyBoardDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if self.isInputRuleNotBlank(str: string) || string == ""{
            return true
        }else{
            SVProgressHUD.showInfo(withStatus: "不支持emoji表情")
            return false
        }
    }
    
    func isInputRuleNotBlank(str:String)->Bool{
        let pattern = "^[a-zA-Z\\u4E00-\\u9FA5\\d]*$"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch = pred.evaluate(with: str)
        if !isMatch{
            let other = "➋➌➍➎➏➐➑➒"
            let len = str.count
            for i in 0..<len{
                let tmpStr = str as NSString
                let tmpOther = other as NSString
                let c = tmpStr.character(at: i)
                
                if !((isalpha(Int32(c))) > 0 || (isalnum(Int32(c))) > 0 || ((Int(c) == "_".hashValue)) || (Int(c) == "-".hashValue) || ((c >= 0x4e00 && c <= 0x9fa6)) || (tmpOther.range(of: str).location != NSNotFound)) {
                    return false
                }
                return true
            }
        }
        return isMatch
    }
    
    func isInputRuleAndBlank(str:String)->Bool{
        let pattern = "^[a-zA-Z\\u4E00-\\u9FA5\\d\\s]*$"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch = pred.evaluate(with: str)
        return isMatch
    }
    
    func disable_emoji(str:String)->String{
        let regex = try!NSRegularExpression.init(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]", options: .caseInsensitive)
        
        let modifiedString = regex.stringByReplacingMatches(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange.init(location: 0, length: str.count), withTemplate: "")
        return modifiedString
    }
    
    
    
    func getSubString(str:String) -> String{
        if str.count>120{
            SVProgressHUD.showInfo(withStatus: "最多输入120个字")
//            return str[0..<(120)]
            return (str as NSString).substring(with: NSRange.init(location: 0, length: 120))
        }
        return str
    }
    
    @objc func textFieldEditChanged(obj:Notification)  {
        
    }
    
}

extension CQCreateMeetingVC:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
}

// MARK: - 代理

extension CQCreateMeetingVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userArray.count + 1
    }
    
}

extension CQCreateMeetingVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQWriteReportCellId", for: indexPath) as! CQWriteReportCell
        if self.userArray.count == 0 {
            if indexPath.row == 0{
                cell.img.image = UIImage.init(named: "CQAddMenberIcon")
                cell.nameLab.text = ""
                cell.deleteBtn.isHidden = true
            }
        }else {
            if indexPath.row == self.userArray.count {
                cell.img.image = UIImage.init(named: "CQAddMenberIcon")
                cell.nameLab.text = ""
                cell.deleteBtn.isHidden = true
            }else {
                cell.img.sd_setImage(with: URL(string: self.userArray[indexPath.row].headImage ), placeholderImage:UIImage.init(named: "personDefaultIcon") )
                cell.nameLab.text = self.userArray[indexPath.row].realName
                cell.deleteBtn.isHidden = false
                cell.deleteDelegate = self
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.userArray.count == 0 {
            if indexPath.row == 0 {
                let vc = AddressBookVC.init()
                vc.toType = .fromCreatMeeting
                vc.hasSelectModelArr = self.userArray
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            if indexPath.row == self.userArray.count{
                let vc = AddressBookVC.init()
                vc.toType = .fromCreatMeeting
                vc.hasSelectModelArr = self.userArray
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                
            }
        }
        
    }
}

extension CQCreateMeetingVC{
    func initPick() {
        
        
        self.view.endEditing(true)
        alertBgView.frame = CGRect(x: 0, y: 64, width: kWidth, height: kHeight - 64)
        alertBgView.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
        self.view.addSubview(alertBgView)
        alertBgView.addTarget(self, action: #selector(removeAlertBgView), for: .touchUpInside)
        
        let pickBg = UIView.init(frame: CGRect.init(x: 0, y:alertBgView.frame.size.height - AutoGetHeight(height: 240) , width: kWidth, height: AutoGetHeight(height: 240)))
        pickBg.backgroundColor = UIColor.white
        alertBgView.addSubview(pickBg)
        
        let sureBtn = UIButton()
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(.black, for: .normal)
        sureBtn.frame = CGRect(x: kWidth - 60, y: 0, width: 60, height: AutoGetHeight(height: 40))
        pickBg.addSubview(sureBtn)
        sureBtn.addTarget(self, action: #selector(chooseAlertTime), for: .touchUpInside)
        
        let cancelBtn = UIButton()
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(.black, for: .normal)
        cancelBtn.frame = CGRect(x: 0, y: 0, width: 60, height: AutoGetHeight(height: 40))
        cancelBtn.addTarget(self, action: #selector(removeAlertBgView(sender:)), for: .touchUpInside)
        pickBg.addSubview(cancelBtn)
        
        self.pickView = UIPickerView.init(frame: CGRect.init(x: 0, y:  AutoGetHeight(height: 40), width: kWidth, height: AutoGetHeight(height: 200)))
        pickView?.delegate = self
        pickView?.dataSource = self
        pickView?.selectedRow(inComponent: 0)
        
        pickBg.addSubview(pickView!)
    }
    
    @objc func chooseAlertTime()  {
        let message = self.pickData[(pickView?.selectedRow(inComponent: 0))!]
        DLog(message)
        self.earlyChooseLab.text = "提前" + message + "提醒"
        self.earlyChooseLab.font = kFontBoldSize15
        if message == "15分钟"{
            self.aletStr = "15"
        }else if message == "30分钟"{
            self.aletStr = "30"
        }else if message == "1小时"{
            self.aletStr = "60"
        }else if message == "1天"{
            self.aletStr = "1440"
        }
        self.alertBgView.removeAllSubviews()
        self.alertBgView.removeFromSuperview()
        
    }
    
    @objc func removeAlertBgView(sender: UIButton) {
        self.alertBgView.removeAllSubviews()
        self.alertBgView.removeFromSuperview()
    }
    
}

extension CQCreateMeetingVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return kWidth
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return AutoGetHeight(height: 40)
    }
    
}

extension CQCreateMeetingVC:CQSelectDeleteDelegate{
    func deleteCollectionCell(index: IndexPath) {
        self.userIdArr.remove(at:index.item)
        self.userArray.remove(at: index.item)
        
        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
        self.table.tableHeaderView = self.headView
        self.attendPersonView.frame = CGRect.init(x: 0, y:self.meetingView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 70) + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
        self.collectionView.frame = CGRect.init(x: kLeftDis, y: self.attendPersonLab.bottom + AutoGetHeight(height: 14), width: kHaveLeftWidth, height: AutoGetHeight(height: 14) + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
        self.alertV.frame =  CGRect.init(x: 0, y:self.attendPersonView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 55))
        self.collectionView.reloadData()
    }
}

extension CQCreateMeetingVC:CQRoomSelectDelegate{
    func selectRoom(model: CQChooseRoomModel) {
        self.roomModel = model
        self.roomName = model.roomName
        self.chooseRoomSelectLab.text = model.roomName
    }
    
    func selectCar(model: CQCarsModel) {
        
    }
}

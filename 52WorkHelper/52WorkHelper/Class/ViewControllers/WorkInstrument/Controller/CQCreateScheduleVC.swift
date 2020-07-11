//
//  CQCreateScheduleVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/10.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

// 编辑日程类型枚举
enum EditScheduleType {
    case save
    case update
}

class CQCreateScheduleVC: SuperVC {
    var timeString = ""
    var pickView:UIPickerView?
    //相册附件图片
    var photoArray = [UIImage]()
    var photoTempArray = [UIImage]()
    var photoStrArray = [String]()
    var delelteArray = [String]()
    
    var bgView = UIButton()
    var type:EditScheduleType?
    var schedulePlanId = ""
    var startTime = ""
    var endTime = ""
    var isOtherDay = false
    var currentTime = ""
    var pickData = ["15分钟","30分钟","1小时","1天"]
    var rightItem:UIBarButtonItem?
    var userArray = [CQDepartMentUserListModel]()
    var userIdArr = [String]()
    var userNameArr = [String]()
    var aletStr = "15"
    var alertBgView = UIButton()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.backgroundColor = kProjectBgColor
        table.separatorStyle = .none
        table.canCancelContentTouches = false
        table.delaysContentTouches = true
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight + AutoGetHeight(height: 80)))
        headView.backgroundColor = kProjectBgColor
        return headView
    }()
    
    lazy var titleView: UIView = {
        let titleView = UIView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 8), width: kWidth, height: AutoGetHeight(height: 55)+50))
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
        let titleTextView = CBTextView.init(frame:  CGRect.init(x: self.titleLab.right, y: AutoGetHeight(height: 10) , width: kWidth - kLeftDis - AutoGetWidth(width: 80), height: AutoGetHeight(height: 45)))
        titleTextView.aDelegate = self
        titleTextView.textView.backgroundColor = UIColor.white
        titleTextView.textView.font = UIFont.systemFont(ofSize: 15)
        titleTextView.textView.textColor = UIColor.black
        
        titleTextView.placeHolder = "请输入日程主题"
        titleTextView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        
        return titleTextView
    }()
    
    lazy var historyView: QRSearchHistoryView = {
        let historyView = QRSearchHistoryView.creatSearchHistoryView()
        historyView.frame =  CGRect(x: 0, y: titleLab.bottom, width: kWidth, height: 50)
        historyView.reloadView()
        historyView.clickClosure = {[unowned self] keyword in
            self.titleTextView.textView.text = keyword
            self.titleTextView.prevText = keyword
        }
        return historyView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView.init(frame: CGRect.init(x: 0, y:self.titleView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 185)+(kHaveLeftWidth-AutoGetWidth(width: 30))/4 + AutoGetHeight(height: 14)))
        contentView.backgroundColor = UIColor.white
        let line = UIView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 55) + 0.5, width: kWidth - kLeftDis, height: 0.5))
        line.backgroundColor = kLineColor
        contentView.addSubview(line)
        return contentView
    }()
    
    lazy var addressLab: UILabel = {
        let addressLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: AutoGetWidth(width: 55), height: AutoGetHeight(height: 55)))
        addressLab.textColor = UIColor.black
        addressLab.text = "地址"
        addressLab.textAlignment = .left
        addressLab.font = kFontSize15
        return addressLab
    }()
    
  
    
    lazy var addressTextView: CBTextView = {
        let addressTextView = CBTextView.init(frame:CGRect.init(x: self.addressLab.right, y: AutoGetHeight(height: 10) , width: kWidth - kLeftDis - AutoGetWidth(width: 80), height: AutoGetHeight(height: 45)))
        addressTextView.aDelegate = self
        addressTextView.textView.backgroundColor = UIColor.white
        addressTextView.textView.font = UIFont.systemFont(ofSize: 15)
        addressTextView.textView.textColor = UIColor.black
        
        addressTextView.placeHolder = "请输入地址"
        addressTextView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        
        return addressTextView
    }()
    
    
    lazy var contentLab: UILabel = {
        let contentLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.addressLab.bottom + AutoGetHeight(height: 14), width: AutoGetWidth(width: 120), height: AutoGetHeight(height: 15)))
        contentLab.textColor = UIColor.black
        contentLab.text = "日程内容"
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
        
        textView.placeHolder = "请输入日程内容."
        textView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        
        return textView
    }()
    
    lazy var addScheduleView : QRAddScheduleView = {
           let addSchedule = QRAddScheduleView(frame:  CGRect(x: 0, y: self.contentView.bottom, width: kWidth, height: 100))
              addSchedule.isAdd = true
              return addSchedule
          }()
       
    
    lazy var scheduleCollectionView: UICollectionView = {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width: (kHaveLeftWidth-AutoGetWidth(width: 30))/4, height: (kHaveLeftWidth-AutoGetWidth(width: 30))/4)
        layOut.minimumLineSpacing = 10
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        layOut.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15)
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: self.addScheduleView.bottom, width: kWidth, height: (kHaveLeftWidth-AutoGetWidth(width: 30))/4 + 20), collectionViewLayout: layOut)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.tag = 801
        collectionView.register(CQCirclePublishCell.self, forCellWithReuseIdentifier: "CQCirclePublishCellId")
        
        let lineView = UIView(frame:  CGRect(x: 0, y: (kHaveLeftWidth-AutoGetWidth(width: 30))/4 + 10, width: kHaveLeftWidth, height: 1))
        lineView.backgroundColor = kProjectBgColor
        collectionView.addSubview(lineView)
    
        return collectionView
    }()
    
    
    
   
    
    lazy var recoredTableView : QRRecordTableView = {
        let recordTab = Bundle.main.loadNibNamed("QRRecordTableView", owner: nil, options: nil)?.last as! QRRecordTableView
        recordTab.frame =  CGRect(x: 0, y: self.scheduleCollectionView.bottom, width: kWidth, height:54)
        recordTab.isEdite = true
        return recordTab
    }()
    
    
    lazy var timeView: UIView = {
        let timeView = UIView.init(frame: CGRect.init(x: 0, y:self.recoredTableView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 110)))
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
        startBtn.addTarget(self, action: #selector(selelctStartTime), for: .touchUpInside)
        //timeChoose(btn:)
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
        endBtn.addTarget(self, action: #selector(selelctEndTime), for: .touchUpInside)
//        timeChoose(btn:)
        endBtn.tag = 601
        return endBtn
    }()
    
    lazy var attendPersonView: UIView = {
        let attendPersonView = UIView.init(frame: CGRect.init(x: 0, y:self.timeView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 145)))
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
        earlyChooseLab.text = "提前15分钟提醒"
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
        LGSoundRecorder.shareInstance()?.removeFile()
       // checkMicAuthen()
        
        if self.type == .update {
            self.initView()
            self.loadData()
            self.title = "编辑日程"
            
        }else{
            self.initView()
            self.title = "新建日程"
            headView.frame =  CGRect(x: 0, y: 0, width: kWidth, height: self.alertV.bottom+30)
            self.table.tableHeaderView = headView
            
        //日期样式
            
            if isOtherDay{
                let dateFormat = DateFormatter()
               dateFormat.dateFormat = "yyyy-MM-dd "
               let startTimeStr = currentTime + " 08:30"
               self.startChooseLab.text = startTimeStr
               self.startTime = startTimeStr
               let endTimeStr = currentTime + " 18:00"
               self.endChooseLab.text = endTimeStr
               self.endTime = endTimeStr
            }else{
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd "
                let startTimeStr = dateFormat.string(from: Date())+"08:30"
                self.startChooseLab.text = startTimeStr
                self.startTime = startTimeStr
                let endTimeStr = dateFormat.string(from: Date())+"18:00"
                self.endChooseLab.text = endTimeStr
                self.endTime = endTimeStr
            }
            
            
            self.startChooseLab.font = kFontSize15
            self.startChooseLab.textColor = UIColor.black
            self.endChooseLab.font = kFontSize15
            self.endChooseLab.textColor = UIColor.black
            
            
        }
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        rightBtn.titleLabel?.font = kFontSize17
        rightBtn.setTitle("完成", for: .normal)
        rightBtn.sizeToFit()
        rightBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        rightBtn.setTitleColor(kBlueColor, for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        rightBtn.addTarget(self, action: #selector(storeClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        let NotifMycation = NSNotification.Name(rawValue:"refreshReportCell")
        NotificationCenter.default.addObserver(self, selector: #selector(upDataChange(notif:)), name: NotifMycation, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEditChanged(obj:)), name: Notification.Name.UITextViewTextDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(upDataChange(notif:)), name: NSNotification.Name.init("refreshCreateScheduleCell"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(upDataChange(notif:)), name: NSNotification.Name.init("FAddTracker"), object: nil)
        
        //更新高度frame
        NotificationCenter.default.addObserver(self, selector: #selector(upDataHeight(notif:)), name: NSNotification.Name.init("updateScheduleSoundHeight"), object: nil)
       
        NotificationCenter.default.addObserver(self, selector: #selector(updateHistoryHeight(notif:)), name: NSNotification.Name.init("updateHistoryHeight"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateScheduleHeight(notif:)), name: NSNotification.Name.init("scheduleUpdateHeight"), object: nil)
    }
    @objc func updateHistoryHeight(notif:Notification){
        let hisHeight = notif.userInfo!["height"] as! CGFloat
        self.historyView.frame = CGRect(x: 0, y: titleLab.bottom, width: kWidth, height: hisHeight)
        self.titleView.frame =  CGRect(x: 0, y: AutoGetHeight(height: 8), width: kWidth, height:self.historyView.bottom )
        self.contentView.frame =  CGRect(x: 0, y:  self.titleView.bottom+10, width: kWidth, height: self.scheduleCollectionView.bottom)
        let height = CGFloat(AutoGetHeight(height: 55)*CGFloat(recoredTableView.dataArr.count)) + 54
        self.recoredTableView.frame =  CGRect(x: 0, y: contentView.bottom, width: kWidth, height: height)
        self.timeView.frame =  CGRect(x: 0, y: recoredTableView.bottom+14, width: kWidth, height: self.endBtn.bottom)
        self.attendPersonView.frame =  CGRect(x: 0, y: timeView.bottom+14, width: kWidth, height: self.collectionView.bottom)
        self.alertV.frame =  CGRect(x: 0, y: attendPersonView.bottom+14, width: kWidth, height: self.earlyBtn.bottom)
        self.headView.frame =  CGRect(x: 0, y: 0, width: kWidth, height: self.alertV.bottom+20)
        self.table.tableHeaderView = headView
    }
    
    @objc func updateScheduleHeight(notif: NSNotification) {
          
          let scheduleHeight = notif.userInfo!["height"] as! CGFloat
          self.contentView.frame =  CGRect(x: 0, y:  self.titleView.bottom+10, width: kWidth, height: self.contentLab.bottom)
          
          self.addScheduleView.frame =  CGRect(x: 0, y:  self.contentView.bottom, width: kWidth, height: scheduleHeight)
          self.scheduleCollectionView.frame =  CGRect(x: 0, y: self.addScheduleView.bottom, width: kWidth, height: self.scheduleCollectionView.height)
            
          let height = CGFloat(AutoGetHeight(height: 55)*CGFloat(recoredTableView.dataArr.count)) + 54
          self.recoredTableView.frame =  CGRect(x: 0, y: scheduleCollectionView.bottom, width: kWidth, height: height)
          self.timeView.frame =  CGRect(x: 0, y: recoredTableView.bottom+14, width: kWidth, height: self.endBtn.bottom)
          self.attendPersonView.frame =  CGRect(x: 0, y: timeView.bottom+14, width: kWidth, height: self.collectionView.bottom)
          self.alertV.frame =  CGRect(x: 0, y: attendPersonView.bottom+14, width: kWidth, height: self.earlyBtn.bottom)
          self.headView.frame =  CGRect(x: 0, y: 0, width: kWidth, height: self.alertV.bottom+20)
          self.table.tableHeaderView = headView
      }
   
    func initView()  {
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.titleView)
        self.titleView.addSubview(self.titleLab)
        self.titleView.addSubview(self.titleTextView)
        self.titleView.addSubview(historyView)
        
        self.headView.addSubview(self.contentView)
        self.contentView.addSubview(self.addressLab)
        self.contentView.addSubview(self.addressTextView)
        self.contentView.addSubview(self.contentLab)
//        self.contentView.addSubview(self.textView)

        //内容视图计算高度
        self.contentView.frame =  CGRect(x: 0, y: titleView.bottom+14, width: kWidth, height: self.contentLab.bottom+10)
        
        
         self.headView.addSubview(self.addScheduleView)
        
        //添加图片选择器
        self.headView.addSubview(self.scheduleCollectionView)
        //语音录音
        self.headView.addSubview(self.recoredTableView)
        
        self.headView.addSubview(self.timeView)
        self.timeView.addSubview(self.beginLab)
        self.timeView.addSubview(self.startChooseLab)
        self.timeView.addSubview(self.startArrow)
        self.timeView.addSubview(self.endLab)
        self.timeView.addSubview(self.endChooseLab)
        self.timeView.addSubview(self.endArrow)
        self.timeView.addSubview(self.startBtn)
        self.timeView.addSubview(self.endBtn)
        if self.type == .update {
            self.startBtn.isEnabled = false
            self.endBtn.isEnabled = false
            self.startChooseLab.textColor = UIColor.gray
            self.endChooseLab.textColor = UIColor.gray
        }else{
            self.startBtn.isEnabled = true
            self.endBtn.isEnabled = true
            self.startChooseLab.textColor = UIColor.black
            self.endChooseLab.textColor = UIColor.black
        }
        //时间视图计算高度
        self.timeView.frame =  CGRect(x: 0, y: recoredTableView.bottom+14, width: kWidth, height: self.endBtn.bottom)
        
        self.headView.addSubview(self.attendPersonView)
        self.attendPersonView.addSubview(self.attendPersonLab)
        self.attendPersonView.addSubview(self.collectionView)
        //视图计算高度
        self.attendPersonView.frame =  CGRect(x: 0, y: timeView.bottom+14, width: kWidth, height: self.collectionView.bottom)
        self.headView.addSubview(self.alertV)
        self.alertV.addSubview(self.alertLab)
        self.alertV.addSubview(self.earlyChooseLab)
        self.alertV.addSubview(self.earlyArrow)
        self.alertV.addSubview(self.earlyBtn)
        //时间视图计算高度
        self.alertV.frame =  CGRect(x: 0, y: attendPersonView.bottom+14, width: kWidth, height: self.earlyBtn.bottom)
       
    }

    
    @objc func upDataHeight(notif:NSNotification){
        let height = CGFloat(AutoGetHeight(height: 55)*CGFloat(recoredTableView.dataArr.count)) + 54
      self.recoredTableView.frame =  CGRect(x: 0, y: scheduleCollectionView.bottom, width: kWidth, height: height)
        self.timeView.frame =  CGRect(x: 0, y: recoredTableView.bottom+14, width: kWidth, height: self.endBtn.bottom)
        self.attendPersonView.frame =  CGRect(x: 0, y: timeView.bottom+14, width: kWidth, height: self.collectionView.bottom)
        self.alertV.frame =  CGRect(x: 0, y: attendPersonView.bottom+14, width: kWidth, height: self.earlyBtn.bottom)
        self.headView.frame =  CGRect(x: 0, y: 0, width: kWidth, height: self.alertV.bottom+20)
        self.table.tableHeaderView = headView
    }
    
    //获取日程列表的数据
    func getScheduleText()->String{
        
        let dataArr = addScheduleView.dataArray
        var str = ""
        for(_,item) in dataArr.enumerated(){
            if item.planItemContent.count>0{
                str = str + item.planItemContent + ","
            }else{
                
            }
        }
        if str.hasSuffix(","){
            str.removeLast()
        }
        
        return str
    }
    
    
    @objc func storeClick()  {
        var planContent = getScheduleText()
        if planContent == self.textView.placeHolder {
            planContent = ""
        }
        var titleContent = self.titleTextView.textView.text
        if titleContent == self.titleTextView.placeHolder {
            titleContent = ""
        }
        var addressContent = self.addressTextView.textView.text
        if addressContent == self.addressTextView.placeHolder {
            addressContent = ""
        }

        
        
        if  self.aletStr.count > 0 && self.startTime.count > 0 && self.endTime.count > 0 && (titleContent?.count)! > 0 &&  (planContent.count) > 0{
            self.loadingPlay()
            self.editScheduleRequest()
            
        }else{

            if (titleContent?.isEmpty)! {
                SVProgressHUD.showInfo(withStatus: "请输入主题")
            }else if (planContent.isEmpty) {
                SVProgressHUD.showInfo(withStatus: "请输入日程内容")
            }else if self.startTime.isEmpty {
                SVProgressHUD.showInfo(withStatus: "请选择日程开始时间")
            }else if self.endTime.isEmpty {
                SVProgressHUD.showInfo(withStatus: "请选择日程结束时间")
            }else if self.aletStr.isEmpty {
                SVProgressHUD.showInfo(withStatus: "请选择提醒时间")
            }
        }
        
    }
    
    deinit {
        //移除通知
        LGSoundRecorder.shareInstance()?.removeFile()
        NotificationCenter.default.removeObserver(self)
        QRMusicPlay.shared.player?.onStateChange = {state in
        }
        QRMusicPlay.shared.stopMusic()
       
        LGAudioPlayer.share()?.stop()
    }
    
    
    
    
    @objc func selelctStartTime(){
        self.view.endEditing(true)
        BRDatePickerView.showDatePicker(withTitle: "", dateType: BRDatePickerMode.dateAndTime, defaultSelValue: self.startChooseLab.text) { [unowned self](select) in
            //选中时间
            let startDate = Date(dateString: select!, format: "yyyy-MM-dd HH:mm")
            self.startChooseLab.text = select
            self.startChooseLab.font = kFontSize15
            self.startChooseLab.textColor = UIColor.black
            self.startTime = select!
            //计算结束时间
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
            let deleyEnd = startDate.addingTimeInterval(3600)
            let endTimeStr = dateFormat.string(from: deleyEnd)
            self.endTime = endTimeStr
            self.endChooseLab.text = endTimeStr
            self.endChooseLab.font = kFontSize15
            self.endChooseLab.textColor = UIColor.black

        }
    }
    
    @objc func selelctEndTime(){
        self.view.endEditing(true)
        BRDatePickerView.showDatePicker(withTitle: "", dateType: BRDatePickerMode.dateAndTime, defaultSelValue: self.endChooseLab.text) { [unowned self](select) in
            
            
            let startDate = Date(dateString: self.startTime, format: "yyyy-MM-dd HH:mm")
            let endDate = Date(dateString: select!, format: "yyyy-MM-dd HH:mm")
            if endDate.isEarlier(than: startDate) && self.startTime != ""{
                SVProgressHUD.showInfo(withStatus: "结束时间需要大于开始时间,请重新选择")
            }else{
                
                if endDate.isSameDay(date: startDate){
                    
//                    let dateFormat = DateFormatter()
//                    dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
//                    let deleyEnd = endDate.addingTimeInterval(-3600)
//                    let startTimeStr = dateFormat.string(from: deleyEnd)
//                    self.startTime = startTimeStr
//                    self.startChooseLab.text = startTimeStr
//                    self.startChooseLab.font = kFontSize15
//                    self.startChooseLab.textColor = UIColor.black
                    
                    self.endChooseLab.text = select
                    self.endChooseLab.font = kFontSize15
                    self.endChooseLab.textColor = UIColor.black
                    self.endTime = select!
                }else{
                    
                     SVProgressHUD.showInfo(withStatus: "开始时间和结束时间必须在同一天")
                }
                
               
            }
          
            
            
        }
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
        
        if !self.userIdArr.contains(STUserTool.account().userID){
            self.userArray.append(CQDepartMentUserListModel.init(uId: STUserTool.account().userID, realN: STUserTool.account().realName, headImag: STUserTool.account().headImage))
            self.userIdArr.append(STUserTool.account().userID)
        }
        
        
        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
        self.table.tableHeaderView = self.headView
        self.attendPersonView.frame = CGRect.init(x: 0, y:self.timeView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 70) + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
        self.collectionView.frame = CGRect.init(x: kLeftDis, y: self.attendPersonLab.bottom + AutoGetHeight(height: 14), width: kHaveLeftWidth, height: AutoGetHeight(height: 14) + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
        self.alertV.frame =  CGRect.init(x: 0, y:self.attendPersonView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 55))
        self.collectionView.reloadData()
        self.headView.frame =  CGRect(x: 0, y: 0, width: kWidth, height: self.alertV.bottom+20)
        self.table.tableHeaderView = self.headView
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
        cancelBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        pickBg.addSubview(cancelBtn)
        cancelBtn.addTarget(self, action: #selector(removeBgView(sender:)), for: .touchUpInside)
        
        //创建日期选择器
        let datePicker = UIDatePicker(frame: CGRect(x:0, y:40, width:kWidth, height:200))
        //将日期选择器区域设置为中文，则选择器日期显示为中文
       // datePicker.locale = Locale(identifier: "zh_CN")
        datePicker.calendar = Calendar.current
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
            
            let startDate = Date(dateString: startTime, format: "yyyy-MM-dd HH:mm")
            let endDate = Date(dateString: endTime, format: "yyyy-MM-dd HH:mm")
            if endDate.isEarlier(than: startDate) && endTime != "" {
                SVProgressHUD.showInfo(withStatus: "结束时间需要大于开始时间,请重新选择")
                startTime = ""
                timeString = ""
                self.startChooseLab.text = ""
                self.bgView.removeAllSubviews()
                self.bgView.removeFromSuperview()
                return
            }else{
                self.startChooseLab.text = startTime
                self.startChooseLab.font = kFontSize15
                self.startChooseLab.textColor = UIColor.black
                
                let deleyEnd = startDate.addingTimeInterval(3600)
                if deleyEnd.hour < 18{
                    let dateFormat = DateFormatter()
                    dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
                    let endTimeStr = dateFormat.string(from: deleyEnd)
                    self.endTime = endTimeStr
                    self.endChooseLab.text = endTimeStr
                    self.endChooseLab.font = kFontSize15
                    self.endChooseLab.textColor = UIColor.black
                }else{
                    
                    let dateFormat = DateFormatter()
                    dateFormat.dateFormat = "yyyy-MM-dd "
                    let endTimeStr = dateFormat.string(from: Date())+"18:00"
                    self.endTime = endTimeStr
                    self.endChooseLab.text = endTimeStr
                    self.endChooseLab.font = kFontSize15
                    self.endChooseLab.textColor = UIColor.black
                }
            }
  
        }else if btn.tag == 701 {
            endTime = timeString
            if endTime.isEmpty{
                let now = Date()
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
                self.endTime = dateFormat.string(from: now)
            }
            //判断结束是否小于开始
            let startDate = Date(dateString: startTime, format: "yyyy-MM-dd HH:mm")
            let endDate = Date(dateString: endTime, format: "yyyy-MM-dd HH:mm")
            if endDate.isEarlier(than: startDate) && startTime != ""{
                SVProgressHUD.showInfo(withStatus: "结束时间需要大于开始时间,请重新选择")
                endTime = ""
                timeString = ""
                 self.endChooseLab.text = ""
                self.bgView.removeAllSubviews()
                self.bgView.removeFromSuperview()
                return
            }else{
                self.endChooseLab.text = endTime
                self.endChooseLab.font = kFontSize15
                self.endChooseLab.textColor = UIColor.black
            }
            
           
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
    
    @objc func earlyChoose()  {
        self.initPick()
    }
}

// Mark :编辑日程请求
extension CQCreateScheduleVC{
    
    func editScheduleRequest()  {
        let userID = STUserTool.account().userID
        var opt = ""
        
        //获取删除语音数组
        var soundDeleteStr = ""
       
        if type == .save {
            opt = "save"
            if !self.userIdArr.contains(STUserTool.account().userID){
                self.userArray.append(CQDepartMentUserListModel.init(uId: STUserTool.account().userID, realN: STUserTool.account().realName, headImag: STUserTool.account().headImage))
                self.userIdArr.append(STUserTool.account().userID)
            }
        }else if type == .update{
            opt = "update"
            //删除语音字符串
            for (_,value) in self.recoredTableView.deleteArr.enumerated(){
                let arr = value.soundFilePath.split(separator: "/")
                let path = arr.last
                soundDeleteStr += path! + ","
            }
            
            //删除y图片字段
            let set1 = Set(self.delelteArray)
            let set2 = Set(self.photoStrArray)
            let set3 = set1.subtracting(set2)
            for (_,value) in set3.enumerated(){
                let arr = (value ).split(separator: "/")
                let path = arr.last
                soundDeleteStr += path! + ","
            }
            if soundDeleteStr.hasSuffix(","){
                soundDeleteStr.removeLast()
            }
            
            
            
        }
        var addressStr = ""
        addressStr = self.addressTextView.textView.text
        if addressStr == self.addressTextView.placeHolder{
            addressStr = ""
        }
        //获取音屏模型数组
        let sounds = self.recoredTableView.uploadArr
        //mp3文件
        let now = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
        var current = ""
        current = dateFormat.string(from: now)
        let realName = STUserTool.account().realName
        
        
        var useArrStr = ""
        for (_,value) in self.userIdArr.enumerated(){
            useArrStr += value + ","
        }
        if useArrStr.hasSuffix(","){
            useArrStr.removeLast()
        }
      
        let planItemContents = getScheduleText()
        
        let urlUpload = "\(baseUrl)/schedule/saveOrUpdateSchedulePlan"
        let headers = ["t_userId":userID,
                       "token":STUserTool.account().token]
        Alamofire.upload(multipartFormData: { formData in
            let param = ["userId":userID,
                         "addressRemark":addressStr,
                         "alertLimit":self.aletStr,
                         "userIds[]":useArrStr,
                         "endDate":self.endTime,
                         "planContent":self.textView.textView.text ?? "",
                         "planTitle":self.titleTextView.textView.text ?? "",
                         "startDate":self.startTime,
                         "operateMode":opt,
                         "schedulePlanId":self.schedulePlanId,
                         "planType":"1",
                         "deleteFileName":soundDeleteStr,
                         "planItemContents":planItemContents]
            
            //添加音频文件 audioFiles
            for (index,value) in sounds.enumerated() {
                let vidioName = "qqq" + "\(index)" + ".mp3"
                let url = URL(fileURLWithPath: value.soundFilePath )//audio/mp3
                formData.append(url, withName: "audioFiles", fileName: vidioName, mimeType: "audio/mp3")
            }
            
            for index in 0..<self.photoArray.count {
                let imageData = UIImageJPEGRepresentation(self.photoArray[index], 0.3)
                formData.append(imageData!, withName: "imgFiles", fileName: "photo.png", mimeType: "image/jpg")
            }

            for (key, value) in param {
                formData.append((value.data(using: .utf8)!), withName: key)
            }

        }, to: urlUpload, headers: headers, encodingCompletion: {encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    self.loadingSuccess()
                    guard let result = response.result.value else {
                        //请求失败
                        if let err = response.error{
                        }
                        SVProgressHUD.showError(withStatus: "服务器有点问题")
                        DLog(response.error)
                        return
                    }
                    //将结果回调出去
                    let json = JSON(result)
                    if json["success"].boolValue == true{
                        SVProgressHUD.showInfo(withStatus: json["message"].stringValue)
                        //刷新日程首页
                        NotificationCenter.default.post(name: NSNotification.Name.init("refreshScheduleUI"), object: nil)
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        SVProgressHUD.showError(withStatus: json["message"].stringValue)
                    }
                    
                   
                }
            case .failure( _):
                self.loadingSuccess()
                SVProgressHUD.showError(withStatus: "网络异常，请检查连接")
            }
        })
        
        
    }
    
//    //上传图片
//    func postImgData(comment:String)  {
//        let userID = STUserTool.account().userID
//        let urlUpload = "\(baseUrl)/admir/saveAdmir"
//        let headers = ["t_userId":userID,
//                       "token":STUserTool.account().token]
//        Alamofire.upload(multipartFormData: { formData in
//            let param = ["userId":userID,
//                         "content":comment,"toUserId":userID]
//            for index in 0..<self.photoArray.count {
//                let imageData = UIImageJPEGRepresentation(self.photoArray[index], 0.3)
//                formData.append(imageData!, withName: "imgFiles", fileName: "photo.png", mimeType: "image/jpg")
//            }
//
//            for (key, value) in param {
//                formData.append((value.data(using: .utf8)!), withName: key)
//            }
//        }, to: urlUpload, headers: headers, encodingCompletion: {encodingResult in
//            switch encodingResult {
//            case .success(let upload, _, _):
//                upload.responseJSON { response in
//                    self.loadingSuccess()
//                    SVProgressHUD.showInfo(withStatus: "添加成功")
//                    //刷新日程首页
//                    NotificationCenter.default.post(name: NSNotification.Name.init("refreshScheduleUI"), object: nil)
//                    self.navigationController?.popViewController(animated: true)
//                }
//            case .failure( _):
//                self.loadingSuccess()
//            }
//        })
//    }
    
    
    
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
                self.addressTextView.prevText = model.addressRemark
//                self.textView.prevText = model.planContent
             
                
              
                var dataArr = [QRSecheduleModel]()
                for(_,item) in result["data"]["planItemData"].arrayValue.enumerated(){
                    let mod = QRSecheduleModel(jsonData: item)
                    dataArr.append(mod!)
                }
                self.addScheduleView.dataArray = dataArr
                self.addScheduleView.table.reloadData()
                
                
                self.startChooseLab.text = model.startDate//st
                self.startChooseLab.font = kFontSize15
                self.startChooseLab.textColor = UIColor.black
                self.startTime = model.startDate
                self.endChooseLab.text = model.endDate// et
                self.endChooseLab.font = kFontSize15
                self.endChooseLab.textColor = UIColor.black
                self.endTime = model.endDate
                
                
                
                if self.type == .update {
                    self.startChooseLab.textColor = UIColor.gray
                    self.endChooseLab.textColor = UIColor.gray
                }else{
                    self.startChooseLab.textColor = UIColor.black
                    self.endChooseLab.textColor = UIColor.black
                }
                
                
                
                var arr = [CQDepartMentUserListModel]()
                
                self.userArray.removeAll()
                self.userIdArr.removeAll()
                
                for modalJson in result["data"]["userData"].arrayValue  {
                    guard let modal = CQDepartMentUserListModel(jsonData: JSON(modalJson)) else {
                        return
                    }
                    DLog(modal)
                    arr.append(modal)
                }
               
                
                self.userArray = arr
                for uid in self.userArray{
                    self.userIdArr.append(uid.userId)
                }
                self.aletStr = model.alertLimit
                if model.alertLimit == "15"{
                    self.earlyChooseLab.text = "提前15分钟提醒"
                }else if model.alertLimit == "30"{
                    self.earlyChooseLab.text = "提前30分钟提醒"
                }else if model.alertLimit == "60"{
                    self.earlyChooseLab.text = "提前1小时提醒"
                }else if model.alertLimit == "1440"{
                    self.earlyChooseLab.text = "提前1天提醒"
                }
                
                self.earlyChooseLab.font = kFontSize15
                self.earlyChooseLab.textColor = UIColor.black
                self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
                self.table.tableHeaderView = self.headView
                self.attendPersonView.frame = CGRect.init(x: 0, y:self.timeView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 70) + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
                self.collectionView.frame = CGRect.init(x: kLeftDis, y: self.attendPersonLab.bottom + AutoGetHeight(height: 14), width: kHaveLeftWidth, height: AutoGetHeight(height: 14) + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
                self.alertV.frame =  CGRect.init(x: 0, y:self.attendPersonView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 55))
                self.collectionView.reloadData()
                
                //照片
                
//                var tempArr = [UIImage]()//
//                for (_,_) in model.imgFiles.enumerated(){
//                    tempArr.append(UIImage(named: "demo")!)
//                }
//                self.downloadImageData(urlArr:model.imgFiles)
                self.photoStrArray = model.imgFiles
                self.delelteArray = model.imgFiles
                self.scheduleCollectionView.reloadData()
                //音频数据
                self.recoredTableView.dataArr = model.audioFiles
                self.recoredTableView.table.reloadData()
                NotificationCenter.default.post(name: NSNotification.Name.init("updateScheduleSoundHeight"), object: self, userInfo: nil)
                self.table.reloadData()
                
                
                
        }) { (error) in
            
        }
    }
    
    
    func downloadImageData(urlArr : [String])  {

//        let queue = OperationQueue()
//         var temp = [BlockOperation]()
//
//        for (index,value) in urlArr.enumerated(){
//            let opt = BlockOperation {
//                SDWebImageManager.shared().imageDownloader?.downloadImage(with: URL(string: value), options: [], progress: { (receivedSize, expectedSize, imageURL) in
//
//                }, completed: { (img, data, error, boo) in
//                    if let image = img{
//                        self.photoArray.append(image)
//                        self.scheduleCollectionView.reloadData()
//                    }else{
//                        self.photoArray.append(UIImage(named: "demo")!)
//                        self.scheduleCollectionView.reloadData()
//                    }
//                })
//            }
//            if index-1<0{
//            }else{
//                opt.addDependency(temp[index-1])
//            }
//           temp.append(opt)
//        }
//
//        //加入
//        for (_,value) in temp.enumerated(){
//            queue.addOperation(value)
//        }
        
    }
}

extension CQCreateScheduleVC:UITextFieldDelegate,KeyBoardDelegate{
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

extension CQCreateScheduleVC:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
}

// MARK: - 代理

extension CQCreateScheduleVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if 801 == collectionView.tag {
            if self.type == .update{
                return self.photoStrArray.count + self.photoArray.count + 1
            }else{
                return self.photoArray.count + 1
            }
           
        }
        return self.userArray.count + 1
    }
        
    
    
}

extension CQCreateScheduleVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if 801 == collectionView.tag {
            //相册
         
            if self.type == .update{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQCirclePublishCellId", for: indexPath) as! CQCirclePublishCell
                cell.deleteDelegate = self
                cell.deleteBtn.isHidden = false
                if (self.photoArray.count + self.photoStrArray.count) == indexPath.item {
                        cell.img.image = UIImage.init(named: "CQCirclePublishAdd")
                        cell.deleteBtn.isHidden = true
                }else {
                    cell.deleteBtn.isHidden = false
                    if indexPath.item > self.photoStrArray.count-1 {
                        cell.img.image = self.photoArray[indexPath.item-self.photoStrArray.count]
                    }else{
                        cell.img.sd_setImage(with: URL(string: self.photoStrArray[indexPath.item]), placeholderImage: UIImage.init(named: "CQIndexPersonDefault"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
                    }
                    
                    
                }
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQCirclePublishCellId", for: indexPath) as! CQCirclePublishCell
                cell.deleteDelegate = self
                cell.deleteBtn.isHidden = false
                if self.photoArray.count == 0 {
                    if indexPath.item == 0{
                        cell .img.image = UIImage.init(named: "CQCirclePublishAdd")
                        cell.deleteBtn.isHidden = true
                    }
                }else {
                    cell.deleteBtn.isHidden = false
                    if indexPath.item == self.photoArray.count {
                        cell.img.image = UIImage.init(named: "CQCirclePublishAdd")
                        cell.deleteBtn.isHidden = true
                    }else {
                        cell.img.image = self.photoArray[indexPath.item]
                    }
                }
                return cell
            }
  
        }else{
            //日程成员
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQWriteReportCellId", for: indexPath) as! CQWriteReportCell
            if self.userArray.count == 0 {
                if indexPath.row == 0{
                    cell.img.image = UIImage.init(named: "CQAddMenberIcon")
                    cell.deleteBtn.isHidden = true
                    cell.nameLab.text = ""
                }
            }else {
                if indexPath.row == self.userArray.count {
                    cell.img.image = UIImage.init(named: "CQAddMenberIcon")
                    cell.deleteBtn.isHidden = true
                    cell.nameLab.text = ""
                }else {
                    cell.img.sd_setImage(with: URL(string: self.userArray[indexPath.row].headImage ), placeholderImage:UIImage.init(named: "personDefaultIcon") )
                    cell.nameLab.text = self.userArray[indexPath.row].realName
                    cell.deleteBtn.isHidden = false
                    cell.deleteDelegate = self
                }
            }
            return cell
            
            
        }
        
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if 801 == collectionView.tag {
            //图片选择
            if self.type == .update{
                if (self.photoArray.count + self.photoStrArray.count) == indexPath.item {
                    initImgPick()
                }else{
                    
                }
            }else{
                if self.photoArray.count == 0 {
                    if indexPath.item == 0 {
                        initImgPick()
                    }
                }else{
                    if indexPath.item == self.photoArray.count{
                        initImgPick()
                    }else{
                        
                    }
                }
            }
            
        }else{
            //日程成员选择
            if self.userArray.count == 0 {
                if indexPath.row == 0 {
                    let contact = QRAddressBookVC()
                    contact.toType = .fromAddGroupMember
                    contact.hasSelectModelArr = [CQDepartMentUserListModel.init(uId: STUserTool.account().userID, realN: STUserTool.account().realName, headImag: STUserTool.account().headImage)]
                    self.navigationController?.pushViewController(contact, animated: true)
                }
            }else{
                if indexPath.row == self.userArray.count{
                    let contact = QRAddressBookVC()
                    contact.toType = .fromAddGroupMember
                    contact.hasSelectModelArr = self.userArray
                    self.navigationController?.pushViewController(contact, animated: true)
                    
                }else{
                    
                }
            }
        }
        
        
    }
}

extension CQCreateScheduleVC:CQPublishDeleteDelegate{
    func deletePublishPic(index: IndexPath) {
        if self.type == .update{
            if index.item > photoStrArray.count-1{
                self.photoArray.remove(at: index.item-photoStrArray.count)
                self.scheduleCollectionView.reloadData()
            }else{
             //   delelteStr.append(self.photoStrArray[index.row])
                self.photoStrArray.remove(at: index.row)
                self.scheduleCollectionView.reloadData()
            }
          
        }else{
            self.photoArray.remove(at: index.row)
            self.scheduleCollectionView.reloadData()
        }
        
    }
    
    
}
extension CQCreateScheduleVC{
    func initImgPick()  {
        let imagePickerVc = TZImagePickerController(maxImagesCount: 3, delegate: self)
        //imagePickerVc?.allowTakePicture = false
        self.present(imagePickerVc!, animated: true, completion: nil)
    }
}

extension CQCreateScheduleVC: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        photoArray.insert(contentsOf: photos, at: 0)
        if (photoArray.count+photoStrArray.count) > 3 {
            if photoArray.count >= 3{
                photoStrArray.removeAll()
                photoArray.removeSubrange(photoArray.indices.suffix(from: 3))
            }else{
                //删除旧的并且记录下来
             
                photoStrArray.removeSubrange(photoStrArray.indices.prefix(upTo: 3-photoArray.count-1))
                
            }
            
        }
        
        self.scheduleCollectionView.frame = CGRect.init(x: 0, y: self.addScheduleView.bottom, width: kWidth, height: (kHaveLeftWidth-AutoGetWidth(width: 30))/4 + 20)
        
            scheduleCollectionView.reloadData()
    }
}


extension CQCreateScheduleVC{
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
        
        let titleLab = UILabel()
        titleLab.frame = CGRect.init(x: kWidth/2 - AutoGetWidth(width: 35), y: 0, width: AutoGetWidth(width: 70), height: AutoGetHeight(height: 40))
        titleLab.text = "选择时间"
        titleLab.textAlignment = .center
        titleLab.font = kFontBoldSize17
        titleLab.textColor = UIColor.black
        pickBg.addSubview(titleLab)
        
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
        self.earlyChooseLab.font = kFontSize15
        self.earlyChooseLab.textColor = UIColor.black
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


extension CQCreateScheduleVC:UIPickerViewDelegate,UIPickerViewDataSource{
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


extension CQCreateScheduleVC:CQSelectDeleteDelegate{
    func deleteCollectionCell(index: IndexPath) {
        self.userIdArr.remove(at:index.item)
        self.userArray.remove(at: index.item)
        
        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
        self.table.tableHeaderView = self.headView
        self.attendPersonView.frame = CGRect.init(x: 0, y:self.timeView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 70) + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
        self.collectionView.frame = CGRect.init(x: kLeftDis, y: self.attendPersonLab.bottom + AutoGetHeight(height: 14), width: kHaveLeftWidth, height: AutoGetHeight(height: 14) + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
        self.alertV.frame =  CGRect.init(x: 0, y:self.attendPersonView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 55))
        self.collectionView.reloadData()
        self.headView.frame =  CGRect(x: 0, y: 0, width: kWidth, height: self.alertV.bottom+20)
        self.table.tableHeaderView = self.headView
    }
    
    
}


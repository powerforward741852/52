//
//  CQWriteReportVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/9.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit
import AVKit
import AssetsLibrary
import MediaPlayer
import MobileCoreServices


/// 请求方法枚举
enum writeReportType {
    case day
    case week
    case month
}

class CQWriteReportVC: SuperVC {

    var wirteType:writeReportType?
    var userArray = [CQDepartMentUserListModel]()
    var userIdArr = [String]()
    var userNameArr = [String]()
    
    //上传类型
    var flag = ""
    //上传图片
    var imageUrl:UIImage?
    //上传视频
    var mp4Path:URL?
    //当前类型
    var curType = ""
    //当前名字
    var curName = ""

    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 64, width: kWidth, height: kHeight - 64), style: UITableViewStyle.plain)
        table.backgroundColor = kProjectBgColor
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight ))
        headView.backgroundColor = kProjectBgColor
        return headView
    }()
    
    lazy var todayFinishView: UIView = {
        let todayFinishView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 118)))
        todayFinishView.backgroundColor = UIColor.white
        
        return todayFinishView
    }()
    
    lazy var todayFinishWorkLab: UILabel = {
        let todayFinishWorkLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 18), width: kHaveLeftWidth, height: AutoGetHeight(height: 15)))
        todayFinishWorkLab.text = ""
        todayFinishWorkLab.textAlignment = .left
        todayFinishWorkLab.textColor = UIColor.black
        todayFinishWorkLab.font = kFontSize15
        return todayFinishWorkLab
    }()
    
    lazy var todayFinishWorkField: CBTextView = {
        let todayFinishWorkField = CBTextView.init(frame:CGRect.init(x: kLeftDis, y: self.todayFinishWorkLab.bottom + AutoGetHeight(height: 13), width: kHaveLeftWidth, height: AutoGetHeight(height: 59)))
        todayFinishWorkField.aDelegate = self
        todayFinishWorkField.textView.backgroundColor = UIColor.white
        todayFinishWorkField.textView.font = UIFont.systemFont(ofSize: 15)
        todayFinishWorkField.textView.textColor = UIColor.black
        
        todayFinishWorkField.placeHolder = "请输入"
        todayFinishWorkField.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        return todayFinishWorkField
    }()
    
    lazy var hasNotFinishView: UIView = {
        let hasNotFinishView = UIView.init(frame: CGRect.init(x: 0, y: self.todayFinishView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 118)))
        hasNotFinishView.backgroundColor = UIColor.white
        return hasNotFinishView
    }()
    
    lazy var hsaNotFinishLab: UILabel = {
        let hsaNotFinishLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 18), width: kHaveLeftWidth, height: AutoGetHeight(height: 15)))
        hsaNotFinishLab.text = ""
        hsaNotFinishLab.textAlignment = .left
        hsaNotFinishLab.textColor = UIColor.black
        hsaNotFinishLab.font = kFontSize15
        return hsaNotFinishLab
    }()
    
    lazy var hasNotFinishField: CBTextView = {
        let hasNotFinishField = CBTextView.init(frame: CGRect.init(x: kLeftDis, y: self.hsaNotFinishLab.bottom + AutoGetHeight(height: 13), width: kHaveLeftWidth, height: AutoGetHeight(height: 59)))
        hasNotFinishField.aDelegate = self
        hasNotFinishField.textView.backgroundColor = UIColor.white
        hasNotFinishField.textView.font = UIFont.systemFont(ofSize: 15)
        hasNotFinishField.textView.textColor = UIColor.black
        
        hasNotFinishField.placeHolder = "请输入."
        hasNotFinishField.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        return hasNotFinishField
    }()
    
    lazy var needCoordinateView: UIView = {
        let needCoordinateView = UIView.init(frame: CGRect.init(x: 0, y: self.hasNotFinishView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 118)))
        needCoordinateView.backgroundColor = UIColor.white
        return needCoordinateView
    }()
    
    lazy var needCoordinateLab: UILabel = {
        let needCoordinateLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 18), width: kHaveLeftWidth, height: AutoGetHeight(height: 15)))
        needCoordinateLab.text = ""
        needCoordinateLab.textAlignment = .left
        needCoordinateLab.textColor = UIColor.black
        needCoordinateLab.font = kFontSize15
        return needCoordinateLab
    }()
    
    lazy var needCoordinateField: CBTextView = {
        let needCoordinateField = CBTextView.init(frame: CGRect.init(x: kLeftDis, y: self.needCoordinateLab.bottom + AutoGetHeight(height: 13), width: kHaveLeftWidth, height: AutoGetHeight(height: 59)))
        needCoordinateField.aDelegate = self
        needCoordinateField.textView.backgroundColor = UIColor.white
        needCoordinateField.textView.font = UIFont.systemFont(ofSize: 15)
        needCoordinateField.textView.textColor = UIColor.black
        
        needCoordinateField.placeHolder = "请输入."
        needCoordinateField.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        return needCoordinateField
    }()
    
    lazy var weekNeedHelpView: UIView = {
        let weekNeedHelpView = UIView.init(frame: CGRect.init(x: 0, y: self.needCoordinateView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 118)))
        weekNeedHelpView.backgroundColor = UIColor.white
        return weekNeedHelpView
    }()
    
    lazy var weekNeedHelpLab: UILabel = {
        let weekNeedHelpLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 18), width: kHaveLeftWidth, height: AutoGetHeight(height: 15)))
        weekNeedHelpLab.text = "需帮助与支持"
        weekNeedHelpLab.textAlignment = .left
        weekNeedHelpLab.textColor = UIColor.black
        weekNeedHelpLab.font = kFontSize15
        return weekNeedHelpLab
    }()
    
    lazy var weekNeedHelpField: CBTextView = {
        let weekNeedHelpField = CBTextView.init(frame: CGRect.init(x: kLeftDis, y: self.weekNeedHelpLab.bottom + AutoGetHeight(height: 13), width: kHaveLeftWidth, height: AutoGetHeight(height: 59)))
        weekNeedHelpField.aDelegate = self
        weekNeedHelpField.textView.backgroundColor = UIColor.white
        weekNeedHelpField.textView.font = UIFont.systemFont(ofSize: 15)
        weekNeedHelpField.textView.textColor = UIColor.black
        
        weekNeedHelpField.placeHolder = "请输入."
        weekNeedHelpField.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        return weekNeedHelpField
    }()
    
    lazy var attachView: UIButton = {
        let attachView = UIButton.init(type: .custom)
        attachView.frame = CGRect.init(x: 0, y: self.weekNeedHelpField.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 55))
        attachView.setTitle("    附件", for: .normal)
        attachView.setTitleColor(.black, for: .normal)
        attachView.contentHorizontalAlignment = .left
        attachView.backgroundColor = .white
        attachView.titleLabel?.font = kFontSize15
        attachView.addTarget(self, action: #selector(uploadClick), for: .touchUpInside)
        return attachView
    }()
    
    
    lazy var sendView: UIView = {
        let sendView = UIView.init(frame: CGRect.init(x: 0, y: self.attachView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 145)))
        sendView.backgroundColor = UIColor.white
        return sendView
    }()
    
    lazy var sendToWhoLab: UILabel = {
        let sendToWhoLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kHaveLeftWidth, height: AutoGetHeight(height: 51)))
        sendToWhoLab.textColor = UIColor.black
        sendToWhoLab.textAlignment = .left
        sendToWhoLab.text = "发给谁"
        sendToWhoLab.font = kFontSize15
        return sendToWhoLab
    }()
    
    lazy var collectionView: UICollectionView = {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width: kHaveLeftWidth/4, height: AutoGetHeight(height: 75))
        layOut.minimumLineSpacing = 0
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        //        layOut.headerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 38))
        //        layOut.footerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 11))
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: kLeftDis, y: self.sendToWhoLab.bottom , width: kHaveLeftWidth, height: AutoGetHeight(height: 75)), collectionViewLayout: layOut)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(CQWriteReportCell.self, forCellWithReuseIdentifier: "CQWriteReportCellId")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.todayFinishView)
        self.todayFinishView.addSubview(self.todayFinishWorkLab)
        self.todayFinishView.addSubview(self.todayFinishWorkField)
        self.headView.addSubview(self.hasNotFinishView)
        self.hasNotFinishView.addSubview(self.hsaNotFinishLab)
        self.hasNotFinishView.addSubview(self.hasNotFinishField)
        self.headView.addSubview(self.needCoordinateView)
        self.needCoordinateView.addSubview(self.needCoordinateLab)
        self.needCoordinateView.addSubview(self.needCoordinateField)
        
        self.headView.addSubview(self.sendView)
        self.sendView.addSubview(self.sendToWhoLab)
        self.sendView.addSubview(self.collectionView)
        if self.wirteType == .day {
            self.getSchedulePlanByReportList()
            self.title = "日报"
            self.todayFinishWorkLab.text = "今日完成工作"
            self.hsaNotFinishLab.text = "未完成工作"
            self.needCoordinateLab.text = "需协调工作"
            self.attachView.frame = CGRect.init(x: 0, y: self.needCoordinateView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 55))
            self.headView.addSubview(self.attachView)
            
            self.sendView.frame = CGRect.init(x: 0, y: self.attachView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 145))
        }else if self.wirteType == .week {
            self.title = "周报"
            self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 720))
            self.table.tableHeaderView = self.headView
            self.headView.addSubview(self.weekNeedHelpView)
            self.weekNeedHelpView.addSubview(self.weekNeedHelpLab)
            self.weekNeedHelpView.addSubview(self.weekNeedHelpField)
            self.attachView.frame = CGRect.init(x: 0, y: self.weekNeedHelpView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 55))
            self.headView.addSubview(self.attachView)
            
            self.sendView.frame = CGRect.init(x: 0, y: self.attachView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 145))
            self.todayFinishWorkLab.text = "本周工作内容"
            self.hsaNotFinishLab.text = "本周工作总结"
            self.needCoordinateLab.text = "下周工作计划"
            self.weekNeedHelpLab.text = "需帮助与支持"
        }else {
            self.title = "月报"
            self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 720))
            self.table.tableHeaderView = self.headView
            self.headView.addSubview(self.weekNeedHelpView)
            self.weekNeedHelpView.addSubview(self.weekNeedHelpLab)
            self.weekNeedHelpView.addSubview(self.weekNeedHelpField)
            self.attachView.frame = CGRect.init(x: 0, y: self.weekNeedHelpView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 55))
            self.headView.addSubview(self.attachView)
            
            self.sendView.frame = CGRect.init(x: 0, y: self.attachView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 145))
            self.todayFinishWorkLab.text = "本月工作内容"
            self.hsaNotFinishLab.text = "本月工作总结"
            self.needCoordinateLab.text = "下月工作计划"
            self.weekNeedHelpLab.text = "需帮助与支持"
        }
        
//        let NotifMycation = NSNotification.Name(rawValue:"refreshReportCell")
//        NotificationCenter.default.addObserver(self, selector: #selector(upDataChange(notif:)), name: NotifMycation, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(upDataChange(notif:)), name: NSNotification.Name.init("AddTracker"), object: nil)
     
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        rightBtn.setTitle("完成", for: .normal)
        rightBtn.sizeToFit()
        rightBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        rightBtn.setTitleColor(UIColor.colorWithHexString(hex: "#20afff"), for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        rightBtn.addTarget(self, action: #selector(storeClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEditChanged(obj:)), name: Notification.Name.UITextViewTextDidChange, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
    }

    @objc func storeClick()  {
        writeReportRequest()
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
        
        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75) + AutoGetHeight(height: 68))
        self.table.tableHeaderView = self.headView
        if self.wirteType == .week || self.wirteType == .month{
            self.sendView.frame = CGRect.init(x: 0, y: self.attachView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 70) + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
        }else{
            self.sendView.frame = CGRect.init(x: 0, y:self.attachView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 70) + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
        }
        
        self.collectionView.frame = CGRect.init(x: kLeftDis, y: self.sendToWhoLab.bottom + AutoGetHeight(height: 14), width: kHaveLeftWidth, height: AutoGetHeight(height: 14) + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
        self.table.reloadData()
        self.collectionView.reloadData()
    }

    
    //MARK 附件上传
    @objc func uploadClick()  {
        self.takePhoto()
    }
    
    
}

// Mark :添加发票请求
extension CQWriteReportVC{
    func writeReportRequest()  {
        let userID = STUserTool.account().userID
        var par:[String : Any]?
        var opt = ""
        
        var userIdStr = ""
        for str in self.userIdArr{
            userIdStr = str + ","
        }
        if userIdStr.last == ","{
            userIdStr.removeLast()
        }
         
        if wirteType == .day {
            opt = "1"
            var todayStr = self.todayFinishWorkField.textView.text
            if todayStr == self.todayFinishWorkField.placeHolder {
                todayStr = ""
            }
            var hasNotFinishStr = self.hasNotFinishField.textView.text
            if hasNotFinishStr == self.hasNotFinishField.placeHolder{
                hasNotFinishStr = ""
            }
            var needStr = self.needCoordinateField.textView.text
            if needStr == self.needCoordinateField.placeHolder{
                needStr = ""
            }
            // 数字判断
            guard   (todayStr?.count)! > 0,
                (hasNotFinishStr?.count)! > 0,
                (needStr?.count)! > 0,
                self.userArray.count>0 else {
                    if (todayStr?.isEmpty)!{
                       SVProgressHUD.showInfo(withStatus: "请输入今日完成工作")
                    }else if (hasNotFinishStr?.isEmpty)!{
                        SVProgressHUD.showInfo(withStatus: "请输入未完成工作")
                    }else if (needStr?.isEmpty)!{
                        SVProgressHUD.showInfo(withStatus: "请输入需要协调工作")
                    }else if self.userArray.count <= 0{
                        SVProgressHUD.showInfo(withStatus: "请选择要发送的对象")
                    }
                    
                    return
            }
            
            par = ["hasdoWork":self.todayFinishWorkField.textView.text ?? "",
                    "reportType":opt,
                    "teamWork":self.hasNotFinishField.textView.text ?? "",
                    "undoWork":self.needCoordinateField.textView.text ?? "",
                    "userId":userID,
                    "newUserIds":userIdStr]
        }else if wirteType == .week{
            opt = "2"
            var todayStr = self.todayFinishWorkField.textView.text
            if todayStr == self.todayFinishWorkField.placeHolder {
                todayStr = ""
            }
            var hasNotFinishStr = self.hasNotFinishField.textView.text
            if hasNotFinishStr == self.hasNotFinishField.placeHolder{
                hasNotFinishStr = ""
            }
            var needStr = self.needCoordinateField.textView.text
            if needStr == self.needCoordinateField.placeHolder{
                needStr = ""
            }
            var weekNeedHelpStr = self.weekNeedHelpField.textView.text
            if weekNeedHelpStr == self.weekNeedHelpField.placeHolder{
                weekNeedHelpStr = ""
            }
            // 数字判断
            guard   (todayStr?.count)! > 0,
                (hasNotFinishStr?.count)! > 0,
                (needStr?.count)! > 0,
                (weekNeedHelpStr?.count)! > 0,
                self.userArray.count>0 else {
                    if (todayStr?.isEmpty)!{
                        SVProgressHUD.showInfo(withStatus: "请输入本周工作内容")
                    }else if (hasNotFinishStr?.isEmpty)!{
                        SVProgressHUD.showInfo(withStatus: "请输入本周工作总结")
                    }else if (needStr?.isEmpty)!{
                        SVProgressHUD.showInfo(withStatus: "请输入下周工作计划")
                    }else if (weekNeedHelpStr?.isEmpty)!{
                        SVProgressHUD.showInfo(withStatus: "请输入需帮助与支持内容")
                    }else if self.userArray.count <= 0{
                        SVProgressHUD.showInfo(withStatus: "请选择要发送的对象")
                    }
                    
                    return
            }
            
            par = ["thisWorkContent":self.todayFinishWorkField.textView.text ?? "",
                   "thisWorkSummary":self.hasNotFinishField.textView.text ?? "",
                   "nextWorkPlan":self.needCoordinateField.textView.text ?? "",
                   "needHelp": self.weekNeedHelpField.textView.text ?? "",
                   "reportType":opt,
                   "userId":userID,
                   "newUserIds":userIdStr]
        }else if wirteType == .month{
            opt = "3"
            var todayStr = self.todayFinishWorkField.textView.text
            if todayStr == self.todayFinishWorkField.placeHolder {
                todayStr = ""
            }
            var hasNotFinishStr = self.hasNotFinishField.textView.text
            if hasNotFinishStr == self.hasNotFinishField.placeHolder{
                hasNotFinishStr = ""
            }
            var needStr = self.needCoordinateField.textView.text
            if needStr == self.needCoordinateField.placeHolder{
                needStr = ""
            }
            var weekNeedHelpStr = self.weekNeedHelpField.textView.text
            if weekNeedHelpStr == self.weekNeedHelpField.placeHolder{
                weekNeedHelpStr = ""
            }
            // 数字判断
            guard   (todayStr?.count)! > 0,
                (hasNotFinishStr?.count)! > 0,
                (needStr?.count)! > 0,
                (weekNeedHelpStr?.count)! > 0,
                self.userArray.count>0 else {
                    if (todayStr?.isEmpty)!{
                        SVProgressHUD.showInfo(withStatus: "请输入本月工作内容")
                    }else if (hasNotFinishStr?.isEmpty)!{
                        SVProgressHUD.showInfo(withStatus: "请输入本月工作总结")
                    }else if (needStr?.isEmpty)!{
                        SVProgressHUD.showInfo(withStatus: "请输入下月工作计划")
                    }else if (weekNeedHelpStr?.isEmpty)!{
                        SVProgressHUD.showInfo(withStatus: "请输入需帮助与支持内容")
                    }else if self.userArray.count <= 0{
                        SVProgressHUD.showInfo(withStatus: "请选择要发送的对象")
                    }
                    
                    return
            }
            par = ["thisWorkContent":self.todayFinishWorkField.textView.text ?? "",
                   "thisWorkSummary":self.hasNotFinishField.textView.text ?? "",
                   "nextWorkPlan":self.needCoordinateField.textView.text ?? "",
                   "needHelp": self.weekNeedHelpField.textView.text ?? "",
                   "reportType":opt,
                   "userId":userID,
                   "newUserIds":userIdStr]
        }
        self.loadingPlay()
       
        
        self.uploadImage(type: self.curType, name: self.curName, param: par!)
        
    }
    
    
    //日报-获取某天日程
    fileprivate func getSchedulePlanByReportList() {
        let now = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormat.string(from: now)
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/schedule/getSchedulePlanByReportList" ,
            type: .get,
            param: ["userId":userID,
                    "date":dateStr],
            successCallBack: { (result) in
                
                
                var doneArray = [String]()
                for modalJson in result["data"]["donePlanItemContentData"].arrayValue {
                    let planItemContents = modalJson["planItemContents"].arrayValue
                    for(_,item) in planItemContents.enumerated(){
                        doneArray.append(item.stringValue)
                    }
                }
                var doneStr = ""
                for str in doneArray{
                    doneStr += str + "\n"
                }
                self.todayFinishWorkField.textView.text = doneStr
                self.todayFinishWorkField.textView.textColor = UIColor.black
                var undoArray = [String]()
                for modalJson in result["data"]["undoPlanItemContentData"].arrayValue {
                    let planItemContents = modalJson["planItemContents"].arrayValue
                    for(index,item) in planItemContents.enumerated(){
                        undoArray.append(item.stringValue)
                    }
                }

                var undoStr = ""
                for (_,str) in undoArray.enumerated(){
                    undoStr += str + "\n"
                }
                self.hasNotFinishField.textView.text = undoStr
                self.hasNotFinishField.textView.textColor = UIColor.black
                self.table.reloadData()
        }) { (error) in
            self.table.reloadData()
           
        }
    }
}

extension CQWriteReportVC:UITextFieldDelegate,KeyBoardDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        return true
        if string == "\n" {
            return false
        }
        return true
    }
    
    
    
    @objc func textFieldEditChanged(obj:Notification)  {
        
    }
    
    
}



// MARK: - 代理

extension CQWriteReportVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userArray.count + 1
    }
    
}

extension CQWriteReportVC: UICollectionViewDelegate {
    
    
    
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
                cell.deleteBtn.isHidden = false
                cell.deleteDelegate = self
                cell.nameLab.text = self.userArray[indexPath.row].realName
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.userArray.count == 0 {
            if indexPath.row == 0 {
//                let vc = AddressBookVC.init()
//                vc.toType = .fromReport
                let vc = QRAddressBookVC.init()
                vc.toType = .fromGenJin
                vc.hasSelectModelArr = self.userArray
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            if indexPath.row == self.userArray.count{
//                let vc = AddressBookVC.init()
//                vc.toType = .fromReport
                let vc = QRAddressBookVC.init()
                vc.toType = .fromGenJin
                vc.hasSelectModelArr = self.userArray
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                
            }
        }
        
        
    }
}

extension CQWriteReportVC:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
}

extension CQWriteReportVC:CQSelectDeleteDelegate{
    func deleteCollectionCell(index: IndexPath) {
        self.userIdArr.remove(at:index.item)
        self.userArray.remove(at: index.item)
        
        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75) + AutoGetHeight(height: 68))
        self.table.tableHeaderView = self.headView
        if self.wirteType == .week || self.wirteType == .month{
            self.sendView.frame = CGRect.init(x: 0, y: self.attachView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 70) + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
        }else{
            self.sendView.frame = CGRect.init(x: 0, y:self.attachView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 70) + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
        }
        
        self.collectionView.frame = CGRect.init(x: kLeftDis, y: self.sendToWhoLab.bottom + AutoGetHeight(height: 14), width: kHaveLeftWidth, height: AutoGetHeight(height: 14) + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
        self.table.reloadData()
        self.collectionView.reloadData()
    }
}


//关于图片视频上传
extension CQWriteReportVC{
    func takePhoto() {
        let alertSheet = UIAlertController(title: "", message: "请选择上传类型", preferredStyle: UIAlertControllerStyle.actionSheet)
        // 2 命令（样式：退出Cancel，警告Destructive-按钮标题为红色，默认Default）
        let cancelAction = UIAlertAction(title: "取消", style:  .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "上传图片", style:  .default, handler:{
            action in
            self.photoLib()
        })
        
        let archiveAction = UIAlertAction(title: "上传视频", style: .default, handler: {
            action in
            self.videoLib()
        })
        
        alertSheet.addAction(cancelAction)
        alertSheet.addAction(deleteAction)
        alertSheet.addAction(archiveAction)
        // 3 跳转
        self.present(alertSheet, animated: true, completion: nil)
    }
    
    
    //图库 - 照片
    func photoLib(){
        //
        flag = "图片"
        //判断设置是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //弹出控制器，显示界面
            self.present(picker, animated: true, completion: nil)
        }else{
            print("读取相册错误")
        }
    }
    
    
    //图库 - 视频
    func videoLib(){
        flag = "视频"
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            //初始化图片控制器
            let imagePicker = UIImagePickerController()
            //设置代理
            imagePicker.delegate = self
            //指定图片控制器类型
            imagePicker.sourceType = .photoLibrary;
            //只显示视频类型的文件
            imagePicker.mediaTypes =  [kUTTypeMovie as String]
            //不需要编辑
            imagePicker.allowsEditing = false
            //弹出控制器，显示界面
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            print("读取相册错误")
        }
    }
    
    
    /// 转换视频
    ///
    /// - Parameters:
    ///   - inputPath: 输入url
    ///   - outputPath:输出url
    func transformMoive(inputPath:String,outputPath:String){
        
        
        let avAsset:AVURLAsset = AVURLAsset(url: URL.init(fileURLWithPath: inputPath), options: nil)
        let assetTime = avAsset.duration
        
        let duration = CMTimeGetSeconds(assetTime)
        print("视频时长 \(duration)");
        let compatiblePresets = AVAssetExportSession.exportPresets(compatibleWith: avAsset)
        if compatiblePresets.contains(AVAssetExportPresetLowQuality) {
            let exportSession:AVAssetExportSession = AVAssetExportSession.init(asset: avAsset, presetName: AVAssetExportPresetMediumQuality)!
            let existBool = FileManager.default.fileExists(atPath: outputPath)
            if existBool {
            }
            exportSession.outputURL = URL.init(fileURLWithPath: outputPath)
            
            
            exportSession.outputFileType = AVFileType.mp4
            exportSession.shouldOptimizeForNetworkUse = true;
            exportSession.exportAsynchronously(completionHandler: {
                
                switch exportSession.status{
                    
                case .failed:
                    
                    print("失败...\(String(describing: exportSession.error?.localizedDescription))")
                    break
                case .cancelled:
                    print("取消")
                    break;
                case .completed:
                    print("转码成功")
                    self.mp4Path = URL.init(fileURLWithPath: outputPath)
                    let now = Date()
                    let dateFormat = DateFormatter()
                    dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
                    var current = ""
                    current = dateFormat.string(from: now)
                    let realName = STUserTool.account().realName
                    var name = ""
                    name = realName + " " + current + ".mp4"
                    self.curType = "video"
                    self.curName = name
                    DispatchQueue.main.async {
                        self.attachView.setTitle("    " + self.curName, for: .normal)
                    }
                    break;
                default:
                    print("..")
                    break;
                }
            })
        }
    }
}

extension CQWriteReportVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if flag == "视频" {
            
            //获取选取的视频路径
            let videoURL = info[UIImagePickerControllerMediaURL] as! URL
            let pathString = videoURL.path
            print("视频地址：\(pathString)")
            //图片控制器退出
            self.dismiss(animated: true, completion: nil)
            let outpath = NSHomeDirectory() + "/Documents/\(Date().timeIntervalSince1970).mp4"
            //视频转码
            self.transformMoive(inputPath: pathString, outputPath: outpath)
            
        }else{
            //flag = "图片"
            
            //获取选取后的图片
            let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.imageUrl = pickedImage
            //上传
            let now = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
            var current = ""
            current = dateFormat.string(from: now)
            let realName = STUserTool.account().realName
            var name = ""
            name = realName + " " + current + ".png"
            self.attachView.setTitle("    " + name, for: .normal)
            self.curType = "image"
            self.curName = name
            //图片控制器退出
            self.dismiss(animated: true, completion:nil)
        }
        
    }
    
    
}

//图片上传 与 视频 上传
extension CQWriteReportVC{
    //上传文件
    @objc func uploadImage(type:String,name:String,param:[String : Any])  {
        let userID = STUserTool.account().userID
        let urlUpload = "\(baseUrl)/personnelReport/savePersonnelReport"
        let headers = ["t_userId":userID,
                       "token":STUserTool.account().token]
        Alamofire.upload(multipartFormData: { formData in

            if type == "image"{
                let imageData = UIImageJPEGRepresentation(self.imageUrl!, 0.3)
                    formData.append(imageData!, withName: "file", fileName:name, mimeType: "image/jpg")
            }else if type == "video"{
                formData.append(self.mp4Path!, withName: "file", fileName: name, mimeType: "video/mp4")
            }
            
            
            
            for (key, value) in param {
                if key != "userIds"{
                    formData.append(((value as! String).data(using: .utf8)!), withName: key)
                }
            }
            DLog(formData)
        }, to: urlUpload, headers: headers, encodingCompletion: {encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    self.loadingSuccess()
                    
                    guard let result = response.result.value else {
                        SVProgressHUD.showError(withStatus: "服务器有点问题")
                        return
                    }
                    let json = JSON(result)
                    if json["success"].boolValue {
                        SVProgressHUD.showInfo(withStatus: json["message"].stringValue)
                        NotificationCenter.default.post(name: NSNotification.Name.init("refreshReprotFromWrite"), object: nil)
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        SVProgressHUD.showError(withStatus: json["message"].stringValue)
                    }
                    
                    
                    
                 //ruan   SVProgressHUD.showInfo(withStatus: "添加成功")
                   
                }
            case .failure( _):
                self.loadingSuccess()
                SVProgressHUD.showError(withStatus: "上传失败,请稍后重试")
            }
        })
    }
}


//
//  CQScheduleDetailVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/10.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQScheduleDetailVC: SuperVC {

    var selectModel:QRSecheduleModel?
    var allMod:CQScheduleModel?
    var userArray = [CQScheduleUserModel]()
    //留言模型数组
    var commentDataArr = [CQCommentModel]()
    //留言数量
    var leverMessageCount = ""
    
    //外勤记录
    var outRecorderArr = [QROutRecorderModel]()
    var outRecorderUseArr = [QROutRecorderModel]()
    var jiantou = UIButton()
    var isZhanKai = false
    
    var schedulePlanId = ""
    var pageNum = 1
    var commentArray = [CQCommentModel]()
    var isFromRecieve = false
    var reasonV:CQScheduleUnagreeView?
    var planType = ""
    var meetingRoomId = ""
    var isFromApp = false
    var reasonType = "" //0为不同意原因   1为未完成原因
    lazy var picview : QRNetImgPicView={
        let pic = QRNetImgPicView(width: kWidth/3*2)
        return pic
    }()
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - AutoGetHeight(height: 45) - SafeAreaBottomHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        table.backgroundColor = kProjectBgColor
        weak var weakSelf = self
        table.delegate = weakSelf
        table.dataSource = weakSelf
        table.estimatedSectionHeaderHeight = 0;
        table.estimatedSectionFooterHeight = 0;
        table.estimatedRowHeight = 0;
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.allowsSelection = false
        table.register(UINib(nibName: "QROutRecorderCell", bundle: nil), forCellReuseIdentifier: "outRecorder")
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 170)))
        headView.backgroundColor = UIColor.white
        return headView
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 0), width: kHaveLeftWidth, height: AutoGetHeight(height: 45)))
        nameLab.text = ""
        nameLab.numberOfLines = 0
        nameLab.textColor = UIColor.black
        nameLab.textAlignment = .left
        nameLab.font = kFontSize18
        return nameLab
    }()
    
    lazy var addScheduleV : QRAddScheduleView = {
     let addSchedule = QRAddScheduleView(frame:  CGRect(x: 0, y: self.nameLab.bottom+5, width: kWidth, height: 100))
        addSchedule.isAdd = false
        addSchedule.isDetail = true
        addSchedule.clipsToBounds = true
        addSchedule.table.tableFooterView = UIView()
        return addSchedule
    }()
    
    lazy var contentLab: UILabel = {
        let contentLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.addScheduleV.bottom + AutoGetHeight(height: 0), width: kHaveLeftWidth, height: AutoGetHeight(height: 70)))
        contentLab.text = ""
        contentLab.textColor = kLyGrayColor
        contentLab.numberOfLines = 0
        contentLab.textAlignment = .left
        contentLab.font = kFontSize15
        return contentLab
    }()
    
    
          
    
    lazy var lineView: UIView = {
        let lineView = UIView.init(frame: CGRect(x: 0, y: contentLab.bottom+AutoGetHeight(height: 8), width: kWidth, height: AutoGetHeight(height: 1)))
        lineView.backgroundColor = kProjectBgColor
       // lineView.isHidden = true
        return lineView
    }()
    
    lazy var beginLab: UILabel = {
        let beginLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.lineView.bottom + AutoGetHeight(height: 10), width: AutoGetWidth(width: 30), height: AutoGetHeight(height: 13)))
        beginLab.text = "开始"
        beginLab.textColor = kLyGrayColor
        beginLab.textAlignment = .left
        beginLab.font = kFontSize13
        return beginLab
    }()
    
    lazy var startLab: UILabel = {
        let startLab = UILabel.init(frame: CGRect.init(x: self.beginLab.right + AutoGetWidth(width: 1), y:self.lineView.bottom + AutoGetHeight(height: 0), width: AutoGetWidth(width: 100), height: AutoGetHeight(height: 13)))
        startLab.text = ""
        startLab.textColor = UIColor.black
        startLab.textAlignment = .left
        startLab.font = kFontSize13
        startLab.adjustsFontSizeToFitWidth = true
        return startLab
    }()
    
    lazy var finishLab: UILabel = {
        let finishLab = UILabel.init(frame: CGRect.init(x: self.beginLab.right, y:self.beginLab.top + AutoGetHeight(height: 0), width: AutoGetWidth(width: 30), height: AutoGetHeight(height: 13)))
        finishLab.text = "结束"
        finishLab.textColor = kLyGrayColor
        finishLab.textAlignment = .left
        finishLab.font = kFontSize13
        return finishLab
    }()
    
    lazy var endLab: UILabel = {
        let endLab = UILabel.init(frame: CGRect.init(x: self.finishLab.right + AutoGetWidth(width: 1), y:self.startLab.bottom + AutoGetHeight(height: 0), width: AutoGetWidth(width: 100), height: AutoGetHeight(height: 13)))
        endLab.text = ""
        endLab.textColor = UIColor.black
        endLab.textAlignment = .left
        endLab.font = kFontSize13
        endLab.adjustsFontSizeToFitWidth = true
        return endLab
    }()
    
    lazy var locationImg: UIImageView = {
        let locationImg = UIImageView.init(frame: CGRect.init(x: kLeftDis, y: self.startLab.bottom + AutoGetHeight(height: 11), width: AutoGetWidth(width: 14.5), height: AutoGetHeight(height: 18.5)))
        locationImg.image = UIImage.init(named: "FieldPersonelLocation")
        return locationImg
    }()
    
    lazy var locationLab: UILabel = {
        let locationLab = UILabel.init(frame: CGRect.init(x: self.locationImg.right + AutoGetWidth(width: 8), y: self.startLab.bottom + AutoGetHeight(height: 13.5), width: kWidth - AutoGetWidth(width: 102), height: AutoGetHeight(height: 13)))
        locationLab.text = ""
        locationLab.textColor = UIColor.black
        locationLab.textAlignment = .left
        locationLab.font = kFontSize13
        return locationLab
    }()
    
    lazy var carRequestImg: UIImageView = {
        let carRequestImg = UIImageView.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 55.5), y: self.contentLab.bottom + AutoGetHeight(height: 18+9+15), width: AutoGetWidth(width: 20.5), height: AutoGetHeight(height: 19)))
        carRequestImg.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(carAskClick))
        carRequestImg.addGestureRecognizer(tap)
        carRequestImg.image = UIImage.init(named: "CQScheduleCar")
        return carRequestImg
    }()
    
    lazy var carBtn: UIButton = {
        let carBtn = UIButton.init(type: .custom)
        carBtn.frame = CGRect.init(x: kWidth - AutoGetWidth(width: 60.5), y: self.carRequestImg.bottom + AutoGetHeight(height: 3), width: AutoGetWidth(width: 30.5), height: AutoGetHeight(height: 15))
        carBtn.setTitle("派车", for: .normal)
        carBtn.setTitleColor(UIColor.colorWithHexString(hex: "#ffa421"), for: .normal)
        carBtn.titleLabel?.font = kFontSize13
        carBtn.titleLabel?.textAlignment = .center
        carBtn.addTarget(self, action: #selector(carAskClick), for: .touchUpInside)
        return carBtn
    }()
    //录音button
    lazy var recodeBtn: UIButton = {
        let recodeBtn = UIButton.init(type: .custom)
        recodeBtn.frame = CGRect.init(x: kLeftDis, y: contentLab.bottom+10, width: kHaveLeftWidth*0.7, height: AutoGetHeight(height: 45))
        recodeBtn.setTitle("语音", for: UIControlState.normal)
        recodeBtn.addTarget(self, action: #selector(recordeChoose(btn:)), for: .touchUpInside)
        return recodeBtn
    }()
    
    lazy var footView: UIView = {
        let footView = UIView.init(frame: CGRect.init(x: 0, y: kHeight - SafeAreaBottomHeight - AutoGetHeight(height: 45), width: kWidth, height: AutoGetHeight(height: 45) + SafeAreaBottomHeight))
        footView.backgroundColor = UIColor.white
        return footView
    }()
    
    lazy var recoredTableView : QRRecordTableView = {
        let recordTab = Bundle.main.loadNibNamed("QRRecordTableView", owner: nil, options: nil)?.last as! QRRecordTableView
        recordTab.frame =  CGRect(x: 0, y: self.picview.bottom, width: kWidth, height:54)
        
        return recordTab
    }()
    //考勤视图界面
    lazy var SignView: QRScheduleFoldView = {
        let SignView = Bundle.main.loadNibNamed("QRScheduleFoldView", owner: nil, options: nil)?.last as! QRScheduleFoldView
        SignView.frame =  CGRect(x: 0, y: self.locationLab.bottom+5, width: kWidth, height:61 )
        SignView.detailView.isHidden = true
        SignView.backgroundColor = UIColor.white
        return SignView
    }()
    
    @objc func recordeChoose(btn:UIButton){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.addScheduleV)
        self.headView.addSubview(self.nameLab)
        self.headView.addSubview(self.contentLab)
        self.headView.addSubview(self.lineView)
        self.headView.addSubview(self.picview)
        self.headView.addSubview(self.recoredTableView)
        self.headView.addSubview(self.beginLab)
        self.headView.addSubview(self.startLab)
        self.headView.addSubview(self.finishLab)
        self.headView.addSubview(self.endLab)
        self.headView.addSubview(self.locationImg)
        self.headView.addSubview(self.locationLab)
        
        //签到详情view
     //   self.headView.addSubview(self.SignView)
      
        
        self.view.addSubview(self.footView)

        self.table.register(CQScheduleDetailCell.self, forCellReuseIdentifier: "CQScheduleDetailCellId")
        self.table.register(CQScheduleDetailCell.self, forCellReuseIdentifier: "CQLYScheduleDetailCellId")
        loadDatas(moreData: false)
        self.table.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CQScheduleDetailFooter")
        NotificationCenter.default.addObserver(self, selector: #selector(updateImages(notification:)), name: NSNotification.Name(rawValue: "imagsCellID"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openFold(notification:)), name: NSNotification.Name(rawValue: "openFold"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reflashFriendCircle(notification:)), name: NSNotification.Name.init("reflashFriendCircle"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateScheduleHeight(notif:)), name: NSNotification.Name.init("scheduleUpdateHeight"), object: nil)
       
        NotificationCenter.default.addObserver(self, selector: #selector(updatescheduleUpdateSelectIndexStatus(notif:)), name: NSNotification.Name.init("scheduleUpdateSelectIndexStatus"), object: nil)
        
        
        
    }
    
    @objc func updatescheduleUpdateSelectIndexStatus(notif:NSNotification){
        let index = notif.userInfo!["index"] as! IndexPath
        let mod = allMod?.planItemData[index.row]
        self.selectModel = mod
        if mod!.finishStatus{
            self.reasonType = "1"
            self.initReasonView()
           
        }else{
            var msg = ""
           if self.planType == "1"{
              msg = "是否将日程标记为完成"
           }else{
              msg = "是否将会议标记为完成"
           }
           let alertVC = UIAlertController.init(title: "", message: msg, preferredStyle: UIAlertControllerStyle.alert)
           let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
           let okAction = UIAlertAction.init(title: "确定", style: .default) { (action) in
            self.planItemIsfinishRequest(txt: "", schedukeModel: mod!)
           }
           alertVC.addAction(cancelAction)
           alertVC.addAction(okAction)
           self.present(alertVC, animated: true, completion: nil)
    
          
        }
        
        
        
       
        
    }
    
    @objc func updateScheduleHeight(notif: NSNotification) {

//             let scheduleHeight = notif.userInfo!["height"] as! CGFloat
//            self.addScheduleV.frame =  CGRect(x: 0, y:  self.nameLab.bottom+18, width: kWidth, height: scheduleHeight)
//           self.addScheduleV.frame = CGRect.init(x: 0, y:self.nameLab.bottom + 18, width: kWidth, height: self.addScheduleV.calculateHeight())
//           self.addScheduleV.table.frame = CGRect.init(x: 0, y:0, width: kWidth, height: self.addScheduleV.calculateHeight()-54)
//           self.contentLab.frame = CGRect.init(x: kLeftDis, y:self.addScheduleV.bottom + 0, width: kHaveLeftWidth, height: 0)
        
//            var picheight:CGFloat = 0
//               if model.planType == "1"{
//                    //日程//图片判断
//                   if model.imgFiles.count > 0{
//                       self.picview.isHidden = false
//                       self.picview.imags = model.imgFiles
//                       self.picview.frame =  CGRect(x: kLeftDis, y: self.contentLab.bottom+AutoGetWidth(width: 10), width: kWidth/3*2, height: self.picview.pictureViewHeight)
//                       picheight = self.picview.pictureViewHeight+AutoGetHeight(height: 14)
//                   }else{
//                       self.picview.isHidden = true
//                       self.picview.frame =  CGRect(x: kLeftDis, y: self.contentLab.bottom, width: kWidth/3*2, height: 0)
//                       picheight = 0
//                   }
//               }else{
//                   self.picview.isHidden = true
//                   self.picview.frame =  CGRect(x: kLeftDis, y: self.contentLab.bottom, width: kWidth/3*2, height: 0)
//                   picheight = 0
//               }
               
               //录音table
//               var recordHeight:CGFloat = 0
//               if allMod.planType == "1"{
//
//                   if soundModel.audioFiles.count > 0{
//                       self.recoredTableView.isHidden = false
//                       self.recoredTableView.dataArr = soundMod
//                       self.recoredTableView.table.reloadData()
//                       self.recoredTableView.frame = CGRect(x: 0, y: self.picview.bottom+AutoGetWidth(width:10), width: kWidth, height: AutoGetHeight(height: 55)*CGFloat(soundModel.audioFiles.count))
//                       recordHeight = AutoGetHeight(height: 55)*CGFloat(soundModel.audioFiles.count)
//                   }else{
//                       self.recoredTableView.isHidden = true
//                       self.recoredTableView.frame =  CGRect(x: 0, y: self.picview.bottom+AutoGetWidth(width: 10), width: kWidth, height: 0)
//                       recordHeight = 0
//                   }
//               }else{
//                   self.recoredTableView.isHidden = true
//                   self.recoredTableView.frame =  CGRect(x: 0, y: self.picview.bottom+AutoGetWidth(width: 14), width: kWidth, height: 0)
//                   recordHeight = 0
//               }
//
//
//               self.lineView.frame =  CGRect.init(x: 0, y:self.recoredTableView.bottom+AutoGetHeight(height: 0) , width: kWidth, height: AutoGetHeight(height: 1))
//               self.beginLab.frame =  CGRect.init(x: kLeftDis, y:self.lineView.bottom + AutoGetHeight(height: 13), width: AutoGetWidth(width: 30), height: AutoGetHeight(height: 16))
//               self.startLab.frame = CGRect.init(x: self.beginLab.right + AutoGetWidth(width: 1), y:self.lineView.bottom + AutoGetHeight(height: 13), width: AutoGetWidth(width: 100), height: AutoGetHeight(height: 16))
//               self.finishLab.frame =  CGRect.init(x: self.beginLab.left + AutoGetWidth(width: 0), y:self.beginLab.bottom + AutoGetHeight(height: 10), width: AutoGetWidth(width: 30), height: AutoGetHeight(height: 16))
//               self.endLab.frame = CGRect.init(x: self.finishLab.right + AutoGetWidth(width: 1), y:self.finishLab.top, width: AutoGetWidth(width: 100), height: AutoGetHeight(height: 16))
//               self.locationImg.frame = CGRect.init(x: kLeftDis, y: self.finishLab.bottom + AutoGetHeight(height: 11), width: AutoGetWidth(width: 14.5), height: AutoGetHeight(height: 18.5))
//               self.locationLab.frame = CGRect.init(x: self.locationImg.right + AutoGetWidth(width: 8), y: self.endLab.bottom + AutoGetHeight(height: 13.5), width: kWidth - AutoGetWidth(width: 102), height: AutoGetHeight(height: 13))
//
//               self.carRequestImg.frame = CGRect.init(x: kWidth - AutoGetWidth(width: 55.5), y: self.lineView.bottom + AutoGetHeight(height: 18), width: AutoGetWidth(width: 20.5), height: AutoGetHeight(height: 19))
//               self.carBtn .frame = CGRect.init(x: kWidth - AutoGetWidth(width: 60.5), y: self.carRequestImg.bottom + AutoGetHeight(height: 3), width: AutoGetWidth(width: 30.5), height: AutoGetHeight(height: 15))
//
//
//               self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: self.locationLab.bottom+15)
                           
        
        
        
//            self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: self.locationLab.bottom+15)
//             self.table.tableHeaderView = headView
         }
    
    @objc func reflashFriendCircle(notification:Notification){
         self.loadDatas(moreData: false)
    }
    
    @objc func updateImages(notification:NSNotification){
        let index = notification.userInfo?["index"] as? Int
        let imgs = notification.userInfo?["imags"] as? [String]
        if let index = index ,let imags = imgs, imags.count > 0{
            let previewVC = ImagePreViewVC(images: imags, index: index)
            self.navigationController?.pushViewController(previewVC, animated: true)
        }
    }
    
  
   
    //展开和折叠
    @objc func openFold(notification:NSNotification){
        let fold = notification.userInfo!["fold"] as! Bool
        if fold{
            //展开
            self.SignView.frame =  CGRect(x: 0, y: self.locationLab.bottom+5, width: kWidth, height: 243.5)
            self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: self.SignView.bottom + AutoGetHeight(height: 15))
            table.tableHeaderView =  self.headView
        }else{
            //收缩
            self.SignView.frame =  CGRect(x: 0, y: self.locationLab.bottom+5, width: kWidth, height: self.SignView.lineView.bottom)
            self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: self.SignView.bottom + AutoGetHeight(height: 0))
            table.tableHeaderView =  self.headView
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        QRMusicPlay.shared.player?.onStateChange = {state in
        }
        QRMusicPlay.shared.stopMusic()
       
        LGAudioPlayer.share()?.stop()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isFromApp {
            self.navigationItem.leftBarButtonItem = self.barBackButton()
        }

        loadDetailData()
        
    }

    
    func initFootView(index:Int)  {
        let imgArr = ["CQScheduleMessage","CQScheduleFail","CQScheduleFinish"]
        let titleArr = ["留言","未完成","完成"] // ["留言"]
        for i in 0..<index {
            let img = UIImageView.init(frame: CGRect.init(x: (kWidth/(CGFloat(index)) - AutoGetWidth(width: 21))/2 + kWidth/(CGFloat(index)) * CGFloat(i), y: AutoGetHeight(height: 4), width: AutoGetWidth(width: 21), height: AutoGetWidth(width: 21)))
            img.image = UIImage.init(named: imgArr[i])
            self.footView.addSubview(img)
            
            let lab = UILabel.init(frame: CGRect.init(x: kWidth/(CGFloat(index)) * CGFloat(i), y: img.bottom + AutoGetHeight(height: 3), width: kWidth/(CGFloat(index)), height: AutoGetHeight(height: 13)))
            lab.text = titleArr[i]
            lab.textColor = kLightBlueColor
            lab.textAlignment = .center
            lab.font = kFontSize13
            self.footView.addSubview(lab)
            
            let btn = UIButton.init(type: .custom)
            btn.frame = CGRect.init(x: kWidth/(CGFloat(index)) * CGFloat(i), y: 0, width: kWidth/(CGFloat(index)), height: AutoGetHeight(height: 45))
            btn.tag = 500 + i
            btn.addTarget(self, action: #selector(footChoose(btn:)), for: .touchUpInside)
            self.footView.addSubview(btn)
        }
        let line = UIView(frame:  CGRect(x: 0, y: 0, width: kWidth, height: 0.7))
        line.backgroundColor = kLineColor
        self.footView.addSubview(line)
    }
    
    @objc func editingClick() {
        if self.planType == "1"{
            let vc = CQCreateScheduleVC()
            vc.type = .update
            vc.schedulePlanId = self.schedulePlanId
            self.navigationController?.pushViewController(vc, animated: true)
        }else if self.planType == "2"{
            let vc = CQCreateMeetingVC()
            vc.type = .update
            vc.schedulePlanId = self.schedulePlanId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc func carAskClick()  {
        let vc = CQCarApplyVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func footChoose(btn:UIButton) {
        if btn.tag == 500 {

            var items = ["文字输入","语音输入"]
            if self.planType == "1"{
                items = ["文字输入","语音输入"]
            }else{
                items = ["文字输入"]
            }
            let vProperty = FWSheetViewProperty()
            vProperty.touchWildToHide = "1"
            let sheetView = FWSheetView.sheet( title:"", itemTitles: items, itemBlock: {[unowned self] (popupView, index, title) in
                if index == 0{
//                    let vc = CQLeavingMessageVC.init()
//                    vc.schedulePlanId = self.schedulePlanId
//                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    let vc = QRAddGenJinVC()
                    vc.fromType = .fromMessage
                    vc.schedulePlanId = self.schedulePlanId
                    vc.titleStr = "留言"
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else if index == 1{
                    let recordView = (Bundle.main.loadNibNamed("QRSoundRecordView", owner: nil, options: nil)?.last as! QRRecordSoundView)
                    recordView.schedulePlanId = self.schedulePlanId
                    recordView.frame =  CGRect(x: 0, y: 0, width: kWidth, height: kHeight)
//                    let app = UIApplication.shared.delegate as! AppDelegate
//                    app.window?.addSubview(recordView)
                    self.view.addSubview(recordView)
                    recordView.clickClosure = {[unowned self]close in
                        self.loadDatas(moreData: false)
                    }
                }else{

                }
            }, cancenlBlock: {

            }, property: vProperty)
            sheetView.show()
        }else if btn.tag == 501{
            self.reasonType = "1"
            self.initReasonView()
        }else if btn.tag == 502{
            var msg = ""
            if self.planType == "1"{
               msg = "是否将日程标记为完成"
            }else{
               msg = "是否将会议标记为完成"
            }

            let alertVC = UIAlertController.init(title: "", message: msg, preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction.init(title: "确定", style: .default) { (action) in
                self.planIsfinishRequest(txt: "", finishStatus: "2")
            }
            alertVC.addAction(cancelAction)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
}

extension CQScheduleDetailVC{
    fileprivate func loadDetailData() {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/schedule/getSchedulePlanDetails" ,
            type: .get,
            param: ["schedulePlanId":self.schedulePlanId,
                    "userId":userID],
            successCallBack: { (result) in
                guard let model = CQScheduleModel.init(jsonData: result["data"]) else {
                    return
                }
                
                self.allMod = model
                self.outRecorderUseArr = model.outRecordJsons
                guard let soundModel = QRSoundModel.init(jsonData: result["data"]["audioFiles"]) else {
                    return
                }
                var soundMod = [QRSoundModel]()
                for (_,value) in result["data"]["audioFiles"].arrayValue.enumerated(){
                   let mod = QRSoundModel()
                    mod.soundFilePath = value.stringValue
                    mod.second = Int((LGSoundRecorder.shareInstance()?.audioDuration(fromURL: value.stringValue)) ?? 1.0)
                    soundMod.append(mod)
                }
                
                
                if model.planType == "1"{
                    self.title = "日程详情"
                    self.locationLab.text = model.addressRemark
                    
                    //旧的日程的单条隐藏
                    
                    self.nameLab.text = model.planTitle
                    self.contentLab.text = model.planContent
                    let titleH = self.getTextHeigh(textStr: model.planTitle, font: kFontSize18, width: kHaveLeftWidth)
                    self.nameLab.frame = CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 18), width: kHaveLeftWidth, height: titleH)
                    
                    if model.planItemData.count == 0{
                        self.contentLab.isHidden = false
                        self.addScheduleV.isHidden = true
                        self.addScheduleV.frame = CGRect.init(x: 0, y:self.nameLab.bottom + 18, width: kWidth, height: 0)
                        let contentH = self.getTextHeigh(textStr: model.planContent, font: kFontSize15, width: kHaveLeftWidth)
                        self.contentLab.frame = CGRect.init(x: kLeftDis, y:self.addScheduleV.bottom + 10, width: kHaveLeftWidth, height: contentH)
                    }else{
            
                        self.contentLab.isHidden = true
                        self.addScheduleV.isHidden = false
                        self.addScheduleV.dataArray = model.planItemData
                        self.addScheduleV.table.reloadData()
                         
                        self.addScheduleV.table.layoutIfNeeded()
                        
                        self.addScheduleV.frame = CGRect.init(x: 0, y:self.nameLab.bottom + 18, width: kWidth, height: self.addScheduleV.calculateHeight()-54)
                        self.addScheduleV.table.frame = CGRect.init(x: 0, y:0, width: kWidth, height: self.addScheduleV.calculateHeight()-54)
                        self.contentLab.frame = CGRect.init(x: kLeftDis, y:self.addScheduleV.bottom + 0, width: kHaveLeftWidth, height: 0)
                    }
    
                }else{
                    self.addScheduleV.isHidden = true
                    self.title = "会议详情"
                    self.locationLab.text = model.meetingRoomName
                    self.meetingRoomId = model.meetingRoomId
                    
                    let titleH = self.getTextHeigh(textStr: model.planTitle, font: kFontSize18, width: kHaveLeftWidth)
                     self.nameLab.frame = CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 18), width: kHaveLeftWidth, height: titleH)
                    let contentH = self.getTextHeigh(textStr: model.planContent, font: kFontSize15, width: kHaveLeftWidth)
                    self.contentLab.frame = CGRect.init(x: kLeftDis, y:self.nameLab.bottom + AutoGetHeight(height: 18), width: kHaveLeftWidth, height: contentH)
                    self.nameLab.text = model.planTitle
                    self.contentLab.text = model.planContent
                }
                self.planType = model.planType
                //图片
                var picheight:CGFloat = 0
                if model.planType == "1"{
                     //日程//图片判断
                    if model.imgFiles.count > 0{
                        self.picview.isHidden = false
                        self.picview.imags = model.imgFiles
                        self.picview.frame =  CGRect(x: kLeftDis, y: self.contentLab.bottom+AutoGetWidth(width: 10), width: kWidth/3*2, height: self.picview.pictureViewHeight)
                        picheight = self.picview.pictureViewHeight+AutoGetHeight(height: 14)
                    }else{
                        self.picview.isHidden = true
                        self.picview.frame =  CGRect(x: kLeftDis, y: self.contentLab.bottom, width: kWidth/3*2, height: 0)
                        picheight = 0
                    }
                }else{
                    self.picview.isHidden = true
                    self.picview.frame =  CGRect(x: kLeftDis, y: self.contentLab.bottom, width: kWidth/3*2, height: 0)
                    picheight = 0
                }
                
                //录音table
                var recordHeight:CGFloat = 0
                if model.planType == "1"{
                    
                    if soundModel.audioFiles.count > 0{
                        self.recoredTableView.isHidden = false
                        self.recoredTableView.dataArr = soundMod
                        self.recoredTableView.table.reloadData()
                        self.recoredTableView.frame = CGRect(x: 0, y: self.picview.bottom+AutoGetWidth(width:10), width: kWidth, height: AutoGetHeight(height: 55)*CGFloat(soundModel.audioFiles.count))
                        recordHeight = AutoGetHeight(height: 55)*CGFloat(soundModel.audioFiles.count)
                    }else{
                        self.recoredTableView.isHidden = true
                        self.recoredTableView.frame =  CGRect(x: 0, y: self.picview.bottom+AutoGetWidth(width: 10), width: kWidth, height: 0)
                        recordHeight = 0
                    }
                }else{
                    self.recoredTableView.isHidden = true
                    self.recoredTableView.frame =  CGRect(x: 0, y: self.picview.bottom+AutoGetWidth(width: 14), width: kWidth, height: 0)
                    recordHeight = 0
                }
                
                
                self.lineView.frame =  CGRect.init(x: 0, y:self.recoredTableView.bottom+AutoGetHeight(height: 0) , width: kWidth, height: AutoGetHeight(height: 1))
                self.beginLab.frame =  CGRect.init(x: kLeftDis, y:self.lineView.bottom + AutoGetHeight(height: 13), width: AutoGetWidth(width: 30), height: AutoGetHeight(height: 16))
                self.startLab.frame = CGRect.init(x: self.beginLab.right + AutoGetWidth(width: 1), y:self.lineView.bottom + AutoGetHeight(height: 13), width: AutoGetWidth(width: 100), height: AutoGetHeight(height: 16))
                self.finishLab.frame =  CGRect.init(x: self.beginLab.left + AutoGetWidth(width: 0), y:self.beginLab.bottom + AutoGetHeight(height: 10), width: AutoGetWidth(width: 30), height: AutoGetHeight(height: 16))
                self.endLab.frame = CGRect.init(x: self.finishLab.right + AutoGetWidth(width: 1), y:self.finishLab.top, width: AutoGetWidth(width: 100), height: AutoGetHeight(height: 16))
                self.locationImg.frame = CGRect.init(x: kLeftDis, y: self.finishLab.bottom + AutoGetHeight(height: 11), width: AutoGetWidth(width: 14.5), height: AutoGetHeight(height: 18.5))
                self.locationLab.frame = CGRect.init(x: self.locationImg.right + AutoGetWidth(width: 8), y: self.endLab.bottom + AutoGetHeight(height: 13.5), width: kWidth - AutoGetWidth(width: 102), height: AutoGetHeight(height: 13))
                
                self.carRequestImg.frame = CGRect.init(x: kWidth - AutoGetWidth(width: 55.5), y: self.lineView.bottom + AutoGetHeight(height: 18), width: AutoGetWidth(width: 20.5), height: AutoGetHeight(height: 19))
                self.carBtn .frame = CGRect.init(x: kWidth - AutoGetWidth(width: 60.5), y: self.carRequestImg.bottom + AutoGetHeight(height: 3), width: AutoGetWidth(width: 30.5), height: AutoGetHeight(height: 15))
               

                self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: self.locationLab.bottom+15)
                
                self.startLab.text = model.startDate
                self.endLab.text = model.endDate
            
                var arr = [CQScheduleUserModel]()
                self.userArray.removeAll()
                
                for modalJson in result["data"]["userData"].arrayValue  {
                    guard let modal = CQScheduleUserModel(jsonData: JSON(modalJson)) else {
                        return
                    }
                    DLog(modal)
                    arr.append(modal)
                }
                
                if model.isCreateUser{
                    let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
                    rightBtn.titleLabel?.font = kFontSize17
                    rightBtn.setTitle("编辑", for: .normal)
                    rightBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: -15)
                    rightBtn.setTitleColor(UIColor.colorWithHexString(hex: "#20afff"), for: .normal)
                    rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
                    rightBtn.addTarget(self, action: #selector(self.editingClick), for: .touchUpInside)
                    let rightItem = UIBarButtonItem.init(customView: rightBtn)
                    self.navigationItem.rightBarButtonItem = rightItem
                    
                    if !model.addressRemark.isEmpty{
                        self.headView.addSubview(self.carRequestImg)
                        self.headView.addSubview(self.carBtn)
                    }
                }
                
                
                if model.isCreateUser && (model.finishStatus == "3" || model.finishStatus == "2"){
                    self.initFootView(index:1)
                }else if !model.isCreateUser{
                    self.initFootView(index:1)
                } else{
                    if self.planType == "1"{
                        self.initFootView(index:1)
                    }else{
                        self.initFootView(index: 3)
                    }
                    
                }
                
                
                
                self.userArray = arr
                self.table.tableHeaderView = self.headView
                self.table.reloadData()
                
        }) { (error) in
            
        }
    }
    
    //计算高度
    func getTextHeigh(textStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        let normalText: String = textStr
        let size = CGSize.init(width: width, height: 1000)
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context:nil).size
        return stringSize.height
    }
}

extension CQScheduleDetailVC{
    
//    fileprivate func loadComment() {
//        let STHeader = CQRefreshHeader{[unowned self] in
//            self.loadDatas(moreData: false)
//        }
//        let STFooter = CQRefreshFooter {[unowned self] in
//            self.loadDatas(moreData: true)
//        }
//        self.table.mj_header = STHeader
//        self.table.mj_footer = STFooter
//        self.table.mj_header.beginRefreshing()
//    }
    // MARK:request
    fileprivate func loadDatas(moreData: Bool) {
        if moreData {
            pageNum += 1
        } else {
            pageNum = 1
        }
        STNetworkTools.requestData(URLString:"\(baseUrl)/schedule/getScheduleCommentByPage" ,
            type: .get,
            param: ["currentPage":pageNum,
                    "rows":"100",
                    "schedulePlanId":self.schedulePlanId],
            successCallBack: { (result) in
                self.commentArray.removeAll()
                var tempArray = [CQCommentModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQCommentModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                
                self.commentDataArr = tempArray
                
               
                if moreData {
                    self.commentDataArr.append(contentsOf: tempArray)
                } else {
                    self.commentDataArr = tempArray
                }

                self.table.reloadSections(IndexSet(integer: 2), with: UITableViewRowAnimation.none)
                
        }) { (error) in
            self.table.reloadSections(IndexSet(integer: 1), with: UITableViewRowAnimation.none)

        }
    }
    
    
    func planIsfinishRequest(txt:String,finishStatus:String) {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/schedule/setSchedulePlanIsfinishSign",
            type: .post,
            param: ["userId":userID,
                    "schedulePlanId":self.schedulePlanId,
                    "finishStatus":finishStatus,
                    "planRemark":txt],
            successCallBack: { (result) in
                self.reasonV?.removeFromSuperview()
                SVProgressHUD.showInfo(withStatus: "设置成功")
                self.footView.removeAllSubviews()
                //刷新日程首页
            NotificationCenter.default.post(name: NSNotification.Name.init("refreshScheduleUI"), object: nil)
                
                self.loadDetailData()
                self.table.reloadData()
        }) { (error) in
            
        }
    }
    
    
    
    func planItemIsfinishRequest(txt:String,schedukeModel:QRSecheduleModel) {
              let userID = STUserTool.account().userID
                var finishStatus = ""
                if schedukeModel.finishStatus{
                    finishStatus = "1"
                }else{
                    finishStatus = "2"
                }
              STNetworkTools.requestData(URLString: "\(baseUrl)/schedule/setSchedulePlanItemIsfinishSign",
                  type: .post,
                  param: ["userId":userID,
                    "schedulePlanItemId":schedukeModel.schedulePlanItemId,
                          "finishStatus":finishStatus,
                          "planItemRemark":txt],
                  successCallBack: { (result) in
                      self.reasonV?.removeFromSuperview()
                      SVProgressHUD.showInfo(withStatus: "设置成功")
                      self.footView.removeAllSubviews()
                      //刷新日程首页
                      NotificationCenter.default.post(name: NSNotification.Name.init("refreshScheduleUI"), object: nil)
                      
                      self.loadDetailData()
                      self.table.reloadData()
              }) { (error) in
                  
              }
           }
    
    
    
    
}

extension CQScheduleDetailVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
          return outRecorderArr.count
        }else if section == 1{
           return self.userArray.count
        }else {
           return self.commentDataArr.count
        }
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CQScheduleDetailCellId") as! CQScheduleDetailCell
            cell.model = self.userArray[indexPath.row]
            cell.selectionStyle = .none
            cell.agreeDelegate = self
            return cell
        }else if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "outRecorder", for: indexPath) as! QROutRecorderCell
            cell.model = outRecorderArr[indexPath.row]
            return cell
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CQLYScheduleDetailCellId") as! CQScheduleDetailCell
            let model = self.commentDataArr[indexPath.row]
            cell.modelLeave = model
            cell.iconImg.sd_setImage(with: URL(string: model.headImage ), placeholderImage:UIImage.init(named: "personDefaultIcon") )
            cell.nameLab.text = model.realName
            cell.contentLab.text =  model.commentContent
            cell.timeLab.text = model.commentTime
            if model.path == ""{
                cell.soundView.isHidden = true
            }else{
                cell.soundView.isHidden = false
                cell.soundView.frame =  CGRect(x: cell.nameLab.left, y: cell.nameLab.bottom+5, width: 130, height: 35)
                let mod = QRSoundModel()
                mod.soundFilePath = model.path
                mod.second = Int((LGSoundRecorder.shareInstance()?.audioDuration(fromURL: model.path)) ?? 1.0)
                cell.soundModel = mod
            }
            return cell
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            let mod = self.outRecorderArr[indexPath.row]
            return mod.rowheight
        }else if indexPath.section == 1 {
            return AutoGetHeight(height: 70)
        }else{
            let mod = self.commentDataArr[indexPath.row]
            return mod.rowHeight
        }
        
    }
    
   
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AutoGetHeight(height: 51)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView()
        header.backgroundColor = kProjectBgColor
        let bgV = UIView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 38)))
        bgV.backgroundColor = UIColor.white
        header.addSubview(bgV)
        let lab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kWidth, height: AutoGetHeight(height: 38)))
        lab.textAlignment = .left
        lab.textColor = UIColor.black
        lab.font = kFontSize15
        bgV.addSubview(lab)
        if section == 1{
            lab.text = "参与人员"
        }else if section == 0{
            lab.text = "外出详情"
             let jianTou = UIButton(frame:  CGRect(x: kWidth-12.5-15, y: (38-12.5)/2, width: 12.5, height: 12.5))
                jianTou.setImage(UIImage(named: "jtb"), for: UIControlState.normal)
                jianTou.setImage(UIImage(named: "zk"), for: UIControlState.selected)
            self.jiantou = jianTou
             bgV.addSubview(jianTou)
            jiantou.isSelected = isZhanKai
             lab.isUserInteractionEnabled = true
             let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapTouchIn))
             lab.addGestureRecognizer(tapGes)
        }else{
            lab.text = "留言" + String(self.commentDataArr.count)
         }
        
       
        let line = UIView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 38) - 0.5, width: kWidth, height: 0.5))
        line.backgroundColor = kLineColor
        bgV.addSubview(line)
        return header
    }
   
    @objc func tapTouchIn(){
        if isZhanKai == true{
          self.outRecorderArr = []
        }else{
          self.outRecorderArr = outRecorderUseArr
        }
        isZhanKai = !isZhanKai
        self.table.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.none)
        
    }
}

extension CQScheduleDetailVC:CQScheduleDetailAgreeOrNotDelegate{
    func deleteClick(index: IndexPath) {
        
    }
    
    func disAgreeClick(index: IndexPath) {
        self.initReasonView()
        self.reasonType = "0"
    }
    
    func agreeClick(index: IndexPath) {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/schedule/setJoinSchedulePlanIsAgreeSign",
            type: .post,
            param: ["userId":userID,
                    "schedulePlanId":self.schedulePlanId,
                    "agreeSign":"3",
                    "unagreeReason":""],
            successCallBack: { (result) in
                SVProgressHUD.showInfo(withStatus: "设置成功")
                self.loadDetailData()
                self.table.reloadData()
        }) { (error) in
            
        }
    }
    
    
    
}

extension CQScheduleDetailVC{
    func initReasonView()  {
        self.reasonV = CQScheduleUnagreeView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight))
        self.reasonV?.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
        self.reasonV?.reasonDelegate = self
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.addSubview(reasonV!)
    }
}

extension CQScheduleDetailVC:CQScheduleReasonDelegate{
    func disagreeForReason(txt: String) {
        
        
        if reasonType == "0" {
            if txt.count > 0 {
                let userID = STUserTool.account().userID
                STNetworkTools.requestData(URLString: "\(baseUrl)/schedule/setJoinSchedulePlanIsAgreeSign",
                    type: .post,
                    param: ["userId":userID,
                            "schedulePlanId":self.schedulePlanId,
                            "agreeSign":"2",
                            "unagreeReason":txt],
                    successCallBack: { (result) in
                        self.reasonV?.removeFromSuperview()
                        SVProgressHUD.showInfo(withStatus: "设置成功")
                        self.loadDetailData()
                        self.table.reloadData()
                }) { (error) in
                }
            }else{
                SVProgressHUD.showInfo(withStatus: "请输入原因")
            }
            
        }else if reasonType == "1" {
            if self.planType == "1"{
                 self.planItemIsfinishRequest(txt: txt, schedukeModel: self.selectModel!)
            }else{
                 self.planIsfinishRequest(txt: txt, finishStatus: "1")
            }
        }
        
    }
}

extension CQScheduleDetailVC:CQLeavingMessageDelegate {
    func pushToDetailVC() {
        
    }
}

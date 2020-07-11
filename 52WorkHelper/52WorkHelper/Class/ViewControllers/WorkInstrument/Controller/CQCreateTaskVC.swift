//
//  CQCreateTaskVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/29.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQCreateTaskVC: SuperVC {

    var photoArray = [UIImage]()
    var userArray = [CQDepartMentUserListModel]()
    var userIdArr = [String]()
    var userNameArr = [String]()
    
    
    var bgView = UIButton() //遮罩
    var chooseTime = "" //选择的时间
    
    var pickView:UIPickerView?
    var aletStr = ""
    var alertBgView = UIButton()//遮罩
    var pickData = ["紧急","普通"]
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        table.backgroundColor = kProjectBgColor
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight + AutoGetHeight(height: 80)))
        return headView
    }()
    
    lazy var taskNameView: UIView = {
        let taskNameView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 225)))
        taskNameView.backgroundColor = UIColor.white
        return taskNameView
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 18), width: AutoGetWidth(width: 75), height: AutoGetHeight(height: 15)))
        nameLab.text = " 任务名称"
        nameLab.textAlignment = .left
        nameLab.textColor = UIColor.black
        nameLab.font = kFontSize15
        return nameLab
    }()
    
    lazy var titleTextView: CBTextView = {
        
        let titleTextView = CBTextView.init(frame:CGRect.init(x: self.nameLab.right, y: AutoGetHeight(height: 10) , width: kWidth - kLeftDis - AutoGetWidth(width: 80), height: AutoGetHeight(height: 28)))
        titleTextView.aDelegate = self
        titleTextView.textView.backgroundColor = UIColor.white
        titleTextView.textView.font = UIFont.systemFont(ofSize: 15)
        titleTextView.textView.textColor = UIColor.black
        
        titleTextView.placeHolder = "请输入任务名称"
        titleTextView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        return titleTextView
    }()
    
    lazy var taskTextView: CBTextView = {
        
        let taskTextView = CBTextView.init(frame: CGRect.init(x: AutoGetWidth(width: 15), y:self.nameLab.bottom + AutoGetWidth(width: 8), width: kWidth - AutoGetWidth(width: 30), height: AutoGetHeight(height: 71)))
        taskTextView.aDelegate = self
        taskTextView.textView.backgroundColor = UIColor.white
        taskTextView.textView.font = UIFont.systemFont(ofSize: 15)
        taskTextView.textView.textColor = UIColor.black
        
        taskTextView.placeHolder = "请输入任务内容..."
        taskTextView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        return taskTextView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width: (kHaveLeftWidth-AutoGetWidth(width: 30))/4, height: (kHaveLeftWidth-AutoGetWidth(width: 30))/4)
        layOut.minimumLineSpacing = 10
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: kLeftDis, y: self.taskTextView.bottom+AutoGetHeight(height: 18), width: kHaveLeftWidth, height: (kHaveLeftWidth-AutoGetWidth(width: 30))/4 ), collectionViewLayout: layOut)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.tag = 800
        collectionView.register(CQCirclePublishCell.self, forCellWithReuseIdentifier: "CQCirclePublishCellId")
        
        return collectionView
    }()
    
    lazy var taskMemberView: UIView = {
        let taskMemberView = UIView.init(frame: CGRect.init(x: 0, y: self.taskNameView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 143)))
        taskMemberView.backgroundColor = UIColor.white
        return taskMemberView
    }()
    
    lazy var attendPersonLab: UILabel = {
        let attendPersonLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 18), width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 15)))
        attendPersonLab.textColor = UIColor.black
        attendPersonLab.text = "任务成员"
        attendPersonLab.textAlignment = .left
        attendPersonLab.font = kFontSize15
        return attendPersonLab
    }()
    
    lazy var taskCollectionView: UICollectionView = {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width: kHaveLeftWidth/4, height: AutoGetHeight(height: 75))
        layOut.minimumLineSpacing = 0
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        //        layOut.headerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 38))
        //        layOut.footerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 11))
        
        let taskCollectionView = UICollectionView.init(frame: CGRect.init(x: kLeftDis, y: self.attendPersonLab.bottom + AutoGetHeight(height: 14), width: kHaveLeftWidth, height: AutoGetHeight(height: 84)), collectionViewLayout: layOut)
        taskCollectionView.backgroundColor = UIColor.white
        taskCollectionView.delegate = self
        taskCollectionView.dataSource = self
        taskCollectionView.tag = 801
        taskCollectionView.register(CQWriteReportCell.self, forCellWithReuseIdentifier: "CQWriteReportCellId")
        return taskCollectionView
    }()
    
    lazy var timeBtn: UIButton = {
        let timeBtn = UIButton.init(frame: CGRect.init(x: 0, y: self.taskMemberView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 55)))
        timeBtn.backgroundColor = UIColor.white
        timeBtn.tag = 600
        timeBtn.addTarget(self, action: #selector(chooseTime(btn:)), for: UIControlEvents.touchUpInside)
        return timeBtn
    }()
    
    lazy var ruleTimeLab: UILabel = {
        let ruleTimeLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kWidth/2, height: AutoGetHeight(height: 55)))
        ruleTimeLab.text = "截止时间"
        ruleTimeLab.textAlignment = .left
        ruleTimeLab.font = kFontSize15
        ruleTimeLab.textColor = UIColor.black
//        ruleTimeLab.isUserInteractionEnabled = true
        return ruleTimeLab
    }()
    
    lazy var timeLab: UILabel = {
        let timeLab = UILabel.init(frame: CGRect.init(x: kWidth/2, y: 0, width: kWidth/2 - AutoGetWidth(width: 30), height: AutoGetHeight(height: 55)))
        timeLab.text = "请选择截止时间"
        timeLab.textAlignment = .right
        timeLab.font = kFontSize15
        timeLab.textColor = klightGreyColor
//        timeLab.isUserInteractionEnabled = true
        return timeLab
    }()
    
    lazy var ruleTimeImg: UIImageView = {
        let ruleTimeImg = UIImageView.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 21.5), y: AutoGetHeight(height: 21.5), width: AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 12)))
        ruleTimeImg.image = UIImage.init(named: "PersonAddressArrow")
        ruleTimeImg.isUserInteractionEnabled = true
        return ruleTimeImg
    }()
    
    lazy var priorityLevelBtn: UIButton = {
        let priorityLevelBtn = UIButton.init(frame: CGRect.init(x: 0, y: self.timeBtn.bottom , width: kWidth, height: AutoGetHeight(height: 55)))
        priorityLevelBtn.backgroundColor = UIColor.white
        priorityLevelBtn.tag = 601
        priorityLevelBtn.addTarget(self, action: #selector(initPriorityLevelPicker), for: UIControlEvents.touchUpInside)
        let lineView = UIView.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kWidth - kLeftDis, height: 0.5))
        lineView.backgroundColor = kLineColor
        priorityLevelBtn.addSubview(lineView)
        return priorityLevelBtn
    }()
    
    lazy var priorityLevelLab: UILabel = {
        let priorityLevelLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kWidth/2, height: AutoGetHeight(height: 55)))
        priorityLevelLab.text = "优先级"
        priorityLevelLab.textAlignment = .left
        priorityLevelLab.font = kFontSize15
        priorityLevelLab.textColor = UIColor.black
//        priorityLevelLab.isUserInteractionEnabled = true
        return priorityLevelLab
    }()
    
    lazy var priorityLevelSelectLab: UILabel = {
        let priorityLevelSelectLab = UILabel.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 91.5), y: 0, width: AutoGetWidth(width: 70), height: AutoGetHeight(height: 55)))
        priorityLevelSelectLab.text = "请选择"
        priorityLevelSelectLab.textAlignment = .center
        priorityLevelSelectLab.font = kFontSize15
        priorityLevelSelectLab.textColor = klightGreyColor
//        priorityLevelSelectLab.isUserInteractionEnabled = true
        return priorityLevelSelectLab
    }()
    
    lazy var selectImg: UIImageView = {
        let selectImg = UIImageView.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 111.5), y: AutoGetWidth(width: 17.5), width: AutoGetWidth(width: 20), height: AutoGetWidth(width: 20)))
        
        return selectImg
    }()
    
    lazy var priorityLevelImg: UIImageView = {
        let priorityLevelImg = UIImageView.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 21.5), y: AutoGetHeight(height: 21.5), width: AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 12)))
        priorityLevelImg.image = UIImage.init(named: "PersonAddressArrow")
        priorityLevelImg.isUserInteractionEnabled = true
        return priorityLevelImg
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "新建任务"
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.taskNameView)
        self.taskNameView.addSubview(self.nameLab)
        self.taskNameView.addSubview(self.titleTextView)
        self.taskNameView.addSubview(self.taskTextView)
        self.taskNameView.addSubview(self.collectionView)
        self.headView.addSubview(self.taskMemberView)
        self.taskMemberView.addSubview(self.attendPersonLab)
        self.taskMemberView.addSubview(self.taskCollectionView)
        self.headView.addSubview(self.timeBtn)
        self.timeBtn.addSubview(self.ruleTimeLab)
        self.timeBtn.addSubview(self.timeLab)
        self.timeBtn.addSubview(self.ruleTimeImg)
        self.headView.addSubview(self.priorityLevelBtn)
        
        self.priorityLevelBtn.addSubview(self.priorityLevelLab)
        self.priorityLevelBtn.addSubview(self.priorityLevelSelectLab)
        self.priorityLevelBtn.addSubview(self.selectImg)
        self.priorityLevelBtn.addSubview(self.priorityLevelImg)
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        rightBtn.setTitle("完成", for: .normal)
        rightBtn.sizeToFit()
        rightBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        rightBtn.setTitleColor(UIColor.colorWithHexString(hex: "#20afff"), for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        rightBtn.addTarget(self, action: #selector(storeClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
       // let NotifMycation = NSNotification.Name(rawValue:"refreshCreateTaskCell")
        
        let NotifMycation = NSNotification.Name(rawValue:"FAddTracker")
        NotificationCenter.default.addObserver(self, selector: #selector(upDataChange(notif:)), name: NotifMycation, object: nil)
    }
    deinit {
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
        if !self.userIdArr.contains(STUserTool.account().userID){
            self.userArray.append(CQDepartMentUserListModel.init(uId: STUserTool.account().userID, realN: STUserTool.account().realName, headImag: STUserTool.account().headImage))
            self.userIdArr.append(STUserTool.account().userID)
        }
        
        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
        self.taskMemberView.frame = CGRect.init(x: 0, y:self.taskNameView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 70) + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
        self.taskCollectionView.frame = CGRect.init(x: kLeftDis, y: self.attendPersonLab.bottom + AutoGetHeight(height: 14), width: kHaveLeftWidth, height: AutoGetHeight(height: 14) + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
        self.timeBtn.frame =  CGRect.init(x: 0, y: self.taskMemberView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 55))
        self.priorityLevelBtn.frame = CGRect.init(x: 0, y: self.timeBtn.bottom , width: kWidth, height: AutoGetHeight(height: 55))
        self.taskCollectionView.reloadData()
        self.table.tableHeaderView = self.headView
        self.table.reloadData()
    }

    @objc func chooseTime(btn:UIButton)  {
        let tag = btn.tag - 600
        self.view.endEditing(true)
        bgView.frame = CGRect(x: 0, y: 64, width: kWidth, height: kHeight - 64)
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
        datePicker.locale = Locale(identifier: "zh_CN")
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .white
        //注意：action里面的方法名后面需要加个冒号“：”
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        pickBg.addSubview(datePicker)
    }
    
    @objc func sureClick(btn:UIButton) {
        if btn.tag == 700 {
            if chooseTime.isEmpty{
                let now = Date()
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd"
                self.chooseTime = dateFormat.string(from: now)
            }
            self.timeLab.text = chooseTime
            self.timeLab.font = kFontBoldSize15
        }
        self.bgView.removeAllSubviews()
        self.bgView.removeFromSuperview()
    }
    
    //日期选择器响应方法
    @objc func dateChanged(datePicker : UIDatePicker){
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd"
        chooseTime = formatter.string(from: datePicker.date)
    }
    
    @objc func removeBgView(sender: UIButton) {
        self.bgView.removeAllSubviews()
        self.bgView.removeFromSuperview()
    }
    
    @objc func initPriorityLevelPicker()  {
        self.initPick()
    }
    
    @objc func storeClick()  {
        
        
        var planContent = self.taskTextView.textView.text
        if planContent == self.taskTextView.placeHolder {
            planContent = ""
        }
        
        var titleContent = self.titleTextView.textView.text
        if titleContent == self.titleTextView.placeHolder{
            titleContent = ""
        }
        if self.chooseTime.count>0 && self.aletStr.count > 0 &&  (planContent?.count)! > 0 && (titleContent?.count)! > 0 && self.userIdArr.count > 0 {
            self.loadingPlay()
            self.createTaskRequest()
        }else{
            if (titleContent?.isEmpty)! {
                SVProgressHUD.showInfo(withStatus: "请输入任务名称")
            }else if (planContent?.isEmpty)! {
                SVProgressHUD.showInfo(withStatus: "请输入任务内容")
            }else if self.userIdArr.count <= 0 {
                SVProgressHUD.showInfo(withStatus: "请选择任务成员")
            }else if self.chooseTime.isEmpty {
                SVProgressHUD.showInfo(withStatus: "请选择截止时间")
            }else if self.aletStr.isEmpty{
                SVProgressHUD.showInfo(withStatus: "请选择优先级")
            }
        }
    }
}

extension CQCreateTaskVC{
  
    
//    func createTaskRequest()  {
//        let userID = STUserTool.account().userID
//
//        STNetworkTools.requestData(URLString: "\(baseUrl)/personnelTask/savePersonnelTask",
//            type: .post,
//            param: ["userId":userID,
//                    "priorityLevel":self.aletStr,
//                    "userIds":self.userIdArr,
//                    "taskContent":self.taskTextView.textView.text ?? "",
//                    "taskName":self.titleTextView.prevText ?? "",
//                    "deadLine":self.chooseTime],
//            successCallBack: { (result) in
//                self.loadingSuccess()
//                SVProgressHUD.showInfo(withStatus: "添加成功")
//                //刷新日程首页
//                NotificationCenter.default.post(name: NSNotification.Name.init("refreshTaskUI"), object: nil)
//                self.navigationController?.popViewController(animated: true)
//        }) { (error) in
//            self.loadingSuccess()
//        }
//    }
    
    
    func createTaskRequest()  {
        let userID = STUserTool.account().userID
        let taskText = self.taskTextView.textView.text ?? ""
        let tasknameText = self.titleTextView.prevText ?? ""
        var useArrStr = ""
        for (_,value) in self.userIdArr.enumerated(){
            useArrStr += value + ","
        }
        if useArrStr.hasSuffix(","){
            useArrStr.removeLast()
        }
        
        
        
        let urlUpload = "\(baseUrl)/personnelTask/savePersonnelTask"
        let headers = ["t_userId":userID,
                       "token":STUserTool.account().token]
        Alamofire.upload(multipartFormData: { formData in
            let param = ["userId":userID,
                         "priorityLevel":self.aletStr,
                         "userIds[]":useArrStr,
                         "taskContent":taskText,
                         "taskName":tasknameText,
                         "deadLine":self.chooseTime]
            
            
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
                        SVProgressHUD.showError(withStatus: "服务器有点问题")
                        return
                    }
                    let json = JSON(result)
                    if json["success"].boolValue {
                        SVProgressHUD.showInfo(withStatus: json["message"].stringValue)
                        //刷新日程首页
                        NotificationCenter.default.post(name: NSNotification.Name.init("refreshTaskUI"), object: nil)
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        SVProgressHUD.showError(withStatus: json["message"].stringValue)
                    }
                    
                    

                  
                }
            case .failure( _):
                self.loadingSuccess()
            }
        })
        
        
    }
    
}

extension CQCreateTaskVC:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
}

extension CQCreateTaskVC:UITextFieldDelegate,KeyBoardDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    @objc func textFieldEditChanged(obj:Notification)  {
        
    }
    
    
}

extension CQCreateTaskVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if 800 == collectionView.tag {
            return self.photoArray.count + 1
        }
        return self.userArray.count + 1
    }
    
}

extension CQCreateTaskVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        if 800 == collectionView.tag {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQCirclePublishCellId", for: indexPath) as! CQCirclePublishCell
            if self.photoArray.count == 0 {
                if indexPath.item == 0{
                    (cell as! CQCirclePublishCell).img.image = UIImage.init(named: "CQCirclePublishAdd")
                }
            }else {
                if indexPath.item == self.photoArray.count {
                    (cell as! CQCirclePublishCell).img.image = UIImage.init(named: "CQCirclePublishAdd")
                }else {
                    (cell as! CQCirclePublishCell).img.image = self.photoArray[indexPath.item]
                }
            }
        }else if 801 == collectionView.tag{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQWriteReportCellId", for: indexPath) as! CQWriteReportCell
            if self.userArray.count == 0 {
                if indexPath.row == 0{
                    (cell as! CQWriteReportCell).img.image = UIImage.init(named: "CQAddMenberIcon")
                    (cell as! CQWriteReportCell).deleteBtn.isHidden = true
                    (cell as! CQWriteReportCell).nameLab.text = ""
                }
            }else {
                if indexPath.row == self.userArray.count {
                    (cell as! CQWriteReportCell).img.image = UIImage.init(named: "CQAddMenberIcon")
                    (cell as! CQWriteReportCell).deleteBtn.isHidden = true
                    (cell as! CQWriteReportCell).nameLab.text = ""
                }else {
                    (cell as! CQWriteReportCell).img.sd_setImage(with: URL(string: self.userArray[indexPath.row].headImage ), placeholderImage:UIImage.init(named: "personDefaultIcon") )
                    (cell as! CQWriteReportCell).nameLab.text = self.userArray[indexPath.row].realName
                    (cell as! CQWriteReportCell).deleteBtn.isHidden = false
                    (cell as! CQWriteReportCell).deleteDelegate = self
                }
            }
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if 800 == collectionView.tag {
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
        }else if 801 == collectionView.tag{
            if self.userArray.count == 0 {
                if indexPath.row == 0 {
//                    let vc = AddressBookVC.init()
//                    vc.toType = .fromCreateTask
                    
                    let vc = QRAddressBookVC.init()
                    vc.toType = .fromAddGroupMember
                    vc.hasSelectModelArr = self.userArray
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                if indexPath.row == self.userArray.count{
//                    let vc = AddressBookVC.init()
//                    vc.toType = .fromCreateTask
                    let vc = QRAddressBookVC.init()
                    vc.toType = .fromAddGroupMember
                    vc.hasSelectModelArr = self.userArray
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    
                }
            }
        }
        
        
        
    }
    
}

extension CQCreateTaskVC{
    func initImgPick()  {
        let imagePickerVc = TZImagePickerController(maxImagesCount: 3, delegate: self)
//        imagePickerVc?.allowTakePicture = false
        self.present(imagePickerVc!, animated: true, completion: nil)
    }
}

extension CQCreateTaskVC: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        photoArray.insert(contentsOf: photos, at: 0)
        if photoArray.count > 3 {
            photoArray.removeSubrange(photoArray.indices.suffix(from: 3))
        }
        print(photoArray.count)
        
        self.collectionView.frame = CGRect.init(x: kLeftDis, y: self.taskTextView.bottom+AutoGetHeight(height: 18), width: kHaveLeftWidth, height: (kHaveLeftWidth-AutoGetWidth(width: 30))/4 * CGFloat((self.photoArray.count/4)+1) + 10 * CGFloat((self.photoArray.count/4)+1))
//        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 126) + (kHaveLeftWidth-AutoGetWidth(width: 30))/4 * CGFloat((self.photoArray.count/4)+1) + 20 * CGFloat((self.photoArray.count/4)+1))
        collectionView.reloadData()
    }
}

extension CQCreateTaskVC{
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
        titleLab.frame = CGRect.init(x: kWidth/2 - AutoGetWidth(width: 50), y: 0, width: AutoGetWidth(width: 100), height: AutoGetHeight(height: 40))
        titleLab.text = "选择优先级"
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
        self.priorityLevelSelectLab.text = message
        self.priorityLevelSelectLab.font = kFontBoldSize15
        
        
        if message == "紧急"{
            self.aletStr = "1"
            self.selectImg.image = UIImage.init(named: "TaskSerrier")
        }else if message == "普通"{
            self.aletStr = "2"
            self.selectImg.image = UIImage.init(named: "TaskSoSo")
        }
        
        self.alertBgView.removeAllSubviews()
        self.alertBgView.removeFromSuperview()
        
    }
    
    @objc func removeAlertBgView(sender: UIButton) {
        self.alertBgView.removeAllSubviews()
        self.alertBgView.removeFromSuperview()
    }
    
}


extension CQCreateTaskVC:UIPickerViewDelegate,UIPickerViewDataSource{
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



extension CQCreateTaskVC:CQSelectDeleteDelegate{
    func deleteCollectionCell(index: IndexPath) {
        self.userIdArr.remove(at:index.item)
        self.userArray.remove(at: index.item)
        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
        self.taskMemberView.frame = CGRect.init(x: 0, y:self.taskNameView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 70) + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
        self.taskCollectionView.frame = CGRect.init(x: kLeftDis, y: self.attendPersonLab.bottom + AutoGetHeight(height: 14), width: kHaveLeftWidth, height: AutoGetHeight(height: 14) + CGFloat(self.userArray.count/4 + 1) * AutoGetHeight(height: 75))
        self.timeBtn.frame =  CGRect.init(x: 0, y: self.taskMemberView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 55))
        self.priorityLevelBtn.frame = CGRect.init(x: 0, y: self.timeBtn.bottom , width: kWidth, height: AutoGetHeight(height: 55))
        self.table.tableHeaderView = self.headView
        self.taskCollectionView.reloadData()
        self.table.reloadData()
    }
    
    
}


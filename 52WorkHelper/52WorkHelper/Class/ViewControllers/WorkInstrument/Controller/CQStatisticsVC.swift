//
//  CQStatisticsVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/4/27.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQStatisticsVC: SuperVC {
    var titleArr = ["出勤天数","休息天数","迟到","早退","缺勤","旷工","请假","外勤","加班","补卡申请"]
    var selectIndex:NSMutableArray = NSMutableArray()
    var timeString = ""
    var nowDateStr = ""
    var sectionModel:CQStasticsModel?
    var selectRow:NSInteger?
    var selectComp:NSInteger?
    /*
     按照顺序返回各个cell数组
 */
    var attenceArray = [CQStaticsTypeModel]()
    var restArray = [CQStaticsTypeModel]()
    var lateArray = [CQStaticsTypeModel]()
    var earlyArray = [CQStaticsTypeModel]()
    var withOutSignArray = [CQStaticsTypeModel]()
    var noWorkArray = [CQStaticsTypeModel]()
    var leaveArray = [CQStaticsTypeModel]()
    var signOutArray = [CQStaticsTypeModel]()
    var workHardArray = [CQStaticsTypeModel]()
    var applyCardArray = [CQStaticsTypeModel]()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: CGFloat(SafeAreaTopHeight), width: kWidth, height: kHeight - CGFloat(SafeAreaTopHeight)), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        table.backgroundColor = kProjectBgColor
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 135)))
        return headView
    }()
    
    
    
    lazy var rankView: UIButton = {
        let rankView = UIButton.init(type: .custom)
        rankView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 35))
        rankView.backgroundColor = UIColor.colorWithHexString(hex: "#fff9e6")
        rankView.addTarget(self, action: #selector(rankClick), for: .touchUpInside)
        
        return rankView
    }()
    
    lazy var rankLab: UILabel = {
        let rankLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kWidth - 2 * kLeftDis, height: AutoGetHeight(height: 35)))
        rankLab.text = "排行榜"
        rankLab.textColor = UIColor.colorWithHexString(hex: "#f89800")
        rankLab.textAlignment = .left
        rankLab.font = kFontSize15
        rankLab.isUserInteractionEnabled = false
        return rankLab
    }()
    
    lazy var arrowImg: UIImageView = {
        let arrowImg = UIImageView.init(frame: CGRect.init(x: kWidth -  kLeftDis - AutoGetWidth(width: 6.5), y: AutoGetHeight(height: 10.5), width: AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 12)))
        arrowImg.isUserInteractionEnabled = false
        arrowImg.image = UIImage.init(named: "CQStaticsYellow")
        return arrowImg
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView.init(frame: CGRect.init(x: 0, y: self.rankView.bottom, width: kWidth, height: AutoGetHeight(height: 100)))
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    
    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 12.5), width: AutoGetWidth(width: 75), height: AutoGetWidth(width: 75)))
        iconImg.image = UIImage.init(named: "personDefaultIcon")
        iconImg.layer.cornerRadius = AutoGetWidth(width: 37.5)
        iconImg.clipsToBounds = true
        return iconImg
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: kLeftDis + self.iconImg.right, y: 0, width: kWidth/3, height: AutoGetHeight(height: 100)))
        nameLab.text = "胡歌"
        nameLab.textColor = UIColor.black
        nameLab.textAlignment = .left
        nameLab.font = kFontSize18
        return nameLab
    }()
    
    lazy var dateBtn: UIButton = {
        let dateBtn = UIButton.init(type: .custom)
        dateBtn.frame = CGRect.init(x: kWidth - AutoGetWidth(width: 135)-AutoGetWidth(width: 10), y: AutoGetHeight(height: 20), width: AutoGetWidth(width: 120), height: AutoGetHeight(height: 60))
        dateBtn.addTarget(self, action: #selector(dateClick), for: .touchUpInside)
        dateBtn.setTitleColor(UIColor.black, for: .normal)
      //  dateBtn.setImage(UIImage.init(named: "roomClose"), for: .normal)
        dateBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: AutoGetWidth(width: 130), bottom: 0, right: 0)
        
        return dateBtn
    }()
    
    lazy var footView: UIView = {
        let footView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 100)))
        footView.backgroundColor = kProjectBgColor
        return footView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = kProjectBgColor
        for _ in self.titleArr {
            selectIndex.add("0")
        }
        let now = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM"
        let dateStr =  dateFormat.string(from: now)
        self.loadDatas(time: dateStr)
        dateBtn.setTitle(dateStr, for: .normal)
        
        dateFormat.dateFormat = "yyyy-MM-dd"
        self.nowDateStr = dateFormat.string(from: now)
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 0, y: 0, width: 110, height: 40)
        btn.contentHorizontalAlignment = .right
        btn.titleLabel?.font = kFontSize17
        btn.setTitle("部门考勤", for: .normal)
        btn.setTitleColor(kBlueColor, for: .normal)
        btn.addTarget(self, action: #selector(departmentClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: btn)
        self.navigationItem.rightBarButtonItem = rightItem
        
    }
    
    func initView()  {
        self.title = "统计"
        self.view.addSubview(self.table)
        self.table.register(CQStatisticsCell.self, forCellReuseIdentifier: "CQStatisticsCellId")
        self.table.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CQStatisticsHeader")
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.rankView)
        self.rankView.addSubview(self.rankLab)
        self.rankView.addSubview(self.arrowImg)
        self.headView.addSubview(self.bgView)
        self.bgView.addSubview(self.iconImg)
        self.bgView.addSubview(self.nameLab)
        self.bgView.addSubview(self.dateBtn)
        let img = UIImageView(frame:  CGRect(x: dateBtn.right, y: dateBtn.center.y, width: AutoGetWidth(width: 8), height: AutoGetHeight(height: 14.5)))
        img.center.y = dateBtn.center.y
        img.image = UIImage(named: "roomClose")
        self.bgView.addSubview(img)
        self.table.tableFooterView = self.footView
    }
    
    @objc func departmentClick()   {
        let vc = CQDepartmentAttendanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func rankClick() {
        let vc = CQRankVC.init()
        vc.timeString = self.nowDateStr
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func dateClick() {
        let picker = XMTimePickerView.init()
        if self.selectRow != nil{
            picker.curSelectRow = self.selectRow!
        }
        if self.selectComp != nil{
            picker.curSelectComp = self.selectComp!
        }
        picker.delegate = self
        picker.isShowToday = false
        picker.show()
    }
    
    @objc func tapClick(tap:UITapGestureRecognizer) {
        DLog("点了")
        let num:Int = tap.view!.tag
        var timeStr = ""
        if timeString.count > 0{
            timeStr = timeString
        }else{
            let now = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM"
            timeStr =  dateFormat.string(from: now)
        }
        
        
        if selectIndex[num] as! String == "1" {
            selectIndex.replaceObject(at: num, with: "0")
            self.table.reloadSections(IndexSet.init(integer: num), with: .none)

        }else{
            selectIndex.replaceObject(at: num, with: "1")
            self.table.reloadSections(IndexSet.init(integer: num), with: .none)
            if 0 == num {
                self.loadCellData(type: "attendanceWorkCountDays", timeStr: timeStr)
            }else if 1 == num {
                self.loadCellData(type: "restDays", timeStr: timeStr)
            }else if 2 == num {
                self.loadCellData(type: "laterNumbers", timeStr: timeStr)
            }else if 3 == num {
                self.loadCellData(type: "earlyRetreatNumber", timeStr: timeStr)
            }else if 4 == num {
                self.loadCellData(type: "absenceFromDutyNumber", timeStr: timeStr)
            }else if 5 == num {
                self.loadCellData(type: "absenteeismNumber", timeStr: timeStr)
            }else if 6 == num {
                self.loadCellData(type: "leaveTime", timeStr: timeStr)
            }else if 7 == num {
                self.loadCellData(type: "outsideOfficeNumber", timeStr: timeStr)
            }else if 8 == num {
                self.loadCellData(type: "overTime", timeStr: timeStr)
            }else if 9 == num {
                self.loadCellData(type: "supplyAttendanceNumber", timeStr: timeStr)
            }
        }
//        table.reloadData()
    }
}

//Mark 数据加载
extension CQStatisticsVC{
    
    // MARK:request
    fileprivate func loadDatas(time:String) {
        
        let userID = STUserTool.account().userID
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/attendance/getAttendanceStatistics" ,
            type: .get,
            param: ["emyeId":userID,
                    "statisticalMonth":time],
            successCallBack: { (result) in
                
                guard let model = CQStasticsModel.init(jsonData: result["data"]) else {
                    return
                }
                self.sectionModel = model
                self.initView()
                self.iconImg.sd_setImage(with: URL(string:model.headImage), placeholderImage:UIImage.init(named: "personDefaultIcon") )
                self.nameLab.text = model.realName
                //刷新表格
                self.table.reloadData()
                
        }) { (error) in
            self.table.reloadData()
        }
    }
    
    func loadCellData(type:String,timeStr:String)  {
        let userID = STUserTool.account().userID
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/attendance/getAttendanceStatisticsType" ,
            type: .get,
            param: ["emyeId":userID,
                    "statisticalMonth":timeStr,
                    "type":type],
            successCallBack: { (result) in
                if type == "attendanceWorkCountDays"{
                    self.attenceArray.removeAll()
                }else if type == "restDays"{
                    self.restArray.removeAll()
                }else if type == "laterNumbers"{
                    self.lateArray.removeAll()
                }else if type == "earlyRetreatNumber"{
                    self.earlyArray.removeAll()
                }else if type == "absenceFromDutyNumber"{
                    self.withOutSignArray.removeAll()
                }else if type == "absenteeismNumber"{
                    self.noWorkArray.removeAll()
                }else if type == "leaveTime"{
                    self.leaveArray.removeAll()
                }else if type == "outsideOfficeNumber"{
                    self.signOutArray.removeAll()
                }else if type == "overTime"{
                    self.workHardArray.removeAll()
                }else if type == "supplyAttendanceNumber"{
                    self.applyCardArray.removeAll()
                }
               
                
                var tempArray = [CQStaticsTypeModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQStaticsTypeModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                
                if type == "attendanceWorkCountDays"{
                    self.attenceArray = tempArray
                }else if type == "restDays"{
                    self.restArray = tempArray
                }else if type == "laterNumbers"{
                    self.lateArray = tempArray
                }else if type == "earlyRetreatNumber"{
                    self.earlyArray = tempArray
                }else if type == "absenceFromDutyNumber"{
                    self.withOutSignArray = tempArray
                }else if type == "absenteeismNumber"{
                    self.noWorkArray = tempArray
                }else if type == "leaveTime"{
                    self.leaveArray = tempArray
                }else if type == "outsideOfficeNumber"{
                    self.signOutArray = tempArray
                }else if type == "overTime"{
                    self.workHardArray = tempArray
                }else if type == "supplyAttendanceNumber"{
                    self.applyCardArray = tempArray
                }
                
                
                
                self.table.reloadData()
                
                
                
        }) { (error) in
            self.table.reloadData()
        }
    }
}


// Mark tableview代理
extension CQStatisticsVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.titleArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectIndex[section] as! String == "1" {
            if 0 == section{
                return self.attenceArray.count
            }else if 1 == section{
                return self.restArray.count
            }else if 2 == section{
                return self.lateArray.count
            }else if 3 == section{
                return self.earlyArray.count
            }else if 4 == section{
                return self.withOutSignArray.count
            }else if 5 == section{
                return self.noWorkArray.count
            }else if 6 == section{
                return self.leaveArray.count
            }else if 7 == section{
                return self.signOutArray.count
            }else if 8 == section{
                return self.workHardArray.count
            }else if 9 == section{
                return self.applyCardArray.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQStatisticsCellId") as! CQStatisticsCell
        
        //2018-05-23 16:59:31
        var model:CQStaticsTypeModel?
        if 0 == indexPath.section {
            model = self.attenceArray[indexPath.row]
        }else if 1 == indexPath.section {
            model = self.restArray[indexPath.row]
        }else if 2 == indexPath.section {
            model = self.lateArray[indexPath.row]
        }else if 3 == indexPath.section {
            model = self.earlyArray[indexPath.row]
        }else if 4 == indexPath.section {
            model = self.withOutSignArray[indexPath.row]
        }else if 5 == indexPath.section {
            model = self.noWorkArray[indexPath.row]
        }else if 6 == indexPath.section {
            model = self.leaveArray[indexPath.row]
        }else if 7 == indexPath.section {
            model = self.signOutArray[indexPath.row]
        }else if 8 == indexPath.section {
            model = self.workHardArray[indexPath.row]
        }else if 9 == indexPath.section {
            model = self.applyCardArray[indexPath.row]
        }
        
        let str:NSString = model!.attendanceTime as NSString
        var date = ""
        var time = ""
        if (model?.attendanceTime.count)! > 9{
            date = str.substring(with: NSRange.init(location: 0, length: 10))
            time = str.substring(with: NSRange.init(location: 10, length: 9))
        }
        
        cell.dateLab.text = date + "（" + (model?.dayOfWeek)! + "）" + time
        
        if 0 == indexPath.section {
            cell.descLab.text = (model?.attendanceType)! + (model?.attendanceAbnormalDesc)!
            cell.dateLab.text = date + "（" + (model?.dayOfWeek)! + "）" + time
        }else if 1 == indexPath.section {
            cell.descLab.text = model?.recordTypeDesc
            cell.dateLab.text = (model?.recordDate)! + "（" + (model?.dayOfWeek)! + "）" + time
        }else if 2 == indexPath.section {
            cell.descLab.text = model?.laterTime
            cell.dateLab.text = date + "（" + (model?.dayOfWeek)! + "）" + time
        }else if 3 == indexPath.section {
            cell.descLab.text = model?.earlyTime
            cell.dateLab.text = date + "（" + (model?.dayOfWeek)! + "）" + time
        }else if 4 == indexPath.section {
            cell.descLab.text = (model?.attendanceType)! + " " + (model?.attendanceAbnormalDesc)!
            cell.dateLab.text = date + "（" + (model?.dayOfWeek)! + "）" + time
        }else if 5 == indexPath.section {
            cell.descLab.text = (model?.attendanceType)! + " " + (model?.attendanceAbnormalDesc)!
            cell.dateLab.text = date + "（" + (model?.dayOfWeek)! + "）" + time
        }else if 6 == indexPath.section {
            cell.descLab.text = model?.recordTypeDesc
            cell.dateLab.adjustsFontSizeToFitWidth = true
            cell.dateLab.text = model?.attendanceTime
        }else if 7 == indexPath.section {
            cell.descLab.text = model?.attendanceType
            cell.dateLab.text = date + "（" + (model?.dayOfWeek)! + "）" + time
        }else if 8 == indexPath.section {
            let str = (model!.overTime) as NSString
//            let sStr =  str.substring(from: 1)
            cell.descLab.text = (model?.attendanceType)! //+ " " + (str as String) + "小时"
            
            
            cell.dateLab.text = model?.attendanceTime
            cell.dateLab.adjustsFontSizeToFitWidth = true
        }else if 9 == indexPath.section {
            cell.descLab.text = model?.supplyAttendance
            cell.dateLab.text = date + "（" + (model?.dayOfWeek)! + "）" + time
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var model:CQStaticsTypeModel?
        if 0 == indexPath.section {
            model = self.attenceArray[indexPath.row]
            if "1" == model?.recordType{
//                let vc = CQCheckWorkAttendanceVC()
//                vc.isFromStatics = true
//                vc.dateStr = (model?.recordDate)!
//                vc.applyId = "B_BK"
//                vc.isGoApplyCard = true
                let vc = QRSignVC.init()
                vc.isFromStatics = true
                vc.dateStr = (model?.recordDate)!
                self.navigationController?.pushViewController(vc, animated: true)
            }else if "2" == model?.recordType {
                let vc = CQFieldPersonelVC()
                vc.isFromStatics = true
                vc.dateStr = (model?.recordDate)!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if 1 == indexPath.section {
            model = self.restArray[indexPath.row]
            if "1" == model?.recordType{
//                let vc = CQCheckWorkAttendanceVC()
//                vc.isFromStatics = true
//                vc.dateStr = (model?.recordDate)!
                let vc = QRSignVC.init()
                vc.isFromStatics = true
                vc.dateStr = (model?.recordDate)!
                self.navigationController?.pushViewController(vc, animated: true)
            }else if "2" == model?.recordType {
                let vc = CQFieldPersonelVC()
                vc.isFromStatics = true
                vc.dateStr = (model?.recordDate)!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if 2 == indexPath.section {
            model = self.lateArray[indexPath.row]
            if "1" == model?.recordType{
//                let vc = CQCheckWorkAttendanceVC()
//                vc.isFromStatics = true
//                vc.dateStr = (model?.recordDate)!
//                vc.applyId = "B_BK"
//                vc.isGoApplyCard = true
                let vc = QRSignVC.init()
                vc.isFromStatics = true
                vc.dateStr = (model?.recordDate)!
                self.navigationController?.pushViewController(vc, animated: true)
            }else if "2" == model?.recordType {
                let vc = CQFieldPersonelVC()
                vc.isFromStatics = true
                vc.dateStr = (model?.recordDate)!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if 3 == indexPath.section {
            model = self.earlyArray[indexPath.row]
            if "1" == model?.recordType{
//                let vc = CQCheckWorkAttendanceVC()
//                vc.isFromStatics = true
//                vc.dateStr = (model?.recordDate)!
                let vc = QRSignVC.init()
                vc.isFromStatics = true
                vc.dateStr = (model?.recordDate)!
                self.navigationController?.pushViewController(vc, animated: true)
            }else if "2" == model?.recordType {
                let vc = CQFieldPersonelVC()
                vc.isFromStatics = true
                vc.dateStr = (model?.recordDate)!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if 4 == indexPath.section {
            model = self.withOutSignArray[indexPath.row]
            if "1" == model?.recordType{
//                let vc = CQCheckWorkAttendanceVC()
//                vc.isFromStatics = true
//                vc.dateStr = (model?.recordDate)!
//                vc.attendanceTime = model!.attendanceTime
//                vc.isScrollToBack = model!.attendanceType
//                vc.applyId = "B_BK"
//                vc.isGoApplyCard = true
                let vc = QRSignVC.init()
                vc.isFromStatics = true
                vc.dateStr = (model?.recordDate)!
                self.navigationController?.pushViewController(vc, animated: true)
            }else if "2" == model?.recordType {
                let vc = CQFieldPersonelVC()
                vc.isFromStatics = true
                vc.dateStr = (model?.recordDate)!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if 5 == indexPath.section {
            model = self.noWorkArray[indexPath.row]
            if "1" == model?.recordType{
//                let vc = CQCheckWorkAttendanceVC()
//                vc.isFromStatics = true
//                vc.dateStr = (model?.recordDate)!
//                vc.applyId = "B_BK"
//                vc.isGoApplyCard = true
                let vc = QRSignVC.init()
                vc.isFromStatics = true
                vc.dateStr = (model?.recordDate)!
                self.navigationController?.pushViewController(vc, animated: true)
            }else if "2" == model?.recordType {
                let vc = CQFieldPersonelVC()
                vc.isFromStatics = true
                vc.dateStr = (model?.recordDate)!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if 6 == indexPath.section {
            model = self.leaveArray[indexPath.row]
            if "4" == model?.recordType{
                let vc = NCQApproelDetailVC()
                vc.businessApplyId = (model?.entityId)!
                vc.isFromMeSubmit = true
                vc.titleStr = "我的请假"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if 7 == indexPath.section {
            model = self.signOutArray[indexPath.row]
            if "1" == model?.recordType{
//                let vc = CQCheckWorkAttendanceVC()
//                vc.isFromStatics = true
//                vc.dateStr = (model?.recordDate)!
                let vc = QRSignVC.init()
                vc.isFromStatics = true
                vc.dateStr = (model?.recordDate)!
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if "2" == model?.recordType {
                let vc = CQFieldPersonelVC()
                vc.isFromStatics = true
                vc.dateStr = (model?.recordDate)!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if 8 == indexPath.section {
            model = self.workHardArray[indexPath.row]
            if "1" == model?.recordType{
//                let vc = CQCheckWorkAttendanceVC()
//                vc.isFromStatics = true
//                vc.dateStr = (model?.recordDate)!
                let vc = QRSignVC.init()
                vc.isFromStatics = true
                vc.dateStr = (model?.recordDate)!
                self.navigationController?.pushViewController(vc, animated: true)
            }else if "2" == model?.recordType {
                let vc = CQFieldPersonelVC()
                vc.isFromStatics = true
                vc.dateStr = (model?.recordDate)!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if 9 == indexPath.section {
            model = self.applyCardArray[indexPath.row]
            if "1" == model?.recordType{
//                let vc = CQCheckWorkAttendanceVC()
//                vc.isFromStatics = true
//                vc.dateStr = (model?.recordDate)!
//                vc.applyId = "B_BK"
//                vc.isGoApplyCard = true
                let vc = QRSignVC.init()
                vc.isFromStatics = true
                vc.dateStr = (model?.recordDate)!
                self.navigationController?.pushViewController(vc, animated: true)
            }else if "2" == model?.recordType {
                let vc = CQFieldPersonelVC()
                vc.isFromStatics = true
                vc.dateStr = (model?.recordDate)!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoGetHeight(height: 55)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AutoGetHeight(height: 55)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 55)))
        
        header.backgroundColor = UIColor.white
        header.layer.borderColor = kLineColor.cgColor
        header.layer.borderWidth = 0.5
        let titleLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kWidth - 2 * kLeftDis, height: AutoGetHeight(height: 55)))
        titleLab.font = kFontSize15
        titleLab.textAlignment = .left
        titleLab.textColor = UIColor.black
        titleLab.text = titleArr[section]
        header.addSubview(titleLab)
        
        let dayLab = UILabel.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 200), y: 0, width: AutoGetWidth(width: 164.5), height: AutoGetHeight(height: 55)))
        dayLab.font = kFontSize15
        dayLab.textAlignment = .right
        dayLab.textColor = UIColor.colorWithHexString(hex: "#8b8b8b")
        if 0 == section {
            dayLab.text = sectionModel?.attendanceWorkCountDays
        }else if 1 == section {
            dayLab.text = sectionModel?.restDays
        }else if 2 == section {
            dayLab.text = sectionModel!.laterNumber + sectionModel!.laterTime
            dayLab.textColor = UIColor.colorWithHexString(hex: "#ee2727")
        }else if 3 == section{
            dayLab.text = sectionModel!.earlyRetreatNumber + sectionModel!.earlyRetreatTime
            dayLab.textColor = UIColor.colorWithHexString(hex: "#ee2727")
        }else if 4 == section {
            dayLab.text = sectionModel?.absenceFromDutyNumber
            dayLab.textColor = UIColor.colorWithHexString(hex: "#ee2727")
        }else if 5 == section {
            dayLab.text = sectionModel?.absenteeismNumber
            dayLab.textColor = UIColor.colorWithHexString(hex: "#ee2727")
        }else if 6 == section {
            dayLab.text = sectionModel?.leaveHour
        }else if 7 == section {
            dayLab.text = sectionModel?.outsideOfficeNumber
        }else if 8 == section {
            dayLab.text = sectionModel?.overTime
        }else if 9 == section {
            dayLab.text = sectionModel?.supplyAttendanceNumber
        }
        
        header.addSubview(dayLab)
        
        let zhedieImg = UIImageView.init(frame: CGRect.init(x: kWidth -  kLeftDis - AutoGetWidth(width: 6.5), y: AutoGetHeight(height: 21.5), width: AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 12)))
        zhedieImg.tag = section + 1000
        if (self.selectIndex[section] as! String) == "0"{
            zhedieImg.frame = CGRect.init(x: kWidth -  kLeftDis - AutoGetWidth(width: 8), y: AutoGetHeight(height: 20.25), width: AutoGetWidth(width: 8), height: AutoGetHeight(height: 14.5))
            zhedieImg.image = UIImage.init(named: "roomClose")
        }else{
            zhedieImg.frame =  CGRect.init(x: kWidth -  kLeftDis - AutoGetWidth(width: 15)+5, y: AutoGetHeight(height: 24.75), width: AutoGetWidth(width: 14.5), height: AutoGetHeight(height: 8))
            zhedieImg.image = UIImage.init(named: "roomOpen")
        }
        header.addSubview(zhedieImg)
        
        let tap = UITapGestureRecognizer.init(target: self, action:#selector(tapClick(tap:)))
        header.tag = section
        header.addGestureRecognizer(tap)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 100)))
        header.backgroundColor = UIColor.clear
        return header
    }
}

extension CQStatisticsVC:XMTimePickerViewDelegate{
    func xm_didSelect(_ pickerView: XMTimePickerView!, andTime time: String!, andRow selectRow: Int, andComp selectComp: Int) {
        self.selectRow = selectRow
        self.selectComp = selectComp
        DLog(time)
        self.loadDatas(time: time)
        self.timeString = time
        self.dateBtn.setTitle(time, for: .normal)
    }
    
}

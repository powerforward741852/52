//
//  CQAttendancePersonVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/9/11.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQAttendancePersonVC: SuperVC {

    let imageArr = ["Att0","Att1","Att2","Att3","Att4","Att5","Att6"/*,"Att7"*/]
    let titleArr = ["迟到","旷工","早退","缺勤","请假","外出","出差"/*,"补卡"*/]
    var countArr = [String]()
    var statisticalDate = ""
    var departmentId = ""
    var pageNum = 1
    var dataArray = [CQDepartMentAttenceModel]()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        //        table.backgroundColor = kProjectBgColor
        table.delegate = self
        table.dataSource = self
        table.estimatedRowHeight = 10
        table.rowHeight = UITableViewAutomaticDimension
        table.allowsSelection = false
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: 142))
        headView.backgroundColor = kProjectBgColor
        return headView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 7, width: kWidth, height: 128))
        scrollView.contentSize = CGSize.init(width: kWidth * 2, height:128 )
        scrollView.backgroundColor = UIColor.white
//        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.backgroundColor = kProjectBgColor
        self.getDepAttendanceStatistics()
        self.setUpRefresh()
        self.view.addSubview(self.table)
        
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.scrollView)
        self.table.register(QRKaoQingJiLuTableViewCell.self, forCellReuseIdentifier: "QRAttendancePersonCellId")
        self.table.register(NCQAttendancePersonCell.self, forCellReuseIdentifier: "NCQAttendancePersonCellId")
    }
    
    func initScrollContent()  {
        for i in 0..<self.imageArr.count{
            let img = UIImageView.init(frame: CGRect.init(x: AutoGetWidth(width: 18) + AutoGetWidth(width: 44) * CGFloat(i) + AutoGetWidth(width: 38) * CGFloat(i), y: AutoGetHeight(height: 31), width: AutoGetWidth(width: 44), height: AutoGetWidth(width: 44)))
            img.image = UIImage.init(named: self.imageArr[i])
            self.scrollView.addSubview(img)
            
            let countLab = UILabel.init(frame: CGRect.init(x: AutoGetWidth(width: 0), y: 0, width: AutoGetWidth(width: 44), height: AutoGetWidth(width: 44)))
            countLab.font = kFontSize18
            
            countLab.textAlignment = .center
//            countLab.text = self.countArr[i] + "人"
            let attrstring:NSMutableAttributedString = NSMutableAttributedString.init(string: self.countArr[i] + "人")
            let str = NSString.init(string: self.countArr[i] + "人")
            let ranStr = "人"
            let theRange = str.range(of: ranStr)
            
            attrstring.addAttribute(NSAttributedStringKey.font, value: kFontSize10, range: theRange)
            countLab.attributedText = attrstring
            img.addSubview(countLab)
            
            if 0 == i{
                countLab.textColor = UIColor.colorWithHexString(hex: "#ff8e39")
            }else if 1 == i{
                countLab.textColor = UIColor.colorWithHexString(hex: "#eb4947")
            }else if 2 == i{
                countLab.textColor = UIColor.colorWithHexString(hex: "#3d99ff")
            }else if 3 == i{
                countLab.textColor = UIColor.colorWithHexString(hex: "#b770e3")
            }else if 4 == i{
                countLab.textColor = UIColor.colorWithHexString(hex: "#60bc26")
            }else if 5 == i{
                countLab.textColor = UIColor.colorWithHexString(hex: "#5564d5")
            }else if 6 == i{
                countLab.textColor = UIColor.colorWithHexString(hex: "#58eae2")
            }
            
            let lab = UILabel.init(frame: CGRect.init(x: AutoGetWidth(width: 18) + AutoGetWidth(width: 44) * CGFloat(i) + AutoGetWidth(width: 38) * CGFloat(i), y: img.bottom + 9, width: AutoGetWidth(width: 44), height: AutoGetHeight(height: 13)))
            lab.font = kFontSize13
            lab.text = self.titleArr[i]
            lab.textColor = UIColor.black
            lab.textAlignment = .center
            self.scrollView.addSubview(lab)
        }
    }
}

extension CQAttendancePersonVC{
    func getDepAttendanceStatistics() {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/attendance/getDepAttendanceStatistics" ,
            type: .get,
            param: ["emyeId":userID,
                    "departmentId":self.departmentId,
                    "statisticalDate":self.statisticalDate],
            successCallBack: { (result) in
                
                self.countArr.append(result["data"]["laterNumber"].stringValue)
                self.countArr.append(result["data"]["absenteeismNumber"].stringValue)
                self.countArr.append(result["data"]["earlyRetreatNumber"].stringValue)
                self.countArr.append(result["data"]["absenceFromDutyNumber"].stringValue)
                self.countArr.append(result["data"]["leaveNumber"].stringValue)
                self.countArr.append(result["data"]["outsideOfficeNumber"].stringValue)
                self.countArr.append(result["data"]["travelNumber"].stringValue)
                self.title = "部门考勤人员 " + result["data"]["emyeNumber"].stringValue
                self.initScrollContent()
        }) { (error) in
            
        }
    }
    
    
    fileprivate func setUpRefresh() {
        // MARK:header
        let STHeader = CQRefreshHeader {[unowned self] in
            self.loadDatas(moreData: false)
        }
        // MARK:footer
        let STFooter = CQRefreshFooter {[unowned self] in
            self.loadDatas(moreData: true)
        }
        self.table.mj_header = STHeader
        self.table.mj_footer = STFooter
        self.table.mj_header.beginRefreshing()
    }
    // MARK:request
    fileprivate func loadDatas(moreData: Bool) {
        if moreData {
            pageNum += 1
        } else {
            pageNum = 1
        }
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/attendance/getDepAttendanceStatisticByPage" ,
            type: .get,
            param: ["emyeId":userID,
                    "currentPage":pageNum,
                    "rows":"10",
                    "departmentId":self.departmentId,
                    "statisticalDate":self.statisticalDate],
            successCallBack: { (result) in
                var tempArray = [CQDepartMentAttenceModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQDepartMentAttenceModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                
                if moreData {
                    self.dataArray.append(contentsOf: tempArray)
                } else {
                    self.dataArray = tempArray
                }
                //刷新表格
                self.table.mj_header.endRefreshing()
                self.table.mj_footer.endRefreshing()
                self.table.reloadData()
                
                //分页控制
                let total = result["total"].intValue
                if self.dataArray.count == total {
                    self.table.mj_footer.endRefreshingWithNoMoreData()
                }else {
                    self.table.mj_footer.resetNoMoreData()
                }
                
                
        }) { (error) in
            self.table.reloadData()
            
            self.table.mj_header.endRefreshing()
            self.table.mj_footer.endRefreshing()
        }
    }
}

extension CQAttendancePersonVC:UIScrollViewDelegate{
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
}

extension CQAttendancePersonVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "NCQAttendancePersonCellId") as! NCQAttendancePersonCell
         let cell = QRKaoQingJiLuTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "QRAttendancePersonCellId")
        //let cell = NCQAttendancePersonCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "NCQAttendancePersonCellId")
        if indexPath.row%2 == 0{
            cell.backgroundColor = UIColor.white
            
        }else{
            cell.backgroundColor = kProjectBgColor
            cell.statusTextView.backgroundColor = kProjectBgColor
        }
        if (cell.contentView.subviews.last != nil)  {
            cell.contentView.subviews.last?.removeFromSuperview()
        }
        
        cell.model = self.dataArray[indexPath.row]
        cell.rootVc = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let cell = NCQAttendancePersonCell()
//        return cell.refreshCellWithModel(model: self.dataArray[indexPath.row], index: indexPath)
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}


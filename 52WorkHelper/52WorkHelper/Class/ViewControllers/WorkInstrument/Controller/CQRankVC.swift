//
//  CQRankVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/4/27.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQRankVC: SuperVC {

    var timeString = ""
    var pageNum = 1
    var dataArray = [CQRankModel]()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.separatorInset = UIEdgeInsets.init(top: 0, left: kLeftDis, bottom: 0, right: 0)
        table.separatorColor = kLineColor
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 177)))
        return headView
    }()
    
    lazy var bgView: UIImageView = {
        let bgView = UIImageView.init(frame: CGRect.init(x: kLeftDis, y: kLeftDis, width: kWidth - 2*kLeftDis, height: AutoGetHeight(height: 147)))
        bgView.image = UIImage.init(named: "CQRankBgImg")
        return bgView
    }()
    
    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView.init(frame: CGRect.init(x: AutoGetWidth(width: 18), y: AutoGetHeight(height: 17), width: AutoGetWidth(width: 70), height: AutoGetWidth(width: 70)))
        iconImg.image = UIImage.init(named: "personDefaultIcon")
        iconImg.layer.cornerRadius = AutoGetWidth(width: 35)
        iconImg.clipsToBounds = true
        return iconImg
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 15), y: AutoGetHeight(height: 35), width: (kWidth - AutoGetWidth(width: 30))/3, height: AutoGetHeight(height: 18)))
        nameLab.textAlignment = .left
        nameLab.textColor = UIColor.black
        nameLab.text = ""
        nameLab.font = kFontSize18
        return nameLab
    }()
    
    lazy var jobLab: UILabel = {
        let jobLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 15), y: AutoGetHeight(height: 9) + self.nameLab.bottom, width: (kWidth - AutoGetWidth(width: 30))/3, height: AutoGetHeight(height: 32)))
        jobLab.textAlignment = .left
        jobLab.textColor = kLyGrayColor
        jobLab.text = ""
        jobLab.font = kFontSize12
        jobLab.numberOfLines = 0
        return jobLab
    }()
    
    lazy var timeLab: UILabel = {
        let timeLab = UILabel.init(frame: CGRect.init(x: (kWidth - AutoGetWidth(width: 30))/2.0, y: AutoGetHeight(height: 44) , width: (kWidth - AutoGetWidth(width: 30))/2 - AutoGetWidth(width: 25), height: AutoGetHeight(height: 30)))
        timeLab.textAlignment = .right
        timeLab.textColor = UIColor.colorWithHexString(hex: "#f89800")
        timeLab.text = ""
        timeLab.font = kFontBoldSize30
        return timeLab
    }()
    
    
    lazy var rankImg: UIImageView = {
        let rankImg = UIImageView.init(frame: CGRect.init(x: AutoGetWidth(width: 33), y: self.iconImg.bottom + AutoGetHeight(height: 20), width: AutoGetWidth(width: 17.5), height: AutoGetHeight(height: 14)))
        rankImg.image = UIImage.init(named: "rankPaiHang")
        return rankImg
    }()
    
    lazy var rankLab: UILabel = {
        let rankLab = UILabel.init(frame: CGRect.init(x: self.rankImg.right + AutoGetWidth(width: 11), y: self.iconImg.bottom + AutoGetHeight(height: 20) , width: AutoGetWidth(width: 100), height: AutoGetHeight(height: 14)))
        rankLab.textAlignment = .left
        rankLab.textColor = kLyGrayColor
        rankLab.text = ""
        rankLab.font = kFontSize14
        return rankLab
    }()
    
    lazy var zanBtn: UIButton = {
        let zanBtn = UIButton.init(type: .custom)
        zanBtn.frame = CGRect.init(x: (kWidth - 2*kLeftDis)/2, y:self.iconImg.bottom + AutoGetHeight(height: 17) , width: (kWidth - 2*kLeftDis)/2 - AutoGetWidth(width: 25), height: AutoGetHeight(height: 20))
        zanBtn.titleLabel?.textAlignment = .right
        zanBtn.titleLabel?.font = kFontSize14
        zanBtn.setImage(UIImage.init(named: "rankZan"), for: .normal)
        zanBtn.setTitleColor(kLyGrayColor, for: .normal)
        zanBtn.setTitle("", for: .normal)
        zanBtn.titleEdgeInsets = UIEdgeInsets.init(top: 1, left:0, bottom: 0, right: -AutoGetWidth(width: 80))
        zanBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left:0, bottom: 0, right: -AutoGetWidth(width: 70))
        zanBtn.isUserInteractionEnabled = false
        return zanBtn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "排行榜"
        
        self.setUpRefresh()
        
        self.view.addSubview(self.table)
        
        self.table.register(CQRankCell.self, forCellReuseIdentifier: "CQRankCellId")
        self.table.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CQRankHeader")
        
        
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.bgView)
        self.bgView.addSubview(self.iconImg)
        self.bgView.addSubview(self.nameLab)
        self.bgView.addSubview(self.jobLab)
        self.bgView.addSubview(self.timeLab)
        self.bgView.addSubview(self.rankImg)
        self.bgView.addSubview(self.rankLab)
        self.bgView.addSubview(self.zanBtn)
    }

    

}

//Mark 数据加载
extension CQRankVC{
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
       // let base = "http://192.168.3.30:8080/smart_asst_52_app/api/v1"
        STNetworkTools.requestData(URLString:"\(baseUrl)/attendance/viewRankingList" ,
            type: .get,
            param: ["emyeId":userID,
                    "currentPage":pageNum,
                    "pageSize":"10",
                    "dateStr":self.timeString],
            successCallBack: { (result) in
                var tempArray = [CQRankModel]()
                for modalJson in result["data"]["dataList"].arrayValue {
                    guard let modal = CQRankModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                
                if moreData {
                    self.dataArray.append(contentsOf: tempArray)
                } else {
                    self.dataArray = tempArray
                }
                
                guard let modal = CQRankModel(jsonData: result["data"]["mySort"]) else {
                    return
                }
                
              //  if modal.emyeId == userID{
                   // self.headView.isHidden = false
                    self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 177))
                    self.iconImg.sd_setImage(with: URL(string: modal.headImage ), placeholderImage:UIImage.init(named: "personDefaultIcon") )
                    self.nameLab.text = modal.realName
                    self.jobLab.text = modal.positionName
                
                    if modal.attendanceTime == "" || modal.attendanceTime.count < 7 {
                        self.timeLab.text = ""
                    }else{
                         self.timeLab.text = (modal.attendanceTime as NSString).substring(with: NSRange.init(location: 0, length: 5))
                    }
                    self.rankLab.text =  "第" + modal.sort + "名"
                    self.zanBtn.setTitle("被赞" + modal.likeCount + "次", for: .normal)
               // }else{
//                    self.headView.isHidden = true
//                    self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: 0)
//                    self.table.tableHeaderView = self.headView
//                }
                
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
    
    //点赞
    func rankZanRequest(attendanceRecordId:String,index:IndexPath) {
        let userID = STUserTool.account().userID
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/attendance/attendanceLike" ,
            type: .get,
            param: ["emyeId":userID,
                    "dateStr":self.timeString,
                    "dayStatisticsRecordId":attendanceRecordId],
            successCallBack: { (result) in
                
                
                
                let cell:CQRankCell = self.table.cellForRow(at: index) as! CQRankCell
                if result["data"]["likeSign"].boolValue {
                    cell.zanBtn.setImage(UIImage.init(named: "rankZan"), for: .normal)
                }else{
                    cell.zanBtn.setImage(UIImage.init(named: "rankUnselectZan"), for: .normal)
                }
                cell.layoutIfNeeded()
                
                self.loadDatas(moreData: false)
        }) { (error) in
            
        }
    }
    
}



extension CQRankVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQRankCellId") as! CQRankCell
        
        if indexPath.row == 0 {
            cell.rankLab.textColor = UIColor.colorWithHexString(hex: "#f8c904")
        }else if indexPath.row == 1 {
            cell.rankLab.textColor = UIColor.colorWithHexString(hex: "#a3b1c4")
        }else if indexPath.row == 2 {
            cell.rankLab.textColor = UIColor.colorWithHexString(hex: "#ba7e07")
        }else if indexPath.row == 3 {
            cell.rankLab.textColor = UIColor.colorWithHexString(hex: "#b5b5b5")
        }else{
            cell.rankLab.textColor = UIColor.colorWithHexString(hex: "#b4b4b4")
        }
        cell.zanDelegate = self
        cell.model = self.dataArray[indexPath.row]
        cell.timeLab.font = kFontSize15
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoGetHeight(height: 55)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AutoGetHeight(height: 40)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        
        header.backgroundColor = UIColor.white
        header.layer.borderColor = kLineColor.cgColor
        header.layer.borderWidth = 0.5
        let titleLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kWidth - 2 * kLeftDis, height: AutoGetHeight(height: 40)))
        titleLab.font = kFontSize16
        titleLab.textAlignment = .left
        titleLab.textColor = UIColor.black
        titleLab.text = "今日排行榜"
        header.addSubview(titleLab)
        return header
    }
}

extension CQRankVC:CQRankZanDelegate{
    func refreshUIWithZan(index: IndexPath) {
        let model = self.dataArray[index.row]
        self.rankZanRequest(attendanceRecordId: model.dayStatisticsRecordId, index: index)
    }
}



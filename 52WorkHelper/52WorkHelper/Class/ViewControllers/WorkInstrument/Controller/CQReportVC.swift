//
//  CQReportVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/9.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQReportVC: SuperVC {

    var bgImg:UIImageView?
    var pageNum = 1
    var dataArray = [CQReportModel]()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        //        table.backgroundColor = kProjectBgColor
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 106)))
        headView.backgroundColor = kProjectBgColor
        return headView
    }()
    
    lazy var labBgView: UIView = {
        let labBgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 55)))
        labBgView.backgroundColor = UIColor.white
        return labBgView
    }()
    
    lazy var recieveLab: UILabel = {
        let recieveLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kHaveLeftWidth, height: AutoGetHeight(height: 55)))
        recieveLab.text = "我收到的汇报"
        recieveLab.textColor = UIColor.black
        recieveLab.textAlignment = .left
        recieveLab.font = kFontSize15
        return recieveLab
    }()
    
    lazy var recieveBtn: UIButton = {
        let recieveBtn = UIButton.init(type: .custom)
        recieveBtn.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 55))
        recieveBtn.setImage(UIImage.init(named: "PersonAddressArrow"), for: .normal)
        recieveBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: AutoGetWidth(width: 330), bottom: 0, right: 0)
        recieveBtn.addTarget(self, action: #selector(recieveClick), for: .touchUpInside)
        return recieveBtn
    }()
    
    lazy var sectionBgView: UIView = {
        let sectionBgView = UIView.init(frame: CGRect.init(x: 0, y: self.labBgView.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 38)))
        sectionBgView.backgroundColor = UIColor.white
        let lineView = UIView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 38) - 0.5, width: kWidth, height: 0.5))
        lineView.backgroundColor = kfilterBackColor
        sectionBgView.addSubview(lineView)
        return sectionBgView
    }()
    
    lazy var sectionLab: UILabel = {
        let sectionLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kHaveLeftWidth, height: AutoGetHeight(height: 38)))
        sectionLab.text = "我发送的"
        sectionLab.textColor = UIColor.black
        sectionLab.textAlignment = .left
        sectionLab.font = kFontSize15
        return sectionLab
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "汇报"
        
        self.setUpRefresh()
        
        self.view.addSubview(self.table)
        self.table.register(CQMyReportCell.self, forCellReuseIdentifier: "CQMyReportCellId")
        
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.labBgView)
        self.labBgView.addSubview(self.recieveLab)
        self.labBgView.addSubview(self.recieveBtn)
        self.headView.addSubview(self.sectionBgView)
        self.sectionBgView.addSubview(self.sectionLab)
    
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        rightBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: -25)
        rightBtn.setImage(UIImage.init(named: "FriendAdd"), for: .normal)
        rightBtn.addTarget(self, action: #selector(addClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUI(notification:)), name: NSNotification.Name.init("refreshReprotFromWrite"), object: nil)
        
    }
    
    @objc func refreshUI(notification:Notification)  {
        self.setUpRefresh()
    }
    
    @objc func addClick()  {
        initSelectView()
    }
    
    func initSelectView()  {
        let selectView = CQReportSelectView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight))
        selectView.cqSelectDelegate = self
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.addSubview(selectView)
        
    }
    
    @objc func recieveClick()  {
        let vc = CQRecieveReportVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}

extension CQReportVC{
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
        STNetworkTools.requestData(URLString:"\(baseUrl)/personnelReport/getPersonnelReportByPage" ,
            type: .get,
            param: ["userId":userID,
                    "currentPage":pageNum,
                    "rows":"10",
                    "reportType":"1",
                    "searchmode":"1"],
            successCallBack: { (result) in
                var tempArray = [CQReportModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQReportModel(jsonData: modalJson) else {
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


extension CQReportVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CQMyReportCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "CQMyReportCellId")
        cell.findDelegate = self
        cell.isReadLab.isHidden = true
        if (cell.contentView.subviews.last != nil)  {
            cell.contentView.subviews.last?.removeFromSuperview()
        }
        cell.model = self.dataArray[indexPath.row]
        
        let model = self.dataArray[indexPath.row]
        
        if model.reportType == "1"{
            cell.nameLab.text = "我的日报"
        }else if model.reportType == "2"{
            cell.nameLab.text = "我的周报"
        }else if model.reportType == "3"{
            cell.nameLab.text = "我的月报"
        }
        
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataArray[indexPath.row]
        let vc = CQFulltextVC.init()
        vc.personnelReportId = model.personnelReportId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = CQMyReportCell()
        return cell.getHeightWithModel(model:self.dataArray[indexPath.row])
    }
    
    
}

extension CQReportVC:CQFindMoreClickDelegate{
    func goToReportFullTextView(index: IndexPath) {
        let model = self.dataArray[index.row]
        let vc = CQFulltextVC.init()
        vc.personnelReportId = model.personnelReportId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension CQReportVC:CQReportSelectDelegate{
    func pushToDetailThroughType(btn: UIButton) {
        let vc = CQWriteReportVC.init()
        if btn.tag == 400 {
            vc.wirteType = .day
        }else if btn.tag == 401 {
            vc.wirteType = .week
        }else {
            vc.wirteType = .month
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

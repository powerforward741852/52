//
//  CQRecieveReportVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/17.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQRecieveReportVC: SuperVC {

    var detailTable:CQRecieveTable?
    var dataArray = [CQReportModel]()
    var pageNum = 1
    var reportType = "1"
    var lastBtn:UIButton?
    
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.backgroundColor = UIColor.white
        table.separatorStyle = .none
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight))
        headView.backgroundColor = kProjectBgColor
        return headView
    }()
    
    lazy var btnView: UIView = {
        let btnView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 44)))
        btnView.backgroundColor = UIColor.white
        return btnView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: btnView.bottom, width: kWidth, height: kHeight - AutoGetHeight(height: 44) ))
        scrollView.contentSize = CGSize.init(width: kWidth*3, height: kHeight - AutoGetHeight(height: 44))
        scrollView.backgroundColor = UIColor.white
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView.init(frame: CGRect.init(x: (kWidth/3 - AutoGetWidth(width: 60))/2, y: AutoGetHeight(height: 42), width: AutoGetWidth(width: 60), height: AutoGetHeight(height: 2)))
        lineView.backgroundColor = kLightBlueColor
        return lineView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingPlay()
        self.setUpRefresh()
        self.title = "我收到的"
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.btnView)
        self.btnView.addSubview(self.lineView)
        initBtn()
        self.headView.addSubview(self.scrollView)
        initTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadingPlay()
        self.setUpRefresh()
    }
    
    func initBtn()  {
        let titleArr = ["日报","周报","月报"]
        for i in 0..<3 {
            let btn = UIButton.init(type: .custom)
            btn.frame = CGRect.init(x: kWidth/3 * CGFloat(i), y: 0, width: kWidth/3, height: AutoGetHeight(height: 44))
            btn.setTitle(titleArr[i], for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.tag = 300+i
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            btn.titleLabel?.font = kFontSize15
            self.btnView.addSubview(btn)
        }
    }
    
    func initTable()  {
        for i in 0..<3 {
            self.detailTable = CQRecieveTable.init(frame: CGRect.init(x: kWidth * CGFloat(i), y: 0, width: kWidth, height: kHeight - AutoGetHeight(height: 44) - 64), style: .plain)
            detailTable?.dataArray = self.dataArray
            detailTable?.recieveDelegate = self
            detailTable?.tag = 800 + i
            self.scrollView.addSubview(self.detailTable!)
        }
    }
    
    @objc func btnClick(btn:UIButton)  {
        if lastBtn?.tag != btn.tag {
            lastBtn?.setTitleColor(UIColor.black, for: .normal)
            btn.setTitleColor(kLightBlueColor, for: .normal)
            lastBtn = btn
            self.lineView.frame.origin.x = (kWidth/3 - AutoGetWidth(width: 60))/2 + kWidth/3 * CGFloat(btn.tag - 300)
            
            self.scrollView.setContentOffset(CGPoint.init(x: kWidth * CGFloat(btn.tag - 300), y: 0), animated: true)
            if btn.tag == 300 {
                self.reportType = "1"
            }else if btn.tag == 301 {
                self.reportType = "2"
            }else{
                self.reportType = "3"
            }
            self.loadingPlay()
            self.setUpRefresh()
        }
    }
    
}

extension CQRecieveReportVC{
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
        let tab:CQRecieveTable = self.view.viewWithTag(800 + Int(self.reportType)! - 1) as! CQRecieveTable
        tab.isMyRecieve = true
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/personnelReport/getPersonnelReportByPage" ,
            type: .get,
            param: ["userId":userID,
                    "currentPage":pageNum,
                    "rows":"10",
                    "reportType":self.reportType,
                    "searchmode":"2"],
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
                
                tab.dataArray = self.dataArray
                tab.layoutIfNeeded()
                //刷新表格
                self.table.mj_header.endRefreshing()
                self.table.mj_footer.endRefreshing()
                tab.reloadData()
                
                //分页控制
                let total = result["total"].intValue
                if self.dataArray.count == total {
                    self.table.mj_footer.endRefreshingWithNoMoreData()
                }else {
                    self.table.mj_footer.resetNoMoreData()
                }
                
                self.loadingSuccess()
        }) { (error) in
            tab.reloadData()
            self.loadingSuccess()
            self.table.mj_header.endRefreshing()
            self.table.mj_footer.endRefreshing()
        }
    }    
    
}

extension CQRecieveReportVC:UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / scrollView.frame.width
        let titleButton:UIButton = self.view.viewWithTag(Int(300+index)) as! UIButton
        lastBtn?.setTitleColor(UIColor.black, for: .normal)
        titleButton.setTitleColor(kLightBlueColor, for: .normal)
        self.lineView.frame = CGRect.init(x: (kWidth/3 - AutoGetWidth(width: 60))/2 + kWidth/3 * CGFloat(index), y: AutoGetHeight(height: 42), width: AutoGetWidth(width: 60), height: AutoGetHeight(height: 2))
        lastBtn = titleButton
        if titleButton.tag == 300 {
            self.reportType = "1"
        }else if titleButton.tag == 301 {
            self.reportType = "2"
        }else{
            self.reportType = "3"
        }
        self.loadingPlay()
        self.setUpRefresh()
    }
}

extension CQRecieveReportVC:CQRecieveReportDelegate{
    func pushToDetail(personnelReportId: String) {
        let vc = CQFulltextVC.init()
        vc.personnelReportId = personnelReportId
        vc.toType = .fromMyRecieve
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

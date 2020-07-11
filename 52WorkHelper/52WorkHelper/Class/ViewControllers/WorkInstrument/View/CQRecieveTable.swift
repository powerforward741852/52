//
//  CQRecieveTable.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/17.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol CQRecieveReportDelegate : NSObjectProtocol{
    func pushToDetail(personnelReportId:String)
}

class CQRecieveTable: UITableView {

    weak var recieveDelegate:CQRecieveReportDelegate?
    var dataArray = [CQReportModel]()
    var isMyRecieve = false
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.backgroundColor = kProjectBgColor
        self.delegate = self
        self.dataSource = self
        self.separatorStyle = .none
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        self.tableFooterView = view
        self.register(CQMyReportCell.self, forCellReuseIdentifier: "CQMyReportCellId")
        //        self.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CQAddressBookHeader")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension CQRecieveTable:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CQMyReportCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "CQMyReportCellId")
        if (cell.contentView.subviews.last != nil)  {
            cell.contentView.subviews.last?.removeFromSuperview()
        }
        cell.model = self.dataArray[indexPath.row]
        if self.isMyRecieve{
            if self.dataArray[indexPath.row].createUserId == STUserTool.account().userID{
                if self.dataArray[indexPath.row].reportType == "1"{
                    cell.nameLab.text = "我的日报"
                }else if self.dataArray[indexPath.row].reportType == "2"{
                    cell.nameLab.text = "我的周报"
                }else if self.dataArray[indexPath.row].reportType == "3"{
                    cell.nameLab.text = "我的月报"
                }
            }
        }
        cell.findDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataArray[indexPath.row]
        self.loadHasReadData(personnelReportId: model.personnelReportId)
        if self.recieveDelegate != nil {
            self.recieveDelegate?.pushToDetail(personnelReportId: model.personnelReportId)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = CQMyReportCell()
        return cell.getHeightWithModel(model:self.dataArray[indexPath.row])
    }
    
    
}

extension CQRecieveTable{
    func loadHasReadData(personnelReportId:String)  {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/personnelReport/setPersonnelReportReadSign",
            type: .post,
            param: ["personnelReportId":personnelReportId,
                    "userId":userID],
            successCallBack: { (result) in
                
                self.reloadData()
        }) { (error) in
            
        }
    }
}

extension CQRecieveTable:CQFindMoreClickDelegate{
    func goToReportFullTextView(index: IndexPath) {
        let model = self.dataArray[index.row]
        self.loadHasReadData(personnelReportId: model.personnelReportId)
        if self.recieveDelegate != nil {
            self.recieveDelegate?.pushToDetail(personnelReportId: model.personnelReportId)
        }
    }
}

//
//  CQChildDepartmentTable.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/11.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol CQChildTableDelegate : NSObjectProtocol{
    func pushToContactDetailVC(model:CQDepartMentUserListModel)
}

protocol CQGroupSelectDelegate : NSObjectProtocol{
    func changeSelectImg(hasSelectArr:[CQDepartMentUserListModel])
}

protocol CQScheduleWorkMateSelectDelegate : NSObjectProtocol{
    func selectWorkMate(uid:String)
}

protocol CQOverTimeChildSelectDelegate : NSObjectProtocol{
    func overSelectImg(userModelArr:CQDepartMentUserListModel)
}

protocol CQTranferAproveDelegate : NSObjectProtocol{
    func transferAprove(uid:String)
}

class CQChildDepartmentTable: UITableView {
    var hasSelectModelArr = [CQDepartMentUserListModel]()
    var typeStr:String?
    var hasLoad:Bool = false
    weak var childTableDelegate:CQChildTableDelegate?
    var dataArray = [CQDepartMentUserListModel]()
    var isFromLaunchGroupChat = false //是否发起群聊
    weak var changeDelegate:CQGroupSelectDelegate?
    var selectArr = [Bool]()
    
    //下面是选择同事参数
    var isFromSchedule = false
    weak var workMateSelectDelegate:CQScheduleWorkMateSelectDelegate?
    
    var isOverTime = false //从加班入
    weak var overTimeDelegate:CQOverTimeChildSelectDelegate?
    var lastSelect:IndexPath?
    
    var isFromCreateSchedule = false
    //记录旧的选择状态数据
    var oldSelectArr = [Bool]()
    
    
    var isTransferApprove = false
    weak var turnDelegate:CQTranferAproveDelegate?
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.backgroundColor = UIColor.white
        self.delegate = self
        self.dataSource = self
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        self.tableFooterView = view
        self.register(CQAdressBookCell.self, forCellReuseIdentifier: "CQAddressBookCellId")
        
//        self.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CQAddressBookHeader")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadDataWithSelectArr(statusArr:[Bool])  {
        self.selectArr = statusArr
        self.reloadData()
    }
    
    func reloadDataWithSelectArr(statusArr:[Bool],index:IndexPath)  {
        let cell = self.cellForRow(at: index) as! CQAdressBookCell
        cell.selectStatus = statusArr[index.row]
        cell.layoutSubviews()
    }
   
}

extension CQChildDepartmentTable:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQAddressBookCellId") as! CQAdressBookCell
        if isFromLaunchGroupChat == true {
            cell.selectBtn.isHidden = false
            cell.iconImg.frame.origin.x = cell.selectBtn.right
            cell.nameLab.frame.origin.x = cell.iconImg.right + kLeftDis
            cell.jobLab.frame.origin.x = cell.iconImg.right + kLeftDis
            cell.cellSelDelegate = self
            cell.selectStatus = self.selectArr[indexPath.row]
            cell.layoutSubviews()
        }
        cell.model = self.dataArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoGetHeight(height: 55)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataArray[indexPath.row]
        
        
        if isFromSchedule {
            if self.workMateSelectDelegate != nil{
                self.workMateSelectDelegate?.selectWorkMate(uid: model.userId)
            }
        }else if isOverTime{
            if (self.lastSelect != nil) {
                let lastCell = tableView.cellForRow(at: self.lastSelect!)
                lastCell?.accessoryType = .none
            }
            
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
            self.lastSelect = indexPath
            
            if self.overTimeDelegate != nil{
                self.overTimeDelegate?.overSelectImg(userModelArr: model)
            }
        } else if self.isTransferApprove{
            if self.turnDelegate != nil{
                self.turnDelegate?.transferAprove(uid: model.userId)
            }
        } else{
            if childTableDelegate != nil {
                self.childTableDelegate?.pushToContactDetailVC(model: model)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AutoGetHeight(height: 5)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 5)))
        header.backgroundColor = kProjectBgColor
//        let lab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kHaveLeftWidth, height: AutoGetHeight(height: 17)))
//        lab.text = "常用联系人"
//        lab.textAlignment = .left
//        lab.textColor = kLyGrayColor
//        lab.font = kFontSize10
//        header.addSubview(lab)
        return header
    }
 
}

extension CQChildDepartmentTable:cellSelectDelegate{
    func pushToTable(index: IndexPath) {
        let model = self.dataArray[index.row]
        let cell = self.cellForRow(at: index)
        if !(cell as! CQAdressBookCell).selectStatus! {
            self.hasSelectModelArr.append(model)
        }else{
            for i in 0..<self.hasSelectModelArr.count{
                let hModel = self.hasSelectModelArr[i]
                if hModel.userId == model.userId{
                    self.hasSelectModelArr.remove(at: i)
                    break
                }
            }
        }
        let num = index.row
        let sec = index.row + 1
        let selectStaues = self.selectArr[index.row]
        self.selectArr.replaceSubrange(Range(num ..< sec), with: [!selectStaues])
        self.reloadData()
        if self.changeDelegate != nil {
            self.changeDelegate?.changeSelectImg(hasSelectArr: self.hasSelectModelArr)
        }
    }
}



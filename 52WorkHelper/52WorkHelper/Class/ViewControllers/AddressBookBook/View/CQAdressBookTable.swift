//
//  CQAdressBookTable.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/2.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit


protocol CQAddressBookTableDelegate : NSObjectProtocol{
    func pushToContactDetailVC(model:CQDepartMentUserListModel)
}

protocol CQAddressBookChangeSelectDelegate : NSObjectProtocol{
    func changeSelectImg(hasSelectArr:[CQDepartMentUserListModel])
}

protocol CQOverTimeSelectDelegate : NSObjectProtocol{
    func overSelectImg(userModelArr:CQDepartMentUserListModel)
}

protocol CQScheduleFromAddressChooseDelegate : NSObjectProtocol{
    func selectWorkMate(uid:String)
}

protocol CQTurnOverDelegate : NSObjectProtocol{
    func turnOverClcik(uid:String)
}

class CQAddressBookTable: UITableView {
    var hasSelectModelArr = [CQDepartMentUserListModel]()
    var lastSelect:IndexPath?
    var dataArr = [CQDepartMentUserListModel]()
    var typeStr:String?
    var hasLoad:Bool = false
    weak var addressTableDelegate:CQAddressBookTableDelegate?
    var isFromLaunchGroupChat = false
    weak var changeDelegate:CQAddressBookChangeSelectDelegate?
    var selectArr = [Bool]()
    var isOverTime = false //从加班入
    weak var overTimeDelegate:CQOverTimeSelectDelegate?
    //日程选择同事参数
    var isFromSchedule = false
    weak var workmateSelectDelegate:CQScheduleFromAddressChooseDelegate?
    
    var isFromCreateSchedule = false //是否是创建日程  默认选择自己
    
    var isTransferApprove = false
    weak var turnDelegate:CQTurnOverDelegate?
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    
        self.loadData()
        
        self.backgroundColor = UIColor.white
        self.delegate = self
        self.dataSource = self
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        self.tableFooterView = view
        self.register(CQAdressBookCell.self, forCellReuseIdentifier: "CQAddressBookCellId")
        self.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CQAddressBookHeader")
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadDataWithSelectArr(statusArr:[Bool])  {
        self.selectArr = statusArr
        self.reloadData()
    }
    
    func loadData()  {
        self.dataArr.removeAll()
        self.selectArr.removeAll()
        
        let uData = UserDefaults.standard.object(forKey: "userArray")
        if uData != nil {
            let uArr:[CQDepartMentUserListModel] = NSKeyedUnarchiver.unarchiveObject(with: uData as! Data) as! [CQDepartMentUserListModel]
            self.dataArr = uArr
            DLog(uArr)
        }
        for _ in self.dataArr {
            self.selectArr.append(false)
        }
        if self.hasSelectModelArr.count > 0 {
            
            for i in 0..<self.selectArr.count{
                let model = self.dataArr[i]
                for m in self.hasSelectModelArr{
                    if m.userId == model.userId{
                        let num = i
                        let sec = i + 1
                        self.selectArr.replaceSubrange(Range(num ..< sec), with: [!self.selectArr[i]])
                    }
                }
            }
        }
    }
}

extension CQAddressBookTable:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
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
        cell.model = self.dataArr[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoGetHeight(height: 55)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataArr[indexPath.row]
        if isFromSchedule {
            if self.workmateSelectDelegate != nil{
                self.workmateSelectDelegate?.selectWorkMate(uid: model.userId)
            }
        }else if isOverTime {
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
        }else if self.isTransferApprove{
            if self.turnDelegate != nil{
                self.turnDelegate?.turnOverClcik(uid: model.userId)
            }
        } else{
            
            if addressTableDelegate != nil {
                self.addressTableDelegate?.pushToContactDetailVC(model:model)
            }
        }
            
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AutoGetHeight(height: 17)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 17)))
        header.backgroundColor = kProjectBgColor
        let lab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kHaveLeftWidth, height: AutoGetHeight(height: 17)))
        lab.text = "常用联系人"
        lab.textAlignment = .left
        lab.textColor = kLyGrayColor
        lab.font = kFontSize10
        header.addSubview(lab)
        return header
    }
    
    //返回编辑类型，滑动删除
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    //在这里修改删除按钮的文字
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    //点击删除按钮的响应方法，在这里处理删除的逻辑
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let uData = UserDefaults.standard.object(forKey: "userArray")
            if uData != nil {
                self.dataArr.remove(at: indexPath.row)
                self.deleteRows(at: [indexPath], with: .automatic)
                let data = NSKeyedArchiver.archivedData(withRootObject: self.dataArr)
                UserDefaults.standard.set(data, forKey: "userArray")
            }
        }
    }
}

extension CQAddressBookTable:cellSelectDelegate{
//    func pushToTable(index: IndexPath) {
//        if self.changeDelegate != nil {
//            self.changeDelegate?.changeSelectImg(index: index,selectArr: self.selectArr,userModelArr:self.dataArr)
//        }
//    }
    
    func pushToTable(index: IndexPath) {
        let model = self.dataArr[index.row]
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


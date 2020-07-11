//
//  QRAddScheduleView.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2020/3/23.
//  Copyright © 2020 chenqihang. All rights reserved.
//

import UIKit

class QRAddScheduleView: UIView {

    var isAdd : Bool = false
    var isDetail : Bool = false
    var dataArray = [QRSecheduleModel]()
    
    lazy var footView : UIView = {
           let backView = UIView(frame:  CGRect(x: 0, y: 0, width: kWidth, height:54))
           backView.backgroundColor = UIColor.white
           let addBut = UIButton(frame:  CGRect(x: kLeftDis, y: 5, width: kHaveLeftWidth, height:  54 - 10))
           addBut.titleLabel?.font = kFontSize14
           addBut.setTitleColor(UIColor.black, for: .normal)
           addBut.setTitle("新建日程", for:.normal)
           addBut.backgroundColor = UIColor.white
           addBut.setImage(UIImage(named: "addCell"), for: .normal)
           addBut.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
           addBut.addTarget(self, action: #selector(add), for: UIControlEvents.touchUpInside)
           backView.addSubview(addBut)
           return backView
       }()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: 100), style: UITableViewStyle.plain)
        table.backgroundColor = UIColor.red
        if #available(iOS 11.0, *) {
            //            table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
            //            table.contentInset = UIEdgeInsetsMake(CGFloat(SafeAreaTopHeight), 0, CGFloat(SafeAreaBottomHeight), 0);
            //            table.scrollIndicatorInsets = table.contentInset;
        } else {
            //低于 iOS 9.0
          //  self.automaticallyAdjustsScrollViewInsets = false
        }
        table.register(QRAddScheduleCell.self, forCellReuseIdentifier: "QRAddScheduleCellid")
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
        table.allowsSelection = false
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        
        table.estimatedRowHeight = 0
        table.isScrollEnabled = false
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(table)
        let blank = QRSecheduleModel(isCompleted: false, content: "")
        self.dataArray = [blank]
        table.tableFooterView = self.footView
    }
    
    @objc  func add(){
        let mod = QRSecheduleModel(isCompleted: true, content: "")
        self.dataArray.append(mod)
        
//        self.table.reloadData()
//        let cell = self.table.dequeueReusableCell(withIdentifier: "QRAddScheduleCellid") as! QRAddScheduleCell
//        cell.rootV = self
//        cell.indexP = IndexPath(item: dataArray.count-1, section: 0)
//        cell.table = table
//        cell.isAdd = self.isAdd
//        cell.isDetail = self.isDetail
//        cell.model = mod
//        cell.clickClosure = nil
//        cell.clickClosure = { [unowned self] (index) in
//            self.dataArray.remove(at: index!.row)
//            self.table.reloadData()
//            let height = self.table.contentSize.height
//            self.table.frame.size = CGSize(width: kWidth, height: height)
//            let userDic = ["height":height]
//            NotificationCenter.default.post(name: NSNotification.Name.init("scheduleUpdateHeight"), object: self, userInfo:userDic)
//        }
//
//
//        self.table.beginUpdates()
//        self.table.endUpdates()
        
        
        self.table.insertRows(at: [IndexPath(item: dataArray.count-1, section: 0)], with: UITableViewRowAnimation.fade)
        self.table.reloadData()
        
        let height = self.table.contentSize.height  //self.calculateHeight()//
        self.table.frame.size = CGSize(width: kWidth, height: height)
        let userDic = ["height":height]
        NotificationCenter.default.post(name: NSNotification.Name.init("scheduleUpdateHeight"), object: self, userInfo:userDic)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func calculateHeight()->CGFloat{
        var height : CGFloat = 0
        for (_,item )in dataArray.enumerated(){
            height += item.rowHeight
        }
        
        return height+54  //table.contentSize.height//
    }

}

extension QRAddScheduleView:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QRAddScheduleCellid", for: indexPath) as! QRAddScheduleCell
        cell.rootV = self
        cell.indexP = indexPath
        if indexPath.row == 0{
            cell.deleteBtn.isHidden = true
        }else{
            cell.deleteBtn.isHidden = false
        }
        cell.table = table
        cell.isAdd = self.isAdd
        cell.isDetail = self.isDetail
        cell.model = dataArray[indexPath.row]
        cell.clickClosure = nil
        cell.clickClosure = { [unowned self] (index) in
            self.dataArray.remove(at: index!.row)
            self.table.reloadData()
            let height = self.table.contentSize.height
            self.table.frame.size = CGSize(width: kWidth, height: height)
            let userDic = ["height":height]
            NotificationCenter.default.post(name: NSNotification.Name.init("scheduleUpdateHeight"), object: self, userInfo:userDic)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let mod = dataArray[indexPath.row]
        print("\(mod.rowHeight)")
        return mod.rowHeight
    }
}

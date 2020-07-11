//
//  CQTaskTable.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/29.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol CQTaskSelectDelegate : NSObjectProtocol{
    func pushToDetailVC(personnelTaskId:String)
}

class CQTaskTable: UITableView {

    var hasLoad:Bool = false
    var dataArray = [CQTaskModel]()
    weak var selectDelegate:CQTaskSelectDelegate?
    var isMePublish = false
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.backgroundColor = UIColor.white
        self.delegate = self
        self.dataSource = self
        self.separatorColor = kLineColor
        self.separatorInset = UIEdgeInsets.init(top: 0, left: kLeftDis, bottom: 0, right: 0)
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        self.tableFooterView = view
        self.register(CQTaskCell.self, forCellReuseIdentifier: "CQTaskCellId")
        self.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CQTaskHeaderView")
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CQTaskTable:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQTaskCellId") as! CQTaskCell
        cell.model = self.dataArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoGetHeight(height: 71)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataArray[indexPath.row]
        if self.selectDelegate != nil {
            self.selectDelegate?.pushToDetailVC(personnelTaskId: model.personnelTaskId)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.isMePublish {
            return 0.01
        }
        return AutoGetHeight(height: 40)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init()
        if self.isMePublish {
            header.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 0.01))
        }else{
            header.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 40))
            header.backgroundColor = UIColor.white
            let lab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kHaveLeftWidth, height: AutoGetHeight(height: 40)))
            lab.text = "我收到的任务"
            lab.textAlignment = .left
            lab.textColor = UIColor.black
            lab.font = kFontSize15
            header.addSubview(lab)
        }
        
        
        return header
    }
}

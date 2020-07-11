//
//  CQChooseDistanceTable.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/9/27.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol distanceSelectDelegate : NSObjectProtocol{
    func chooseDistanceAction(distance:String)
}

class CQChooseDistanceTable: UITableView {

    var dataArray = ["500","1000","2000","3000"]
    weak var selectDelegate:distanceSelectDelegate?
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
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CQChooseDistanceTable:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "chooseDistanceId")
        cell.textLabel?.text = self.dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoGetHeight(height: 40)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.selectDelegate != nil{
            self.selectDelegate?.chooseDistanceAction(distance: self.dataArray[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}

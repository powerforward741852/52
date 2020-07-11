//
//  CQCarTypeVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/7/2.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol CQCarTypeSelectDelegate : NSObjectProtocol{
    func carTypeSelect(carType:Int,name:String)
}

class CQCarTypeVC: SuperVC {

    var carTypeArr = ["商务车","货车","客车"]
    weak var selectDelegate:CQCarTypeSelectDelegate?
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        //        table.backgroundColor = kProjectBgColor
        table.delegate = self
        table.dataSource = self
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "车辆类型"
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "CQCarTypeCellId")
    }
}


extension CQCarTypeVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.carTypeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQCarTypeCellId")
        cell?.textLabel?.text = self.carTypeArr[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var car = 0
        if self.carTypeArr[indexPath.row] == "商务车" {
            car = 1
        }else if self.carTypeArr[indexPath.row] == "货车" {
            car = 2
        }else if self.carTypeArr[indexPath.row] == "客车" {
            car = 3
        }
        if selectDelegate != nil {
            self.selectDelegate?.carTypeSelect(carType: car,name: self.carTypeArr[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return AutoGetHeight(height: 64)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AutoGetHeight(height: 0.01)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.white
        return header
    }
}

//
//  CQSupplementaryCardAppliactionRecordVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/28.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQSupplementaryCardAppliactionRecordVC: SuperVC {

    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.delegate = self
        table.backgroundColor = UIColor.white
        table.dataSource = self
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "补卡申请记录"
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        
        
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "CQSupplementRecordCell")
    }

}

extension CQSupplementaryCardAppliactionRecordVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = nil
        if cell == nil{
            cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "CQSupplementRecordCell")
        }
        cell?.accessoryType = .disclosureIndicator
        cell?.textLabel?.text = "2018-04-27 09:00"
        cell?.textLabel?.textAlignment = .left
        cell?.textLabel?.textColor = UIColor.black
        cell?.textLabel?.font = kFontSize15
        
        cell?.detailTextLabel?.text = "审批中..."
        cell?.detailTextLabel?.textAlignment = .right
        cell?.detailTextLabel?.textColor = kColorRGB(r: 238, g: 167, b: 40)
        //已通过 kLyGrayColor
        cell?.detailTextLabel?.font = kFontSize15
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoGetHeight(height: 55)
    }
}

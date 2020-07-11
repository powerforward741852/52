//
//  QRDropLeftTView.swift
//  test
//
//  Created by 秦榕 on 2019/4/22.
//  Copyright © 2019年 qq. All rights reserved.
//

import UIKit

class QRDropLeftTView: YNDropDownView {


    //声明闭包type = 0 全部成员   type = 1  选择成员
    typealias clickBtnClosure = (_ clickType:Int) -> Void
    //把申明的闭包设置成属性
     var clickClosure: clickBtnClosure?
    
    @IBOutlet weak var table: UITableView!
    var selectIndex = IndexPath(row: 0, section: 0)
    var titleArr = [["全部成员","选择成员"]]
    override func awakeFromNib() {
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .singleLine
        table.backgroundColor = UIColor.white
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.rowHeight = 44
        table.register(UITableViewCell.self, forCellReuseIdentifier: "DropMenuId")
    }
    deinit {
        print("deinit")
    }
}

extension QRDropLeftTView : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropMenuId", for: indexPath)
        cell.textLabel?.text = titleArr[indexPath.section][indexPath.row]
        
        if selectIndex == indexPath{
            //  判断是否选中,选中
            let img = UIImageView(frame:  CGRect(x: 0, y: 0, width: AutoGetWidth(width: 13), height: AutoGetHeight(height: 9)))
            img.image = UIImage(named: "ggg")
            cell.textLabel?.textColor = kBlueC
            cell.accessoryView = img
        }else{
            cell.accessoryView = nil
            cell.textLabel?.textColor = UIColor.black
        }
        
        if indexPath.row == 1{
            cell.accessoryType = .disclosureIndicator
           
        }else{
            cell.accessoryType = .none
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 && indexPath.section == 0{
              selectIndex = IndexPath(row: -1, section: -1)
              weak var weakself = self
            weakself!.clickClosure!(1)
            
        }else{
               selectIndex = indexPath
               self.changeMenu(title: "全部成员", status: YNStatus.selected, at: 0)
            clickClosure!(0)
               hideMenu()
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            return  nil
    }
    
}

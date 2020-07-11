//
//  QRScheduleFoldView.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/5/27.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class QRScheduleFoldView: UIView {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var jianTou: UIButton!

    @IBOutlet weak var detailView: UIView!
    
    
    var dataArr = [QROutRecorderModel]()
    
    
    @IBAction func jianTouAction(_ sender: Any) {
        
//        let mod = QROutRecorderModel()
//        mod.startDate = "2018/23/21 12:22"
//        mod.endDate = "2018/23/21 22:22"
//        mod.outContent = "外出是想阿斯达来"
//        mod.outImages = ["http://192.168.1.33:9094/asst_52/images/schedule20190513/cf20b6bc-fc84-4b58-a1b4-e8d0ee6509a9.jpg","http://192.168.1.33:9094/asst_52/images/schedule20190513/cf20b6bc-fc84-4b58-a1b4-e8d0ee6509a9.jpg","http://192.168.1.33:9094/asst_52/images/schedule20190513/cf20b6bc-fc84-4b58-a1b4-e8d0ee6509a9.jpg"]
//        dataArr = [mod,mod]
//        table.reloadData()
        if jianTou.isSelected == true{
            detailView.isHidden = true
        }else{
            detailView.isHidden = true
        }
        jianTou.isSelected = !jianTou.isSelected
       
        var tableHeight : CGFloat = 0
        for (_,value) in dataArr.enumerated(){
            tableHeight += value.rowheight
        }
        
        
        let userInfo = ["fold":jianTou.isSelected,"height":tableHeight] as [String : Any]
        let notification = NSNotification(name: NSNotification.Name(rawValue: "openFold"), object: nil, userInfo: userInfo)
        NotificationCenter.default.post(notification as Notification)
    }
    
    override func awakeFromNib() {
       jianTou.isSelected = false
        topLineView.backgroundColor = kProjectBgColor
        table.dataSource = self
        table.delegate = self
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .singleLine
        table.backgroundColor = UIColor.white
        table.allowsSelection = false
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        //table.register(QRFriendCircleCell.self, forCellReuseIdentifier:"friendcellid")
        table.register(UINib(nibName: "QROutRecorderCell", bundle: nil), forCellReuseIdentifier: "outRecorder")
        table.estimatedSectionHeaderHeight = 0;
        table.estimatedSectionFooterHeight = 0;
        table.estimatedRowHeight = 0;
     
    }
 
}
extension QRScheduleFoldView:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "outRecorder", for: indexPath) as! QROutRecorderCell
        cell.model = dataArr[indexPath.row]
        //        cell.rootVc = self
        //        cell.index = indexPath
        //        cell.clickClosure = { path in
        //            tableView.reloadRows(at: [path], with: UITableViewRowAnimation.none)
        //        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mod = dataArr[indexPath.row]
        return CGFloat(mod.rowheight)
    }
}

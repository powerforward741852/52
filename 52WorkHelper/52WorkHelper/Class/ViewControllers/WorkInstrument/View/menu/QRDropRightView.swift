//
//  QRDropRightView.swift
//  test
//
//  Created by 秦榕 on 2019/4/21.
//  Copyright © 2019年 qq. All rights reserved.
//

import UIKit

class QRDropRightView: YNDropDownView {
    //声明闭包起始时间和结束时间
    typealias clickBtnClosure = (_ startTime:String , _ endTime:String) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    
    var startTime : CVDate?
    var endTiem : CVDate?
    
    @IBOutlet weak var table: UITableView!
    var selectIndex = IndexPath(row: 1, section: 0)
    var titleArr = [["今天","本月","选择日期","选择时间段"],["选择时间段"],["本月","上月","选择月份"]]
    override func awakeFromNib() {
        //设置默认时间值
        
        startTime = CVDate(day: 1, month: Date().month, week: 1, year: Date().year)
        endTiem = CVDate(day: Date().daysInMonth, month: Date().month, week: Date().weekOfMonth, year: Date().year)
        
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

extension QRDropRightView : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 3
        }else{
            return 1
        }
        
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
        
        if indexPath.row == 3 || indexPath.row == 2{
            cell.accessoryType = .disclosureIndicator
        }else{
             cell.accessoryType = .none
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        if (indexPath.row == 3 && indexPath.section == 0)||(indexPath.row == 2 && indexPath.section == 0)||(indexPath.row == 2 && indexPath.section == 1)||(indexPath.row == 2 && indexPath.section == 2){
            selectIndex = IndexPath(row: -1, section: -1)
        }else{
            selectIndex = indexPath
        }
        tableView.reloadData()
        //处理时间选择
        if indexPath.section == 0 && indexPath.row == 0{
            //今天
            let start = Date().format(with: "yyyy-MM-dd ") + "00:00:01"
            let end = Date().format(with: "yyyy-MM-dd ") + "23:59:59"
            clickClosure!(start,end)
            self.changeMenu(title: "今天", status: YNStatus.selected, at: 1)
            self.hideMenu()
        }else if indexPath.section == 0 && indexPath.row == 1{
            //本月
            let st = CVDate(day: 1, month: Date().month, week: 1, year: Date().year).convertedDate()
            let ed = CVDate(day: Date().daysInMonth, month: Date().month, week: Date().weekOfMonth, year: Date().year).convertedDate()
            let start = st!.format(with: "yyyy-MM-dd") + " " + "00:00:01"
            let end = ed!.format(with: "yyyy-MM-dd") + " " + "23:59:59"
           
            self.changeMenu(title: "本月", status: YNStatus.selected, at: 1)
            clickClosure!(start,end)
            self.hideMenu()
        }else if indexPath.section == 0 && indexPath.row == 3{
            let calendarView = QRCalendarView.creatPopview()
            calendarView.isSelectDayRange = false
            calendarView.clickClosure = {[unowned self] start,end in
              //选择日期
                var star = start
                star.removeLast(9)
                self.changeMenu(title: star, status: YNStatus.selected, at: 1)
                self.clickClosure!(start,end)
                self.hideMenu()
            }
            calendarView.showPopView()
        }else if indexPath.section == 0 && indexPath.row == 2{
            let calendarView = QRCalendarView.creatPopview()
            calendarView.fatherV = self
            calendarView.isSelectDayRange = true
            calendarView.clickClosure = {[unowned self] start,end in
               //选择时间段
                var stars = start
                stars.removeFirst(5)
                stars.removeLast(9)
                var ends = end
                ends.removeLast(9)
                ends.removeFirst(5)
                if stars == ends{
                    var stars = start
                    stars.removeLast(9)
                    self.changeMenu(title: stars, status: YNStatus.selected, at: 1)
                }else{
                   self.changeMenu(title: stars + " ~ " + ends, status: YNStatus.selected, at: 1)
                }
                self.clickClosure!(start,end)
                self.hideMenu()
            }
             //转换时间显示
            calendarView.isSelected = true
            calendarView.isSelected = true
            calendarView.CVstartTime = startTime
            calendarView.CVendTime = endTiem
        calendarView.calendarView.toggleViewWithDate((startTime?.convertedDate())!)
            calendarView.calendarView.commitCalendarViewUpdate()
            calendarView.calendarView.contentController.refreshPresentedMonth()
            calendarView.showPopView()
        }else if indexPath.section == 1 && indexPath.row == 0{
            
        }else if indexPath.section == 1 && indexPath.row == 1{
            
        }else if indexPath.section == 1 && indexPath.row == 2{
            
        }else if indexPath.section == 2 && indexPath.row == 0{
            
        }else if indexPath.section == 2 && indexPath.row == 1{
            
        }else if indexPath.section == 2 && indexPath.row == 2{
            
        }else{
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if section == 0 || section == 1{
//            return 15
//        }else{
            return 0
      //  }
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        if section == 0 || section == 1{
//            let greyView = UIView(frame:  CGRect(x: 0, y: 0, width: kWidth, height: 15))
//            greyView.backgroundColor = kProjectBgColor
//            return greyView
//        }else{
            return  nil
       // }
        
    }
    
}


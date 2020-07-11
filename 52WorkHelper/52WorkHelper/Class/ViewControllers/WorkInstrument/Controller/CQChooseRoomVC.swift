//
//  CQChooseRoomVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/7/2.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol CQRoomSelectDelegate : NSObjectProtocol{
    func selectRoom(model:CQChooseRoomModel)
}

class CQChooseRoomVC: SuperVC {
    var dataArray = [CQChooseRoomModel]()
    var startDate = ""
    var endDate = ""
    weak var selectDelegate:CQRoomSelectDelegate?
    var selectIndex:NSMutableArray = NSMutableArray()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        table.backgroundColor = UIColor.white
        table.delegate = self
        table.dataSource = self
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "会议室选择"
        
        self.setUpRefresh()
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.table)
        self.table.register(CQChooseRoomCell.self, forCellReuseIdentifier: "CQChooseRoomCellId")
        self.table.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CQChooseRoomHeader")
    }
    
    @objc func swClick(sender:UIButton)  {
        let num:Int = sender.tag - 1000
        if selectIndex[num] as! String == "1" {
            selectIndex.replaceObject(at: num, with: "0")
        }else{
            selectIndex.replaceObject(at: num, with: "1")
        }
        self.table.reloadData()
    }
    
    @objc func bookClick(sender:UIButton)  {
        let num:Int = sender.tag - 2000
        let model = self.dataArray[num]
        if model.isOrder!{
            if self.selectDelegate != nil {
                self.selectDelegate?.selectRoom(model: model)
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            SVProgressHUD.showInfo(withStatus: "会议室在此开始时间和结束时间区间已被预订！")
        }
    }
}

extension CQChooseRoomVC{
    fileprivate func setUpRefresh() {
        // MARK:header
        let STHeader = CQRefreshHeader {[unowned self] in
            self.loadDatas()
        }
        
        self.table.mj_header = STHeader
        self.table.mj_header.beginRefreshing()
    }
    // MARK:request
    fileprivate func loadDatas() {
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/meetingRoom/getMeetingRoomList" ,
            type: .get,
            param: ["userId":userID,
                    "endDate":endDate,
                    "startDate":startDate],
            successCallBack: { (result) in
                var tempArray = [CQChooseRoomModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQChooseRoomModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                self.dataArray = tempArray
                
                for _ in self.dataArray {
                    self.selectIndex.add("0")
                }
                
                //刷新表格
                self.table.mj_header.endRefreshing()
                self.table.reloadData()
                
               
                
        }) { (error) in
            self.table.reloadData()
            
            self.table.mj_header.endRefreshing()
        }
    }
    
    
}



extension CQChooseRoomVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = self.dataArray[section]
        if selectIndex[section] as! String == "1"{
            return model.orderDetails!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQChooseRoomCellId") as! CQChooseRoomCell
        let model = self.dataArray[indexPath.section]
        var tempArray = [CQChooseRoomModel]()
        for modalJson in model.orderDetails! {
            let modal = CQChooseRoomModel(jsonData: modalJson)
            tempArray.append(modal!)
        }
        cell.model = tempArray[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoGetHeight(height: 48)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AutoGetHeight(height: 153)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.white
        let bgView = UIView.init(frame: CGRect.init(x: AutoGetWidth(width: 10), y: AutoGetWidth(width: 10), width: kWidth - AutoGetWidth(width: 20), height: AutoGetHeight(height: 143)))
        bgView.layer.borderWidth = 0.5
        bgView.layer.borderColor = kLineColor.cgColor
        header.addSubview(bgView)
        
        let model = self.dataArray[section]
        
        let titleLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:  AutoGetHeight(height: 22), width: kWidth/3, height: AutoGetHeight(height: 16)))
        titleLab.textAlignment = .left
        titleLab.textColor = UIColor.black
        titleLab.text = model.roomName
        titleLab.font = kFontSize16
        bgView.addSubview(titleLab)
        
        let floorLab = UILabel.init(frame: CGRect.init(x: kWidth/2, y:  AutoGetHeight(height: 22), width: (kWidth - AutoGetWidth(width: 10))/2 - 2 * kLeftDis, height: AutoGetHeight(height: 16)))
        floorLab.textAlignment = .right
        floorLab.textColor = UIColor.black
        floorLab.text = model.roomFloor
        floorLab.font = kFontSize16
        bgView.addSubview(floorLab)
        
        let detailLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:  titleLab.bottom + AutoGetHeight(height: 14), width: kWidth - AutoGetWidth(width: 20) - 2 * kLeftDis, height: AutoGetHeight(height: 45)))
        detailLab.textAlignment = .left
        detailLab.textColor = kLyGrayColor
        
        var personSize = ""
        if !model.personSize.isEmpty {
            personSize = "容纳" + model.personSize + "人、"
        }
        var roomLayout = ""
        if !model.roomLayout.isEmpty{
            roomLayout = model.roomLayout + "、"
        }
        var roomEquipment = ""
        if !model.roomEquipment.isEmpty{
            roomEquipment = model.roomEquipment
        }
        var roomRemark = ""
        if !model.roomRemark.isEmpty{
            roomRemark = model.roomRemark + "、"
        }
        if roomLayout == "" && roomRemark == "" && roomEquipment == ""{
            personSize = "容纳" + model.personSize + "人"
        }
        detailLab.text = personSize + roomLayout + roomRemark + "\n" +  roomEquipment
        
        detailLab.font = kFontSize13
        detailLab.numberOfLines = 0
        detailLab.adjustsFontSizeToFitWidth = true
        
        //lab行间距
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string:  personSize + roomLayout + roomRemark + "\n" +  roomEquipment )
        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7 //大小调整
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, detailLab.text!.count))
        detailLab.attributedText = attributedString
        detailLab.sizeToFit()
        
        bgView.addSubview(detailLab)
        
        let switchBtn = UIButton.init(type: .custom)
        switchBtn.frame = CGRect.init(x: kLeftDis, y: detailLab.bottom , width: AutoGetWidth(width: 30), height: AutoGetHeight(height: 30))
        if selectIndex[section] as! String == "0" {
            switchBtn.setImage(UIImage.init(named: "roomClose"), for: .normal)
        }else{
            switchBtn.setImage(UIImage.init(named: "roomOpen"), for: .normal)
        }
        switchBtn.addTarget(self, action: #selector(swClick), for: .touchUpInside)
        switchBtn.tag = 1000 + section
        bgView.addSubview(switchBtn)
        
        
        let bookBtn = UIButton.init(type: .custom)
        bookBtn.frame = CGRect.init(x: (kWidth - AutoGetWidth(width: 20)) - AutoGetWidth(width: 100), y: detailLab.bottom , width: AutoGetWidth(width: 83), height: AutoGetHeight(height: 30))
        bookBtn.setTitleColor(UIColor.white, for: .normal)
        bookBtn.setTitle("预约", for: .normal)
        if model.isOrder!{
            bookBtn.backgroundColor = UIColor.colorWithHexString(hex: "#0a9bf1")
        }else{
            bookBtn.backgroundColor = UIColor.colorWithHexString(hex: "#dcdcdc")
        }
        bookBtn.tag = 2000 + section
        bookBtn.addTarget(self, action: #selector(bookClick(sender:)), for: UIControlEvents.touchUpInside)
        bookBtn.layer.cornerRadius = AutoGetHeight(height: 15)
        bookBtn.clipsToBounds = true
        bgView.addSubview(bookBtn)
        
        return header
    }
}

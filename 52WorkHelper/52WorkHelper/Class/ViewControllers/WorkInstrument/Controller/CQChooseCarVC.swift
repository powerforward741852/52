//
//  CQChooseCarVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/9/10.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol CQCarSelectDelegate : NSObjectProtocol{
    func selectCar(model:CQCarsModel)
}

class CQChooseCarVC: SuperVC {

    var startDate = ""
    var endDate = ""
    var carType:Int = 0
    var dataArray = [CQCarsModel]()
    var pageNum = 1
    weak var selectDelegate:CQCarSelectDelegate?
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .none
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
        
        self.loadCarDatas()
        self.title = "派车"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.table)
        self.table.register(UINib.init(nibName: "CQChooseCarCell", bundle: Bundle.init(identifier: "chooseCarCellId")), forCellReuseIdentifier: "CQChooseCarCellId")
    }
}

extension CQChooseCarVC{
    
    fileprivate func loadCarDatas() {
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getAllCars" ,
            type: .get,
            param: ["emyeId":userID,
                    "endDate":endDate,
                    "startDate":startDate,
                    "carType":carType],
            successCallBack: { (result) in
                var tempArray = [CQCarsModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQCarsModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                self.dataArray = tempArray
                if self.dataArray.count == 0{
                    SVProgressHUD.showInfo(withStatus: "没找到相关数据")
                    self.navigationController?.popViewController(animated: false)
                }
                //刷新表格
                self.table.reloadData()
                
                
                
        }) { (error) in
            self.table.reloadData()
        }
    }
}



extension CQChooseCarVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQChooseCarCellId") as! CQChooseCarCell
        cell.carModel = self.dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.selectDelegate != nil {
            self.selectDelegate?.selectCar(model: self.dataArray[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 160
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
}

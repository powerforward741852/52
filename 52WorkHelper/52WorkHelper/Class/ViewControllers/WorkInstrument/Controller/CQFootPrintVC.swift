//
//  CQFootPrintVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/4/27.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQFootPrintVC: SuperVC {

    var recordDate = ""
    var dataArray = [CQFieldPersonalModel]()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.backgroundColor = kProjectBgColor
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    lazy var headView: UIImageView = {
        let headView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 100.5)))
        headView.image = UIImage.init(named: "footPrintBgImg")
        return headView
    }()
    
    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 15), width: AutoGetWidth(width: 70), height: AutoGetWidth(width: 70)))
        iconImg.sd_setImage(with: URL(string: STUserTool.account().headImage ), placeholderImage:UIImage.init(named: "personDefaultIcon") )
        iconImg.layer.cornerRadius = AutoGetWidth(width: 35)
        iconImg.clipsToBounds = true
        return iconImg
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 15), y: AutoGetHeight(height: 30), width: kWidth/2, height: AutoGetHeight(height: 18)))
        nameLab.font = kFontSize18
        nameLab.textColor = UIColor.white
        nameLab.text = STUserTool.account().realName
        nameLab.textAlignment = .left
        return nameLab
    }()
    
    lazy var dateLab: UILabel = {
        let dateLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + kLeftDis, y: self.nameLab.bottom + AutoGetHeight(height: 12), width: kWidth/5 * CGFloat(3), height: AutoGetHeight(height: 14)))
        dateLab.textAlignment = .left
        
        let now = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy年MM月dd日"
        let str = dateFormat.string(from: now)
        
        dateLab.text = str
        dateLab.textColor = UIColor.white
        dateLab.font = kFontSize14
        return dateLab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "足迹"
        
        self.loadData(recordDate: recordDate)
        
        self.view.addSubview(self.table)
        
        
        self.table.register(CQFootPrintCell.self, forCellReuseIdentifier: "CQFootPrintCellId")
        self.table.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CQFootPrintFooter")
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.iconImg)
        self.headView.addSubview(self.nameLab)
        self.headView.addSubview(self.dateLab)
        
    }
}

extension CQFootPrintVC{
    func loadData(recordDate:String)  {
        let param = ["userId":STUserTool.account().userID,
                     "recordDate":recordDate]
        STNetworkTools.requestData(URLString:"\(baseUrl)/outWork/getfootprint" ,
            type: .get,
            param: param,
            successCallBack: { (result) in
                var tempArray = [CQFieldPersonalModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQFieldPersonalModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }

                self.dataArray = tempArray
                self.table.reloadData()
        }) { (error) in
            
        }
    }
}

extension CQFootPrintVC:UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
  
}

extension CQFootPrintVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQFootPrintCellId") as! CQFootPrintCell
        cell.model = self.dataArray[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoGetHeight(height: 73)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return AutoGetHeight(height: 13)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        
        footer.backgroundColor = kProjectBgColor
      
        return footer
    }
    
    
}

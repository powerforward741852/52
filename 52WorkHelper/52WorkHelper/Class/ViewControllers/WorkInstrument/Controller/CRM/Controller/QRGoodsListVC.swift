//
//  QRGoodsListVC.swift
//  test
//
//  Created by 秦榕 on 2018/9/4.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit

class QRGoodsListVC: SuperVC {
    static let CellIdentifier = "QRGoodsListcell_ID";
    var contratKey = ""
    var dataArray = [QRBiaoModel]()
    
    lazy var table : UITableView = {
       let tab = UITableView(frame:  CGRect(x: 0, y: 0, width: kWidth, height: kHeight))
        tab.dataSource = self
        tab.delegate = self
        tab.rowHeight = AutoGetHeight(height: 180)
        tab.register(QRGoodsListCell.self, forCellReuseIdentifier: QRGoodsListVC.CellIdentifier)
        tab.backgroundColor = kColorRGB(r: 245, g: 245, b: 245)
        tab.separatorStyle = UITableViewCellSeparatorStyle.none
        let view = UIView(frame: CGRect.zero)
        tab.tableFooterView = view
//        tab.rowHeight =
        return tab
    }()
    
    deinit {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(table)
        table.backgroundColor = kProjectBgColor
        loadListData()
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func loadListData() {
        
       // let userid = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmContract/getContractCommodities", type: .get, param:  [
                                                                                                        "contractId":contratKey
            ], successCallBack: { (result) in
                 let data = result["data"]["commodityCount"].stringValue
                if  Bool(data) == false  {
                    self.title = "商品"
                }else{
                    self.title = "商品(\( data))"
                }
                let goods = result["data"]["commodityList"].arrayValue
                var temp = [QRBiaoModel]()
                for item in goods {
                    let moda = QRBiaoModel(jsonData:item)
                    temp.append(moda!)
                }
                
                self.dataArray = temp
                self.table.reloadData()
        }) { (error) in
            
                
        }
        
    }
}
extension QRGoodsListVC :UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: false)
        //跳转到商品销售VC
           let saleVc = QRGoodInfoVC()
            saleVc.entityId =  dataArray[indexPath.row].commodityId
        self.navigationController?.pushViewController(saleVc, animated: true)
        
    }
}
extension QRGoodsListVC :UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell :QRGoodsListCell? = (tableView.dequeueReusableCell(withIdentifier: QRGoodsListVC.CellIdentifier, for: indexPath) as! QRGoodsListCell) ;
          cell?.model = dataArray[indexPath.row]
         cell?.goods.text = "商品" + "\(indexPath.row + 1)"
         cell?.selectionStyle = UITableViewCellSelectionStyle.none

//        let cell :QRGoodsListCell? = (tableView.dequeueReusableCell(withIdentifier: QRGoodsListVC.CellIdentifier, for: indexPath) as! QRGoodsListCell) ;
//        cell?.model = dataArray[indexPath.row]
//        cell?.selectionStyle = UITableViewCellSelectionStyle.none

        return cell!
        
    }
    
    
    
}

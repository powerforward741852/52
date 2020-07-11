//
//  CQInvoiceVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/4.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQInvoiceVC: SuperVC {

    var dataArray = [CQInvoiceModel]()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.separatorColor = kLineColor
        table.backgroundColor = kProjectBgColor
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    lazy var addInvoiceBtn: UIButton = {
        let addInvoiceBtn = UIButton.init(type: .custom)
        addInvoiceBtn.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 41))
        addInvoiceBtn.setImage(UIImage.init(named: "PersonAddressAdd"), for: .normal)
        addInvoiceBtn.setTitle("添加发票抬头", for: .normal)
        addInvoiceBtn.setTitleColor(UIColor.black, for: .normal)
        addInvoiceBtn.titleLabel?.font = kFontSize15
        addInvoiceBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0)
        addInvoiceBtn.addTarget(self, action: #selector(addInvoiceClick), for: .touchUpInside)
        addInvoiceBtn.backgroundColor = UIColor.white
        
        return addInvoiceBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "单位发票抬头"
        self.view.backgroundColor = kProjectBgColor
        
        
        self.view.addSubview(self.table)
        self.table.register(CQInvoiceCell.self, forCellReuseIdentifier: "CQInvoiceCellId")
        self.table.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CQInvoiceFootView")
        self.table.tableFooterView = self.addInvoiceBtn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpRefresh()
    }
    
    @objc func addInvoiceClick()  {
        let vc = CQAddInvoiceVC.init()
        vc.type = .add
        vc.invoiceType = "1"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// Mark :loadData
extension CQInvoiceVC{
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
        STNetworkTools.requestData(URLString:"\(baseUrl)/my/getMyInvoiceList" ,
            type: .get,
            param: ["emyeId":userID],
            successCallBack: { (result) in
                var tempArray = [CQInvoiceModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQInvoiceModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                
                self.dataArray = tempArray
                //刷新表格
                self.table.mj_header.endRefreshing()
                self.table.reloadData()
                
                if self.dataArray.count > 0{
//                    if let vie = self.addInvoiceBtn.viewWithTag(100) {
//                        vie.removeFromSuperview()
//                    }
                    let line = UIView.init(frame: CGRect.init(x: kLeftDis, y: 0, width:kWidth - kLeftDis , height: 0.5))
                    line.tag = 100
                    line.backgroundColor = kfilterBackColor
                    self.addInvoiceBtn.addSubview(line)
                }
                
              
                
        }) { (error) in
            self.table.reloadData()
            
            self.table.mj_header.endRefreshing()
        }
    }
    
    
    
    func deleteFaPiaoRequest(id:String)  {
        SVProgressHUD.show()
        let userID = STUserTool.account().userID
//        STNetworkTools.requestData(URLString: "\(baseUrl)/my/deleteMyInvoice",
//            type: .post,
//            param: ["invoiceId":id],
//            successCallBack: { (result) in
//                SVProgressHUD.dismiss()
//                SVProgressHUD.showInfo(withStatus: "删除成功")
//                self.table.mj_header.beginRefreshing()
//        }) { (error) in
//                SVProgressHUD.dismiss()
//        }
        
        STNetworkTools.requestData(URLString: "\(baseUrl)/my/updateMyInvoice",
            type: .post,
            param: ["emyeId":userID,
                    "opt":"del",
                    "entityId":id],
            successCallBack: { (result) in
                SVProgressHUD.dismiss()
                SVProgressHUD.showInfo(withStatus: "删除成功")
                self.table.mj_header.beginRefreshing()
               
        }) { (error) in
            SVProgressHUD.dismiss()
        }
    }
}



extension CQInvoiceVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CQInvoiceCellId") as! CQInvoiceCell
        let model = self.dataArray[indexPath.row]
        cell.model = model
        cell.editingDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataArray[indexPath.row]
        let vc = CQInvoiceDetailVC.init()
        vc.entityId = model.entityId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return AutoGetHeight(height: 73)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AutoGetHeight(height: 13)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = kColorRGB(r: 247, g: 247, b: 247)
        return header
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //删除
        let mod = dataArray[indexPath.row]
        self.deleteFaPiaoRequest(id: mod.entityId)
    }
}

extension CQInvoiceVC:CQInvoiceEditDelegate{
    func editWithInvoiceType(index: IndexPath) {
        let model = self.dataArray[index.row]
        let vc = CQAddInvoiceVC.init()
        vc.type = .update
        vc.entityId = model.entityId
        vc.invoiceType = model.invoiceType
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

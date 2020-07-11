//
//  CQMyAddressVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/4.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQMyAddressVC: SuperVC {
    
    var dataArray = [CQAddressModel]()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.separatorColor = kLineColor
        table.backgroundColor = kProjectBgColor
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    lazy var addAddressBtn: UIButton = {
        let addAddressBtn = UIButton.init(type: .custom)
        addAddressBtn.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 41))
        addAddressBtn.setImage(UIImage.init(named: "PersonAddressAdd"), for: .normal)
        addAddressBtn.setTitle("新增地址", for: .normal)
        addAddressBtn.setTitleColor(UIColor.black, for: .normal)
        addAddressBtn.titleLabel?.font = kFontSize15
        addAddressBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0)
        addAddressBtn.addTarget(self, action: #selector(addAddressClick), for: .touchUpInside)
        addAddressBtn.backgroundColor = UIColor.white
        
        return addAddressBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的地址"
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.register(CQMyAddressCell.self, forCellReuseIdentifier: "CQMyAddressCellId")
        self.table.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CQAddressFootView")
        self.table.tableFooterView = self.addAddressBtn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpRefresh()
    }
    
    @objc func addAddressClick()  {
        let vc = CQAddAddressVC.init()
        vc.type = .add
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// Mark :loadData
extension CQMyAddressVC{
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
        STNetworkTools.requestData(URLString:"\(baseUrl)/my/getMyAddressList" ,
            type: .get,
            param: ["emyeId":userID],
            successCallBack: { (result) in
                var tempArray = [CQAddressModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQAddressModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                
                self.dataArray = tempArray
                //刷新表格
                self.table.mj_header.endRefreshing()
                self.table.reloadData()
                if self.dataArray.count > 0{
                    let line = UIView.init(frame: CGRect.init(x: kLeftDis, y: 0, width:kWidth - kLeftDis , height: 0.5))
                    line.backgroundColor = kfilterBackColor
                    self.addAddressBtn.addSubview(line)
                }
                
                
                
        }) { (error) in
            self.table.reloadData()
            
            self.table.mj_header.endRefreshing()
        }
    }
    
    
    func deleteAddressRequest(id:String)  {
        SVProgressHUD.show()
        let userID = STUserTool.account().userID
        var opt = "del"
        STNetworkTools.requestData(URLString: "\(baseUrl)/my/updateMyAddress",
            type: .post,
            param: ["emyeId":userID,
                    "addressCity":"",
                    "addressDetails":  "",
                    "cityCode": "",
                    "contactName": "",
                    "mobilePhone": "",
                    "opt":opt,
                    "entityId":id],
            successCallBack: { (result) in
                SVProgressHUD.dismiss()
                    opt = "del"
                    SVProgressHUD.showInfo(withStatus: "删除成功")
                    self.table.mj_header.beginRefreshing()
        }) { (error) in

        }
    }
    
   
}

extension CQMyAddressVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQMyAddressCellId") as! CQMyAddressCell
        cell.model = self.dataArray[indexPath.row]
        cell.editDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataArray[indexPath.row]
        //H5地址页面详情
//        let vc = CQAddAddressVC()
//        vc.type = .detail
//        vc.entityId = model.entityId
//        self.navigationController?.pushViewController(vc, animated: true)

        let vc = CQWebVC()
        vc.urlStr = baseUrl + "/my/getMyAddressInfoOfPage?entityId=\(model.entityId)"
        vc.title = "我的地址"
        vc.titleStr = model.contactName+"的地址"
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
        self.deleteAddressRequest(id: mod.entityId)
    }
}

extension CQMyAddressVC:CQEditAddressDelegate{
    func pushToDetailVC(index: IndexPath) {
        let model = self.dataArray[index.row]
        let vc = CQAddAddressVC.init()
        vc.type = .update
        vc.entityId = model.entityId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

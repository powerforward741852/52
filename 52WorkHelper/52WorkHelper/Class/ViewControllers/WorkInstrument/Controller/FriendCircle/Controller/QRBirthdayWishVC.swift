//
//  QRBirthdayWishVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/14.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRBirthdayWishVC: SuperVC {

    var dataArr = [QRBirthModel]()
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight ), style: UITableViewStyle.plain)
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
            table.contentInset = UIEdgeInsetsMake(CGFloat(SafeAreaTopHeight), 0, CGFloat(SafeAreaBottomHeight), 0);
            table.scrollIndicatorInsets = table.contentInset;
            
        } else {
            //低于 iOS 9.0
        }
        //table.register(QRZhuFuCell.self, forCellReuseIdentifier: "zhuFuCellId")
        table.register(UINib(nibName: "QRBirthZhuFuCell", bundle: nil), forCellReuseIdentifier: "zhuFuCellId")
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
    
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        //table.estimatedRowHeight = 107
        table.rowHeight = AutoGetHeight(height: 105)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(table)
        let RightButton = UIButton(frame:  CGRect(x: 0, y: 0, width: 60, height: 30))
        RightButton.setTitle("写祝福", for: UIControlState.normal)
        RightButton.titleLabel?.font = kFontSize17
        RightButton.addTarget(self, action: #selector(jumpIn), for: UIControlEvents.touchUpInside)
        RightButton.setTitleColor(kBlueColor, for: UIControlState.normal)
        RightButton.sizeToFit()
        RightButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: -7)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: RightButton)
        
       // loadData()
        getListData()
        
        
          NotificationCenter.default.addObserver(self, selector: #selector(popBirthDayList(notification:)), name: NSNotification.Name(rawValue: "popBirthDayList"), object: nil)
    }
    
      @objc func popBirthDayList(notification:Notification) {
        self.navigationController?.popToViewController(self, animated: true)
        }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func getListData() {
                STNetworkTools.requestData(URLString:"\(baseUrl)/birth/getAllDate" ,
                    type: .get,
                    param: nil,
                    successCallBack: { (result) in

                        var tempArray = [QRBirthModel]()
                        for modalJson in result["data"].arrayValue {
                            guard let modal = QRBirthModel(jsonData: modalJson) else {
                                return
                            }
                            tempArray.append(modal)
                        }
                        self.dataArr = tempArray
                        self.table.reloadData()

                }) { (error) in

                }
    }
    
    @objc func jumpIn(){
        let XieZhuFu = QRXieZhuFuVC()
        XieZhuFu.clickClosure = {[unowned self]flash in
            self.getListData()
        }
        XieZhuFu.title = "写祝福"
        self.navigationController?.pushViewController(XieZhuFu, animated: true)
    }
    
//    func loadData()  {
//        STNetworkTools.requestData(URLString:"\(baseUrl)/birth/getAllMonth" ,
//            type: .get,
//            param: nil,
//            successCallBack: { (result) in
//                var tempArray = [QRBirthModel]()
//                for modalJson in result["data"].arrayValue {
//                    guard let modal = QRBirthModel(jsonData: modalJson) else {
//                        return
//                    }
//                    tempArray.append(modal)
//                }
//                self.dataArr = tempArray
//                self.table.reloadData()
//
//        }) { (error) in
//
//        }
//    }
    
}

extension QRBirthdayWishVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let mod = dataArr[indexPath.row]
        if mod.contentId == "0"{
            let vc = QRBirthDayParterVC()
            vc.date = dataArr[indexPath.row].date
            self.navigationController?.pushViewController(vc, animated: true)

        }else{
            let vc = QRXieZhuFuVC()
          
            vc.title = "祝福详情"
            vc.isDetaile = true
            vc.dataModel = dataArr[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "zhuFuCellId", for: indexPath) as! QRZhuFuCell
        cell.model = dataArr[indexPath.row]
        
        return cell
    }
    
}

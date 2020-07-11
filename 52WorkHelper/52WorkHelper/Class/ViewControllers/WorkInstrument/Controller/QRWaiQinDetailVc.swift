//
//  QRWaiQinDetailVc.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/2/19.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRWaiQinDetailVc: SuperVC{
    var  userId = ""
    var  entityId = ""
    var  model: CQFieldPersonalModel?
    var dataStr = "2019-02-26"
    var dataSource = [String]()
    lazy var locationV : UIView = {
        let locationV = UIView(frame:  CGRect(x: 0, y: SafeAreaTopHeight, width: kWidth, height: AutoGetHeight(height: 35)))
        locationV.backgroundColor = kProjectBgColor
        return locationV
    }()
    
    lazy var img : UIImageView = {
        let img = UIImageView(frame:  CGRect(x: AutoGetHeight(height: 15), y: AutoGetHeight(height: 17/2), width: AutoGetHeight(height: 15), height: AutoGetHeight(height: 18)))
        img.image = UIImage(named: "FieldPersonelLocation")
        return img
    }()
    
    lazy var locationTitle :UILabel = {
        let big = UILabel(title: "厦门市软件园二期", textColor: UIColor.black, fontSize: 14)
        big.frame = CGRect(x: img.right+7, y: 0, width: kWidth-img.right-7, height: AutoGetHeight(height: 35))
        big.textAlignment = .left
        big.numberOfLines = 2
        return big
    }()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: locationV.bottom, width: kWidth, height: kHeight-locationV.bottom ), style: UITableViewStyle.plain)
        if #available(iOS 11.0, *) {
            
        } else {
            //低于 iOS 9.0
        }
        table.register(QRWaiQinDetailCell.self, forCellReuseIdentifier: "waiqin")
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
        table.allowsSelection = false
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.estimatedRowHeight = 107
        table.rowHeight = UITableViewAutomaticDimension
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "外勤详情"
       view.addSubview(locationV)
       locationV.addSubview(img)
       locationV.addSubview(locationTitle)
       view.addSubview(table)
        loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateImages(notification:)), name: NSNotification.Name(rawValue: "imagsCellID"), object: nil)
    }
    
    @objc func updateImages(notification:NSNotification){
        
        let index = notification.userInfo?["index"] as? Int
        let imgs = notification.userInfo?["imags"] as? [String]
        if let index = index ,let imags = imgs, imags.count > 0{
            let previewVC = ImagePreViewVC(images: imags, index: index)
            self.navigationController?.pushViewController(previewVC, animated: true)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func loadData()  {
            loadingPlay()
           // let userID = STUserTool.account().userID
            STNetworkTools.requestData(URLString:"\(baseUrl)/outWork/getOutWorkDetails" ,
                type: .get,
                param: ["outWorkId":self.entityId,
                        "userId":self.userId,
                        "recordDate":dataStr],
                successCallBack: { (result) in
                    guard let model = CQFieldPersonalModel.init(jsonData: result["data"]) else {
                        return
                    }
                    self.model = model
                    var tempArray = [CQFieldPersonalModel]()
                    for modalJson in result["data"]["punchData"].arrayValue {
                        guard let cardModel = CQFieldPersonalModel(jsonData: modalJson) else {
                            return
                        }
                        tempArray.append(cardModel)
                    }
                    self.locationTitle.text = model.addressRemark
                    self.dataSource.removeAll()
                    self.dataSource.append(model.visitPartner)
                    for (_,val) in tempArray.enumerated(){
                        if val.punchTime == "签退"{
                            //self.dataSource.append("  ")
                        }else{
                           self.dataSource.append(val.punchTime)
                        }
                    }
                    self.dataSource.append(model.detailsContent)
                    
                     self.table.reloadData()
                     self.loadingSuccess()
            }) { (error) in
                // self.table.reloadData()
                    self.loadingSuccess()
                
            }
    }
   

}
extension QRWaiQinDetailVc : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "waiqin", for: indexPath) as! QRWaiQinDetailCell
        if dataSource[indexPath.row]==""{
            cell.detailLabs.text = "  "
        }else{
            cell.detailLabs.text = dataSource[indexPath.row]
        }
        if dataSource.count == 3 {
            if indexPath.row == 1{
                cell.nameLab.text = "签到时间"
            }else if indexPath.row == 2{
                cell.nameLab.text = "工作说明"
            }else if indexPath.row == 0{
                cell.nameLab.text = "拜访对象"
            }
        }
        if dataSource.count == 4 {
            if indexPath.row == 1{
                cell.nameLab.text = "签到时间"
            }else if indexPath.row == 2{
                cell.nameLab.text = "签退时间"
            }else if indexPath.row == 3{
                cell.nameLab.text = "工作说明"
            }else if indexPath.row == 0{
                cell.nameLab.text = "拜访对象"
            }
        }
        if indexPath.row == dataSource.count-1{
//           let imgs = ["https://pics5.baidu.com/feed/2fdda3cc7cd98d106cd08c21c68bc90a7aec90d7.jpeg?token=a7b060c06fc710a69e1e37631cce6371&s=CEF513C2411091D84EE0B4320300D011","https://pics5.baidu.com/feed/2fdda3cc7cd98d106cd08c21c68bc90a7aec90d7.jpeg?token=a7b060c06fc710a69e1e37631cce6371&s=CEF513C2411091D84EE0B4320300D011","https://pics5.baidu.com/feed/2fdda3cc7cd98d106cd08c21c68bc90a7aec90d7.jpeg?token=a7b060c06fc710a69e1e37631cce6371&s=CEF513C2411091D84EE0B4320300D011","https://pics5.baidu.com/feed/2fdda3cc7cd98d106cd08c21c68bc90a7aec90d7.jpeg?token=a7b060c06fc710a69e1e37631cce6371&s=CEF513C2411091D84EE0B4320300D011","https://pics5.baidu.com/feed/2fdda3cc7cd98d106cd08c21c68bc90a7aec90d7.jpeg?token=a7b060c06fc710a69e1e37631cce6371&s=CEF513C2411091D84EE0B4320300D011"]
//            self.model?.picurlData = imgs
            cell.model = self.model
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
    }
}

//
//  QRContactCollectionView.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/5/29.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class QRContactCollectionView: UIView {
    
    
   // @IBOutlet weak var titleLab: UIButton!
    
    @IBOutlet weak var collectView: UICollectionView!
    
    @IBOutlet weak var QRflowLayout: UICollectionViewFlowLayout!
    
    //var ishidden = false
    
    var dataArr =  [QREmployeesModel]()
    var functionArr =  [QREmployeesModel]()
    var overTimeModel : QREmployeesModel?

    
    
    override func awakeFromNib() {

            
         collectView.delegate = self
         collectView.dataSource = self
         QRflowLayout.minimumLineSpacing = 0
         QRflowLayout.minimumInteritemSpacing = 0
         QRflowLayout.itemSize = CGSize.init(width: kHaveLeftWidth/6, height: 75)

        collectView.backgroundColor = UIColor.white
        collectView.register(QRGenjinCollectionCell.self, forCellWithReuseIdentifier: "QRGenjinCellId")
        collectView.isScrollEnabled = false
        
        let NotifMycation = NSNotification.Name(rawValue:"AddTracker")
        NotificationCenter.default.addObserver(self, selector: #selector(upDataChange(notif:)), name: NotifMycation, object: nil)
        
    }
    
    @objc func upDataChange(notif:Notification){
//        guard let arr: [QREmployeesModel] = notif.object as! [QREmployeesModel]? else { return }
//        var temp = [QREmployeesModel]()
//        for i in 0..<arr.count {
//            //添加选中的模型
//            temp.append(arr[i])
//        }
//        self.dataArr = temp
//        self.collectView.reloadData()
//        let footerHeight = CGFloat(((dataArr.count+functionArr.count-1)/5+1)*75+40)
//
//        //更新
//        let userInfo = ["height":footerHeight]
//        NotificationCenter.default.post(name: NSNotification.Name.init("refreshFooter"), object: nil, userInfo: userInfo)
        
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension QRContactCollectionView:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count + functionArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QRGenjinCellId", for: indexPath) as! QRGenjinCollectionCell
         cell.location.isHidden = true
         cell.deleteBtn.isHidden = true
        if indexPath.row < dataArr.count{
            let mod = self.dataArr[indexPath.row]
            cell.img.sd_setImage(with: URL(string:mod.headImage), placeholderImage: UIImage(named:"personDefaultIcon"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
            cell.name.isHidden = false
            cell.name.text = mod.realName
           // cell.deleteDelegate = self
        }else{
            let index =  indexPath.row-dataArr.count
            let mod = self.functionArr[index]
            cell.img.image = UIImage.init(named: mod.headImage)
            cell.name.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row < dataArr.count{
             let model = self.dataArr[indexPath.row]
            let vc = QRSworkmateScheduleVC()
            vc.title = model.realName + "的日程"
            vc.curUserId = model.id
            let nav = getTopVC()
            nav?.navigationController?.pushViewController(vc, animated: true)
            //点击头像
        }else{
            //点击功能键
            let index =  indexPath.row-dataArr.count
            let mod = self.functionArr[index]
            if mod.realName == "add"{
//                let vc = getTopVC()
//                let contact = QRAddressBookVC()
//                contact.titleStr = "添加同事"
//                contact.hasSelectModelArr = self.dataArr
//                contact.toType = ToAddressBookType.fromGenJin
//                vc?.navigationController?.pushViewController(contact, animated: true)
            }else if mod.realName == "more"{
                  let vc = getTopVC()
              //  let contact = AddressBookVC.init()
               
                let contact = QRAddressBookVC.init()
                contact.scheduleModel = true
                contact.toType = .fromContact
                
                if self.overTimeModel != nil{
                    contact.hasSelectModelArr = [self.overTimeModel] as! [CQDepartMentUserListModel]
                }
                vc?.navigationController?.pushViewController(contact, animated: true)
            }

        }
   
    }

    

}

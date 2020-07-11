//
//  QRBirthDayParterVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/14.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRBirthDayParterVC: SuperVC {
    var isMainpage:Bool = false
    var isfromMain = false
    var Month:String = "0"
    var date:String = "2019-06-06"
    var dataArr = [CQDepartMentAttenceModel]()
    var selectArr = [CQDepartMentAttenceModel]()
    lazy var collectionView: UICollectionView = {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width: kWidth/3, height: kWidth/3+AutoGetHeight(height: 10))
        layOut.minimumLineSpacing = 20
        layOut.minimumInteritemSpacing = kWidth/18
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        layOut.sectionInset = UIEdgeInsets(top: 0, left: kWidth/9, bottom: 0, right: kWidth/9)
        layOut.headerReferenceSize =  CGSize.init(width: kWidth, height: AutoGetHeight(height: 170))
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: SafeAreaTopHeight, width: kWidth, height: kHeight-SafeAreaBottomHeight - AutoGetHeight(height: 49) - SafeAreaTopHeight), collectionViewLayout: layOut)
        
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(QRBigWishCell.self, forCellWithReuseIdentifier: "birthId")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "birthIdHeader")
       
        return collectionView
    }()
    
    lazy var footBut : UIButton = {
        let footBut = UIButton(frame:  CGRect(x: kLeftDis, y: kHeight-SafeAreaBottomHeight-AutoGetHeight(height: 49), width: kHaveLeftWidth, height: AutoGetHeight(height: 40)))
        footBut.backgroundColor = kBlueC
        footBut.setTitle("送上祝福", for: UIControlState.normal)
        footBut.setTitleColor(UIColor.white, for: UIControlState.normal)
        footBut.layer.cornerRadius = 5
        footBut.addTarget(self, action: #selector(sendWish(send:)), for: UIControlEvents.touchUpInside)
        footBut.isHidden = true
        return footBut
    }()
    
    lazy var bgImg : UIImageView = {
        let bgImg = UIImageView(frame:CGRect(x: 0, y: 0, width: kWidth, height: kHeight-SafeAreaBottomHeight))
        bgImg.image = UIImage(named: "zfbg")
        bgImg.isUserInteractionEnabled = true
        return bgImg
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "生日祝福"
        
        self.view.addSubview(bgImg)
        self.view.addSubview(collectionView)
        self.view.addSubview(footBut)
       // loadData()
        loadDayData()
        
        
        let cancelButton = UIButton(frame:  CGRect(x: 0, y: 0, width: 70, height: 30))
       cancelButton.setTitle("取消", for: UIControlState.normal)
       cancelButton.addTarget(self, action: #selector(cancel(sender:)), for: UIControlEvents.touchUpInside)
       cancelButton.titleLabel?.textAlignment = .right
       cancelButton.titleLabel?.font = kFontSize17
       cancelButton.setTitleColor(kBlueColor, for: UIControlState.normal)
      // RightButton.sizeToFit()
       cancelButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -7, bottom: 0, right: 7)
       navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        
        
        let RightButton = UIButton(frame:  CGRect(x: 0, y: 0, width: 70, height: 30))
        RightButton.setTitle("   全选", for: UIControlState.normal)
        RightButton.setTitle("取消全选", for: UIControlState.selected)
        RightButton.addTarget(self, action: #selector(jumpIn(sender:)), for: UIControlEvents.touchUpInside)
        RightButton.titleLabel?.textAlignment = .right
        RightButton.titleLabel?.font = kFontSize17
        RightButton.setTitleColor(kBlueColor, for: UIControlState.normal)
       // RightButton.sizeToFit()
        RightButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: -7)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: RightButton)
    
    }
    
    @objc func jumpIn(sender:UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            for (_,value) in dataArr.enumerated(){
                value.isSelected = true
            }
             self.selectArr = dataArr
        }else{
            for (_,value) in dataArr.enumerated(){
                value.isSelected = false
            }
            self.selectArr.removeAll()
        }
       
        self.collectionView.reloadData()
    }
    
    @objc func cancel(sender:UIButton){
         self.navigationController?.popViewController(animated: true)
        self.navigationController?.dismiss(animated: true, completion: nil)
       }
   
    @objc func sendWish(send:UIButton){
        if selectArr.count>0{
            let vc = QRSendWishVC()
            vc.isMainpage = self.isMainpage
            vc.isfromMain = self.isfromMain
            vc.dataModel = selectArr
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            SVProgressHUD.showInfo(withStatus: "请选择同事送上祝福")
        }
      
    }
    func loadDayData()  {
        STNetworkTools.requestData(URLString:"\(baseUrl)/birth/getDataByDate" ,
            type: .get,
            param: ["date":date],
            successCallBack: { (result) in
                var tempArray = [CQDepartMentAttenceModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQDepartMentAttenceModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                self.dataArr = tempArray
                if self.dataArr.count == 0{
                    
                    self.footBut.isUserInteractionEnabled = false
                    self.footBut.isHidden = true
                }else{
                    self.footBut.isUserInteractionEnabled = true
                    self.footBut.isHidden = false
                }
                self.collectionView.reloadData()
                
        }) { (error) in
            
        }
    }
    func loadData()  {
        STNetworkTools.requestData(URLString:"\(baseUrl)/birth/getDataByMonth" ,
            type: .get,
            param: ["month":Month],
            successCallBack: { (result) in
                var tempArray = [CQDepartMentAttenceModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQDepartMentAttenceModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
               self.dataArr = tempArray
                if self.dataArr.count == 0{

                    self.footBut.isUserInteractionEnabled = false
                    self.footBut.isHidden = true
                }else{
                    self.footBut.isUserInteractionEnabled = true
                    self.footBut.isHidden = false
                }
                self.collectionView.reloadData()
                
        }) { (error) in
            
        }
    }
}
extension QRBirthDayParterVC:UICollectionViewDataSource,UICollectionViewDelegate{

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "birthId", for: indexPath)as! QRBigWishCell
        cell.rootVc = self
        cell.model = self.dataArr[indexPath.row]
        if dataArr[indexPath.row].isSelected == true{
            cell.selectImg.image = UIImage(named: "MessageGroupSelect")
        }else{
            cell.selectImg.image = UIImage(named: "MessageGroupNotSelect")
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let mod = dataArr[indexPath.row]
        mod.isSelected = !mod.isSelected
        if mod.isSelected == true{
            self.selectArr.append(mod)
        }else{
            for (index,value) in selectArr.enumerated(){
                if value == mod{
                    selectArr.remove(at: index)
                   // return
                }
            }
            
        }
        self.collectionView.reloadItems(at: [indexPath])
        
//        let cell = collectionView.cellForItem(at: indexPath) as! QRBigWishCell
//        cell.selectImg.image = UIImage(named: "MessageGroupSelect")
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var header:UICollectionReusableView!
        header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "birthIdHeader", for: indexPath)
        let img = UIImageView(frame:  CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 170)))
        img.image = UIImage(named: "zfhead")
        img.isUserInteractionEnabled = true
        header.addSubview(img)
        return header
    }
}


//
//  QRChooseBackgroundVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/5/24.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class QRChooseBackgroundVC: SuperVC {
    
    //声明闭包
    typealias clickBtnClosure = (_ backimg : String ) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    
    var dataArr = [CQDepartMentAttenceModel]()
    var selectArr = [CQDepartMentAttenceModel]()
    var selectMod : CQDepartMentAttenceModel?
    lazy var collectionView: UICollectionView = {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width: (kWidth-60)/3, height: (kWidth-60)/3)
        layOut.minimumLineSpacing = 10
        layOut.minimumInteritemSpacing = 15
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        layOut.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        layOut.headerReferenceSize =  CGSize.init(width: kWidth, height: AutoGetHeight(height: 15))
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: SafeAreaTopHeight, width: kWidth, height: kHeight-SafeAreaBottomHeight - AutoGetHeight(height: 49) - SafeAreaTopHeight), collectionViewLayout: layOut)
        
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(QRImgCell.self, forCellWithReuseIdentifier: "imageId")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "birthIdHeader")
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(collectionView)
//        let RightButton = UIButton(frame:  CGRect(x: 0, y: 0, width: 60, height: 30))
//        RightButton.setTitle("确定", for: UIControlState.normal)
//        RightButton.addTarget(self, action: #selector(jumpIn), for: UIControlEvents.touchUpInside)
//        RightButton.titleLabel?.font = kFontSize17
//        RightButton.setTitleColor(kBlueColor, for: UIControlState.normal)
//        RightButton.sizeToFit()
//        RightButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: -7)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: RightButton)
        getImgList()
    }
    // 按月份查询生日
    func getImgList() {

        STNetworkTools.requestData(URLString:"\(baseUrl)/birth/getbackGroundImageList" ,
            type: .get,
            param: nil,
            successCallBack: { (result) in
                var tempArray = [CQDepartMentAttenceModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQDepartMentAttenceModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                self.dataArr = tempArray
                self.collectionView.reloadData()

        }) { (error) in
           
        }
        
    }
    
    @objc func jumpIn(){
   
    }
}
extension QRChooseBackgroundVC:UICollectionViewDataSource,UICollectionViewDelegate{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageId", for: indexPath)as! QRImgCell
        cell.backgroundColor = UIColor.green
//        cell.rootVc = self
        cell.model = self.dataArr[indexPath.row]
//        if dataArr[indexPath.row].isSelected == true{
//            cell.selectImg.image = UIImage(named: "MessageGroupSelect")
//        }else{
//            cell.selectImg.image = UIImage(named: "MessageGroupNotSelect")
//        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        //取消全部选中
//        for (_,value) in dataArr.enumerated(){
//          value.isSelected = false
//        }
//        let mod = dataArr[indexPath.row]
//        mod.isSelected = !mod.isSelected
//        self.selectMod = mod
//        self.collectionView.reloadItems(at: [indexPath])
        
            let mod = dataArr[indexPath.row]
        if clickClosure != nil{
             clickClosure!(mod.backGroundImageId)
             self.navigationController?.popViewController(animated: true)
        }else{
            
        }
        
    }
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        var header:UICollectionReusableView!
//        header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "birthIdHeader", for: indexPath)
//        let img = UIImageView(frame:  CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 170)))
//        img.image = UIImage(named: "zfhead")
//        img.isUserInteractionEnabled = true
//        header.addSubview(img)
//        return header
//    }
}


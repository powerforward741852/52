//
//  QRFriendTitlescrollView.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/5/20.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class QRFriendTitlescrollView: UIView {
    
    @IBOutlet weak var collect: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //声明闭包
    typealias clickBtnClosure = (_ InPath:IndexPath) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    
    var dataSource : [QRFileModel]?
    
    var  imgArr = [String]()
    var  titleArr = [String]()
    override func awakeFromNib() {
       collect.delegate = self
       collect.dataSource = self
        
    //       collect.register(QRheadcell.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "head1")
       collect.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "QRGenjinCellId")
    }
    
    
}
extension QRFriendTitlescrollView:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QRGenjinCellId", for: indexPath) 
        cell.removeAllSubviews()
        let imgview = UIImageView(frame:  CGRect(x: (kWidth/5-45)/2, y: 45/2, width: 45, height: 45))
        let img = imgArr[indexPath.row]
        imgview.image = UIImage(named: img)
        
        let tex = titleArr[indexPath.row]
        let title = UILabel(title: tex, textColor: UIColor.black, fontSize: 13, alignment: NSTextAlignment.center, numberOfLines: 1)
        title.frame =  CGRect(x: 5, y: imgview.bottom+10, width: (kWidth/5)-10, height: 15)
        cell.addSubview(title)
        cell.addSubview(imgview)
         return cell
    }
   
//    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        clickClosure!(indexPath)

    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        let head = collectionView.dequeueReusableSupplementaryView(ofKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "head1", for:indexPath ) as! QRheadcell
//        if indexPath.section == 0 {
//            head.label.text = "客户来源"
//        }else if indexPath.section == 1{
//            head.label.text = "跟进状态"
//        }else{
//            head.label.text = "成交状态"
//        }
//        return head
//    }
    
}

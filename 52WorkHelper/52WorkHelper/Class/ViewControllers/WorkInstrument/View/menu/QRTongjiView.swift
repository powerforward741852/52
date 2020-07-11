//
//  QRTongjiView.swift
//  test
//
//  Created by 秦榕 on 2019/4/22.
//  Copyright © 2019年 qq. All rights reserved.
//

import UIKit

class QRTongjiView: UIView {

    //声明闭包
    typealias clickBtnClosure = (_ clickType:Int) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    
    var titleArray = ["提交天数","未提交天数","日程数量","提交率"]
    var countArray = ["0","0","0","0%"]
    
    @IBOutlet weak var collect: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func awakeFromNib() {
        flowLayout.itemSize = CGSize(width: kHaveLeftWidth/2, height: AutoGetHeight(height: 90))
        collect.delegate =  self
        collect.dataSource =  self
        collect.register(UINib.init(nibName: "QRTongjiCollectCell", bundle: nil), forCellWithReuseIdentifier: "tj")
        collect.isScrollEnabled = false
    }
    
//    func changeFrame()  {
//        self.collect.reloadData()
//        self.collect.size = CGSize(width: kHaveLeftWidth, height: 200)
//        self.height = collect.bottom
//
//    }
    
}
extension QRTongjiView : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tj", for: indexPath) as! QRTongjiCollectionCell
        
        cell.titleName.text = titleArray[indexPath.row]
        cell.count.text = countArray[indexPath.row]
        
        if indexPath.row == 2{
            cell.titleName.layer.cornerRadius = 13
           // cell.clipsToBounds = true
            cell.titleName.layer.backgroundColor = UIColor.colorWithHexString(hex: "#e4f6ff").cgColor
            cell.titleName.textColor =  UIColor.colorWithHexString(hex: "#008dda")
        }else{
             cell.titleName.layer.cornerRadius = 0
            // cell.clipsToBounds = false
            cell.titleName.layer.backgroundColor = UIColor.white.cgColor
           cell.titleName.textColor =  UIColor.colorWithHexString(hex: "#6a6a6a")
        }
        
        if indexPath.row == 0{
            cell.count.textColor = UIColor.colorWithHexString(hex: "#fd9812")
        }else if indexPath.row == 1{
            cell.count.textColor = UIColor.colorWithHexString(hex: "#f75716")
        }else if indexPath.row == 2{
            cell.count.textColor = UIColor.colorWithHexString(hex: "#3d9bb7")
        }else if indexPath.row == 3{
            cell.count.textColor = UIColor.colorWithHexString(hex: "#67b26a")
        }else {
            cell.count.textColor = UIColor.black
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        clickClosure!(indexPath.row)
    }
}

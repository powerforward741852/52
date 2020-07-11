//
//  QRWebFilterVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/26.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRWebFilterVC: SuperVC {

    //声明闭包
    typealias clickBtnClosure = (_ selectArr:[Int]) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    //三个必填的数组
    //默认位置
    var selectArr = [Int]()
    var cateArr = [[String]]()
    var cateTitleArr = [String]()
    lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:(kWidth-55)/3,height:36)
        let  collect = UICollectionView(frame:  CGRect(x: 0, y: 0, width: kWidth, height: kHeight), collectionViewLayout: layout)
        layout.sectionInset = UIEdgeInsetsMake(5, 15, 5, 15)
        layout.minimumLineSpacing = 13
        collect.delegate = self
        collect.dataSource = self;
        collect.backgroundColor = UIColor.white
        //注册一个cell
        collect.register( QRfilterCell.self, forCellWithReuseIdentifier:QRFilterVC.ID)
      //  layout.headerReferenceSize = CGSize(width: kWidth, height: 44)
        collect.register(QRheadcell.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "head1")
        return collect
    }()
    lazy var DecideBut :UIButton = {
        let but = UIButton(title: "确定",  titleColor: UIColor.white, fontSize: 22, target: self, action: "confirmClick")
        but.setBackgroundImage(imageWithColor(color: UIColor.colorWithHexString(hex: "#58c3ff"), size: but.frame.size), for: .normal)
        but.setBackgroundImage(imageWithColor(color: kBlueColor, size: but.frame.size), for:.highlighted)
        but.frame =  CGRect(x: 0, y: kHeight-AutoGetHeight(height: 44) -   CGFloat(SafeAreaBottomHeight), width: kWidth, height: AutoGetHeight(height: 44))
        return but
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "类别选择"
        self.view.addSubview(collection)
        self.view.addSubview(DecideBut)
        
    }
    


}

extension QRWebFilterVC: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! QRfilterCell
        //  创建数组记录每个section的位置
        let sec = indexPath.section
        let row = indexPath.row
        // self.seindexpath = indexPath
        
        if selectArr[sec] == -1 {
            cell.contentView.backgroundColor = kfilterBlueColor
            cell.label.textColor = kBlueC
            selectArr[sec] = row
        }else{
            if selectArr[sec] == row {
                //取消选中,设置为-1
                cell.contentView.backgroundColor = kfilterBackColor
                cell.label.textColor = UIColor.black
                selectArr[sec] = -1
                
            }else{
                cell.contentView.backgroundColor = kfilterBlueColor
                cell.label.textColor = kBlueC
                //取消
                let arrRow = IndexPath(item: selectArr[sec], section: sec)
                let cellold = collectionView.cellForItem(at: arrRow) as! QRfilterCell
                cellold.label.textColor = UIColor.black
                cellold.contentView.backgroundColor = kfilterBackColor
                
                selectArr[sec] = row
            }
            
        }
        print(selectArr)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let head = collectionView.dequeueReusableSupplementaryView(ofKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "head1", for:indexPath ) as! QRheadcell
            head.label.text = cateTitleArr[indexPath.section]
            return head
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if cateTitleArr[indexPath.section] == "" {
//         return CGSize(width: kWidth, height: 15)
//        }else{
//         return CGSize(width: kWidth, height: 44)
//        }
//
//    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if cateTitleArr[section] == "" {
            return CGSize(width: kWidth, height: 15)
        }else{
            return CGSize(width: kWidth, height: 44)
        }
    }
}

extension QRWebFilterVC:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cateArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //返回全部数据源
        return cateArr[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QRFilterVC.ID, for: indexPath)as! QRfilterCell
        cell.label.font = kFontSize15
        cell.label.text = cateArr[indexPath.section][indexPath.row]
        
        if selectArr[indexPath.section] == indexPath.row{
            cell.contentView.backgroundColor = kfilterBlueColor
            cell.label.textColor = kBlueC
        }else{
            cell.label.textColor = UIColor.black
            cell.contentView.backgroundColor = kProjectBgColor
        }
        
       
        return cell
    }
}





//:MARK- 点击事件
extension QRWebFilterVC{
    @objc  func confirmClick()  {
        self.navigationController?.popViewController(animated: true)
        self.clickClosure!(self.selectArr)
    }
}

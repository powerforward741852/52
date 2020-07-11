//
//  QRBusinessfilterVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/11.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRBusinessfilterVC: SuperVC {
    var yujijiedanshijian = ["全部","本周","本月","本季度","本年"]
    var aId = ["","week","month","quarter","year"];
    var shangjijine = ["0-1万","1-5万","5-10万","10-50万","50-100万","100万以上"]
    var bId = ["1","2","3","4","5","6"]
    var zuihougenjin = ["今日","本周","本月","三个月"]
    var cId = ["today","week","theMonth","threeMonth"]
    var selectArr = [-1,-1,-1]
    
    //声明闭包
    typealias clickBtnClosure = (_ jiezhi: String,_ jine :String,_ genjin:String,_ arr:[Int] ) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    
 
    lazy var collection: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width:(kWidth-55)/3,height:36)
        let  collect = UICollectionView(frame:  CGRect(x: 0, y: 0, width: kWidth, height: kHeight - AutoGetHeight(height: 44)), collectionViewLayout: layout)
        layout.sectionInset = UIEdgeInsetsMake(5, 15, 5, 15)
        layout.minimumLineSpacing = 13
        collect.delegate = self
        collect.dataSource = self;
        collect.backgroundColor = UIColor.white
        //注册一个cell
        collect.register( QRfilterCell.self, forCellWithReuseIdentifier:QRFilterVC.ID)
        layout.headerReferenceSize = CGSize(width: kWidth, height: 44)
        collect.register(QRheadcell.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "head1")
        return collect
    }()
    lazy var DecideBut :UIButton = {
        let but = UIButton(title: "确 定",  titleColor: UIColor.white, fontSize: 22, target: self, action: "confirmClick")
        but.setBackgroundImage(imageWithColor(color: UIColor.colorWithHexString(hex: "#58c3ff"), size: but.frame.size), for: .normal)
        but.setBackgroundImage(imageWithColor(color: kBlueColor, size: but.frame.size), for:.highlighted)
        but.frame =  CGRect(x: 0, y: kHeight-AutoGetHeight(height: 44) -   CGFloat(SafeAreaBottomHeight), width: kWidth, height: AutoGetHeight(height: 44))
        return but
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "商机"
        self.view.addSubview(collection)
        self.view.addSubview(DecideBut)
    }
    //确定
    @objc func confirmClick(){
       var a = ""
        if selectArr[0] == -1{
            a = ""
        }else{
            a = aId[selectArr[0]]
        }
        
        var b = ""
        if selectArr[1] == -1{
            b = ""
        }else{
            b = bId[selectArr[1]]
        }
        
        var c = ""
        if selectArr[2] == -1{
            c = ""
        }else{
            c = cId[selectArr[2]]
        }
       
        clickClosure!(a,b,c,self.selectArr)
        self.navigationController?.popViewController(animated: true)
    }
}
extension QRBusinessfilterVC:UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return yujijiedanshijian.count
        }else if section == 1 {
            return shangjijine.count
        }else{
            return zuihougenjin.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QRFilterVC.ID, for: indexPath)as! QRfilterCell
        
        if indexPath.section == 0 {
            cell.label.text = yujijiedanshijian[indexPath.item]
            if indexPath.row == selectArr[0]{
                cell.contentView.backgroundColor = kfilterBlueColor
                cell.label.textColor = kBlueC
            }
            
        }else if indexPath.section == 1{
            cell.label.text = shangjijine[indexPath.item]
            if indexPath.row == selectArr[1]{
                cell.contentView.backgroundColor = kfilterBlueColor
                cell.label.textColor = kBlueC
            }
        }else {
            cell.label.text = zuihougenjin[indexPath.item]
            if indexPath.row == selectArr[2]{
                cell.contentView.backgroundColor = kfilterBlueColor
                cell.label.textColor = kBlueC
            }
        }
        return cell
    }
}
extension QRBusinessfilterVC:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! QRfilterCell
        
        //  创建数组记录每个section的位置
        let sec = indexPath.section
        let row = indexPath.row
        
        if selectArr[sec] == -1 {
            cell.contentView.backgroundColor = kfilterBlueColor
            cell.label.textColor = kBlueC
            selectArr[sec] = row
        }else{
            if selectArr[sec] == row {
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
        if indexPath.section == 0 {
            head.label.text = "预计结单时间"
        }else if indexPath.section == 1{
            head.label.text = "商机金额"
        }else{
            head.label.text = "最后跟进时间"
        }
        return head
    }
    
}



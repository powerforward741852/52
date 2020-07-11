//
//  QRGongHaiFilterVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/16.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRGongHaiFilterVC: SuperVC {

    //声明闭包
    typealias clickBtnClosure = (_ laiyuan: String?,_ genjin :String,_ chengjiao :String ,_ shijian :String ,_ shuzu :[Int] ) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    //上线
    var sx = "0"
    var cateId = ""
    static let ID = "hotcell"

    var shangxian = ["全部","已上线","已下线"]
    var kehulaiyuan = ["全部","网络营销","电话营销","渠道代理","线下拜访","亲朋好友","会议营销","其他","自定义"]
    var genjin = ["全部","尚未跟进","跟进1次","跟进2次","跟进3次","意向","初访","已签约"]
    var chengjiao = ["全部","暂无","已成交","多次提交"]
    var weiGenjin = ["全部","1周到2周","2周到1月","1月到2月","2月以上"]
    
    
    var selectArr = [0,0,0,0]
    lazy var collection: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width:(kWidth-55)/3,height:36)
        let  collect = UICollectionView(frame:  CGRect(x: 0, y: 0, width: kWidth, height: kHeight-AutoGetHeight(height: 44)), collectionViewLayout: layout)
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
        title = "客户公海"
        self.view.addSubview(collection)
        self.view.addSubview(DecideBut)
   
    }
    @objc func confirmClick(){
        //确认
//        if selectArr[0] == -1{
//
//        }
        var messtage = kehulaiyuan[selectArr[0]]
        if selectArr[0] == 0 {
            messtage = ""
        }
        
        
        var genjin = ""
        if selectArr[1] == 0 {
            genjin = ""
        }else if selectArr[1] == 1 {
            genjin = "0"
        }else if selectArr[1] == 2{
            genjin = "1"
        }else if selectArr[1] == 3{
            genjin = "2"
        }else if selectArr[1] == 4{
            genjin = "3"
        }else if selectArr[1] == 5{
            genjin = "4"
        }else if selectArr[1] == 6{
            genjin = "5"
        }else if selectArr[1] == 7{
            genjin = "6"
        }
        
        
        
        var chengjiao = ""
        if selectArr[2] == 0 {
            chengjiao = ""
        }else if selectArr[2] == 1 {
            chengjiao = "0"
        }else if selectArr[2] == 2{
            chengjiao = "1"
        }else{
            chengjiao = "2"
        }
        var time = ""
        if selectArr[3] == 0{
            time = ""
        }else if selectArr[3] == 1{
            time = "followLastOneToTwoWeek"
        }else if selectArr[3] == 2{
            time = "followLastTwoWeekToOneMonth2"
        }else if selectArr[3] == 3{
            time = "followLastOneMonthToTwoMonth"
        }else if selectArr[3] == 4{
            time = "followLastTwoMonth2"
        }
        
       
        clickClosure!(messtage,genjin,chengjiao,time,self.selectArr)
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension QRGongHaiFilterVC:UICollectionViewDelegate{
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
//                cell.contentView.backgroundColor = kProjectBgColor
//                cell.label.textColor = UIColor.darkGray
//                selectArr[sec] = -1
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
            head.label.text = "客户来源"
        }else if indexPath.section == 1{
            head.label.text = "跟进状态"
        }else if indexPath.section == 2{
            head.label.text = "成交状态"
        }else {
            head.label.text = "未跟进时间"
        }
        return head
    }
    
    
}
extension QRGongHaiFilterVC:UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            
            return kehulaiyuan.count
        }else if section == 1{
            return genjin.count
        }else if section == 2{
            return chengjiao.count
        }else {
            return weiGenjin.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QRFilterVC.ID, for: indexPath)as! QRfilterCell
        
        if indexPath.section == 0 {
            if indexPath.row == selectArr[0]{
            cell.contentView.backgroundColor = kfilterBlueColor
                cell.label.textColor = kBlueC
                
            }
            cell.label.text = kehulaiyuan[indexPath.item]
            cell.label.font = kFontSize15
            
        }else if indexPath.section == 1{
            if indexPath.row == selectArr[1]{
                cell.contentView.backgroundColor = kfilterBlueColor
                cell.label.textColor = kBlueC
            }
                cell.label.text = genjin[indexPath.item]
                cell.label.font = kFontSize15
        }else if indexPath.section == 2{
            if indexPath.row == selectArr[2]{
                cell.contentView.backgroundColor = kfilterBlueColor
                cell.label.textColor = kBlueC
            }
            cell.label.text = chengjiao[indexPath.item]
            cell.label.font = kFontSize15
        }else{
            if indexPath.row == selectArr[3]{
                cell.contentView.backgroundColor = kfilterBlueColor
                cell.label.textColor = kBlueC
            }
            cell.label.text = weiGenjin[indexPath.item]
            cell.label.font = kFontSize15
        }
        return cell
    }
    
}

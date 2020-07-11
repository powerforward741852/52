//
//  QRSearchHistoryView.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/5/27.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class QRSearchHistoryView: UIView {
    
    //声明闭包
    typealias clickBtnClosure = (_ keyword : String) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    var dataStr : String?
    var dataArr = ["学习","培训","出差","开会","拜访客户"]
    var collection : UICollectionView?
    
    var cell : HistoryViewCell?
    var QRflowLayout : JYEqualCellSpaceFlowLayout?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func creatSearchHistoryView() -> QRSearchHistoryView {
        let SearchHistoryView = QRSearchHistoryView(frame:  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        SearchHistoryView.backgroundColor = UIColor.white //UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.7)
        SearchHistoryView.setUpUi()
        return SearchHistoryView
    }
    
    func setUpUi(){
        //背景
        let backGroundView = UIView(frame:  CGRect(x: 0, y: 0, width: kWidth, height: 0.7))
        backGroundView.backgroundColor = kProjectBgColor
        self.addSubview(backGroundView)
       
        //历史的collectionView
        
        let layout = JYEqualCellSpaceFlowLayout(type: AlignType.withLeft, betweenOfCell: 10)
        self.QRflowLayout = layout
        let  collect = UICollectionView(frame:  CGRect(x: 0, y: 1, width: kWidth, height: 49), collectionViewLayout: layout!)
        collect.delegate = self
        collect.dataSource = self;
        collect.backgroundColor = UIColor.white
       // collect.register( HistoryViewCell.self, forCellWithReuseIdentifier:QRFilterVC.ID)
        collect.register(UINib(nibName: "HistoryViewCell", bundle: nil), forCellWithReuseIdentifier: "HistoryViewCell")
        self.collection = collect
        self.addSubview(collect)

    }
    
    @objc func reloadView(){
        self.collection?.reloadData()
        let height = QRflowLayout?.collectionViewContentSize.height
        self.collection?.frame =  CGRect(x: 0, y: 1, width: kWidth, height: height!+5)
        let userInfo = ["height":height]
        NotificationCenter.default.post(name: NSNotification.Name.init("updateHistoryHeight"), object: self, userInfo: userInfo as [AnyHashable : Any])
        
    }
    
    
    @objc func closeWindow(){
        self.dismissPopView()
    }
    
    @objc func buKa(){
        print("补卡")
        clickClosure!("B_BK")
        
    }
    
    func showPopView(){
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.addSubview(self)
    }
    
    func dismissPopView(){
        self.removeFromSuperview()
    }
   
}
extension QRSearchHistoryView : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryViewCell", for: indexPath) as! HistoryViewCell
        cell.keyword = dataArr[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if cell == nil{
            cell = (Bundle.main.loadNibNamed("HistoryViewCell", owner: nil, options: nil)?.last as! HistoryViewCell)
        }
        cell?.keyword = dataArr[indexPath.row]
        return (cell?.sizeForCell())!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.dataArr.insert("dsdas", at: 0)
//        self.reloadView()
        let keyword = dataArr[indexPath.row]
        if clickClosure != nil{
            clickClosure!(keyword)
        }
        
    }
}

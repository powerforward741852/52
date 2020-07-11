//
//  QRZhufuView.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/21.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRZhufuView: UIView {
    
    var dataSource = [CQDepartMentAttenceModel]()
    lazy var bottomView : UIView = {
        let bottomView = UIView(frame:  CGRect(x: 0, y: collectionView.bottom+10, width: pictureViewWidth, height: AutoGetHeight(height: 20)))
        bottomView.backgroundColor = UIColor.colorWithHexString(hex: "#05a3f5")
        bottomView.layer.cornerRadius = 10
        bottomView.clipsToBounds = true
        return bottomView
    }()
    lazy var topView : UIView = {
        let topView = UIView(frame:  CGRect(x: 0, y: 0, width: pictureViewWidth, height: AutoGetHeight(height: 20)))
        topView.backgroundColor = UIColor.colorWithHexString(hex: "#05a3f5")
        return topView
    }()
    lazy var cakeView : UIView = {
        let cakeView = UIView(frame:  CGRect(x: 0, y: 0, width: pictureViewWidth, height: AutoGetHeight(height: pictureViewWidth*0.65+40+40+40)))
        cakeView.backgroundColor = UIColor.colorWithHexString(hex: "#05a3f5")
        cakeView.layer.cornerRadius = AutoGetWidth(width: 10)
        cakeView.clipsToBounds = true
        cakeView.addSubview(self.iconImg)
        cakeView.addSubview(self.nameLalel)
        cakeView.addSubview(self.cakeImg)
        cakeView.addSubview(self.bitthLalel)
        cakeView.addSubview(self.topView)
        return cakeView
    }()
    
    lazy var iconImg : UIImageView = {
        let iconImg = UIImageView(frame:  CGRect(x: (pictureViewWidth - AutoGetWidth(width: 40))/2, y:  AutoGetWidth(width: 8), width: AutoGetWidth(width: 36), height: AutoGetWidth(width: 36)))
        iconImg.layer.cornerRadius =  AutoGetWidth(width: 18)
        iconImg.clipsToBounds = true
        iconImg.image = UIImage(named: "tx")
        return iconImg
    }()
    
    lazy var nameLalel :UILabel = {
        let nameLalel = UILabel(title: "来自:小米", textColor: UIColor.white, fontSize: 13)
        nameLalel.textAlignment = .center
        nameLalel.frame =  CGRect(x: 0, y: iconImg.bottom+AutoGetWidth(width: 3), width: pictureViewWidth, height: AutoGetHeight(height: 15))
        nameLalel.numberOfLines = 1
        return nameLalel
    }()
    
    lazy var cakeImg : UIImageView = {
        let cakeImg = UIImageView(frame:  CGRect(x:0.1*pictureViewWidth, y: nameLalel.bottom, width: pictureViewWidth*0.8, height: pictureViewWidth*0.65*0.8))
        
        cakeImg.image = UIImage(named: "cake")
        return cakeImg
    }()
    
    lazy var bitthLalel :UILabel = {
        let bitthLalel = UILabel(title: "生日快乐!", textColor: UIColor.white, fontSize: 30)
        bitthLalel.frame =  CGRect(x: 0, y: cakeImg.bottom-10, width: pictureViewWidth, height: AutoGetHeight(height: 35) )
        bitthLalel.numberOfLines = 1
        bitthLalel.font = UIFont.boldSystemFont(ofSize: 27)
        bitthLalel.textAlignment = .center
        bitthLalel.backgroundColor =  UIColor.colorWithHexString(hex: "#05a3f5")
        return bitthLalel
    }()
    
    
    lazy var collectionView: UICollectionView = {
      //  let layOut = UICollectionViewFlowLayout.init()
        let layOut = JYEqualCellSpaceFlowLayout(type: AlignType.withCenter, betweenOfCell: 0) as JYEqualCellSpaceFlowLayout
  
        layOut.itemSize = CGSize.init(width: (pictureViewWidth)/numOfPerRow, height: (pictureViewWidth)/numOfPerRow)
        layOut.minimumLineSpacing = 0
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        layOut.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       // layOut.footerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 108))
       // layOut.headerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 225+40+20+40+20))
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x:0, y: cakeView.bottom, width: pictureViewWidth, height:0 ), collectionViewLayout: layOut)
        if #available(iOS 11.0, *) {
        } else {
            //低于 iOS 9.0
          //  self.automaticallyAdjustsScrollViewInsets = false
        }
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.colorWithHexString(hex: "#05a3f5")
        collectionView.allowsSelection = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(QRWishPersonCell.self, forCellWithReuseIdentifier: "sendWishId")
      //  collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "wishTextId")
      //  collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "happybirthIdcellHeader")
        return collectionView
    }()
    
    
    
    var margin:CGFloat = 0
    var iconSize: CGSize?
    var numOfPerRow: CGFloat = 0
    var imageHeight:CGFloat = 0
    var imageSize:CGFloat = 0
    
    var pictureViewWidth:CGFloat = 0
    var pictureViewHeight:CGFloat = 0
    var cakeHeight:CGFloat = 0
    
    var isShowFour:Bool = false
    init(width:CGFloat,numberOfRow:CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: 10))
        pictureViewWidth =  width
        numOfPerRow = numberOfRow
        imageHeight = width/numOfPerRow
        cakeHeight = width*0.65
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
    
       addSubview(cakeView)
       //addSubview(topView)
       addSubview(collectionView)
       addSubview(bottomView)
        self.sendSubview(toBack: bottomView)
    }
    
    func setDataSource(data:[CQDepartMentAttenceModel]){
        self.dataSource = data
        self.collectionView.reloadData()
        let rowNum = (data.count - 1)/(Int(numOfPerRow)) + 1
        let sheight = CGFloat(rowNum) * imageHeight
        
       bottomView.frame =  CGRect(x: 0, y: 0, width: pictureViewWidth, height: AutoGetHeight(height: 20))
    
        collectionView.frame =  CGRect(x: 0, y: bottomView.bottom - AutoGetHeight(height: 10), width: pictureViewWidth, height: sheight)
        cakeImg.frame =  CGRect(x: 0.1*pictureViewWidth, y: AutoGetHeight(height: 10) , width: pictureViewWidth*0.8, height: pictureViewWidth*0.65*0.8)
        bitthLalel.frame = CGRect(x: 0, y: cakeImg.bottom-10, width: pictureViewWidth, height: AutoGetHeight(height: 35))
        iconImg.frame = CGRect(x: (pictureViewWidth - AutoGetWidth(width: 40))/2, y: bitthLalel.bottom, width: AutoGetWidth(width: 36), height: AutoGetWidth(width: 0))
        nameLalel.frame = CGRect(x: 0, y: iconImg.bottom+AutoGetWidth(width: 3), width: pictureViewWidth, height: AutoGetHeight(height: 15))
        cakeView.frame = CGRect(x: 0, y: collectionView.bottom - AutoGetHeight(height: 10), width: pictureViewWidth, height: nameLalel.bottom+15)
        topView.isHidden = true
        
        
        self.pictureViewHeight = cakeView.bottom
       
    }
    func setWishDataSource(data:[CQDepartMentAttenceModel]){
        self.dataSource = data
        self.collectionView.reloadData()
        let rowNum = (data.count - 1)/(Int(numOfPerRow)) + 1
        let sheight = CGFloat(rowNum) * imageHeight
       
        bottomView.frame = CGRect(x: 0, y: 0, width: pictureViewWidth, height: AutoGetHeight(height: 20))
        collectionView.frame =  CGRect(x: 0, y: bottomView.bottom - AutoGetHeight(height: 10), width: pictureViewWidth, height: sheight)
        cakeImg.frame =  CGRect(x: 0, y: AutoGetHeight(height: 5) , width: pictureViewWidth, height: pictureViewWidth*0.65)
        bitthLalel.frame = CGRect(x: 0, y: cakeImg.bottom, width: pictureViewWidth, height: AutoGetHeight(height: 35))
        
        topView.frame =  CGRect(x: 0, y: bitthLalel.bottom, width: pictureViewWidth, height: AutoGetHeight(height: 108))
        
        iconImg.frame = CGRect(x: (pictureViewWidth - AutoGetWidth(width: 40))/2, y: topView.bottom, width: AutoGetWidth(width: 36), height: AutoGetWidth(width: 0))
        nameLalel.frame = CGRect(x: 0, y: iconImg.bottom+AutoGetWidth(width: 3), width: pictureViewWidth, height: AutoGetHeight(height: 15))
        
         cakeView.frame = CGRect(x: 0, y: collectionView.bottom - AutoGetHeight(height: 10), width: pictureViewWidth, height: nameLalel.bottom+15)
      topView.frame =  CGRect(x: 0, y: bitthLalel.bottom, width: pictureViewWidth, height: AutoGetHeight(height: 108))
        


    
        self.pictureViewHeight = cakeView.bottom
        
//
//        cakeImg.frame =  CGRect(x:0, y: nameLalel.bottom, width: pictureViewWidth, height: pictureViewWidth*0.65)
//        bitthLalel.frame =  CGRect(x: 0, y: cakeImg.bottom-10, width: pictureViewWidth, height: AutoGetHeight(height: 35) )
//        cakeView.frame = CGRect(x: 0, y: 0, width: pictureViewWidth, height: bitthLalel.bottom+5)
//        topView.frame =  CGRect(x: 0, y: cakeView.bottom-AutoGetHeight(height: 10), width: pictureViewWidth, height: AutoGetHeight(height: 108))
//        collectionView.frame =  CGRect(x: 0, y: topView.bottom, width: pictureViewWidth, height: sheight)
//        bottomView.frame = CGRect(x: 0, y: collectionView.bottom-AutoGetHeight(height: 10), width: pictureViewWidth, height: AutoGetHeight(height: 20))
//        self.pictureViewHeight = bottomView.bottom
        
    }
}
extension QRZhufuView:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sendWishId", for: indexPath)as! QRWishPersonCell
        cell.backgroundColor = UIColor.colorWithHexString(hex: "#05a3f5")
         cell.model = dataSource[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        print(kind)
//        if kind == UICollectionElementKindSectionFooter{
//            var header:UICollectionReusableView!
//            header = collectionView.dequeueReusableSupplementaryView(ofKind:UICollectionElementKindSectionFooter, withReuseIdentifier: "wishTextId", for: indexPath)
//
//            return header
//        }else {
//            var header:UICollectionReusableView!
//            header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "happybirthIdcellHeader", for: indexPath)
//            self.cakeView.addSubview(self.iconImg)
//            self.cakeView.addSubview(self.nameLalel)
//            self.cakeView.addSubview(self.cakeImg)
//            self.cakeView.addSubview(self.bitthLalel)
//
//            header.addSubview(cakeView)
//            return header
//        }
//
//    }
    
}

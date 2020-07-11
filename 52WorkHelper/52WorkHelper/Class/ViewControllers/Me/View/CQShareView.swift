//
//  CQShareView.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/5.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol CQShareDelegate : NSObjectProtocol{
    func pushToThirdPlatform(index:Int)
}

class CQShareView: UIView {

    weak var cqShareDelegate:CQShareDelegate?
    var imageArray = [String]()
    var titleArray = [String]()
    var type = -1
    
    lazy var bgView: UIView = {
        let bgView = UIView.init(frame: CGRect.init(x: 0, y: kHeight - AutoGetHeight(height: 100) - CGFloat(SafeAreaBottomHeight) , width: kWidth, height: AutoGetHeight(height: 100) + CGFloat(SafeAreaBottomHeight)))
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width: kWidth/4, height: AutoGetHeight(height: 64))
        layOut.minimumLineSpacing = 0
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        layOut.footerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 36))
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 100)), collectionViewLayout: layOut)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(CQShareCollectionCell.self, forCellWithReuseIdentifier: "CQShareCollectionCellId")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "CQShareFooterView")
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleArray = ["微信好友","微信朋友圈","QQ","QQ空间"]
        self.imageArray = ["wechat","wechatLine","QQ","qZone"]
        
        
        
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setData()  {
        if type == 0{
            
            self.titleArray = ["微信好友","微信朋友圈","QQ","QQ空间","保存到通讯录"]
            self.imageArray = ["wechat","wechatLine","QQ","qZone","1024"]
            //重新设置frame  CGRect.init(x: 0, y: kHeight - AutoGetHeight(height: 100), width: kWidth, height: AutoGetHeight(height: 100))
            self.bgView.frame =  CGRect(x: 0, y: kHeight - AutoGetHeight(height: 164) - CGFloat(SafeAreaBottomHeight), width: kWidth, height: AutoGetHeight(height: 164) + CGFloat(SafeAreaBottomHeight))
            self.collectionView.frame =  CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 164) )
            
        }else if type == 1 {
            
//            self.titleArray = ["微信好友","微信朋友圈","QQ","QQ空间","联系人"]
//            self.imageArray = ["wechat","wechatLine","QQ","qZone","1024"]
            self.titleArray = ["微信好友","微信朋友圈","QQ","QQ空间"]
            self.imageArray = ["wechat","wechatLine","QQ","qZone"]
            self.bgView.frame =  CGRect(x: 0, y: kHeight - AutoGetHeight(height: 100) - CGFloat(SafeAreaBottomHeight) , width: kWidth, height: AutoGetHeight(height: 100) + CGFloat(SafeAreaBottomHeight))
            self.collectionView.frame =  CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 100) )
        }
    }
    
    func setUp()  {
        self.addSubview(self.bgView)
        self.bgView.addSubview(self.collectionView)
    }
    
    @objc func dismissView()  {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (finished:Bool) in
            self.removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        let point = touch.location(in: self)
        if point.x < self.bgView.frame.origin.x || point.x > self.bgView.frame.origin.x || point.y < self.bgView.frame.origin.y || point.y > self.bgView.frame.origin.y {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }) { (finished:Bool) in
                self.removeFromSuperview()
            }
        }
    }

}

// MARK: - 代理

extension CQShareView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    
}

extension CQShareView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQShareCollectionCellId", for: indexPath) as! CQShareCollectionCell
        cell.iconImg.image = UIImage.init(named: self.imageArray[indexPath.item])
        cell.nameLab.text = self.titleArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismissView()
        if self.cqShareDelegate != nil {
            self.cqShareDelegate?.pushToThirdPlatform(index: indexPath.item)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "CQShareFooterView", for: indexPath)
        let cancelBtn = UIButton.init(type: .custom)
        cancelBtn.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 36))
        cancelBtn.setTitle("取 消", for: .normal)
        cancelBtn.setTitleColor(kLightBlueColor, for: .normal)
        //cancelBtn.layer.borderColor = kLyGrayColor.cgColor
        //cancelBtn.layer.borderWidth = 0.5
        cancelBtn.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        let greylineview = UIView()
        greylineview.frame =  CGRect(x: 0, y: 0, width: kWidth, height: 0.5)
        greylineview.backgroundColor = kLyGrayColor
        
        header.addSubview(cancelBtn)
        header.addSubview(greylineview)
        return header
    }
    
    
}

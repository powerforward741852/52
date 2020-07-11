//
//  CQFriendCollectionView.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/7/16.
//  Copyright © 2018年 chenqihang. All righ ts reserved.
//

import UIKit

protocol CQFriendCircleImageSelectDelegate : NSObjectProtocol{
    func pushToImagePreView(images:[String],index:Int)
}

class CQFriendCollectionView: UICollectionView {

    var collectDataArray = [JSON]()
    var imageArr = [String]()
    weak var selectItemDelegate:CQFriendCircleImageSelectDelegate?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = UIColor.white
        self.delegate = self
        self.dataSource = self
        self.register(CQWorkMateCircleImageCell.self, forCellWithReuseIdentifier: "CQWorkMateCircleImageCellId")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


//  MARK:UICollectionViewDelegate
extension CQFriendCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.collectDataArray.count
    }
    
}

extension CQFriendCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQWorkMateCircleImageCellId", for: indexPath) as! CQWorkMateCircleImageCell
        
        if self.collectDataArray.count>0{
            cell.img.sd_setImage(with: URL(string:self.collectDataArray[indexPath.item].stringValue), placeholderImage:UIImage.init(named: "demo"))
            
        }else{
            cell.img.image = UIImage.init(named: "demo")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.imageArr.removeAll()
        for str in self.collectDataArray{
            self.imageArr.append(str.stringValue)
        }
        
        if self.selectItemDelegate != nil{
            self.selectItemDelegate?.pushToImagePreView(images: self.imageArr,index: indexPath.item)
        }
        
    }
    
}

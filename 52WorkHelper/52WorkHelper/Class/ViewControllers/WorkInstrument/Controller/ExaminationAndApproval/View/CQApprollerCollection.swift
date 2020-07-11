//
//  CQApprollerCollection.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/7/27.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQApprollerCollection: UICollectionView {

    var collectDataArray = [CQDepartMentUserListModel]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = UIColor.white
        self.delegate = self
        self.dataSource = self
        self.register(CQWriteReportCell.self, forCellWithReuseIdentifier: "CQWriteReportCellId")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//  MARK:UICollectionViewDelegate
extension CQApprollerCollection: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.collectDataArray.count
    }
    
}

extension CQApprollerCollection: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQWorkMateCircleImageCellId", for: indexPath) as! CQWorkMateCircleImageCell
        
        if self.collectDataArray.count>0{
            cell.img.sd_setImage(with: URL(string:self.collectDataArray[indexPath.item].headImage), placeholderImage:UIImage.init(named: "personDefaultIcon"))
        }else{
            cell.img.image = UIImage.init(named: "personDefaultIcon")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

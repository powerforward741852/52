//
//  QRYuanjiaoFlowLayout.swift
//  test
//
//  Created by 秦榕 on 2018/12/4.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit

class QRYuanjiaoFlowLayout: UICollectionViewFlowLayout {
    var itemAttributes = NSMutableArray()
    override func prepare() {
        super.prepare()
        let delegate = self.collectionView!.delegate as! UICollectionViewDelegateFlowLayout;
        let numberOfSection = self.collectionView!.numberOfSections;
        for index in 0...numberOfSection-1 {
            let lastIndex = (self.collectionView?.numberOfItems(inSection: index))!-1
            if (lastIndex < 0){
                
            }else{
                    let firstItem = self.layoutAttributesForItem(at: IndexPath(item: 0, section: index))
                   let lastItem = self.layoutAttributesForItem(at: IndexPath(item: lastIndex, section: index))
                var sectioninset = self.sectionInset;
                sectioninset = delegate.collectionView!(self.collectionView!, layout: self, insetForSectionAt: index)
                var frame = firstItem?.frame.union((lastItem?.frame)!)
                frame!.origin.x -= sectioninset.left
                frame!.origin.y -= sectioninset.top
                frame!.size.width = self.collectionView!.frame.size.width
                frame!.size.height += sectionInset.top + sectionInset.bottom
                
                let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "QRDecorationCollectionReusableView", with: IndexPath(item: 0, section: index))
                attributes.zIndex = -1;
                attributes.frame = frame!;
                self.itemAttributes.add(attributes)
                self.register(QRDecorateView.self, forDecorationViewOfKind: "QRDecorationCollectionReusableView")

            }
            

        }
        
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
       var attributes = super.layoutAttributesForElements(in: rect)
        for xx in self.itemAttributes {
            let xxx = xx as! UICollectionViewLayoutAttributes
            if rect.intersects(xxx.frame){
                attributes?.append(xxx)
            }
        }
        return attributes
    }
    
//    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        <#code#>
//    }
}

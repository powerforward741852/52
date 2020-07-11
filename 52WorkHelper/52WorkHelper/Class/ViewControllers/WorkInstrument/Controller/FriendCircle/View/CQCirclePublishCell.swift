//
//  CQCirclePublishCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/19.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol CQPublishDeleteDelegate : NSObjectProtocol{
    func deletePublishPic(index:IndexPath)
}

class CQCirclePublishCell: UICollectionViewCell {
    
   weak var deleteDelegate:CQPublishDeleteDelegate?
    
    lazy var img: UIImageView = {
        let img = UIImageView.init(frame: CGRect.init(x: AutoGetWidth(width: 0), y: AutoGetWidth(width: 0), width: (kHaveLeftWidth-AutoGetWidth(width: 30))/4, height: (kHaveLeftWidth-AutoGetWidth(width: 30))/4))
        img.image = UIImage.init(named: "demo")
        img.isUserInteractionEnabled = true
        return img
    }()
    
    lazy var deleteBtn: UIButton = {
        let deleteBtn = UIButton.init(type: .custom)
        deleteBtn.frame = CGRect.init(x:(kHaveLeftWidth-AutoGetWidth(width: 30))/4 - AutoGetWidth(width: 24) , y: AutoGetHeight(height: 0), width: AutoGetWidth(width: 24), height: AutoGetWidth(width: 24))
        deleteBtn.setImage(UIImage.init(named: "CQDeleteBtn"), for: .normal)
        deleteBtn.addTarget(self, action: #selector(deleteClick(sender:)), for: UIControlEvents.touchUpInside)
        return deleteBtn
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.setup()
        
    }
    
    func setup()  {
        addSubview(self.img)
        
        self.img.addSubview(self.deleteBtn)
        deleteBtn.isHidden = true
    }
    
    @objc func deleteClick(sender:AnyObject)  {
        let btn = sender as! UIButton
        let cell = superUITableViewCell(of: btn)
        let table = superUITableView(of: btn)
        let index = table?.indexPath(for: cell!)
        DLog(index)
        
        
        
        if self.deleteDelegate != nil{
            self.deleteDelegate?.deletePublishPic(index: index!)
        }
    }
    
    //返回button所在的UITableViewCell
    func superUITableViewCell(of: UIButton) -> UICollectionViewCell? {
        for view in sequence(first: of.superview, next: { $0?.superview }) {
            if let cell = view as? UICollectionViewCell {
                return cell
            }
        }
        return nil
    }
    
    //返回button所在的UITableView
    func superUITableView(of: UIButton) -> UICollectionView? {
        for view in sequence(first: of.superview, next: { $0?.superview }) {
            if let table = view as? UICollectionView {
                return table
            }
        }
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

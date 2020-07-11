//
//  CQWriteReportCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/9.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol CQSelectDeleteDelegate : NSObjectProtocol{
    func deleteCollectionCell(index:IndexPath)
}

protocol CQOverSelectDeleteDelegate : NSObjectProtocol{
    func deleteOverCollectionCell(index:IndexPath)
}

protocol CQTogetherDeleteDelegate : NSObjectProtocol{
    func deleteTogetherPerson(index:IndexPath)
}

class CQWriteReportCell: UICollectionViewCell {
    
   weak var deleteDelegate:CQSelectDeleteDelegate?
    weak var overDelegate:CQOverSelectDeleteDelegate?
    weak var togetherDelegate:CQTogetherDeleteDelegate?
    lazy var img: UIImageView = {
        let img = UIImageView.init(frame: CGRect.init(x: (kHaveLeftWidth/4 - AutoGetWidth(width: 36))/2, y: AutoGetHeight(height: 9), width: AutoGetWidth(width: 36), height: AutoGetWidth(width: 36)))
        img.image = UIImage.init(named: "personDefaultIcon")
        img.layer.cornerRadius = AutoGetWidth(width: 18)
        img.clipsToBounds = true
        return img
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: 0, y: self.img.bottom + AutoGetHeight(height: 7), width: kHaveLeftWidth/4, height: AutoGetHeight(height: 14)))
        nameLab.textAlignment = .center
        nameLab.textColor = kLyGrayColor
        nameLab.text = "李明"
        nameLab.font = kFontSize14
        return nameLab
    }()
    
    lazy var deleteBtn: UIButton = {
        let deleteBtn = UIButton.init(type: .custom)
        deleteBtn.frame = CGRect.init(x: kHaveLeftWidth/8 + AutoGetWidth(width:6), y: AutoGetHeight(height: 10), width: AutoGetWidth(width: 12), height: AutoGetWidth(width: 12))
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
        addSubview(self.nameLab)
        addSubview(self.deleteBtn)
        deleteBtn.isHidden = true
    }
    
    @objc func deleteClick(sender:AnyObject)  {
        let btn = sender as! UIButton
        let cell = superUITableViewCell(of: btn)
        let table = superUITableView(of: btn)
        let index = table?.indexPath(for: cell!)
        DLog(index)
        
        if self.deleteDelegate != nil {
            self.deleteDelegate?.deleteCollectionCell(index: index!)
        }
        
        if self.overDelegate != nil{
            self.overDelegate?.deleteOverCollectionCell(index: index!)
        }
        
        if self.togetherDelegate != nil{
            self.togetherDelegate?.deleteTogetherPerson(index: index!)
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

//
//  QRGenjinCollectionCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/13.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit
protocol QRGenjinCollectionCellDeleteDelegate : NSObjectProtocol {
    func deletePublishPic(index:IndexPath)
}
class QRGenjinCollectionCell: UICollectionViewCell {
    weak var deleteDelegate:QRGenjinCollectionCellDeleteDelegate?
    
    lazy var img: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named: "CQIndexPersonDefault")
        img.layer.cornerRadius = 20
        img.clipsToBounds = true
        img.isUserInteractionEnabled = true
        return img
    }()
    lazy var name: UILabel = {
        let name = UILabel(title: "黄志坤", textColor: UIColor.black, fontSize: 14 )
        
        return name
    }()
    lazy var deleteBtn: UIButton = {
        let deleteBtn = UIButton.init(type: .custom)

        deleteBtn.setImage(UIImage.init(named: "CQDeleteBtn"), for: .normal)
        deleteBtn.addTarget(self, action: #selector(deleteClick(sender:)), for: UIControlEvents.touchUpInside)
        return deleteBtn
    }()
    lazy var location: UILabel = {
        let name = UILabel(title: "项目经理", textColor: klightGreyColor, fontSize: 12 )
        
        return name
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        
    }
    
    func setup()  {
        deleteBtn.isHidden = true
        contentView.addSubview(img)
        contentView.addSubview(name)
        contentView.addSubview(location)
        contentView.addSubview(deleteBtn)
        img.mas_makeConstraints { (make) in
            make?.centerX.mas_equalTo()(contentView)
            make?.top.mas_equalTo()(contentView)?.setOffset(5)
            make?.width.mas_equalTo()(40)
            make?.height.mas_equalTo()(40)
        }
        deleteBtn.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(contentView)?.setOffset(-5)
            make?.top.mas_equalTo()(contentView)?.setOffset(5)
            make?.width.mas_equalTo()(15)
            make?.height.mas_equalTo()(15)
        }
        name.mas_makeConstraints { (make) in
            make?.centerX.mas_equalTo()(contentView)
            make?.top.mas_equalTo()(img.mas_bottom)?.setOffset(4)
            make?.height.mas_equalTo()(15)
        }
        location.mas_makeConstraints { (make) in
            make?.centerX.mas_equalTo()(contentView)
            make?.top.mas_equalTo()(name.mas_bottom)?.setOffset(2)
            make?.height.mas_equalTo()(15)
        }
        
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

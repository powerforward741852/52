//
//  CQSmileWallCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/9/29.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol CQSmileZanDelegate : NSObjectProtocol{
    func zanAction(index:IndexPath)
    func deleteAction(index:IndexPath)
}

class CQSmileWallCell: UICollectionViewCell {
    
    weak var zanDelegate:CQSmileZanDelegate?
    
    lazy var img: UIImageView = {
//        let img = UIImageView.init(frame: CGRect.init(x:0, y: 0, width: self.tz_width, height:self.tz_width*496/750 ))  //self.tz_height
         let img = UIImageView.init(frame: CGRect.init(x:0, y: 0, width: self.tz_width, height:self.tz_height ))
        img.layer.cornerRadius = 5
        img.contentMode = UIView.ContentMode.scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    lazy var backGroundV : UIView = {
        let backGroundV = UIView.init(frame: CGRect.init(x:0, y: 0, width: self.tz_width, height: self.tz_height))
        backGroundV.layer.cornerRadius = 5
        backGroundV.clipsToBounds = true
        backGroundV.backgroundColor = kColorRGB(r: 213, g: 214, b: 213)
        return backGroundV
    }()
    lazy var NameLabel :UILabel = {
        let NameLabel = UILabel(title: "我的客户标题", textColor: UIColor.white, fontSize: 13)
        NameLabel.frame =  CGRect(x: 15, y: img.bottom, width: self.tz_width/2, height: 30)
        NameLabel.numberOfLines = 0
        return NameLabel
    }()
    
    lazy var deleteBtn: UIButton = {
        let deleteBtn = UIButton.init(type: .custom)
        deleteBtn.frame = CGRect.init(x: self.tz_width - AutoGetWidth(width: 30), y: self.tz_height - AutoGetHeight(height: 25), width: AutoGetWidth(width: 20), height: AutoGetHeight(height: 20))
        deleteBtn.setImage(UIImage.init(named: "sc"), for: .normal)
        deleteBtn.addTarget(self, action: #selector(deleteClick(btn:)), for: .touchUpInside)
        deleteBtn.titleLabel?.font = kFontSize11
        return deleteBtn
    }()
    
    lazy var zanBtn: UIButton = {
        let zanBtn = UIButton.init(type: .custom)
        zanBtn.frame = CGRect.init(x: self.tz_width - AutoGetWidth(width: 45), y: AutoGetHeight(height: 8), width: AutoGetWidth(width: 40), height: AutoGetHeight(height: 25))
        zanBtn.setImage(UIImage.init(named: "CQWorkCircleZan"), for: .normal)
        zanBtn.addTarget(self, action: #selector(zanClick(btn:)), for: .touchUpInside)
        zanBtn.titleLabel?.font = kFontSize11
        return zanBtn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.setup()
        
    }
    
    func setup()  {
        addSubview(self.backGroundV)
        self.backGroundV.addSubview(self.img)
        self.backGroundV.addSubview(self.deleteBtn)
        self.backGroundV.addSubview(self.NameLabel)
        self.backGroundV.addSubview(self.zanBtn)
        self.img.center.y = self.backGroundV.height/2
        
        NameLabel.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(backGroundV.mas_left)?.setOffset(15)
            make?.right.mas_equalTo()(zanBtn.mas_left)?.setOffset(10)
            make?.bottom.mas_equalTo()(deleteBtn.mas_bottom)
        }
        
//        addSubview(self.img)
//        addSubview(self.zanBtn)
 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func zanClick(btn:UIButton)  {
        let cell = superUITableViewCell(of: btn)
        let table = superUITableView(of: btn)
        let index = table?.indexPath(for: cell!)
        DLog(index)
        
        if self.zanDelegate != nil{
            self.zanDelegate?.zanAction(index: index!)
        }
        
    }
    @objc func deleteClick(btn:UIButton)  {
        let cell = superUITableViewCell(of: btn)
        let table = superUITableView(of: btn)
        let index = table?.indexPath(for: cell!)
        DLog(index)
        
        if self.zanDelegate != nil{
            self.zanDelegate?.deleteAction(index: index!)
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
    
    //定义模型属性
    var model: CQSmileWallModel? {
        didSet {
            self.img.sd_setImage(with: URL(string: model?.imageUrl ?? "" ), placeholderImage:UIImage.init(named: "PersonNoticBg") )//moren
            
            if model!.laudStatus {
                zanBtn.setImage(UIImage.init(named: "CQWorkCircleZan"), for: .normal)
            }else{
                zanBtn.setImage(UIImage.init(named: "CQWorkCircleCancelZan"), for: .normal)
            }
            NameLabel.text = (model?.createUserRealName)!  + "\n" + (model?.createTime)!
            
            zanBtn.setTitle("  " + model!.laudNum, for: .normal)
            
            if model!.isAllowDelete == true{
                deleteBtn.isHidden = false
            }else{
                deleteBtn.isHidden = true
            }
            
        }
    }
    
    //定义模型属性
    var headModel: CQSmileWallModel? {
        didSet {
            
            if headModel?.imageUrl == ""{
                self.img.image = UIImage.init(named: "moren")
                self.zanBtn.isHidden = true
                self.NameLabel.isHidden = true
                self.deleteBtn.isHidden = true
            }else{
                self.img.sd_setImage(with: URL(string: headModel?.imageUrl ?? "" ), placeholderImage:UIImage.init(named: "moren") )
                
                if headModel!.laudStatus {
                    zanBtn.setImage(UIImage.init(named: "CQWorkCircleZan"), for: .normal)
                }else{
                    zanBtn.setImage(UIImage.init(named: "CQWorkCircleCancelZan"), for: .normal)
                }
                zanBtn.setTitle("  " + headModel!.laudNum, for: .normal)
                self.zanBtn.isHidden = false
                self.deleteBtn.isHidden = true
                self.NameLabel.isHidden = true
            }
            
        }
    }
}

//
//  WorkInstrumentCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/4/26.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit



class WorkInstrumentCell: UICollectionViewCell {
    
    
    lazy var deletbut : UIButton = {
        let deletbut = UIButton(frame:  CGRect(x: kHaveLeftWidth/4 - AutoGetWidth(width: 16), y: 0, width: AutoGetWidth(width: 16), height: AutoGetWidth(width: 16)))
        deletbut.setBackgroundImage(UIImage.init(named: "BCardDelete"), for: UIControlState.normal)
        deletbut.addTarget(self, action: #selector(deleteItem(sender:)), for: UIControlEvents.touchUpInside)
        //deletbut.isHidden = true
        return deletbut
    }()
    
    lazy var img: UIImageView = {
        let img = UIImageView.init(frame: CGRect.init(x: AutoGetWidth(width: 25), y: AutoGetWidth(width: 12), width: kHaveLeftWidth/4 - AutoGetWidth(width: 50), height: kHaveLeftWidth/4 - AutoGetWidth(width: 50)))
        img.image = UIImage.init(named: "xcxz")
        
        return img
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: 0, y: self.img.bottom + AutoGetHeight(height: 7), width: kHaveLeftWidth/4, height: AutoGetHeight(height: 11)))
        nameLab.textAlignment = .center
        nameLab.textColor = UIColor.black
        nameLab.text = ""
        nameLab.font = UIFont.systemFont(ofSize: 11)
        return nameLab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.setup()
    }
    
    func setup()  {
        addSubview(self.img)
        addSubview(self.nameLab)
      //  addSubview(self.deletbut)
        
//        img.mas_makeConstraints { (make) in
//            make?.left.mas_equalTo()(AutoGetWidth(width: 15))
//            make?.centerY.mas_equalTo()(self.contentView.mas_centerY)?.setOffset(-AutoGetWidth(width: 7))
//            make?.width.mas_equalTo()(AutoGetWidth(width: 36))
//            make?.height.mas_equalTo()(AutoGetWidth(width: 36))
//        }
//
//        line1.mas_makeConstraints { (make) in
//            make?.centerX.mas_equalTo()(self.img.mas_centerX)
//            make?.top.mas_equalTo()(self.contentView.mas_top)
//            make?.bottom.mas_equalTo()(self.img.mas_top)?.setOffset(-6)
//            make?.width.mas_equalTo()(1)
//            make?.height.mas_greaterThanOrEqualTo()(AutoGetWidth(width: 30))
//        }
//        line2.mas_makeConstraints { (make) in
//            make?.centerX.mas_equalTo()(self.img.mas_centerX)
//            make?.top.mas_equalTo()(self.nameLab.mas_bottom)?.setOffset(6)
//            make?.bottom.mas_equalTo()(self.contentView.mas_bottom)
//            make?.width.mas_equalTo()(1)
//            make?.height.mas_greaterThanOrEqualTo()(AutoGetWidth(width: 30))
//        }
        
        
//        deletbut.mas_makeConstraints { (make) in
//            make?.right.mas_equalTo()(self.contentView.mas_right)?.setOffset(-5)
//            make?.top.mas_equalTo()(self.contentView.mas_top)?.setOffset(5)
//            make?.width.mas_equalTo()(self.contentView.width/4)
//            make?.height.mas_equalTo()(self.contentView.height/4)
//        }
//        img.mas_makeConstraints { (make) in
//            make?.centerX.mas_equalTo()(self.contentView.mas_centerX)
//            make?.centerY.mas_equalTo()(self.contentView.mas_centerY)
//            make?.width.mas_equalTo()(self.contentView.width/2)
//            make?.height.mas_equalTo()(self.contentView.height/2)
//        }
//
//        nameLab.mas_makeConstraints { (make) in
//            make?.centerX.mas_equalTo()(self.contentView.mas_centerX)
//            make?.top.mas_equalTo()(self.img.mas_bottom)?.setOffset(5)
//            make?.width.mas_equalTo()(self.contentView.height/2)
//            make?.height.mas_equalTo()(AutoGetWidth(width: 15))
//        }
    }
    
    
    @objc func deleteItem(sender:UIButton){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

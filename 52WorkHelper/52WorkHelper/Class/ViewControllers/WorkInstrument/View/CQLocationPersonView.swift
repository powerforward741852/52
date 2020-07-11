//
//  CQLocationPersonView.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/9/27.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit
protocol locationVClickDelegate :NSObjectProtocol {
    func viewClick(v:CQLocationPersonView)
}
class CQLocationPersonView: UIView {

    var model:CQDepartMentAttenceModel?
    weak var personVDelegate:locationVClickDelegate?
    
    lazy var statusLab: UILabel = {
        let statusLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 20), width: AutoGetWidth(width: 10), height: AutoGetWidth(width: 10)))
        statusLab.backgroundColor = kLyGrayColor
        statusLab.layer.cornerRadius = 5
        statusLab.clipsToBounds = true
        return statusLab
    }()
    
    lazy var iconImage: UIImageView = {
        let iconImage = UIImageView.init(frame: CGRect.init(x:self.statusLab.right + AutoGetWidth(width: 7), y: AutoGetHeight(height: 9), width: AutoGetWidth(width: 32), height: AutoGetWidth(width: 32)))
        iconImage.image = UIImage.init(named: "personDefaultIcon")
        iconImage.layer.cornerRadius = AutoGetWidth(width: 16)
        iconImage.clipsToBounds = true
        return iconImage
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: self.iconImage.right + AutoGetWidth(width: 7), y: AutoGetHeight(height: 9), width: AutoGetWidth(width: 200), height: AutoGetHeight(height: 15)))
        nameLab.font = kFontSize15
        nameLab.text = ""
        nameLab.textAlignment = .left
        nameLab.textColor = UIColor.black
        return nameLab
    }()
    
    lazy var positionLab: UILabel = {
        let positionLab = UILabel.init(frame: CGRect.init(x: self.iconImage.right + AutoGetWidth(width: 7), y:self.nameLab.bottom + AutoGetHeight(height: 8), width: AutoGetWidth(width: 200), height: AutoGetHeight(height: 13)))
        positionLab.font = kFontSize13
        positionLab.text = ""
        positionLab.textAlignment = .left
        positionLab.textColor = kLyGrayColor
        
        return positionLab
    }()
    
    lazy var btn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 0, y: 0, width: self.tz_width, height: self.tz_height)
        btn.addTarget(self, action: #selector(footClick), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.white
        self.addSubview(self.statusLab)
        self.addSubview(self.iconImage)
        self.addSubview(self.nameLab)
        self.addSubview(self.positionLab)
        self.addSubview(self.btn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    @objc func footClick()  {
        if self.personVDelegate != nil{
            self.personVDelegate?.viewClick(v: self)
        }
    }
}

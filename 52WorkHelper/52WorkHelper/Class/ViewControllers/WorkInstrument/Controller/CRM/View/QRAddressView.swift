//
//  QRAddressView.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/10/12.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRAddressView: UIView {

    lazy var mapImg : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named:"dd")
        return img
    }()
    lazy var address : UILabel = {
        let lab = UILabel(title: "思美达科技", textColor: UIColor.black, fontSize: 14)
        return lab
    }()

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        setupUi()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUi()  {
        self.addSubview(address)
        self.addSubview(mapImg)
        mapImg.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(self)?.setOffset(kLeftDis)
            make?.top.mas_equalTo()(self)?.setOffset(AutoGetHeight(height: 5))
            make?.width.mas_equalTo()(AutoGetHeight(height: 15))
            make?.height.mas_equalTo()(AutoGetHeight(height: 15))
        }
        
        address.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(mapImg.mas_right)?.setOffset(10)
            make?.centerY.mas_equalTo()(mapImg)
        }
    }
    
}

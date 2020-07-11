//
//  CQSearchBar.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/2.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQSearchBar: UITextField {
    var searchbut :UIButton?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kProjectDarkBgColor
        self.layer.cornerRadius = 5
        self.font = UIFont.systemFont(ofSize: 14)
        self.clearButtonMode = .always
        self.placeholder = ""
        
        let image = UIImageView.init()
        image.image = UIImage.init(named: "knowledgeSearch")
        image.contentMode = .center
//        self.leftView = image
//        self.leftViewMode = .always
        
        let but = UIButton(title: " 搜索", imgName: "knowledgeSearch", backgroundImage: "", titleColor: klightGreyColor, fontSize: 15, target: self, action: nil, event: UIControlEvents.touchUpInside)
        but.addTarget(self, action: #selector(hidBut), for: UIControlEvents.touchUpInside)
        but.setImage(UIImage.init(named: "knowledgeSearch"),
                     for: UIControlState.normal)
        but.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 2)
        self.searchbut = but
        self.addSubview(but)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.searchbut?.frame = CGRect(x: (self.frame.size.width - 60)/2, y: 2, width: 60, height: self.tz_height - 4)
    }
    
    @objc func hidBut(){
        searchbut?.isHidden = true
        self.becomeFirstResponder()
    }
}

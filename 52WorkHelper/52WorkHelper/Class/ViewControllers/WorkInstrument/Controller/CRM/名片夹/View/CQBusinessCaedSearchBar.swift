//
//  CQBusinessCaedSearchBar.swift
//  52WorkHelper
//
//  Created by chenqihang on 2019/1/17.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class CQBusinessCaedSearchBar: UITextField {

    var searchbut :UIButton?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kProjectDarkBgColor
        //            kAlpaRGB(r: 0.9451, g: 0.9451, b: 0.9451, a: 1)
        self.layer.cornerRadius = 5
        self.font = UIFont.systemFont(ofSize: 14)
        self.clearButtonMode = .always
        self.placeholder = ""
        
        let image = UIImageView.init()
        image.image = UIImage.init(named: "knowledgeSearch")
        image.contentMode = .center
        //        self.leftView = image
        //        self.leftViewMode = .always
        
        let but = UIButton(title: " 搜索姓名、拼音、电话", imgName: "knowledgeSearch", backgroundImage: "", titleColor: klightGreyColor, fontSize: 15, target: self, action: nil, event: UIControlEvents.touchUpInside)
        but.addTarget(self, action: #selector(hidBut), for: UIControlEvents.touchUpInside)
        but.setImage(UIImage.init(named: "knowledgeSearch"),
                     for: UIControlState.normal)
        
        self.searchbut = but
        self.addSubview(but)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // self.leftView?.frame = CGRect.init(x: 0, y: 0, width: 30, height: self.frame.size.height)
        self.searchbut?.frame = CGRect(x: (self.frame.size.width - 200)/2, y: 4, width: 200, height: self.tz_height - 8)
        
        //  searchbut?.tz_width = 60
    }
    
    @objc func hidBut(){
        searchbut?.isHidden = true
        self.becomeFirstResponder()
    }

}

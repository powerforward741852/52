//
//  CQPinView.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/9/27.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol viewClickDelegate : NSObjectProtocol {
    func clickAnnotionView(annot:MAAnnotation,view:CQPinView)
}

class CQPinView: MAAnnotationView {
    var button:UIButton?
    var bgImage:UIImageView?
    weak var clickDelegate:viewClickDelegate?
    var annot:MAAnnotation!
    var reuseIdenti:String!
    init(annotation: MAAnnotation!, reuseIdentifier: String!,name:String) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.bounds = CGRect(x: 0, y: 0, width: 62, height: 62)
        
        button = UIButton(frame: CGRect(x: 0, y: 0, width: 62, height: 22))
        button?.titleLabel?.textColor = UIColor.white
        button?.titleLabel?.lineBreakMode = .byWordWrapping
        button?.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button?.setTitleColor(kColorRGB(r: 33, g: 151, b: 216), for: .normal)
        button?.isUserInteractionEnabled = false
        let titleStr = annotation.title
        button?.setTitle(titleStr!, for: .normal)
        self.addSubview(button!)
        bgImage = UIImageView.init(frame: CGRect.init(x: 20, y: 24, width: 22, height: 36))
        bgImage?.image = UIImage.init(named: "red_location")
        self.addSubview(bgImage!)
        let str = annotation.title
        button?.setTitle(str!, for: .normal)
//        self.name = String.init(format: "%@", annotation.title!)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(viewClcik))
        self.addGestureRecognizer(tap)
        self.alpha = 0.85;
        self.annot = annotation
        self.reuseIdenti = reuseIdentifier
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func viewClcik()  {
        if self.clickDelegate != nil{
            self.clickDelegate?.clickAnnotionView(annot: self.annot,view:self)
        }
    }
}

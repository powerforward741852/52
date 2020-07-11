//
//  QRLocationView.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/12/18.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRLocationView: MAAnnotationView {
    
    var button:UIButton?
    var bgImage:UIImageView?
    var img:UIImageView?
    var lab:UILabel?
    
    var annot:MAAnnotation!
    var reuseIdenti:String!
    
    init(annotation: MAAnnotation!, reuseIdentifier: String!,name:String) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
       
        self.bounds = CGRect(x: 0, y: 0, width: 146, height: 43+30)
        
        button = UIButton(frame: CGRect(x: 123/2, y: 43, width: 23, height: 30))
        button?.setBackgroundImage(UIImage(named: "bz-拷贝"), for: UIControlState.normal)
        button?.isUserInteractionEnabled = false
        self.addSubview(button!)
       
        bgImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 146, height: 43))
        bgImage?.image = UIImage.init(named: "qb")
        self.addSubview(bgImage!)
        
        
        let gg = UIImageView.init(frame: CGRect.init(x: 10, y: 13, width: 12, height: 12))
        gg.image = UIImage.init(named: "gg")
        img = gg
        bgImage!.addSubview(gg)
        
        let xx = UILabel(title: "已进入考勤范围", textColor: UIColor.white, fontSize: 14, alignment: .center, numberOfLines: 1)
        xx.frame.origin = CGPoint(x: gg.right+5, y: 10)
        xx.sizeToFit()
        lab = xx
        bgImage!.addSubview(xx)
        if name=="yes"{
            gg.image = UIImage.init(named: "gg")
            xx.text = "已进入考勤范围"
        }else{
            gg.image = UIImage.init(named: "cccc")
            xx.text = "未进入考勤范围"
        }
        
        
//        let str = annotation.title
//        button?.setTitle(str!, for: .normal)
//        self.alpha = 0.85;
//        self.annot = annotation
//        self.reuseIdenti = reuseIdentifier
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    @objc func viewClcik()  {
//        if self.clickDelegate != nil{
//            self.clickDelegate?.clickAnnotionView(annot: self.annot,view:self)
//        }
//    }
}

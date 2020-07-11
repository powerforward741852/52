
//
//  QRScheduleHview.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/5/14.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class QRScheduleHview: UIView {
    
    //声明闭包
    typealias clickBtnClosure = (_ click : Bool ) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    @IBOutlet weak var bgButton: UIButton!
    
    @IBOutlet weak var textLab: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    @IBAction func touchClick(_ sender: Any) {
        //点击事件
        if clickClosure != nil{
            clickClosure!(true)
        }else{
            
        }
    }
}

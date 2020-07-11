//
//  QRXinshengSelectView.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/5/22.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class QRXinshengSelectView: UIView {

    @IBOutlet weak var firstBut: UIButton!
    
    @IBOutlet weak var secondBut: UIButton!
    @IBOutlet weak var firstLab: UILabel!
    
    @IBOutlet weak var secondLab: UILabel!
    
    var selectIndex: Int = 11
    @IBAction func buttonClick(_ sender: UIButton) {
        if sender.isSelected == false{
            sender.isSelected = true
        }else{
        }
        //取消另一个的选中
        for (_,value) in self.subviews.enumerated() {
            if value.isKind(of: UIButton.self){
                
                if  value == sender {
                    
                }else{
                    (value as! UIButton).isSelected = false
                }
            }
        }
        
        self.selectIndex = sender.tag
        
    }
    
    override func awakeFromNib() {
        firstBut.isSelected = true
    }
    
}

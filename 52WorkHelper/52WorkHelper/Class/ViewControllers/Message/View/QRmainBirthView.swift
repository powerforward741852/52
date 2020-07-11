//
//  QRmainBirthView.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2020/3/12.
//  Copyright © 2020 chenqihang. All rights reserved.
//

import UIKit

class QRmainBirthView: UIView {

    @IBOutlet weak var back: UIView!
    
    @IBOutlet weak var sendBut: UIButton!
    
    @IBAction func send(_ sender: Any) {
        self.removeFromSuperview()
    }
    
 
    @IBOutlet weak var animationView: UIView!
    
    
    @IBOutlet weak var animationH: NSLayoutConstraint!
    

    func addAnimation() {
        
       
        
        
        let  ani = CABasicAnimation(keyPath: "position")
        ani.fromValue = NSValue(cgPoint: CGPoint(x: kWidth/2, y: 100))
        ani.toValue = NSValue(cgPoint: CGPoint(x: kWidth/2, y: kHeight-250))
        ani.duration = 10
        ani.delegate = self
        ani.repeatCount = 1
        ani.isRemovedOnCompletion = false
        animationView.layer.add(ani, forKey: "singleLineAnimation")
    }
    func removeAnimation() {
        
    }

    override func awakeFromNib() {
        back.backgroundColor = UIColor.clear;
        self.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.7)
        
        addPic()
    }
    
    
    func addPic() {
        let img = UIImage(named: "birth1")
        let img1 = UIImage(named: "birth2")
        let img2 = UIImage(named: "birth3")
        let img3 = UIImage(named: "birth4")
        let img4 = UIImage(named: "birth5")
        let img5 = UIImage(named: "birth6")
        
        
        let flower =  FlowFlower.init(fLow: [img,img1,img2,img3,img4,img5])
          flower?.startFly(on: self)
        
        
//        UIView.animate(withDuration: 26, animations: {
//
//        }) { (too) in
//             flower?.endFly()
//        }
       
        
    }
    
}


extension QRmainBirthView:CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        
    }
}

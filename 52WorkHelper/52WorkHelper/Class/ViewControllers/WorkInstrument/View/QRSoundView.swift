//
//  QRSoundView.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/4/25.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class QRSoundView: UIView {
    
    @IBOutlet weak var playImg: UIImageView!
    
    @IBOutlet weak var timeCount: UILabel!
    
    var isPlay = false
     var playUrl = ""
    //声明闭包
    typealias clickBtnClosure = (_ play : Bool ) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    
    override func awakeFromNib() {
       self.playImg.isUserInteractionEnabled = true
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playSound))
        self.addGestureRecognizer(tapGesture)
        self.playImg.image = UIImage(named: "yuyin3")
        self.playImg.animationImages = ([UIImage(named: "yuyin1"),UIImage(named: "yuyin2"),UIImage(named: "yuyin3")] as! [UIImage])
        self.playImg.animationDuration = 1.2
        self.timeCount.text = ""
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeAnimation(noti:)), name: NSNotification.Name("soundAnimationST"), object: nil)
    }
    
    @objc func changeAnimation(noti:Notification){
        
        let dic = noti.userInfo! as NSDictionary
        let str =  dic.value(forKey: "urlPath") as! String
        print(playUrl)
        print(str)
         if str == playUrl{
            playImg.startAnimating()
            isPlay = true
         }else{
            playImg.stopAnimating()
            isPlay = false
        }
    }
    deinit {
        print("deinit")
        NotificationCenter.default.removeObserver(self)
    }
    @objc func playSound(){
        isPlay = !isPlay
        if isPlay {
         playImg.startAnimating()
        }else{
         playImg.stopAnimating()
        }
        
        if clickClosure != nil {
            clickClosure!(isPlay)
        }
        
    }
    
    
    
    
}

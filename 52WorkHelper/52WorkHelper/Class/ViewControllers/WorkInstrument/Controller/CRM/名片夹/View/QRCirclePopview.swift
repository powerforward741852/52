//
//  QRCirclePopview.swift
//  test1
//
//  Created by 秦榕 on 2019/1/8.
//  Copyright © 2019年 qq. All rights reserved.
//

import UIKit

class QRCirclePopview: UIView {
    var centerP: CGPoint?
    var butArr = [UIButton]()
    var titleArr = [String]()
    var imageArr = [String]()
    var counts = 3
    //声明闭包
    typealias clickBtnClosure = (_ select : Int) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func creatPopview(center:CGPoint,imgs:[String],titles:[String]) -> QRCirclePopview {
        let CirclePopview = QRCirclePopview(frame:  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        CirclePopview.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.8)
        CirclePopview.centerP = center
        CirclePopview.titleArr = titles
        CirclePopview.imageArr = imgs
        CirclePopview.counts = titles.count
        CirclePopview.setUpUi(center: center)
        return CirclePopview
    }
    
    
    func setUpUi(center:CGPoint){
        centerP = center
        let radius: CGFloat = 60
        for i in 0..<counts {
            let but = UIButton()
            but.setTitle(titleArr[i], for: UIControlState.normal)
            but.setImage(UIImage(named: imageArr[i]), for: UIControlState.normal)
            but.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            but.sizeToFit()
//
            but.titleEdgeInsets = UIEdgeInsetsMake(0, -(but.imageView?.frame.size.width)!-7, 0, (but.imageView?.frame.size.width)!+7)
            but.imageEdgeInsets = UIEdgeInsetsMake(0, (but.titleLabel?.frame.size.width)!, 0, -(but.titleLabel?.frame.size.width)!)
            but.setTitleColor(UIColor.colorWithHexString(hex: "#8d8d8d"), for: UIControlState.normal)
           // but.imageView?.frame.size = CGSize(width: 40, height: 40)
            
            but.tag = i
            but.addTarget(self, action: #selector(detailMune(sender:)), for: UIControlEvents.touchUpInside)
            
            //let angle =  CGFloat(M_PI) * CGFloat(i) / CGFloat(4-1) + CGFloat(M_PI)/2
            let angle =  -CGFloat(Double.pi) * CGFloat(i) / CGFloat(counts-1) - CGFloat(Double.pi)/2
            let x = radius*cos(angle)+center.x
            let y = radius*sin(angle)+center.y
            but.center = CGPoint(x: x, y: y)
            self.addSubview(but)
             //添加动画效果
            let basic = CABasicAnimation(keyPath: "position")
            basic.fromValue = center
            basic.toValue = CGPoint(x: x, y: y)
            basic.repeatCount = 1
            basic.duration = 0.15*Double(i)
            basic.isRemovedOnCompletion = true
            but.layer.add(basic, forKey: "basic")
            
            butArr.append(but)
        }

    }
    
    @objc func detailMune(sender:UIButton){
       // print(sender.tag)
        clickClosure!(sender.tag)
        self.dismissPopView()
    }
    
    func dismissPopView(){
//        for i in 0..<4 {
//            let but = self.butArr[i]
//            let basic = CABasicAnimation(keyPath: "position")
//            basic.toValue = CGPoint(x: (self.centerP?.x)!, y: (self.centerP?.y)!)
//            basic.repeatCount = 1
//            basic.isRemovedOnCompletion = true
//            basic.duration = 0.15*Double(i)
//            but.layer.add(basic, forKey: "basic")
//        }
        
        for i in 0..<counts{
            let but = self.butArr[counts - 1 - i]
            UIView.animate(withDuration: 0.13*Double(i), animations: {
                but.center = self.centerP!
            }) { (boo) in
                but.removeFromSuperview()
            }
        }
     
        DispatchQueue.main.asyncAfter(deadline: .now()+0.13*Double(counts)) {
             self.removeFromSuperview()
        }
    }
    
    func showPopView(){
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.addSubview(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismissPopView()
    }
}

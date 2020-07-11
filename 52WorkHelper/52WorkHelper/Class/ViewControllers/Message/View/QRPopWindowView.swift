//
//  QRPopWindowView.swift
//  test1
//
//  Created by 秦榕 on 2019/2/18.
//  Copyright © 2019年 qq. All rights reserved.
//

import UIKit

class QRPopWindowView: UIView {

    //声明闭包
    typealias clickBtnClosure = (_ dataStr : String) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    var dataStr : String?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func creatPopview() -> QRPopWindowView {
        let PopWindowView = QRPopWindowView(frame:  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        PopWindowView.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.7)
        PopWindowView.setUpUi()
        
        return PopWindowView
    }
    
    func setUpUi(){
        //背景
        let backGroundView = UIView(frame:  CGRect(x: 0, y: 0, width: AutoGetHeight(height: 280), height: AutoGetHeight(height: 300)))
        backGroundView.backgroundColor = UIColor.white
        backGroundView.center = CGPoint(x: kWidth/2, y: kHeight/2)
        self.addSubview(backGroundView)
        //关闭按钮
        let closeBtn = UIButton(frame:  CGRect(x: AutoGetHeight(height: 280-31), y: AutoGetHeight(height: 5), width: AutoGetHeight(height: 26), height: AutoGetHeight(height: 26)))
        closeBtn.setImage(UIImage(named: "guanbi"), for: UIControlState.normal)
        backGroundView.addSubview(closeBtn)
        closeBtn.addTarget(self, action: #selector(closeWindow), for: UIControlEvents.touchUpInside)
        //图片
        let img = UIImageView(frame:  CGRect(x: AutoGetHeight(height: 75)/2, y: AutoGetHeight(height: 31), width:AutoGetHeight(height: 205) , height: AutoGetHeight(height: 150)))
        img.image = UIImage(named: "tupi")
        backGroundView.addSubview(img)
        
        //zlab
        let lab = UILabel(title: "小主,您忘记打卡了哦!")
        lab.textColor  = UIColor.black
        lab.font = kFontSize16
        lab.frame = CGRect(x: 0, y: img.bottom, width: AutoGetWidth(width: 280), height: 31)
        lab.textAlignment = .center
        backGroundView.addSubview(lab)
        
        //补卡按钮
        let BKBtn = UIButton(frame:  CGRect(x: AutoGetHeight(height: 20), y: AutoGetHeight(height: 236), width: AutoGetHeight(height: 240), height: AutoGetHeight(height: 49)))
        BKBtn.setTitle("去补卡", for: UIControlState.normal)
        BKBtn.backgroundColor = kBlueC
        BKBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        BKBtn.layer.cornerRadius = 5
        BKBtn.clipsToBounds = true
        backGroundView.addSubview(BKBtn)
        BKBtn.addTarget(self, action: #selector(buKa), for: UIControlEvents.touchUpInside)
        
    }
    
    @objc func closeWindow(){
        self.dismissPopView()
        }
    
    @objc func buKa(){
        print("补卡")
        clickClosure!("B_BK")
    
    }
    
    func showPopView(){
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.addSubview(self)
    }
    
    func dismissPopView(){
         self.removeFromSuperview()
    }
}

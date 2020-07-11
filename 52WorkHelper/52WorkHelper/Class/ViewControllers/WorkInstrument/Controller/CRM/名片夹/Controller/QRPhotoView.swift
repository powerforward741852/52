//
//  QRPhotoView.swift
//  test1
//
//  Created by 秦榕 on 2019/1/10.
//  Copyright © 2019年 qq. All rights reserved.
//

import UIKit

class QRPhotoView: UIView {
    //声明闭包 tag(0重拍 1下一张 2完成 3拍反面 4 重拍反面 5取消 )
    typealias clickBtnClosure = (_ selectTag : Int) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    //是否反面
    var isRevert = false
    
    //单拍多拍类型  0==单拍  ,1==多拍
    var type : Int?
    //大图
    var centerImg = UIImageView()
    //底部三个vbut的背景
    var bottomView : UIView?
    //关闭
    var closeBut : UIButton?
    //下一张
    var myNextBut : UIButton?
    //反面
    var myRevertBut : UIButton?
    //重拍
    var myReTakeBut : UIButton?
    //完成
    var myDoneBut : UIButton?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func creatPhotoView() -> QRPhotoView {
        let PhotoView = QRPhotoView(frame:  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
       // PhotoView.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.7)
        PhotoView.backgroundColor = UIColor.black
        PhotoView.setUpUi()
        return PhotoView
    }
    func setUpUi(){
        
        //照片
        let img = UIImageView(frame: CGRect.init(x: 0, y: 0, width: kWidth , height: kHeight-SafeTabbarBottomHeight/3-AutoGetHeight(height: 128)))
        
       // img.backgroundColor = UIColor.blue
        self.centerImg = img
        let basic = CABasicAnimation(keyPath: "position")
        basic.fromValue = CGPoint(x:center.x , y: kHeight-200)
        basic.repeatCount = 1
        basic.duration = 0.25
        basic.isRemovedOnCompletion = true
        img.layer.add(basic, forKey: "basic")
        self.addSubview(img)
        //三个按钮的背景
        let colorBgV = UIView.init(frame: CGRect.init(x: 0, y: kHeight-SafeTabbarBottomHeight/3-AutoGetHeight(height: 128), width: kWidth, height: AutoGetHeight(height: 128)+SafeTabbarBottomHeight/3))
        colorBgV.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.7)
        self.addSubview(colorBgV)
        self.bottomView = colorBgV
        //重拍按钮
        let reTakeBut = UUButton(frame: CGRect(x:0, y: 0, width: 84, height: 64))
        reTakeBut.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        reTakeBut.contentAlignment = .centerImageTop
        reTakeBut.setTitle("重新拍照", for: .normal)
        reTakeBut.setImage(UIImage(named: "chongx"), for: UIControlState.normal)
        reTakeBut.tag = 0
        reTakeBut.setTitleColor(UIColor.white, for: .normal)
        reTakeBut.center.y = AutoGetHeight(height: 128)/2
        reTakeBut.center.x = kWidth/4
        colorBgV.addSubview(reTakeBut)
        reTakeBut.addTarget(self, action: #selector(removeBgView(sender:)), for: .touchUpInside)
        self.myReTakeBut = reTakeBut
        //下一张按钮
        let nextBtn = UIButton()
        nextBtn.tag = 1
        nextBtn.setTitle("下一张", for: .normal)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        nextBtn.setTitleColor(UIColor.white, for: .normal)
        nextBtn.setBackgroundImage(UIImage(named: "quer"), for: UIControlState.normal)
        nextBtn.frame = CGRect(x: kWidth/3, y: 0, width: 64, height: 64)
        nextBtn.center = CGPoint(x: kWidth/2, y: AutoGetHeight(height: 128)/2)
        colorBgV.addSubview(nextBtn)
        nextBtn.addTarget(self, action: #selector(removeBgView(sender:)), for: .touchUpInside)
        self.myNextBut = nextBtn
        //完成按钮
        let okBtn = UIButton()
        okBtn.tag = 2
        okBtn.setTitle("完成", for: .normal)
        okBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        okBtn.setTitleColor(UIColor.white, for: .normal)
        okBtn.frame = CGRect(x: kWidth/3*2, y: 0, width: kWidth/3, height: 44)
        okBtn.center = CGPoint(x: kWidth/4*3, y: AutoGetHeight(height: 128)/2)
        colorBgV.addSubview(okBtn)
        okBtn.addTarget(self, action: #selector(removeBgView(sender:)), for: .touchUpInside)
        self.myDoneBut = okBtn
        //拍反面按钮
        let revertBtn = UIButton()
        revertBtn.tag = 3
       // revertBtn.setTitle("拍反面", for: .normal)
        revertBtn.setBackgroundImage(UIImage(named: "annn"), for: UIControlState.normal)
        revertBtn.setTitleColor(UIColor.white, for: .normal)
        revertBtn.frame = CGRect(x: kWidth-85, y: 10, width: 85, height: 30)
        revertBtn.sizeToFit()
        colorBgV.addSubview(revertBtn)
        revertBtn.addTarget(self, action: #selector(removeBgView(sender:)), for: .touchUpInside)
        self.myRevertBut = revertBtn
        //关闭按钮
        let closeBtn = UIButton()
        closeBtn.setTitle("取消", for: .normal)
        closeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        closeBtn.setTitleColor(UIColor.white, for: .normal)
        closeBtn.frame = CGRect(x: AutoGetWidth(width: 15), y: SafeAreaStateTopHeight+10, width: 40, height: 30)
        closeBtn.tag = 5
        closeBtn.sizeToFit()
        self.addSubview(closeBtn)
        self.closeBut = closeBtn
        closeBtn.addTarget(self, action: #selector(removeBgView(sender:)), for: .touchUpInside)
        
        ///照片位置
        if SafeAreaStateTopHeight == 44{
            img.frame = CGRect(x: AutoGetHeight(height: 40), y: closeBtn.bottom+45, width: kWidth-AutoGetHeight(height: 80), height: (kWidth-AutoGetHeight(height: 80))*1.5)
        }else{
            img.frame = CGRect(x: AutoGetHeight(height: 50), y: closeBtn.bottom+15, width: kWidth-AutoGetHeight(height: 100), height: (kWidth-AutoGetHeight(height: 100))*1.5)
        }
//        //框框
//        let kkView = CALayer.init()
//        //        kkView.frame = CGRect(x: AutoGetHeight(height: 40), y: backBtn.bottom+30, width: kWidth-AutoGetHeight(height: 80), height: kHeight-SafeTabbarBottomHeight-AutoGetHeight(height: 128)-SafeAreaStateTopHeight-80-30)
//        if SafeAreaStateTopHeight == 44{
//            kkView.frame = CGRect(x: AutoGetHeight(height: 40+25), y: closeBtn.bottom+45, width: kWidth-AutoGetHeight(height: 80+50), height: (kWidth-AutoGetHeight(height: 80))*1.5)
//        }else{
//            kkView.frame = CGRect(x: AutoGetHeight(height: 50+25), y: closeBtn.bottom+15, width: kWidth-AutoGetHeight(height: 100+50), height: (kWidth-AutoGetHeight(height: 100))*1.5)
//        }
//
//
//        kkView.contents = UIImage(named: "anquank")?.cgImage
//        self.layer.addSublayer(kkView)
      
    }
    
    
    
    //按钮判断
    @objc func removeBgView(sender: UIButton) {
        self.clickClosure!(sender.tag)
       
    }
    
    @objc func sureClick(btn:UIButton) {
        self.dismissPotoview()
    }
    func showPotoview(){
        if type == 0{
            //closeBut?.isHidden = true
            myRevertBut?.isHidden = true
            myDoneBut?.isHidden = true
            myNextBut?.setTitle("确认", for: UIControlState.normal)
        }else{
          //  closeBut?.isHidden = true
            myRevertBut?.isHidden = self.isRevert
            if self.isRevert == true{
                myReTakeBut?.tag = 4
                myReTakeBut!.setTitle("重拍反面", for: .normal)
            }else{
               // myReTakeBut?.tag = 4
            }
        }
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.addSubview(self)
//        let basic = CABasicAnimation(keyPath: "position")
//        basic.fromValue = center
//        basic.toValue = CGPoint(x: x, y: y)
//        basic.repeatCount = 1
//        basic.duration = 0.15*Double(i)
//        basic.isRemovedOnCompletion = true
//        self.layer.add(basic, forKey: "basic")
    }
    
    func dismissPotoview(){
        self.removeFromSuperview()
    }
}

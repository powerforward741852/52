//
//  STCountDownButton.swift
//  SwiftBaiSi
//
//  Created by 浮生若梦 on 2016/12/21.
//  Copyright © 2016年 Mystery. All rights reserved.
//

import UIKit


//声明一个闭包类型 countDownChanging
typealias countDownChanging = (STCountDownButton,Int)->(String)
// countDownFinished
typealias countDownFinished = (STCountDownButton,Int)->(String)
// touchedCountDownButtonHandler
typealias touchedCountDownButtonHandler = (STCountDownButton,Int)->(Void)



class STCountDownButton: UIButton {
    
    var second: Int = 0
    var totalSecond: Int = 0
    
    var time: Timer? = nil
    var startDate: NSDate? = nil
    
    var changing: countDownChanging? = nil
    var finished: countDownFinished? = nil
    var handler: touchedCountDownButtonHandler? = nil
    
    
    //倒计时按钮点击回调
    func countDownButtonHandler(touchedCountDownButtonHandler: @escaping touchedCountDownButtonHandler) {
        handler = touchedCountDownButtonHandler
        self.addTarget(self, action: #selector(touched), for: .touchUpInside)
    }
    
    @objc func touched(sender: STCountDownButton) {
        if (handler != nil) {
            handler!(sender,sender.tag)
        }
    }
    
    //倒计时时间改变回调
    func countDownChanging(countChanging: countDownChanging) {
        
    }
    //倒计时结束回调
    func countDownFinished(countFinish: countDownFinished) {
        
    }
    //开始倒计时
    func starCountDownWithSeconf(secondCount: Int) {
        totalSecond = secondCount
        second = secondCount
        
        time = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerStart), userInfo: nil, repeats: true)
        startDate = NSDate()
        RunLoop.current.add(time!, forMode: .commonModes)
    }
    
    @objc func timerStart(theTimer: Timer) {
        let deltaTime = NSDate().timeIntervalSince(startDate! as Date)
        
        second = totalSecond - Int((deltaTime + 0.5))
    
        if second < 0 {
            stopCountDown()
        }else {
            if changing != nil {
                self.setTitle(changing!(self,second), for: .normal)
                self.setTitle(changing!(self,second), for: .disabled)
            }else {
                let title = "\(second)秒"
                self.setTitle(title, for: .normal)
                self.setTitle(title, for: .disabled)
            }
        }
    }
    
    //停止倒计时
    func stopCountDown() {
        if (time != nil) {
            if (time?.responds(to: #selector(getter: Port.isValid)))! {
                if (time?.isValid)! {
                    time?.invalidate()
                    second = totalSecond
                    if (finished != nil) {
                        self.setTitle(finished!(self,totalSecond), for: .normal)
                        self.setTitle(finished!(self,totalSecond), for: .disabled)
                    }else {
                        self.setTitle("重新获取", for: .normal)
                        self.setTitle("重新获取", for: .disabled)
                    }
                }
            }
        }
    }
    
    func countChanging(countChange: @escaping countDownChanging) {
        changing = countChange
    }
    
    func countFinish(countFinish: @escaping countDownFinished) {
        finished = countFinish
    }
    

}

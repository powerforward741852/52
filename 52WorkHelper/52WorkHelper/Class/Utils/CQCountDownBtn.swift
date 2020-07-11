//
//  CQCountDownBtn.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/13.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

//声明一个闭包类型 countDownChanging
typealias countDownChange = (CQCountDownBtn,Int)->(String)
// countDownFinished
typealias countDownFinish = (CQCountDownBtn,Int)->(String)
// touchedCountDownButtonHandler
typealias touchedCountDownButtonHandle = (CQCountDownBtn,Int)->(Void)

class CQCountDownBtn: UIButton {

    var second: Int = 0
    var totalSecond: Int = 0
    
    var time: Timer? = nil
    var startDate: NSDate? = nil
    
    var changing: countDownChange? = nil
    var finished: countDownFinish? = nil
    var handler: touchedCountDownButtonHandle? = nil
    
    
    //倒计时按钮点击回调
    func countDownButtonHandler(touchedCountDownButtonHandle: @escaping touchedCountDownButtonHandle) {
        handler = touchedCountDownButtonHandle
        self.addTarget(self, action: #selector(touched), for: .touchUpInside)
    }
    
    @objc func touched(sender: CQCountDownBtn) {
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
    
    func countChanging(countChange: @escaping countDownChange) {
        changing = countChange
    }
    
    func countFinish(countFinish: @escaping countDownFinish) {
        finished = countFinish
    }
    

}

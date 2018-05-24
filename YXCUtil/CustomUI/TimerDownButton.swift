//
//  TimerDownButton.swift
//  KFHome
//
//  Created by Sansan on 2017/3/15.
//  Copyright © 2017年 Sansan. All rights reserved.
//

import Foundation
import UIKit

func TimerDownButton(second:Int, button:UIButton) {
    
    if second > 0 {
        var timeout:Int = second
        let backgroundColor = button.backgroundColor!
        let titleColor = button.titleLabel?.textColor
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.red, for: .normal)
        button.isUserInteractionEnabled = false

        let timer:DispatchSource = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global()) as! DispatchSource
        timer.setEventHandler {
            // 进行倒计时
            if (timeout <= 0) {
                DispatchQueue.main.async(execute: {
                    button.setTitle("获取验证码", for: .normal)
                    button.isUserInteractionEnabled = true
                    button.backgroundColor = backgroundColor
                    button.setTitleColor(titleColor, for: .normal)
                })
                timer.cancel()
                
            } else {
                let btnTitle:String = "\(timeout)s"
                DispatchQueue.main.async(execute: {
                    button.setTitle(btnTitle, for: .normal)
                })
                timeout = timeout - 1
            }
        }
        
        timer.schedule(deadline: .now(), repeating: .seconds(1))
        timer.resume()
    }
}

//
//  UIView+frame.swift
//  KFHome
//
//  Created by Sansan on 2017/3/23.
//  Copyright © 2017年 Sansan. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    // MARK: - 获取
    public var kfhX:CGFloat {
        return frame.origin.x
    }
    
    public var kfhY:CGFloat {
        return frame.origin.y
    }
    
    public var kfhWidth:CGFloat {
        return frame.size.width
    }
    
    public var kfhheight:CGFloat {
        return frame.size.height
    }
    
    public var kfhCenterX:CGFloat {
        return center.x
    }
    
    public var kfhCenterY:CGFloat {
        return center.y
    }
    
    
    // MARK: - 赋值
    func setX(X:CGFloat) {
        let oldRect = frame
        let newRect = CGRect(x: X, y: oldRect.origin.y, width: oldRect.width, height: oldRect.height)
        frame = newRect
    }
    
    func setY(Y:CGFloat) {
        let oldRect = frame
        let newRect = CGRect(x: oldRect.origin.x, y: Y, width: oldRect.width, height: oldRect.height)
        frame = newRect
    }
    
    func setWidth(W:CGFloat) {
        let oldRect = frame
        let newRect = CGRect(x: oldRect.origin.x, y: oldRect.origin.y, width: W,height:oldRect.height)
        frame = newRect
    }
    
    func setHeight(H:CGFloat) {
        let oldRect = frame
        let newRect = CGRect(x: oldRect.origin.x, y: oldRect.origin.y, width: oldRect.width, height: H)
        frame = newRect
    }

}

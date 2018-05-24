//
//  UIView+KFHView.swift
//  KFHome
//
//  Created by Sansan on 2017/2/24.
//  Copyright © 2017年 Sansan. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    
    var corners: Int {
        get {
            return 1
        }
        set {
            // 输入一个整数，位数为四位，对应 左上，右上，右下，左下。1代表圆角，非1代表非圆角，例如1212：左上右下为圆角，
            let leftTop:Int = newValue/1000
            let rightTop:Int = (newValue%1000)/100
            let rightBottom:Int = (newValue%100)/10
            let leftBottom:Int = newValue%10
            var cornerRect:UIRectCorner = []
            if leftTop == 1 {
                cornerRect.insert(.topLeft)
            }
            if rightTop == 1 {
                cornerRect.insert(.topRight)
            }
            if leftBottom == 1 {
                cornerRect.insert(.bottomLeft)
            }
            if rightBottom == 1 {
                cornerRect.insert(.bottomRight)
            }
            self.drawRoundingCorners(corners: cornerRect, cornerRadii: CGSize.init(width: 10, height: 10))
        }
    }
    
    func drawRoundingCorners(corners:UIRectCorner,cornerRadii:CGSize) {
        let maskPath:UIBezierPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
        let maskLayer:CAShapeLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    func controller() -> UIViewController? {
        
        var next:UIView? = self.superview
        while (next != nil) {
            let nextResponder:UIResponder = next!.next!
            if nextResponder.isKind(of: UIViewController.self) {
                return nextResponder as? UIViewController
            }
            next = next?.superview!
        }
        return nil
    }
    func removeAllSubView() {
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
    }
    
    //初始化gradientLayer并设置相关属性
    func createGradientLayer(startPoint:CGPoint, endPoint:CGPoint) {
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        //设置渐变的主颜色
        gradientLayer.colors = [UIColor.init(white: 0.0, alpha: 0.6).cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        //将gradientLayer作为子layer添加到主layer上
        self.layer.addSublayer(gradientLayer)
    }
    func addGradient(colors:[CGColor], frame:CGRect, radius:CGFloat) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = radius
        gradientLayer.frame = frame
        gradientLayer.colors = colors
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    func addRightBorderARC() {
        let finalSize = self.frame.size
        let layerWidth = finalSize.width * 0.16
        let layer = CAShapeLayer()
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint.init(x: finalSize.width - layerWidth, y: 0))
        bezier.addLine(to: CGPoint.init(x: 0, y: 0))
        bezier.addLine(to: CGPoint.init(x: 0, y: finalSize.height))
        bezier.addLine(to: CGPoint.init(x: finalSize.width - layerWidth, y: finalSize.height))
        bezier.addQuadCurve(to: CGPoint.init(x: finalSize.width - layerWidth, y: 0), controlPoint: CGPoint.init(x: finalSize.width + layerWidth, y: finalSize.height/2.0))
        layer.path = bezier.cgPath
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        //设置渐变的主颜色
        gradientLayer.colors = [Colors.customColor.cgColor, Colors.placeholderColor.cgColor]
        gradientLayer.locations = [NSNumber.init(value: 0.0), NSNumber.init(value: 0.7)]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 0.28, y: 1)
        
        gradientLayer.mask = layer
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    func addBottomBorderARC() {
        let finalSize = self.frame.size
        let layerHeight:CGFloat = 10.0
        let layer = CAShapeLayer()
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint.init(x: 0, y: finalSize.height - layerHeight))
        bezier.addLine(to: CGPoint.init(x: 0, y: 0))
        bezier.addLine(to: CGPoint.init(x: finalSize.width, y: 0))
        bezier.addLine(to: CGPoint.init(x: finalSize.width, y: finalSize.height - layerHeight))
        bezier.addQuadCurve(to: CGPoint.init(x: 0, y: finalSize.height - layerHeight), controlPoint: CGPoint.init(x: finalSize.width/2.0, y: finalSize.height + layerHeight))
        layer.path = bezier.cgPath
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        //设置渐变的主颜色
        gradientLayer.colors = [Colors.customColor.cgColor, Colors.placeholderColor.cgColor]
        gradientLayer.locations = [NSNumber.init(value: 0.0), NSNumber.init(value: 0.7)]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 0.28, y: 1)
        
        gradientLayer.mask = layer
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    func addCommonShadow(subFrame:CGRect, radius:CGFloat) {
        
        let shadowLayer:CALayer = CALayer.init()
        shadowLayer.frame = subFrame
        shadowLayer.backgroundColor = UIColor.init(white: 1.0, alpha: 0.1).cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowRadius = radius
        shadowLayer.shadowOpacity = 1.0
        shadowLayer.shadowOffset = CGSize.init(width: 1, height: 2)
        self.superview?.layer.insertSublayer(shadowLayer, below: self.layer)
    }
    func addHeartRateShadow(subFrame:CGRect, radius:CGFloat) {
        
        let shadowLayer:CALayer = CALayer.init()
        shadowLayer.frame = subFrame
        shadowLayer.cornerRadius = radius
        shadowLayer.masksToBounds = false
        shadowLayer.backgroundColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowRadius = 3
        shadowLayer.shadowOpacity = 1.0
        shadowLayer.shadowOffset = CGSize.init(width: 1, height: 2)
        self.superview?.layer.insertSublayer(shadowLayer, below: self.layer)
    }
}

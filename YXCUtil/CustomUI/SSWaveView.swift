//
//  SSWaveView.swift
//  HealthMark
//
//  Created by Sansan on 2017/10/24.
//  Copyright © 2017年 dayigufen. All rights reserved.
//

import UIKit

protocol SSWaveViewDelegate {
    func drawBgGradient(waveView:SSWaveView, context:CGContext)
}

class SSWaveView: UIView {

    var waveDisplaylink:CADisplayLink?
    var firstWaveLayer:CAShapeLayer?    //里层
    var secondWaveLayer:CAShapeLayer?   //外层
    
    var gradientLayer:CAGradientLayer?   // 绘制渐变1
    var sGradientLayer:CAGradientLayer?  // 绘制渐变2
    
    var percent:CGFloat = 0.0 {
        didSet {
            currentWavePointY = self.frame.size.height*percent
            if percent>0 && percent<1 {
                kExtraHeight = 10.0
            }
        }
    }
    var waveAmplitude:CGFloat = 0.0
    var waveCycle:CGFloat!
    var waveSpeed:CGFloat = CGFloat(0.2*Double.pi)
    var waveGrowth:CGFloat = 1.0
    var isRound:Bool = true
    
    var colors:[CGColor] = [CGColor]()
    var sColors:[CGColor] = [CGColor]()
    
    var waterWaveWidth:CGFloat!             // 宽度
    var offsetX:CGFloat = 0                 // 波浪x位移
    var currentWavePointY:CGFloat = 0.0     // 当前波浪上升高度Y
    
    var kExtraHeight:CGFloat = 0            // 保证水波波峰不被裁剪，增加部分额外的高度
    var variable:CGFloat = 1.6              // 可变参数 更加真实 模拟波纹
    var increase:Bool = false               // 增减变化
    
    var delegate:SSWaveViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
        self.initial()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initial() {
        self.percent = 0
        self.waveAmplitude = 0
        self.waveGrowth = 1.0
        self.waveSpeed = CGFloat(0.1/Double.pi)
        waterWaveWidth  = self.frame.size.width
        if (waterWaveWidth > 0) {
            self.waveCycle = CGFloat(1.5 * Double.pi) / waterWaveWidth
        }
    }
    func resetProperty() {
        currentWavePointY = self.frame.size.height * self.percent
        
        offsetX = 0
        variable = 1.6
        increase = false
        
        kExtraHeight = 0
        if (percent>0 && percent<1) {
            kExtraHeight = 10.0
        }
    }
    
    func startWave() {
        if (firstWaveLayer == nil) {
            // 创建第一个波浪Layer
            firstWaveLayer = CAShapeLayer()
        }
        if (secondWaveLayer == nil) {
            // 创建第二个波浪Layer
            secondWaveLayer = CAShapeLayer()
        }
        // 添加渐变layer
        if (self.gradientLayer != nil) {
            self.gradientLayer?.removeFromSuperlayer()
            self.gradientLayer = nil
        }
        
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer?.frame = self.gradientLayerFrame()
        self.gradientLayer?.mask = firstWaveLayer
        self.layer.addSublayer(self.gradientLayer!)
        
        if (self.sGradientLayer != nil) {
            self.sGradientLayer?.removeFromSuperlayer()
            self.sGradientLayer = nil
        }
        
        self.sGradientLayer = CAGradientLayer()
        self.sGradientLayer?.frame = self.gradientLayerFrame()
        self.sGradientLayer?.mask = secondWaveLayer
        self.layer.addSublayer(self.sGradientLayer!)
        
        //设置渐变layer相关属性
        self.setupGradientColor()
        
        if (waveDisplaylink != nil) {
            self.stopWave()
        }
        // 启动定时调用
        waveDisplaylink = CADisplayLink.init(target: self, selector: #selector(SSWaveView.getCurrentWave(displayLink:)))
        waveDisplaylink?.add(to: RunLoop.current, forMode: .commonModes)
    }
    func gradientLayerFrame() -> CGRect {
        // gradientLayer在上升完成之后的frame值，如果gradientLayer在上升过程中不断变化frame值会导致一开始绘制卡顿，所以只进行一次赋值
        
        var gradientLayerHeight:CGFloat = self.frame.size.height * self.percent + kExtraHeight
        
        if (gradientLayerHeight > self.frame.size.height)
        {
            gradientLayerHeight = self.frame.size.height
        }
        
        let frame:CGRect = CGRect.init(x: 0, y: self.frame.size.height-gradientLayerHeight, width: self.frame.size.width, height: gradientLayerHeight)
        
        return frame
    }
    func setupGradientColor() {
    // gradientLayer设置渐变色
        if (self.colors.count < 1) {
            self.colors = self.defaultColors()
        }
        if (self.sColors.count < 1){
            self.sColors = self.defaultColors()
        }
        
        self.gradientLayer?.colors = self.colors
        self.sGradientLayer?.colors = self.sColors
    
        //设定颜色分割点
        let count:Int = self.colors.count
        let d:Float = 1.0 / Float(count)
    
        var locations:[NSNumber] = [NSNumber]()
        for i in 0..<count {
            let res:Float = d+d*Float(i)
            let num:NSNumber = NSNumber.init(value: res)
            locations.append(num)
        }
        let lastNum:NSNumber = NSNumber.init(value: 1.0)
        locations.append(lastNum)
        
        self.gradientLayer?.locations = locations
        self.sGradientLayer?.locations = locations
        
        // 设置渐变方向，从上往下
        self.gradientLayer?.startPoint = CGPoint.init(x: 0, y: 0)
        self.gradientLayer?.endPoint = CGPoint.init(x: 0, y: 1)
        
        self.sGradientLayer?.startPoint = CGPoint.init(x: 0, y: 0)
        self.sGradientLayer?.endPoint = CGPoint.init(x: 0, y: 1)
    }
    @objc func getCurrentWave(displayLink:CADisplayLink) {
        
        self.animateWave()
        
        if (!self.waveFinished()) {
            currentWavePointY = currentWavePointY - self.waveGrowth
        }
        // 波浪位移
        offsetX += self.waveSpeed
        
        self.setCurrentFirstWaveLayerPath()
        self.setCurrentSecondWaveLayerPath()
    }
    func setCurrentFirstWaveLayerPath() {
    
        let path:CGMutablePath = CGMutablePath()
        var y:CGFloat = currentWavePointY
        path.move(to: CGPoint.init(x: 0, y: y))
        for x in 0...Int(waterWaveWidth) {
            // 正弦波浪公式
            y = self.waveAmplitude * sin(self.waveCycle * CGFloat(x) + offsetX) + currentWavePointY
            path.addLine(to: CGPoint.init(x: CGFloat(x), y: y))
        }
        path.addLine(to: CGPoint.init(x: waterWaveWidth, y: self.frame.size.height))
        path.addLine(to: CGPoint.init(x: 0, y: self.frame.size.height))
        path.closeSubpath()
        
        firstWaveLayer?.path = path
        
    }
    
    func setCurrentSecondWaveLayerPath() {
        
        let path:CGMutablePath = CGMutablePath()
        var y:CGFloat = currentWavePointY
        path.move(to: CGPoint.init(x: 0, y: y))
        for x in 0...Int(waterWaveWidth) {
            // 余弦波浪公式
            y = self.waveAmplitude * cos(self.waveCycle * CGFloat(x) + offsetX) + currentWavePointY
            path.addLine(to: CGPoint.init(x: CGFloat(x), y: y))
        }
        
        path.addLine(to: CGPoint.init(x: waterWaveWidth, y: self.frame.size.height))
        path.addLine(to: CGPoint.init(x: 0, y: self.frame.size.height))
        path.closeSubpath()
        
        secondWaveLayer?.path = path
    }
    func animateWave() {
        if (increase) {
            variable += 0.01
        }else{
            variable -= 0.01
        }
        
        if (variable<=1) {
            increase = true
        }
        
        if (variable>=1.6) {
            increase = false
        }
        
        // 可变振幅
        self.waveAmplitude = variable*5.0
    }
    func waveFinished() -> Bool{
        // 波浪上升动画是否完成
        let d:CGFloat = self.frame.size.height - self.gradientLayer!.frame.size.height
        let extraH:CGFloat = min(d, kExtraHeight)
        let bFinished:Bool = currentWavePointY <= extraH
        
        return bFinished
    }
    func defaultColors() -> [CGColor]{
    // 默认的渐变色
        let color0:UIColor = Colors.mainGreen
        let color1:UIColor = Colors.mainGreenColor
        let colors:[CGColor] = [color0.cgColor, color1.cgColor]
        
        return colors
    }
    func stopWave() {
        waveDisplaylink?.invalidate()
        waveDisplaylink = nil
    }
    func reset() {
        self.stopWave()
        self.resetProperty()
        
        firstWaveLayer?.removeFromSuperlayer()
        firstWaveLayer = nil
        secondWaveLayer?.removeFromSuperlayer()
        secondWaveLayer = nil
        
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
        sGradientLayer?.removeFromSuperlayer()
        sGradientLayer = nil
    }
    deinit {
        self.reset()
    }
}

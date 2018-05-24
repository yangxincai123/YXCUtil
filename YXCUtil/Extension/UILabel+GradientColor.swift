//
//  UILabel+GradientColor.swift
//  HealthMark
//
//  Created by Sansan on 2017/11/8.
//  Copyright © 2017年 dayigufen. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func setTextGradientColors(colors:[UIColor]) {
        if colors.count > 0 {
            if colors.count == 1 {
                self.textColor = colors.first
            } else {
                let gradientLayer:CAGradientLayer = CAGradientLayer()
                gradientLayer.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height + 3)
                var cgColors:[CGColor] = [CGColor]()
                for item in colors {
                    cgColors.append(item.cgColor)
                }
                gradientLayer.colors = cgColors
                let gradientImage:UIImage = self.imageFromLayer(layer: gradientLayer)
                self.textColor = UIColor.init(patternImage: gradientImage)
            }
        }
    }
    func imageFromLayer(layer:CALayer) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.isOpaque, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return outputImage
    }
}

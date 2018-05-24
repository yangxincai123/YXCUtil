//
//  UILabel+ContentHeight.swift
//  KFHome
//
//  Created by Sansan on 2017/4/8.
//  Copyright © 2017年 Sansan. All rights reserved.
//

import Foundation
import CoreText
import UIKit

extension UILabel {
    //label高度自适应//
    func autoLabelHeight() -> CGFloat {
        let size = CGSize(width:self.frame.width,height: CGFloat(MAXFLOAT))
        let paragraph:NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        paragraph.lineSpacing = 5.0
        let dic = [NSAttributedStringKey.font.rawValue:self.font,NSAttributedStringKey.paragraphStyle:paragraph] as [AnyHashable : Any]
        let textSize = self.text?.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context: nil);
        
        return textSize!.height
    }
    
    func autoHeight(width:CGFloat, text:String?, font:UIFont) -> CGFloat {
        if text != nil && (text?.count)! > 0 {
            let size = CGSize(width:width,height: CGFloat(MAXFLOAT))
            let dic = [NSAttributedStringKey.font:font]
            let textSize = text?.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: dic, context: nil);
            return textSize!.height
        }
        return 0
    }
    
    func textAlignmentLeftAndRight(width:CGFloat) {
        let text:NSString = self.text! as NSString
        if text.length > 0 {
            let size = text.boundingRect(with: CGSize.init(width: width, height: CGFloat(MAXFLOAT)), options: [NSStringDrawingOptions.usesLineFragmentOrigin,NSStringDrawingOptions.truncatesLastVisibleLine,NSStringDrawingOptions.usesFontLeading], attributes: [NSAttributedStringKey.font:self.font], context: nil).size
            let margin:CGFloat = (width - size.width)/CGFloat(text.length - 1)
            let number:NSNumber = NSNumber.init(value: Float(margin))
            let attribute:NSMutableAttributedString = NSMutableAttributedString.init(string: self.text!)
            attribute.addAttribute(NSAttributedStringKey.kern, value: number, range: NSRange.init(location: 0, length: text.length - 1))
            self.attributedText = attribute
        }
    }
}


//
//  String+substring.swift
//  HealthMark
//
//  Created by Sansan on 2017/11/22.
//  Copyright © 2017年 dayigufen. All rights reserved.
//

import Foundation

extension String {
    //获取部分字符串，如果不在范围内，返回nil.如果end大于字符串长度，那么截取到最后
    subscript (start: Int, end: Int) -> String? {
        if start > self.count || start < 0 || start > end {
            return nil
        }
        let begin = self.index(self.startIndex, offsetBy: start)
        var terminal: Index
        if end >= count {
            terminal = self.index(self.startIndex, offsetBy: count)
        } else {
            terminal = self.index(self.startIndex, offsetBy: end + 1)
        }
        let range = (begin ..< terminal)
        
        return String(self[range])
    }
    //获取某个字符，如果不在范围内，返回nil
    subscript (index: Int) -> Character? {
        if index > self.count - 1 || index < 0 {
            return nil
        }
        return self[self.index(self.startIndex, offsetBy: index)]
    }
    
    func getWidthForContent(fontSize: CGFloat, height: CGFloat = 20) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return ceil(rect.width)
    }
    
    func getHeightForContent(fontSize: CGFloat, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return ceil(rect.height)
    }
    
}

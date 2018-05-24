//
//  Array+SortedByPinYin.swift
//  KFHome
//
//  Created by 杨新财 on 2018/2/28.
//  Copyright © 2018年 Sansan. All rights reserved.
//

import Foundation

extension Array {
    
    /// 数组内中文按拼音字母排序
    ///
    /// - Parameter ascending: 是否升序（默认升序）
    func sortedByPinyin(ascending: Bool = true) -> Array<String>? {
        if self is Array<String> {
            return (self as! Array<String>).sorted { (value1, value2) -> Bool in
                let pinyin1 = value1.transformToPinyin()
                let pinyin2 = value2.transformToPinyin()
                return pinyin1.compare(pinyin2) == (ascending ? .orderedAscending : .orderedDescending)
            }
        }
        return nil
    }
    
    func getPinyinHeadArray() -> Array<String> {
        var result:[String] = [String]()
        if self is Array<String> {
            for item in self {
                if (item as! String).isIncludeChinese() {
                    result.append((item as! String).transformToPinyinHead())
                } else {
                    result.append("A")
                }
            }
        }
        return result
    }
}

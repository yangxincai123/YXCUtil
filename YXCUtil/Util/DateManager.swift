//
//  DateManager.swift
//  KFHome
//
//  Created by Sansan on 2017/3/10.
//  Copyright © 2017年 Sansan. All rights reserved.
//

import Foundation

//yyyy-MM-dd HH:mm:ss

func date_hm(date:Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    let hm = formatter.string(from: date)
    return hm
}
func date_hour(date:Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH"
    let hour = formatter.string(from: date)
    
    return hour
}
func date_minute(date:Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "mm"
    let m = formatter.string(from: date)
    return m
}
func date_month(date:Date) -> String {
    // 获取当前日期
    let formatter = DateFormatter()
    formatter.dateFormat = "MM"
    let month = formatter.string(from: date)
    return month
}
func date_day(date:Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd"
    let day = formatter.string(from: date)
    return day
}
func date_year(date:Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    let year = formatter.string(from: date)
    return year
}
func dateString(date:Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let dateStr = formatter.string(from: date)
    return dateStr
}
func dateADString(date:Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    let dateStr = formatter.string(from: date)
    return dateStr
}
func dateToFullString(date:Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let dateStr = formatter.string(from: date)
    return dateStr
}
func dateToMMddString(date:Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd"
    let dateStr = formatter.string(from: date)
    return dateStr
}

func sevenDayFromToday() -> NSMutableArray {
    let sevenDays:NSMutableArray = NSMutableArray()
    for i in 0...6 {
        let dateSeven:Date = Date.init(timeIntervalSinceNow: TimeInterval(i*86400))
        let dateStr = "\(date_year(date: dateSeven))-\(date_month(date: dateSeven))-\(date_day(date: dateSeven)) (\(getWeekResult(date: dateSeven)))"
        sevenDays.add(dateStr)
    }
    
    return sevenDays
}
//获取周
func getWeekDay(date:Date) ->Int{
    
    let calendar:NSCalendar = NSCalendar.current as NSCalendar
    let dateComp:NSDateComponents = calendar.components(NSCalendar.Unit.weekday, from: date) as NSDateComponents
    return dateComp.weekday;
}
func getWeekStr(date:Date) -> String {
    let calendar:NSCalendar = NSCalendar.current as NSCalendar
    let dateComp:NSDateComponents = calendar.components(NSCalendar.Unit.weekday, from: date) as NSDateComponents
    if dateComp.weekday == 1 {
        return "星期日"
    }
    if dateComp.weekday == 2 {
        return "星期一"
    }
    if dateComp.weekday == 3 {
        return "星期二"
    }
    if dateComp.weekday == 4 {
        return "星期三"
    }
    if dateComp.weekday == 5 {
        return "星期四"
    }
    if dateComp.weekday == 6 {
        return "星期五"
    }
    if dateComp.weekday == 7 {
        return "星期六"
    }
    return ""
}
func getWeekResult(date:Date) -> String {
    let calendar:NSCalendar = NSCalendar.current as NSCalendar
    let dateComp:NSDateComponents = calendar.components(NSCalendar.Unit.weekday, from: date) as NSDateComponents
    let weeks = ["周日","周一","周二","周三","周四","周五","周六"]
    
    return weeks[dateComp.weekday-1]
}

func calendarDayCountOfMonth(y:Int, m:Int) -> Int {
    
    var count:Int = 30
    if m == 1 || m == 3 || m == 5 || m == 7 || m == 8 || m == 10 || m == 12 {
        count = 31
    }
    if m == 4 || m == 6 || m == 9 || m == 11 {
        count = 30
    }
    if m == 2 {
        if (y % 100 == 0 && y % 400 == 0) || (y % 100 != 0 && y % 4 == 0 ) {
            count = 29
        } else {
            count = 28
        }
    }
    
    return count
}
func calendarDayData(y:Int, m:Int) -> NSMutableArray {
    
    let days:NSMutableArray = NSMutableArray.init()
    var count:Int = 30
    if m == 1 || m == 3 || m == 5 || m == 7 || m == 8 || m == 10 || m == 12 {
        count = 31
    }
    if m == 4 || m == 6 || m == 9 || m == 11 {
        count = 30
    }
    if m == 2 {
        if (y % 100 == 0 && y % 400 == 0) || (y % 100 != 0 && y % 4 == 0 ) {
            count = 29
        } else {
            count = 28
        }
    }
    
    for j in 1...count {
        days.add(String.init(format: "%.2d", j))
    }
    
    return days
}
func stringToDateStamp(timeStr:String) -> TimeInterval {
    let dfmatter = DateFormatter()
    dfmatter.dateFormat="yyyy-MM-dd"
    let date = dfmatter.date(from: timeStr)
    let dateStamp:TimeInterval = (date?.timeIntervalSince1970)!

    return dateStamp
}
func stringToFullDateStamp(timeStr:String) -> TimeInterval {
    if !timeStr.isEmpty {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        let date = dfmatter.date(from: timeStr)
        let dateStamp:TimeInterval = (date?.timeIntervalSince1970)!
        
        return dateStamp
    }
    return 0
}
func dateToSpecialFormat(timeStr:String) -> String {
    
    var result:String = ""
    let dateStamp:TimeInterval = stringToDateStamp(timeStr: timeStr)
    let date:Date = Date.init(timeIntervalSince1970: dateStamp)
    
    let m:Int = Int(date_month(date: date))!
    let d:Int = Int(date_day(date: date))!
    
    result = String.init(format: "%d月%d日", m, d)
    
    return result
}
func dateToXMXDFormat(date:Date) -> String {
    
    let m:Int = Int(date_month(date: date))!
    let d:Int = Int(date_day(date: date))!
    
    let result = String.init(format: "%d月%d日", m, d)
    
    return result
}
func dateToXYXMXDFormat(date:Date) -> String {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy年MM月dd日"
    let dateStr = formatter.string(from: date)
    return dateStr
}
func dateToXYXMXDMSFormat(date:Date) -> String {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
    let dateStr = formatter.string(from: date)
    return dateStr
}
func dateToMessageDetailFormat(date:Date) -> String {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy年MM月dd日"
    let dateStr = formatter.string(from: date)
    
    let hStr = date_hour(date: date)
    let mStr = date_minute(date: date)
    var h:Int = Int(hStr)!
    var noon:String = "下午"
    if h < 12 {
        noon = "上午"
    } else {
        h = h%12
    }
    let res = noon+String.init(format: "%d", h)+":"+mStr+","+dateStr
    
    return res
}
func numberToHanzi(number:Int) -> String {
    var zhNumbers = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
    var units = ["", "十", "百", "千", "万", "十", "百", "千", "亿", "十","百","千"]
    var cn = ""
    var currentNum = 0
    var beforeNum = 0
    let intLength = Int(floor(log10(Double(number))))
    for index in 0...intLength {
        currentNum = number/Int(pow(10.0,Double(index)))%10
        if index == 0{
            if currentNum != 0 {
                cn = zhNumbers[currentNum]
                continue
            }
        } else {
            beforeNum = number/Int(pow(10.0,Double(index-1)))%10
        }
        if [1,2,3,5,6,7,9,10,11].contains(index) {
            if currentNum == 1 && [1,5,9].contains(index) && index == intLength { // 处理一开头的含十单位
                cn = units[index] + cn
            } else if currentNum != 0 {
                cn = zhNumbers[currentNum] + units[index] + cn
            } else if beforeNum != 0 {
                cn = zhNumbers[currentNum] + cn
            }
            continue
        }
        if [4,8,12].contains(index) {
            cn = units[index] + cn
            if (beforeNum != 0 && currentNum == 0) || currentNum != 0 {
                cn = zhNumbers[currentNum] + cn
            }
        }
    }
    return cn
}
func calculatePastDateStrByTimeDifference(second:Int) -> String {
    
    let interval = Date().timeIntervalSince1970
    let pastInterval = interval - TimeInterval(second)
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let pastStr = formatter.string(from: Date.init(timeIntervalSince1970: pastInterval))
    return pastStr
}
func logTime() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "[yyyy/MM/dd HH:mm:ss]"
    let dateStr = formatter.string(from: Date())
    return dateStr
}
func getSleepDateParamsUntil(date:Date, dayCount:Int) -> [SleepDataParam] {
    let daySeconds:Int = 86400
    let startTime_suf:String = " 20:00:00"
    let endTime_suf:String = " 10:00:00"
    let currentTimestamp:TimeInterval = date.timeIntervalSince1970
    var params:[SleepDataParam] = [SleepDataParam]()
    for i in 1...dayCount {
        let dateStr_start:String = dateString(date: Date.init(timeIntervalSince1970: currentTimestamp - TimeInterval(daySeconds*(dayCount - i))))
        let dateStr_end:String = dateString(date: Date.init(timeIntervalSince1970: currentTimestamp - TimeInterval(daySeconds*(dayCount - i - 1))))
        let s = dateStr_start+startTime_suf
        let e = dateStr_end+endTime_suf
        let param:SleepDataParam = SleepDataParam.init(sn: "sn", start_time: s, end_time: e)
        params.append(param)
    }
    return params
}

func secondToStringDesc(second:Int) -> String {
    let hour:Int = second/3600
    let min:Int = (second%3600)/60
    if hour == 0 {
        return String.init(format: "%d分钟", min)
    }
    return String.init(format: "%d小时%d分钟", hour, min)
}
func timeStrhhmmFrom(timestamp:Int) ->String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    let dateStr = formatter.string(from: Date.init(timeIntervalSince1970: TimeInterval(timestamp)))
    return dateStr
}

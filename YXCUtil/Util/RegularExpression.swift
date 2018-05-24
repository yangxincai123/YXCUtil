//
//  RegularExpression.swift
//  KFHome
//
//  Created by Sansan on 2017/3/15.
//  Copyright © 2017年 Sansan. All rights reserved.
//

import Foundation

// 检测手机号码格式的正确性

func IsPhoneNumber(phoneNumber:String) -> Bool {
    
    if phoneNumber.count != 11 {
        return false
    }
    
    let mobileRegular:String = "^1+[3-8]+\\d{9}"
    let pred:NSPredicate = NSPredicate(format:"SELF MATCHES %@", mobileRegular)
    let result:Bool = pred.evaluate(with: phoneNumber)
    
    return result
}

// 检测验证码格式的正确性
func IsVerifyCode(verifyCode:String) -> Bool {
    
    if verifyCode.count != 4 {
        return false
    }
    
    let verifyCodeRegular:String = "[0-9]{4}"
    let pred:NSPredicate = NSPredicate(format:"SELF MATCHES %@", verifyCodeRegular)
    let result:Bool = pred.evaluate(with: verifyCode)
    
    return result
}

// 检测密码格式的正确性,
func IsPassword(password:String) -> Bool {
    
    let passwordRegular:String = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,12}$"// 6~12位数字和字母
    let pred:NSPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegular)
    let result:Bool = pred.evaluate(with: password)
    
    return result
}
//返回性别
func getGenderByIdCard(idCrad:String) -> String {
    let myNSString = idCrad as NSString
    let genderStr = myNSString.substring(with: NSRange(location: myNSString.length-2, length: 1))
    if Int(genderStr)! % 2 == 0 {
        return "女"
    }
    return "男"
}
//检测身份证号格式的正确性
func IsIdentityCard(identityCard:String) -> Bool {
    
    let identityCardRegular:String = "^(\\d{14}|\\d{17})(\\d|[xX])$"
    let pred:NSPredicate = NSPredicate(format:"SELF MATCHES %@", identityCardRegular)
    let result:Bool = pred.evaluate(with: identityCard)
    
    return result
}
func validateIDCardNumber(sfz:String)->Bool{
    
    let value = sfz.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    var length = 0
    if value == ""{
        return false
    } else {
        length = value.count
        if length != 15 && length != 18{
            return false
        }
    }
    
    //省份代码
    let arearsArray = ["11","12", "13", "14", "15", "21", "22", "23", "31", "32", "33", "34", "35", "36", "37", "41", "42", "43", "44", "45", "46", "50", "51", "52", "53", "54", "61", "62", "63", "64", "65", "71", "81", "82", "91"]
    let valueStart2 = (value as NSString).substring(to: 2)
    var arareFlag = false
    if arearsArray.contains(valueStart2){
        
        arareFlag = true
    }
    if !arareFlag{
        return false
    }
    var regularExpression = NSRegularExpression()
    
    var numberofMatch = Int()
    var year = 0
    switch (length){
    case 15:
        year = Int((value as NSString).substring(with: NSRange(location:6,length:2)))!
        if year%4 == 0 || (year%100 == 0 && year%4 == 0){
            do{
                regularExpression = try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$", options: .caseInsensitive) //检测出生日期的合法性
                
            }catch{
            }
        }else{
            do{
                regularExpression = try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$", options: .caseInsensitive) //检测出生日期的合法性
                
            }catch{}
        }
        
        numberofMatch = regularExpression.numberOfMatches(in: value, options:NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, value.count))
        
        if(numberofMatch > 0) {
            return true
        }else {
            return false
        }
        
    case 18:
        year = Int((value as NSString).substring(with: NSRange(location:6,length:4)))!
        if year%4 == 0 || (year%100 == 0 && year%4 == 0){
            do{
                regularExpression = try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$", options: .caseInsensitive) //检测出生日期的合法性
                
            }catch{
                
            }
        }else{
            do{
                regularExpression = try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$", options: .caseInsensitive) //检测出生日期的合法性
                
            }catch{}
        }
        
        numberofMatch = regularExpression.numberOfMatches(in: value, options:NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, value.count))
        
        if(numberofMatch > 0) {
            let v1 = (value as NSString).substring(with: NSRange(location:0,length:1))
            let v2 = (value as NSString).substring(with: NSRange(location:10,length:1))
            let v3 = (value as NSString).substring(with: NSRange(location:1,length:1))
            let v4 = (value as NSString).substring(with: NSRange(location:11,length:1))
            let v5 = (value as NSString).substring(with: NSRange(location:2,length:1))
            let v6 = (value as NSString).substring(with: NSRange(location:12,length:1))
            let v7 = (value as NSString).substring(with: NSRange(location:3,length:1))
            let v8 = (value as NSString).substring(with: NSRange(location:13,length:1))
            let v9 = (value as NSString).substring(with: NSRange(location:4,length:1))
            let v10 = (value as NSString).substring(with: NSRange(location:14,length:1))
            let v11 = (value as NSString).substring(with: NSRange(location:5,length:1))
            let v12 = (value as NSString).substring(with: NSRange(location:15,length:1))
            let v13 = (value as NSString).substring(with: NSRange(location:6,length:1))
            let v14 = (value as NSString).substring(with: NSRange(location:16,length:1))
            let v15 = (value as NSString).substring(with: NSRange(location:7,length:1))
            let v16 = (value as NSString).substring(with: NSRange(location:8,length:1))
            let v17 = (value as NSString).substring(with: NSRange(location:9,length:1))
            let r1 = (Int(v1)! + Int(v2)!) * 7
            let r2 = (Int(v3)! + Int(v4)!) * 9
            let r3 = (Int(v5)! + Int(v6)!) * 10
            let r4 = (Int(v7)! + Int(v8)!) * 5
            let r5 = (Int(v9)! + Int(v10)!) * 8
            let r6 = (Int(v11)! + Int(v12)!) * 4
            let r7 = (Int(v13)! + Int(v14)!) * 2
            let r8 = Int(v15)! * 1 + Int(v16)! * 6
            let r9 = Int(v17)! * 3
            let s1 = r1+r2+r3+r4
            let s2 = r5+r6+r7+r8+r9
            let s = s1+s2
            
            let Y = s%11
            var M = "F"
            let JYM = "10X98765432"
            
            M = (JYM as NSString).substring(with: NSRange(location:Y,length:1))
            if M == (value as NSString).substring(with: NSRange(location:17,length:1))
            {
                return true
            }else{
                return false
            }
            
            
        }else {
            return false
        }
        
    default:
        return false
    }
    
}

enum Validate {
    case email(_: String)
    case phoneNum(_: String)
    case carNum(_: String)
    case username(_: String)
    case password(_: String)
    case nickname(_: String)
    
    case URL(_: String)
    case IP(_: String)
    
    
    var isRight: Bool {
        var predicateStr:String!
        var currObject:String!
        switch self {
        case let .email(str):
            predicateStr = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            currObject = str
        case let .phoneNum(str):
            predicateStr = "^((13[0-9])|(15[^4,\\D]) |(17[0,0-9])|(18[0,0-9]))\\d{8}$"
            currObject = str
        case let .carNum(str):
            predicateStr = "^[A-Za-z]{1}[A-Za-z_0-9]{5}$"
            currObject = str
        case let .username(str):
            predicateStr = "^[A-Za-z0-9]{6,20}+$"
            currObject = str
        case let .password(str):
            predicateStr = "^[a-zA-Z0-9]{6,20}+$"
            currObject = str
        case let .nickname(str):
            predicateStr = "^[\\u4e00-\\u9fa5]{4,8}$"
            currObject = str
        case let .URL(str):
            predicateStr = "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"
            currObject = str
        case let .IP(str):
            predicateStr = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
            currObject = str
        }
        
        let predicate =  NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
        return predicate.evaluate(with: currObject)
    }
}

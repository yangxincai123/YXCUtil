//
//  DYTagView.swift
//  CHPUser
//
//  Created by 杨新财 on 2018/3/2.
//  Copyright © 2018年 杨新财. All rights reserved.
//

import UIKit

let titleLeftRightMargin:CGFloat = 8.0
let spaceOfButton:CGFloat = 10.0

class DYTagView: UIView {

    var selectedHandle:((Int, String) -> ())?
    var selectedLabel:UILabel?
    var selectedColor:UIColor?
    var canSelected:Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func layoutTagView(tagTexts:[String], textColor:UIColor, maxWidth:CGFloat, fontSize:CGFloat, isCanSelected:Bool) {
        if maxWidth <= 0 {
            return
        }
        if tagTexts.count > 0 {
            self.selectedColor = textColor
            self.canSelected = isCanSelected
            
            var lastLabel:UILabel?
            var currentWidth:CGFloat = 0.0
            var isNewLine:Bool = false
            for i in 0..<tagTexts.count {
                let label:UILabel = UILabel()
                self.addSubview(label)
                label.text = tagTexts[i]
                label.isUserInteractionEnabled = true
                label.textAlignment = .center
                label.textColor = textColor
                label.font = UIFont.systemFont(ofSize: fontSize)
                label.layer.cornerRadius = 3
                label.layer.borderColor = textColor.cgColor
                label.layer.borderWidth = 1.0
                label.clipsToBounds = true
                label.tag = 1000+i
                if isCanSelected {
                    let tap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(selectedAction(tap:)))
                    label.addGestureRecognizer(tap)
                }
                
                let labelWidth:CGFloat = tagTexts[i].getWidthForContent(fontSize: fontSize) + titleLeftRightMargin*2
                currentWidth = currentWidth + labelWidth
                if lastLabel != nil {
                    label.snp.makeConstraints({ (make) in
                        make.height.equalTo(lastLabel!)
                        if isNewLine {
                            make.left.equalTo(self)
                            make.top.equalTo((lastLabel?.snp.bottom)!).offset(spaceOfButton)
                            if currentWidth < maxWidth {
                                make.width.equalTo(labelWidth)
                            } else {
                                make.right.equalTo(self)
                            }
                        } else {
                            
                            if currentWidth <= maxWidth {
                                make.left.equalTo((lastLabel?.snp.right)!).offset(spaceOfButton)
                                make.top.equalTo(lastLabel!)
                                make.width.equalTo(labelWidth)
                            } else {
                                make.left.equalTo(self)
                                make.top.equalTo((lastLabel?.snp.bottom)!).offset(spaceOfButton)
                                if labelWidth >= maxWidth {
                                    make.right.equalTo(self)
                                } else {
                                    make.width.equalTo(labelWidth)
                                }
                            }
                        }
                    })
                    
                    if isNewLine {
                        if currentWidth < maxWidth {
                            isNewLine = false
                            currentWidth = currentWidth + spaceOfButton
                        } else {
                            isNewLine = true
                            currentWidth = spaceOfButton
                        }
                    } else {
                        if currentWidth == maxWidth {
                            isNewLine = true
                            currentWidth = spaceOfButton
                        } else if currentWidth < maxWidth {
                            isNewLine = false
                            currentWidth = currentWidth + spaceOfButton
                        } else {
                            if labelWidth >= maxWidth {
                                isNewLine = true
                                currentWidth = spaceOfButton
                            } else {
                                isNewLine = false
                                currentWidth = labelWidth + spaceOfButton
                            }
                        }
                    }
                } else {
                    if currentWidth > maxWidth {
                        isNewLine = true
                        currentWidth = 0.0
                    } else {
                        currentWidth = spaceOfButton
                    }
                    label.snp.makeConstraints({ (make) in
                        make.left.equalTo(self)
                        make.top.equalTo(self)
                        make.height.equalTo(30)
                        if labelWidth <= maxWidth {
                            make.width.equalTo(labelWidth)
                        } else {
                            make.right.equalTo(self)
                        }
                    })
                }
                lastLabel = label
            }
        }
    }
    
    @objc func selectedAction(tap:UITapGestureRecognizer) {
        let label:UILabel = tap.view as! UILabel
        if selectedLabel == nil || label.tag != selectedLabel?.tag {
            if selectedLabel != nil {
                selectedLabel?.backgroundColor = UIColor.white
                selectedLabel?.textColor = self.selectedColor
            }
            self.selectedHandle!(label.tag, label.text!)
            label.backgroundColor = self.selectedColor
            label.textColor = UIColor.white
            selectedLabel = label
        }
    }

    class func getCellHeight(tagTexts:[String], textColor:UIColor, maxWidth:CGFloat, fontSize:CGFloat) -> CGFloat {
        if maxWidth <= 0 {
            return 0.0
        }
        if tagTexts.count > 0 {
            
            var currentWidth:CGFloat = 0.0
            var totalLines:Int = 0
            var isNewLine:Bool = false
            for i in 0..<tagTexts.count {
                
                let labelWidth:CGFloat = tagTexts[i].getWidthForContent(fontSize: fontSize) + titleLeftRightMargin*2
                currentWidth = currentWidth + labelWidth
                if i != 0 {
                    
                    if isNewLine {
                        if currentWidth < maxWidth {
                            isNewLine = false
                            currentWidth = currentWidth + spaceOfButton
                        } else {
                            isNewLine = true
                            totalLines = totalLines + 1
                            currentWidth = spaceOfButton
                        }
                    } else {
                        if currentWidth == maxWidth {
                            isNewLine = true
                            currentWidth = spaceOfButton
                        } else if currentWidth < maxWidth {
                            isNewLine = false
                            currentWidth = currentWidth + spaceOfButton
                        } else {
                            totalLines = totalLines + 1
                            if labelWidth >= maxWidth {
                                isNewLine = true
                                currentWidth = spaceOfButton
                            } else {
                                isNewLine = false
                                currentWidth = labelWidth + spaceOfButton
                            }
                        }
                    }
                } else {
                    totalLines = totalLines + 1
                    if currentWidth > maxWidth {
                        isNewLine = true
                        currentWidth = 0.0
                    } else {
                        currentWidth = spaceOfButton
                    }
                }
            }
            return CGFloat(totalLines * 40 - 10)
        }
        return 0.0
    }
}

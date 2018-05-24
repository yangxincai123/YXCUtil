//
//  SwitchLabelView.swift
//  HealthMark
//
//  Created by Sansan on 2017/10/25.
//  Copyright © 2017年 dayigufen. All rights reserved.
//

import UIKit

class SwitchLabelView: UIView {

    var selectedHandle:((Int, String) -> ())?
    var markImagView:UIImageView?
    var selectedBtn:UIButton?
    var isShowMark:Bool = true
    var selectedColor:UIColor = UIColor.black
    var textColor:UIColor = UIColor.black
    var titleFont:CGFloat = 18.0
    
    var scaleFont:CGFloat = 2.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configLabel(labTexts:[String], textColor:UIColor, selectedColor:UIColor, showMark:Bool = true, markWidth:CGFloat = 45.0, font:CGFloat = 18.0, scaleFont:CGFloat) {
        self.isShowMark = showMark
        self.selectedColor = selectedColor
        self.textColor = textColor
        self.titleFont = font
        self.scaleFont = scaleFont
        if labTexts.count > 0 {
            var lastBtn:UIButton?
            for i in 0..<labTexts.count {
                let button:UIButton = UIButton.init(type: .custom)
                self.addSubview(button)
                button.setTitle(labTexts[i], for: .normal)
                button.setTitleColor(textColor, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: self.titleFont)
                button.tag = 1000+i
                button.addTarget(self, action: #selector(selectedAction(button:)), for: .touchUpInside)
                if lastBtn != nil {
                    button.snp.makeConstraints({ (make) in
                        make.left.equalTo((lastBtn?.snp.right)!)
                        make.bottom.top.equalTo(lastBtn!)
                        make.width.equalTo(lastBtn!)
                        if i == labTexts.count-1 {
                            make.right.equalTo(self)
                        }
                    })
                } else {
                    button.snp.makeConstraints({ (make) in
                        make.left.equalTo(self)
                        make.bottom.top.equalTo(self)
                    })
                }
                lastBtn = button
            }
            let btn:UIButton = self.viewWithTag(1000) as! UIButton
            btn.setTitleColor(selectedColor, for: .normal)
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: self.titleFont + self.scaleFont)
            selectedBtn = btn
            if self.isShowMark {
                markImagView = UIImageView()
                self.addSubview(markImagView!)
//                markImagView?.layer.cornerRadius = 1.5
                markImagView?.backgroundColor = selectedColor
                markImagView?.snp.makeConstraints({ (make) in
                    make.bottom.equalTo(self)
                    make.centerX.equalTo(btn.snp.centerX)
                    make.height.equalTo(2)
                    make.width.equalTo(markWidth)
                })
            }
        }
    }
    @objc func selectedAction(button:UIButton) {
        if selectedBtn == nil || button.tag != selectedBtn?.tag {
            if selectedBtn != nil {
                selectedBtn?.titleLabel?.font = UIFont.systemFont(ofSize: self.titleFont)
                selectedBtn?.setTitleColor(self.textColor, for: .normal)
            }
            if self.isShowMark {
                UIView.animate(withDuration: 0.3, animations: {
                    self.markImagView?.center = CGPoint.init(x: button.center.x, y: self.frame.size.height - 1.5)
                }, completion: { (isComplete) in
                })
            }
            
            self.selectedHandle!(button.tag, (button.titleLabel?.text)!)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: self.titleFont + self.scaleFont)
            button.setTitleColor(self.selectedColor, for: .normal)
            
            selectedBtn = button
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.selectedBtn != nil {
            self.markImagView?.center = CGPoint.init(x: (self.selectedBtn?.center.x)!, y: self.frame.size.height - 1.5)
        }
    }
    
}

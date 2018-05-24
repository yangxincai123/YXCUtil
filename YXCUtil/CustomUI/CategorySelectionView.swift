//
//  CategorySelectionView.swift
//  CHPUser
//
//  Created by 杨新财 on 2018/3/1.
//  Copyright © 2018年 杨新财. All rights reserved.
//

import UIKit

class CategorySelectionView: UIView {

    var selectedHandle:((Int, String) -> ())?
    var selectedBtn:UIButton?
    
    var selectedColor:UIColor = Colors.mainGreen
    var textColor:UIColor = Colors.textColor4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configLabel(labTexts:[String], textColor:UIColor, selectedColor:UIColor, maxLabelNumOfline:Int = 4) {
        self.textColor = textColor
        self.selectedColor = selectedColor
        if labTexts.count > 0 {
            var lastBtn:UIButton?
            for i in 0..<labTexts.count {
                let button:UIButton = UIButton.init(type: .custom)
                self.addSubview(button)
                button.setTitle(labTexts[i], for: .normal)
                button.setTitleColor(textColor, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                button.tag = 1000+i
                button.addTarget(self, action: #selector(selectedAction(button:)), for: .touchUpInside)
                if lastBtn != nil {
                    button.snp.makeConstraints({ (make) in
                        make.width.equalTo(lastBtn!)
                        make.height.equalTo(lastBtn!)
                        if (i + 1) % maxLabelNumOfline == 0 {
                            make.right.equalTo(self)
                        }
                        if i % maxLabelNumOfline == 0 {
                            make.left.equalTo(self)
                            make.top.equalTo(lastBtn!.snp.bottom)
                        } else {
                            make.top.equalTo(lastBtn!)
                            make.left.equalTo((lastBtn?.snp.right)!)
                        }
                        if i == labTexts.count - 1 {
                            make.bottom.equalTo(self)
                        }
                    })
                } else {
                    button.snp.makeConstraints({ (make) in
                        make.left.equalTo(self)
                        make.top.equalTo(self)
                    })
                }
                lastBtn = button
            }
            let btn:UIButton = self.viewWithTag(1000) as! UIButton
            btn.setTitleColor(selectedColor, for: .normal)
            selectedBtn = btn
        }
    }
    @objc func selectedAction(button:UIButton) {
        if selectedBtn == nil || button.tag != selectedBtn?.tag {
            if selectedBtn != nil {
                selectedBtn?.setTitleColor(self.textColor, for: .normal)
            }
            button.setTitleColor(self.selectedColor, for: .normal)
            self.selectedHandle!(button.tag, (button.titleLabel?.text)!)
            selectedBtn = button
        }
    }

}

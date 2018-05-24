//
//  UITableView+NoData.swift
//  KFHome
//
//  Created by Sansan on 2017/5/2.
//  Copyright © 2017年 Sansan. All rights reserved.
//

import Foundation
import SnapKit

extension UITableView {
    
    func showDefaultImage() {
        
        let defaultView:UIView? = self.viewWithTag(10001)
        if defaultView == nil {
            let defaultView:UIView = UIView()
            defaultView.frame = self.bounds
            defaultView.tag = 10001
            self.addSubview(defaultView)
            
            let defaultImage:UIImageView = UIImageView()
            defaultImage.tag = 10002
            defaultImage.contentMode = .scaleAspectFit
            defaultImage.image = UIImage(named:"网络错误")
            defaultView.addSubview(defaultImage)
            
            defaultImage.snp.makeConstraints { (make) in
                make.centerX.equalTo(defaultView)
                make.top.equalTo(defaultView).offset(43)
                make.width.equalTo(self).dividedBy(2.5)
                make.height.equalTo(defaultImage.snp.width)
            }
            
            let defaultTitie:UILabel = UILabel()
            defaultTitie.text = "暂无内容"
            defaultTitie.tag = 10003
            defaultTitie.font = UIFont.systemFont(ofSize: 17)
            defaultTitie.textColor = UIColor.ColorHex(hex: "#888888")
            defaultView.addSubview(defaultTitie)
            defaultTitie.snp.makeConstraints { (make) in
                make.top.equalTo(defaultImage.snp.bottom).offset(6)
                make.centerX.equalTo(defaultView).offset(7)
            }

        }
    }
    func setDefaultTitle(title:String) {
        let label:UILabel? = self.viewWithTag(10003) as? UILabel
        if label != nil {
            label?.text = title
        }
    }
    func setImageTopSpace(top:CGFloat) {
        let defaultView:UIView? = self.viewWithTag(10001)
        
        defaultView?.frame = CGRect.init(x: 0, y: top, width: self.frame.size.width, height: self.frame.size.height - top)
        
    }
    func dismissDefaultImage() {
        var defaultView:UIView? = self.viewWithTag(10001)
        if defaultView != nil {
            defaultView?.removeFromSuperview()
            defaultView = nil
        }
    }
    
}

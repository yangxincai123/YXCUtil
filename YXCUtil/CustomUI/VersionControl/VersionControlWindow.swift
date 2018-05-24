//
//  VersionControlWindow.swift
//  KFHome
//
//  Created by Sansan on 2017/6/27.
//  Copyright © 2017年 Sansan. All rights reserved.
//

import UIKit

class VersionControlWindow: UIWindow {
    
    
    @IBOutlet weak var lb_version_new: UILabel!
    
    @IBOutlet weak var tv_content: UITextView!
    @IBOutlet weak var lb_version: UILabel!
    @IBOutlet weak var btn_version_exit: UIButton!
    
    @IBOutlet weak var lb_hint: UILabel!
    
    var url:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func updateVersionAction(_ sender: Any) {
        let url_app:URL = URL.init(string: url)!
        UIApplication.shared.openURL(url_app)
        //        UIApplication.shared.openURL(URL.init(string: "itms-apps://itunes.apple.com/app/id1380029164")!)
    }
    
    @IBAction func exitVersionAction(_ sender: Any) {
        VersionManager.shared.dismiss()
    }
    
}
private let VManager = VersionManager()

class VersionManager: NSObject {
    
    static var shared:VersionManager {
        return VManager
    }
    fileprivate override init() {
        super.init()
    }
    var url:String = ""
    var versionWindow:VersionControlWindow?
    
    func show(model:VersionInfoModel, isNecessary:Bool) {
        versionWindow  = (Bundle.main.loadNibNamed("VersionControlWindow", owner: nil, options: nil)?.first as? VersionControlWindow)!
        versionWindow?.frame = UIScreen.main.bounds
        versionWindow?.windowLevel = UIWindowLevelAlert
        versionWindow?.makeKeyAndVisible()
        versionWindow?.tv_content.text = model.ver_info
        versionWindow?.lb_version.text = String.init(format: " V%@ ", model.cur_version)
        versionWindow?.lb_version_new.text = String.init(format: " V%@ ", model.cur_version)
        versionWindow?.btn_version_exit.isHidden = isNecessary
        
        versionWindow?.tv_content.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        versionWindow?.url = self.url

    }
    func dismiss() {
        self.versionWindow?.resignKey()
        self.versionWindow = nil
    }
    
}

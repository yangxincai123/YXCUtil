//
//  NavigationController+Rotate.swift
//  DoctorTime
//
//  Created by Sansan on 2017/7/11.
//  Copyright © 2017年 Sansan. All rights reserved.
//

import Foundation
import UIKit
extension UINavigationController {
    
    override open var shouldAutorotate: Bool {
        return true
    }
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
}

//
//  UINavigationController+Pop.swift
//  KFHome
//
//  Created by Sansan on 2017/2/28.
//  Copyright © 2017年 Sansan. All rights reserved.
//

import Foundation
import UIKit
extension UINavigationController {
    func pop(animated: Bool) {
        _ = self.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool) {
        _ = self.popToRootViewController(animated: animated)
    }
}

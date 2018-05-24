//
//  PhotoConfig.swift
//  SelectPhoto
//
//  Created by 杨新财 on 2018/2/26.
//  Copyright © 2018年 杨新财. All rights reserved.
//

import Foundation
import UIKit

func showAlert(msg:String) -> UIAlertController {
    let alert:UIAlertController = UIAlertController.init(title: "提示", message: msg, preferredStyle: .alert)
    let action:UIAlertAction = UIAlertAction.init(title: "确定", style: .default) { (act) in
        alert.dismiss(animated: true, completion: nil)
    }
    alert.addAction(action)
    
    return alert
}

class PhotoConfig {
    
    static let max_selected_photo_num:Int = 9           //最多可选择照片张数
    
    static let small_cell_width:CGFloat = 80            //DYPhotoPickerController照片小图尺寸
    static let big_cell_height:CGFloat = 180            //DYPhotoPickerController照片大图高度
    static let cell_line_space:CGFloat = 5              //照片header和footer宽度
    static let cell_Interitem_space:CGFloat = 10        //DYPhotoPickerController照片间隔
    static let superview_big_height:CGFloat = 300       //DYPhotoPickerController照片被选择后控件高度
    static let superview_original_height:CGFloat = 200  //DYPhotoPickerController原始控件高度
    
    static let previewImage_max_height:CGFloat = 1200       //照片最大预览高度
    
    static let systemBlue:UIColor = UIColor.init(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
    
    /** 压缩比,0(most)..1(least) 越小图片就越小*/
    static let compressionQuality: CGFloat = 1.0
    
    /** 从云端获取照片的缩放比*/
    static let cloudImageScale: CGFloat = 1.0
}

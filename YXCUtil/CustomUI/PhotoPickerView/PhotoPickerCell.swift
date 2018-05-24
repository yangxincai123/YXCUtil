//
//  PhotoPickerCell.swift
//  SelectPhoto
//
//  Created by 杨新财 on 2018/2/23.
//  Copyright © 2018年 杨新财. All rights reserved.
//

import UIKit
import Photos

class PhotoPickerCell: UICollectionViewCell {
    
    @IBOutlet weak var img_photo: UIImageView!
    @IBOutlet weak var btn_selected: UIButton!
    
    var image_asset:PHAsset? {
        didSet {
            DYPhotoPickerManager.shared.getPhotoByMaxSize(asset: image_asset!, height: PhotoConfig.big_cell_height) { (image, info) -> Void in
                self.img_photo.image = image
            }
        }
    }
    
    func setupSelected(isPhotoSelected:Bool, index:Int, indexPath:IndexPath) {
        self.btn_selected.isHidden = !isPhotoSelected
        if isPhotoSelected {
            self.btn_selected.setTitle("\(index+1)", for: .normal)
        } else {
            self.btn_selected.setTitle("", for: .normal)
        }
    }
}

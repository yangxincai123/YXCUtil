//
//  AlbumCollectionCell.swift
//  SelectPhoto
//
//  Created by 杨新财 on 2018/2/24.
//  Copyright © 2018年 杨新财. All rights reserved.
//

import UIKit
import Photos

class AlbumCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var img_photo: UIImageView!
    @IBOutlet weak var btn_selected: UIButton!
    
    @IBOutlet weak var img_mark: UIImageView!
    @IBOutlet weak var lb_index: UILabel!
    
    var selectedHandle:((IndexPath) -> ())!
    var indexPath:IndexPath?
    
    var image_asset:PHAsset? {
        didSet {
            let cellHeight = (UIScreen.main.bounds.width - 25)/4.0
            DYPhotoPickerManager.shared.getPhotoByMaxSize(asset: image_asset!, height: cellHeight) { (image, info) -> Void in
                self.img_photo.image = image
            }
        }
    }
    
    @IBAction func selectedAction(_ sender: Any) {
        self.selectedHandle(self.indexPath!)
    }
    func setupSelected(isPhotoSelected:Bool, index:Int, indexPath:IndexPath) {
        self.lb_index.isHidden = !isPhotoSelected
        if isPhotoSelected {
            self.lb_index.text = "\(index+1)"
            self.img_mark.image = UIImage.init(named: "circle_blue")
        } else {
            self.lb_index.text = ""
            self.img_mark.image = UIImage.init(named: "circle")
        }
    }
}

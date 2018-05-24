//
//  AlbumPhotoImage.swift
//  SelectPhoto
//
//  Created by 杨新财 on 2018/2/26.
//  Copyright © 2018年 杨新财. All rights reserved.
//

import UIKit
import Photos

class AlbumPhotoImage: NSObject {
    
    static let shared:AlbumPhotoImage = AlbumPhotoImage()
    private override init() {}
    var selectedImageChangeHandle:(() -> ())?
    var selectedImage:[PHAsset] = [PHAsset]()
    
}

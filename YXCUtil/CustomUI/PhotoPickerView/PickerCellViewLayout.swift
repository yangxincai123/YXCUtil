//
//  PickerCellViewLayout.swift
//  SelectPhoto
//
//  Created by 杨新财 on 2018/2/23.
//  Copyright © 2018年 杨新财. All rights reserved.
//

import UIKit
import Photos

class PickerCellViewLayout: UICollectionViewLayout {
    
    var attrsArr:[UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepare() {
        super.prepare()
        
        self.attrsArr.removeAll()
        let count:Int = (self.collectionView?.numberOfItems(inSection: 0))!
        for i in 0..<count {
            let indexPath = IndexPath.init(row: i, section: 0)
            let attrs:UICollectionViewLayoutAttributes = self.layoutAttributesForItem(at: indexPath)!
            self.attrsArr.append(attrs)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return attrsArr
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs:UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        let index:Int = indexPath.row
        if DYPhotoPickerManager.shared.selectedPhotoData.count == 0 {
            let x:CGFloat = CGFloat(5 + index * 10)
            attrs.frame = CGRect.init(x: CGFloat(index) * PhotoConfig.small_cell_width + x, y: 5, width: PhotoConfig.small_cell_width, height: PhotoConfig.small_cell_width)
        } else {
            let currentAsset:PHAsset = DYPhotoPickerManager.shared.assetsFetchResults[indexPath.row]
            let currentImageWidth:CGFloat = CGFloat(currentAsset.pixelWidth)*PhotoConfig.big_cell_height/CGFloat(currentAsset.pixelHeight)
            attrs.frame = CGRect.init(x: DYPhotoPickerManager.shared.bigCellOffsetX[indexPath.row], y: 5, width: currentImageWidth, height: PhotoConfig.big_cell_height)
        }
        
        return attrs
    }
    override var collectionViewContentSize: CGSize {
        if DYPhotoPickerManager.shared.selectedPhotoData.count > 0 {
            return CGSize.init(width: DYPhotoPickerManager.shared.collectionViewWidth, height: 0)
        }
        return CGSize.init(width: (PhotoConfig.small_cell_width + 10) * CGFloat(DYPhotoPickerManager.shared.assetsFetchResults.count), height: 0)
    }
}

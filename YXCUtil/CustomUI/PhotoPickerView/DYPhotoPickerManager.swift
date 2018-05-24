//
//  PhotoPickerManager.swift
//  SelectPhoto
//
//  Created by 杨新财 on 2018/2/23.
//  Copyright © 2018年 杨新财. All rights reserved.
//

import UIKit
import Photos

class DYPhotoPickerManager: NSObject {
    
    static let shared = DYPhotoPickerManager()
    
    var selectedPhotoData:[PHAsset] = [PHAsset]()
    
    var bigCellOffsetX:[CGFloat] = [CGFloat]()
    var collectionViewWidth:CGFloat = 0.0
    
    var selectedComplete:(([PHAsset]) -> ())?
    
    ///取得的资源结果，用了存放的PHAsset
    var assetsFetchResults:PHFetchResult<PHAsset> = PHFetchResult<PHAsset>()
    /// 带缓存的图片管理对象
    var imageManager:PHCachingImageManager!
    
    private override init() {
        super.init()
    }
    
    func getPhotoSource() {
        DYPhotoPickerManager.shared.checkPermission { (res) in
            if res {
                self.bigCellOffsetX.removeAll()
                self.selectedPhotoData.removeAll()
                
                //获取所有资源
                let photosOptions = PHFetchOptions()
                //按照创建时间倒序排列
                photosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                //只获取图片
                photosOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
                
                self.assetsFetchResults = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: photosOptions)
                
                self.bigCellOffsetX.append(5.0)
                for i in 0..<self.assetsFetchResults.count {
                    let currentAsset:PHAsset = self.assetsFetchResults[i]
                    let currentImageWidth:CGFloat = CGFloat(currentAsset.pixelWidth)*PhotoConfig.big_cell_height/CGFloat(currentAsset.pixelHeight)
                    var lastXOffset:CGFloat = 5.0
                    if self.bigCellOffsetX.last != nil {
                        lastXOffset = self.bigCellOffsetX.last!
                    }
                    self.bigCellOffsetX.append(lastXOffset+currentImageWidth+10)
                    if i == self.assetsFetchResults.count - 1 {
                        self.collectionViewWidth = self.bigCellOffsetX.last! - 5
                    }
                }
                // 初始化和重置缓存
                self.imageManager = PHCachingImageManager()
                let opt = PHImageRequestOptions();
                opt.resizeMode = .fast;
                opt.isSynchronous = true
                self.resetCachedAssets()
            }
        }
    }
    
    func getAllSmartAlbum() -> [PHAssetCollection] {
        let assetCollection = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.any, options: nil)
        var albums:[PHAssetCollection] = [PHAssetCollection]()
        assetCollection.enumerateObjects { (assetCollect, index, res) in
            if assetCollect.localizedTitle == "Camera Roll" || assetCollect.localizedTitle == "Recently Added" || assetCollect.localizedTitle == "Screenshots" || assetCollect.localizedTitle == "Selfies" || assetCollect.localizedTitle == "所有照片" || assetCollect.localizedTitle == "最近添加" || assetCollect.localizedTitle == "屏幕快照" || assetCollect.localizedTitle == "自拍" {
                albums.append(assetCollect)
            }
        }
        return albums
    }
    
    //重置缓存
    func resetCachedAssets(){
        DYPhotoPickerManager.shared.checkPermission { (res) in
            if res {
                self.imageManager.stopCachingImagesForAllAssets()
            }
        }
    }
    
    func getPhotoByMaxSize(asset: PHObject, height: CGFloat, completion: @escaping (UIImage?,[NSObject : AnyObject]?)->Void){
        
        let maxSize = height > PhotoConfig.previewImage_max_height ? PhotoConfig.previewImage_max_height : height
        if let asset = asset as? PHAsset {
            
            let factor = CGFloat(asset.pixelWidth)/CGFloat(asset.pixelHeight)
            let scale = UIScreen.main.scale
            let pixcelHeight = maxSize * scale
            let pixcelWidth = CGFloat(pixcelHeight) * factor
            self.imageManager.requestImage(for: asset, targetSize: CGSize(width:pixcelWidth, height: pixcelHeight), contentMode: .aspectFit, options: nil, resultHandler: { (image, info) -> Void in
                
                if let info = info as? [String:AnyObject] {
                    let canceled = info[PHImageCancelledKey] as? Bool
                    let error = info[PHImageErrorKey] as? NSError
                    
                    if canceled == nil && error == nil && image != nil {
                        completion(image, info as [NSObject : AnyObject]?)
                    }
                    // download from iCloud
                    let isCloud = info[PHImageResultIsInCloudKey] as? Bool
                    if isCloud != nil && image == nil {
                        let options = PHImageRequestOptions()
                        options.isNetworkAccessAllowed = true
                        self.imageManager.requestImageData(for: asset, options: options, resultHandler: { (data, dataUTI, oritation, info) -> Void in
                            
                            if let data = data {
                                let resultImage = UIImage(data: data, scale: PhotoConfig.cloudImageScale)
                                completion(resultImage,info as [NSObject : AnyObject]?)
                            }
                        })
                    }
                }
            })
        }
    }
    
    func showPicker() {
        let photoPickerVC:DYPhotoPickerController = UIStoryboard(name:"PhotoPickerStoryboard",bundle:Bundle.main).instantiateViewController(withIdentifier:"DYPhotoPickerController") as! DYPhotoPickerController
        photoPickerVC.modalPresentationStyle = .custom
        UIApplication.shared.keyWindow?.rootViewController?.present(photoPickerVC, animated: false, completion: nil)
    }
    func dismissPicker(controller:UIViewController) {
        controller.dismiss(animated: true, completion: nil)
        self.resetCachedAssets()
        self.selectedPhotoData.removeAll()
        AlbumPhotoImage.shared.selectedImage.removeAll()
    }
    func showPhotoCollectionView() {
        
        let albumsVC:AlbumTableController =  UIStoryboard(name:"PhotoPickerStoryboard",bundle:Bundle.main).instantiateViewController(withIdentifier:"AlbumTableController") as! AlbumTableController
        
        let photoVC:DYPhotoViewController = UIStoryboard(name:"PhotoPickerStoryboard",bundle:Bundle.main).instantiateViewController(withIdentifier:"DYPhotoViewController") as! DYPhotoViewController
        for i in 0..<DYPhotoPickerManager.shared.assetsFetchResults.count {
            photoVC.photos.append(DYPhotoPickerManager.shared.assetsFetchResults[i])
        }
        let naVC:UINavigationController = UINavigationController.init(rootViewController: albumsVC)
        naVC.pushViewController(photoVC, animated: false)
        naVC.navigationBar.tintColor = UIColor.white
        
        UIApplication.shared.keyWindow?.rootViewController?.present(naVC, animated: true, completion: nil)
    }
    
    func checkPermission(complete:@escaping ((Bool) -> ())) {
        let authStatus:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if (authStatus == PHAuthorizationStatus.restricted || authStatus == PHAuthorizationStatus.denied){
            //无权限 做一个友好的提示
            let alertController:UIAlertController = UIAlertController.init(title: "请您设置允许APP访问您的相册->设置->隐私->照片", message: nil, preferredStyle: .alert)
            
            let cancel:UIAlertAction = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
            }
            let confirm:UIAlertAction = UIAlertAction.init(title: "确定", style: .default) { (action) in
                let url:URL = URL.init(string: UIApplicationOpenSettingsURLString)!
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url)
                }
            }
            alertController.addAction(cancel)
            alertController.addAction(confirm)
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true) {}
            complete(false)
        } else if authStatus == PHAuthorizationStatus.notDetermined {
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
                case .authorized:
                    break
                case .denied, .restricted:
                    break
                case .notDetermined:
                    break
                }
                complete(false)
            }
        } else if authStatus == PHAuthorizationStatus.authorized {
            complete(false)
        }
    }
    
}

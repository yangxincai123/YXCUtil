//
//  AlbumTableController.swift
//  SelectPhoto
//
//  Created by 杨新财 on 2018/2/27.
//  Copyright © 2018年 杨新财. All rights reserved.
//

import UIKit
import Photos

class AlbumTableController: UITableViewController {
    
    var albums:[PHAssetCollection]!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.albums = DYPhotoPickerManager.shared.getAllSmartAlbum()
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAllPHAssetInAlbum(assetCollection:PHAssetCollection) -> [PHAsset] {
        var assets:[PHAsset] = [PHAsset]()
        //获取所有资源
        let options = PHFetchOptions()
        //按照创建时间倒序排列
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        //只获取图片
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        let result:PHFetchResult = PHAsset.fetchAssets(in: assetCollection, options: options)
        if result.count > 0 {
            result.enumerateObjects { (asset, index, obj) in
                assets.append(asset)
            }
        }
        return assets
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        AlbumPhotoImage.shared.selectedImage.removeAll()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:AlbumCell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        
        let album:PHAssetCollection = self.albums[indexPath.row]
        
        var title:String = ""
        if album.localizedTitle == "Selfies" || album.localizedTitle == "自拍" {
            title = "自拍"
        }
        if album.localizedTitle == "Screenshots" || album.localizedTitle == "屏幕快照" {
            title = "屏幕快照"
        }
        if album.localizedTitle == "Recently Added" || album.localizedTitle == "最近添加" {
            title = "最近添加"
        }
        if album.localizedTitle == "Camera Roll" || album.localizedTitle == "所有照片" {
            title = "所有照片"
        }
        cell.lb_title?.text = title
        let assets:[PHAsset] = self.getAllPHAssetInAlbum(assetCollection: album)
        if assets.count > 0 {
            DYPhotoPickerManager.shared.getPhotoByMaxSize(asset: assets.first!, height: 80) { (image, info) in
                cell.img_cover?.image = image
                cell.lb_subTitle.text = "\(assets.count)"
            }
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photoVC:DYPhotoViewController = UIStoryboard(name:"PhotoPickerStoryboard",bundle:Bundle.main).instantiateViewController(withIdentifier:"DYPhotoViewController") as! DYPhotoViewController
        let album:PHAssetCollection = self.albums[indexPath.row]
        photoVC.photos = self.getAllPHAssetInAlbum(assetCollection: album)
        self.navigationController?.pushViewController(photoVC, animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }
}

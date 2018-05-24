//
//  DYPhotoViewController.swift
//  SelectPhoto
//
//  Created by 杨新财 on 2018/2/24.
//  Copyright © 2018年 杨新财. All rights reserved.
//

import UIKit
import Photos

class DYPhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var btn_preview: UIButton!
    @IBOutlet weak var btn_send: UIButton!
    @IBOutlet weak var lb_num: UILabel!
    
    @IBOutlet weak var collection_photo: UICollectionView!
    var photos:[PHAsset] = [PHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func backAction(_ sender: Any) {
        AlbumPhotoImage.shared.selectedImage.removeAll()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func previewAction(_ sender: Any) {
        let previewVC:PreviewController =  UIStoryboard(name:"PhotoPickerStoryboard",bundle:Bundle.main).instantiateViewController(withIdentifier:"PreviewController") as! PreviewController
        previewVC.photoImages = AlbumPhotoImage.shared.selectedImage
        previewVC.photosChangeHandle = {
            self.collection_photo.reloadData()
        }
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
    @IBAction func sendAction(_ sender: Any) {
        DYPhotoPickerManager.shared.selectedComplete!(AlbumPhotoImage.shared.selectedImage)
        DYPhotoPickerManager.shared.dismissPicker(controller: self)
    }
    @IBAction func cancelAction(_ sender: Any) {
        AlbumPhotoImage.shared.selectedImage.removeAll()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (UIScreen.main.bounds.width - 25)/4.0, height: (UIScreen.main.bounds.width - 25)/4.0)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:AlbumCollectionCell  = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionCell", for: indexPath) as! AlbumCollectionCell
        let asset:PHAsset = self.photos[indexPath.row]
        cell.image_asset = asset
        cell.indexPath = indexPath
        cell.selectedHandle = { index in
            self.deselect(index: index)
        }
        
        if AlbumPhotoImage.shared.selectedImage.contains(asset) {
            cell.setupSelected(isPhotoSelected: true, index: AlbumPhotoImage.shared.selectedImage.index(of: asset)!, indexPath:indexPath)
        } else {
            cell.setupSelected(isPhotoSelected: false, index: 0, indexPath:indexPath)
        }
        
        return cell
    }
    func deselect(index:IndexPath) {
        let cell:AlbumCollectionCell = self.collection_photo.cellForItem(at: index) as! AlbumCollectionCell
        if AlbumPhotoImage.shared.selectedImage.contains(cell.image_asset!) {
            let tempIndex:Int? = AlbumPhotoImage.shared.selectedImage.index(of: cell.image_asset!)
            AlbumPhotoImage.shared.selectedImage.remove(at: tempIndex!)
            self.updateSelectedPhotoInfo()
            self.collection_photo.reloadData()
            cell.setupSelected(isPhotoSelected: false, index: 0, indexPath:index)
        } else {
            AlbumPhotoImage.shared.selectedImage.append(cell.image_asset!)
            self.updateSelectedPhotoInfo()
            cell.setupSelected(isPhotoSelected: true, index: AlbumPhotoImage.shared.selectedImage.count - 1, indexPath:index)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previewVC:PreviewController =  UIStoryboard(name:"PhotoPickerStoryboard",bundle:Bundle.main).instantiateViewController(withIdentifier:"PreviewController") as! PreviewController
        previewVC.photoImages = self.photos
        previewVC.currentPage = indexPath.row
        previewVC.photosChangeHandle = {
            self.collection_photo.reloadData()
        }
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
    func updateSelectedPhotoInfo() {
        self.lb_num.isHidden = AlbumPhotoImage.shared.selectedImage.count == 0
        self.btn_preview.isUserInteractionEnabled = AlbumPhotoImage.shared.selectedImage.count > 0
        self.btn_send.isUserInteractionEnabled = AlbumPhotoImage.shared.selectedImage.count > 0
        self.btn_send.isSelected = AlbumPhotoImage.shared.selectedImage.count > 0
        self.btn_preview.isSelected = AlbumPhotoImage.shared.selectedImage.count > 0
        self.lb_num.text = "\(AlbumPhotoImage.shared.selectedImage.count)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

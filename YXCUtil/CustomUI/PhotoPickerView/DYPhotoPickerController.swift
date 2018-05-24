//
//  DYPhotoPickerController.swift
//  SelectPhoto
//
//  Created by 杨新财 on 2018/2/22.
//  Copyright © 2018年 杨新财. All rights reserved.
//

import UIKit
import Photos

class DYPhotoPickerController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var view_mask: UIView!
    @IBOutlet weak var view_content: UIView!
    
    @IBOutlet weak var collection_recentphoto: UICollectionView!
    @IBOutlet weak var btn_album: UIButton!
    @IBOutlet weak var btn_takePhoto: UIButton!
    @IBOutlet weak var collectionViewTop: NSLayoutConstraint!
        
    @IBOutlet weak var view_content_bottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DYPhotoPickerManager.shared.getPhotoSource()
        let pickerLayout:PickerCellViewLayout = PickerCellViewLayout()
        self.collection_recentphoto.setCollectionViewLayout(pickerLayout, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5) {
            self.view_content_bottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func takePhoto(_ sender: Any) {
        if DYPhotoPickerManager.shared.selectedPhotoData.count > 0 {
            DYPhotoPickerManager.shared.selectedComplete!(DYPhotoPickerManager.shared.selectedPhotoData)
            DYPhotoPickerManager.shared.dismissPicker(controller: self)
        } else {
            self.selectByCamera()
        }
    }
    @IBAction func openAlbum(_ sender: Any) {
        if DYPhotoPickerManager.shared.selectedPhotoData.count > 0 {
            DYPhotoPickerManager.shared.selectedComplete!(DYPhotoPickerManager.shared.selectedPhotoData)
            DYPhotoPickerManager.shared.dismissPicker(controller: self)
        } else {
            self.selectFromAlbum()
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.view_mask.isHidden = true
        self.dismiss(animated: true) {
            DYPhotoPickerManager.shared.resetCachedAssets()
        }
    }
    /**
     拍照获取
     */
    private func selectByCamera(){
        // todo take photo task
        
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if (authStatus == AVAuthorizationStatus.restricted || authStatus == AVAuthorizationStatus.denied){
            //无权限 做一个友好的提示
            let alertController:UIAlertController = UIAlertController.init(title: "请您设置允许APP访问您的相机->设置->隐私->相机", message: nil, preferredStyle: .alert)
            let confirm:UIAlertAction = UIAlertAction.init(title: "确定", style: .default) { (action) in
                
            }
            alertController.addAction(confirm)
            self.present(alertController, animated: true) {}
        } else {
            //调用相机的代码写在这里
            PhotoPickerManager.sharedPostImageView().presentPicker(with: self) { (imageAsset) in
                if imageAsset != nil {
                    DispatchQueue.main.async {
                        DYPhotoPickerManager.shared.selectedComplete!([imageAsset!])
                    }
                }
            }
        }
    }
    /**
     从相册中选择图片
     */
    private func selectFromAlbum(){
        
        PHPhotoLibrary.requestAuthorization { (status) -> Void in
            switch status {
            case .authorized:
                DispatchQueue.main.async() {
                    self.showLocalPhotoGallery()
                }
                break
            default:
                DispatchQueue.main.async() {
                    self.showNoPermissionDailog()
                }
                break
            }
        }
    }
    private func showLocalPhotoGallery(){
        self.view_mask.isHidden = true
        self.dismiss(animated: true, completion: {
            DYPhotoPickerManager.shared.showPhotoCollectionView()
        })
    }
    
    private func showNoPermissionDailog(){
        let alert = UIAlertController.init(title: nil, message: "没有打开相册的权限，请您设置允许APP访问您的相册", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func updateSelectedPhotoInfo() {
        if DYPhotoPickerManager.shared.selectedPhotoData.count > 0 {
            self.btn_album.setTitle("发送\(DYPhotoPickerManager.shared.selectedPhotoData.count)张照片", for: .normal)
            self.calculateSelectedImageData()
        } else {
            self.btn_album.setTitle("相册", for: .normal)
            self.btn_takePhoto.setTitle("拍摄", for: .normal)
        }
    }
    func calculateSelectedImageData() {
        var photoSize:String = ""
        var size:CGFloat = 0.0
        var singal:Int = 0
        for imageAsset in DYPhotoPickerManager.shared.selectedPhotoData {
            PHImageManager.default().requestImageData(for: imageAsset, options: nil) { (imageData, name, imageOrientation, info) in
                size = size + CGFloat((imageData?.count)!)/1000.0
                singal = singal + 1
                if singal == DYPhotoPickerManager.shared.selectedPhotoData.count {
                    if size > 1000 {
                        photoSize = String.init(format: "%.1fMB", size/1000.0)
                    } else {
                        photoSize = String.init(format: "%.1fKB", size)
                    }
                    self.btn_takePhoto.setTitle("发送\(DYPhotoPickerManager.shared.selectedPhotoData.count)张原图(共\(photoSize))", for: .normal)
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DYPhotoPickerManager.shared.assetsFetchResults.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:PhotoPickerCell  = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoPickerCell", for: indexPath) as! PhotoPickerCell
        let asset:PHAsset = DYPhotoPickerManager.shared.assetsFetchResults[indexPath.row]
        cell.image_asset = asset
        
        if DYPhotoPickerManager.shared.selectedPhotoData.contains(asset) {
            cell.setupSelected(isPhotoSelected: true, index: DYPhotoPickerManager.shared.selectedPhotoData.index(of: asset)!, indexPath:indexPath)
        } else {
            cell.setupSelected(isPhotoSelected: false, index: 0, indexPath:indexPath)
        }
        
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected_cell:PhotoPickerCell = collectionView.cellForItem(at: indexPath) as! PhotoPickerCell
        if DYPhotoPickerManager.shared.selectedPhotoData.contains(selected_cell.image_asset!) {
            let tempIndex:Int? = DYPhotoPickerManager.shared.selectedPhotoData.index(of: selected_cell.image_asset!)
            DYPhotoPickerManager.shared.selectedPhotoData.remove(at: tempIndex!)
            self.updateSelectedPhotoInfo()
            self.collection_recentphoto.reloadData()
            selected_cell.setupSelected(isPhotoSelected: false, index: 0, indexPath:indexPath)
            if DYPhotoPickerManager.shared.selectedPhotoData.count == 0 {
                self.superViewAnimate(isOriginalStatus: true, index: indexPath)
            }
        } else {
            if DYPhotoPickerManager.shared.selectedPhotoData.count >= PhotoConfig.max_selected_photo_num {
                self.present(showAlert(msg: "最多选择\(PhotoConfig.max_selected_photo_num)张图片"), animated: true, completion: nil)
            } else {
                if DYPhotoPickerManager.shared.selectedPhotoData.count == 0 {
                    self.superViewAnimate(isOriginalStatus: false, index: indexPath)
                }
                DYPhotoPickerManager.shared.selectedPhotoData.append(selected_cell.image_asset!)
                self.updateSelectedPhotoInfo()
                
                selected_cell.setupSelected(isPhotoSelected: true, index: DYPhotoPickerManager.shared.selectedPhotoData.count - 1, indexPath:indexPath)
            }
        }
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func superViewAnimate(isOriginalStatus:Bool, index:IndexPath) {
        
        if isOriginalStatus {
            UIView.animate(withDuration: 0.3, animations: {
                self.collectionViewTop.constant = isOriginalStatus ? 100 : 0
                self.view_content.layoutIfNeeded()
            }) { (animate) in
                self.collection_recentphoto.reloadData()
                self.collection_recentphoto.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            }
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.collectionViewTop.constant = isOriginalStatus ? 100 : 0
                self.view_content.layoutIfNeeded()
                self.collection_recentphoto.reloadData()
            }) { (animate) in
                
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

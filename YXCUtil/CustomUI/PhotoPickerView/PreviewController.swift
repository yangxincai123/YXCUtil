//
//  PreviewController.swift
//  SelectPhoto
//
//  Created by 杨新财 on 2018/2/26.
//  Copyright © 2018年 杨新财. All rights reserved.
//

import UIKit
import Photos

class PreviewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,PhotoPreviewCellDelegate {
    
    @IBOutlet weak var bottomBarBottom: NSLayoutConstraint!
    @IBOutlet weak var bottomBarHeight: NSLayoutConstraint!
    @IBOutlet weak var view_blue_dot: UIView!
    @IBOutlet weak var lb_original: UILabel!
    @IBOutlet weak var lb_num: UILabel!
    @IBOutlet weak var btn_send: UIButton!
    @IBOutlet weak var btn_selected: UIButton!
    
    @IBOutlet weak var collection_photo: UICollectionView!
    
    var photosChangeHandle:(() -> ())!
    var photoImages:[PHAsset] = [PHAsset]()
    var currentPage:Int = 0
    var isOnlyPreview:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.configNavigationBar()
        
        self.collection_photo.contentSize = CGSize(width: self.view.bounds.width * CGFloat(self.photoImages.count), height: self.view.bounds.height)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collection_photo.setContentOffset(CGPoint(x: CGFloat(self.currentPage) * self.view.bounds.width, y: 0), animated: false)
        
        let asset:PHAsset = self.photoImages[currentPage]
        self.btn_selected.isSelected = AlbumPhotoImage.shared.selectedImage.contains(asset)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.onImageSingleTap()
    }
    private func configNavigationBar(){
//        UIApplication.shared.statusBarStyle = .lightContent
//        self.navigationController?.navigationBar.barStyle = .black
//        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.bottomBarHeight.constant = isIphoneX() ? 74 : 40
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        UIApplication.shared.statusBarStyle = .default
//        self.navigationController?.navigationBar.barStyle = .default
//        self.navigationController?.navigationBar.tintColor = PhotoConfig.systemBlue
    }
    @IBAction func selectedAction(_ sender: Any) {
        self.btn_selected.isSelected = !self.btn_selected.isSelected
        if self.btn_selected.isSelected {
            AlbumPhotoImage.shared.selectedImage.append(self.photoImages[currentPage])
        } else {
            let asset:PHAsset = self.photoImages[currentPage]
            AlbumPhotoImage.shared.selectedImage.remove(at: AlbumPhotoImage.shared.selectedImage.index(of: asset)!)
        }
        self.photosChangeHandle()
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func sendAction(_ sender: Any) {
        DYPhotoPickerManager.shared.selectedComplete!(AlbumPhotoImage.shared.selectedImage)
        DYPhotoPickerManager.shared.dismissPicker(controller: self)
    }
    @IBAction func originalImageAction(_ sender: Any) {
        self.view_blue_dot.isHidden = !self.view_blue_dot.isHidden
        if !self.view_blue_dot.isHidden {
            self.calculateCurrentImageData()
        } else {
            self.lb_original.text = "原图"
        }
    }
    
    // MARK: -  collectionView dataSource delagate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoImages.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoPreviewCell", for: indexPath) as! PhotoPreviewCell
        cell.delegate = self
        let asset = self.photoImages[indexPath.row]
        cell.renderModel(asset: asset)

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.view.bounds.size
    }
    // MARK: -  Photo Preview Cell Delegate
    func onImageSingleTap() {
        let status = !(self.navigationController?.navigationBar.isHidden)!
        UIApplication.shared.setStatusBarHidden(status, with: .fade)
        self.navigationController?.setNavigationBarHidden(status, animated: true)
        UIView.animate(withDuration: 0.3) {
            self.bottomBarBottom.constant = status ? (isIphoneX() ? -74 : -40) : 0
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: -  scroll page
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let lastPage:Int = self.currentPage
        self.currentPage = Int(offset.x / self.view.bounds.width)
        if lastPage != self.currentPage {
            if self.view_blue_dot.isHidden {
                self.lb_original.text = "原图"
            } else {
                self.calculateCurrentImageData()
            }
            let asset:PHAsset = self.photoImages[currentPage]
            self.btn_selected.isSelected = AlbumPhotoImage.shared.selectedImage.contains(asset)
        }
    }
    func calculateCurrentImageData() {
        PHImageManager.default().requestImageData(for: self.photoImages[currentPage], options: nil) { (imageData, name, imageOrientation, info) in
            var photoSize:String = ""
            var size:CGFloat = 0.0
            size = size + CGFloat((imageData?.count)!)/1000.0
            if size > 1000 {
                photoSize = String.init(format: "%.1fMB", size/1000.0)
            } else {
                photoSize = String.init(format: "%.1fKB", size)
            }
            self.lb_original.text = "原图(\(photoSize))"
        }
    }
    
}

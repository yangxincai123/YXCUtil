//
//  SinglePreviewController.swift
//  SelectPhoto
//
//  Created by 杨新财 on 2018/3/31.
//  Copyright © 2018年 杨新财. All rights reserved.
//

import UIKit
import Photos

class SinglePreviewController: UIViewController, UIScrollViewDelegate {

    var image: PhotoImageModel?
    private var scrollView: UIScrollView?
    private var imageContainerView = UIView()
    private var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configView()
        if self.image != nil {
            self.renderModel(asset: (self.image?.data)!)
        }
    }
    
    func configView() {
        self.scrollView = UIScrollView(frame: self.view.bounds)
        self.scrollView!.bouncesZoom = true
        self.scrollView!.maximumZoomScale = 2.5
        self.scrollView!.isMultipleTouchEnabled = true
        self.scrollView!.delegate = self
        self.scrollView!.scrollsToTop = false
        self.scrollView!.showsHorizontalScrollIndicator = false
        self.scrollView!.showsVerticalScrollIndicator = false
        self.scrollView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.scrollView!.delaysContentTouches = false
        self.scrollView!.canCancelContentTouches = true
        self.scrollView!.alwaysBounceVertical = false
        self.view.addSubview(self.scrollView!)
        
        self.imageContainerView.clipsToBounds = true
        self.scrollView!.addSubview(self.imageContainerView)
        
        self.imageView.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        self.imageView.clipsToBounds = true
        self.imageContainerView.addSubview(self.imageView)
        
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(PhotoPreviewCell.singleTap(tap:)))
        let doubleTap = UITapGestureRecognizer.init(target: self, action: #selector(PhotoPreviewCell.doubleTap(tap:)))
        
        doubleTap.numberOfTapsRequired = 2
        singleTap.require(toFail: doubleTap)
        
        self.view.addGestureRecognizer(singleTap)
        self.view.addGestureRecognizer(doubleTap)
    }
    func renderModel(asset: PHAsset) {
        DYPhotoPickerManager.shared.getPhotoByMaxSize(asset: asset, height: self.view.bounds.width) { (image, info) -> Void in
            self.imageView.image = image
            self.resizeImageView()
        }
    }
    
    func resizeImageView() {
        self.imageContainerView.frame = CGRect(x:0, y:0, width: self.view.frame.width, height: self.imageContainerView.bounds.height)
        let image = self.imageView.image!
        
        
        if image.size.height / image.size.width > self.view.bounds.height / self.view.bounds.width {
            
            let height = floor(image.size.height / (image.size.width / self.view.bounds.width))
            var originFrame = self.imageContainerView.frame
            originFrame.size.height = height
            self.imageContainerView.frame = originFrame
        } else {
            var height = image.size.height / image.size.width * self.view.frame.width
            if height < 1 || height.isNaN {
                height = self.view.frame.height
            }
            height = floor(height)
            var originFrame = self.imageContainerView.frame
            originFrame.size.height = height
            self.imageContainerView.frame = originFrame
            self.imageContainerView.center = CGPoint(x:self.imageContainerView.center.x, y:self.view.bounds.height / 2)
        }
        
        if self.imageContainerView.frame.height > self.view.frame.height && self.imageContainerView.frame.height - self.view.frame.height <= 1 {
            
            var originFrame = self.imageContainerView.frame
            originFrame.size.height = self.view.frame.height
            self.imageContainerView.frame = originFrame
        }
        
        self.scrollView?.contentSize = CGSize(width: self.view.frame.width, height: max(self.imageContainerView.frame.height, self.view.frame.height))
        self.scrollView?.scrollRectToVisible(self.view.bounds, animated: false)
        self.scrollView?.alwaysBounceVertical = self.imageContainerView.frame.height > self.view.frame.height
        self.imageView.frame = self.imageContainerView.bounds
        
    }
    
    @objc func singleTap(tap:UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func doubleTap(tap:UITapGestureRecognizer) {
        if (self.scrollView!.zoomScale > 1.0) {
            // 状态还原
            self.scrollView!.setZoomScale(1.0, animated: true)
        } else {
            let touchPoint = tap.location(in: self.imageView)
            let newZoomScale = self.scrollView!.maximumZoomScale
            let xsize = self.view.frame.size.width / newZoomScale
            let ysize = self.view.frame.size.height / newZoomScale
            
            self.scrollView!.zoom(to: CGRect(x: touchPoint.x - xsize/2, y: touchPoint.y-ysize/2, width: xsize, height: ysize), animated: true)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageContainerView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = (scrollView.frame.width > scrollView.contentSize.width) ? (scrollView.frame.width - scrollView.contentSize.width) * 0.5 : 0.0;
        let offsetY = (scrollView.frame.height > scrollView.contentSize.height) ? (scrollView.frame.height - scrollView.contentSize.height) * 0.5 : 0.0;
        self.imageContainerView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

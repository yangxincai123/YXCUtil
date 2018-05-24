//
//  PhotoPickerView.swift
//  SelectPhoto
//
//  Created by 杨新财 on 2018/2/27.
//  Copyright © 2018年 杨新财. All rights reserved.
//

import UIKit
import Foundation
import Photos

enum ModelType {
    case button
    case image
}

protocol PhotoPickerViewDelegate: class {
    func imageDidSelected(image:PhotoImageModel)
    func imageRemoved(index:Int)
}

class PhotoPickerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var selectModel = [PhotoImageModel]()
    var containerView = UIView()
    weak var delegate:PhotoPickerViewDelegate?
    var triggerRefresh = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(self.containerView)
        self.checkNeedAddButton()
        self.renderView()
        
        if self.triggerRefresh {
            self.triggerRefresh = false
            self.updateView()
        }
    }
    
    private func checkNeedAddButton(){
        if self.selectModel.count < PhotoConfig.max_selected_photo_num && !hasButton() {
            selectModel.append(PhotoImageModel(type: ModelType.button, data: nil))
        }
    }
    
    private func hasButton() -> Bool{
        for item in self.selectModel {
            if item.type == ModelType.button {
                return true
            }
        }
        return false
    }
    func addImageModels(images:[PhotoImageModel]) {
        if self.selectModel.last != nil {
            if self.selectModel.last!.type == .button {
                self.selectModel.remove(at: self.selectModel.count-1)
            }
            self.selectModel = self.selectModel+images+[PhotoImageModel.init(type: .button, data: nil)]
        } else {
            self.selectModel = images
            self.selectModel.append(PhotoImageModel.init(type: .button, data: nil))
        }
        self.renderView()
    }
    func removeElement(element: PhotoImageModel?, atIndex:Int){
        if element != nil && self.selectModel.count > atIndex {
            self.selectModel.remove(at: atIndex)
            self.updateView()
            if let delegate = self.delegate {
                delegate.imageRemoved(index: atIndex)
            }
        }
    }
    
    private func updateView(){
        self.clearAll()
        self.checkNeedAddButton()
        self.renderView()
    }
    
    private func renderView(){
        
        if selectModel.count <= 0 {return;}
        
        let totalWidth = UIScreen.main.bounds.width
        let space:CGFloat = 10
        let lineImageTotal = 5
        
        let line = self.selectModel.count / lineImageTotal
        let lastItems = self.selectModel.count % lineImageTotal
        
        let lessItemWidth = (totalWidth - (CGFloat(lineImageTotal) + 1) * space)
        let itemWidth = lessItemWidth / CGFloat(lineImageTotal)
        
        for i in 0 ..< line {
            let itemY = CGFloat(i+1) * space + CGFloat(i) * itemWidth
            for j in 0 ..< lineImageTotal {
                let itemX = CGFloat(j+1) * space + CGFloat(j) * itemWidth
                let index = i * lineImageTotal + j
                self.renderItemView(itemX: itemX, itemY: itemY, itemWidth: itemWidth, index: index)
            }
        }
        
        // last line
        for i in 0..<lastItems{
            let itemX = CGFloat(i+1) * space + CGFloat(i) * itemWidth
            let itemY = CGFloat(line+1) * space + CGFloat(line) * itemWidth
            let index = line * lineImageTotal + i
            self.renderItemView(itemX: itemX, itemY: itemY, itemWidth: itemWidth, index: index)
        }
        
        let totalLine = ceil(Double(self.selectModel.count) / Double(lineImageTotal))
        let containerHeight = CGFloat(totalLine) * itemWidth + (CGFloat(totalLine) + 1) *  space
        self.containerView.frame = CGRect(x:0, y:0, width:totalWidth,  height:containerHeight)
    }
    
    private func renderItemView(itemX:CGFloat,itemY:CGFloat,itemWidth:CGFloat,index:Int){
        let itemModel = self.selectModel[index]
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x:itemX, y:itemY+10, width:itemWidth-10, height: itemWidth-10)
        button.backgroundColor = UIColor.red
        button.tag = index
        
        if itemModel.type == ModelType.button {
            button.backgroundColor = UIColor.clear
            button.addTarget(self, action: #selector(PhotoPickerView.eventAddImage), for: .touchUpInside)
            button.contentMode = .scaleAspectFit
            button.setImage(UIImage(named: "selectedPhoto"), for: UIControlState.normal)
            self.containerView.addSubview(button)
        } else {
            let deleteBtn:UIButton = UIButton.init(type: .custom)
            deleteBtn.frame = CGRect.init(x: itemX + itemWidth - 20, y: itemY, width: 20, height: 20)
            deleteBtn.tag = 1000+index
            deleteBtn.addTarget(self, action: #selector(PhotoPickerView.eventDeleteImage(button:)), for: .touchUpInside)
            deleteBtn.setImage(UIImage.init(named: "photoDelete"), for: .normal)
            
            button.addTarget(self, action: #selector(PhotoPickerView.eventPreview(button:)), for: .touchUpInside)
            
            if let asset = itemModel.data {
                let pixSize = UIScreen.main.scale * itemWidth
                PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: pixSize, height: pixSize), contentMode: PHImageContentMode.aspectFill, options: nil, resultHandler: { (image, info) -> Void in
                    if image != nil {
                        button.imageView?.contentMode = .scaleAspectFill
                        button.setImage(image, for: UIControlState.normal)
                        button.clipsToBounds = true
                    }
                })
            }
            self.containerView.addSubview(button)
            self.containerView.addSubview(deleteBtn)
        }
    }
    
    private func clearAll(){
        for subview in self.containerView.subviews {
            if let view =  subview as? UIButton {
                view.removeFromSuperview()
            }
        }
    }
    // MARK: -  button event 预览
    @objc func eventPreview(button:UIButton){
        if let delegate = self.delegate {
            delegate.imageDidSelected(image: self.selectModel[button.tag])
        }
        
    }
    // MARK: -  button event 添加
    @objc func eventAddImage() {
        DYPhotoPickerManager.shared.checkPermission { (res) in
            if res {
                DYPhotoPickerManager.shared.showPicker()
            }
        }
    }
    // MARK: -  button event 删除
    @objc func eventDeleteImage(button:UIButton) {
        self.removeElement(element: self.selectModel[button.tag%1000], atIndex: button.tag%1000)
        print(button.tag)
    }
    
    func onImageSelectFinished(images: [PHAsset]) {
        self.renderSelectImages(images: images)
    }
    
    private func renderSelectImages(images: [PHAsset]){
        for item in images {
            self.selectModel.insert(PhotoImageModel(type: ModelType.image, data: item), at: 0)
        }
        
        let total = self.selectModel.count;
        if total > PhotoConfig.max_selected_photo_num {
            for i in 0 ..< total {
                let item = self.selectModel[i]
                if item.type == .button {
                    self.selectModel.remove(at: i)
                    
                }
            }
        }
        self.renderView()
    }
    
    private func getModelExceptButton()->[PhotoImageModel]{
        var newModels = [PhotoImageModel]()
        for i in 0..<self.selectModel.count {
            let item = self.selectModel[i]
            if item.type != .button {
                newModels.append(item)
            }
        }
        return newModels
    }
    
}

struct PhotoImageModel: Equatable {
    var type: ModelType?
    var data: PHAsset?
    
    init(type: ModelType?,data:PHAsset?){
        self.type = type
        self.data = data
    }
    
    static func ==(lhs: PhotoImageModel, rhs: PhotoImageModel) -> Bool {
        return lhs.type == rhs.type && lhs.data == rhs.data
    }
}

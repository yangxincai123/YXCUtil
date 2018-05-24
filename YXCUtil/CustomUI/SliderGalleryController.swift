//
//  SliderGalleryController.swift
//  hangge_1314
//
//  Created by hangge on 2018/2/5.
//  Copyright © 2018年 hangge. All rights reserved.
//

import UIKit

//图片轮播组件代理协议
protocol SliderGalleryControllerDelegate{
    //获取数据源
    func galleryDataSource()->[OrgPdtModel]
    //获取内部scrollerView的宽高尺寸
    func galleryScrollerViewSize()->CGSize
}

//图片轮播组件控制器
class SliderGalleryController: UIViewController,UIScrollViewDelegate{
    //代理对象
    var delegate : SliderGalleryControllerDelegate!
    
    //屏幕宽度
    let kScreenWidth = UIScreen.main.bounds.size.width
    
    //当前展示的图片索引
    var currentIndex : Int = 0
    
    //数据源
    var dataSource : [OrgPdtModel]?
    
    //用于轮播的左中右三个image（不管几张图片都是这三个imageView交替使用）
    var leftView , middleView , rightView : GalleryView?
    
    //放置imageView的滚动视图
    var scrollerView : UIScrollView?
    
    //scrollView的宽和高
    var scrollerViewWidth : CGFloat?
    var scrollerViewHeight : CGFloat?
    
    //页控制器（小圆点）
    var pageControl : UIPageControl?
    
    //加载指示符（用来当iamgeView还没将图片显示出来时，显示的图片）
    var placeholderImage:UIImage!
    
    //自动滚动计时器
    var autoScrollTimer:Timer?
    
    //轮播视图图片边距
    var edge_left:CGFloat = 0.0
    var edge_top:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        //获取并设置scrollerView尺寸
        let size : CGSize = self.delegate.galleryScrollerViewSize()
        self.scrollerViewWidth = size.width
        self.scrollerViewHeight = size.height
        
        //获取数据
        self.dataSource =  self.delegate.galleryDataSource()
        //设置scrollerView
        self.configureScrollerView()
        //设置加载指示图片
        self.configurePlaceholder()
        //设置imageView
        self.configureGalleryView()
        //设置页控制器
        self.configurePageController()
        //设置自动滚动计时器
        self.configureAutoScrollTimer()
        
        self.view.backgroundColor = UIColor.black
    }
    
    //设置scrollerView
    func configureScrollerView(){
        self.scrollerView = UIScrollView(frame: CGRect(x: 0,y: 0,
                                    width: self.scrollerViewWidth!,
                                    height: self.scrollerViewHeight!))
        self.scrollerView?.backgroundColor = UIColor.white
        self.scrollerView?.delegate = self
        self.scrollerView?.contentSize = CGSize(width: self.scrollerViewWidth! * 3,
                                                height: self.scrollerViewHeight!)
        //滚动视图内容区域向左偏移一个view的宽度
        self.scrollerView?.contentOffset = CGPoint(x: self.scrollerViewWidth!, y: 0)
        self.scrollerView?.isPagingEnabled = true
        self.scrollerView?.bounces = false
        self.view.addSubview(self.scrollerView!)
        
    }
    
    //设置加载指示图片
    func configurePlaceholder(){
        placeholderImage = UIImage.init(named: "图片未出来")
    }
    
    //设置imageView
    func configureGalleryView(){
        self.leftView = GalleryView(frame: CGRect(x: 0, y: 0, width: self.scrollerViewWidth!, height: self.scrollerViewHeight!))
        self.leftView?.edge_left = self.edge_left
        self.leftView?.edge_top = self.edge_top
        self.leftView?.setupSubView()
        
        self.middleView = GalleryView(frame: CGRect(x: self.scrollerViewWidth!, y: 0, width: self.scrollerViewWidth!, height: self.scrollerViewHeight!))
        self.middleView?.edge_left = self.edge_left
        self.middleView?.edge_top = self.edge_top
        self.middleView?.setupSubView()
        
        self.rightView = GalleryView(frame: CGRect(x: 2*self.scrollerViewWidth!, y: 0, width: self.scrollerViewWidth!, height: self.scrollerViewHeight!))
        self.rightView?.edge_left = self.edge_left
        self.rightView?.edge_top = self.edge_top
        self.rightView?.setupSubView()
        
        self.scrollerView?.showsHorizontalScrollIndicator = false
        
        //设置初始时左中右三个imageView的图片（分别时数据源中最后一张，第一张，第二张图片）
        if(self.dataSource?.count != 0){
            resetImageViewSource()
        }
        
        self.scrollerView?.addSubview(self.leftView!)
        self.scrollerView?.addSubview(self.middleView!)
        self.scrollerView?.addSubview(self.rightView!)
    }
    
    //设置页控制器
    func configurePageController() {
        self.pageControl = UIPageControl(frame: CGRect(x: kScreenWidth/2-67,
                        y: self.scrollerViewHeight! - 67, width: 120, height: 20))
        self.pageControl?.numberOfPages = (self.dataSource?.count)!
        self.pageControl?.isUserInteractionEnabled = false
        self.view.addSubview(self.pageControl!)
    }
    
    //设置自动滚动计时器
    func configureAutoScrollTimer() {
        //设置一个定时器，每三秒钟滚动一次
        autoScrollTimer = Timer.scheduledTimer(timeInterval: 3, target: self,
                selector: #selector(SliderGalleryController.letItScroll),
                userInfo: nil, repeats: true)
    }
    
    //计时器时间一到，滚动一张图片
    @objc func letItScroll(){
        let offset = CGPoint(x: 2*scrollerViewWidth!, y: 0)
        self.scrollerView?.setContentOffset(offset, animated: true)
    }
    
    //每当滚动后重新设置各个imageView的图片
    func resetImageViewSource() {
        
        if self.dataSource?.count == 0 {
            return
        }
        
        //当前显示的是第一张图片
        if self.currentIndex == 0 {
            self.leftView?.imageView.sd_setImage(with: self.getImageURL(model: self.dataSource!.last!), placeholderImage: placeholderImage)
            self.leftView?.titleLabel.text = self.dataSource!.last!.name

            self.middleView?.imageView.sd_setImage(with: self.getImageURL(model: self.dataSource!.first!), placeholderImage: placeholderImage)
            self.middleView?.titleLabel.text = self.dataSource!.first!.name
            
            let rightImageIndex = (self.dataSource?.count)!>1 ? 1 : 0 //保护
            self.rightView?.imageView.sd_setImage(with: self.getImageURL(model: self.dataSource![rightImageIndex]), placeholderImage: placeholderImage)
            self.rightView?.titleLabel.text = self.dataSource![rightImageIndex].name
        }
            //当前显示的是最好一张图片
        else if self.currentIndex == (self.dataSource?.count)! - 1 {
            self.leftView?.imageView.sd_setImage(with: self.getImageURL(model: self.dataSource![self.currentIndex-1]), placeholderImage: placeholderImage)
            self.leftView?.titleLabel.text = self.dataSource![self.currentIndex-1].name

            self.middleView?.imageView.sd_setImage(with: self.getImageURL(model: self.dataSource!.last!), placeholderImage: placeholderImage)
            self.middleView?.titleLabel.text = self.dataSource!.last!.name

            self.rightView?.imageView.sd_setImage(with: self.getImageURL(model: self.dataSource!.first!), placeholderImage: placeholderImage)
            self.rightView?.titleLabel.text = self.dataSource!.first!.name
        }
            //其他情况
        else {
            self.leftView?.imageView.sd_setImage(with: self.getImageURL(model: self.dataSource![self.currentIndex-1]), placeholderImage: placeholderImage)
            self.leftView?.titleLabel.text = self.dataSource![self.currentIndex-1].name
            
            self.middleView?.imageView.sd_setImage(with: self.getImageURL(model: self.dataSource![self.currentIndex]), placeholderImage: placeholderImage)
            self.middleView?.titleLabel.text = self.dataSource![self.currentIndex].name
           
            self.rightView?.imageView.sd_setImage(with: self.getImageURL(model: self.dataSource![self.currentIndex+1]), placeholderImage: placeholderImage)
            self.rightView?.titleLabel.text = self.dataSource![self.currentIndex+1].name
        }
    }
    
    //scrollView滚动完毕后触发
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //获取当前偏移量
        let offset = scrollView.contentOffset.x
        
        if(self.dataSource?.count != 0){
            
            //如果向左滑动（显示下一张）
            if(offset >= self.scrollerViewWidth!*2){
                //还原偏移量
                scrollView.contentOffset = CGPoint(x: self.scrollerViewWidth!, y: 0)
                //视图索引+1
                self.currentIndex = self.currentIndex + 1
                
                if self.currentIndex == self.dataSource?.count {
                    self.currentIndex = 0
                }
            }
            
            //如果向右滑动（显示上一张）
            if(offset <= 0){
                //还原偏移量
                scrollView.contentOffset = CGPoint(x: self.scrollerViewWidth!, y: 0)
                //视图索引-1
                self.currentIndex = self.currentIndex - 1
                
                if self.currentIndex == -1 {
                    self.currentIndex = (self.dataSource?.count)! - 1
                }
            }
            
            //重新设置各个imageView的图片
            resetImageViewSource()
            //设置页控制器当前页码
            self.pageControl?.currentPage = self.currentIndex
        }
    }
    
    //手动拖拽滚动开始
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //使自动滚动计时器失效（防止用户手动移动图片的时候这边也在自动滚动）
        autoScrollTimer?.invalidate()
    }
    
    //手动拖拽滚动结束
    func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                  willDecelerate decelerate: Bool) {
        //重新启动自动滚动计时器
        configureAutoScrollTimer()
    }
    
    //重新加载数据
    func reloadData() {
        //索引重置
        self.currentIndex = 0
        //重新获取数据
        self.dataSource =  self.delegate.galleryDataSource()
        //页控制器更新
        self.pageControl?.numberOfPages = (self.dataSource?.count)!
        self.pageControl?.currentPage = 0
        //重新设置各个imageView的图片
        resetImageViewSource()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getImageURL(model:OrgPdtModel) -> URL {
        return URL.init(string: BaseFileURL+PdtPhotoImgPath+model.pdt_photo)!
    }
}
class GalleryView: UIView {
    
    var edge_left:CGFloat = 0.0
    var edge_top:CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var imageView:UIImageView!
    var titleLabel:UILabel!
    
    func setupSubView() {
        self.backgroundColor = UIColor.white
        
        self.imageView = UIImageView.init()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(self.edge_left)
            make.right.equalTo(self).offset(-self.edge_left)
            make.top.equalTo(self).offset(self.edge_top)
            make.bottom.equalTo(self).offset(-47)
        }
        
        self.titleLabel = UILabel()
        titleLabel.textColor = UIColor.ColorHex(hex: "#333333")
        titleLabel.backgroundColor = UIColor.white
        titleLabel.text = ""
        titleLabel.font = UIFont.systemFont(ofSize: 16.0)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.top.equalTo(imageView.snp.bottom)
        }
    }
    
}


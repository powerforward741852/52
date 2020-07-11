//
//  RanGuidePages.swift
//  RanGuidePages
//
//  Created by 浮生若梦 on 2017/5/15.
//  Copyright © 2017年 MysteryRan. All rights reserved.
//

import UIKit

class RanGuidePages: UIView, UIScrollViewDelegate {
    //图片数组
    fileprivate var imageDatas = [String]()
    
    //背景scrollerView
    fileprivate let scrollView = UIScrollView()
    
    //pageControl
    fileprivate let pageController = UIPageControl()
    
    //进入按钮
//    fileprivate let actionButton = UIButton()
    
    //跳过按钮
    fileprivate let skipBtn = UIButton()
    
    var timer:Timer?
    
    
    // 重写初始化方法
    init(frame: CGRect, images: [String]) {
        
        super.init(frame: frame)
        
        imageDatas = images
        
        //MARK: 初始化UI
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 初始化UI
    func initView() {
        
        //背景scrollView
        scrollView.frame = UIScreen.main.bounds
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(imageDatas.count), height: UIScreen.main.bounds.height)
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.white
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        
//        //pageController
        pageController.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 30, width: UIScreen.main.bounds.width, height: 10)
        pageController.numberOfPages = imageDatas.count
        pageController.currentPage = 0
        pageController.hidesForSinglePage = true
        pageController.pageIndicatorTintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        pageController.currentPageIndicatorTintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        addSubview(pageController)
        
        //内容
        for i in 0..<imageDatas.count {
            //里面的图片
            let imageName = imageDatas[i]
            let imgView = UIImageView.init()
            imgView.sd_setImage(with: URL(string: imageName ), placeholderImage:UIImage.init(named: "") )
            
            /*
            imgView.sd_setImage(with: URL(string: imageName ), placeholderImage: UIImage.init(named: ""), options: SDWebImageOptions.queryDiskSync) { (image, error, cacheType, imageUrl) in
                //存储到内存
                SDImageCache.shared().store(image, forKey: "launchAdImage", toDisk: true, completion: {
                    DLog("存储到硬盘")
                })
                switch cacheType{
                    case .none:
                    DLog("现在下载，没用缓存")
                    break;
                    case .disk:
                    DLog("磁盘缓存")
                    break;
                    case .memory:
                    DLog("内存缓存")
                    break;
                }
            }
            */
            imgView.frame = CGRect(x: UIScreen.main.bounds.width * CGFloat(i), y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            imgView.isUserInteractionEnabled = true
            scrollView.addSubview(imgView)
            
            //actionButton
            let actionButton = UIButton.init(type: .custom)
            actionButton.frame = CGRect(x: UIScreen.main.bounds.width  - 80, y: 44, width: 65, height: 35)
            //                actionButton.setBackgroundImage(#imageLiteral(resourceName: "guardBtnLayer.png"), for: .normal)
            actionButton.setTitle("跳过", for: .normal)
            actionButton.layer.cornerRadius = 2
            actionButton.layer.borderColor = kLightBlueColor.cgColor
            actionButton.layer.borderWidth = 0.5
            actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            actionButton.setTitleColor(kLightBlueColor, for: .normal)
            actionButton.addTarget(self, action: #selector(BtnClick), for: .touchUpInside)
            self.bringSubview(toFront: actionButton)
            imgView.addSubview(actionButton)
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector:#selector(self.scrollViewGoNext), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer!, forMode: RunLoopMode.defaultRunLoopMode)
        
        
    }
    
    @objc func scrollViewGoNext()  {
        if self.pageController.currentPage == (self.imageDatas.count - 1){
            self.BtnClick()
        }else{
            self.pageController.currentPage += 1
            self.scrollView.setContentOffset(CGPoint.init(x: kWidth * CGFloat(self.pageController.currentPage), y: 0), animated: true)
        }
    }
    
    
    //进入按钮点击事件
    @objc func BtnClick() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0.0
        }, completion: { (finish) in
            self.timer?.invalidate()
            self.timer = nil
            self.removeFromSuperview()
            NotificationCenter.default.post(name: NSNotification.Name.init("loadCurrentVersion"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name.init("launchActionV"), object: nil)
        })
    }
    
    //跳过按钮点击事件
    func skipGuard() {
        UIView.animate(withDuration: 2.0, animations: {
            self.alpha = 0.0
        }, completion: { (finish) in
            self.removeFromSuperview()
        })
    }
    
    
    //MARK UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageController.currentPage = Int((scrollView.contentOffset.x + UIScreen.main.bounds.width / 2.0) / UIScreen.main.bounds.width)
        if pageController.currentPage == imageDatas.count - 1 {
            skipBtn.isHidden = true
        } else {
            skipBtn.isHidden = false
        }
    }
}

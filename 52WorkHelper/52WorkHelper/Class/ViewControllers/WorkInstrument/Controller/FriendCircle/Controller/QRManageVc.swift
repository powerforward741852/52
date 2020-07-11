//
//  QRManageVc.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/15.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRManageVc: SuperVC {
    var  btnArr = [UIButton]()
    lazy var page: UIPageViewController = {
        let page = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: nil)
        page.delegate = self
        page.dataSource = self
         page.isDoubleSided = true
        return page
    }()
    
    lazy var titleView: UIView = {
        let titleView = UIView(frame:  CGRect(x: 0, y: Int(SafeAreaTopHeight), width: Int(kWidth), height: Int(AutoGetHeight(height: 49))))
        titleView.backgroundColor = UIColor.yellow
        return titleView
    }()
    lazy var lineView: UIView = {
        let lineView = UIView(frame:  CGRect(x: 0, y: Int(AutoGetHeight(height: 48)), width: Int(kWidth/3), height: Int(AutoGetHeight(height: 1))))
        lineView.backgroundColor = UIColor.red
        return lineView
    }()
    
    var VCDic = NSMutableArray(array: [])
    var currentPage : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "管理"
        let RightButton = UIButton(frame:  CGRect(x: 0, y: 0, width: 60, height: 30))
        RightButton.titleLabel?.font = kFontSize17
        RightButton.setTitle("领取礼物", for: UIControlState.normal)
        RightButton.addTarget(self, action: #selector(getPresent), for: UIControlEvents.touchUpInside)
        RightButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        RightButton.sizeToFit()
        RightButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: -7)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: RightButton)
        view.addSubview(titleView)
        //btnView
        initBtns()
        //pageview
        initVcs()
        currentPage = 0
        
        view.backgroundColor = UIColor.white
        self.addChildViewController(page)
        view.addSubview(page.view)
        page.setViewControllers( [VCDic.firstObject as! UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        (btnArr as NSArray).mas_distributeViews(along: MASAxisType.horizontal, withFixedSpacing: 0, leadSpacing: 0, tailSpacing: 0)
        (btnArr as NSArray).mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(titleView.mas_top)
            make?.width.mas_equalTo()(kWidth/3)
            make?.height.mas_equalTo()(AutoGetHeight(height: 49))
        }
        
        page.view.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(self.view)
            make?.right.mas_equalTo()(self.view)
            make?.top.mas_equalTo()(self.titleView.mas_bottom)
            make?.bottom.mas_equalTo()(self.view.mas_bottom)?.setOffset(0)
        }
        
        
    }
    
    func initBtns(){
        
        let btn1 = UIButton(frame:  CGRect(x: 0, y: 0, width: kWidth/3, height: AutoGetHeight(height: 49)))
        btn1.addTarget(self, action: #selector(jumpVC(sender:)), for: UIControlEvents.touchUpInside)
        btn1.setTitleColor(kColorRGB(r: 44, g: 160, b: 255), for: .normal)
        btn1.setTitle("收到的", for: UIControlState.normal)
        btn1.titleLabel?.font = kFontSize15
        btn1.tag = 1
        titleView.addSubview(btn1)
        
        let btn2 = UIButton(frame:  CGRect(x: 0, y: 0, width: kWidth/3, height: AutoGetHeight(height: 49)))
        btn2.addTarget(self, action: #selector(jumpVC(sender:)), for: UIControlEvents.touchUpInside)
        btn2.setTitleColor(kColorRGB(r: 44, g: 160, b: 255), for: .normal)
        btn2.setTitle("发送的", for: UIControlState.normal)
        btn2.titleLabel?.font = kFontSize15
        btn2.tag = 2
        titleView.addSubview(btn2)
        
        let btn3 = UIButton(frame:  CGRect(x: 0, y: 0, width: kWidth/3, height: AutoGetHeight(height: 49)))
        btn3.addTarget(self, action: #selector(jumpVC(sender:)), for: UIControlEvents.touchUpInside)
        btn3.setTitleColor(kColorRGB(r: 44, g: 160, b: 255), for: .normal)
        btn3.setTitle("我的动态", for: UIControlState.normal)
        btn3.titleLabel?.font = kFontSize15
        btn3.tag = 3
        titleView.addSubview(btn3)
        
        btnArr.append(btn1)
        btnArr.append(btn2)
        btnArr.append(btn3)
        
        titleView.addSubview(lineView)
        
        
       
    }
    
    func initVcs(){
        let vc1 = QRWorkmateCircleVC()
        vc1.btn1.setTitle("1", for: UIControlState.normal)
        VCDic.add(vc1)
        
        let vc2 = QRWorkmateCircleVC()
        vc2.btn1.setTitle("2", for: UIControlState.normal)
        VCDic.add(vc2)
        
        let vc3 = QRWorkmateCircleVC()
        vc3.btn1.setTitle("3", for: UIControlState.normal)
        VCDic.add(vc3)
    }

    @objc func getPresent(){
        let reflash = QRGetPresentVC()
        self.navigationController?.pushViewController(reflash, animated: true)
    }
    
    @objc func jumpVC(sender:UIButton){
        if (sender.tag-1) > currentPage{
            page.setViewControllers( [VCDic[sender.tag-1] as! UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
            
        }else if  (sender.tag-1) < currentPage{
            page.setViewControllers( [VCDic[sender.tag-1] as! UIViewController], direction: UIPageViewControllerNavigationDirection.reverse, animated: true, completion: nil)
        }
           currentPage = sender.tag-1
        UIView.animate(withDuration: 0.3) {
            self.lineView.frame =  CGRect(x: CGFloat(self.currentPage)*kWidth/3, y: AutoGetHeight(height: 48), width: kWidth/3, height: AutoGetHeight(height: 1))
        }
        
    }
}


extension QRManageVc : UIPageViewControllerDelegate,UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let index = VCDic.index(of: viewController)
        print(index)
        currentPage = index
        UIView.animate(withDuration: 0.15) {
            self.lineView.frame =  CGRect(x: CGFloat(index)*kWidth/3, y: AutoGetHeight(height: 48), width: kWidth/3, height: AutoGetHeight(height: 1))
        }
        if index <= 0 {
            return nil
        }
        
        return VCDic[index-1] as? UIViewController
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let index = VCDic.index(of: viewController)
         print(index)
        currentPage = index
        UIView.animate(withDuration: 0.15) {
            self.lineView.frame =  CGRect(x: CGFloat(index)*kWidth/3, y: AutoGetHeight(height: 48), width: kWidth/3, height: AutoGetHeight(height: 1))
        }
        if index >= VCDic.count-1 {
            return nil
        }
        return VCDic[index+1] as? UIViewController
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
      //  let index = VCDic.index(of: previousViewControllers.first)

    }
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
       // let index = VCDic.index(of: pendingViewControllers.first)
 
    }
}

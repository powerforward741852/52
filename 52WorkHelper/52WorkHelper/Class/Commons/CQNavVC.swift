//
//  CQNavVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/19.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQNavVC: UINavigationController {

    var popDelegate:UIGestureRecognizerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//
//        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
       // navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        let img = imageWithColor(color: kfilterBackColor, size: CGSize(width: kWidth, height: 0.5))
        navigationBar.shadowImage = img
        navigationBar.backgroundColor = UIColor.white
        navigationBar.barTintColor = UIColor.white
        self.popDelegate = self.interactivePopGestureRecognizer?.delegate
        self.delegate = self
    }

}

extension CQNavVC:UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        //实现滑动返回功能
        //清空滑动返回手势的代理就能实现
        if viewController == self.viewControllers[0] {
            self.interactivePopGestureRecognizer!.delegate = self.popDelegate
        }
        else {
            self.interactivePopGestureRecognizer!.delegate = nil
        }
        
    }
}

//
//  MainTabbarController.swift
//  LSByCQH
//
//  Created by chenqihang on 2017/10/20.
//  Copyright © 2017年 chenqihang. All rights reserved.
//

import UIKit

class MainTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initTabbar()
    }

    func initTabbar()  {
      
       // let vc1 = QRScrollIndexViewController()
        let vc1 = CQIndexVC()
        //let vc1 = QRIndexVC()
//        let vc2 = WorkInstrumentVC()
        let vc2 = QRWorkInstrumentVC()
        
       //let vc3 = AddressBookVC()
        let vc3 = QRAddressBookVC()
        vc3.toType = .normal
        let vc4 = PersonVC()
        
        let views = [vc1,vc2,vc3,vc4]
        let viewControllers = NSMutableArray.init()
        
        for vc in views {
            let nav = CQNavVC.init(rootViewController: vc)
            viewControllers.add(nav)
            setTabBarItemStyle(tabbar: nav.tabBarItem)
        }
        
        let titleArr = ["首页","工作台","通讯录","我的"]
        let imageArr = ["tabbar_0","tabbar_1","tabbar_2","tabbar_3"]
        let selectImgArr = ["tabbarS_0","tabbarS_1","tabbarS_2","tabbarS_3"]
        
        for i in 0..<views.count {
            let nav:CQNavVC = viewControllers[i] as! CQNavVC
            nav.tabBarItem = UITabBarItem.init(title: titleArr[i], image: UIImage.init(named: imageArr[i])?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage.init(named: selectImgArr[i])?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
            nav.tabBarItem.tag = i
            
        }
        
        self.delegate = self
        self.viewControllers = viewControllers as? [UIViewController]
        self.tabBar.tintColor = kLightBlueColor
        self.tabBar.shadowImage = UIImage.init(named: "")
        self.tabBarController?.view.backgroundColor = UIColor.lightGray
        
        
    }
    
    func setTabBarItemStyle(tabbar:UITabBarItem) -> Void {
        let color = UIColor.init(red: 87, green: 87, blue: 87, alpha: 1)
        let colorSelect = kLightBlueColor
        let font = UIFont.systemFont(ofSize: 11)
        let dic = [NSAttributedStringKey.foregroundColor : color,NSAttributedStringKey.font:font]
        let selectDic = [NSAttributedStringKey.foregroundColor : colorSelect,NSAttributedStringKey.font:font]
        
        tabbar.setTitleTextAttributes(dic, for: UIControlState.normal)
        tabbar.setTitleTextAttributes(selectDic, for: UIControlState.selected)
    }
}

extension MainTabbarController:UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = tabBarController.viewControllers?.index(of: viewController)
        let user = STUserTool.account()
        if 3 == index {
            if user.userName.count < 1{
                let vc = LoginVC.init()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
}

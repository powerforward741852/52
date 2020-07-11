//
//  SuperVC.swift
//  LSByCQH
//
//  Created by chenqihang on 2017/10/20.
//  Copyright © 2017年 chenqihang. All rights reserved.
//

import UIKit


class SuperVC: UIViewController {

    var loadingAndRefreshView:LoadingAndRefreshView?
    var loadingView:UIView?
    var activityIndicator:UIActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.backgroundColor = UIColor.white
        
        if (self.navigationItem.leftBarButtonItem == nil) {
            if self.isTabbarRoot() {
                self.navigationItem.leftBarButtonItem = nil
            }else {
               
                self.navigationItem.leftBarButtonItem = self.barBackButton()
                
            }
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)]
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if self.isTabbarRoot() {
            self.hidesBottomBarWhenPushed = true
        }else{
            self.hidesBottomBarWhenPushed = true
        }
        
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if self.isTabbarRoot() {
            self.hidesBottomBarWhenPushed = false
        }else{
            self.hidesBottomBarWhenPushed = true
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for v in self.view.subviews{
            if v is UITabBar{
                view.frame = CGRect.init(x: v.frame.origin.x, y: self.view.bounds.size.height - 49, width: v.frame.size.width, height: 49)
            }
        }
    }
    
    func isTabbarRoot() -> Bool {
        if self.navigationController?.viewControllers.first == self {
            return true
        }
        return false
    }
    
    
    //MARK: 导航左按钮
    func barBackButton() -> UIBarButtonItem {
        return self.barBackButtonWithImg(image: UIImage.init(named: "blue_nav_arrow")!,color: UIColor.colorWithHexString(hex: "#20afff"))
    }
    
    func barBackWhiteButton() -> UIBarButtonItem {
        return self.barBackButtonWithImg(image: UIImage.init(named: "back_white_icon")!, color: UIColor.white)
    }
    
    
    func barBackBlackButton() -> UIBarButtonItem {
        return self.barBackButtonWithImg(image: UIImage.init(named: "nav_bt_back")!, color: UIColor.black)
    }
    
    
    func barBackButtonWithImg(image:UIImage,color:UIColor) -> UIBarButtonItem {
        var buttonFrame:CGRect?
        buttonFrame = CGRect.init(x: 0, y: 0, width: 60, height: image.size.height)
        
        
        let button = UIButton.init(frame: buttonFrame!)
        button.addTarget(self, action: #selector(backToSuperView), for: UIControlEvents.touchUpInside)
        button.setImage(image, for: .normal)
        button.accessibilityLabel = "back"
        button.setTitle("返回", for: .normal)
        button.titleLabel?.font = kFontSize17
        button.setTitleColor(color, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -2, bottom: 0, right: 2)
        button.imageEdgeInsets = UIEdgeInsets(top: 2, left: -5, bottom: 2, right: 5)
        let item = UIBarButtonItem.init(customView: button)
        return item
    }
    
    @objc func backToSuperView()  {
        self.view.endEditing(true)
        
        if self.navigationController?.viewControllers.first == self {
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK 导航右按钮
    func rightButtonWithImg(image:UIImage) -> UIBarButtonItem {
        var buttonFrame:CGRect?
        buttonFrame = CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        
        let button = UIButton.init(frame: buttonFrame!)
        button.addTarget(self, action: #selector(rightItemClick), for: UIControlEvents.touchUpInside)
        button.setImage(image, for: .normal)
        let item = UIBarButtonItem.init(customView: button)
        return item
    }
    
    @objc func rightItemClick()  {
        self.view.endEditing(true)
    }
    
    //MARK 加载底层失败view
    func addLoadingView()  {
        if self.loadingAndRefreshView == nil{
            self.loadingAndRefreshView = LoadingAndRefreshView.init(frame: self.view.bounds)
            self.loadingAndRefreshView?.delegate = self
        }
        
        if self.loadingAndRefreshView == nil {
            self.view.addSubview(self.loadingAndRefreshView!)
        }
        
        self.view.sendSubview(toBack: self.loadingAndRefreshView!)
    }
    
    
    func loadDataStart()  {
        self.addLoadingView()
        self.loadingAndRefreshView?.setLoadingState()
    }
    
    func loadingDataSuccess()  {
        if self.loadingAndRefreshView?.superview != nil{
            self.loadingAndRefreshView?.removeFromSuperview()
        }
    }
    
    func loadingDataFail()  {
        self.addLoadingView()
        self.loadingAndRefreshView?.setFailedState()
        self.view.bringSubview(toFront: self.loadingAndRefreshView!)
    }
    
    func loadingDataBlank()  {
        self.addLoadingView()
    }
    
    func loadingDataBlankWithTitle(title:String)  {
        self.addLoadingView()
    }
    
    //MARK:转菊花效果
    func addActivityIndicator()  {
        if self.loadingView == nil{
            self.loadingView = UIView.init(frame: CGRect.init(x: self.view.center.x - 30, y: self.view.center.y - 30, width: 60, height: 60))
            self.loadingView?.backgroundColor = UIColor.black
            self.loadingView?.layer.cornerRadius = 6
            self.view.addSubview(self.loadingView!)
            self.activityIndicator = UIActivityIndicatorView.init()
            activityIndicator?.color = UIColor.white
            activityIndicator?.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
            self.loadingView?.addSubview(self.activityIndicator!)
        }
    }
    
    func loadingPlay()  {
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        self.view.isUserInteractionEnabled = false
        self.loadingView?.isHidden = false
        self.addActivityIndicator()
        self.view.bringSubview(toFront: self.loadingView!)
        self.activityIndicator?.startAnimating()
    }
    
    func loadingSuccess()  {
        self.activityIndicator?.stopAnimating()
        self.loadingView?.isHidden = true
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
        self.view.isUserInteractionEnabled = true
    }
    
}

extension SuperVC:LoadingAndRefreshViewDelegate{
    func refreshClick() {
        
    }
}




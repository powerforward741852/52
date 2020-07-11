//
//  QRCateManageVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/18.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRCateManageVC: SuperVC {
    var currentIndex = 0
    var vcDic = [Int:UIViewController]()
    lazy var categoryView : JXCategoryDotView = {
        let categoryView = JXCategoryDotView(frame:  CGRect(x: 0, y: SafeAreaTopHeight, width: kWidth, height: AutoGetHeight(height: 49)))
        categoryView.titles = ["收到的","发送的","我的动态"]
        categoryView.dotStates = [false,false,false]
        categoryView.averageCellSpacingEnabled = true
       // categoryView.cellWidth = kWidth/3
        let line = JXCategoryIndicatorLineView()
        line.indicatorLineWidth = kWidth/3-30
        line.indicatorLineViewHeight = 2
        line.indicatorLineViewColor = kBlueC
        categoryView.indicators = [line]
        categoryView.titleSelectedColor = kBlueC
        categoryView.layer.contents = UIImage(named: "recty")?.cgImage
        categoryView.delegate = self
        categoryView.defaultSelectedIndex = 0
        return categoryView
    }()
    
    lazy var myScroll : UIScrollView = {
        let myScroll = UIScrollView(frame:  CGRect(x: 0, y: SafeAreaTopHeight+AutoGetHeight(height: 49), width: kWidth, height: kHeight-SafeAreaTopHeight-AutoGetHeight(height: 49)))
        myScroll.delegate = self
        myScroll.isPagingEnabled = true
        myScroll.bounces = false
       // myScroll.showsHorizontalScrollIndicator = false
        myScroll.contentSize = CGSize(width: kWidth*3, height: kHeight-SafeAreaTopHeight-AutoGetHeight(height: 49))
        self.automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            myScroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            //低于 iOS 9.0
        }
        return myScroll
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "管理"
        view.backgroundColor = UIColor.white
        view.addSubview(myScroll)
        view.addSubview(categoryView)
        self.categoryView.contentScrollView = myScroll;
        showWithIndex(index: 0)
         let RightButton = UIButton(frame:  CGRect(x: 0, y: 0, width: 60, height: 30))
        RightButton.titleLabel?.font = kFontSize15
        RightButton.setTitle("领取礼物", for: UIControlState.normal)
        RightButton.addTarget(self, action: #selector(getPresent), for: UIControlEvents.touchUpInside)
        RightButton.setTitleColor(kBlueC, for: UIControlState.normal)
        RightButton.sizeToFit()
        RightButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: -7)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: RightButton)
       
        
        
    }
    deinit {
    }
    @objc func getPresent(){
        let reflash = QRGetPresentVC()
        self.navigationController?.pushViewController(reflash, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (self.categoryView.selectedIndex == 0)
    }
    func showWithIndex(index:Int) {
        if vcDic[index] != nil{
            
        }else{
            let friend = QRManageDetailVc()
            friend.type = index
            friend.rootNav = self
            friend.view.frame = CGRect(x: CGFloat(index)*kWidth, y: 0, width: kWidth, height: kHeight-SafeAreaTopHeight-AutoGetHeight(height: 49))
            friend.table.frame =  CGRect(x: kLeftDis, y: 0, width: kHaveLeftWidth, height: kHeight-SafeAreaTopHeight-AutoGetHeight(height: 49))
            self.myScroll.addSubview(friend.view)
            vcDic[index] = friend
        }
    }
   

}
extension QRCateManageVC:JXCategoryViewDelegate{
    func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {
         self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (self.categoryView.selectedIndex == 0)
        self.showWithIndex(index: index)
    }
    func categoryView(_ categoryView: JXCategoryBaseView!, scrollingFromLeftIndex leftIndex: Int, toRightIndex rightIndex: Int, ratio: CGFloat) {
        
    }
}
extension QRCateManageVC:UIScrollViewDelegate{
 
}

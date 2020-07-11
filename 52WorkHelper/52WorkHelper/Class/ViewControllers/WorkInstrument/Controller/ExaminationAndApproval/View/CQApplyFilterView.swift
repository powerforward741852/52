//
//  CQApplyFilterView.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/7/8.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol CQFilterSubmitDelegate : NSObjectProtocol{
    func loadNewData(finish:Bool,businessName:String)
}

class CQApplyFilterView: UIView {

    var levelOneTitle = ""
    var leverlTwoTitle = ""
    var levelOneArray = [String]()
    var levelTwoArray = [String]()
    weak var submitDelegate:CQFilterSubmitDelegate?
    var lastOneSelect:CQApplyFilterCell?
    var lastTwoSelect:CQApplyFilterCell?
    var currentOneSelect:CQApplyFilterCell?
    var currentTwoSelect:CQApplyFilterCell?
    // 重写初始化方法
    init(frame: CGRect, levelOneTitle: String,leverlTwoTitle:String,levelOneArray:[String],levelTwoArray:[String]) {
        
        super.init(frame: frame)
        
        self.levelOneTitle = levelOneTitle
        self.leverlTwoTitle = leverlTwoTitle
        self.levelOneArray = levelOneArray
        self.levelTwoArray = levelTwoArray
        
        //MARK: 初始化UI
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        self.addSubview(self.bgView)
        self.bgView.addSubview(self.levelOneTitleLab)
        self.bgView.addSubview(self.attendPersonView)
        self.attendPersonView.addSubview(self.collectionView)
        self.bgView.addSubview(self.levelTwoTitleLab)
        self.bgView.addSubview(self.levelTwoView)
        self.levelTwoView.addSubview(self.twoCollectionView)
        self.bgView.addSubview(self.submitBtn)
        
    }
    
    @objc func submitClick() {
        let index = self.collectionView.indexPath(for: self.currentOneSelect!)
        var finishStatues:Bool?
        if  index?.item == 0 {
            finishStatues = true
        }else if  index?.item == 1 {
            finishStatues = true
        }else if  index?.item == 2 {
            finishStatues = false
        }
        let twoIndex = self.twoCollectionView.indexPath(for: self.currentTwoSelect!)
        if self.submitDelegate != nil{
            self.submitDelegate?.loadNewData(finish: finishStatues!, businessName: self.levelTwoArray[(twoIndex?.item)!])
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (finished:Bool) in
            self.removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        let point = touch.location(in: self)
        if point.x < self.bgView.frame.origin.x || point.x > self.bgView.frame.origin.x || point.y < self.bgView.frame.origin.y || point.y > self.bgView.frame.origin.y {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }) { (finished:Bool) in
                self.removeFromSuperview()
            }
        }
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 40) * CGFloat(self.levelOneArray.count/3 + 1) + AutoGetHeight(height: 40) * CGFloat(self.levelTwoArray.count/3 + 1) + AutoGetHeight(height: 150)))
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    
    lazy var levelOneTitleLab: UILabel = {
        let levelOneTitleLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 12), width: kHaveLeftWidth, height: AutoGetHeight(height: 15)))
        levelOneTitleLab.text = self.levelOneTitle
        levelOneTitleLab.textColor = UIColor.black
        levelOneTitleLab.textAlignment = .left
        levelOneTitleLab.font = kFontSize15
        return levelOneTitleLab
    }()
    
    lazy var attendPersonView: UIView = {
        let attendPersonView = UIView.init(frame: CGRect.init(x: 0, y:self.levelOneTitleLab.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 40) * CGFloat(self.levelOneArray.count/3)))
        attendPersonView.backgroundColor = UIColor.white
        return attendPersonView
    }()

    
    
    lazy var collectionView: UICollectionView = {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width: (kHaveLeftWidth - AutoGetWidth(width: 25))/3, height: AutoGetHeight(height: 30))
        layOut.minimumLineSpacing = 0
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        //        layOut.headerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 38))
        //        layOut.footerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 11))
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 5), width: kHaveLeftWidth, height: AutoGetHeight(height: 30) * CGFloat(self.levelOneArray.count/3 )), collectionViewLayout: layOut)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.tag = 1000
        collectionView.register(CQApplyFilterCell.self, forCellWithReuseIdentifier: "CQApplyFilterCellId")
        return collectionView
    }()
    
    lazy var levelTwoTitleLab: UILabel = {
        let levelTwoTitleLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.attendPersonView.bottom + AutoGetHeight(height: 12), width: kHaveLeftWidth, height: AutoGetHeight(height: 15)))
        levelTwoTitleLab.text = self.leverlTwoTitle
        levelTwoTitleLab.textColor = UIColor.black
        levelTwoTitleLab.textAlignment = .left
        levelTwoTitleLab.font = kFontSize15
        return levelTwoTitleLab
    }()
    
    lazy var levelTwoView: UIView = {
        let levelTwoView = UIView.init(frame: CGRect.init(x: 0, y:self.levelTwoTitleLab.bottom + AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 40) * CGFloat(self.levelTwoArray.count/3 + 1)))
        levelTwoView.backgroundColor = UIColor.white
        return levelTwoView
    }()
    
    
    
    lazy var twoCollectionView: UICollectionView = {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width: (kHaveLeftWidth - AutoGetWidth(width: 25))/3 , height: AutoGetHeight(height: 30))
        //layOut.minimumLineSpacing = 13
        //layOut.minimumInteritemSpacing = 10
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        //        layOut.headerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 38))
        //        layOut.footerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 11))
        
        let twoCollectionView = UICollectionView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 5), width: kHaveLeftWidth, height: AutoGetHeight(height: 40) * CGFloat(self.levelTwoArray.count/3 + 1)), collectionViewLayout: layOut)
        twoCollectionView.backgroundColor = UIColor.white
        twoCollectionView.delegate = self
        twoCollectionView.dataSource = self
        twoCollectionView.tag = 1001
        twoCollectionView.register(CQApplyFilterCell.self, forCellWithReuseIdentifier: "CQApplyFilterCellId")
        return twoCollectionView
    }()
    
    lazy var submitBtn: UIButton = {
        let submitBtn = UIButton.init(type: .custom)
        submitBtn.frame = CGRect.init(x: kLeftDis, y: self.levelTwoView.bottom + AutoGetHeight(height: 20), width: kHaveLeftWidth, height: AutoGetHeight(height: 49))
        submitBtn.backgroundColor = kLightBlueColor
        submitBtn.setTitle("确定", for: .normal)
        submitBtn.setTitleColor(UIColor.white, for: .normal)
        submitBtn.addTarget(self, action: #selector(submitClick), for: .touchUpInside)
        return submitBtn
    }()
    
}

// MARK: - 代理

extension CQApplyFilterView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if 1000 == collectionView.tag{
            return self.levelOneArray.count
        }
        return self.levelTwoArray.count
    }
    
}

extension CQApplyFilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQApplyFilterCellId", for: indexPath) as! CQApplyFilterCell
        if 1001 == collectionView.tag{
            cell.nameLab.text = self.levelTwoArray[indexPath.item]
            if indexPath.item == 0{
                self.currentTwoSelect = cell
            }
            
        }else if 1000 == collectionView.tag{
            cell.nameLab.text = self.levelOneArray[indexPath.item]
            if indexPath.item == 0{
                self.currentOneSelect = cell
            }
        }
        
        if indexPath.item == 0{
            cell.nameLab.textColor = kBlueC
            cell.backgroundColor = kfilterBlueColor
            if 1000 == collectionView.tag{
                lastOneSelect = cell
            }else if 1001 == collectionView.tag{
                lastTwoSelect = cell
            }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if 1000 == collectionView.tag{
            let cell = collectionView.cellForItem(at: indexPath) as! CQApplyFilterCell
            cell.nameLab.textColor = kBlueC
            cell.backgroundColor = kfilterBlueColor
            self.currentOneSelect = cell
            lastOneSelect?.nameLab.textColor = UIColor.black
            lastOneSelect?.backgroundColor = kfilterBackColor
            lastOneSelect = cell
        }else if 1001 == collectionView.tag{
            let cell = collectionView.cellForItem(at: indexPath) as! CQApplyFilterCell
            cell.nameLab.textColor = kBlueC
            cell.backgroundColor = kfilterBlueColor
            self.currentTwoSelect = cell
            lastTwoSelect?.nameLab.textColor = UIColor.black
            lastTwoSelect?.backgroundColor = kfilterBackColor
            lastTwoSelect = cell
        }
    }
}

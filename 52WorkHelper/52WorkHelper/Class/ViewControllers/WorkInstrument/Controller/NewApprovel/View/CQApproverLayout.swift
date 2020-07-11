//
//  CQApproverLayout.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/10/22.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit

class CQApproverLayout: TGLinearLayout {

    var curName = ""
    var type = ""
    var curTitle = ""
    var prompt = ""
    var required = false
    var dataArray = [CQCopyForModel]()
    var collectionHeight:CGFloat! = AutoGetHeight(height: 75)
    var actionLayout:TGLinearLayout!
    
    convenience init(orientation: TGOrientation,name:String,type:String,title:String,prompt:String,require:Bool,dataArray:[CQCopyForModel]) {
        self.init(frame: CGRect.zero, orientation: orientation, name: name, type: type, title: title, prompt: prompt, require: require,dataArray:dataArray)
        
    }
    
    init(frame: CGRect, orientation: TGOrientation,name:String,type:String,title:String,prompt:String,require:Bool,dataArray:[CQCopyForModel]) {
        super.init(frame: frame, orientation: orientation)
        
        self.actionLayout = TGLinearLayout(.vert)
        actionLayout.tg_width.equal(.wrap)
        actionLayout.tg_height.equal(.wrap)
        self.addSubview(actionLayout)
        
        self.tg_height.equal(.wrap)
        self.tg_width.equal(kWidth)
        self.curName = name
        self.type = type
        self.curTitle = title
        self.prompt = prompt
        self.required = require
        self.dataArray = dataArray
        
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()  {
        self.actionLayout.addSubview(self.addTitleLayout())
        self.actionLayout.addSubview(self.addCollectionViewContentLayout(height: self.collectionHeight))
    }
    
    
}

//layout
extension CQApproverLayout{
    //collectionView
    internal func addCollectionViewContentLayout(height:CGFloat) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        
        
        wrapContentLayout.addSubview(self.addCollectionView(leftDis: kLeftDis, delegate: self, dataSource: self,height:height))
        return wrapContentLayout
    }
    
    //标题
    internal func addTitleLayout() -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(kWidth)
        wrapContentLayout.addSubview(self.addxingLable())
        wrapContentLayout.addSubview(self.addTitleLable(title: self.curTitle))
        
        return wrapContentLayout
    }
    
}


// Mark 整个界面可能用到的控件
extension CQApproverLayout{
    
    //*号 在非必填时 隐藏
    @objc internal func addxingLable() -> UILabel{
        let lab = UILabel.init()
        lab.font = kFontSize15
        lab.textAlignment = .left
        lab.textColor = UIColor.red
        lab.tg_height.equal(AutoGetHeight(height: 55))
        lab.tg_left.equal(AutoGetWidth(width: 15))
        if self.required{
            lab.tg_width.equal(AutoGetWidth(width: 20))
            lab.text = "*"
        }else{
            lab.tg_width.equal(AutoGetWidth(width: 20))
            lab.text = ""
        }
        return lab
    }
    
    @objc internal func addTitleLable(title:String) -> UILabel{
        let lab = UILabel.init()
        lab.text = title
        lab.font = kFontSize15
        lab.textAlignment = .left
        lab.textColor = UIColor.black
        let labWidth = getTexWidth(textStr: title, font: kFontSize15, height: AutoGetHeight(height: 15)) + AutoGetWidth(width: 10)
        lab.tg_width.equal(labWidth)
        lab.tg_height.equal(AutoGetHeight(height: 55))
        return lab
    }
    
    
    //collectionView
    @objc internal func addCollectionView(leftDis:CGFloat,delegate:UICollectionViewDelegate,dataSource:UICollectionViewDataSource,height:CGFloat) -> UICollectionView {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width:kHaveLeftWidth/4, height:AutoGetHeight(height: 75))
        layOut.minimumLineSpacing = 10
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kHaveLeftWidth, height:height), collectionViewLayout: layOut)
        collectionView.tg_left.equal(leftDis)
        collectionView.tg_width.equal(kWidth - 2*leftDis)
        collectionView.tg_height.equal(.wrap)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        collectionView.tag = 801
        collectionView.register(CQWriteReportCell.self, forCellWithReuseIdentifier: "CQWriteReportCellId")
        return collectionView
    }
    
    
}

//  MARK:UICollectionViewDelegate
extension CQApproverLayout: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
}

extension CQApproverLayout: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQWriteReportCellId", for: indexPath) as! CQWriteReportCell
        cell.img.sd_setImage(with: URL(string: self.dataArray[indexPath.item].headImage), placeholderImage:UIImage.init(named: "personDefaultIcon") )
        cell.deleteBtn.isHidden = true
        cell.nameLab.text = self.dataArray[indexPath.item].realName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}



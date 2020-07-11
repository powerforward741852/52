//
//  CQDepartmentLayout.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/11/5.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit

protocol chooseDepartMentDelegate : NSObjectProtocol{
    func chooseDepartMent()
}

class CQDepartmentLayout: TGLinearLayout {

    var curName = ""
    var type = ""
    var curTitle = ""
    var prompt = ""
    var required = false
    var single = false  //是否单选
    var collectionHeight:CGFloat! = AutoGetHeight(height: 75)
    var dataArray = [CQAddressBookModel]() //人列表
    var actionLayout:TGLinearLayout!
    weak var departDelagte:chooseDepartMentDelegate?
    var selectDepartStr = ""
    var isDetail = false
    
    convenience init(orientation: TGOrientation,name:String,type:String,title:String,prompt:String,require:Bool,dataArray:[CQAddressBookModel],single:Bool,isDetail:Bool) {
        self.init(frame: CGRect.zero, orientation: orientation, name: name, type: type, title: title, prompt: prompt, require: require,dataArray:dataArray,single:single,isDetail:isDetail)
        
    }
    
    init(frame: CGRect, orientation: TGOrientation,name:String,type:String,title:String,prompt:String,require:Bool,dataArray:[CQAddressBookModel],single:Bool,isDetail:Bool) {
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
        self.single = single
        self.isDetail = isDetail
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()  {
        self.actionLayout.addSubview(self.addTitleLayout())
        
        if self.dataArray.count == 0{
            self.collectionHeight =  0
        }else{
            self.collectionHeight =  CGFloat(self.dataArray.count/4 + 1) * AutoGetHeight(height: 85)
        }
        self.actionLayout.addSubview(self.addCollectionViewContentLayout(height: self.collectionHeight))
        
        
    }
    
    @objc func handleAction()  {
        NotificationCenter.default.post(name: NSNotification.Name.init("cancelKeyBoard"), object: nil)
        
        if self.departDelagte != nil{
            self.departDelagte?.chooseDepartMent()
        }
        
    }
    
    func reloadCollectionData(model:CQAddressBookModel)  {
        if self.single{
            self.dataArray.removeAll()
            self.dataArray.append(model)
            self.collectionHeight = CGFloat(self.dataArray.count/4 + 1) * AutoGetHeight(height: 85) + AutoGetHeight(height: 20)
            let collection = self.viewWithTag(801) as! UICollectionView
            collection.tg_height.equal(self.collectionHeight)
            collection.reloadData()
        }else{
            self.dataArray.append(model)
            self.collectionHeight = CGFloat(self.dataArray.count/4 + 1) * AutoGetHeight(height: 85) + AutoGetHeight(height: 20)
            let collection = self.viewWithTag(801) as! UICollectionView
            collection.tg_height.equal(self.collectionHeight)
            collection.reloadData()
        }
        
    }
    
    
}

//Mark 整个界面用到的layout
extension CQDepartmentLayout{
    //标题
    internal func addTitleLayout() -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(kWidth)
        wrapContentLayout.addSubview(self.addxingLable())
        wrapContentLayout.addSubview(self.addTitleLable(title: self.curTitle))
        if !self.isDetail{
            wrapContentLayout.addSubview(self.addSelectBtn(title: self.prompt))
            wrapContentLayout.addSubview(self.addArrowBtn())
        }
        
        return wrapContentLayout
    }
    
    //collectionView
    internal func addCollectionViewContentLayout(height:CGFloat) -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        
        
        wrapContentLayout.addSubview(self.addCollectionView(leftDis: kLeftDis, delegate: self, dataSource: self,height:height))
        return wrapContentLayout
    }
}

// Mark 整个界面可能用到的控件
extension CQDepartmentLayout{
    
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
        if self.isDetail{
            lab.tg_width.equal(AutoGetWidth(width: 0))
        }
        return lab
    }
    
    @objc internal func addTitleLable(title:String) -> UILabel{
        let lab = UILabel.init()
        lab.text = title
        lab.font = kFontSize15
        lab.textAlignment = .left
        if self.isDetail{
            lab.textColor = kLyGrayColor
        }else{
            lab.textColor = UIColor.black
        }
        
        //        let labWidth = getTexWidth(textStr: title, font: kFontSize15, height: AutoGetHeight(height: 15)) + AutoGetWidth(width: 10)
        lab.tg_width.equal(AutoGetWidth(width: 85))
        lab.tg_height.equal(AutoGetHeight(height: 55))
        return lab
    }
    
    @objc internal func addSelectBtn(title:String) -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.addTarget(self ,action:#selector(handleAction), for:.touchUpInside)
        btn.setTitle("请选择" ,for:.normal)
        btn.titleLabel!.font = kFontSize15
        btn.setTitleColor(kLyGrayColor, for: .normal)
        btn.contentHorizontalAlignment = .right
        btn.tag = 200
        btn.tg_height.equal(AutoGetHeight(height: 55))
        btn.tg_width.equal(kWidth - AutoGetWidth(width: 140))
        return btn
    }
    
    @objc internal func addArrowBtn() -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "PersonAddressArrow"), for: .normal)
        btn.tg_height.equal(AutoGetHeight(height: 55))
        btn.tg_width.equal(AutoGetWidth(width: 12.5))
        return btn
    }
    
    //collectionView
    @objc internal func addCollectionView(leftDis:CGFloat,delegate:UICollectionViewDelegate,dataSource:UICollectionViewDataSource,height:CGFloat) -> UICollectionView {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width:kHaveLeftWidth/3, height:AutoGetHeight(height: 75))
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
extension CQDepartmentLayout: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
}

extension CQDepartmentLayout: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQWriteReportCellId", for: indexPath) as! CQWriteReportCell
        cell.deleteBtn.isHidden = false
        cell.deleteBtn.frame = CGRect.init(x: kHaveLeftWidth/3 - AutoGetWidth(width: 22), y: AutoGetHeight(height: 0), width: AutoGetWidth(width: 12), height: AutoGetWidth(width: 12))
        cell.deleteBtn.isUserInteractionEnabled = false
        cell.img.isHidden = true
//        cell.img.sd_setImage(with: URL(string: self.dataArray[indexPath.item].headImage), placeholderImage:UIImage.init(named: "personDefaultIcon") )
        cell.nameLab.frame = CGRect.init(x: 0, y: 3, width: kHaveLeftWidth/3 - kLeftDis, height: AutoGetHeight(height: 75))
        if !self.dataArray[indexPath.item].departmentName.isEmpty{
            cell.nameLab.text = self.dataArray[indexPath.item].departmentName
        }else {
            cell.nameLab.text = self.dataArray[indexPath.item].name
        }
        if self.isDetail{
            cell.deleteBtn.isHidden = true
        }
        
        cell.nameLab.textColor = kLyGrayColor
        cell.nameLab.backgroundColor = kLineColor
        cell.nameLab.layer.cornerRadius = 4
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dataArray.remove(at: indexPath.item)
        if self.dataArray.count == 0{
            collectionView.tg_height.equal(0)
        }
        collectionView.reloadData()
        
    }
    
}


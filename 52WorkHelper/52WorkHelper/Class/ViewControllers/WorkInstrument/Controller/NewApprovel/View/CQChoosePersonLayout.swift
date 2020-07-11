//
//  CQChoosePersonLayout.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/10/25.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit

protocol CQTogtherPersonDelegate : NSObjectProtocol{
    func chooseTogtherPerson(dataArray:[CQDepartMentUserListModel])
}

class CQChoosePersonLayout: TGLinearLayout {

    var curName = ""
    var type = ""
    var curTitle = ""
    var prompt = ""
    var required = false
    var isReplace = false
    var collectionHeight:CGFloat! = AutoGetHeight(height: 75)
    var dataArray = [CQDepartMentUserListModel]() //人列表
    var actionLayout:TGLinearLayout!
    weak var chooseDelegate:CQTogtherPersonDelegate?
    
    
    convenience init(orientation: TGOrientation,name:String,type:String,title:String,prompt:String,require:Bool,isReplace:Bool,dataArray:[CQDepartMentUserListModel]) {
        self.init(frame: CGRect.zero, orientation: orientation, name: name, type: type, title: title, prompt: prompt, require: require,isReplace:isReplace,dataArray:dataArray)
        
    }
    
    init(frame: CGRect, orientation: TGOrientation,name:String,type:String,title:String,prompt:String,require:Bool,isReplace:Bool,dataArray:[CQDepartMentUserListModel]) {
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
        self.isReplace = isReplace
        self.dataArray = dataArray
//        if !self.isReplace{
//            let model = CQDepartMentUserListModel.init(uId: STUserTool.account().userID, realN: STUserTool.account().realName, headImag: STUserTool.account().headImage)
//            self.dataArray.append(model)
//        }
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
            self.collectionHeight =  CGFloat(self.dataArray.count/4 + 1) * AutoGetHeight(height: 75)
        }
        self.actionLayout.addSubview(self.addCollectionViewContentLayout(height: self.collectionHeight))
        
//        let NotifMycation1 = NSNotification.Name(rawValue:"refreshTogherCell")
        let NotifMycation1 = NSNotification.Name(rawValue:"together")
        NotificationCenter.default.addObserver(self, selector: #selector(togherDataChange(notif:)), name: NotifMycation1, object: nil)
    }
    
    @objc func handleAction()  {
        NotificationCenter.default.post(name: NSNotification.Name.init("cancelKeyBoard"), object: nil)
        if self.chooseDelegate != nil{
            self.chooseDelegate?.chooseTogtherPerson(dataArray: self.dataArray)
        }
    }
    
    //接收同行人
    @objc func togherDataChange(notif: NSNotification) {
        guard let arr: [CQDepartMentUserListModel] = notif.object as! [CQDepartMentUserListModel]? else { return }
        for model in arr {
            
            self.dataArray.append(model)
        }
        
        let collection = self.viewWithTag(801) as! UICollectionView
        collection.tg_height.equal(CGFloat(self.dataArray.count/4 + 1) * AutoGetHeight(height: 75) + AutoGetHeight(height: 30)  )
        collection.reloadData()
        
        NotificationCenter.default.post(name: NSNotification.Name.init("togherPersonChosseValue"), object: CGFloat(self.dataArray.count/4 + 1) * AutoGetHeight(height: 75) + AutoGetHeight(height: 30) )
    }
    
}

//Mark 整个界面用到的layout
extension CQChoosePersonLayout{
    //标题
    internal func addTitleLayout() -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(kWidth)
        wrapContentLayout.addSubview(self.addxingLable())
        wrapContentLayout.addSubview(self.addTitleLable(title: self.curTitle))
        wrapContentLayout.addSubview(self.addSelectBtn(title: self.prompt))
        wrapContentLayout.addSubview(self.addArrowBtn())
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
extension CQChoosePersonLayout{
    
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
    
    @objc internal func addSelectBtn(title:String) -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.addTarget(self ,action:#selector(handleAction), for:.touchUpInside)
        btn.setTitle(title ,for:.normal)
        btn.titleLabel!.font = kFontSize15
        btn.setTitleColor(kLyGrayColor, for: .normal)
        btn.contentHorizontalAlignment = .right
        if !self.isReplace {
            btn.isUserInteractionEnabled = false
            btn.setTitle("", for: .normal)
        }else{
            btn.isUserInteractionEnabled = true
        }
        btn.tag = 200
        btn.tg_height.equal(AutoGetHeight(height: 55))
        btn.tg_width.equal(kWidth - AutoGetWidth(width: 116.5))
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
extension CQChoosePersonLayout: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
}

extension CQChoosePersonLayout: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQWriteReportCellId", for: indexPath) as! CQWriteReportCell
        
        if !self.isReplace {
            cell.deleteBtn.isHidden = true
        }else{
            cell.deleteBtn.isHidden = false
            cell.deleteBtn.isUserInteractionEnabled = false
        }
        cell.img.sd_setImage(with: URL(string: self.dataArray[indexPath.item].headImage), placeholderImage:UIImage.init(named: "personDefaultIcon") )
        cell.nameLab.text = self.dataArray[indexPath.item].realName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.isReplace{
            self.dataArray.remove(at: indexPath.item)
            if self.dataArray.count == 0{
                collectionView.tg_height.equal(0)
            }
            collectionView.reloadData()
        }
        
        
    }
    
}


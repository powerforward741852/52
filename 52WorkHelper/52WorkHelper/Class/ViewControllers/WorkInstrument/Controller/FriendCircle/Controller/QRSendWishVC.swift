//
//  QRSendWishVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/15.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRSendWishVC: SuperVC {
    var isMainpage = false
    var isfromMain = false
    var singleModel : CQDepartMentAttenceModel?
    var dataModel = [CQDepartMentAttenceModel]()
    var textView : CBTextView?
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: SafeAreaTopHeight, width: kWidth, height: kHeight-SafeAreaTopHeight ), style: UITableViewStyle.plain)
        if #available(iOS 11.0, *) {
            //            table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
            //            table.contentInset = UIEdgeInsetsMake(CGFloat(SafeAreaTopHeight), 0, CGFloat(SafeAreaBottomHeight), 0);
            //            table.scrollIndicatorInsets = table.contentInset;
        } else {
            //低于 iOS 9.0
            self.automaticallyAdjustsScrollViewInsets = false
        }
        table.register(QRFriendCircleCell.self, forCellReuseIdentifier: "friendcellid")
        table.separatorStyle = .singleLine
        table.backgroundColor = UIColor.white
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.estimatedRowHeight = 107
        return table
    }()
    
    lazy var headView :UIView = {
        let headView =  UIView(frame:  CGRect(x: 0, y: 0, width: kWidth, height: kHeight))
        return headView
    }()
    
    lazy var zhufuView :QRZhufuView = {
        let zhufuView =  QRZhufuView(width: kWidth-AutoGetWidth(width: 30), numberOfRow: 4)
        return zhufuView
    }()
    
    
    lazy var cakeView : UIView = {
        let cakeView = UIView(frame:  CGRect(x: 0, y: 0, width: kWidth-AutoGetWidth(width: 30), height: AutoGetHeight(height: 225+40+20+40)))
        cakeView.backgroundColor = UIColor.colorWithHexString(hex: "#05a3f5")
        cakeView.layer.cornerRadius = AutoGetWidth(width: 10)
        return cakeView
    }()
    
    lazy var iconImg : UIImageView = {
        let iconImg = UIImageView(frame:  CGRect(x: (kWidth - AutoGetWidth(width: 40+30))/2, y:  AutoGetWidth(width: 20), width: AutoGetWidth(width: 40), height: AutoGetWidth(width: 40)))
        
        iconImg.image = UIImage(named: "tx")
        return iconImg
    }()
    
    lazy var nameLalel :UILabel = {
        let nameLalel = UILabel(title: "来自:小米", textColor: UIColor.white, fontSize: 15)
        nameLalel.textAlignment = .center
        nameLalel.frame =  CGRect(x: 0, y: iconImg.bottom, width: kWidth-AutoGetWidth(width: 30), height: 20)
        nameLalel.numberOfLines = 1
        return nameLalel
    }()
    
    lazy var cakeImg : UIImageView = {
        let cakeImg = UIImageView(frame:  CGRect(x: (kWidth-AutoGetWidth(width: 300+30))/2, y: nameLalel.bottom, width: AutoGetWidth(width: 300), height: AutoGetWidth(width: 225)))
        
        cakeImg.image = UIImage(named: "cake")
        return cakeImg
    }()
    
    lazy var bitthLalel :UILabel = {
        let bitthLalel = UILabel(title: "生日快乐!", textColor: UIColor.white, fontSize: 30)
        bitthLalel.frame =  CGRect(x: 0, y: cakeImg.bottom, width: kWidth-AutoGetWidth(width: 30), height: 40)
        bitthLalel.numberOfLines = 1
        bitthLalel.font = UIFont.boldSystemFont(ofSize: 30)
        bitthLalel.textAlignment = .center
        bitthLalel.backgroundColor =  UIColor.colorWithHexString(hex: "#05a3f5")
        return bitthLalel
    }()
    
    var text = ""
    
    lazy var footView : UIView = {
        let footView = UIView(frame:  CGRect(x: 0, y: kHeight-SafeAreaBottomHeight-80, width: kWidth, height: 80))
        footView.backgroundColor = klightGreyColor
        return footView
    }()
    
    lazy var fromNameLable : UILabel = {
        let fromNameLable = UILabel(title: "我的客户标题", textColor: UIColor.black, fontSize: 18)
        fromNameLable.numberOfLines = 1
        return fromNameLable
    }()
    
    lazy var fromIcom :UIImageView = {
        let fromIcom = UIImageView()
        return fromIcom
    }()
    
    lazy var collectionView: UICollectionView = {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width: (kWidth-AutoGetWidth(width: 30))/4, height: 20+(kWidth-AutoGetWidth(width: 30))/4)
        layOut.minimumLineSpacing = 0
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        layOut.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layOut.footerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 108))
        layOut.headerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 225+40+20+40+20))
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x:kLeftDis, y: SafeAreaTopHeight+AutoGetHeight(height: 15), width: kHaveLeftWidth, height: kHeight-SafeAreaTopHeight-SafeAreaBottomHeight-AutoGetHeight(height: 30)), collectionViewLayout: layOut)
        if #available(iOS 11.0, *) {
        } else {
            //低于 iOS 9.0
            self.automaticallyAdjustsScrollViewInsets = false
        }
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.colorWithHexString(hex: "#05a3f5")
        collectionView.allowsSelection = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(QRWishPersonCell.self, forCellWithReuseIdentifier: "sendWishId")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "wishTextId")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "happybirthIdHeader")
      
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
       // self.view.addSubview(collectionView)
      //  self.view.addSubview(footView)
        let RightButton = UIButton(frame:  CGRect(x: 0, y: 0, width: 50, height: 30))
        RightButton.setTitle("发送", for: UIControlState.normal)
        RightButton.addTarget(self, action: #selector(sendWish), for: UIControlEvents.touchUpInside)
        RightButton.titleLabel?.font = kFontSize17
        RightButton.setTitleColor(kBlueC, for: UIControlState.normal)
        RightButton.sizeToFit()
        RightButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: -7)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: RightButton)
        
        
        let leftButton = UIButton(frame:  CGRect(x: 0, y: 0, width: 50, height: 30))
        leftButton.titleLabel?.font = kFontSize17
        leftButton.setTitle("取消", for: UIControlState.normal)
        leftButton.addTarget(self, action: #selector(popWish), for: UIControlEvents.touchUpInside)
        leftButton.setTitleColor(kBlueColor, for: UIControlState.normal)
        leftButton.sizeToFit()
        leftButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
       view.addSubview(table)
        
        zhufuView.iconImg.sd_setImage(with: URL(string: STUserTool.account().headImage), placeholderImage: UIImage(named: "CQIndexPersonDefault"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
        zhufuView.nameLalel.text = "来自:" + STUserTool.account().realName
        
        zhufuView.setWishDataSource(data: dataModel)
        zhufuView.frame = CGRect(x:kLeftDis, y: AutoGetHeight(height: 15), width: zhufuView.pictureViewWidth, height: zhufuView.pictureViewHeight)
        headView.addSubview(zhufuView)
      
        let textView = CBTextView(frame:  CGRect(x:10, y:AutoGetHeight(height: 10),width:zhufuView.pictureViewWidth-20, height: AutoGetHeight(height: 88)))
        textView.placeHolder = "生日快乐~~"
        textView.placeHolderColor = UIColor.white
        textView.textView.font = kFontSize16
        textView.backgroundColor = UIColor.colorWithHexString(hex: "#05a3f5")
        textView.textView.backgroundColor = UIColor.colorWithHexString(hex: "#05a3f5")
        textView.aDelegate = self
        textView.isSupportEmoji = true
        self.textView = textView
        zhufuView.topView.addSubview(textView)
        
        headView.frame =  CGRect(x: 0, y: 0, width: kWidth, height: zhufuView.bottom+SafeTabbarBottomHeight)
        table.tableHeaderView = headView
        
    }
    
    @objc func popWish(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func sendWish(){
        
        if text == ""{
            //SVProgressHUD.showInfo(withStatus: "祝福不可为空")
            text = "生日快乐～～"
          //  return
        }
        if dataModel.count == 0 {
            SVProgressHUD.showInfo(withStatus: "祝福的人不可为空")
            return
        }
        
        var tempArr = ""
        for (_,value) in dataModel.enumerated(){
            tempArr.append(value.entityId + ",")
        }
        if tempArr.hasSuffix(","){
            tempArr.removeLast()
        }
        
        self.commitWish(userIds:tempArr)
    
        self.loadingPlay()
    }
    func commitWish(userIds:String)  {
        
        var emoji = text
        emoji = (text + " ").toBase64()! + "\n"
          let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/birth/saveBenison", type: MethodType.post, param: ["content":emoji,"createUserId":userID,"toUserIds":userIds,"type":"1"], successCallBack: { (result) in
            if result["success"].boolValue == true{
                self.loadingSuccess()
                SVProgressHUD.showInfo(withStatus: "发布成功")
                if self.isfromMain{
                    self.navigationController?.dismiss(animated: true, completion: nil)
                    return
                }
                
                if self.isMainpage{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "popBirthDayMainPageList"), object: nil)
                }else{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "popBirthDayList"), object: nil)
                }
                
            }
            
        }) { (error) in
            self.loadingSuccess()
        }
    }
}
extension QRSendWishVC:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  11//dataModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sendWishId", for: indexPath)as! QRWishPersonCell
        cell.backgroundColor = UIColor.colorWithHexString(hex: "#05a3f5")
       // cell.model = dataModel[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print(kind)
        if kind == UICollectionElementKindSectionFooter{
            var header:UICollectionReusableView!
            header = collectionView.dequeueReusableSupplementaryView(ofKind:UICollectionElementKindSectionFooter, withReuseIdentifier: "wishTextId", for: indexPath)
            let textView = CBTextView(frame:  CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 108)))
            textView.placeHolder = "生日快乐~~"
            textView.textView.font = kFontSize16
            textView.aDelegate = self
            self.textView = textView
            
            header.addSubview(textView)
            return header
        }else {
            var header:UICollectionReusableView!
            header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "happybirthIdHeader", for: indexPath)
            self.cakeView.addSubview(self.iconImg)
            self.cakeView.addSubview(self.nameLalel)
            self.cakeView.addSubview(self.cakeImg)
            self.cakeView.addSubview(self.bitthLalel)
            header.addSubview(cakeView)
            return header
        }
       
    }
    
    
}

extension QRSendWishVC:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.text = textView.text
    }
   
}


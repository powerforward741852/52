//
//  QRImgCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/6/5.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class QRImgCell: UICollectionViewCell {
    weak var rootvc : QRGetPresentVC?
    lazy var iconImg : UIImageView = {
        let iconImg = UIImageView(frame:  CGRect(x: 0, y: 0, width: kWidth/3, height: kWidth/3))
        iconImg.image = UIImage(named: "corect")
        iconImg.layer.cornerRadius = AutoGetWidth(width: 6)
        iconImg.clipsToBounds = true
        return iconImg
    }()
    
    lazy var giftImg : UIImageView = {
        let giftImg = UIImageView(frame:  CGRect(x: 0, y: 0, width: kWidth/3/2, height: kWidth/3/2))
        // giftImg.image = UIImage(named: "corect")
        giftImg.layer.cornerRadius = AutoGetWidth(width: 5)
        giftImg.clipsToBounds = true
        return giftImg
    }()
    
    lazy var getBut :UIButton = {
        let getBut = UIButton(frame:  CGRect(x: 0, y: 0, width: 80, height: 28))
        //       getBut.setTitleColor(UIColor.black, for: UIControlState.normal)
        //        getBut.setTitle("领取", for: UIControlState.normal)
        //        getBut.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        //        getBut.setTitleColor(UIColor.white, for: UIControlState.normal)
        //        getBut.backgroundColor = UIColor.colorWithHexString(hex: "#f69a00")
        //getBut.setTitle("已领取", for: UIControlState.disabled)
        
        getBut.layer.cornerRadius = 5
        getBut.clipsToBounds = true
        getBut.setBackgroundImage(UIImage(named: "getp"), for: UIControlState.normal)
        getBut.setBackgroundImage(UIImage(named: "getd"), for: UIControlState.disabled)
        //getBut.addTarget(self, action: #selector(getPresent), for: UIControlEvents.touchUpInside)
        return getBut
    }()
    
    var model : CQDepartMentAttenceModel?{
        didSet{
            iconImg.sd_setImage(with: URL(string: model?.imgUrl ?? ""), placeholderImage: UIImage(named: "corect"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)

        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.colorWithHexString(hex: "#f6f3f4")
        self.contentView.addSubview(iconImg)
       // self.contentView.addSubview(getBut)
        
        iconImg.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(self.contentView.mas_left)
            make?.top.mas_equalTo()(self.contentView.mas_top)
            make?.right.mas_equalTo()(self.contentView.mas_right)
            make?.bottom.mas_equalTo()(self.contentView.mas_bottom)
        }
//
//        getBut.mas_makeConstraints { (make) in
//            make?.centerX.mas_equalTo()(self.contentView.mas_centerX)
//            make?.top.mas_equalTo()(self.iconImg.mas_bottom)?.setOffset(15)
//            make?.width.mas_equalTo()(AutoGetWidth(width: 80))
//            make?.height.mas_equalTo()(AutoGetWidth(width: 28))
//        }
    }
    
//    @objc func getPresent(){
//        loadResiveGift()
//    }
//    func loadResiveGift(){
//        SVProgressHUD.show()
//        self.getBut.isUserInteractionEnabled = false
//
//        let userId = STUserTool.account().userID
//        STNetworkTools.requestData(URLString: "\(baseUrl)/birth/receiveGift",
//            type: .get,
//            param: ["giftId":(model?.entityId)!,"userId":userId],
//            successCallBack: { (result) in
//
//                self.getBut.isUserInteractionEnabled = true
//
//                //   let scuucess = result["success"].boolValue
//                // self.getBut.isEnabled = true
//                SVProgressHUD.dismiss()
//                SVProgressHUD.showInfo(withStatus: result["message"].stringValue)
//                self.rootvc?.collectionView.reloadData()
//        }) { (error) in
//            self.getBut.isUserInteractionEnabled = true
//            //  self.getBut.isEnabled = true
//            //SVProgressHUD.showInfo(withStatus: result["message"].stringValue)
//        }
//        //
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

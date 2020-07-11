//
//  CQInvoiceDetailVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/4.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQInvoiceDetailVC: SuperVC {

    var dataArray = [CQInvoiceModel]()
    var entityId = ""
    var invoiceType = ""
    var shareUrl = ""
    
    lazy var bgTitleLab: UILabel = {
        let bgTitleLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 64, width: kHaveLeftWidth, height: AutoGetHeight(height: 33)))
        bgTitleLab.font = kFontSize12
        bgTitleLab.text = "单位抬头发票"
        bgTitleLab.textAlignment = .left
        bgTitleLab.textColor = UIColor.white
        return bgTitleLab
    }()
    
    lazy var bgIconImg: UIImageView = {
        let bgIconImg = UIImageView.init(frame: CGRect.init(x: kLeftDis, y: self.bgTitleLab.bottom, width: kHaveLeftWidth, height: AutoGetHeight(height: 388.5)))
        bgIconImg.image = UIImage.init(named: "InvoiceBg")
        bgIconImg.isUserInteractionEnabled = true
        return bgIconImg
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 28), width: AutoGetWidth(width: 65), height: AutoGetHeight(height: 14)))
        nameLab.font = kFontSize14
        nameLab.text = "名称"
        nameLab.textAlignment = .left
        nameLab.textColor = kLyGrayColor
        return nameLab
    }()
    
    lazy var trueNameLab: UILabel = {
        let trueNameLab = UILabel.init(frame: CGRect.init(x: self.nameLab.right + kLeftDis, y: AutoGetHeight(height: 28), width: kHaveLeftWidth - AutoGetWidth(width: 65) - AutoGetWidth(width: 45), height: AutoGetHeight(height: 14)))
        trueNameLab.font = kFontSize14
        trueNameLab.text = ""
        trueNameLab.textAlignment = .right
        trueNameLab.textColor = UIColor.black
        return trueNameLab
    }()
    
    lazy var taxNum: UILabel = {
        let taxNum = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.nameLab.bottom + AutoGetHeight(height: 26), width: AutoGetWidth(width: 65), height: AutoGetHeight(height: 14)))
        taxNum.font = kFontSize14
        taxNum.text = "税号"
        taxNum.textAlignment = .left
        taxNum.textColor = kLyGrayColor
        return taxNum
    }()
    
    lazy var taxNumLab: UILabel = {
        let taxNumLab = UILabel.init(frame: CGRect.init(x: self.nameLab.right + kLeftDis, y: self.nameLab.bottom + AutoGetHeight(height: 26), width: kHaveLeftWidth - AutoGetWidth(width: 65) - AutoGetWidth(width: 45), height: AutoGetHeight(height: 14)))
        taxNumLab.font = kFontSize14
        taxNumLab.text = ""
        taxNumLab.textAlignment = .right
        taxNumLab.textColor = UIColor.black
        return taxNumLab
    }()
    
    lazy var location: UILabel = {
        let location = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.taxNum.bottom + AutoGetHeight(height: 26), width: AutoGetWidth(width: 65), height: AutoGetHeight(height: 14)))
        location.font = kFontSize14
        location.text = "单位地址"
        location.textAlignment = .left
        location.textColor = kLyGrayColor
        return location
    }()
    
    lazy var locationLab: UILabel = {
        let locationLab = UILabel.init(frame: CGRect.init(x: self.nameLab.right + kLeftDis, y: self.taxNum.bottom + AutoGetHeight(height: 26), width: kHaveLeftWidth - AutoGetWidth(width: 65) - AutoGetWidth(width: 45), height: AutoGetHeight(height: 35)))
        locationLab.font = kFontSize14
        locationLab.text = ""
        locationLab.textAlignment = .right
        locationLab.numberOfLines = 2
        locationLab.textColor = UIColor.black
        return locationLab
    }()
    
    
    lazy var telNum: UILabel = {
        let telNum = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.locationLab.bottom + AutoGetHeight(height: 26), width: AutoGetWidth(width: 65), height: AutoGetHeight(height: 14)))
        telNum.font = kFontSize14
        telNum.text = "电话号码"
        telNum.textAlignment = .left
        telNum.textColor = kLyGrayColor
        return telNum
    }()
    
    lazy var telNumLab: UILabel = {
        let telNumLab = UILabel.init(frame: CGRect.init(x: self.nameLab.right + kLeftDis, y: self.locationLab.bottom + AutoGetHeight(height: 26), width: kHaveLeftWidth - AutoGetWidth(width: 65) - AutoGetWidth(width: 45), height: AutoGetHeight(height: 14)))
        telNumLab.font = kFontSize14
        telNumLab.text = ""
        telNumLab.textAlignment = .right
        telNumLab.textColor = UIColor.black
        return telNumLab
    }()
    
    lazy var bankName: UILabel = {
        let bankName = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.telNumLab.bottom + AutoGetHeight(height: 26), width: AutoGetWidth(width: 65), height: AutoGetHeight(height: 14)))
        bankName.font = kFontSize14
        bankName.text = "开户银行"
        bankName.textAlignment = .left
        bankName.textColor = kLyGrayColor
        return bankName
    }()
    
    lazy var bankNameLab: UILabel = {
        let bankNameLab = UILabel.init(frame: CGRect.init(x: self.nameLab.right + kLeftDis, y: self.telNumLab.bottom + AutoGetHeight(height: 26), width: kHaveLeftWidth - AutoGetWidth(width: 65) - AutoGetWidth(width: 45), height: AutoGetHeight(height: 14)))
        bankNameLab.font = kFontSize14
        bankNameLab.text = ""
        bankNameLab.textAlignment = .right
        bankNameLab.textColor = UIColor.black
        return bankNameLab
    }()
    
    lazy var bankNum: UILabel = {
        let bankNum = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.bankNameLab.bottom + AutoGetHeight(height: 26), width: AutoGetWidth(width: 65), height: AutoGetHeight(height: 14)))
        bankNum.font = kFontSize14
        bankNum.text = "银行账户"
        bankNum.textAlignment = .left
        bankNum.textColor = kLyGrayColor
        return bankNum
    }()
    
    lazy var bankNumLab: UILabel = {
        let bankNumLab = UILabel.init(frame: CGRect.init(x: self.nameLab.right + kLeftDis, y: self.bankNameLab.bottom + AutoGetHeight(height: 26), width: kHaveLeftWidth - AutoGetWidth(width: 65) - AutoGetWidth(width: 45), height: AutoGetHeight(height: 14)))
        bankNumLab.font = kFontSize14
        bankNumLab.text = ""
        bankNumLab.textAlignment = .right
        bankNumLab.textColor = UIColor.black
        return bankNumLab
    }()
    
    lazy var shareBtn: UIButton = {
        let shareBtn = UIButton.init(type: .custom)
        shareBtn.frame = CGRect.init(x: (kHaveLeftWidth - AutoGetWidth(width: 210) - AutoGetWidth(width: 28))/2, y: AutoGetHeight(height: 314), width: AutoGetWidth(width: 105), height: AutoGetHeight(height: 35))
        shareBtn.layer.borderColor = kLightBlueColor.cgColor
        shareBtn.layer.borderWidth = 0.5
        shareBtn.setTitle("分享", for: .normal)
        shareBtn.setTitleColor(kLightBlueColor, for: .normal)
        shareBtn.backgroundColor = UIColor.white
        shareBtn.layer.cornerRadius = 2
        shareBtn.titleLabel?.font = kFontSize17
        shareBtn.addTarget(self, action: #selector(shareClick), for: .touchUpInside)
        return shareBtn
    }()
    
    lazy var editBtn: UIButton = {
        let editBtn = UIButton.init(type: .custom)
        editBtn.frame = CGRect.init(x: self.shareBtn.right + AutoGetWidth(width: 28), y: AutoGetHeight(height: 314), width: AutoGetWidth(width: 105), height: AutoGetHeight(height: 35))
        editBtn.layer.borderColor = kLyGrayColor.cgColor
        editBtn.layer.borderWidth = 0.5
        editBtn.layer.cornerRadius = 2
        editBtn.setTitle("编辑", for: .normal)
        editBtn.titleLabel?.font = kFontBoldSize17
        editBtn.setTitleColor(kLyGrayColor, for: .normal)
        editBtn.backgroundColor = UIColor.white
        editBtn.addTarget(self, action: #selector(editClick), for: .touchUpInside)
        return editBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发票详情"
    
        self.view.backgroundColor = kColorRGB(r: 58, g: 138, b: 251)
        self.view.addSubview(self.bgTitleLab)
        
        self.view.addSubview(self.bgIconImg)
        self.bgIconImg.addSubview(self.nameLab)
        self.bgIconImg.addSubview(self.trueNameLab)
        self.bgIconImg.addSubview(self.taxNum)
        self.bgIconImg.addSubview(self.taxNumLab)
        self.bgIconImg.addSubview(self.location)
        self.bgIconImg.addSubview(self.locationLab)
        self.bgIconImg.addSubview(self.telNum)
        self.bgIconImg.addSubview(self.telNumLab)
        self.bgIconImg.addSubview(self.bankName)
        self.bgIconImg.addSubview(self.bankNameLab)
        self.bgIconImg.addSubview(self.bankNum)
        self.bgIconImg.addSubview(self.bankNumLab)
        self.bgIconImg.addSubview(self.shareBtn)
        self.bgIconImg.addSubview(self.editBtn)
        
        self.shareUrl = "\(baseUrl)/my/shareInvoice" + "?entityId=" + self.entityId
        
        self.loadDatas()
    }
    func initShareView()  {
        let shareV = CQShareView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - CGFloat(SafeAreaBottomHeight)))
        shareV.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
        shareV.cqShareDelegate = self
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.addSubview(shareV)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadDatas()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func shareClick()  {
        self.initShareView()
    }

    @objc func editClick()  {
        let vc = CQAddInvoiceVC.init()
        vc.type = .update
        vc.entityId = self.entityId
        vc.invoiceType = self.invoiceType
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// Mark :loadData
extension CQInvoiceDetailVC{
    
    fileprivate func loadDatas() {
        
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/my/getMyInvoiceInfo" ,
            type: .get,
            param: ["entityId":self.entityId],
            successCallBack: { (result) in
                guard let model = CQInvoiceModel.init(jsonData: result["data"]) else {
                    return
                }
                if model.invoiceType == "1"{
                    self.bgTitleLab.text = "个人发票详情"
                }else{
                    self.bgTitleLab.text = "单位发票详情"
                }
                self.trueNameLab.text = model.invoiceName
                self.taxNumLab.text = model.invoiceNumber
                self.locationLab.text = model.companyAddress
                self.telNumLab.text = model.phoneNumber
                self.bankNameLab.text = model.accountBank
                self.bankNumLab.text = model.accountNumber
                self.invoiceType = model.invoiceType
        }) { (error) in
            
        }
    }
}


extension CQInvoiceDetailVC:CQShareDelegate{
    func pushToThirdPlatform(index: Int) {
        var type:SSDKPlatformType!
        if 0 == index {
            type = SSDKPlatformType.subTypeWechatSession
        }else if 1 == index{
            type = SSDKPlatformType.subTypeWechatTimeline
        }else if 2 == index{
            type = SSDKPlatformType.subTypeQQFriend
        }else if 3 == index{
            type = SSDKPlatformType.subTypeQZone
        }
        
        let imgUrl:String = UserDefaults.standard.object(forKey: "headImage") as! String
        let imgData = NSData.init(contentsOf: URL.init(string: imgUrl)!)
        let img = UIImage.init(data: imgData! as Data)
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: "分享内容",
                                          images : img,
                                          url : NSURL(string:self.shareUrl) as URL?,
                                          title : "分享我的发票",
                                          type : SSDKContentType.webPage)
        
        //2.进行分享
        ShareSDK.share(type , parameters: shareParames) { (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
            
            switch state{
                
            case SSDKResponseState.success: print("分享成功")
            case SSDKResponseState.fail:    print("授权失败,错误描述:\(String(describing: error))")
            case SSDKResponseState.cancel:  print("操作取消")
                
            default:
                break
            }
            
        }
    }
    
    
}



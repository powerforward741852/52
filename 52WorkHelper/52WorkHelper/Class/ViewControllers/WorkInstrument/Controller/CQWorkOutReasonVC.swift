//
//  CQWorkOutReasonVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/4/27.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit


class CQWorkOutReasonVC: SuperVC {

    var photoArray = [UIImage]()
    var locationManager:AMapLocationManager? //定位服务
    var curLatitude:Double? //经度
    var curLongitude:Double? //纬度
    var curlocationStr:String? //当前位置
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight-AutoGetHeight(height: 0)), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        table.backgroundColor = UIColor.colorWithHexString(hex: "#f7f7f7")
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 338)))
        return headView
    }()
    
    lazy var locationImg: UIImageView = {
        let locationImg = UIImageView.init(frame: CGRect.init(x: AutoGetWidth(width: 15), y: AutoGetHeight(height: 8), width: AutoGetWidth(width: 15), height: AutoGetHeight(height: 19)))
        locationImg.image = UIImage.init(named: "FieldPersonelLocation")
        return locationImg
    }()
    
    lazy var locationLab: UILabel = {
        let locationLab = UILabel.init(frame: CGRect.init(x: self.locationImg.right + AutoGetWidth(width: 13), y: 0, width: kWidth/3 * 2, height: AutoGetHeight(height: 35)))
        locationLab.textAlignment = .left
        locationLab.textColor = UIColor.black
        locationLab.text = ""
        locationLab.font = UIFont.systemFont(ofSize: 14)
        return locationLab
    }()
    
    lazy var txtView: UIView = {
        let txtView = UIView.init(frame: CGRect.init(x: 0, y: self.locationLab.bottom, width: kWidth, height: AutoGetHeight(height: 240)))
        txtView.backgroundColor = UIColor.white
        return txtView
    }()
    
    lazy var textView: CBTextView = {
        let textView = CBTextView.init(frame: CGRect.init(x: AutoGetWidth(width: 15), y: AutoGetWidth(width: 15), width: kWidth - AutoGetWidth(width: 30), height: AutoGetHeight(height: 110)))
        textView.aDelegate = self
        textView.textView.backgroundColor = UIColor.white
        textView.textView.font = UIFont.systemFont(ofSize: 15)
        textView.textView.textColor = UIColor.black
        
        textView.placeHolder = "工作说明..."
        textView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        
        return textView
    }()
    
   
    
    lazy var collectionView: UICollectionView = {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width:(kHaveLeftWidth - AutoGetWidth(width: 30))/3, height: (kHaveLeftWidth - AutoGetWidth(width: 30))/3)
        layOut.minimumLineSpacing = AutoGetWidth(width: 10)
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 120), width: kHaveLeftWidth, height: (kHaveLeftWidth - AutoGetWidth(width: 30))/3 ), collectionViewLayout: layOut)
        collectionView.tag = 10088
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        
        collectionView.register(CQWorkOutReasonCell.self, forCellWithReuseIdentifier: "CQWorkOutReasonCellId")
        return collectionView
    }()
    
    lazy var objView: UIView = {
        let objView = UIView.init(frame: CGRect.init(x: 0, y: self.txtView.bottom+AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 50)))
        objView.backgroundColor = UIColor.white
        return objView
    }()
    
    lazy var objField: UITextField = {
        let objField = UITextField.init(frame: CGRect.init(x: AutoGetWidth(width: 15), y: 0, width: kWidth - AutoGetWidth(width: 30), height: AutoGetHeight(height: 50)))
        objField.textAlignment = .left
        objField.textColor = UIColor.black
        objField.placeholder = "请填写拜访对象"
        objField.font = UIFont.systemFont(ofSize: 15)
        objField.keyboardType = .default
        return objField
    }()
    
    
    lazy var footView: UIView = {
        let footView = UIView.init(frame: CGRect.init(x: 0, y: kHeight - AutoGetHeight(height: 65), width: kWidth, height: AutoGetHeight(height: 65)))
        footView.backgroundColor = UIColor.white
        return footView
    }()
    
    lazy var submitBtn: UIButton = {
        let submitBtn = UIButton.init(type: .custom)
        submitBtn.frame = CGRect.init(x: AutoGetWidth(width: 15), y: AutoGetHeight(height: 10), width: kWidth - AutoGetWidth(width: 30), height: AutoGetHeight(height: 45))
        submitBtn.layer.cornerRadius = 3
        submitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        submitBtn.backgroundColor = kColorRGB(r: 62, g: 172, b: 254)
        submitBtn.setTitle("完成", for: .normal)
        submitBtn.setTitleColor(UIColor.white, for: .normal)
        submitBtn.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        return submitBtn
    }()
    
    //审批人数组
    var TrackArray  = [CQDepartMentUserListModel]()
    lazy var splab :UILabel = {
        let big = UILabel(title: "    审批人", textColor: UIColor.black, fontSize: 15)
        big.backgroundColor = UIColor.white
        big.numberOfLines = 1
        big.frame =  CGRect(x: 0, y: self.objView.bottom +  AutoGetHeight(height: 13), width: kWidth, height: 36)
        return big
    }()
    lazy var personCollectionView: UICollectionView = {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width: kHaveLeftWidth/5, height: AutoGetHeight(height: 75))
        layOut.minimumLineSpacing = 0
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        
        
        let personCollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: self.splab.bottom, width: kWidth, height: AutoGetHeight(height: 75)), collectionViewLayout: layOut)
        personCollectionView.tag = 2
        personCollectionView.backgroundColor = UIColor.white
        personCollectionView.delegate = self
        personCollectionView.dataSource = self
       // personCollectionView.register(CQWorkOutReasonCell.self, forCellWithReuseIdentifier: "CQWorkOutReasonCellId")
        personCollectionView.register(QRGenjinCollectionCell.self, forCellWithReuseIdentifier: "QRGenjinCellId")
        return personCollectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locateMap()
        
        self.title = "外勤"
        
        self.view.addSubview(self.table)
        
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.locationImg)
        self.headView.addSubview(self.locationLab)
        self.headView.addSubview(self.txtView)
        self.txtView.addSubview(self.textView)
        self.txtView.addSubview(self.collectionView)
        
        self.headView.addSubview(self.objView)
        self.objView.addSubview(self.objField)
 //       self.headView.addSubview(self.splab)
//        self.headView.addSubview(self.personCollectionView)
//       
//        loadPerson()
        
//        self.view.addSubview(self.footView)
//        self.footView.addSubview(self.submitBtn)
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 44))
        rightBtn.setTitle("提交", for: .normal)
        rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5)
        rightBtn.sizeToFit()
        rightBtn.setTitleColor(UIColor.colorWithHexString(hex: "#20afff"), for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        rightBtn.addTarget(self, action: #selector(submitAction(sender:)), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }

    
    @objc func submitAction(sender:UIButton)  {
       // sender.isUserInteractionEnabled = false
        SVProgressHUD.show()
        self.siginOutWorkRequest(sender: sender)
    }
    // MARK: - 位置构造
    func locateMap()  {
        locationManager = AMapLocationManager.init()
        locationManager?.delegate = self
        //设置定位最小更新距离
        locationManager?.distanceFilter = 5.0
        locationManager?.startUpdatingLocation()
        //如果需要持续定位返回逆地理编码信息
        //        locationManager?.locatingWithReGeocode = true
        //        locationManager?.startUpdatingLocation()
    }
    
}

extension CQWorkOutReasonVC{
    func loadPerson(){
        let userId = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getApplyApprovalPersons" ,
            type: .post,
            param: ["approvalBusinessId":"",
                    "businessCode":"B_WC",
                    "emyeId":userId,
                    "formData":""],
            successCallBack: { (result) in
//                self.copyArray.removeAll()
//                self.userIdArr.removeAll()
                //审核人列表
//                var approvalArr = [CQCopyForModel]()
//                for modalJson in result["data"]["approvalFlowPersonUnitJsonList"].arrayValue  {
//                    guard let modal = CQCopyForModel(jsonData: JSON(modalJson)) else {
//                        return
//                    }
//                    approvalArr.append(modal)
//                }
                
                //抄送人列表  copyFlowPersonUnitJsonList
                var copyToArr = [CQDepartMentUserListModel]()
                for modalJson in result["data"]["approvalFlowPersonUnitJsonList"].arrayValue  {
                    guard let modal = CQDepartMentUserListModel(jsonData: JSON(modalJson)) else {
                        return
                    }
                    copyToArr.append(modal)
                }
                    self.TrackArray = copyToArr
                self.personCollectionView.reloadData()
//                for model in copyToArr{
//                    self.copyArray.append(CQDepartMentUserListModel.init(uId: model.approverId, realN: model.realName, headImag: model.headImage))
//                }
//
//                for model in self.copyArray {
//                    self.userIdArr.append(model.userId)
//                }
                
                
        }) { (error) in
            self.personCollectionView.reloadData()
            
        }
    }
    
    
    
    func siginOutWorkRequest(sender:UIButton) {
    
        var textVTxt = self.textView.textView.text
        if textVTxt == self.textView.placeHolder{
            textVTxt = ""
        }
        
        guard let locaText = self.locationLab.text, locaText.count > 0,
              let visit = self.objField.text, visit.count > 0,
            (textVTxt?.count)! > 0 else {
            SVProgressHUD.showInfo(withStatus: "请输入完整")
            return
        }
        let userID = STUserTool.account().userID
        let now = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormat.string(from: now)
        let urlUpload = "\(baseUrl)/outWork/saveSignin"
        let headers = ["t_userId":userID,
                       "token":STUserTool.account().token]
        Alamofire.upload(multipartFormData: { formData in
            
            
            for index in 0..<self.photoArray.count {
                let imageData = UIImageJPEGRepresentation(self.photoArray[index], 0.3)
                formData.append(imageData!, withName: "imgFiles", fileName: "photo.png", mimeType: "image/jpg")
            }
        }, to: urlUpload, headers: headers, encodingCompletion: {encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in

                    
                    
                    
                    let param = ["userId":userID,
                                 "recordDate":dateStr,
                                 "longitudeValue":self.curLongitude ?? 0.00,
                                 "latitudeValue":self.curLatitude ?? 0.00,
                                 "addressRemark":locaText,
                                 "visitPartner":visit,
                                 "detailsContent":textVTxt ?? ""] as [String : Any]
                    STNetworkTools.requestData(URLString:"\(baseUrl)/outWork/saveSignin" ,
                        type: .post,
                        param: param,
                        successCallBack: { (result) in
                            SVProgressHUD.dismiss()
                            SVProgressHUD.showSuccess(withStatus: "签到成功")
                            NotificationCenter.default.post(name: NSNotification.Name.init("refreshOutWorkView"), object: nil)
                            self.navigationController?.popViewController(animated: true)
                         //   sender.isUserInteractionEnabled = true
                    }) { (error) in
                        SVProgressHUD.dismiss()
                       // sender.isUserInteractionEnabled = true
                    }
                    
                }
            case .failure( _):
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "上传失败,请稍后重试")
              //  sender.isUserInteractionEnabled = true
            }
        })
        
        
    }
    
    
    
}



extension CQWorkOutReasonVC:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if self.textView.textView.text.isEmpty {
            
        }
    }
}

// Mark:高德位置
extension CQWorkOutReasonVC:AMapLocationManagerDelegate{
    //定位失败弹出此代理方法
    //定位失败弹出提示框,提示打开定位按钮，会打开系统的设置，提示打开定位服务
    func amapLocationManager(_ manager: AMapLocationManager!, didFailWithError error: Error!) {
        //设置提示提醒用户打开定位服务
        if   CLLocationManager.authorizationStatus().rawValue == 4 ||  CLLocationManager.authorizationStatus().rawValue == 3{
        }else{
            let alert = UIAlertController.init(title: "允许\"定位\"提示", message: "请在设置中打开定位", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "打开定位", style: .default) { (al) in
                //打开定位设置
                if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(appSettings as URL)
                }
            }
            let cancel = UIAlertAction.init(title: "取消", style: .cancel) { (ca) in
            }
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!) {
        self.curLatitude = location.coordinate.latitude
        self.curLongitude = location.coordinate.longitude
        DLog(self.curLatitude)
        DLog(self.curLongitude)
        
        let geoCoder = CLGeocoder.init()
        geoCoder.reverseGeocodeLocation(location) { (placemark, error) -> Void in
            
            
            
            if(error == nil)//成功
                
            {
                
                let array = placemark! as NSArray
                
                let mark = array.firstObject as! CLPlacemark
                
                //                //这个是城市
                //
                //                let city: String = (mark.addressDictionary! as NSDictionary).value(forKey: "City") as! String
                //
                //                //这个是国家
                //
                //                let country: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "Country") as! NSString
                //
                //                //这个是国家的编码
                //
                //                let CountryCode: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "CountryCode") as! NSString
                //
                //这是街道位置
                
                let FormattedAddressLines: NSString = ((mark.addressDictionary! as NSDictionary).value(forKey: "FormattedAddressLines") as AnyObject).firstObject as! NSString
                
                //这是具体位置
                
                //                let Name: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "Name") as! NSString
                
                //                //这是省
                //
                //                var State: String = (mark.addressDictionary! as NSDictionary).value(forKey: "State") as! String
                //
                //                //这是区
                //
                //                let SubLocality: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "SubLocality") as! NSString
                
                
                //                print("\(CountryCode)\(FormattedAddressLines)\(Name)\(State)\(SubLocality)")
                //                let str1 = Name as String
                let str2 = FormattedAddressLines as String
                self.curlocationStr = str2
                DLog(self.curlocationStr)
                self.locationLab.text = self.curlocationStr
                
            }
                
            else
                
            {
                
            }
            
        }
    }
}

extension CQWorkOutReasonVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 10088{
            return self.photoArray.count + 1
        }else{
            return self.TrackArray.count
        }
        
    }
    
}

extension CQWorkOutReasonVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 10088{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQWorkOutReasonCellId", for: indexPath) as! CQWorkOutReasonCell
            if self.photoArray.count == 0 {
                if indexPath.item == 0{
                    cell.img.image = UIImage.init(named: "WorkOutAddImgBtn")
                    
                }
            }else {
                if indexPath.item == self.photoArray.count {
                    cell.img.image = UIImage.init(named: "WorkOutAddImgBtn")
                }else {
                    cell.img.image = self.photoArray[indexPath.item]
                }
            }
            return cell
        }else{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QRGenjinCellId", for: indexPath) as! QRGenjinCollectionCell
                    cell.location.isHidden = true
                    cell.deleteBtn.isHidden = true
                    let mod = self.TrackArray[indexPath.row]
                    cell.img.sd_setImage(with: URL(string:mod.headImage), placeholderImage: UIImage(named:"personDefaultIcon"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
                    cell.name.isHidden = false
                    cell.name.text = mod.realName
//                    if self.TrackArray.count == 0 {
//                        if indexPath.item == 0{
//                            cell.img.image = UIImage.init(named: "CQAddMenberIcon")
//                            cell.deleteBtn.isHidden = true
//                            cell.name.isHidden = true
//                        }
//                    }else {
//                        if indexPath.item == self.TrackArray.count {
//                            cell.img.image = UIImage.init(named: "CQAddMenberIcon")
//                            cell.deleteBtn.isHidden = true
//                            cell.name.isHidden = true
//                        }else {
//                            //  图片赋值
//                            let mod = self.TrackArray[indexPath.row]
//                            cell.img.sd_setImage(with: URL(string:mod.headImage), placeholderImage: UIImage(named:"personDefaultIcon"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
//                            cell.name.isHidden = false
//                            cell.name.text = mod.realName
//                            cell.deleteBtn.isHidden = false
//                            cell.deleteDelegate = self
//                        }
//                    }
                    return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 10088{
            if self.photoArray.count == 0 {
                if indexPath.item == 0 {
                    initImgPick()
                }
            }else{
                if indexPath.item == self.photoArray.count{
                    initImgPick()
                }else{
                    
                }
            }
        }else{

        }
        
        
        
    }
    
}

extension CQWorkOutReasonVC{
    func initImgPick()  {
        let imagePickerVc = TZImagePickerController(maxImagesCount: 3, delegate: self)
        imagePickerVc?.allowTakePicture = false
        self.present(imagePickerVc!, animated: true, completion: nil)
    }
}

extension CQWorkOutReasonVC: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        photoArray.insert(contentsOf: photos, at: 0)
        if photoArray.count > 3 {
            photoArray.removeSubrange(photoArray.indices.suffix(from: 3))
        }
        collectionView.reloadData()
    }
}

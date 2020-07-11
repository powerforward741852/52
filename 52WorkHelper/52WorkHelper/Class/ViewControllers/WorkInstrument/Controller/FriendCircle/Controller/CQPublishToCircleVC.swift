//
//  CQPublishToCircleVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/19.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQPublishToCircleVC: SuperVC {
    var mod : CQDepartMentUserListModel?
    var photoArray = [UIImage]()
    var isFromZan = false
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        table.backgroundColor = kProjectBgColor

        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 235)))
        headView.backgroundColor = UIColor.white
        return headView
    }()
    
    lazy var txtView: UIView = {
        let txtView = UIView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 18), width: kWidth, height: AutoGetHeight(height: 90)))
        txtView.backgroundColor = UIColor.white
        return txtView
    }()
    
    lazy var textView: CBTextView = {
        let textView = CBTextView.init(frame: CGRect.init(x: AutoGetWidth(width: 15), y: AutoGetWidth(width: 0), width: kWidth - AutoGetWidth(width: 30), height: AutoGetHeight(height: 90)))
        textView.aDelegate = self
        textView.textView.backgroundColor = UIColor.white
        textView.textView.font = UIFont.systemFont(ofSize: 15)
        textView.textView.textColor = UIColor.black
        textView.isSupportEmoji = true
        textView.placeHolder = "分享内容..."
        textView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        
        return textView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width: (kHaveLeftWidth-AutoGetWidth(width: 30))/4, height: (kHaveLeftWidth-AutoGetWidth(width: 30))/4)
        layOut.minimumLineSpacing = 10
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: kLeftDis, y: self.txtView.bottom+AutoGetHeight(height: 18), width: kHaveLeftWidth, height: (kHaveLeftWidth-AutoGetWidth(width: 30))/4 ), collectionViewLayout: layOut)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        
        collectionView.register(CQCirclePublishCell.self, forCellWithReuseIdentifier: "CQCirclePublishCellId")
        return collectionView
    }()
    
    lazy var locationImg: UIImageView = {
        let locationImg = UIImageView.init(frame: CGRect.init(x: AutoGetWidth(width: 15), y: AutoGetHeight(height: 15), width: AutoGetWidth(width: 15), height: AutoGetHeight(height: 19)))
        locationImg.image = UIImage.init(named: "FieldPersonelLocation")
        return locationImg
    }()
    
    lazy var locationLab: UILabel = {
        let locationLab = UILabel.init(frame: CGRect.init(x: self.locationImg.right + AutoGetWidth(width: 12), y: 0, width: kWidth/4 * 3, height: AutoGetHeight(height: 49)))
        locationLab.textColor = UIColor.black
        locationLab.textAlignment = .left
        locationLab.font = UIFont.systemFont(ofSize: 15)
        locationLab.text = "sadadasdahjkd"
        locationLab.numberOfLines = 2
        return locationLab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = ""
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.txtView)
        self.txtView.addSubview(self.textView)
        self.headView.addSubview(self.collectionView)
       
        if self.isFromZan == true{
            self.title = "发布点赞"
            let attributStr = NSMutableAttributedString(string: "")
            attributStr.append(NSAttributedString(string: "我为 "))
            let name = NSMutableAttributedString(string: "@"+(mod?.realName)!)
            name.addAttribute(NSAttributedStringKey.foregroundColor, value: kBlueC, range: NSMakeRange(0, name.length))
            attributStr.append(name)
            attributStr.append(NSAttributedString(string: " 点赞"))
            self.locationLab.attributedText = attributStr
            //self.locationLab.text = "我为 "+(mod?.realName)!+" 点赞"
            
            
            self.locationImg.image = UIImage(named: "dianzh")
            self.locationImg.frame = CGRect.init(x: AutoGetWidth(width: 20), y: AutoGetHeight(height: 12), width: AutoGetWidth(width: 15), height: AutoGetHeight(height: 19))
            self.locationLab.frame = CGRect.init(x: self.locationImg.right + AutoGetWidth(width: 5), y: 0, width: kWidth/4 * 3, height: AutoGetHeight(height: 49))
            self.headView.addSubview(self.locationImg)
            self.headView.addSubview(self.locationLab)
            self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 235+49-18))
            self.txtView.frame =  CGRect(x: 0, y: AutoGetHeight(height: 49), width: kWidth, height: AutoGetHeight(height: 90))
          //  self.txtView.frame =  CGRect(x: 0, y: 0, width: 0, height: 0)
            self.collectionView.frame =  CGRect(x: kLeftDis, y: self.txtView.bottom+AutoGetHeight(height: 18), width: kHaveLeftWidth, height: (kHaveLeftWidth-AutoGetWidth(width: 30))/4)
        }
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        if self.isFromZan == true{
            rightBtn.setTitle("发布", for: .normal)
        }else{
           rightBtn.setTitle("发布", for: .normal)
            self.title = "发布同事圈"
        }
        
        rightBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: -7)
        rightBtn.setTitleColor(kLightBlueColor, for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        rightBtn.addTarget(self, action: #selector(uploadClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }

    @objc func uploadClick()  {
        var comment = self.textView.textView.text
        if comment == self.textView.placeHolder{
            comment = ""
        }
        
        if (comment?.count)! > 0 || self.photoArray.count > 0{
            self.loadingPlay()
            if isFromZan{
                self.postZanData(comment: comment!)
            }else{
                self.postData(comment: comment!)
            }
            return
        }else if (comment?.count)! < 1{
            SVProgressHUD.showInfo(withStatus: "请输入内容")
            return
        }else if self.photoArray.count < 1{
            SVProgressHUD.showInfo(withStatus: "请选择要上传的图片")
            return
        }
        
        
    }
}


extension CQPublishToCircleVC{
    
    func postData(comment:String)  {
        var emoji = comment
        emoji = (comment + " ").toBase64()! + "\n"

        let userID = STUserTool.account().userID
        let urlUpload = "\(baseUrl)/circle/saveCircleArticle"
        let headers = ["t_userId":userID,
                       "token":STUserTool.account().token]
        Alamofire.upload(multipartFormData: { formData in
            let param = ["userId":userID,
                         "articleContent":emoji]
            //            if self.photoArray.count <= 10 && self.photoArray.count>0 {
            //                self.photoArray.removeLast()
            //            }
            for index in 0..<self.photoArray.count {
                let imageData = UIImageJPEGRepresentation(self.photoArray[index], 0.3)
                formData.append(imageData!, withName: "imgFiles", fileName: "photo.png", mimeType: "image/jpg")
            }
            
            for (key, value) in param {
                formData.append((value.data(using: .utf8)!), withName: key)
            }
        }, to: urlUpload, headers: headers, encodingCompletion: {encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    self.loadingSuccess()
                    
                    guard let result = response.result.value else {
                        SVProgressHUD.showError(withStatus: "服务器有点问题")
                        return
                    }
                    let json = JSON(result)
                    if json["success"].boolValue {
                        SVProgressHUD.showSuccess(withStatus: "发布成功")
//                        SVProgressHUD.showInfo(withStatus: json["message"].stringValue)
                        NotificationCenter.default.post(name: NSNotification.Name.init("refreshFriendView"), object: nil)
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        SVProgressHUD.showError(withStatus: json["message"].stringValue)
                    }
                    
                   
                }
            case .failure( _):
                self.loadingSuccess()
                SVProgressHUD.showError(withStatus: "上传失败,请稍后重试")
            }
        })
    }
    
    func postZanData(comment:String)  {
        var emoji = comment
        emoji = (comment + " ").toBase64()! + "\n"

        let userID = STUserTool.account().userID
        let urlUpload = "\(baseUrl)/admir/saveAdmir"
        let headers = ["t_userId":userID,
                       "token":STUserTool.account().token]
        Alamofire.upload(multipartFormData: { formData in
            let param = ["userId":userID,
                         "content":emoji,"toUserId":self.mod?.userId]
          
            for index in 0..<self.photoArray.count {
                let imageData = UIImageJPEGRepresentation(self.photoArray[index], 0.3)
                formData.append(imageData!, withName: "imgFiles", fileName: "photo.png", mimeType: "image/jpg")
            }
            
            for (key, value) in param {
                formData.append((value!.data(using: .utf8)!), withName: key)
            }
        }, to: urlUpload, headers: headers, encodingCompletion: {encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    self.loadingSuccess()
                    
                    guard let result = response.result.value else {
                        SVProgressHUD.showError(withStatus: "服务器有点问题")
                        return
                    }
                    let json = JSON(result)
                    if json["success"].boolValue {
                        SVProgressHUD.showSuccess(withStatus: "发布成功")
//                        SVProgressHUD.showInfo(withStatus: json["message"].stringValue)
                        NotificationCenter.default.post(name: NSNotification.Name.init("refreshZanVC"), object: nil)
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        SVProgressHUD.showError(withStatus: json["message"].stringValue)
                    }
                    
                    
                }
            case .failure( _):
                self.loadingSuccess()
                SVProgressHUD.showError(withStatus: "上传失败,请稍后重试")
            }
        })
    }
}

extension CQPublishToCircleVC:UITextViewDelegate{
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

extension CQPublishToCircleVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoArray.count + 1
    }
    
}

extension CQPublishToCircleVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQCirclePublishCellId", for: indexPath) as! CQCirclePublishCell
        if self.photoArray.count == 0 {
            if indexPath.item == 0{
                cell.img.image = UIImage.init(named: "CQCirclePublishAdd")
                cell.deleteBtn.isHidden = true
            }
        }else {
            if indexPath.item == self.photoArray.count {
                cell.img.image = UIImage.init(named: "CQCirclePublishAdd")
                cell.deleteBtn.isHidden = true
            }else {
                cell.img.image = self.photoArray[indexPath.item]
                cell.deleteBtn.isHidden = false
                cell.deleteDelegate = self
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
        
        
    }
    
}

extension CQPublishToCircleVC{
    func initImgPick()  {
        let imagePickerVc = TZImagePickerController(maxImagesCount: 9, delegate: self)
        imagePickerVc?.allowTakePicture = false
        self.present(imagePickerVc!, animated: true, completion: nil)
    }
}

extension CQPublishToCircleVC: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        photoArray.insert(contentsOf: photos, at: 0)
        if photoArray.count > 9 {
            photoArray.removeSubrange(photoArray.indices.suffix(from: 9))
        }
        print(photoArray.count)
        
        self.collectionView.frame = CGRect.init(x: kLeftDis, y: self.txtView.bottom+AutoGetHeight(height: 18), width: kHaveLeftWidth, height: (kHaveLeftWidth-AutoGetWidth(width: 30))/4 * CGFloat((self.photoArray.count/4)+1) + 10 * CGFloat((self.photoArray.count/4)+1))
       
        if isFromZan == true{
             self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 126+31) + (kHaveLeftWidth-AutoGetWidth(width: 30))/4 * CGFloat((self.photoArray.count/4)+1) + 20 * CGFloat((self.photoArray.count/4)+1))
        }else{
             self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 126) + (kHaveLeftWidth-AutoGetWidth(width: 30))/4 * CGFloat((self.photoArray.count/4)+1) + 20 * CGFloat((self.photoArray.count/4)+1))
        }
        collectionView.reloadData()
    }
}

extension CQPublishToCircleVC:CQPublishDeleteDelegate{
    func deletePublishPic(index: IndexPath) {
        self.collectionView.reloadData()
        self.photoArray.remove(at: index.item)
    }
    
    
}


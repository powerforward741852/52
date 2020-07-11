//
//  CQSmileWallVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/8/23.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQSmileWallVC: SuperVC {

    var dataArray = [CQSmileWallModel]()
    var secDataArray = [CQSmileWallModel]()
    var pageNum = 1
    var lastImage:UIImageView?   //上一张
    var firstImage:UIImageView?  //前一张
    let shopID : String = "CQSmileWallCellId"
    var imageArray = [String]()
    var headerModel:CQSmileWallModel?
    
    lazy var collectionView: UICollectionView = {
        //布局
        let layout = NDCollectionView()
        
        //创建collectionView
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: CGFloat(SafeAreaTopHeight), width: kWidth, height: kHeight - CGFloat(SafeAreaTopHeight) ), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SmileHeader")
//        collectionView.register(CQSmileWallCell.self, forCellWithReuseIdentifier: shopID)
        return collectionView
    }()
    
   
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        self.title = "笑脸墙"
        self.navigationItem.rightBarButtonItem = self.rightButtonWithImg(image: UIImage.init(named: "SmileTakePhoto")!)
        self.loadData()
        
    }
    
    func loadData()  {
        self.getMySmileWall()
        self.setUpRefresh()
    }
    
    func initView()  {
        self.view.addSubview(self.collectionView)
    }
    override func rightItemClick() {
        self.initLibImgPicker()
    }
    
    func initLibImgPicker()  {
        KiClipperHelper.sharedInstance.nav = navigationController
        KiClipperHelper.sharedInstance.clippedImgSize = CGSize.init(width: AutoGetWidth(width: 100), height: AutoGetWidth(width: 100))
        KiClipperHelper.sharedInstance.clippedImageHandler = {[weak self]img in
            self?.uploadImage(header: img)
        }
        KiClipperHelper.sharedInstance.clipperType = .Stay
        KiClipperHelper.sharedInstance.systemEditing = false
        KiClipperHelper.sharedInstance.isSystemType = false
        takePhoto()
    }
    
    func takePhoto() {
        
        //        KiClipperHelper.sharedInstance.photoWithSourceType(type: .photoLibrary) //直接打开相册选取图片
        
        //        KiClipperHelper.sharedInstance.photoWithSourceType(type: .camera) //打开相机拍摄照片
        
        var message = ""
        message = "请选择"
        let alertSheet = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        // 2 命令（样式：退出Cancel，警告Destructive-按钮标题为红色，默认Default）
        let cancelAction = UIAlertAction(title: "取消", style:  .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "拍照", style:  .default, handler:{
            action in
            KiClipperHelper.sharedInstance.photoWithSourceType(type: .camera)
        })
        
        let archiveAction = UIAlertAction(title: "从相册选择", style: .default, handler: {
            action in
            KiClipperHelper.sharedInstance.photoWithSourceType(type: .photoLibrary)
        })
        
        alertSheet.addAction(cancelAction)
        alertSheet.addAction(deleteAction)
        alertSheet.addAction(archiveAction)
        // 3 跳转
        self.present(alertSheet, animated: true, completion: nil)
    }
}

extension CQSmileWallVC{
    
    fileprivate func setUpRefresh() {
        // MARK:header
        let STHeader = CQRefreshHeader {[unowned self] in
            self.getMySmileWall()
            self.loadDatas(moreData: false)
        }
        self.collectionView.mj_header = STHeader
        self.collectionView.mj_header.beginRefreshing()
    }
    // MARK:request
    fileprivate func loadDatas(moreData: Bool) {
        if moreData {
            pageNum += 1
        } else {
            pageNum = 1
        }
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/smileWall/getSmileWallByPage" ,
            type: .get,
            param: ["userId":userID,
                    "currentPage":pageNum,
                    "rows":"1000"],
            successCallBack: { (result) in
                var tempArray = [CQSmileWallModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQSmileWallModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                self.dataArray = tempArray
                
                self.imageArray.removeAll()
                self.imageArray.append((self.headerModel?.imageUrl)!)
                for model in self.dataArray{
                    self.imageArray.append(model.imageUrl)
                }
                
                
                //刷新表格
                self.collectionView.mj_header.endRefreshing()
                self.collectionView.reloadData()
                
                
                
                
        }) { (error) in
            self.collectionView.reloadData()
            self.collectionView.mj_header.endRefreshing()
        }
    }
}

extension CQSmileWallVC{
    
    //删除笑脸
    func deleteSmileWallRequest(model:CQSmileWallModel) {
        SVProgressHUD.show()
        STNetworkTools.requestData(URLString:"\(baseUrl)/smileWall/deleteAllSmileWall" ,
            type: .post,
            param: ["smileWallIds[]":model.smileWallId],
            successCallBack: { (result) in
                SVProgressHUD.dismiss()
                SVProgressHUD.showInfo(withStatus: result["message"].stringValue)
                self.getMySmileWall()
                self.reloadCurrentData()
                
        }) { (error) in
            SVProgressHUD.dismiss()
        }
    }
    
    
    
    //赞与取消赞
    func saveSmileWallLaudRequest(model:CQSmileWallModel) {
        let userID = STUserTool.account().userID
        var laudMode = ""
        if model.laudStatus{
            laudMode = "0"
        }else{
            laudMode = "1"
        }
        STNetworkTools.requestData(URLString:"\(baseUrl)/smileWall/saveSmileWallLaud" ,
            type: .post,
            param: ["userId":userID,
                    "laudMode":laudMode,
                    "smileWallId":model.smileWallId],
            successCallBack: { (result) in
                self.getMySmileWall()
                self.reloadCurrentData()
                
        }) { (error) in
            
        }
    }
    
    //获取我的笑脸墙
    func getMySmileWall() {
        let userID = STUserTool.account().userID
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/smileWall/getMySmileWall" ,
            type: .get,
            param: ["userId":userID],
            successCallBack: { (result) in
                
                guard let modal = CQSmileWallModel(jsonData: result["data"]) else {
                    return
                }
                
                self.headerModel = modal
                
                self.initView()
                
                self.collectionView.reloadData()
                
                
        }) { (error) in
            
        }
    }
    
    
    func reloadCurrentData() {
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/smileWall/getSmileWallByPage" ,
            type: .get,
            param: ["userId":userID,
                    "currentPage":"1",
                    "rows":"1000"],
            successCallBack: { (result) in
                var tempArray = [CQSmileWallModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQSmileWallModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                
                self.dataArray = tempArray
                
                self.imageArray.removeAll()
                self.imageArray.append((self.headerModel?.imageUrl)!)
                for model in self.dataArray{
                    self.imageArray.append(model.imageUrl)
                }
                
                self.collectionView.reloadData()
        }) { (error) in
            self.collectionView.reloadData()
        }
    }
}

extension CQSmileWallVC{
    func uploadImage(header: UIImage) {
        let urlUpload = "\(baseUrl)/smileWall/saveSmileWall"
        let headers = ["t_userId":STUserTool.account().userID,
                       "token":STUserTool.account().token]
        
        Alamofire.upload(multipartFormData: { formData in
            let userID = STUserTool.account().userID
            let param = ["userId":userID]
            //图片
            let imageData = UIImageJPEGRepresentation(header, 0.3)
            formData.append(imageData!, withName: "imgFile", fileName: "photo.png", mimeType: "image/jpg")
            
            for (key, value) in param {
                formData.append((value.data(using: .utf8)!), withName: key)
            }
        }, to: urlUpload, headers: headers, encodingCompletion: {encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    guard let result = response.result.value else {
                        SVProgressHUD.showError(withStatus: "服务器有点问题")
                        return
                    }
                    let json = JSON(result)
                    if json["success"].boolValue {
                        SVProgressHUD.showSuccess(withStatus: "上传成功")
                            self.getMySmileWall()
                            self.setUpRefresh()
                        
                    } else {
                        SVProgressHUD.showError(withStatus: json["message"].stringValue)
                    }
                }
            case .failure( _):
                SVProgressHUD.showError(withStatus: "服务器有点问题")
            }
        })
    }
}

extension CQSmileWallVC : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if 0 == section{
            return 1
        }
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cId = String.init(format: "%d%ld", indexPath.section,indexPath.item)
        self.collectionView.register(CQSmileWallCell.self, forCellWithReuseIdentifier: cId)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cId, for: indexPath) as! CQSmileWallCell
        for v in cell.contentView.subviews{
            v.removeFromSuperview()
        }
        if 1 == indexPath.section{
            cell.model = self.dataArray[indexPath.item]
            cell.zanDelegate = self
        }else{
            cell.headModel = self.headerModel
            cell.zanDelegate = self
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0{
            if !(self.headerModel?.imageUrl.isEmpty)!{
                let previewVC = ImagePreViewVC(images: self.imageArray, index: 0)
                self.navigationController?.pushViewController(previewVC, animated: true)
            }else{
                self.initLibImgPicker()
            }
        }else{
            let previewVC = ImagePreViewVC(images: self.imageArray, index: indexPath.item + 1)
            self.navigationController?.pushViewController(previewVC, animated: true)
        }
    }
    
    // 返回区头
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if section == 0 {
//            return CGSize(width: UIScreen.main.bounds.width, height: 248)
//        }else {
//            // 不返回区头
//            return CGSize(width: UIScreen.main.bounds.width, height: CGFloat.leastNormalMagnitude)
//        }
//    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        var header:UICollectionReusableView!
//        if kind == UICollectionElementKindSectionHeader {
//
//            header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SmileHeader", for: indexPath)
//
//            for v in header.subviews{
//                v.removeFromSuperview()
//            }
//
//            let img = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: 248))
//            img.image = UIImage.init(named: "")
//            img.backgroundColor = UIColor.red
//            header.addSubview(img)
//
//        }
//
//
//        return header
//    }
}

extension CQSmileWallVC:CQSmileZanDelegate{
    func deleteAction(index: IndexPath) {
        let model = self.dataArray[index.item]
        self.deleteSmileWallRequest(model: model)
    }
    
    func zanAction(index: IndexPath) {
        let model = self.dataArray[index.item]
        self.saveSmileWallLaudRequest(model: model)
    }
}

//   MARK:判断一个数是否能整除另一个数
extension CQSmileWallVC{
    func judgeInt(count:Int) -> Bool {
        if count % 2 != 0 {
            return false
        }
        return true
    }
}


//
//  CQEnterpriseInfoVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/2.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit
import AVKit
import AssetsLibrary
import MediaPlayer
import MobileCoreServices
class CQEnterpriseInfoVC: SuperVC {
   //媒体报道
    var isFromMTBD = false
    var siteType = ""
    
    var photoArray = [UIImage]()
    var dataArray = [CQEnterpriseInfoModel]()
    var typeId = ""
    var pageNum = 1
    
    var titleStr = ""
    var selectArr = [Bool]()
    var shareUrl = ""
    var selectModelArray = [CQEnterpriseInfoModel]()
    var createRight = false
    var flag = ""
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight-AutoGetHeight(height: 49)-SafeAreaBottomHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.backgroundColor = kProjectBgColor
        table.delegate = self
        table.dataSource = self
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    
    lazy var footView: UIView = {
        let footView = UIView.init(frame: CGRect.init(x: 0, y: kHeight - AutoGetWidth(width: 49) - SafeAreaBottomHeight, width: kWidth, height: AutoGetWidth(width: 49) + SafeAreaBottomHeight))
        footView.backgroundColor = UIColor.white
        footView.layer.borderWidth = 0.5
        footView.layer.borderColor = kLyGrayColor.cgColor
        return footView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = kProjectBgColor
       
        
        
//        if self.createRight {
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 28, height: 28))
        rightBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        rightBtn.setImage(UIImage.init(named: "FriendAdd"), for: .normal)
        rightBtn.addTarget(self, action: #selector(upLoadClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
//        }
        
        if isFromMTBD {
            rightBtn.isHidden = true
            self.getMicroWebInfoList()
        }else{
             self.setUpRefresh()
        }
        
        self.view.addSubview(self.table)
        self.table.register(CQEnterpriseInfoCell.self, forCellReuseIdentifier: "CQEnterpriseInfoCellId")

        
    }
    
    
    func getMicroWebInfoList() {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/information/getCompanyFolders" ,
            type: .get,
            param: ["emyeId":userID,"siteType":siteType],
            successCallBack: { (result) in
                var tempArray = [CQEnterpriseInfoModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQEnterpriseInfoModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
               self.dataArray = tempArray
                self.table.reloadData()
                //
                //                if siteType == "1"{
                //                    self.titleArr[3][3] = nameArr.first!
                //                    self.imageArr[3][3] = iconArr.first!
                //                }else if siteType == "2"{
                //                    self.titleArr[3][4] = nameArr.first!
                //                    self.imageArr[3][4] = iconArr.first!
                //                }
                //
                //
                //                //
                //
                //                self.collectionView.reloadData()
        }) { (error) in
                self.table.reloadData()
        }
    }
    
    
    @objc func upLoadClick()  {

        takePhoto()
    }

    func takePhoto() {
        
       
        let alertSheet = UIAlertController(title: "", message: "请选择上传类型", preferredStyle: UIAlertControllerStyle.actionSheet)
        // 2 命令（样式：退出Cancel，警告Destructive-按钮标题为红色，默认Default）
        let cancelAction = UIAlertAction(title: "取消", style:  .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "上传图片", style:  .default, handler:{
            action in
            self.photoLib()
        })
        
        let archiveAction = UIAlertAction(title: "上传视频", style: .default, handler: {
            action in
            self.videoLib()
        })
        
        alertSheet.addAction(cancelAction)
        alertSheet.addAction(deleteAction)
        alertSheet.addAction(archiveAction)
        // 3 跳转
        self.present(alertSheet, animated: true, completion: nil)
    }
    
    
    //图库 - 照片
    func photoLib(){
        //
        flag = "图片"
        //判断设置是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //弹出控制器，显示界面
            self.present(picker, animated: true, completion: nil)
        }else{
            print("读取相册错误")
        }
    }
    
    
    //图库 - 视频
    func videoLib(){
        flag = "视频"
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            //初始化图片控制器
            let imagePicker = UIImagePickerController()
            //设置代理
            imagePicker.delegate = self
            //指定图片控制器类型
            imagePicker.sourceType = .photoLibrary;
            //只显示视频类型的文件
            imagePicker.mediaTypes =  [kUTTypeMovie as String]
            //不需要编辑
            imagePicker.allowsEditing = false
            //弹出控制器，显示界面
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            print("读取相册错误")
        }
    }
    
    func initFootView(titleArr:[String],imageArr:[String])  {
        for i in 0..<titleArr.count {
            let btn = UIButton.init(type: .custom)
            btn.frame = CGRect.init(x: kWidth/CGFloat(titleArr.count) * CGFloat(i), y: 0, width: kWidth/CGFloat(titleArr.count), height: 49)
            btn.addTarget(self, action: #selector(barSelectAction(btn:)), for: .touchUpInside)
            btn.tag = 100+i
            self.footView.addSubview(btn)
            
            let iconImg = UIImageView.init(frame: CGRect.init(x: (kWidth/CGFloat(titleArr.count) - AutoGetWidth(width: 23))/CGFloat(titleArr.count) + kWidth/CGFloat(titleArr.count) * CGFloat(i), y: 5, width: AutoGetWidth(width: 23), height: 23))
            iconImg.image = UIImage.init(named: imageArr[i])
            iconImg.isUserInteractionEnabled = false
            iconImg.tag = 200+i
            self.footView.addSubview(iconImg)
            
            let lab = UILabel.init(frame: CGRect.init(x:kWidth/CGFloat(titleArr.count) * CGFloat(i) , y: iconImg.bottom + 5, width: kWidth/CGFloat(titleArr.count), height: 11))
            lab.font = kFontSize11
            lab.text = titleArr[i]
            lab.textColor = kLightBlueColor
            lab.textAlignment = .center
            lab.isUserInteractionEnabled = false
            if i == 0{
                if imageArr[0] == "ShareUnAble"{
                    btn.isUserInteractionEnabled = false
                    lab.textColor = kLyGrayColor
                }else{
                    btn.isUserInteractionEnabled = true
                    lab.textColor = kLightBlueColor
                }
            }else if i == 1{
                if imageArr[1] == "shanchu"{
                    btn.isUserInteractionEnabled = false
                    lab.textColor = kLyGrayColor
                }else{
                    btn.isUserInteractionEnabled = true
                    lab.textColor = kLightBlueColor
                }
            }
            
            self.footView.addSubview(lab)
        }
    }
    
    func initShareView()  {
        let shareV = CQShareView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - CGFloat(SafeAreaBottomHeight)))
        shareV.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
        shareV.cqShareDelegate = self
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.addSubview(shareV)
    }
    
    @objc func barSelectAction(btn:UIButton) {
        self.selectModelArray.removeAll()
        for i in 0..<self.selectArr.count{
            let status = selectArr[i]
            let model = self.dataArray[i]
            if status == true{
                self.selectModelArray.append(model)
            }
        }
        
        if 100 == btn.tag{
            if self.selectModelArray.count ==  1{
                if self.selectModelArray[0].allowShare {
                    self.initShareView()
                    self.shareUrl = "\(baseUrl)/information/downFile" + "?entityId=" + self.selectModelArray[0].attachmentId + "&version=v1"
                    DLog(self.shareUrl)
                }else{
                    SVProgressHUD.showInfo(withStatus: "此文件不支持分享")
                }
            }else{
                SVProgressHUD.showInfo(withStatus: "只能选择一个文件进行分享")
            }
        }else {
            if self.selectModelArray.count > 0{
                var idArray = [String]()
                for i in 0..<self.selectModelArray.count{
                    let model = self.selectModelArray[i]
                    if !model.isDelete {
                        
                        SVProgressHUD.showInfo(withStatus: model.attachmentName + "不允许删除")
                        return
                    }else{
                        
                        idArray.append(model.entityId)
                    }
                }
                self.deleteFileRequest(userIds: idArray)
            }else{
                SVProgressHUD.showInfo(withStatus: "请选择要删除的文件")
            }
        }
    }
    
    
    /// 转换视频
    ///
    /// - Parameters:
    ///   - inputPath: 输入url
    ///   - outputPath:输出url
    func transformMoive(inputPath:String,outputPath:String){
        
        
        let avAsset:AVURLAsset = AVURLAsset(url: URL.init(fileURLWithPath: inputPath), options: nil)
        let assetTime = avAsset.duration
        
        let duration = CMTimeGetSeconds(assetTime)
        print("视频时长 \(duration)");
        let compatiblePresets = AVAssetExportSession.exportPresets(compatibleWith: avAsset)
        if compatiblePresets.contains(AVAssetExportPresetLowQuality) {
            let exportSession:AVAssetExportSession = AVAssetExportSession.init(asset: avAsset, presetName: AVAssetExportPresetMediumQuality)!
            let existBool = FileManager.default.fileExists(atPath: outputPath)
            if existBool {
            }
            exportSession.outputURL = URL.init(fileURLWithPath: outputPath)
            
            
            exportSession.outputFileType = AVFileType.mp4
            exportSession.shouldOptimizeForNetworkUse = true;
            exportSession.exportAsynchronously(completionHandler: {
                
                switch exportSession.status{
                    
                case .failed:
                    
                    print("失败...\(String(describing: exportSession.error?.localizedDescription))")
                    break
                case .cancelled:
                    print("取消")
                    break;
                case .completed:
                    print("转码成功")
                    let mp4Path = URL.init(fileURLWithPath: outputPath)
//                    self.uploadVideo(mp4Path: mp4Path,type:"file")
                    self.uploadImage(type: "file", name: "", urlPath: mp4Path)
                    break;
                default:
                    print("..")
                    break;
                }
            })
        }
    }

}

extension CQEnterpriseInfoVC{
    
    func setUpRefresh()  {
        // MARK:header
        let STHeader = CQRefreshHeader {[unowned self] in
            self.dataArray.removeAll()
            self.selectArr.removeAll()
            self.getCompanyDataList(moreData: false)
        }
        // MARK:footer
        let STFooter = CQRefreshFooter {[unowned self] in
            self.getCompanyDataList(moreData: true)
        }
        self.table.mj_header = STHeader
        self.table.mj_footer = STFooter
        self.table.mj_header.beginRefreshing()
    }
    
    func getCompanyDataList(moreData: Bool) {
        if moreData {
            pageNum += 1
        } else {
            pageNum = 1
        }
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/information/getCompanyDateList" ,
            type: .get,
            param: ["emyeId":userID,
                    "currentPage":pageNum,
                    "typeId":self.typeId,
                    "pageSize":10,
                    "searchName":""],
            successCallBack: { (result) in
                var tempArray = [CQEnterpriseInfoModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQEnterpriseInfoModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                
                if moreData {
                    self.dataArray.append(contentsOf: tempArray)
                } else {
                    self.dataArray = tempArray
                }
                //刷新表格
                self.table.mj_header.endRefreshing()
                self.table.mj_footer.endRefreshing()
                self.table.reloadData()
                
                //分页控制
                let total = result["total"].intValue
                if self.dataArray.count == total {
                    self.table.mj_footer.endRefreshingWithNoMoreData()
                }else {
                    self.table.mj_footer.resetNoMoreData()
                }
                self.selectArr.removeAll()
                for _ in self.dataArray {
                    self.selectArr.append(false)
                }
                
        }) { (error) in
            self.table.reloadData()
            self.table.mj_header.endRefreshing()
            self.table.mj_footer.endRefreshing()
        }
    }
    
    //删除文件
    func deleteFileRequest(userIds:[String])  {
        var userIdArrayName = ""
        for i in 0..<userIds.count{
            if 0 == i{
                userIdArrayName = userIds[0]
            }else{
                userIdArrayName = userIdArrayName + "," + userIds[i]
            }
        }
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/information/deleteFile" ,
            type: .get,
            param: ["articleIds":userIdArrayName],
            successCallBack: { (result) in
                SVProgressHUD.showSuccess(withStatus: "文件删除成功")
                
                self.setUpRefresh()

        }) { (error) in
            
        }
    }
    
    //上传文件
    @objc func uploadImage(type:String,name:String,urlPath:URL?)  {
        let userID = STUserTool.account().userID
        let urlUpload = "\(baseUrl)/information/uploadFile"
        let headers = ["t_userId":userID,
                       "token":STUserTool.account().token]
        Alamofire.upload(multipartFormData: { formData in
            let param = ["emyeId":userID,
                         "type":type,
                         "typeId":self.typeId]
            
            //            if self.photoArray.count <= 10 && self.photoArray.count>0 {
            //                self.photoArray.removeLast()
            //            }
            
            let now = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
            var current = ""
            current = dateFormat.string(from: now)
            let realName = STUserTool.account().realName
            var name = ""
            name = realName + " " + current + ".png"
            DLog(name)
            if type == "image"{
                for index in 0..<self.photoArray.count {
                    let imageData = UIImageJPEGRepresentation(self.photoArray[index], 0.3)
                    formData.append(imageData!, withName: "file", fileName:name, mimeType: "image/jpg")
                }
            }else{
//                for index in 0..<self.photoArray.count {
                    let vidioName = realName + current + ".mp4"
                    formData.append(urlPath!, withName: "file", fileName: vidioName, mimeType: "video/mp4")
//                }
            }
            
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
                        self.setUpRefresh()
                        //SVProgressHUD.showSuccess(withStatus: "上传成功")
                        SVProgressHUD.showInfo(withStatus: json["message"].stringValue)
                    } else {
                        SVProgressHUD.showError(withStatus: json["message"].stringValue)
                    }
                    
                   
                }
            case .failure( _):
                SVProgressHUD.showError(withStatus: "上传失败,请稍后重试")
            }
        })
    }
    
    //上传视频到服务器
    func uploadVideo(mp4Path : URL,type:String){
        let userID = STUserTool.account().userID
        let urlUpload = "\(baseUrl)/information/uploadFile"
        let headers = ["t_userId":userID,
                       "token":STUserTool.account().token,
                       "type":type]
        Alamofire.upload(
            //同样采用post表单上传
            multipartFormData: { multipartFormData in
                let param = ["emyeId":userID,
                             "typeId":self.typeId]
                multipartFormData.append(mp4Path, withName: "file", fileName: "123456.mp4", mimeType: "video/mp4")
                
                for (key, value) in param {
                    multipartFormData.append((value.data(using: .utf8)!), withName: key)
                }
                
                //服务器地址
        },to:urlUpload,headers:headers ,encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                //json处理
                upload.responseJSON { response in
                    //解包
                    guard let result = response.result.value else { return }
                    print("json:\(result)")
                }
                //上传进度
                upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                    print("视频上传进度: \(progress.fractionCompleted)")
//                    self.setUpRefresh()
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
}

extension CQEnterpriseInfoVC:CQShareDelegate{
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
         let titles = selectModelArray.first?.name
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: "",
                                          images : img,
                                          url : NSURL(string:self.shareUrl) as URL?,
                                          title : titles,
                                          type : SSDKContentType.auto )
        
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


extension CQEnterpriseInfoVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQEnterpriseInfoCellId") as! CQEnterpriseInfoCell
       
        if isFromMTBD{
            cell.isFromMTBD = true
        }else{
            cell.selectDelegate = self
            cell.selectStatus = self.selectArr[indexPath.row]
            cell.layoutSubviews()
        }
         cell.model = self.dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataArray[indexPath.row]
        
        
        if isFromMTBD{
            let vc = QRMicorwebVc.init()
            vc.typeId = model.entityId
            vc.siteType = siteType
            vc.title = model.typeName
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            
            if model.type == "2" {
                let vc = CQEnterpriseDocVC.init()
                vc.typeId = model.entityId
                vc.titleStr = model.name
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                if self.createRight{
                    //                if  (model.name as NSString).contains("mp4"){
                    //                    guard let viedioUrl = URL.init(string: "https://v.qq.com/x/cover/my08b9236yzg960/u0744fwzckp.html") else {fatalError("连接错误")}
                    //                }else{
                    let vc = CQWebVC()
                    let url = "\(baseUrl)/information/downFile" + "?entityId=" + model.attachmentId + "&version=v1"
                    DLog(url)
                    vc.urlStr = url
                    vc.titleStr = model.name
                    if model.attachmentName.hasSuffix(".pdf"){
                        vc.isPDF = true
                    }else{
                        vc.isPDF = false
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                    //                }
                }
            }
            
        }
        
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoGetHeight(height: 63)
    }
}

extension CQEnterpriseInfoVC:CQEnterpreiseBaseDelegate{
    func selectIndex(index: IndexPath) {
        let num = index.row
        let sec = index.row + 1
        let selectStaues = selectArr[index.row]
        self.selectArr.replaceSubrange(Range(num ..< sec), with: [!selectStaues])
        self.table.reloadData()
        
        self.view.addSubview(self.footView)

        
        
        self.selectModelArray.removeAll()
        for i in 0..<self.selectArr.count{
            let status = selectArr[i]
            let model = self.dataArray[i]
            if status == true{
                self.selectModelArray.append(model)
            }
        }
        
        if selectModelArray.count == 0  {
            self.footView.removeAllSubviews()
        }
        
        
        for model in self.selectModelArray{
            self.footView.removeAllSubviews()
            if model.allowShare && model.isDelete {
                self.initFootView(titleArr: ["分享","删除"], imageArr: ["EnterpriseDocBarShare","EnterpriseDocBarDelete"])
            }else if model.allowShare && !model.isDelete{
                self.initFootView(titleArr: ["分享","删除"], imageArr: ["EnterpriseDocBarShare","shanchu"])
            }else if !model.allowShare && model.isDelete{
                self.initFootView(titleArr: ["分享","删除"], imageArr: ["ShareUnAble","EnterpriseDocBarDelete"])
            }else if !model.allowShare && !model.isDelete{
                self.initFootView(titleArr: ["分享","删除"], imageArr: ["ShareUnAble","shanchu"])
            }
        }
 
    }
    
    
}

extension CQEnterpriseInfoVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if flag == "视频" {
            
            //获取选取的视频路径
            let videoURL = info[UIImagePickerControllerMediaURL] as! URL
            let pathString = videoURL.path
            print("视频地址：\(pathString)")
            //图片控制器退出
            self.dismiss(animated: true, completion: nil)
            let outpath = NSHomeDirectory() + "/Documents/\(Date().timeIntervalSince1970).mp4"
            //视频转码
            self.transformMoive(inputPath: pathString, outputPath: outpath)
        }else{
            //flag = "图片"
            self.photoArray.removeAll()
            //获取选取后的图片
            let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.photoArray.append(pickedImage)
            //上传
            self.uploadImage(type: "image", name: "",urlPath:nil)
            //图片控制器退出
            self.dismiss(animated: true, completion:nil)
        }
    
    }
    
    
}

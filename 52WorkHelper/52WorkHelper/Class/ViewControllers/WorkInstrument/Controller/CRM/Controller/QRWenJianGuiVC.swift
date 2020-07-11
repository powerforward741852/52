//
//  QRWenJianGuiVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/17.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit
import AVKit
import AssetsLibrary
import MediaPlayer
import MobileCoreServices
class QRWenJianGuiVC: SuperVC {
    
    static let CellIdentifier = "wenjianID"
    var photoArray = [UIImage]()
    //当前页
    var currentPage = 1
    //客户id
    var customerId = ""
    //关键词
    var keyWord = ""
    //行
    var rows = "15"
    //选中记录
    var selectArr = [Bool]()
    var shareUrl = ""
    var shareText = ""
    var dataArray = [QRFileModel]()
    var selectModelArray = [QRFileModel]()

    var flag = ""
    lazy var searchBar: SSSearchBar = {
        let searchbar = SSSearchBar(frame:  CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 45)))
        searchbar.delegate = self
        searchbar.barTintColor = UIColor.white
        searchbar.searchBarStyle = UISearchBarStyle.minimal
        searchbar.placeholder = "  搜索"
        return searchbar
    }()
    lazy var footView: UIView = {
        let footView = UIView.init(frame: CGRect.init(x: 0, y: kHeight - AutoGetHeight(height: 49), width: kWidth, height: AutoGetHeight(height: 49)))
        footView.backgroundColor = UIColor.white
        footView.layer.borderWidth = 0.5
        footView.layer.borderColor = kLyGrayColor.cgColor
        return footView
    }()
    
    
    lazy var searchView: UIView = {
        let searchView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 45)))
        searchView.backgroundColor = UIColor.white
        searchView.layer.borderColor = kLineColor.cgColor
        searchView.layer.borderWidth = 0.5
        return searchView
    }()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.register(QRFileCell.self, forCellReuseIdentifier:QRWenJianGuiVC.CellIdentifier )
        table.rowHeight = 64
        return table
    }()
    
    
    lazy var  bottomBar : UIView = {
       let upload = UIView()
        upload.frame =  CGRect(x: 0, y: kHeight-54-CGFloat(SafeAreaBottomHeight), width: kWidth, height: 54 + CGFloat(SafeAreaBottomHeight))
        upload.backgroundColor = kProjectBgColor
        let but = UIButton()
        but.setTitleColor(UIColor.white, for: .normal)
        but.setTitle("上传文件", for: .normal)
        but.titleLabel?.font = kFontSize20
        but.backgroundColor = kColorRGB(r: 44, g: 160, b: 255)
        but.frame =  CGRect(x: 15, y: 5, width: kWidth-30, height: 44)
        but.addTarget(self, action: #selector(uploadFile), for: .touchUpInside)
        upload.addSubview(but)
        return upload
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "文件柜"
        table.backgroundColor = kProjectBgColor
        view.addSubview(table)
        self.table.tableHeaderView = self.searchView
        self.searchView.addSubview(self.searchBar)
        view.addSubview(bottomBar)
        self.setUpRefresh()
        
    }
    
    
    func setUpRefresh() {
        // MARK:header
        let STHeader = CQRefreshHeader {[unowned self] in
            self.loadDatas(moreData: false)
        }
        // MARK:footer
        let STFooter = CQRefreshFooter {[unowned self] in
            self.loadDatas(moreData: true)
        }
        self.table.mj_header = STHeader
        self.table.mj_footer = STFooter
        self.table.mj_header.beginRefreshing()
    }
    
    
    func loadDatas(moreData: Bool) {
        if moreData {
            currentPage += 1
        } else {
            currentPage = 1
        }
        STNetworkTools.requestData(URLString:"\(baseUrl)/crmFileCabinet/getFileByCustomerIdPage",
            type: .get,
            param:  ["customerId": customerId,
                     "currentPage":currentPage ,
                     "rows":rows,"keyWord":keyWord],
            successCallBack: { (result) in
                
                
                var tempArray = [QRFileModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = QRFileModel(jsonData: modalJson) else {
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

    
 //   删除文件
    func deleteFileRequest(userIds:[String])  {
        var userIdArrayName = ""
        for i in 0..<userIds.count{
            if 0 == i{
                userIdArrayName = userIds[0]
            }else{
                userIdArrayName = userIdArrayName + "," + userIds[i]
            }
        }
        let userid = STUserTool.account().userID
        print(userIdArrayName)
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/crmFileCabinet/deleteFiles" ,
            type: .post,
            param: ["attachmentIds[]":userIdArrayName,"customerId":customerId,"userId":userid],
            successCallBack: { (result) in
                SVProgressHUD.showSuccess(withStatus: "文件删除成功")
                
                self.setUpRefresh()
                
        }) { (error) in
            
        }
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
    
  
    //上传文件
    @objc func uploadImage(type:String,name:String,urlPath:URL?)  {
        let userID = STUserTool.account().userID
        let urlUpload = "\(baseUrl)/crmFileCabinet/uploadFile"
        let headers = ["t_userId":userID,
                       "token":STUserTool.account().token]
        Alamofire.upload(multipartFormData: { formData in
            let param = ["userId":userID,
                         "customerId":self.customerId]
            
    
            
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
                      //  SVProgressHUD.showSuccess(withStatus: "上传成功")
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
                    //    self.uploadVideo(mp4Path: mp4Path,type:"file")
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


extension QRWenJianGuiVC: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        var cell  = (tableView.dequeueReusableCell(withIdentifier: QRWenJianGuiVC.CellIdentifier, for: indexPath) as! QRFileCell) ;
//        if cell == nil   {
        let    cell = QRFileCell(style: .default, reuseIdentifier: QRWenJianGuiVC.CellIdentifier)
//        }
        cell.model = dataArray[indexPath.row]
        cell.selectDelegate = self
        cell.selectStatus = self.selectArr[indexPath.row]
        cell.layoutSubviews()
        
        
        
        return cell
    }
    
    
}

extension QRWenJianGuiVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let mod = dataArray[indexPath.row]
        let vc = CQWebVC()
        let url = "\(baseUrl)/information/downFile" + "?entityId=" + mod.attachmentId
        DLog(url)
        vc.urlStr = url
        vc.titleStr = mod.attachmentOldName
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//        let mod = dataArray[indexPath.row]
//        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
//            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let fileURL = documentsURL.appendingPathComponent("file1/myLogo.png")
//            //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
//            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
//        }
//    
//        let header = ["t_userId":STUserTool.account().userID,
//                       "token":STUserTool.account().token]
//
//        Alamofire.download("\(baseUrl)/crmFileCabinet/downloadFile",parameters: ["attachmentId":"\(mod.attachmentId)"],headers : header,to: destination)
//            .response { response in
//                print(response.destinationURL?.path)
//                let videoPath = response.destinationURL?.path
//                if let path = videoPath {
//                    if  FileManager.default.fileExists(atPath:path){
//                        UISaveVideoAtPathToSavedPhotosAlbum(path, self, #selector(self.video(videoPath:didFinishSavingWithError:contextInfo:)), nil)
//                     }
//                }
//
//            }.downloadProgress { (progess) in
//                print("已下载：\(progess.completedUnitCount/1024)KB")
//                print("总大小：\(progess.totalUnitCount/1024)KB")
//            }.responseData { (response) in
//
//                if let data = response.result.value {
//                    print("下载完毕!")
////                    if ispic {
//                    //下载图片保存在相册
//                    let image = UIImage(data: data)
//                    //图片过大转换成png格式,再转成图片/避免图片过大而崩溃
//                    let img = UIImagePNGRepresentation(image!)
//                    let ima = UIImage(data: img!)
//                    UIImageWriteToSavedPhotosAlbum(ima!, self, #selector(self.saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
//
////                    }else{
//                    //下载视频保存在相册
//
////                    }
//
//
//                }
//
//        }
//
//
//    }




//:MARK- 点击事件
extension QRWenJianGuiVC{

    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        var showMessage = ""
        if error != nil{
            showMessage = "保存失败"
        }else{
            showMessage = "保存成功"
        }
        SVProgressHUD.showInfo(withStatus: showMessage)
    }
    @objc private func video(videoPath:String ,didFinishSavingWithError error:NSError?, contextInfo: AnyObject){
        var showMessage = ""
        if error != nil{
            showMessage = "保存失败"
        }else{
            showMessage = "保存成功"
        }
        SVProgressHUD.showInfo(withStatus: showMessage)
    }
//  - (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    
    
    @objc func uploadFile(){
        DLog("上传文件")
        let items = ["上传图片","上传视频"]
        let vProperty = FWSheetViewProperty()
        vProperty.touchWildToHide = "1"
        let sheetView = FWSheetView.sheet(title:"", itemTitles: items, itemBlock: { [unowned self] (popupView, index, title) in
            //编辑商机
            if index == 0{
             self.photoLib()
            }else{
             self.videoLib()
            }
        }, cancenlBlock: {
            print("点击了取消")
        }, property: vProperty)
        sheetView.show()
        
        
        
    }
}
extension QRWenJianGuiVC : QRFileCellSelectDelegate{
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
            self.footView.removeFromSuperview()
        }
        
        self.initFootView(titleArr: ["分享","删除"], imageArr: ["EnterpriseDocBarShare","EnterpriseDocBarDelete"])
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
//            if i == 0{
//                if imageArr[0] == "ShareUnAble"{
//                    btn.isUserInteractionEnabled = false
//                    lab.textColor = kLyGrayColor
//                }else{
//                    btn.isUserInteractionEnabled = true
//                    lab.textColor = kLightBlueColor
//                }
//            }else if i == 1{
//                if imageArr[1] == "shanchu"{
//                    btn.isUserInteractionEnabled = false
//                    lab.textColor = kLyGrayColor
//                }else{
//                    btn.isUserInteractionEnabled = true
//                    lab.textColor = kLightBlueColor
//                }
//            }
            
            self.footView.addSubview(lab)
        }
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
//                if self.selectModelArray[0].allowShare {
//                }else{
//                    SVProgressHUD.showInfo(withStatus: "此文件不支持分享")
//                }
                self.initShareView()
                self.shareUrl = "\(baseUrl)/information/downFile" + "?entityId=" + self.selectModelArray[0].attachmentId + "&version=v1"
                self.shareText = self.selectModelArray[0].attachmentOldName
                DLog(self.shareUrl)
            }else{
                SVProgressHUD.showInfo(withStatus: "只能选择一个文件进行分享")
            }
        }else {
            if self.selectModelArray.count > 0{
                
                //                    if !model.isDelete {
                //                  SVProgressHUD.showInfo(withStatus: model.attachmentName + "不允许删除")
                //                        return
                //                    }else{
                //                    }
                var idArray = [String]()
                for i in 0..<self.selectModelArray.count{
                    let model = self.selectModelArray[i]
                    idArray.append(model.attachmentId)
                }
                self.deleteFileRequest(userIds: idArray)
            }else{
                SVProgressHUD.showInfo(withStatus: "请选择要删除的文件")
            }
        }
    }
    
    
    
    func initShareView()  {
        let shareV = CQShareView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - CGFloat(SafeAreaBottomHeight)))
        shareV.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
        shareV.cqShareDelegate = self
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.addSubview(shareV)
    }
    
}


extension QRWenJianGuiVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
   
        
    
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



extension QRWenJianGuiVC:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //开始搜索并显示在table上
        
        if let tex = searchBar.text {
            self.keyWord = tex
            self.table.mj_header.beginRefreshing()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            self.keyWord = ""
              self.loadDatas(moreData: false)
        }else{
            self.keyWord = searchText
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}

extension QRWenJianGuiVC :UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}
extension QRWenJianGuiVC:CQShareDelegate{
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
        
        
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: shareText,
                                          images : UIImage(named: "1024"),
                                          url : NSURL(string:self.shareUrl) as URL?,
                                          title : shareText,
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



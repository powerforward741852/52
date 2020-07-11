//
//  CQBussinessCardListVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2019/1/11.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit
import WebKit
import Contacts
import MessageUI
import Messages

class CQBussinessCardListVC: SuperVC {
    var PhotosArray = [UIImage]()
    //分享类型
    var type : Int?
    var dataArray = [CQBussinessCardListModel]()
    var myRevertPhotosArray = [UIImage]()
    var pageNum = 1
    var searchWord = ""
    var curModel:CQBussinessCardListModel?
    var bgBtn = UIButton.init(type: .custom)
    var bV:CQBussinessBottomSelectV?
    var telArr = [String]()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y:SafeAreaTopHeight, width: kWidth, height: kHeight - SafeAreaTopHeight ), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        if #available(iOS 11.0, *) {
//            table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
//            table.contentInset = UIEdgeInsetsMake(CGFloat(SafeAreaTopHeight), 0, CGFloat(SafeAreaBottomHeight), 0);
//            table.scrollIndicatorInsets = table.contentInset;
            
        } else {
           self.automaticallyAdjustsScrollViewInsets = false
            //低于 iOS 9.0
        }
        return table
    }()
    
    lazy var searchView: UIView = {
        let searchView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 45)))
        searchView.backgroundColor = UIColor.white
        searchView.layer.borderColor = kLineColor.cgColor
        searchView.layer.borderWidth = 0.5
        return searchView
    }()
    
    lazy var searchBar: CQBusinessCaedSearchBar = {
        let searchBar = CQBusinessCaedSearchBar.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 5), width: kHaveLeftWidth, height: AutoGetHeight(height: 35)))
        searchBar.delegate = self
        searchBar.returnKeyType = .search
        return searchBar
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //单选
        NotificationCenter.default.addObserver(self, selector: #selector(popToRootNext(notification:)), name: NSNotification.Name(rawValue: "popToRootnNxt"), object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(popToRoot(notification:)), name: NSNotification.Name(rawValue: "popToRoot"), object: nil)
        //多选
//        NotificationCenter.default.addObserver(self, selector: #selector(popToRootNext(notification:)), name: NSNotification.Name(rawValue: "popToRootnNxt"), object: nil)
//        NotificationCenter.default.addObserver(self, selector:  #selector(popToRoot(notification:)), name: NSNotification.Name(rawValue: "popToRoot"), object: nil)
        
//        self.loadData()
        self.initView()
        self.loadData()
        
       
        

    }
  

    deinit {
        NotificationCenter.default.removeObserver(self)
        
    }
    
   
    
    @objc func popToRoot(notification:Notification) {
        self.navigationController?.popToViewController(self, animated: true)
        self.loadDatas(moreData: false)
    }
    @objc func popToRootNext(notification:Notification) {
        self.loadData()
        self.navigationController?.popToViewController(self, animated: true)
        let  camera = QRCameraViewController()
        camera.modalPresentationStyle = .fullScreen
        self.present(camera, animated: true) {
          //  self.navigationController?.popViewController(animated: false)
            camera.rootVc = self
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func loadData()  {
        self.loadingPlay()
        self.setUpRefresh()
    }
    
    func initView()  {
        self.title = "名片夹"
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.searchView
        self.searchView.addSubview(self.searchBar)
        self.table.register(UINib.init(nibName: "CQBussinessCardListCell", bundle: Bundle.init(identifier: "CQBussinessCardListCellId")), forCellReuseIdentifier: "CQBussinessCardListCellId")
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44))
        rightBtn.setImage(UIImage.init(named: "FriendAdd"), for: .normal)
        rightBtn.addTarget(self, action: #selector(addClick), for: .touchUpInside)
        rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func bgClick()  {
        DLog(self.navigationController?.view.subviews.count)
        self.bV?.removeAllSubviews()
        self.bV?.removeFromSuperview()
        self.bgBtn.removeFromSuperview()
    }

    @objc func addClick()  {
        initSelectView()
    }
    
    func initSelectView()  {
        let selectView = CQBussinessSelectV.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight))
        selectView.cqSelectDelegate = self
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.addSubview(selectView)
        
    }
    
}

//Mark 数据加载
extension CQBussinessCardListVC{
    fileprivate func setUpRefresh() {
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
    // MARK:request
    fileprivate func loadDatas(moreData: Bool) {
        if moreData {
            pageNum += 1
        } else {
            pageNum = 1
        }
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/crmBusinessCard/getCardList" ,
            type: .get,
            param: ["emyeId":userID,
                    "currentPage":pageNum,
                    "pageSize":"10",
                    "searchWord":self.searchWord],
            successCallBack: { (result) in
                var tempArray = [CQBussinessCardListModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQBussinessCardListModel(jsonData: modalJson) else {
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
                
                self.loadingSuccess()
                
        }) { (error) in
            self.table.reloadData()
            self.table.mj_header.endRefreshing()
            self.table.mj_footer.endRefreshing()
            self.loadingSuccess()
        }
    }
}

extension CQBussinessCardListVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "CQBussinessCardListCellId", for: indexPath) as! CQBussinessCardListCell
        cell.showDelegate = self
        cell.model = self.dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = CQBussinessCardDtVC.init()
        vc.cardId = self.dataArray[indexPath.row].cardId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 97
    }
}

// Mark:添加按钮代理
extension CQBussinessCardListVC:CQBussinessCardListSelectDelegate{
    
    func pushToEdite(){
        let vc = CQEditBCVC.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushToDetailThroughType(btn: UIButton) {
        
      
        if 400 == btn.tag{
            checkAuthen()
        }else if 401 == btn.tag{
            let vc = CQEditBCVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            checkPhotoAuthen()
        }
        
    }
    
    func initImgPick()  {
        let imagePickerVc = TZImagePickerController(maxImagesCount: 1, delegate: self)
        imagePickerVc?.allowTakePicture = false
        self.present(imagePickerVc!, animated: true, completion: nil)
    }
    func checkPhotoAuthen()  {
        //MARK: APP启动时候，判断用户是否授权使用相册
        if ( PHPhotoLibrary.authorizationStatus() == .restricted || PHPhotoLibrary.authorizationStatus() == .denied) {
            //用户首次拒接
            print("拒绝APP访问相机")
            //设置提示提醒用户打开定位服务
            let alert = UIAlertController.init(title: "无法访问照片", message: "在设置中打开照片权限,以保存名片图片到手机相册", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "去设置", style: .default) { (al) in
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
            return
        }else if PHPhotoLibrary.authorizationStatus() == .notDetermined{
            PHPhotoLibrary.requestAuthorization({(firstStatus) in
                let result = (firstStatus == .authorized)
                if result {
                   
                } else {
                   
                }
            })
        }
        //进入相册
        initImgPick()
    }
  
    
    func checkAuthen()  {
        if ( AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .restricted || AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .denied ) {
            //设置提示提醒用户打开定位服务
            let alert = UIAlertController.init(title: "无法访问相机", message: "请在设置中打开设置权限,以拍摄识别名片", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "去设置", style: .default) { (al) in
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
            return
        }else if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (statusFirst) in
                if statusFirst {
                    // print("允许APP访问相机")
                } else {
                    //弹窗访问是否允许访问相机
                    //self.checkAuthen()
                    return
                }
            })
        }
        //MARK: APP启动时候，判断用户是否授权使用相册
//        if (PHPhotoLibrary.authorizationStatus() == .notDetermined || PHPhotoLibrary.authorizationStatus() == .restricted || PHPhotoLibrary.authorizationStatus() == .denied) {
//            //用户首次拒接
//            print("拒绝APP访问相机")
//            //设置提示提醒用户打开定位服务
//            let alert = UIAlertController.init(title: "无法访问照片", message: "在设置中打开照片权限,以保存名片图片到手机相册", preferredStyle: .alert)
//            let ok = UIAlertAction.init(title: "去设置", style: .default) { (al) in
//                //打开定位设置
//                if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
//                    UIApplication.shared.openURL(appSettings as URL)
//                }
//            }
//            let cancel = UIAlertAction.init(title: "取消", style: .cancel) { (ca) in
//            }
//            alert.addAction(ok)
//            alert.addAction(cancel)
//            self.present(alert, animated: true, completion: nil)
//            return
//        }
        
        let reflash = QRCameraViewController()
        reflash.rootVc = self
        reflash.modalPresentationStyle = .fullScreen
        self.present(reflash, animated: true) {}
    }
    
    
    
    //上传图片识别
    func loadRecognizePic()  {
        //图片识别
        SVProgressHUD.show(withStatus: "图片识别中....")
        let userID = STUserTool.account().userID
        let urlUpload = "\(baseUrl)/crmBusinessCard/disCardInfo"
        let headers = ["t_userId":userID,
                       "token":STUserTool.account().token]
        Alamofire.upload(multipartFormData: { formData in
            
            let now = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
            var current = ""
            current = dateFormat.string(from: now)
            var name = ""
            name =   current + ".png"
            print(self.PhotosArray)
            for index in 0..<self.PhotosArray.count {
                let imageData = UIImageJPEGRepresentation(self.PhotosArray[index], 0.3)
                formData.append(imageData!, withName: "files", fileName: name+"\(index)", mimeType: "image/jpg")
               
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
                    var tempArr = [CQBussinessCardListModel]()
                    for modalJson in json["data"].arrayValue {
                        guard let modal = CQBussinessCardListModel(jsonData: modalJson) else {
                            return
                        }
                        tempArr.append(modal)
                    }
                    
                    
                    if json["success"].boolValue {
                        SVProgressHUD.showSuccess(withStatus: "识别成功")
                        let vc = CQAutoEditBussinessCardVC()
                        vc.curModel = tempArr.first
                        vc.type = 0
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    } else {
                        SVProgressHUD.showError(withStatus: json["message"].stringValue)
                    }
                    
                }
            case .failure( _):
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "识别失败,请稍后重试")
                
            }
        })
        
    
        
    }
}
extension CQBussinessCardListVC : TZImagePickerControllerDelegate{
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        PhotosArray.removeAll()
        PhotosArray.insert(contentsOf: photos, at: 0)
      //  myRevertPhotosArray.insert(UIImage(named: "annn")!, at: 0)
//        if PhotosArray.count > 9 {

            self.loadRecognizePic()
//        }
//        print(PhotosArray.count)
        //压缩图片,并且识别
        
    }
    
    
}

extension CQBussinessCardListVC : ShowBtnDelegate{
    func showChooseClick(index: IndexPath ,but: UIButton) {
        let rect = but.convert(but.bounds, to: self.view)
        let x = rect.origin.x-35
        let y = rect.origin.y+rect.size.height/2
        print(rect)
        let pop = QRCirclePopview.creatPopview(center: CGPoint(x: x, y: y), imgs:["cdh","beiz","cfx"] , titles: ["电话","备注","分享"])
        pop.clickClosure = {[unowned self] select in
            if select == 0 {
                self.telArr.removeAll()
                for jsonModel in self.dataArray[index.row].mobile{
                    if jsonModel.stringValue==""{
                        
                    }else{
                      self.telArr.append(jsonModel.stringValue)
                    }
                    
                }
                
                for jsonModel in self.dataArray[index.row].phone{
                    if jsonModel.stringValue == ""{
                        
                    }else{
                        self.telArr.append(jsonModel.stringValue)
                    }
                    
                }
                
                self.bgBtn.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight)
                self.bgBtn.backgroundColor = UIColor.colorWithHexString(hex: "#000000")
                self.bgBtn.alpha = 0.8
                self.bgBtn.addTarget(self, action: #selector(self.bgClick), for: .touchUpInside)
                self.navigationController?.view.addSubview(self.bgBtn)
                
                self.bV = CQBussinessBottomSelectV.init(frame: CGRect.init(x: 0, y: kHeight - (CGFloat(self.telArr.count) * 50 + 60) - SafeAreaBottomHeight, width: kWidth, height:CGFloat(self.telArr.count) * 50 + 60), dataArray: self.telArr)
                self.bV!.telDelegate = self
                self.bV!.cancelDelegate = self
                self.bV!.isTel = true
                self.navigationController?.view.addSubview(self.bV!)
            }else if select == 1{
                //备注
                let remark = CQBCardRemarkVC()
                remark.cardId = self.dataArray[index.row].cardId
                self.navigationController?.pushViewController(remark, animated: true)
            }else if select == 2{
                //分享
                pop.alpha = 0
                self.share(index: index)
            }
        }
        pop.showPopView()
    }
    
    func initShareView(index: IndexPath)  {
        let shareV = CQShareView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - CGFloat(SafeAreaBottomHeight)))
       // shareV.type = type
        shareV.setData()
        shareV.backgroundColor = kAlpaRGB(r: 0, g: 0, b: 0, a: 0.7)
        shareV.cqShareDelegate = self
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.addSubview(shareV)
        
        self.curModel = self.dataArray[index.row]
    }
    
    //分享朋友圈
    @objc func share(index: IndexPath){
        initShareView(index: index)
    }
    
}

extension CQBussinessCardListVC : CQShareDelegate {
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
        let shareUrl = "http://crm.52zhushou.com/crm/card/shareCard?cardId=" + (self.curModel?.cardId)!
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: "分享" + (self.curModel?.realName)! + "的名片",
                                          images : UIImage.init(named: "1024"),
                                          url : NSURL(string:shareUrl) as URL?,
                                          title :  "名片分享",
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


extension CQBussinessCardListVC:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let search = textField as! CQBusinessCaedSearchBar
        search.searchbut?.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchWord = textField.text!
        textField.resignFirstResponder()
        self.loadingPlay()
        self.setUpRefresh()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}

extension CQBussinessCardListVC:BCardBottomTelSelectDelegate{
    func showTelChooseClick(index: IndexPath) {
        self.bgClick()
        
        //自动打开拨号页面并自动拨打电话
        if  !self.telArr[index.row].isEmpty {
            let telStr = self.telArr[index.row]
//            let str = (telStr as NSString).replacingOccurrences(of: "手机 ", with: "").replacingOccurrences(of: "电话 ", with: "")
            let urlString = "tel://" + telStr
            if let url = URL(string: urlString) {
                //根据iOS系统版本，分别处理
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:],
                                              completionHandler: {
                                                (success) in
                                                
                    })
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}

extension CQBussinessCardListVC:BCardBottomCancelDelegate{
    func cancelAction() {
        self.bgClick()
    }
}

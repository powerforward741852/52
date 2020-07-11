//
//  QRCameraViewController.swift
//  WWXHCamera
//
//  Created by 秦榕 on 2019/1/9.
//  Copyright © 2019年 weiwu. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion
import Photos

protocol QRCameraViewControllerDelegate : NSObjectProtocol{
    func cameraViewController(_ : QRCameraViewController, didFinishPickingImage image: UIImage)
}

class QRCameraViewController: UIViewController {
    enum FlashBtnType: Int {
        case on = 11131
        case auto = 11132
        case off = 11133
    }
    //款款
    var myKkView : CALayer?
    
    var firstType : Int = -1
    var myBackView : UIView?
    //编辑添加图片
    var isEdit = false
    //声明闭包
    typealias clickBtnClosure = (_ shangxian: UIImage?) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    
    //rootvc
    var rootVc : CQBussinessCardListVC?
    //是否反面
    var isRevert = false
    //单张拍摄与多张拍摄,默认是0,单张
    var type : Int = 0
    //弹窗
    var popImgView : QRPhotoView?
    // session 用来执行输入设备和输出设备之间的数据传递
    var session: AVCaptureSession = AVCaptureSession()
    // 输入设备
    var deviceCap : AVCaptureDevice?
    // 输入设备
    var videoInput: AVCaptureInput?
    // 照片输出流
    var stillImageOutput: AVCaptureStillImageOutput = AVCaptureStillImageOutput()
    // 预览图层
    var previewLayer: AVCaptureVideoPreviewLayer?
    // 管理者对象
    var motionManger: CMMotionManager = CMMotionManager()
    // 拍照点击按钮
    var takePhotoBtn: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 56, height: 56))
    // 拍照返回按钮
    var backBtn: UIButton = UIButton(frame: CGRect(x:AutoGetWidth(width: 15), y: SafeAreaStateTopHeight+10, width: 40, height: 30))
    //图片按钮
    var ImgBtn: UUButton = UUButton(frame: CGRect(x: 45, y: 0, width: 70, height:70))
    // 提醒文字
    var tipsLabel: UILabel?
    // 闪光灯打开
    var flashlightButtonOn: UIButton = UIButton(frame: CGRect(x: kWidth - 35, y:SafeAreaStateTopHeight + 10, width: 25, height: 25))
    // 闪光灯关闭
    var flashlightButtonOff: UIButton = UIButton(frame: CGRect(x:kWidth - 65, y:SafeAreaStateTopHeight + 10, width: 25, height: 25))
    // 闪光灯自动
    var flashlightButtonAuto: UIButton = UIButton(frame: CGRect(x: 100, y:SafeAreaStateTopHeight + 10, width: 25, height: 25))
    // 前后摄像头切换按钮
    var cameraSwitchButton: UIButton = UIButton(frame: CGRect(x: kWidth - 20 - 30, y: 0, width: 40, height: 40))
    //切换拍摄模式滚动视图
    var cateBut : JXCategoryTitleView = JXCategoryTitleView(frame: CGRect(x: 0, y: kHeight, width: 160, height: 30))
    
    //完成按钮
    var DoneButton: UIButton = UIButton(frame: CGRect(x: kWidth, y:kHeight + 10, width: 65, height: 30))
    
    //正面照片数组
    var PhotosArray = [UIImage]()
    //反面照片数组
    var myRevertPhotosArray = [UIImage]()
    
    var isUsingFrontFacingCamera: Bool = true
    
    weak var delegate: QRCameraViewControllerDelegate?
    
    var coverImage = UIImage(named: "虚线比对框") // 这个遮罩图片一般是外部传 在demo里 我就直接写死了😁
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        self.setupAVCaptureSession()
        self.setUpUI()
        self.addGesture()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session.startRunning()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.stopRunning()
        if (motionManger.isDeviceMotionActive) {
            motionManger.stopDeviceMotionUpdates()
        }
    }
    
    func initImgPick()  {
        let imagePickerVc = TZImagePickerController(maxImagesCount: 1, delegate: self)
        imagePickerVc?.allowTakePicture = false
        self.present(imagePickerVc!, animated: true, completion: nil)
    }
    func addGesture()  {
        let swipGesleft = UISwipeGestureRecognizer(target: self, action: #selector(swipLR(ges:)))
        swipGesleft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipGesleft)
        let swipGesRight = UISwipeGestureRecognizer(target: self, action: #selector(swipLR(ges:)))
        swipGesRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipGesRight)
    }
    @objc func swipLR(ges:UISwipeGestureRecognizer){
        
        if isEdit == true{
            
        }else{
            if ges.direction == .left {
                self.cateBut.selectItem(at: 1)
            }
            if ges.direction == .right{
                self.cateBut.selectItem(at: 0)
            }
        }
        
    }
    
    
    func setUpUI() {
        self.view.backgroundColor = UIColor.black
        //添加手势
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapTouchIn(ges:)))
        tapGes.delegate = self
        view.addGestureRecognizer(tapGes)
        
        // 初始化相机按钮
        let backView = UIView(frame:  CGRect(x: 0, y: kHeight-AutoGetHeight(height: 128)-SafeTabbarBottomHeight/2, width: kWidth, height: AutoGetHeight(height: 128)+SafeTabbarBottomHeight/2))
        backView.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.7)
        self.view.addSubview(backView)
        self.myBackView = backView
        
        // 初始化相机按钮
        takePhotoBtn.addTarget(self, action: #selector(takePhoto), for: UIControlEvents.touchUpInside)
        takePhotoBtn.setImage(UIImage(named: "anniu"), for: UIControlState.normal)
        takePhotoBtn.setImage(UIImage(named: "anniu"), for: UIControlState.highlighted)
        takePhotoBtn.setImage(UIImage(named: "anniu"), for: UIControlState.disabled)
        takePhotoBtn.center = CGPoint(x: kWidth * 0.5, y: AutoGetHeight(height: 128)/2 + 15 )
        backView.addSubview(takePhotoBtn)
        
        ImgBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        ImgBtn.setTitle("相册", for: UIControlState.normal)
        ImgBtn.setImage(UIImage(named: "xiangce"), for: UIControlState.normal)
        ImgBtn.contentAlignment = .centerImageTop
        ImgBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        ImgBtn.addTarget(self, action: #selector(jumpInPhotoLib), for: UIControlEvents.touchUpInside)
        ImgBtn.center.y = takePhotoBtn.center.y
        ImgBtn.center.x = kWidth/4*3+5
        backView.addSubview(ImgBtn)

        
        
        
        
        // 初始化返回按钮
        backBtn.setTitle("取消", for: UIControlState.normal)
        backBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        backBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        backBtn.addTarget(self, action: #selector(back), for: UIControlEvents.touchUpInside)
        backBtn.sizeToFit()
        self.view.addSubview(backBtn)
        
        
        
        
        //切换滚动视图
        self.cateBut.frame.origin.x =  self.takePhotoBtn.center.x - 5 - 160/4 
        self.cateBut.frame.origin.y = takePhotoBtn.top - 40
        self.cateBut.titles = ["单张拍摄","连续拍摄"]
        cateBut.titleColorGradientEnabled = true
        cateBut.titleLabelZoomEnabled = true
        cateBut.titleColor = UIColor.white
        cateBut.titleSelectedColor = UIColor.colorWithHexString(hex: "23aaf0")
        cateBut.titleSelectedFont = kFontSize15
        cateBut.titleFont = UIFont.systemFont(ofSize: 13)
        cateBut.titleLabelZoomScale = 1.1
        cateBut.sizeToFit()
        self.cateBut.delegate = self;
        backView.addSubview(self.cateBut)
        
        
        //框框
        let kkView = CALayer.init()
//        kkView.frame = CGRect(x: AutoGetHeight(height: 40), y: backBtn.bottom+30, width: kWidth-AutoGetHeight(height: 80), height: kHeight-SafeTabbarBottomHeight-AutoGetHeight(height: 128)-SafeAreaStateTopHeight-80-30)
        if SafeAreaStateTopHeight == 44{
            kkView.frame = CGRect(x: AutoGetHeight(height: 40), y: backBtn.bottom+45, width: kWidth-AutoGetHeight(height: 80), height: (kWidth-AutoGetHeight(height: 80))*1.5)
        }else{
            kkView.frame = CGRect(x: AutoGetHeight(height: 50), y: backBtn.bottom+15, width: kWidth-AutoGetHeight(height: 100), height: (kWidth-AutoGetHeight(height: 100))*1.5)
        }
        
        
        kkView.contents = UIImage(named: "anquank")?.cgImage
        self.view.layer.addSublayer(kkView)
        self.myKkView = kkView
        
        
        
        //        // 初始化完成按钮
        //        DoneButton.setTitle("完成", for: UIControlState.normal)
        //        DoneButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        //        DoneButton.addTarget(self, action: #selector(back), for: UIControlEvents.touchUpInside)
        //        DoneButton.center.y = takePhotoBtn.center.y
        //        DoneButton.left = takePhotoBtn.right+35
        //        DoneButton.isHidden = true
        //        self.view.addSubview(DoneButton)
        
        
        // 图片按钮
//        let lastA = lastAssert()
//        let imgs = UIImage(named: "photo_nor")
//        if lastA!.count>0{
//            PHImageManager.default().requestImage(for: (lastA?.firstObject)!, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.default, options: nil) { (img, _) in
//                self.ImgBtn.setImage(img, for: UIControlState.normal)
//            }
//        }else{
//           ImgBtn.setImage(imgs, for: UIControlState.normal)
//        }
        
        
        // 初始化闪光灯开启按钮
//        flashlightButtonOn.setImage(UIImage(named: "flashlight_on"), for: UIControlState.normal)
//        flashlightButtonOn.setImage(UIImage(named: "flashlight_on_sel"), for: UIControlState.selected)
//        flashlightButtonOn.addTarget(self, action: #selector(flashlightButtonClick), for: UIControlEvents.touchUpInside)
//        flashlightButtonOn.tag = FlashBtnType.on.rawValue
//        self.view.addSubview(flashlightButtonOn)
        
        // 初始化闪光灯自动按钮
//        flashlightButtonAuto.setImage(UIImage(named: "flashlight_auto"), for: UIControlState.normal)
//        flashlightButtonAuto.setImage(UIImage(named: "flashlight_auto_sel"), for: UIControlState.selected)
//        flashlightButtonAuto.addTarget(self, action: #selector(flashlightButtonClick), for: UIControlEvents.touchUpInside)
//        flashlightButtonAuto.tag = FlashBtnType.auto.rawValue
//        self.view.addSubview(flashlightButtonAuto)
        
        // 初始化闪光灯关闭按钮
//        flashlightButtonOff.setImage(UIImage(named: "flashlight_off"), for: UIControlState.normal)
//        flashlightButtonOff.setImage(UIImage(named: "flashlight_off_sel"), for: UIControlState.selected)
//        flashlightButtonOff.addTarget(self, action: #selector(flashlightButtonClick), for: UIControlEvents.touchUpInside)
//        flashlightButtonOff.tag = FlashBtnType.off.rawValue
//        self.view.addSubview(flashlightButtonOff)
        
        // 设置闪光灯默认是自动
       // flashlightButtonAuto.isSelected = true
//        flashlightButtonOn.isSelected = true
//        flashlightButtonOff.isSelected = false
        
        // 初始化前后摄像头切换按钮
//        cameraSwitchButton.center.y = flashlightButtonOff.center.y
//        cameraSwitchButton.setImage(UIImage(named: "sight_camera_switch"), for: UIControlState.normal)
//        cameraSwitchButton.addTarget(self, action: #selector(switchCameraSegmentedControlClick), for: UIControlEvents.touchUpInside)
//        self.view.addSubview(cameraSwitchButton)
    
       
        
    }
    
    
    func setupAVCaptureSession() {
        
        //方法(1)AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        //方法(2)AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInDuoCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
        
//        NSArray<AVCaptureDeviceType> *deviceType = @[AVCaptureDeviceTypeBuiltInWideAngleCamera, AVCaptureDeviceTypeBuiltInDualCamera];
//        AVCaptureDeviceDiscoverySession *videoDeviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:deviceType mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionUnspecified];
        //获取 devices NSArray<AVCaptureDevice *> *devices = videoDeviceDiscoverySession.devices;
        
     
        
        
        
        self.session.sessionPreset = AVCaptureSession.Preset.high
//        if #available(iOS 10.2, *) {
//            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
//            self.deviceCap = device
//
//        } else {
//
//
//        }
        let device =  AVCaptureDevice.default(for: .video)
        self.deviceCap = device
     //   self.deviceCap = device
        
//        if #available(iOS 10.0, *) {
//            let xx = AVCaptureDevice.DiscoverySession
//        } else {
//            // Fallback on earlier versions
//        }
        
        
        //let device = AVCaptureDevice.devices(for: AVMediaType.video).first
        do {
            // 锁定设备之后才能修改设置,修改完再锁上
            try deviceCap?.lockForConfiguration()
            deviceCap?.flashMode = AVCaptureDevice.FlashMode.auto
            deviceCap?.isSubjectAreaChangeMonitoringEnabled = true
            deviceCap?.focusMode = AVCaptureDevice.FocusMode.continuousAutoFocus
            deviceCap?.unlockForConfiguration()
        } catch (let error){
            print(error)
        }
      //      self.focusOnCamera(point: view.center)
        //添加自动对焦功能
        NotificationCenter.default.addObserver(self, selector: #selector(subjectAreaChange), name: NSNotification.Name.AVCaptureDeviceSubjectAreaDidChange, object: nil)
        do {
            try videoInput = AVCaptureDeviceInput(device: deviceCap!)
        } catch (let error){
            print(error)
        }
        // 输出设置 AVVideoCodecJPEG  -> 输出jpeg格式图片
        stillImageOutput.outputSettings = [AVVideoCodecJPEG: AVVideoCodecKey]
        session.canAddInput(videoInput!) ? session.addInput(videoInput!) : ()
        session.canAddOutput(stillImageOutput) ? session.addOutput(stillImageOutput) : ()
        
        //初始化预览图层
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.frame = CGRect(x: 0, y: 0, width: kWidth, height: kHeight)
        if let previewLayer_ = previewLayer {
            self.view.layer.addSublayer(previewLayer_)
        }
    }
    
    @objc func subjectAreaChange(notification:Notification){
        print("change")
        
        
       // focusOnCamera(point: poi)
       // if (deviceCap?.isFocusModeSupported(AVCaptureDevice.FocusMode.autoFocus))!{
        
        //  self.perform(#selector(focusCenter), with: nil, afterDelay: 0.5)
        //}
       

        let poi = CGPoint(x: kWidth/2/kWidth, y: kHeight/2/kHeight)
        do {
            // 锁定设备之后才能修改设置,修改完再锁上
            try deviceCap?.lockForConfiguration()
            deviceCap?.focusPointOfInterest = poi
            deviceCap?.focusMode = .continuousAutoFocus
            deviceCap?.unlockForConfiguration()
        } catch (let error){
            print(error)
        }
        
    }
//    @objc func focusCenter(){
//        let poi = CGPoint(x: kWidth/2, y: kHeight/2)
//        do {
//            // 锁定设备之后才能修改设置,修改完再锁上
//            try deviceCap?.lockForConfiguration()
//            deviceCap?.focusPointOfInterest = poi
//            deviceCap?.focusMode = .autoFocus
//            deviceCap?.unlockForConfiguration()
//        } catch (let error){
//            print(error)
//        }
//    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
    }
   
   @objc func takePhoto() {
    //第一次记录标志
    if firstType == -1{
       self.firstType = type
    }else{
        
    }
//    if firstType == type{
//
//    }else{
//
//        SVProgressHUD.showInfo(withStatus: "切换模式")
//        self.PhotosArray.removeAll()
//        self.myRevertPhotosArray.removeAll()
//        firstType = type
//    }
    
//    if self.PhotosArray.count>=5 {
//        SVProgressHUD.showInfo(withStatus: "最多只能拍5张片")
//        return
//    }
    
    guard let stillImageConnection = stillImageOutput.connection(with: AVMediaType.video) else {
            print("相机初始化失败")
            return
        }
        let curDeviceOrientation = UIDevice.current.orientation
        //stillImageConnection.videoOrientation = curDeviceOrientation
        if let avcaptureOrientation = self.avOrientationForDeviceOrientation(deviceOrientation: curDeviceOrientation) {
            stillImageConnection.videoOrientation = avcaptureOrientation
            stillImageConnection.videoScaleAndCropFactor = 1
        }
        stillImageOutput.captureStillImageAsynchronously(from: stillImageConnection) {[unowned self] (imageDataSampleBuffer, error) in
            
            if let error_ = error {
                print(error_)
                return
            }
            guard let _ = imageDataSampleBuffer else {
                return
            }
            
            if let jpegData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!) {
                if let tempImage = UIImage(data: jpegData, scale: 1) {
                    print(tempImage.size)
                    //截取图片
//                    let scale = UIScreen.main.scale
//                    let tt = UIImage.init(tempImage, scaleTo: CGSize(width: kWidth*scale, height: kHeight*scale))
//                    let rect =  CGRect(x:((self.myKkView?.frame)!.minX+AutoGetWidth(width: 25))*scale , y: (self.myKkView?.frame)!.minY*scale, width: ((self.myKkView?.frame)!.size.width-AutoGetWidth(width: 50))*scale, height: (self.myKkView?.frame)!.size.height*scale)
//                    let pic = UIImage.init(from: tt, in: rect)
                    
                    let zoomScale = kWidth/tempImage.size.width
                    var rect = self.myKkView?.frame
                    rect?.origin.x /= zoomScale
                    rect?.origin.y /= zoomScale
                    rect?.size.width  /= zoomScale
                    rect?.size.height  /= zoomScale
                    let pic = tempImage.crop(rect!)
                    
                    let rePic = UIImage.init(pic, rotation: UIImageOrientation.left)
                    if self.type == 0{
                        //单拍时获取到的照片,显示出来同时上传
                       // self.ImgBtn.setImage(tempImage, for: UIControlState.normal)
                        self.PhotosArray.append(rePic!)
                        let pview = QRPhotoView.creatPhotoView()
                        self.popImgView = pview
                        pview.centerImg.image = pic
                        pview.type = 0
                        pview.showPotoview()
                        pview.clickClosure = {[unowned self] tag in
                            
                            self.ImgBtn.isHidden = true
                           
                            if tag == 0{
                                //重拍
                                self.PhotosArray.removeLast()
                                self.popImgView?.dismissPotoview()
                            }else if tag == 1 {
                                if self.isEdit == true{
                                    self.popImgView?.dismissPotoview()
                                    self.dismiss(animated: false, completion: nil)
                                    self.clickClosure!(self.PhotosArray.first)
                                }else{
                                    //确认,发起识别请求,
                                    //self.myRevertPhotosArray.append(UIImage(named: "annn")!)
                                    self.loadRecognizePic()
                                }
                                
                            }else if tag == 5{
                                //关闭
                                
                                if self.isEdit == true{
                                    self.popImgView?.dismissPotoview()
                                    self.dismiss(animated: false, completion: nil)
                                    self.clickClosure!(self.PhotosArray.first)
                                    
                                }else{
                                self.dismiss(animated: false, completion: {
                                    self.popImgView?.dismissPotoview()
                                })
                                }
                            }
                        }
                       
                    }else{
                        if self.isRevert == true{
                           self.myRevertPhotosArray.append(rePic!)
                        }else{
                            self.PhotosArray.append(rePic!)
                        }
                        let pview = QRPhotoView.creatPhotoView()
                        pview.myDoneBut?.setTitle("完成"+"(\(self.PhotosArray.count))", for: UIControlState.normal)
                        self.popImgView = pview
                        pview.type = 1
                        pview.isRevert = self.isRevert
                        pview.centerImg.image = pic
                        pview.clickClosure = {[unowned self] tag in
                           
                            self.ImgBtn.isHidden = true
                            self.DoneButton.isHidden = true
                            
                            //self.DoneButton.setTitle("完成"+"(\(self.PhotosArray.count))", for: UIControlState.normal)
                            if tag == 0{
                                //v重拍
                                self.PhotosArray.removeLast()
                                self.popImgView?.dismissPotoview()
                            }else if tag == 1{
                                //没拍反面就添加一张占位图
                                if self.isRevert == false{
                                    self.myRevertPhotosArray.append(UIImage(named: "annn")!)
                                }
                                self.isRevert = false
                                self.popImgView?.dismissPotoview()
                                //下一张
                            }else if tag == 2{
                                if self.isRevert == false{
                                    self.myRevertPhotosArray.append(UIImage(named: "annn")!)
                                }
                                self.isRevert = false
                                //完成
                                self.loadRecognizePic()
                            }else if tag == 3{
                                self.isRevert = true
                                self.popImgView?.dismissPotoview()
                                //拍反面
                            }else if tag == 4{
                                //重拍反面
                                self.myRevertPhotosArray.removeLast()
                                self.popImgView?.dismissPotoview()
                            }else if tag == 5{
                                //关闭
                                self.dismiss(animated: false, completion: {
                                    self.popImgView?.dismissPotoview()
                                })
                            }
                            
                        }
                        pview.showPotoview()
                    }
                    
                    
                    
                }
            }
        }
        
    }
    //进入相册
    @objc func jumpInPhotoLib(){
        initImgPick()
        
    }
//
//    @objc func clipPic(img:UIImage){
//        let scale = UIScreen.main.scale
//        let rect = CGRect(x: view.frame.minX * CGFloat(scale), y: view.frame.minY * CGFloat(scale), width: view.frame.width * CGFloat(scale), height: view.frame.height * CGFloat(scale))
//
//        UIGraphicsBeginImageContextWithOptions(rect.size, true, scale)
//        guard let context = UIGraphicsGetCurrentContext() else {
//            return nil
//        }
//      //  view.layer.render(in: context)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        //  这里是重点, 意思是取范围内的cgimage
//        let cgImage = (image?.cgImage)!.cropping(to: rect)
//    }
    
//    public func scale(_ scale:Int) -> CGRect{
//        var rect = self
//        rect.width = self.width * CGFloat(scale)
//        rect.height = self.height * CGFloat(scale)
//        rect.x = self.x * CGFloat(scale)
//        rect.y = self.y * CGFloat(scale)
//        return rect
//    }
   @objc func back() {
        self.dismiss(animated: true, completion: nil)
    }
    func avOrientationForDeviceOrientation(deviceOrientation: UIDeviceOrientation) -> AVCaptureVideoOrientation? {
        if (deviceOrientation == UIDeviceOrientation.landscapeLeft) {
            return AVCaptureVideoOrientation.landscapeRight
        } else if (deviceOrientation == UIDeviceOrientation.landscapeRight){
            return AVCaptureVideoOrientation.landscapeLeft
        } else if (deviceOrientation == UIDeviceOrientation.portrait){
            return AVCaptureVideoOrientation.portrait
        } else if (deviceOrientation == UIDeviceOrientation.portraitUpsideDown){
            return AVCaptureVideoOrientation.portraitUpsideDown
        } else {
            return nil
        }
    }
   @objc func flashlightButtonClick(_ sender: UIButton) {
        if let device = AVCaptureDevice.default(for: AVMediaType.video) {
            do {
                // 锁定设备之后才能修改设置,修改完再锁上
                try device.lockForConfiguration()
                if (device.hasFlash) {
                    if (sender.tag == FlashBtnType.on.rawValue) {
                        device.flashMode = AVCaptureDevice.FlashMode.on
                        flashlightButtonOn.isSelected = true
                        flashlightButtonAuto.isSelected = false
                        flashlightButtonOff.isSelected = false
                    } else if (sender.tag == FlashBtnType.auto.rawValue) {
                        device.flashMode = AVCaptureDevice.FlashMode.auto
                        flashlightButtonOn.isSelected = false
                        flashlightButtonAuto.isSelected = true
                        flashlightButtonOff.isSelected = false
                    } else if (sender.tag == FlashBtnType.off.rawValue) {
                        device.flashMode = AVCaptureDevice.FlashMode.off
                        flashlightButtonOn.isSelected = false
                        flashlightButtonAuto.isSelected = false
                        flashlightButtonOff.isSelected = true
                    }
                } else {
                    print("设备不支持闪光灯")
                }
                device.unlockForConfiguration()
            } catch (let error){
                print(error)
            }
        }
    }
    
  @objc  func switchCameraSegmentedControlClick(_ sender: UIButton) {
    let desiredPosition = isUsingFrontFacingCamera ? AVCaptureDevice.Position.front : AVCaptureDevice.Position.back
    for d in AVCaptureDevice.devices(for: AVMediaType.video) {
            if ((d as! AVCaptureDevice).position == desiredPosition) {
                previewLayer?.session!.beginConfiguration()
                do {
                    let input = try AVCaptureDeviceInput(device: d as! AVCaptureDevice)
                    for oldInput in (previewLayer?.session!.inputs)! {
                        previewLayer?.session!.removeInput(oldInput as! AVCaptureInput)
                    }
                    previewLayer?.session!.addInput(input)
                    previewLayer?.session!.commitConfiguration()
                } catch (let error) {
                    print(error)
                }
                break
            }
        }
        isUsingFrontFacingCamera = !isUsingFrontFacingCamera
    }
    
    func lastAssert() -> PHFetchResult<PHAsset>?{
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let assetsFetchResults = PHAsset.fetchAssets(with: options)
          return assetsFetchResults
    }
    
    @objc func tapTouchIn(ges:UITapGestureRecognizer){
        let poi = ges.location(in: view)
        let rec = self.myBackView?.convert((myBackView?.bounds)!, to: view)
        if (rec?.contains(poi))!{
            
        }else{
            focusOnCamera(point: poi)
        }
        
    }
    //对焦
    func focusOnCamera(point:CGPoint)  {
        let size = view.bounds.size
        let poi = CGPoint(x:point.x/size.width , y: point.y/size.height)
        do {
            // 锁定设备之后才能修改设置,修改完再锁上
            try deviceCap?.lockForConfiguration()
            deviceCap?.focusPointOfInterest = poi
            deviceCap?.focusMode = .continuousAutoFocus
            deviceCap?.unlockForConfiguration()
        } catch (let error){
            print(error)
        }
        self.view.isUserInteractionEnabled = false
        self.addFocusAnima(point: point)
    }
    
    func addFocusAnima(point:CGPoint)  {
       let focisImg = UIImageView(frame:  CGRect(x: point.x-20, y: point.y-20, width: 40, height: 40))
        focisImg.image = UIImage(named: "anquank")
        focisImg.isHidden = false
        
        view.addSubview(focisImg)
        UIView.animate(withDuration: 0.5, animations: {
            focisImg.frame = CGRect(x: point.x-30, y: point.y-30, width: 60, height: 60)
        }) { (boo) in
            focisImg.isHidden = true
            focisImg.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
        }
    }
    
}
//请求
extension QRCameraViewController{
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
            print(self.PhotosArray.count)
            for index in 0..<self.PhotosArray.count {
                let imageData = UIImageJPEGRepresentation(self.PhotosArray[index], 0.9)
                formData.append(imageData!, withName: "files", fileName: "\(index)"+name, mimeType: "image/jpg")
                if self.type == 1{
                    print(self.myRevertPhotosArray.count)
                    let reimageData = UIImageJPEGRepresentation(self.myRevertPhotosArray[index], 0.9)
                    formData.append(reimageData!, withName: "files", fileName: "\(index)r"+name, mimeType: "image/jpg")
                }
            }
            print(formData)

        }, to: urlUpload, headers: headers, encodingCompletion: {encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                     SVProgressHUD.dismiss()
                    guard let result = response.result.value else {
                        SVProgressHUD.showError(withStatus: "服务器有点问题")
                        return
                    }
                    let json = JSON(result)
                    
                    
                    var tempArray = [QRCardInfoModel]()
                    for modalJson in json["data"].arrayValue {
                        guard let modal = QRCardInfoModel(jsonData: modalJson) else {
                            return
                        }
                        tempArray.append(modal)
                    }
                    print(response)
                    
                    if self.type == 0{
                  
                        var tempArr = [CQBussinessCardListModel]()
                        var tempQrArr = [QRCardInfoModel]()
                        for modalJson in json["data"].arrayValue {
                            guard let modal = CQBussinessCardListModel(jsonData: modalJson) else {
                                return
                            }
                            guard let qrmodal = QRCardInfoModel(jsonData: modalJson) else {
                                return
                            }
                            
                            tempArr.append(modal)
                            tempQrArr.append(qrmodal)
                        }
                        
                        
                        if json["success"].boolValue {
                            
                            SVProgressHUD.showSuccess(withStatus: "识别成功")
                            let vc = CQAutoEditBussinessCardVC()
                            vc.curModel = tempArr.first
                            vc.onePassMod = tempQrArr.first
                            vc.type = 0
                            self.rootVc!.navigationController?.pushViewController(vc, animated: true)
                            self.dismiss(animated: false, completion: {
                                 self.popImgView?.dismissPotoview()
                            })
                            
                            
                        } else {
                            SVProgressHUD.showError(withStatus: json["message"].stringValue)
                        }
                       
                    }else{
                        let vc = CQBCardStoreStatusVC()
                        if json["success"].boolValue {
                            SVProgressHUD.showSuccess(withStatus: "识别成功")
                            vc.recognizeStaues = true
                        } else {
                            SVProgressHUD.showError(withStatus: json["message"].stringValue)
                            vc.recognizeStaues = false
                        }
                        vc.dataArray = tempArray
                        vc.type = self.type
                        vc.rootVc = self.rootVc
                        self.rootVc!.navigationController?.pushViewController(vc, animated: true)
                        
                        self.dismiss(animated: false, completion: {
                            self.popImgView?.dismissPotoview()
                        })
                    }
                   
                    

                    
                   


                    
                }
            case .failure( _):
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "识别失败,请稍后重试")
            }
        })
        
        
       
        
    }
    
    
}
extension QRCameraViewController:JXCategoryViewDelegate{
    func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {
        print(index)
        UIView.animate(withDuration: 0.5) {
            self.cateBut.frame.origin.x =  self.takePhotoBtn.center.x - 5 - 160/4 - CGFloat(index*70)
        }
       
       // self.type = index
            if firstType == -1{
                self.type = index
                if index == 1{
                    self.ImgBtn.isHidden = true
                }else{
                    self.ImgBtn.isHidden = false
                }
            }else{
                if firstType == index{
                    print("==")
                }else{
                    print("!=")
                   //提示数据会置空
                    //设置提示提醒用户打开定位服务
                    let alert = UIAlertController.init(title: "注意", message: "切换操作模式,将会置空之前的图片", preferredStyle: .alert)
                    let ok = UIAlertAction.init(title: "确定", style: .default) { (al) in
                        self.type = index
                        self.firstType = -1
                        self.PhotosArray.removeAll()
                        self.myRevertPhotosArray.removeAll()
                        if index == 1{
                            self.ImgBtn.isHidden = true
                        }else{
                            self.ImgBtn.isHidden = false
                        }
                        }
                    let cancel = UIAlertAction.init(title: "取消", style: .cancel) { (ca) in
                        self.cateBut.selectItem(at: self.firstType)
                    }
                    alert.addAction(ok)
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    
                }
            }
    }
}
extension QRCameraViewController:TZImagePickerControllerDelegate{
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        //        if PhotosArray.count > 9 {
        //            PhotosArray.removeSubrange(PhotosArray.indices.suffix(from: 9))
        //        }
        
        if isEdit == true{
             self.dismiss(animated: false, completion: nil)
            clickClosure!(photos.first)
           
        }else{
            PhotosArray.insert(contentsOf: photos, at: 0)
           // myRevertPhotosArray.insert(UIImage(named: "annn")!, at: 0)
            //压缩图片,并且识别
            loadRecognizePic()
        }
        
       
    }
}
extension QRCameraViewController:UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let poi = gestureRecognizer.location(in: view)
        let rec = self.myBackView?.convert((myBackView?.bounds)!, to: view)
        if (rec?.contains(poi))!{
            return false
        }else{
            return true
        }
    }
}

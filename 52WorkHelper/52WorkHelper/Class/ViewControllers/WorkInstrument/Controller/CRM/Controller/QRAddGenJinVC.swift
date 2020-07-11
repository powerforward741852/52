//
//  QRAddGenJinVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/12.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

enum ToSubmiteType {
    case fromXiXun
    case fromXiSheng
    case fromMessage
    case fromSchedule
    case fromSupply
    case fromDefault
    
}

class QRAddGenJinVC: SuperVC {
    //同事圈相关
    var titleStr = ""
    var fromType = ToSubmiteType.fromDefault
    
    //x留言id
    var schedulePlanId = ""
    
    //声明闭包
    typealias clickBtnClosure = (_ shangxian: String?) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    
  //  var edite = "add"
    var model : QRHeadEvaluateModel?
    
    var photoArray = [UIImage]()
    var baiFangFangShi = ""
    var wangChengQingKuang = ""
    //地址
    var address = ""
    //商机id
    var businessId = ""
    //客户id
    var customerId = ""
    //主要活动评价
    var evaluate = ""
    //完成情况
    var finishStatus = ""
    //方法
    var followMethod = ""
    //跟进记录id
    var followRecordId = ""
    //类型商机还是客户
    var type = ""
    //用户id
    var userid = ""
    //图片地址
    var imgFiles = ""
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        table.backgroundColor = kProjectBgColor
        
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 235+128)))
        headView.backgroundColor = UIColor.white
        return headView
    }()
    
    //第1组底部灰线
    lazy var customerInfoLab: UIView = {
        let customerInfoLab = UIView()
        customerInfoLab.frame = CGRect.init(x: 0, y:0, width: kWidth, height: AutoGetHeight(height: 18))
        customerInfoLab.backgroundColor = kProjectBgColor
        return customerInfoLab
    }()
    //第二组容器
    lazy var baseInformationV: UIView = {
        let baseInformationV = UIView.init(frame: CGRect.init(x: 0, y:self.collectionView.bottom+AutoGetHeight(height: 18) , width: kWidth, height: AutoGetHeight(height: 110)+18))
        baseInformationV.addSubview(customerInfoLab)
        
        baseInformationV.backgroundColor = UIColor.white
        return baseInformationV
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
        
        textView.placeHolder = "输入主要活动评价"
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
    
    lazy var baiFang: UILabel = {
        let name = UILabel.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 18), width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        name.text = "拜访方式"
        name.textColor = UIColor.black
        name.textAlignment = .left
        name.font = kFontSize15
        self.baseInformationV.addSubview(name)
        
        let customerFromSelect = UILabel.init(frame: CGRect.init(x: name.right + kLeftDis, y: AutoGetHeight(height: 18), width: kWidth - AutoGetWidth(width: 110) - 4 * kLeftDis - AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 55)))
        customerFromSelect.text = ""
        customerFromSelect.textColor = UIColor.lightGray
        customerFromSelect.textAlignment = .right
        customerFromSelect.font = kFontSize15
        
        let selectImg = UIImageView.init(frame: CGRect.init(x: customerFromSelect.right + kLeftDis, y:AutoGetHeight(height: 18) + AutoGetHeight(height: 55 - 12)/2, width: AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 12)))
        selectImg.image = UIImage.init(named: "PersonAddressArrow")
        selectImg.isUserInteractionEnabled = true
        self.baseInformationV.addSubview(selectImg)
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: name.right , y: AutoGetHeight(height: 18), width: kWidth - AutoGetWidth(width: 125), height: AutoGetHeight(height: 55))
        btn.addTarget(self, action: #selector(baifang), for: .touchUpInside)
        self.baseInformationV.addSubview(btn)
        return customerFromSelect
    }()
    
    lazy var locationLab : UILabel = {
        let name = UILabel.init(frame: CGRect.init(x: kLeftDis, y: baiFang.tz_bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        name.text = "地理位置"
        name.textColor = UIColor.black
        name.textAlignment = .left
        name.font = kFontSize15
        return name
    }()
    
    
    lazy var location: CBTextView = {
        let customerNamextView = CBTextView.init(frame:CGRect.init(x: locationLab.right + kLeftDis, y: baiFang.tz_bottom + AutoGetHeight(height: 13), width: (kWidth - AutoGetWidth(width: 110) - 3 * kLeftDis), height: AutoGetHeight(height: 42)))
        customerNamextView.aDelegate = self
        customerNamextView.textView.backgroundColor = UIColor.white
        customerNamextView.textView.font = UIFont.systemFont(ofSize: 15)
        customerNamextView.textView.textColor = UIColor.black
        customerNamextView.textView.textAlignment = .right
        customerNamextView.placeHolder = "输入位置"
        customerNamextView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        customerNamextView.textView.tag = 5
        return customerNamextView
    }()
    
    lazy var wanChengLab : UILabel = {
        let name = UILabel.init(frame: CGRect.init(x: kLeftDis, y: self.baiFang.bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55)))
        name.text = "完成类别"
        name.textColor = UIColor.black
        name.textAlignment = .left
        name.font = kFontSize15
        return name
    }()
    
    lazy var wanChengimg : UIImageView = {
        let selectImg = UIImageView.init(frame: CGRect.init(x:kWidth - AutoGetWidth(width: 23), y:self.baiFang.bottom + AutoGetHeight(height: 55 - 12)/2, width: AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 12)))
        selectImg.image = UIImage.init(named: "PersonAddressArrow")
        selectImg.isUserInteractionEnabled = true
       
        return selectImg
    }()
    lazy var wanChengbut : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: wanChengLab.right , y: self.baiFang.bottom, width: kWidth - AutoGetWidth(width: 125), height: AutoGetHeight(height: 55))
        btn.addTarget(self, action: #selector(wancheng), for: .touchUpInside)
        return btn
    }()
//
    
    
    lazy var wanCheng: UILabel = {
        
        self.baseInformationV.addSubview(wanChengLab)
        
        let customerFromSelect = UILabel.init(frame: CGRect.init(x: wanChengLab.right + kLeftDis, y: self.baiFang.bottom, width: kWidth - AutoGetWidth(width: 110) - 4 * kLeftDis - AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 55)))
        customerFromSelect.text = ""
        customerFromSelect.textColor = UIColor.lightGray
        customerFromSelect.textAlignment = .right
        customerFromSelect.font = kFontSize15
        
        self.baseInformationV.addSubview(wanChengimg)
        self.baseInformationV.addSubview(wanChengbut)
        return customerFromSelect
    }()
    
    var selectView : QRXinshengSelectView?
    var clafyView : UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.txtView)
        self.txtView.addSubview(self.textView)
        self.headView.addSubview(self.collectionView)
        
    
        
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        rightBtn.setTitleColor(kLightBlueColor, for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
      
        
        if self.fromType == ToSubmiteType.fromXiSheng {
            textView.placeHolder = "分享内容..."
            rightBtn.setTitle("发布", for: .normal)
            rightBtn.sizeToFit()
            rightBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: -7)
            rightBtn.addTarget(self, action: #selector(uploadXinShengClick), for: .touchUpInside)
            let rightItem = UIBarButtonItem.init(customView: rightBtn)
            self.navigationItem.rightBarButtonItem = rightItem
           //添加选择按钮
            let selectView = Bundle.main.loadNibNamed("QRXinshengSelectView", owner: nil, options: nil)?.last as! QRXinshengSelectView
            selectView.firstLab.text = "匿名:"+OCTool.randomData()
            selectView.frame =  CGRect(x: 0, y: collectionView.bottom, width: kWidth, height: 50)
            self.selectView = selectView
            self.headView.addSubview(selectView)
            //公约
            let clafyView = Bundle.main.loadNibNamed("QRXinshengSelectView", owner: nil, options: nil)?.first as! UIView
            clafyView.backgroundColor = kProjectBgColor
            clafyView.frame =  CGRect(x: 0, y: selectView.bottom, width: kWidth, height: 170)
            self.clafyView = clafyView
            self.headView.addSubview(clafyView)
            textView.isSupportEmoji = true
            self.headView.frame =  CGRect(x: 0, y: 0, width: kWidth, height: self.clafyView!.bottom)
        }else if self.fromType == ToSubmiteType.fromXiXun {
            textView.placeHolder = "分享内容..."
            rightBtn.setTitle("发布", for: .normal)
            rightBtn.sizeToFit()
            rightBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: -7)
            rightBtn.addTarget(self, action: #selector(uploadXiXunClick), for: .touchUpInside)
            let rightItem = UIBarButtonItem.init(customView: rightBtn)
            self.navigationItem.rightBarButtonItem = rightItem
            textView.isSupportEmoji = true
            self.headView.frame =  CGRect(x: 0, y: 0, width: kWidth, height: self.collectionView.bottom + 20)
        }else if self.fromType == ToSubmiteType.fromMessage {
            textView.placeHolder = "请输入内容,比如工作提醒..."
            rightBtn.setTitle("完成", for: .normal)
            rightBtn.sizeToFit()
            rightBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: -7)
            rightBtn.addTarget(self, action: #selector(uploadMessageClick), for: .touchUpInside)
            let rightItem = UIBarButtonItem.init(customView: rightBtn)
            self.navigationItem.rightBarButtonItem = rightItem
            
            self.headView.frame =  CGRect(x: 0, y: 0, width: kWidth, height: self.collectionView.bottom + 20)
        }else{
            rightBtn.setTitle("完成", for: .normal)
            rightBtn.sizeToFit()
            rightBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: -7)
            rightBtn.addTarget(self, action: #selector(uploadClick), for: .touchUpInside)
            let rightItem = UIBarButtonItem.init(customView: rightBtn)
            self.navigationItem.rightBarButtonItem = rightItem
            self.headView.addSubview(self.baseInformationV)
            self.baseInformationV.addSubview(baiFang)
            self.baseInformationV.addSubview(wanCheng)
        }
        
       
        
        if self.followRecordId == "" {
            title = "新建跟进记录"
            if self.businessId == ""{
                self.type = "1"
            }else{
                self.type = "2"
            }
            
        }else{
            title = "编辑跟进记录"
            //属性赋值
            self.baiFang.text = model?.followMethod
            self.baiFangFangShi = (model?.followMethod)!
            self.wangChengQingKuang = (model?.finishStatus)!
            if let finish = model?.finishStatus,finish == "0"{
                self.wanCheng.text = "未完成"
            }else{
                self.wanCheng.text = "完成"
            }
            //判断地址
            if  (model?.followMethod)! == "外勤拜访"{
                self.changeAddress()
                self.location.prevText = (model?.address)!
                self.address = (model?.address)!
            }
            
            self.followMethod = (model?.followMethod)!
            self.finishStatus = (model?.finishStatus)!
            self.textView.placeHolder = ""
            if let tx = model?.evaluate{
                self.textView.prevText = tx
            }
            if self.businessId == ""{
                self.type = "1"
            }else{
                self.type = "2"
            }
            
        }
        
        
        if fromType == ToSubmiteType.fromDefault{
        }else{
            title = titleStr
        }
        
        
        
    }
}

extension QRAddGenJinVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoArray.count + 1
    }
    
}

extension QRAddGenJinVC: UICollectionViewDelegate {
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

//MARK-dia点击事件
extension QRAddGenJinVC{
    //上传留言
    @objc func uploadMessageClick(){
        var comment = self.textView.textView.text
        if comment == self.textView.placeHolder{
            comment = ""
        }
        if (comment?.count)! > 0 {
            //发布
            self.loadingPlay()
            self.postMessageData(comment: comment!)
            return
        }else if (comment?.count)! < 1{
            SVProgressHUD.showInfo(withStatus: "输入内容不能为空")
            return
        }
    }
    
    func postMessageData(comment:String)  {

        let userID = STUserTool.account().userID
        let urlUpload = "\(baseUrl)/schedule/saveScheduleComment"
        let headers = ["t_userId":userID,
                       "token":STUserTool.account().token]
       
        Alamofire.upload(multipartFormData: { formData in
            let param = ["userId":userID,
                         "commentContent":comment,"schedulePlanId":self.schedulePlanId]
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
                        SVProgressHUD.showInfo(withStatus: json["message"].stringValue)
                        self.navigationController?.popViewController(animated: true)
                        NotificationCenter.default.post(name: NSNotification.Name.init("reflashFriendCircle"), object: nil)
                    } else {
                        SVProgressHUD.showError(withStatus: json["message"].stringValue)
                    }
                    
                    
//                    SVProgressHUD.showSuccess(withStatus: "发布成功")
                   
                }
            case .failure( _):
                self.loadingSuccess()
                SVProgressHUD.showError(withStatus: "上传失败,请稍后重试")
            }
        })
    }
    
    
    //发布心声
    @objc func uploadXinShengClick()  {
        var comment = self.textView.textView.text
        if comment == self.textView.placeHolder{
            comment = ""
        }
        if (comment?.count)! > 0 {
            //发布
            self.loadingPlay()
            self.postXinShengData(comment: comment!)
            return
        }else if (comment?.count)! < 1{
            SVProgressHUD.showInfo(withStatus: "输入内容不能为空")
            return
        }
    }

    func postXinShengData(comment:String)  {
        var emoji = comment
        emoji = (comment + " ").toBase64()! + "\n"
        let userID = STUserTool.account().userID
        let urlUpload = "\(baseUrl)/aspirations/saveAspirations"
        let headers = ["t_userId":userID,
                       "token":STUserTool.account().token]
        var anonymousName = ""
        if selectView?.selectIndex == 11{
            var name = (selectView?.firstLab.text)!
            if name.hasPrefix("匿名"){
                name.removeFirst()
                name.removeFirst()
                name.removeFirst()
            }
            anonymousName = name//(selectView?.firstLab.text)!
        }else{
            anonymousName = ""
        }
 
        Alamofire.upload(multipartFormData: { formData in
            let param = ["userId":userID,
                         "content":emoji,"anonymous":anonymousName]
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
                        SVProgressHUD.showInfo(withStatus: json["message"].stringValue)
                        self.navigationController?.popViewController(animated: true)
                        NotificationCenter.default.post(name: NSNotification.Name.init("reflashFriendCircle"), object: nil)
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
    
    
    @objc func uploadXiXunClick()  {
        var comment = self.textView.textView.text
        if comment == self.textView.placeHolder{
            comment = ""
        }
        if (comment?.count)! > 0 {
            //发布
            self.loadingPlay()
            self.postXiXunData(comment: comment!)
            return
        }else if (comment?.count)! < 1{
            SVProgressHUD.showInfo(withStatus: "输入内容不能为空")
            return
        }
    }
    
    func postXiXunData(comment:String)  {
        var emoji = comment
        emoji = (comment + " ").toBase64()! + "\n"
        let userID = STUserTool.account().userID
        let urlUpload = "\(baseUrl)/goodNews/saveGoodNews"
        let headers = ["t_userId":userID,
                       "token":STUserTool.account().token]
        Alamofire.upload(multipartFormData: { formData in
            let param = ["userId":userID,
                         "content":emoji]
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
                        SVProgressHUD.showInfo(withStatus: json["message"].stringValue)
                        self.navigationController?.popViewController(animated: true)
                        NotificationCenter.default.post(name: NSNotification.Name.init("reflashFriendCircle"), object: nil)
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
    
    
    
    @objc func uploadClick()  {
        var comment = self.textView.textView.text
        if comment == self.textView.placeHolder{
            comment = ""
        }
        
        if wangChengQingKuang == "" {
            SVProgressHUD.showInfo(withStatus: "请选择完成情况")
            return
        }
        if baiFangFangShi == ""{
            SVProgressHUD.showInfo(withStatus: "请选择拜访方式")
            return
        }

        if baiFangFangShi == "外勤拜访" &&  address == ""{
            SVProgressHUD.showInfo(withStatus: "请选择外勤地址")
            return
        }
        
        if (comment?.count)! > 0 {
           //发布
            self.loadingPlay()
            self.postData(comment: comment!)
            return
        }else if (comment?.count)! < 1{
            SVProgressHUD.showInfo(withStatus: "输入内容不能为空")
            return
        }

        
    }
    func changeAddress()  {
        //如果是外勤写入地址,加入一个控件
        
        self.location.prevText = address
        self.baseInformationV.addSubview(self.locationLab)
        self.baseInformationV.addSubview(self.location)
        self.wanChengLab.frame = CGRect.init(x: kLeftDis, y: self.location.bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55))
        self.wanCheng.frame = CGRect.init(x: self.wanChengLab.right + kLeftDis, y: self.location.bottom, width: kWidth - AutoGetWidth(width: 110) - 4 * kLeftDis - AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 55))
        self.wanChengimg.frame = CGRect.init(x:kWidth - AutoGetWidth(width: 23), y:self.location.bottom + AutoGetHeight(height: 55 - 12)/2, width: AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 12))
        self.wanChengbut.frame =  CGRect.init(x: self.wanChengLab.right , y: self.location.bottom, width: kWidth - AutoGetWidth(width: 125), height: AutoGetHeight(height: 55))
        self.baseInformationV.frame = CGRect.init(x: 0, y:self.collectionView.bottom+AutoGetHeight(height: 18) , width: kWidth, height: AutoGetHeight(height: 165)+18)
        self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 126) + (kHaveLeftWidth-AutoGetWidth(width: 30))/4 * CGFloat((self.photoArray.count/4)+1) + 20 * CGFloat((self.photoArray.count/4)+1)+AutoGetHeight(height: 165)+18)
    }
    @objc func baifang(){
        //弹出AlterView,并且选择并且赋值
        
        let items = ["电话沟通", "外勤拜访"]
        let vProperty = FWSheetViewProperty()
        vProperty.touchWildToHide = "1"
        let sheetView = FWSheetView.sheet(title:"", itemTitles: items, itemBlock: { [unowned self] (popupView, index, title) in
            if index == 0{
                self.baiFang.text = "电话沟通"
                self.baiFangFangShi = "电话沟通"
                self.followMethod = "电话沟通"
                self.address = ""
                self.location.removeFromSuperview()
                self.locationLab.removeFromSuperview()
                self.wanChengLab.frame = CGRect.init(x: kLeftDis, y: self.baiFang.bottom, width: AutoGetWidth(width: 110), height: AutoGetHeight(height: 55))
                self.wanCheng.frame = CGRect.init(x: self.wanChengLab.right + kLeftDis, y: self.baiFang.bottom, width: kWidth - AutoGetWidth(width: 110) - 4 * kLeftDis - AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 55))
                self.wanChengimg.frame = CGRect.init(x:kWidth - AutoGetWidth(width: 23), y:self.baiFang.bottom + AutoGetHeight(height: 55 - 12)/2, width: AutoGetWidth(width: 6.5), height: AutoGetHeight(height: 12))
                self.wanChengbut.frame =  CGRect.init(x: self.wanChengLab.right , y: self.baiFang.bottom, width: kWidth - AutoGetWidth(width: 125), height: AutoGetHeight(height: 55))
                self.baseInformationV.frame = CGRect.init(x: 0, y:self.collectionView.bottom+AutoGetHeight(height: 18) , width: kWidth, height: AutoGetHeight(height: 110)+18)
                self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 126) + (kHaveLeftWidth-AutoGetWidth(width: 30))/4 * CGFloat((self.photoArray.count/4)+1) + 20 * CGFloat((self.photoArray.count/4)+1)+AutoGetHeight(height: 110)+18)
            }else{
                self.baiFang.text = "外勤拜访"
                self.baiFangFangShi = "外勤拜访"
                self.followMethod = "外勤拜访"
                self.changeAddress()
            }
            
        }, cancenlBlock: {
            print("点击了取消")
        }, property: vProperty)
        sheetView.show()
    }
    @objc func wancheng(){
        //完成
        let items = ["未完成", "完成"]
        let vProperty = FWSheetViewProperty()
        vProperty.touchWildToHide = "1"
        let sheetView = FWSheetView.sheet(title:"", itemTitles: items, itemBlock: {[unowned self]  (popupView, index, title) in
            print("Sheet：点击了第\(index)个按钮")
           
            if index == 0{
                self.finishStatus = "0"
                self.wangChengQingKuang = "未完成"
                self.wanCheng.text = "未完成"
            }else{
                self.finishStatus = "1"
                self.wanCheng.text = "完成"
                self.wangChengQingKuang = "完成"
            }
            
        }, cancenlBlock: {
            print("点击了取消")
        }, property: vProperty)
        sheetView.show()
    }
    
    
   
    
    func postData(comment:String)  {
        let userID = STUserTool.account().userID
        let urlUpload = "\(baseUrl)/crmCustomer/saveOrUpdateCrmFollowRecord"
        let headers = ["t_userId":userID,
                       "token":STUserTool.account().token]
        Alamofire.upload(multipartFormData: { formData in
            let param = ["userId":userID,
                         "evaluate":comment,"businessId":self.businessId,"finishStatus":self.finishStatus,"followMethod":self.followMethod,"type":self.type,"customerId":self.customerId,"followRecordId":self.followRecordId,"address":self.address]
            
            print(param)
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
                        SVProgressHUD.showInfo(withStatus: json["message"].stringValue)
                        self.clickClosure?("flash")
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
    
    
    
    func initImgPick()  {
        let imagePickerVc = TZImagePickerController(maxImagesCount: 9, delegate: self)
        imagePickerVc?.allowTakePicture = false
        self.present(imagePickerVc!, animated: true, completion: nil)
    }
}



extension QRAddGenJinVC:UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        
    }
}
extension QRAddGenJinVC:UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return  1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return ["电话沟通","外勤拜访"][row]
        }else{
            return ["未完成","完成"][row]
        }
       
    }
    
}

extension QRAddGenJinVC:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
       if textView.tag == 5{
            self.address = textView.text
        }
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        if self.textView.textView.text.isEmpty {
            
        }
        if textView.tag == 5{
            self.address = textView.text
        }
    }
}
//MARK:图片选择器的代理
extension QRAddGenJinVC: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        photoArray.insert(contentsOf: photos, at: 0)
        if photoArray.count > 9 {
            photoArray.removeSubrange(photoArray.indices.suffix(from: 9))
        }
        print(photoArray.count)
        
        if fromType == ToSubmiteType.fromXiSheng {
              self.collectionView.frame = CGRect.init(x: kLeftDis, y: self.txtView.bottom+AutoGetHeight(height: 18), width: kHaveLeftWidth, height: (kHaveLeftWidth-AutoGetWidth(width: 30))/4 * CGFloat((self.photoArray.count/4)+1) + 10 * CGFloat((self.photoArray.count/4)+1))
            selectView!.frame =  CGRect(x: 0, y: collectionView.bottom, width: kWidth, height: 50)
            clafyView!.frame =  CGRect(x: 0, y: selectView!.bottom, width: kWidth, height: 170)
          
            self.headView.frame =  CGRect(x: 0, y: 0, width: kWidth, height: self.clafyView!.bottom)
            
        }else if self.fromType == ToSubmiteType.fromXiXun{
            self.collectionView.frame = CGRect.init(x: kLeftDis, y: self.txtView.bottom+AutoGetHeight(height: 18), width: kHaveLeftWidth, height: (kHaveLeftWidth-AutoGetWidth(width: 30))/4 * CGFloat((self.photoArray.count/4)+1) + 10 * CGFloat((self.photoArray.count/4)+1))
            self.headView.frame =  CGRect(x: 0, y: 0, width: kWidth, height: self.collectionView.bottom+20)
        }else if self.fromType == ToSubmiteType.fromMessage{
            self.collectionView.frame = CGRect.init(x: kLeftDis, y: self.txtView.bottom+AutoGetHeight(height: 18), width: kHaveLeftWidth, height: (kHaveLeftWidth-AutoGetWidth(width: 30))/4 * CGFloat((self.photoArray.count/4)+1) + 10 * CGFloat((self.photoArray.count/4)+1))
            self.headView.frame =  CGRect(x: 0, y: 0, width: kWidth, height: self.collectionView.bottom+20)
        }else{
            //z重新设置frame
            self.collectionView.frame = CGRect.init(x: kLeftDis, y: self.txtView.bottom+AutoGetHeight(height: 18), width: kHaveLeftWidth, height: (kHaveLeftWidth-AutoGetWidth(width: 30))/4 * CGFloat((self.photoArray.count/4)+1) + 10 * CGFloat((self.photoArray.count/4)+1))
            self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 126) + (kHaveLeftWidth-AutoGetWidth(width: 30))/4 * CGFloat((self.photoArray.count/4)+1) + 20 * CGFloat((self.photoArray.count/4)+1)+AutoGetHeight(height: 128))
            self.baseInformationV.frame =  CGRect(x: 0, y: self.collectionView.bottom, width: kWidth, height: AutoGetHeight(height: 128))
          
        }
         collectionView.reloadData()
    }
}
//删除按钮代理
extension QRAddGenJinVC:CQPublishDeleteDelegate{
    func deletePublishPic(index: IndexPath) {
        self.photoArray.remove(at: index.item)
        //z重新设置frame
        if fromType == ToSubmiteType.fromXiSheng{
            self.collectionView.frame = CGRect.init(x: kLeftDis, y: self.txtView.bottom+AutoGetHeight(height: 18), width: kHaveLeftWidth, height: (kHaveLeftWidth-AutoGetWidth(width: 30))/4 * CGFloat((self.photoArray.count/4)+1) + 10 * CGFloat((self.photoArray.count/4)+1))
            selectView!.frame =  CGRect(x: 0, y: collectionView.bottom, width: kWidth, height: 50)
            clafyView!.frame =  CGRect(x: 0, y: selectView!.bottom, width: kWidth, height: 170)
            
            self.headView.frame =  CGRect(x: 0, y: 0, width: kWidth, height: self.clafyView!.bottom)
        } else if self.fromType == ToSubmiteType.fromXiXun{
            self.collectionView.frame = CGRect.init(x: kLeftDis, y: self.txtView.bottom+AutoGetHeight(height: 18), width: kHaveLeftWidth, height: (kHaveLeftWidth-AutoGetWidth(width: 30))/4 * CGFloat((self.photoArray.count/4)+1) + 10 * CGFloat((self.photoArray.count/4)+1))
            self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: self.collectionView.bottom+20)
        }else if self.fromType == ToSubmiteType.fromMessage{
            self.collectionView.frame = CGRect.init(x: kLeftDis, y: self.txtView.bottom+AutoGetHeight(height: 18), width: kHaveLeftWidth, height: (kHaveLeftWidth-AutoGetWidth(width: 30))/4 * CGFloat((self.photoArray.count/4)+1) + 10 * CGFloat((self.photoArray.count/4)+1))
            self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: self.collectionView.bottom+20)
        }else{
            self.collectionView.frame = CGRect.init(x: kLeftDis, y: self.txtView.bottom+AutoGetHeight(height: 18), width: kHaveLeftWidth, height: (kHaveLeftWidth-AutoGetWidth(width: 30))/4 * CGFloat((self.photoArray.count/4)+1) + 10 * CGFloat((self.photoArray.count/4)+1))
            self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 126) + (kHaveLeftWidth-AutoGetWidth(width: 30))/4 * CGFloat((self.photoArray.count/4)+1) + 20 * CGFloat((self.photoArray.count/4)+1)+AutoGetHeight(height: 128))
            self.baseInformationV.frame =  CGRect(x: 0, y: self.collectionView.bottom, width: kWidth, height: AutoGetHeight(height: 128))
        }
        self.collectionView.reloadData()
    }
    
    
}

extension QRAddGenJinVC :UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.textView.resignFirstResponder()
    }
    
}

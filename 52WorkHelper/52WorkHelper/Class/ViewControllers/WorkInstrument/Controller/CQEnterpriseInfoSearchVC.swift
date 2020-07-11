//
//  CQEnterpriseInfoSearchVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/7/6.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQEnterpriseInfoSearchVC: SuperVC {

    var dataArray = [CQEnterpriseInfoModel]()
    var typeId = ""
    var pageNum = 1
    var selectArr = [Bool]()
    var titleStr = ""
    var shareUrl = ""
    var selectModelArray = [CQEnterpriseInfoModel]()
    var searchName = ""
    
    lazy var searchView: UIView = {
        let searchView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: CGFloat(SafeAreaTopHeight)))
        searchView.backgroundColor = UIColor.white
        let lineView = UIView.init(frame: CGRect.init(x: 0, y: 63.5, width: kWidth, height: 0.5))
        lineView.backgroundColor = UIColor.init(red: 0.9529, green: 0.9529, blue: 0.9529, alpha: 1)
        searchView.addSubview(lineView)
        searchView.layer.borderColor = kLineColor.cgColor
        searchView.layer.borderWidth = 0.5
        return searchView
    }()
    
    lazy var searchBar: CQSearchBar = {
        let searchBar = CQSearchBar.init(frame: CGRect.init(x: AutoGetWidth(width: 15), y: 7 + CGFloat(SafeAreaStateTopHeight), width: kWidth - AutoGetWidth(width: 75), height: 30))
        searchBar.delegate = self
        //        searchBar.placeholder = "搜索"
       // searchBar.placeholder = "        搜索"
        return searchBar
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton.init(type: .custom)
        cancelBtn.frame = CGRect.init(x: kWidth - AutoGetWidth(width: 60), y: 7 + CGFloat(SafeAreaStateTopHeight), width: AutoGetWidth(width: 55), height: 30)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor.gray, for: .normal)
        cancelBtn.addTarget(self, action: #selector(backToSuperView), for: .touchUpInside)
        cancelBtn.titleLabel?.textAlignment = .right
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return cancelBtn
    }()
    
    
    
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: CGFloat(SafeAreaTopHeight), width: kWidth, height: kHeight - CGFloat(SafeAreaTopHeight)), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    
    lazy var withOutResultView: UIView = {
        let withOutResultView = UIView.init(frame: CGRect.init(x: 0, y: CGFloat(SafeAreaTopHeight), width: kWidth, height: AutoGetHeight(height: kHeight - CGFloat(SafeAreaTopHeight))))
        withOutResultView.backgroundColor = UIColor.init(red: 0.9529, green: 0.9529, blue: 0.9529, alpha: 1)
        let imageV = UIImageView.init(frame: CGRect.init(x: (kWidth - imageWidth)/2.0, y: AutoGetHeight(height: 51), width: imageWidth, height: imageWidth))
        imageV.image = UIImage.init(named: "searchNoResult")
        let lab = UILabel.init(frame: CGRect.init(x: 0, y: imageV.bottom + AutoGetHeight(height: 25), width: kWidth, height: AutoGetHeight(height: 20)))
        lab.textAlignment = .center
        lab.textColor = UIColor.black
        lab.text = "要不...换个关键词试试"
        lab.font = UIFont.boldSystemFont(ofSize: 18)
        withOutResultView.addSubview(imageV)
        withOutResultView.addSubview(lab)
        return withOutResultView
    }()
    
    lazy var footView: UIView = {
        let footView = UIView.init(frame: CGRect.init(x: 0, y: kHeight - AutoGetHeight(height: 49) - SafeAreaBottomHeight, width: kWidth, height: AutoGetHeight(height: 49)+SafeAreaBottomHeight))
        footView.backgroundColor = UIColor.white
        footView.layer.borderWidth = 0.5
        footView.layer.borderColor = kLyGrayColor.cgColor
        return footView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = kProjectBgColor
        
        self.searchView.addSubview(self.searchBar)
        self.searchView.addSubview(self.cancelBtn)
        self.view.addSubview(self.table)
        self.table.register(CQEnterpriseInfoCell.self, forCellReuseIdentifier: "CQEnterpriseInfoCellId")
        
        self.table.isHidden = true
        
        self.view.addSubview(self.withOutResultView)
        self.withOutResultView.isHidden = true
        
        self.setUpRefresh()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEditChanged(obj:)), name: Notification.Name.UITextViewTextDidChange, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchView.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.view.addSubview(self.searchView)
    }
    

    func initFootView(titleArr:[String],imageArr:[String])  {
        for i in 0..<titleArr.count {
            let btn = UIButton.init(type: .custom)
            btn.frame = CGRect.init(x: kWidth/CGFloat(titleArr.count) * CGFloat(i), y: 0, width: kWidth/CGFloat(titleArr.count), height: AutoGetHeight(height: 49))
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
}

extension CQEnterpriseInfoSearchVC:CQShareDelegate{
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

extension CQEnterpriseInfoSearchVC{
    func setUpRefresh()  {
        // MARK:header
        let STHeader = CQRefreshHeader {[unowned self] in
            self.getCompanyDataList(moreData: false)
        }
        
        self.table.mj_header = STHeader
       // self.table.mj_header.beginRefreshing()
    }
    
    func getCompanyDataList(moreData: Bool) {
        SVProgressHUD.show()
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
                    "searchName":self.searchName],
            successCallBack: { (result) in
                SVProgressHUD.dismiss()
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
                self.table.reloadData()
                
                //分页控制
                if  self.dataArray.count == 0{
                    self.table.isHidden = true
                    self.withOutResultView.isHidden = false
                }else
                {
                    self.table.isHidden = false
                    self.withOutResultView.isHidden = true
                }
                
                
                for _ in self.dataArray {
                    self.selectArr.append(false)
                }
                
        }) { (error) in
             SVProgressHUD.dismiss()
            self.table.reloadData()
            self.table.mj_header.endRefreshing()
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
                self.getCompanyDataList(moreData: false)
        }) { (error) in
            
        }
    }
}

extension CQEnterpriseInfoSearchVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQEnterpriseInfoCellId") as! CQEnterpriseInfoCell
        cell.model = self.dataArray[indexPath.row]
        cell.selectDelegate = self
        cell.selectStatus = self.selectArr[indexPath.row]
        cell.layoutSubviews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataArray[indexPath.row]
        let vc = CQWebVC()
        let url = "\(baseUrl)/information/downFile" + "?entityId=" + model.attachmentId + "&version=v1"
        vc.urlStr = url
        vc.titleStr = model.name
        if model.attachmentName.hasSuffix(".pdf"){
               vc.isPDF = true
           }else{
               vc.isPDF = false
           }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoGetHeight(height: 63)
    }
    
    
}

extension CQEnterpriseInfoSearchVC:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.searchBar.placeholder = ""
        self.cancelBtn.setTitle("取消", for: .normal)
        let search = textField as! CQSearchBar
        search.searchbut?.isHidden = true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
     //   searchBar.placeholder = " 搜索"
        self.withOutResultView.isHidden = true
        self.table.isHidden = true
        self.cancelBtn.setTitle("取消", for: .normal)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !(textField.text?.isEmpty)! {
            self.searchName = textField.text!
//            let search = textField as! CQSearchBar
//            search.searchbut?.isHidden = false
             self.table.mj_header.beginRefreshing()
           // self.setUpRefresh()
            //self.getCompanyDataList(moreData: false)
        }
        
        
       // textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    @objc func textFieldEditChanged(obj:Notification)  {
        
    }
    
}

extension CQEnterpriseInfoSearchVC:CQEnterpreiseBaseDelegate{
    func selectIndex(index: IndexPath) {
        let num = index.row
        let sec = index.row + 1
        let selectStaues = selectArr[index.row]
        self.selectArr.replaceSubrange(Range(num ..< sec), with: [!selectStaues])
        self.table.reloadData()
        
        self.view.addSubview(self.footView)
        self.initFootView(titleArr: [/*"下载",*/"分享","删除"], imageArr: [/*"EnterpriseDocBarDownload",*/"EnterpriseDocBarShare","EnterpriseDocBarDelete"])
        
        //        let iconImg = btn.viewWithTag(btn.tag - 100 + 200) as! UIImageView
        //        iconImg.image = UIImage.init(named: "gabigeGray")
        //        btn.isUserInteractionEnabled = false
    }
}


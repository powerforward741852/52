//
//  CQEnterpriseDocVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/2.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQEnterpriseDocVC: SuperVC {

    var isFromeMTBD = false
    
    var pageNum = 1
    var typeId = ""
    var dataArray = [CQEnterpriseInfoModel]()
    var titleStr = ""
    var selectArr = [Bool]()
    var shareUrl = ""
    var selectModelArray = [CQEnterpriseInfoModel]()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - AutoGetHeight(height: 49) - SafeAreaBottomHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.delegate = self
        table.backgroundColor = UIColor.white
        table.dataSource = self
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    
    lazy var searchView: UIView = {
        let searchView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 45)))
        searchView.layer.borderColor = kLineColor.cgColor
        searchView.layer.borderWidth = 0.5
        searchView.backgroundColor = UIColor.white
        return searchView
    }()
    
   
    lazy var searchBtn: UIButton = {
        let searchBtn = UIButton.init(type: .custom)
        searchBtn.frame = CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 5), width: kHaveLeftWidth, height: AutoGetHeight(height: 35))
        searchBtn.setImage(UIImage.init(named: "knowledgeSearch"), for: .normal)
        searchBtn.setTitle(" 搜索", for: .normal)
        searchBtn.setTitleColor(kLyGrayColor, for: .normal)
        //        searchBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -AutoGetWidth(width: 300), bottom: 0, right: 0)
        searchBtn.layer.cornerRadius = 5
        searchBtn.backgroundColor = kProjectBgColor
        searchBtn.addTarget(self, action: #selector(searchClick), for: .touchUpInside)
        return searchBtn
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
        
        self.setUpRefresh()
        
        self.title = titleStr
        self.view.backgroundColor = UIColor.white//kProjectBgColor
        self.view.addSubview(self.table)
        self.table.register(CQEnterpriseCell.self, forCellReuseIdentifier: "CQEnterpriseCellId")
        self.table.tableHeaderView = self.searchView
        self.searchView.addSubview(self.searchBtn)
    }
    
    @objc func searchClick()  {
        let vc = CQEnterpriseInfoSearchVC()
        vc.titleStr = self.titleStr
        vc.typeId = self.typeId
        self.navigationController?.pushViewController(vc, animated: true)
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
//                        let iconImg = btn.viewWithTag(btn.tag - 100 + 200) as! UIImageView
//                        iconImg.image = UIImage.init(named: "gabigeGray")
//                        btn.isUserInteractionEnabled = false
                        SVProgressHUD.showInfo(withStatus: model.name + "不允许删除")
                        return
                    }else{
//                        let iconImg = btn.viewWithTag(btn.tag - 100 + 200) as! UIImageView
//                        iconImg.image = UIImage.init(named: "EnterpriseDocBarDelete")
//                        btn.isUserInteractionEnabled = true
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


extension CQEnterpriseDocVC{
   
    
    
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
            self.dataArray.removeAll()
            self.selectArr.removeAll()
        }
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/information/getCompanyDateList" ,
            type: .get,
            param: ["emyeId":userID,
                    "typeId":self.typeId,
                    "currentPage":pageNum,
                    "pageSize":"10",
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
                self.selectArr.removeAll()
                for _ in self.dataArray {
                    self.selectArr.append(false)
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
                self.loadDatas(moreData: false)
        }) { (error) in
            
        }
    }
}


extension CQEnterpriseDocVC:CQShareDelegate{
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
        shareParames.ssdkSetupShareParams(byText: "52工作助手",
                                          images : img,
                                          url : NSURL(string:self.shareUrl) as URL?,
                                          title : titles,
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


extension CQEnterpriseDocVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQEnterpriseCellId") as! CQEnterpriseCell
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
        return AutoGetHeight(height: 55)
    }
}

extension CQEnterpriseDocVC:CQEnterpriseSelectDelegate{
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
            self.footView.layer.borderColor = UIColor.white.cgColor
        }else{
            self.footView.layer.borderColor = kLyGrayColor.cgColor//UIColor.white.cgColor
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

extension CQEnterpriseDocVC:UITextFieldDelegate {
    
}

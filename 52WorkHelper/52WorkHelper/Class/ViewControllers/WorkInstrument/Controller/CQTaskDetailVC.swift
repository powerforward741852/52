//
//  CQTaskDetailVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/29.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQTaskDetailVC: SuperVC {

    var userArray = [CQTaskUserModel]()
    var personnelTaskId = ""
    var isFromApp = false
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.separatorColor = kLineColor
        table.separatorInset = UIEdgeInsets.init(top: 0, left: kLeftDis, bottom: 0, right: 0)
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.allowsSelection = false
        table.estimatedSectionHeaderHeight = 0;
        table.estimatedSectionFooterHeight = 0;
        table.estimatedRowHeight = 0;
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 175)))
        headView.backgroundColor = kProjectBgColor
        return headView
    }()
    
    lazy var reportBgView: UIView = {
        let reportBgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 162)))
        reportBgView.backgroundColor = UIColor.white
        return reportBgView
    }()
    
    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetWidth(width: 18), width: AutoGetWidth(width: 38), height: AutoGetWidth(width: 38)))
        iconImg.image = UIImage.init(named: "personDefaultIcon")
        iconImg.layer.cornerRadius = AutoGetWidth(width: 19)
        iconImg.clipsToBounds = true
        return iconImg
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 12), y: AutoGetWidth(width: 18), width: kWidth/3 * CGFloat(2), height: AutoGetHeight(height: 16)))
        nameLab.font = kFontSize16
        nameLab.textAlignment = .left
        nameLab.textColor = UIColor.black
        nameLab.text = "我的日报"
        return nameLab
    }()
    
    lazy var timeLab: UILabel = {
        let timeLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 12), y:self.nameLab.bottom + AutoGetWidth(width: 6), width: kWidth/3 * CGFloat(2), height: AutoGetHeight(height: 11)))
        timeLab.font = kFontSize11
        timeLab.textAlignment = .left
        timeLab.textColor = kLyGrayColor
        timeLab.text = "2月12日 15:00"
        return timeLab
    }()
    
    lazy var statusImg: UIImageView = {
        let statusImg = UIImageView.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 36), y: AutoGetHeight(height: 18), width: AutoGetWidth(width: 21), height: AutoGetWidth(width: 21)))
        statusImg.layer.cornerRadius = AutoGetWidth(width: 10.5)
        statusImg.clipsToBounds = true
        return statusImg
    }()
    
    lazy var contentLab: UILabel = {
        let contentLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.iconImg.bottom + AutoGetWidth(width: 16), width: kHaveLeftWidth, height: AutoGetHeight(height: 45)))
        contentLab.font = kFontSize15
        contentLab.textAlignment = .left
        contentLab.textColor = kLyGrayColor
        contentLab.text = "今日完成工作"
        contentLab.numberOfLines = 0
        return contentLab
    }()
    
    lazy var delineTimeLab: UILabel = {
        let delineTimeLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.contentLab.bottom + AutoGetWidth(width: 14), width: kHaveLeftWidth, height: AutoGetHeight(height: 13)))
        delineTimeLab.font = kFontSize13
        delineTimeLab.textAlignment = .left
        delineTimeLab.textColor = UIColor.black
        delineTimeLab.text = "2月12日 15:00"
        return delineTimeLab
    }()
    
    lazy var picview : QRNetImgPicView={
       let pic = QRNetImgPicView(width: kWidth/3*2)
        return pic
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDetailData()
        self.title = "任务详情"
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.reportBgView)
        self.reportBgView.addSubview(self.iconImg)
        self.reportBgView.addSubview(self.nameLab)
        self.reportBgView.addSubview(self.timeLab)
        self.reportBgView.addSubview(self.contentLab)
        self.reportBgView.addSubview(self.statusImg)
        self.reportBgView.addSubview(self.picview)
        self.reportBgView.addSubview(self.delineTimeLab)
       
        self.table.register(CQTaskDetailCell.self, forCellReuseIdentifier: "CQTaskDetailCellId")
        self.table.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CQTaskDetailHeader")
        NotificationCenter.default.addObserver(self, selector: #selector(updateImages(notification:)), name: NSNotification.Name(rawValue: "imagsCellID"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(popToTaskDetail(notification:)), name: NSNotification.Name(rawValue: "popToTaskDetail"), object: nil)
       
    }
    @objc func popToTaskDetail(notification:NSNotification){
        self.navigationController?.popToViewController(self, animated: true)
        self.loadDetailData()
    }
    @objc func updateImages(notification:NSNotification){
        
        let index = notification.userInfo?["index"] as? Int
        let imgs = notification.userInfo?["imags"] as? [String]
        if let index = index ,let imags = imgs, imags.count > 0{
            let previewVC = ImagePreViewVC(images: imags, index: index)
            self.navigationController?.pushViewController(previewVC, animated: true)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isFromApp {
            self.navigationItem.leftBarButtonItem = self.barBackButton()
        }
    }
    
    //计算高度
    func getTextHeigh(textStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        let normalText: String = textStr
        let size = CGSize.init(width: width, height: 1000)
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context:nil).size
        return stringSize.height
    }
}

extension CQTaskDetailVC{
    fileprivate func loadDetailData() {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/personnelTask/getPersonnelTaskDetails" ,
            type: .get,
            param: ["personnelTaskId":self.personnelTaskId,
                    "userId":userID],
            successCallBack: { (result) in
                guard let model = CQTaskModel.init(jsonData: result["data"]) else {
                    return
                }
                self.iconImg.sd_setImage(with: URL(string: model.createUserHeadImage), placeholderImage:UIImage.init(named: "personDefaultIcon"))
                self.nameLab.text = model.createUserRealName
                self.timeLab.text = model.createTime
                let H = self.getTextHeigh(textStr: model.taskContent, font: kFontSize15, width: kWidth-2*kLeftDis)
                self.contentLab.frame = CGRect.init(x: kLeftDis, y:self.iconImg.bottom + AutoGetWidth(width: 16), width: kHaveLeftWidth, height: H)
                //图片判断
                var picheight:CGFloat = 0
                if model.picurlData.count > 0{
                    self.picview.isHidden = false
                    self.picview.imags = model.picurlData
                    self.picview.frame =  CGRect(x: kLeftDis, y: self.contentLab.bottom+AutoGetWidth(width: 14), width: kWidth/3*2, height: self.picview.pictureViewHeight)
                    picheight = self.picview.pictureViewHeight+AutoGetHeight(height: 14)
                }else{
                    self.picview.isHidden = true
                    self.picview.frame =  CGRect(x: kLeftDis, y: self.contentLab.bottom, width: kWidth/3*2, height: 0)
                    picheight = 0
                }
                
                self.delineTimeLab.frame = CGRect.init(x: kLeftDis, y:self.picview.bottom + AutoGetWidth(width: 14), width: kHaveLeftWidth, height: AutoGetHeight(height: 13))
                
                self.headView.frame =  CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 135) + H + picheight)
                
                self.reportBgView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height:AutoGetHeight(height: 122) + H + picheight)
                self.contentLab.text = model.taskContent
                if "1" == model.priorityLevel{
                    self.statusImg.image = UIImage.init(named: "TaskSerrier")
                }else if "2" == model.priorityLevel{
                    self.statusImg.image = UIImage.init(named: "TaskSoSo")
                }else if "3" == model.priorityLevel{
                    self.statusImg.isHidden = true
                }
                self.delineTimeLab.text = model.deadLine
                
                var arr = [CQTaskUserModel]()
                
                self.userArray.removeAll()
                
                for modalJson in result["data"]["userData"].arrayValue  {
                    guard let modal = CQTaskUserModel(jsonData: JSON(modalJson)) else {
                        return
                    }
                    DLog(modal)
                    arr.append(modal)
                }
                self.userArray = arr
                
                if model.isCreateUser{
                    
                }
                self.table.reloadData()
                
        }) { (error) in
            
        }
    }
}

extension CQTaskDetailVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQTaskDetailCellId") as! CQTaskDetailCell
        cell.model = self.userArray[indexPath.row]
      //  cell.selectionStyle = .none
        cell.finishDelegate = self
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return AutoGetHeight(height: 70)
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mod = userArray[indexPath.row]
        return CGFloat(mod.rowHeight)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AutoGetHeight(height: 38)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 38)))
        header.backgroundColor = UIColor.white
        let lab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kWidth, height: AutoGetHeight(height: 38)))
        lab.text = "任务成员"
        lab.textAlignment = .left
        lab.textColor = UIColor.black
        lab.font = kFontSize15
        header.addSubview(lab)
        let line = UIView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 38) - 0.5, width: kWidth, height: 0.5))
        line.backgroundColor = kProjectBgColor
        header.addSubview(line)
        return header
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension CQTaskDetailVC:CQTaskDetailFinishDelegate{
    func commentPeople(comment: QRCommentDataModel ,taskId:String) {
        let vc = QRPingLunVC()
        vc.pataskId = taskId
        vc.backMod = comment
        vc.isFromBack = true
        vc.title = "评论"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func liuYanPeople(taskId: String) {
        let vc = QRPingLunVC()
        
        vc.pataskId = taskId
        vc.title = "评论"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func finishClick(index: IndexPath) {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/personnelTask/setPersonnelTaskIsfinishSign",
            type: .post,
            param: ["userId":userID,
                    "personnelTaskId":self.personnelTaskId,
                    "finishSign":true],
            successCallBack: { (result) in
                SVProgressHUD.showInfo(withStatus: "完成")
                self.loadDetailData()
                self.table.reloadData()
        }) { (error) in
            
        }
    }
    
    
}

//
//  CQFulltextVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/9.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

enum ToFullTextType {
    case fromMyRecieve
    
}


class CQFulltextVC: SuperVC {
    var collectionArr = [CQFullTextModel]()
    var personnelReportId = ""
    var lastBtn:UIButton?
    var isRead = true
    var toType:ToFullTextType?
    var urlStr = ""
    var attachmentId = ""
    var attachmentOldName = ""
    var viewHeight:CGFloat = AutoGetHeight(height: 74)
    var curHeight:CGFloat = 0
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        table.backgroundColor = kProjectBgColor
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 750)))
        headView.backgroundColor = UIColor.white
        return headView
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
    
    lazy var todayFinishWorkLab: UILabel = {
        let todayFinishWorkLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: AutoGetHeight(height: 15)))
        todayFinishWorkLab.font = kFontSize15
        todayFinishWorkLab.textAlignment = .left
        todayFinishWorkLab.textColor = kLyGrayColor
        todayFinishWorkLab.text = "今日完成工作"
        return todayFinishWorkLab
    }()
    
    lazy var todayFinishWorkContentLab: UILabel = {
        let todayFinishWorkContentLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: AutoGetHeight(height: 36)))
        todayFinishWorkContentLab.font = kFontSize15
        todayFinishWorkContentLab.textAlignment = .left
        todayFinishWorkContentLab.textColor = UIColor.black
        todayFinishWorkContentLab.text = "我就想写一堆测试文字来看看现在给的还不够吗我去了继续写应该够了吧估计是够了也许够了 够了够了"
        todayFinishWorkContentLab.numberOfLines = 0
        return todayFinishWorkContentLab
    }()
    
    lazy var todayNotFinishWorkLab: UILabel = {
        let todayNotFinishWorkLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.viewHeight+5, width: kHaveLeftWidth, height: AutoGetHeight(height: 15)))
        todayNotFinishWorkLab.font = kFontSize15
        todayNotFinishWorkLab.textAlignment = .left
        todayNotFinishWorkLab.textColor = kLyGrayColor
        todayNotFinishWorkLab.text = "未完成工作"
        return todayNotFinishWorkLab
    }()
    
    lazy var todayNotFinishWorkContentLab: UILabel = {
        let todayNotFinishWorkContentLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: AutoGetHeight(height: 15)))
        todayNotFinishWorkContentLab.font = kFontSize15
        todayNotFinishWorkContentLab.textAlignment = .left
        todayNotFinishWorkContentLab.textColor = UIColor.black
        todayNotFinishWorkContentLab.text = "未完成工作..就是随便瞎写写"
        todayNotFinishWorkContentLab.numberOfLines = 0
        return todayNotFinishWorkContentLab
    }()
    
    lazy var needCoordinateLab: UILabel = {
        let needCoordinateLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.viewHeight+5, width: kHaveLeftWidth, height: AutoGetHeight(height: 15)))
        needCoordinateLab.font = kFontSize15
        needCoordinateLab.textAlignment = .left
        needCoordinateLab.textColor = kLyGrayColor
        needCoordinateLab.text = "需协调工作"
        return needCoordinateLab
    }()
    
    lazy var needCoordinateContentLab: UILabel = {
        let needCoordinateContentLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: AutoGetHeight(height: 15)))
        needCoordinateContentLab.font = kFontSize15
        needCoordinateContentLab.textAlignment = .left
        needCoordinateContentLab.textColor = UIColor.black
        needCoordinateContentLab.text = "需协调工作,定制日志末班，信息收集更准确"
        needCoordinateContentLab.numberOfLines = 0
        return needCoordinateContentLab
    }()
    
    lazy var sumLab: UILabel = {
        let sumLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.viewHeight+5, width: kHaveLeftWidth, height: AutoGetHeight(height: 15)))
        sumLab.font = kFontSize15
        sumLab.textAlignment = .left
        sumLab.textColor = kLyGrayColor
        sumLab.text = "需帮助与支持"
        return sumLab
    }()
    
    lazy var sumDetailLab: UILabel = {
        let sumDetailLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: AutoGetHeight(height: 15)))
        sumDetailLab.font = kFontSize15
        sumDetailLab.textAlignment = .left
        sumDetailLab.textColor = UIColor.black
        sumDetailLab.text = "需协调工作,定制日志末班，信息收集更准确"
        sumDetailLab.numberOfLines = 0
        return sumDetailLab
    }()
    
    
    lazy var fileLab: UILabel = {
        let fileLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.viewHeight+6, width: kHaveLeftWidth, height: AutoGetHeight(height: 15)))
        fileLab.font = kFontSize15
        fileLab.textAlignment = .left
        fileLab.textColor = kLyGrayColor
        fileLab.text = "附件"
        return fileLab
    }()
    
    lazy var fileBtn: UIButton = {
        let fileBtn = UIButton.init(type: .custom)
        fileBtn.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: AutoGetHeight(height: 35))
        fileBtn.setTitle("点击预览附件", for: .normal)
        fileBtn.setTitleColor(kLyGrayColor, for: .normal)
        fileBtn.addTarget(self, action: #selector(fileSeeClick), for: .touchUpInside)
        fileBtn.layer.borderWidth = 0.5
        fileBtn.titleLabel?.font = kFontSize13
        fileBtn.layer.borderColor = kLineColor.cgColor
        return fileBtn
    }()
    
    lazy var hasReadView: UIView = {
        let hasReadView = UIView.init(frame: CGRect.init(x: 0, y: self.viewHeight, width: kWidth, height: AutoGetHeight(height: 145)))
        hasReadView.backgroundColor = UIColor.white
        return hasReadView
    }()
    
    lazy var hasReadBtn: UIButton = {
        let hasReadBtn = UIButton.init(type: .custom)
        hasReadBtn.frame = CGRect.init(x: 0, y: 0, width: AutoGetWidth(width: 70), height: AutoGetHeight(height: 51))
        hasReadBtn.titleLabel?.font = kFontSize15
        hasReadBtn.setTitle("已读", for: .normal)
        hasReadBtn.setTitleColor(UIColor.black, for: .normal)
        hasReadBtn.tag = 200
        hasReadBtn.addTarget(self, action: #selector(hasReadClick), for: .touchUpInside)
        return hasReadBtn
    }()
    
    lazy var hasNotReadBtn: UIButton = {
        let hasNotReadBtn = UIButton.init(type: .custom)
        hasNotReadBtn.frame = CGRect.init(x: self.hasReadBtn.right, y: 0, width: AutoGetWidth(width: 70), height: AutoGetHeight(height: 51))
        hasNotReadBtn.titleLabel?.font = kFontSize15
        hasNotReadBtn.setTitle("未读", for: .normal)
        hasNotReadBtn.tag = 201
        hasNotReadBtn.setTitleColor(kLyGrayColor, for: .normal)
        hasNotReadBtn.addTarget(self, action: #selector(hasNotReadClick), for: .touchUpInside)
        return hasNotReadBtn
    }()
    
  
    lazy var collectionView: UICollectionView = {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width: kHaveLeftWidth/4, height: AutoGetHeight(height: 75))
        layOut.minimumLineSpacing = 0
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        let collectionView = UICollectionView.init(frame: CGRect.init(x: kLeftDis, y: self.hasNotReadBtn.bottom , width: kHaveLeftWidth, height: AutoGetHeight(height: 75)), collectionViewLayout: layOut)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CQFullTextCell.self, forCellWithReuseIdentifier: "CQFullTextCellId")
        return collectionView
    }()
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "汇报"
        
        loadData()
        
    }
    
    func initView()  {
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.iconImg)
        self.headView.addSubview(self.nameLab)
        self.headView.addSubview(self.timeLab)
        
    }
    
    @objc func hasReadClick(btn:UIButton)  {
        if lastBtn?.tag != btn.tag {
            lastBtn?.setTitleColor(kLyGrayColor, for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            lastBtn = btn
            isRead = true
            self.loadScrollViewData()
        }
        
    }
    @objc func hasNotReadClick(btn:UIButton)  {
        if lastBtn?.tag != btn.tag {
            lastBtn?.setTitleColor(kLyGrayColor, for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            lastBtn = btn
            isRead = false
            self.loadScrollViewData()
        }
        
    }
    
    @objc func fileSeeClick()  {
        if !self.attachmentId.isEmpty {
            let vc = CQWebVC()
            vc.urlStr = self.urlStr
            vc.titleStr = self.attachmentOldName
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            SVProgressHUD.showInfo(withStatus: "没有可预览的附件")
        }
    }
}

extension CQFulltextVC{
    func loadData()  {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/personnelReport/getPersonnelReportDetails" ,
            type: .get,
            param: ["userId":userID,
                    "personnelReportId":self.personnelReportId],
            successCallBack: { (result) in
                guard let model = CQFullTextModel.init(jsonData: result["data"]) else {
                    return
                }
                
                self.initView()
                
                self.iconImg.sd_setImage(with: URL(string: model.createUserHeadImage ), placeholderImage:UIImage.init(named: "personDefaultIcon") )
                self.timeLab.text = model.createTime
                self.urlStr = model.attachmentPath
                self.attachmentId = model.attachmentId
                self.attachmentOldName = model.attachmentOldName
                self.nameLab.text = model.createUserRealName
                
                if model.reportType == "1"{
                    self.headView.addSubview(self.todayFinishWorkLab)
                    self.viewHeight += AutoGetHeight(height: 15)
                    self.headView.addSubview(self.todayFinishWorkContentLab)
                    let firstHeight = getTextHeight(text: model.hasdoWork, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
                    self.todayFinishWorkContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: firstHeight)
                    self.viewHeight += firstHeight
                    self.headView.addSubview(self.todayNotFinishWorkLab)
                    self.viewHeight += AutoGetHeight(height: 15)
                    self.headView.addSubview(self.todayNotFinishWorkContentLab)
                    let secHeight = getTextHeight(text: model.teamWork, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
                    self.todayNotFinishWorkContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: secHeight)
                    self.viewHeight += secHeight
                    self.headView.addSubview(self.needCoordinateLab)
                    self.viewHeight += AutoGetHeight(height: 15)
                    self.headView.addSubview(self.needCoordinateContentLab)
                    let thirdHeight = getTextHeight(text: model.undoWork, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
                    self.needCoordinateContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: thirdHeight)
                    self.viewHeight += thirdHeight
                    
                    self.todayFinishWorkLab.text = "今日完成工作"
                    self.todayNotFinishWorkLab.text = "未完成工作"
                    self.needCoordinateLab.text = "需协调工作"
                    self.todayFinishWorkContentLab.text = model.hasdoWork
                    self.todayNotFinishWorkContentLab.text = model.teamWork
                    self.needCoordinateContentLab.text = model.undoWork
                }else if model.reportType == "2"{
                    
                    
                    self.headView.addSubview(self.todayFinishWorkLab)
                    self.viewHeight += AutoGetHeight(height: 15)
                    self.headView.addSubview(self.todayFinishWorkContentLab)
                    let firstHeight = getTextHeight(text: model.thisWorkContent, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
                    self.todayFinishWorkContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: firstHeight)
                    self.viewHeight += firstHeight
                    self.headView.addSubview(self.todayNotFinishWorkLab)
                    self.viewHeight += AutoGetHeight(height: 15)
                    self.headView.addSubview(self.todayNotFinishWorkContentLab)
                    let secHeight = getTextHeight(text: model.thisWorkSummary, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
                    self.todayNotFinishWorkContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: secHeight)
                    self.viewHeight += secHeight
                    self.headView.addSubview(self.needCoordinateLab)
                    self.viewHeight += AutoGetHeight(height: 15)
                    self.headView.addSubview(self.needCoordinateContentLab)
                    let thirdHeight = getTextHeight(text: model.nextWorkPlan, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
                    self.needCoordinateContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: thirdHeight)
                    self.viewHeight += thirdHeight
                    self.headView.addSubview(self.sumLab)
                    self.viewHeight += AutoGetHeight(height: 15)
                    self.headView.addSubview(self.sumDetailLab)
                    let forHeight = getTextHeight(text: model.needHelp, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
                    self.sumDetailLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: forHeight)
                    self.viewHeight += forHeight
                    
                    self.todayFinishWorkLab.text = "本周工作内容"
                    self.todayNotFinishWorkLab.text = "本周工作总结"
                    self.needCoordinateLab.text = "下周工作计划"
                    self.sumLab.text = "需帮助与支持"
                    self.todayFinishWorkContentLab.text = model.thisWorkContent
                    self.todayNotFinishWorkContentLab.text = model.thisWorkSummary
                    self.needCoordinateContentLab.text = model.nextWorkPlan
                    self.sumDetailLab.text = model.needHelp
                }else if model.reportType == "3"{
                    
                    
                    self.headView.addSubview(self.todayFinishWorkLab)
                    self.viewHeight += AutoGetHeight(height: 15)
                    self.headView.addSubview(self.todayFinishWorkContentLab)
                    let firstHeight = getTextHeight(text: model.thisWorkContent, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
                    self.todayFinishWorkContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: firstHeight)
                    self.viewHeight += firstHeight
                    self.headView.addSubview(self.todayNotFinishWorkLab)
                    self.viewHeight += AutoGetHeight(height: 15)
                    self.headView.addSubview(self.todayNotFinishWorkContentLab)
                    let secHeight = getTextHeight(text: model.thisWorkSummary, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
                    self.todayNotFinishWorkContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: secHeight)
                    self.viewHeight += secHeight
                    self.headView.addSubview(self.needCoordinateLab)
                    self.viewHeight += AutoGetHeight(height: 15)
                    self.headView.addSubview(self.needCoordinateContentLab)
                    let thirdHeight = getTextHeight(text: model.nextWorkPlan, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
                    self.needCoordinateContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: thirdHeight)
                    self.viewHeight += thirdHeight
                    self.headView.addSubview(self.sumLab)
                    self.viewHeight += AutoGetHeight(height: 15)
                    self.headView.addSubview(self.sumDetailLab)
                    let forHeight = getTextHeight(text: model.needHelp, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
                    self.sumDetailLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: forHeight)
                    self.viewHeight += forHeight
                    
                    self.todayFinishWorkLab.text = "本月工作内容"
                    self.todayNotFinishWorkLab.text = "本月工作总结"
                    self.needCoordinateLab.text = "下月工作计划"
                    self.sumLab.text = "需帮助与支持"
                    self.todayFinishWorkContentLab.text = model.thisWorkContent
                    self.todayNotFinishWorkContentLab.text = model.thisWorkSummary
                    self.needCoordinateContentLab.text = model.nextWorkPlan
                    self.sumDetailLab.text = model.needHelp
                }
                
                DLog(self.viewHeight)
                let grayView = UIView.init(frame: CGRect.init(x: 0, y: self.viewHeight, width: kWidth, height: AutoGetHeight(height: 20)))
                grayView.backgroundColor = kProjectBgColor
                self.headView.addSubview(grayView)
                self.viewHeight += AutoGetHeight(height: 20)
                
                if !model.attachmentOldName.isEmpty {
                    self.headView.addSubview(self.fileLab)
                    self.viewHeight += AutoGetHeight(height: 25)
                    self.headView.addSubview(self.fileBtn)
                    self.viewHeight += AutoGetHeight(height: 45)
                    
                    self.fileBtn.setTitle("附件:   " + model.attachmentOldName, for: .normal)
                }
                
                self.curHeight = self.viewHeight
                
                if self.toType == .fromMyRecieve {
                }else{
                    if model.reportType == "1"{
                        self.nameLab.text = "我的日报"
                    }else if model.reportType == "2"{
                        self.nameLab.text = "我的周报"
                    }else if model.reportType == "3"{
                        self.nameLab.text = "我的月报"
                    }
                    self.loadScrollViewData()
                    self.headView.addSubview(self.hasReadView)
                    self.hasReadView.addSubview(self.hasReadBtn)
                    self.hasReadView.addSubview(self.hasNotReadBtn)
                    self.hasReadView.addSubview(self.collectionView)
                    self.lastBtn = self.hasReadBtn
                }
                
                self.hasReadBtn.setTitle("已读"+model.readNum, for: .normal)
                self.hasNotReadBtn.setTitle("未读"+model.unReadNum, for: .normal)
                
                self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: self.viewHeight)
                self.table.reloadData()
                
        }) { (error) in
            self.table.reloadData()
            
        }
    }
    
    
    func loadScrollViewData() {
        STNetworkTools.requestData(URLString: "\(baseUrl)/personnelReport/getPersonnelReportJoinUser",
            type: .get,
            param: ["personnelReportId":self.personnelReportId,
                    "readSign":self.isRead],
            successCallBack: { (result) in
                self.collectionArr.removeAll()
                
                var tempArray = [CQFullTextModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQFullTextModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                self.collectionArr = tempArray
                
                let height = CGFloat(self.collectionArr.count/4 + 1) * AutoGetHeight(height: 75) + AutoGetHeight(height: 70)
                self.hasReadView.frame = CGRect.init(x: 0, y: self.curHeight , width: kWidth, height: height )
                self.collectionView.frame = CGRect.init(x: kLeftDis, y: self.hasNotReadBtn.bottom , width: kHaveLeftWidth, height: height - AutoGetHeight(height: 70))
                self.viewHeight = self.curHeight + height
                self.headView.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: self.viewHeight)
                self.table.reloadData()
                
                self.collectionView.reloadData()
        }) { (error) in
            
        }
    }
}

// MARK: - 代理

extension CQFulltextVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.collectionArr.count
    }
    
}

extension CQFulltextVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQFullTextCellId", for: indexPath) as! CQFullTextCell
        cell.model = self.collectionArr[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension CQFulltextVC{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / scrollView.frame.width
        let titleButton:UIButton = self.view.viewWithTag(Int(200+index)) as! UIButton
        lastBtn?.setTitleColor(kLyGrayColor, for: .normal)
        titleButton.setTitleColor(UIColor.black, for: .normal)
        lastBtn = titleButton
        if titleButton.tag == 200 {
            self.isRead = true
        }else{
            self.isRead = false
        }
        self.loadScrollViewData()
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

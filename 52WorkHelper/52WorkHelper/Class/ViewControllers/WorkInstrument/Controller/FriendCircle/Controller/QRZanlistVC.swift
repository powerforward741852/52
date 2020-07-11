//
//  QRZanlistVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/18.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRZanlistVC: SuperVC {
    var pageNum = 1
    var dataArray = [QRZanlistModel]()
    var myData : QRZanlistModel?
    lazy var headView : UIView = {
        let headView = UIView(frame:  CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 110)))
        headView.backgroundColor = UIColor.colorWithHexString(hex: "#f7f7f7")
        headView.addSubview(headBgView)
        return headView
    }()
    
    lazy var headBgView : UIView = {
        let headBgView = UIView(frame:  CGRect(x: kLeftDis, y: AutoGetWidth(width: 15), width: kHaveLeftWidth, height: AutoGetHeight(height: 80)))
        headBgView.layer.cornerRadius = AutoGetWidth(width: 8)
       // headBgView.clipsToBounds = true
        headBgView.layer.shadowOpacity = 0.2;// 阴影透明度
        headBgView.layer.shadowColor = UIColor.black.cgColor;// 阴影的颜色
        headBgView.layer.shadowRadius = 0.3;// 阴影扩散的范围控制
        headBgView.layer.shadowOffset = CGSize(width: 0.2, height: 0.2)// 阴影的范围
        headBgView.backgroundColor = UIColor.white
        headBgView.addSubview(imgIcon)
        headBgView.addSubview(Namelab)
        headBgView.addSubview(positionlab)
        headBgView.addSubview(paiMingLab)
        headBgView.addSubview(zanCountLab)
        headBgView.addSubview(rankIcon)
        return headBgView
    }()
    lazy var rankIcon : UIImageView = {
        let rankIcon = UIImageView(frame:  CGRect(x:paiMingLab.left-AutoGetHeight(height: 22.5), y:paiMingLab.bottom - AutoGetHeight(height: 17.5) , width: AutoGetHeight(height: 17.5), height: AutoGetHeight(height: 17.5)))
        rankIcon.image = UIImage(named: "paim")
        return rankIcon
    }()
    
    lazy var imgIcon : UIImageView = {
        let imgIcon = UIImageView(frame:  CGRect(x: AutoGetHeight(height: 10), y:AutoGetHeight(height: 15) , width: AutoGetHeight(height: 50), height: AutoGetHeight(height: 50)))
        imgIcon.layer.cornerRadius = AutoGetHeight(height: 25)
        imgIcon.clipsToBounds = true
        imgIcon.image = UIImage(named: "CQIndexPersonDefault")
        return imgIcon
    }()
    
    lazy var Namelab :UILabel = {
        let Namelab = UILabel(title: " ", textColor: UIColor.black, fontSize: 18)
        Namelab.numberOfLines = 1
        Namelab.frame =  CGRect(x: imgIcon.right+5, y: imgIcon.top, width: AutoGetWidth(width: 130), height: 20)
        return Namelab
    }()
    lazy var positionlab :UILabel = {
        let positionlab = UILabel(title: " ", textColor: UIColor.colorWithHexString(hex: "#8b8b8b"), fontSize: 14)
        positionlab.numberOfLines = 1
        positionlab.frame =  CGRect(x: imgIcon.right+5, y: imgIcon.bottom-20, width: AutoGetWidth(width: 130), height: 20)
        return positionlab
    }()
    
    lazy var zanCountLab :UILabel = {
        let zanCountLab = UILabel(title: "", textColor: UIColor.colorWithHexString(hex: "#f69a00"), fontSize: 30)
        zanCountLab.font = UIFont.boldSystemFont(ofSize: 32)
        zanCountLab.numberOfLines = 1
        zanCountLab.textAlignment = .center
        zanCountLab.frame =  CGRect(x: kHaveLeftWidth-AutoGetHeight(height: 60), y: imgIcon.top+5, width: AutoGetWidth(width: 30), height: imgIcon.frame.height-10)
        zanCountLab.center.y = AutoGetHeight(height: 40)
        return zanCountLab
    }()
    
    lazy var paiMingLab :UILabel = {
        let paiMingLab = UILabel(title: "", textColor: UIColor.colorWithHexString(hex: "#aaaaaa"), fontSize: 13)
        paiMingLab.numberOfLines = 1
        
        paiMingLab.frame =  CGRect(x: kHaveLeftWidth, y: zanCountLab.bottom-5, width: AutoGetWidth(width: 30), height: imgIcon.frame.height)
       // paiMingLab.sizeToFit()
        paiMingLab.center.x = zanCountLab.center.x
        return paiMingLab
    }()
    
    lazy var firstSectionView : UIView = {
        let firstSectionView = UIView(frame:  CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 55)))
        firstSectionView.backgroundColor = UIColor.white
        
        let paiMing = UILabel(title: "排名", textColor: UIColor.black, fontSize: 14 )
        paiMing.textAlignment = .center
        paiMing.numberOfLines = 1
        paiMing.frame =  CGRect(x: 0, y: 0, width: kWidth/4, height: AutoGetWidth(width: 55))
        let touXiang = UILabel(title: "头像", textColor: UIColor.black, fontSize: 14)
        touXiang.textAlignment = .center
        touXiang.numberOfLines = 1
        touXiang.frame =  CGRect(x: kWidth/4, y: 0, width: kWidth/4, height: AutoGetWidth(width: 55))
        let xingMing = UILabel(title: "姓名", textColor: UIColor.black, fontSize: 14)
        xingMing.textAlignment = .center
        xingMing.numberOfLines = 1
        xingMing.frame =  CGRect(x: kWidth/2, y: 0, width: kWidth/4, height: AutoGetWidth(width: 55))
        let huoZan = UILabel(title: "获赞", textColor: UIColor.black, fontSize: 14)
        huoZan.textAlignment = .center
        huoZan.numberOfLines = 1
        huoZan.frame =  CGRect(x: kWidth/4*3, y: 0, width: kWidth/4, height: AutoGetWidth(width: 55))
        firstSectionView.addSubview(paiMing)
        firstSectionView.addSubview(touXiang)
        firstSectionView.addSubview(xingMing)
        firstSectionView.addSubview(huoZan)
        return firstSectionView
    }()
    
    
//    lazy var paiHangBangBtn : UIButton = {
//        let paiHangBangBtn = UIButton(frame:  CGRect(x: kWidth/4, y: AutoGetHeight(height: 90), width: kWidth/2, height: AutoGetHeight(height: 30)))
//        paiHangBangBtn.setTitle("查看获赞排行榜 >", for: UIControlState.normal)
//        paiHangBangBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
//        paiHangBangBtn.addTarget(self, action: #selector(jumpPaihb), for: UIControlEvents.touchUpInside)
//        return paiHangBangBtn
//    }()
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: SafeAreaTopHeight, width: kWidth, height: kHeight-SafeAreaTopHeight ), style: UITableViewStyle.plain)
        if #available(iOS 11.0, *) {
            //            table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
            //            table.contentInset = UIEdgeInsetsMake(CGFloat(SafeAreaTopHeight), 0, CGFloat(SafeAreaBottomHeight), 0);
            //            table.scrollIndicatorInsets = table.contentInset;
        } else {
            //低于 iOS 9.0
            self.automaticallyAdjustsScrollViewInsets = false
        }
        table.register(QRZanPaiMingCell.self, forCellReuseIdentifier: "zanpaimingcellid")
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
       // table.estimatedRowHeight = 107
        table.rowHeight = AutoGetWidth(width: 55)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "获赞排行榜"
        view.backgroundColor = UIColor.white
        view.addSubview(table)
       // table.tableHeaderView = headView
        setUpRefresh()
    }
    deinit {
    }
    func setUpRefresh()  {
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
    
    func loadDatas(moreData:Bool) {
        
        if moreData {
            pageNum += 1
        } else {
            pageNum = 1
        }
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/admir/getRankList" ,
            type: .get,
            param: ["userId":userID,
                    "currentPage":pageNum,
                    "rows":"10"],
            successCallBack: { (result) in
                var tempArray = [QRZanlistModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = QRZanlistModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                let myMod = QRZanlistModel(jsonData: result["mydata"])
                self.myData = myMod
                
                if myMod?.number == "0" {
                    self.table.tableHeaderView = nil
                }else{
                    self.table.tableHeaderView = self.headView
                    self.imgIcon.sd_setImage(with: URL(string: myMod?.headImage ?? ""), placeholderImage: UIImage(named: "CQIndexPersonDefault"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
                    self.Namelab.text = myMod?.realName
                    self.positionlab.text = myMod?.positionName
                    self.zanCountLab.text = myMod?.admirNum
                    self.paiMingLab.text = "第" + (myMod?.number)! + "名"
                    self.paiMingLab.sizeToFit()
                }
                
                if self.pageNum > 1 {
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
                
        }) { (error) in
            self.table.reloadData()
            self.table.mj_header.endRefreshing()
            self.table.mj_footer.endRefreshing()
        }
    }
   

}

extension QRZanlistVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "zanpaimingcellid", for: indexPath) as! QRZanPaiMingCell
        cell.model = dataArray[indexPath.row]
     //   cell.paiMingLable.font = UIFont.boldSystemFont(ofSize: 18)
        cell.paiMingLable.font = UIFont.init(name: "Helvetica-BoldOblique", size: 18)
        cell.zanLable.textColor = UIColor.colorWithHexString(hex: "#f69a00")
        cell.zanLable.font = UIFont.boldSystemFont(ofSize: 18)
        if indexPath.row == 0 {
            cell.paiMingLable.textColor = UIColor.colorWithHexString(hex: "#f8c904")
        }else if indexPath.row == 1 {
            cell.paiMingLable.textColor = UIColor.colorWithHexString(hex: "#a3b1c4")
        }else if indexPath.row == 2 {
            cell.paiMingLable.textColor = UIColor.colorWithHexString(hex: "#ba7e07")
        }else if indexPath.row == 3 {
            cell.paiMingLable.textColor = UIColor.colorWithHexString(hex: "#b5b5b5")
        }else{
            cell.paiMingLable.textColor = UIColor.colorWithHexString(hex: "#b4b4b4")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return firstSectionView
        }else{
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section==0 {
            return AutoGetHeight(height: 55)
        }else{
           return 0.01
        }
    }
}

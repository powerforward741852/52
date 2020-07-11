//
//  CQFriendCircleVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/19.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQFriendCircleVC: SuperVC {

    var pageNum = 1
    weak var rootLayout :TGLinearLayout! //整个背景约束
    var dataArray = [CQWorkMateCircleModel]()
    /*创建一个输入框*/
    var ewenTextView:EwenTextView!
    //当前评论点中对应的 最底层的类cell控件tag值
    var currentCount:Int?
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight ))
        headView.backgroundColor = UIColor.white
        return headView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpRefresh()
        self.title = "同事圈"
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
        
        self.headView.tg_width.equal(.wrap)
        self.headView.tg_height.equal(.wrap)
        //如果一个非布局父视图里面有布局子视图，那么这个非布局父视图也是可以将高度和宽度设置为.wrap的，他表示的意义是这个非布局父视图的尺寸由里面的布局子视图的尺寸来决定的。还有一个场景是非布局父视图是一个UIScrollView。他是左右滚动的，但是滚动视图的高度是由里面的布局子视图确定的，而宽度则是和窗口保持一致。这样只需要将滚动视图的宽度设置为和屏幕保持一致，高度设置为.wrap，并且把一个水平线性布局添加到滚动视图即可。
        let rootLayout = TGLinearLayout(.vert)
        rootLayout.tg_height.equal(.wrap)
        rootLayout.tg_width.equal(.wrap)
        rootLayout.isUserInteractionEnabled = true
        //        rootLayout.tg_padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        rootLayout.tg_zeroPadding = false   //这个属性设置为false时表示当布局视图的尺寸是wrap也就是由子视图决定时并且在没有任何子视图是不会参与布局视图高度的计算的。您可以在这个DEMO的测试中将所有子视图都删除掉，看看效果，然后注释掉这句代码看看效果。
        //        rootLayout.tg_vspace = 5
        self.headView.addSubview(rootLayout)
        self.rootLayout = rootLayout
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        rightBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: -25)
        rightBtn.setImage(UIImage.init(named: "FriendAdd"), for: .normal)
        rightBtn.addTarget(self, action: #selector(publishClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUI), name: NSNotification.Name.init("refreshFriendView"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        setUpRefresh()
    }
    
    @objc func refreshUI()  {
        self.setUpRefresh()
    }
    
    @objc func publishClick()  {
        let vc = CQPublishToCircleVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CQFriendCircleVC{
    fileprivate func setUpRefresh() {
        // MARK:header
        let STHeader = CQRefreshHeader {[unowned self] in
             self.dataArray.removeAll()
            self.pageNum = 1
            self.loadDatas(page: self.pageNum)
        }
        // MARK:footer
        let STFooter = CQRefreshFooter {[unowned self] in
            self.pageNum += 1
            self.loadDatas(page: self.pageNum)
        }
        self.table.mj_header = STHeader
        self.table.mj_footer = STFooter
        self.table.mj_header.beginRefreshing()
    }
    // MARK:request
    fileprivate func loadDatas(page: Int) {
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/circle/getCircleArticleByPage" ,
            type: .get,
            param: ["userId":userID,
                    "currentPage":pageNum,
                    "rows":"10"],
            successCallBack: { (result) in
                var tempArray = [CQWorkMateCircleModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQWorkMateCircleModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                
                if page>1 {
                    self.dataArray.append(contentsOf: tempArray)
                } else {
                    self.dataArray = tempArray
                }
                
                self.rootLayout.removeAllSubviews()
                
                for i in 0..<self.dataArray.count{
                    let model = self.dataArray[i]
                    var collectH:CGFloat!
                    if model.picurlData.count == 1 {
                        collectH = AutoGetWidth(width: 180)
                    }else if model.picurlData.count == 2 || model.picurlData.count == 3{
                        collectH = AutoGetHeight(height: 79)
                    }else if model.picurlData.count == 4 || model.picurlData.count == 5 || model.picurlData.count == 6{
                        collectH = AutoGetHeight(height: 163)
                    }else if model.picurlData.count == 7 || model.picurlData.count == 8 || model.picurlData.count == 9{
                        collectH = AutoGetHeight(height: 247)
                    }else {
                        collectH = AutoGetHeight(height: 0)
                    }
                    
                    var commentArr = [CQWorkMateCircleModel]()
                    for modalJson in model.commentData{
                        guard let modal = CQWorkMateCircleModel(jsonData: modalJson) else {
                            return
                        }
                        commentArr.append(modal)
                    }
                    
                    let tableH:CGFloat = CGFloat(commentArr.count + 1) * AutoGetHeight(height: 26)
                    
                    
                    self.rootLayout.addSubview(self.createIconAndNameAndTimeLayout(image: model.iconImg, name: model.realName, time: model.differTime, content: model.articleContent, tag: 10000 + i , collectionH:collectH, tableH: tableH, i: i, collectDataArr: model.picurlData, tableDataArr:commentArr,userArr:model.laudUserData,laudStatus:model.laudStatus))
                }
                
                
                for v in self.rootLayout.subviews{
                    for sub in v.subviews{
                        for sbV in sub.subviews{
                            if 40000 == sbV.tag{
                                for baseV in sbV.subviews{
                                    if baseV.tag == 40000{
                                        let dv = baseV as! CQFriendCircleTable
                                        dv.setNeedsLayout()
                                        dv.layoutIfNeeded()
                                        dv.reloadData()
                                        
                                        //                                        dv.reloadData()
                                        //                                        dv.reloadSections(IndexSet.init(integer: 0), with: UITableViewRowAnimation.automatic)
                                    }
                                }
                            }
                        }
                    }
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
    
    func zanRequest(model:CQWorkMateCircleModel,index:Int,sender:UIButton) {
        var laudMode = ""
        if model.laudStatus {
            laudMode = "0"
        }else{
            laudMode = "1"
        }
        
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/circle/saveCircleLaud",
            type: .post,
            param: ["userId":userID,
                    "circleArticleId":model.circleArticleId,
                    "laudMode":laudMode],
            successCallBack: { (result) in
                
                var arr = [JSON]()
                arr = model.laudUserData
                if arr.count < 1 {
                    for v in (sender.superview?.superview?.superview?.subviews)!{
                        if 1000 == v.tag{
                            for sub in v.subviews{
                                if sub.tag == 1098{
                                    sub.removeAllSubviews()
                                    sub.removeFromSuperview()
                                }
                                if 2018 == sub.tag{
                                    for dv in sub.subviews{
                                        if 19920121 == dv.tag{
                                            
                                            dv.removeAllSubviews()
                                            var commentArr = [CQWorkMateCircleModel]()
                                            for modalJson in model.commentData{
                                                guard let modal = CQWorkMateCircleModel(jsonData: modalJson) else {
                                                    return
                                                }
                                                commentArr.append(modal)
                                            }
                                            
                                            dv.addSubview(self.addZanAndCommentContentLayOut(tableDataArr:commentArr, userArr: model.laudUserData,newName:STUserTool.account().realName))
                                            v.addSubview(self.addLineLayout(tag: 1098))
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    for v in (sender.superview?.superview?.superview?.subviews)!{
                        if 1000 == v.tag{
                            for sub in v.subviews{
                                if 2018 == sub.tag{
                                    for dv in sub.subviews{
                                        if 19920121 == dv.tag{
                                            for lastV in dv.subviews{
                                                if 511111 == lastV.tag{
                                                    for desV in lastV.subviews{
                                                        if 198112 == desV.tag{
                                                            let lab = desV as! UILabel
                                                            //为真表示取消赞
                                                            if model.laudStatus {
                                                                let nameStr = lab.text! as NSString
                                                                let realName = STUserTool.account().realName
                                                                DLog(nameStr)
                                                                DLog(realName)
                                                                if lab.text == (" " + realName){
                                                                    lastV.removeAllSubviews()
                                                                    lastV.removeFromSuperview()
                                                                }else if nameStr.contains(STUserTool.account().realName + ",") {
                                                                    let new = nameStr.replacingOccurrences(of: STUserTool.account().realName + ",", with: "")
                                                                    lab.text = new as String
                                                                }else if nameStr.contains("," + STUserTool.account().realName ) {
                                                                    let new = nameStr.replacingOccurrences(of:"," + STUserTool.account().realName, with:"")
                                                                    lab.text = new as String
                                                                }
                                                            }else{
                                                                if (lab.text?.isEmpty)!{
                                                                    lab.text = STUserTool.account().realName
                                                                    
                                                                }else{
                                                                    let person = STUserTool.account().realName
                                                                    let str = lab.text
                                                                    lab.text = str! + "," + person
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                if model.laudStatus {
                    sender.setImage(UIImage.init(named: "CQWorkCircleCancelZan"), for: .normal)
                    model.laudStatus = !model.laudStatus
                }else if !model.laudStatus{
                    sender.setImage(UIImage.init(named: "CQWorkCircleZan"), for: .normal)
                    model.laudStatus = !model.laudStatus
                }
                
                self.loadDatas(page: Int(self.dataArray.count/10))
                
//                self.setUpRefresh()
//                self.loadDatas(moreData: true)
        }) { (error) in
            
        }
    }
    
    func commentRequest(model: CQWorkMateCircleModel,text:String) {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/circle/saveCircleComment",
            type: .post,
            param: ["userId":userID,
                    "circleArticleId":model.circleArticleId,
                    "commentContent":text],
            successCallBack: { (result) in
//                self.setUpRefresh()
//                self.loadDatas(moreData: true)
                self.loadDatas(page: Int((self.currentCount! + 1)/10))
        }) { (error) in
            
        }
    }
    //子评论
    func childCommentRequest(uId:String,text:String) {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/circle/saveCircleChildComment",
            type: .post,
            param: ["userId":userID,
                    "circleCommentId":uId,
                    "commentContent":text],
            successCallBack: { (result) in
//                self.setUpRefresh()
                self.loadDatas(page: Int((self.currentCount! + 1)/10))
                //                self.loadDatas(moreData: true)
        }) { (error) in
            
        }
    }
}


// MARK:生成水平模块
extension CQFriendCircleVC{
    
    //生成头像和名字加上评论的水平模块,从10000生成到20000
    internal func createIconAndNameAndTimeLayout(image:String,name:String,time:String,content:String,tag:Int,collectionH:CGFloat,tableH:CGFloat,i:Int,collectDataArr:[JSON],tableDataArr:[CQWorkMateCircleModel],userArr:[JSON],laudStatus:Bool) -> TGLinearLayout{
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        let actionLayout = TGLinearLayout(.vert)//竖直
        actionLayout.tg_width.equal(.wrap)
        actionLayout.tg_height.equal(.wrap)
        actionLayout.isUserInteractionEnabled = true
        actionLayout.tag = 1000
        wrapContentLayout.addSubview(actionLayout)
        
        actionLayout.addSubview(self.addIconImageLayout(image: image, tag: 3333))
        
        
        actionLayout.addSubview(self.addNameLabLayout(name: name, tag: 100))
        actionLayout.addSubview(self.addTimeLabLayout(time: time, tag: 101))
        actionLayout.addSubview(self.addContentLabLayout(content: content, tag: 102))
        actionLayout.addSubview(self.addCollectionViewLayout(collectDataArr:collectDataArr, tag: 103, height: collectionH, collectTag: 50000+i))
        actionLayout.addSubview(self.addCommentBtnLayout(tag: 20000+i,zanTag:30000+i,laudStatus:laudStatus))
        
        actionLayout.addSubview(self.addZanAndCommentContentLayOut(tableDataArr: tableDataArr, userArr: userArr,newName:""))
        
        actionLayout.addSubview(self.addLineLayout(tag:1098))
        return wrapContentLayout
    }
    
    //生成头像
    internal func addIconImageLayout(image:String,tag:Int) -> TGLinearLayout{
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addIconImageView(image: image,tag: tag))
        
        return wrapContentLayout
    }
    
    //生成用户名
    internal func addNameLabLayout(name:String,tag:Int) -> TGLinearLayout{
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addNameLab(title: name))
        
        return wrapContentLayout
    }
    
    //生成时间
    internal func addTimeLabLayout(time:String,tag:Int) -> TGLinearLayout{
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addTimeLab(time: time))
        
        return wrapContentLayout
    }
    
    //生成内容
    internal func addContentLabLayout(content:String,tag:Int) -> TGLinearLayout{
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addContentLab(content: content))
        
        return wrapContentLayout
    }
    
    //生成collection tag为100000 + 总数据的count
    internal func addCollectionViewLayout(collectDataArr:[JSON],tag:Int,height:CGFloat,collectTag:Int) -> TGLinearLayout{
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addCollectionView(tag: collectTag, height: height, collectDataArr: collectDataArr))
        
        return wrapContentLayout
    }
    
    //生成评论按钮tag为20000 + 总数据的count
    internal func addCommentBtnLayout(tag:Int,zanTag:Int,laudStatus:Bool) -> TGLinearLayout{
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addCommentBtn(tag: tag))
        wrapContentLayout.addSubview(self.addZanBtn(tag: zanTag,laudStatus:laudStatus))
        return wrapContentLayout
    }
    
    //生成赞按钮tag为30000 + 总数据的count
//    internal func addZanBtnLayout(tag:Int,laudStatus:String) -> TGLinearLayout{
//        let wrapContentLayout = TGLinearLayout(.horz)//横
//        wrapContentLayout.tg_height.equal(.wrap)
//        wrapContentLayout.tg_width.equal(.wrap)
//        wrapContentLayout.tag = tag
//        wrapContentLayout.isUserInteractionEnabled = true
//        wrapContentLayout.addSubview(self.addZanBtn(tag: tag,laudStatus:laudStatus))
//
//        return wrapContentLayout
//    }
    
    //生成table的tag为40000 + 总数据的count
    internal func addTableLayout(tag:Int,tableDataArray:[CQWorkMateCircleModel],height:CGFloat,userArr:[JSON]) -> TGLinearLayout{
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        
        wrapContentLayout.addSubview(self.addCommentTableView(tag: tag, tableDataArray: tableDataArray,height:height,userArr:userArr))
        
        return wrapContentLayout
    }
    
    //生成评论的tag为40000 + 总数据的count
    internal func addCommentLayout(tag:Int,commentName:String,answerName:String,commentConttent:String,dataArray:CQWorkMateCircleModel) -> TGLinearLayout{
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tg_top.equal(7)
      //  wrapContentLayout.tg_padding = UIEdgeInsets(top: 3,left: 5,bottom: 2,right: 0)
        wrapContentLayout.tag = tag

        wrapContentLayout.addSubview(self.addCommentLab(commentName: commentName, answerName:answerName, commentConttent: commentConttent,dataArray:dataArray,labTag:tag - 400000))
        
        return wrapContentLayout
    }
    
    //生成点赞人的tag为50000 + 总数据的count
    internal func addZanPeopleLayout(tag:Int,name:String) -> TGLinearLayout{
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_top.equal(3)
        wrapContentLayout.tg_bottom.equal(3)
        wrapContentLayout.tg_width.equal(.wrap)
//        wrapContentLayout.tg_left.equal(AutoGetWidth(width: 63))
        wrapContentLayout.tag = 511111
//        wrapContentLayout.backgroundColor = UIColor.colorWithHexString(hex: "#f2f6fc")
        
        wrapContentLayout.addSubview(self.addZanImageView())
        wrapContentLayout.addSubview(self.addZanPeopleLab(name: name))
        
        return wrapContentLayout
    }
    
    internal func addZanLineLayout(tag:Int,name:String) -> TGLinearLayout{
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(1)
        wrapContentLayout.tg_width.equal(.wrap)
        
        //        wrapContentLayout.tg_left.equal(AutoGetWidth(width: 63))
        //  wrapContentLayout.tag = 511111
        //        wrapContentLayout.backgroundColor = UIColor.colorWithHexString(hex: "#f2f6fc")
        let greyLine = UIView()
        greyLine.frame =  CGRect(x: 0, y: 0, width: kWidth - AutoGetWidth(width: 91), height: 1)
        greyLine.backgroundColor = kLineColor
        
        wrapContentLayout.addSubview(greyLine)
        
        
        return wrapContentLayout
    }
    
    
    //生成横线
    internal func addLineLayout(tag:Int) -> TGLinearLayout{
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tag = tag
        wrapContentLayout.addSubview(self.addLineView())
        
        return wrapContentLayout
    }
    
    
    //点赞和评论的水平模块,从10000生成到20000
    internal func addZanAndCommentContentLayOut(tableDataArr:[CQWorkMateCircleModel],userArr:[JSON],newName:String) -> TGLinearLayout{
        let wrapContentLayout = TGLinearLayout(.horz)//横
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tg_left.equal(AutoGetWidth(width: 63))
        wrapContentLayout.backgroundColor = UIColor.colorWithHexString(hex: "#f2f6fc")
        wrapContentLayout.tag = 2018
        
        let actionLayout = TGLinearLayout(.vert)//竖直
        actionLayout.tg_width.equal(.wrap)
        actionLayout.tg_height.equal(.wrap)
        actionLayout.isUserInteractionEnabled = true
        actionLayout.tag = 19920121
        wrapContentLayout.addSubview(actionLayout)
        
        var name = ""
        for i in 0..<userArr.count{
            if 0 == i{
                name = userArr[0].stringValue
            }else{
                name = name + "," + userArr[i].stringValue
            }
        }
        if userArr.count > 0{
            actionLayout.addSubview(self.addZanPeopleLayout(tag: 91211, name: name))
           // actionLayout.addSubview(self.addZanLineLayout(tag: 111, name: ""))
        }
        
        if !newName.isEmpty{
            actionLayout.addSubview(self.addZanPeopleLayout(tag: 91211, name: newName))
           // actionLayout.addSubview(self.addZanLineLayout(tag: 111, name: ""))
        }
        if userArr.count == 0 || tableDataArr.count == 0{
            
        }else{
             actionLayout.addSubview(self.addZanLineLayout(tag: 111, name: ""))
        }
        
        for i in 0..<tableDataArr.count{
            actionLayout.tg_padding = UIEdgeInsets(top: 0,left: 0,bottom: 7,right: 0)
           // actionLayout.tg_vspace = 5
            actionLayout.addSubview(self.addCommentLayout(tag: 400000 + i, commentName: tableDataArr[i].commentUserFrom, answerName: tableDataArr[i].commentUserTo, commentConttent: tableDataArr[i].commentContent,dataArray:tableDataArr[i]))
        }
        
        return wrapContentLayout
    }
    
}

// MARK:基础控件
extension CQFriendCircleVC{
    
    @objc internal func addIconImageView(image:String,tag:Int) -> UIImageView {
        
        let img = UIImageView.init()
        img.tg_top.equal(AutoGetHeight(height: 18))
        img.tg_left.equal(kLeftDis)
        img.tag = tag
        
        img.tg_width.equal(AutoGetWidth(width: 36))
        img.tg_height.equal(AutoGetWidth(width: 36))
        img.sd_setImage(with: URL(string:image), placeholderImage:UIImage.init(named: "personDefaultIcon"))
        img.layer.cornerRadius = AutoGetWidth(width: 18)
        img.clipsToBounds = true
        return img
    }
    
    @objc internal func addNameLab(title:String) -> UILabel {
        
        let nameLab = UILabel.init()
        nameLab.tg_top.equal(-AutoGetHeight(height: 33.5))
        nameLab.tg_left.equal( AutoGetWidth(width: 63))
        nameLab.tg_width.equal(kWidth - AutoGetWidth(width: 78))
        nameLab.tg_height.equal(AutoGetHeight(height: 16))
        nameLab.text = title
        nameLab.textColor = UIColor.black
        nameLab.textAlignment = .left
        nameLab.font = kFontSize16
        return nameLab
    }
    
    @objc internal func addTimeLab(time:String) -> UILabel {
        
        let timeLab = UILabel.init()
        timeLab.tg_top.equal(-AutoGetHeight(height: 13))
        timeLab.tg_left.equal(AutoGetWidth(width: 63))
        timeLab.tg_width.equal(kWidth - AutoGetWidth(width: 78))
        timeLab.tg_height.equal(AutoGetHeight(height: 11))
        timeLab.text = time
        timeLab.textColor = kLyGrayColor
        timeLab.textAlignment = .left
        timeLab.font = kFontSize11
        return timeLab
    }
    
    @objc internal func addContentLab(content:String) -> UILabel {
        
        let contentLab = UILabel.init()
        contentLab.tg_top.equal(AutoGetHeight(height: 15))
        contentLab.tg_left.equal(AutoGetWidth(width: 63))
        contentLab.tg_width.equal(kWidth - AutoGetWidth(width: 78))
        contentLab.tg_height.equal(.wrap)
        contentLab.text = content
        contentLab.textColor = UIColor.black
        contentLab.textAlignment = .left
        contentLab.font = kFontSize15
        return contentLab
    }
    
    //collectionView
     internal func addCollectionView(tag:Int,height:CGFloat,collectDataArr:[JSON]) -> UICollectionView {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.minimumLineSpacing = AutoGetWidth(width: 5)
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        if 1 == collectDataArr.count{
            layOut.itemSize = CGSize.init(width:AutoGetWidth(width: 180), height:AutoGetWidth(width: 180))
        }else {
            layOut.itemSize = CGSize.init(width:AutoGetWidth(width: 79), height:AutoGetWidth(width: 79))
        }
        
        let collectionView = CQFriendCollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth - AutoGetWidth(width: 78), height:height), collectionViewLayout: layOut)
        collectionView.tg_left.equal(AutoGetWidth(width: 63))
        if 4 == collectDataArr.count {
            collectionView.sd_width = AutoGetWidth(width: 163)
            collectionView.tg_width.equal( AutoGetWidth(width: 163))
        }else if 1 == collectDataArr.count{
            collectionView.sd_width = AutoGetWidth(width: 180)
            collectionView.tg_width.equal( AutoGetWidth(width: 180))
        }else{
            collectionView.sd_width = AutoGetWidth(width: 247)
            collectionView.tg_width.equal(AutoGetWidth(width: 247))
        }
        collectionView.tg_height.equal(.wrap )
        collectionView.tg_top.equal(AutoGetHeight(height: 13))
        collectionView.tag = tag
        collectionView.collectDataArray = collectDataArr
        collectionView.selectItemDelegate = self
        
        return collectionView
    }
    
    //评论按钮
    @objc internal func addCommentBtn(tag:Int) -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "CQWorkCircleComment"), for: .normal)
        btn.tg_height.equal(AutoGetHeight(height: 31))
        btn.tg_width.equal(AutoGetWidth(width: 56.5))
        btn.tg_left.equal(kWidth - AutoGetWidth(width: 126))
        btn.addTarget(self, action: #selector(commentAction(_:)), for: .touchUpInside)
        btn.tag = tag
        return btn
    }
    
    //赞按钮
    @objc internal func addZanBtn(tag:Int,laudStatus:Bool) -> UIButton {
        let btn = UIButton.init(type: .custom)
        if laudStatus{
            btn.setImage(UIImage.init(named: "CQWorkCircleZan"), for: .normal)
        }else{
            btn.setImage(UIImage.init(named: "CQWorkCircleCancelZan"), for: .normal)
        }
        
        btn.tg_height.equal(AutoGetHeight(height: 31))
        btn.tg_width.equal(AutoGetWidth(width: 56.5))
        btn.tg_left.equal(AutoGetWidth(width: 0))
        btn.tg_top.equal(AutoGetHeight(height: 0))
        btn.isUserInteractionEnabled = true
        btn.addTarget(self, action: #selector(zanAction(sender:)), for: .touchUpInside)
        btn.tag = tag
        return btn
    }
    
    //评论table
   internal func addCommentTableView(tag:Int,tableDataArray:[CQWorkMateCircleModel],height:CGFloat,userArr:[JSON]) -> UITableView {
        let table = CQFriendCircleTable.init(frame: CGRect.init(x: 0, y: 0, width:kWidth - AutoGetWidth(width: 78) , height:height ), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        table.tg_height.equal(height)
        table.tg_width.equal(kWidth - AutoGetWidth(width: 78))
        table.tg_left.equal(AutoGetWidth(width: 63))
        table.tg_top.equal(0)
        table.dataArray = tableDataArray
        table.tag = tag
        table.commentDelegate = self
        table.laudUserArray = userArr
        return table
    }
    
    //横线
    @objc internal func addLineView() -> UIView {
        
        let line = UIView.init()
        line.tg_top.equal(AutoGetHeight(height: 18))
        line.tg_left.equal(0)
        line.tg_width.equal(kWidth)
        line.tg_height.equal(0.5)
        line.backgroundColor = kLineColor
        return line
    }
    
    //赞图
    @objc internal func addZanImageView() -> UIImageView {
        
        let img = UIImageView.init()
        img.tg_top.equal(AutoGetHeight(height: 6))
        img.tg_left.equal(AutoGetWidth(width: 13))
        
        img.tg_width.equal(AutoGetWidth(width: 12.5))
        img.tg_height.equal(AutoGetWidth(width: 11))
        img.image = UIImage.init(named: "CQWorkMateCircleHasZan")
        return img
    }
    
    //点赞人
    @objc internal func addZanPeopleLab(name:String) -> UILabel {
        
        let lab = UILabel.init()
        lab.tg_top.equal(AutoGetHeight(height: 3))
        lab.tg_left.equal(AutoGetWidth(width: 4))
        lab.tg_height.equal(.wrap)
        lab.tg_width.equal(kWidth - AutoGetWidth(width: 106.5))
        lab.font = kFontSize14
        lab.tag = 198112
        lab.textColor = UIColor.colorWithHexString(hex: "#1e5f91")
        lab.textAlignment = .left
        lab.text = " " + name
        return lab
    }
    
    //评论
    @objc internal func addCommentLab(commentName:String,answerName:String,commentConttent:String,dataArray:CQWorkMateCircleModel,labTag:Int) -> UILabel {
        
        let lab = UILabel.init()
       // lab.tg_top.equal(AutoGetHeight(height: 6))
       // lab.tg_bottom.equal(-AutoGetHeight(height: 6))

        lab.tg_left.equal(AutoGetWidth(width: 8))
        lab.tg_height.equal(.wrap)
        lab.tg_width.equal(kWidth - AutoGetWidth(width: 81))
        lab.tag = labTag
        lab.font = kFontSize14
        lab.textColor = UIColor.black
        if answerName.isEmpty{
            let string = commentName + ":" + commentConttent
            let ranStr = commentName + ":"
            let attrstring:NSMutableAttributedString = NSMutableAttributedString.init(string: string)
            let str = NSString.init(string: string)
            let theRange = str.range(of: ranStr)
            attrstring.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.colorWithHexString(hex: "#1e5f91"), range: theRange)
            lab.attributedText = attrstring
        }else{
            let string = commentName + "回复"  + answerName + ":" + commentConttent
            let ranStr = commentName
            let attrstring:NSMutableAttributedString = NSMutableAttributedString.init(string: string)
            let str = NSString.init(string: string)
            
            let theRange = str.range(of: ranStr)
            
            let subRanStr = answerName + ":"
            let subRange = str.range(of: subRanStr)
            
            attrstring.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.colorWithHexString(hex: "#1e5f91"), range: theRange)
            attrstring.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.colorWithHexString(hex: "#1e5f91"), range: subRange)
            lab.attributedText = attrstring
        }
        lab.textAlignment = .left
        lab.isUserInteractionEnabled = true
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 0, y: 0, width: kWidth - AutoGetWidth(width: 81), height: AutoGetHeight(height: 18))

        btn.addTarget(self, action: #selector(tapClick(sender:)), for: .touchUpInside)
        lab.addSubview(btn)
        
        return lab
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

//按钮点击事件
//MARK: - Handle Method
extension CQFriendCircleVC
{
    @objc internal func tapClick(sender :UIButton)
    {
        let tapTag:Int = (sender.superview?.tag)!
        DLog(tapTag)
        let underTag = (sender.superview?.superview?.superview?.superview?.superview?.superview?.tag)! - 10000
        DLog(underTag)
        let model = self.dataArray[underTag]
        self.currentCount = underTag
        let arr = model.commentData
        DLog(arr)
        let subModel = CQWorkMateCircleModel.init(jsonData: arr[tapTag])
        DLog(subModel?.circleCommentId)
//        SVProgressHUD.showInfo(withStatus: "正在开发中")
        DLog(sender.superview?.superview?.superview)
        self.view.addSubview(self.TextView())
        self.TextView().textView.becomeFirstResponder()
        self.ewenTextView.ewenTextViewBlock = {(test) -> Void in
            /*输入的内容在上方显示*/

            self.childCommentRequest(uId: (subModel?.circleCommentId)!, text: test!)
            sender.superview?.superview?.superview?.addSubview(self.addCommentLayout(tag: tapTag + 1  , commentName: STUserTool.account().realName, answerName: (subModel?.commentUserFrom)!, commentConttent: test!, dataArray: subModel!))
            
            /*移除*/
            self.TextView().resignFirstResponder()
            self.TextView().removeFromSuperview()
            
        }
            
       
    }
    
    
    
    
    @objc internal func zanAction(sender :UIButton)
    {
        let i = sender.tag - 30000
        let model = self.dataArray[i]
        
       
        self.zanRequest(model: model,index: i,sender:sender)
        
    }
    
    @objc internal func commentAction(_ sender :UIButton)
    {
        let i = sender.tag - 20000
        let model = self.dataArray[i]
        self.currentCount = i
        self.view.addSubview(self.TextView())
        self.TextView().textView.becomeFirstResponder()
        self.ewenTextView.ewenTextViewBlock = {(test) -> Void in
            /*输入的内容在上方显示*/
            //                self.noticeTop(test)
            self.commentRequest(model: model, text: test!)
            
            for v in (sender.superview?.superview?.superview?.subviews)!{
                for sub in v.subviews {

                    if 2018 == sub.tag{
                        for sv in sub.subviews{
                            if 19920121 == sv.tag{
                                let count = sv.subviews.count
                                for i in 0..<count{
                                    if (count - 1) == i {
                                        let lastV = sv.subviews[i]
                                        let tag = lastV.tag
                                        DLog(tag)
                                        sv.addSubview(self.addCommentLayout(tag: tag + 1  , commentName: STUserTool.account().realName, answerName: "", commentConttent: test!, dataArray: model))
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
            
            /*移除*/
            self.TextView().resignFirstResponder()
            self.TextView().removeFromSuperview()
        }
    }
    
    /*输入框方法*/
    func TextView() -> EwenTextView {
        if (ewenTextView == nil) {
            self.ewenTextView = EwenTextView.init(frame: CGRect.init(x: 0, y: kHeight - 49, width: kWidth, height: 49))
            self.ewenTextView.backgroundColor = UIColor(white: 0, alpha: 0.3)
            self.ewenTextView.setPlaceholderText("请输入文字")
            
        }
        return ewenTextView
    }
}

extension CQFriendCircleVC:CQFriendCircleCommentDelegate{
    func commentForCellClick(uId: String, tag: Int) {
        
        self.view.addSubview(self.TextView())
        self.TextView().textView.becomeFirstResponder()
        self.ewenTextView.ewenTextViewBlock = {(test) -> Void in
            /*输入的内容在上方显示*/
            //                self.noticeTop(test)
            self.childCommentRequest(uId: uId, text: test!)
            /*移除*/
            self.TextView().resignFirstResponder()
            self.TextView().removeFromSuperview()
        }
        
    }
}

extension CQFriendCircleVC:CQFriendCircleImageSelectDelegate{
    func pushToImagePreView(images: [String], index: Int) {
        //进入图片全屏展示
        let previewVC = ImagePreViewVC(images: images, index: index)
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
}

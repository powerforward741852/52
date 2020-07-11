//
//  QRGengZongListVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/13.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRGengZongListVC: SuperVC {
    
    //声明闭包
    typealias clickBtnClosure = (_ reflash: String?) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    
    //跟进记录iD
    var followRecordId = ""
    //currentPage
    var currentPage = 1
    //每页多少行
    var rows = 1
    
    var businessid = ""
    
    var customID = ""
    //跟踪记录数组
    var genzongArr = [QRGenZongListModel]()
    //
    var headModel : QRHeadEvaluateModel?
    //内容
    var contens = ""
    
    
    lazy var headListView :UIView = {
        let big = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 22)))
        big.backgroundColor = UIColor.white
        big.addSubview(headTitle)
        
        let white = UIView(frame:  CGRect(x: 0, y: -7, width: kWidth, height: 7))
        white.backgroundColor = UIColor.white
        big.addSubview(white)
        return big
    }()
    
    lazy var headTitle :UILabel = {
        let title = UILabel(title: "评论", textColor: UIColor.black, fontSize: 16, alignment: .left, numberOfLines: 1)
        title.frame =  CGRect(x: kLeftDis, y: 0, width: 100, height:
            AutoGetHeight(height: 22))
        return title
    }()
    
    fileprivate var popover: Popover!
    fileprivate var popoverOptions: [PopoverOption] = [
         // .type(.auto),
        .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
    ]
    
    
    static let CellIdentifier = "evaluateID"
    static let CellIdentifier2 = "evaluateID2"
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.grouped)
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
        table.backgroundColor = kProjectBgColor
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.register(QREvaluateCell.self, forCellReuseIdentifier:QRGengZongListVC.CellIdentifier )
        table.register(QRheadEvaluateCell.self, forCellReuseIdentifier: QRGengZongListVC.CellIdentifier2)
        table.separatorStyle = UITableViewCellSeparatorStyle.none
      
        table.allowsSelection = false
        table.estimatedRowHeight = 200
        table.rowHeight = UITableViewAutomaticDimension
        return table
    }()
    
    //添加输入框
    lazy var keyboard : UIView = {
        let but = UIView(frame:  CGRect(x: 0, y: kHeight-49, width: kWidth, height: 49))
        but.backgroundColor = kProjectBgColor
        but.addSubview(textView!)
        but.addSubview(sendBut)
        return but
    }()
    
    lazy var sendBut : UIButton = {
        let but = UIButton(frame: CGRect(x:kWidth-90-10 , y: 5, width: 90, height: 39))
        but.setTitle("确定", for: .normal)
        but.setTitleColor(UIColor.white, for: .normal)
        but.backgroundColor = kColorRGB(r: 0, g: 142, b: 254)
        but.addTarget(self, action: #selector(sendMessage), for: UIControlEvents.touchUpInside)
        return but
    }()
    lazy var placeHolder :UILabel? = {
        let lab = UILabel(title: "请输入评论", textColor: klightGreyColor, fontSize: 15)
        lab.frame =  CGRect(x: 10, y: 5, width: 100, height: 23)
        return lab
    }()
    
    lazy var titleLab :UILabel? = {

        let lab = UILabel(title: "    跟进记录", textColor: UIColor.black, fontSize: 16)
        lab.frame =  CGRect(x: 15, y: 5, width: 100, height: 23)
        return lab
    }()
    lazy var textView : UITextView? = {
       let vie = UITextView()
        vie.frame =  CGRect(x: 15, y: 8, width: kWidth-90-15, height: 33)
        vie.delegate = self
        vie.addSubview(placeHolder!)
        
        
        
        return vie
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         view.addSubview(table)
        title = "跟进记录详情"
        view.addSubview(keyboard)
        /// 键盘将要变化的通知
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChanged:", name: UIKeyboardWillChangeFrameNotification, object: nil)
//        UNUserNotificationCenter.addObserver(self, forKeyPath: "keyboardWillChanged:", options: UIKeyboardWillChangeFrameNotification, context: nil)
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: "addOrDeleteEmotion:", name: addOrDeleteEmotionNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(QRGengZongListVC.keyboardWillChanged(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        setUpRefresh()
        loadHeadData()
        loadGenJinListData(moreData: false)
        navigationItem.rightBarButtonItem = rightButtonWithImg(image: UIImage(named:"gd")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadHeadData()
    }
    
    @objc func sendMessage(){
        if self.contens == ""  {
            SVProgressHUD.showInfo(withStatus: "评论内容不能为空")
        }else{
             addNewEvaluates()
            self.textView?.resignFirstResponder()
            self.textView?.text = ""
            self.contens = ""
        }
       
    }
    func addNewEvaluates(){
       let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmCustomer/saveCrmComment", type: .post, param: ["userId":userID,"followRecordId":followRecordId,"content":contens], successCallBack: { (result) in
            
            if  result["success"].boolValue{
                SVProgressHUD.showInfo(withStatus: "发布评论成功")
                self.loadGenJinListData(moreData: false)
            }
        }) { (error) in
            
            SVProgressHUD.showInfo(withStatus: "发布评论失败")
        }
    }
    
    
    
    
    /// 键盘将要变化通知
    @objc private func keyboardWillChanged (notification: NSNotification) {
        print(notification.userInfo!)
//        //如果需要做动画
////        if shouldAnimation {
////        }
//        /// 获取键盘的originy
//        let keyboardOriginY = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.origin.y
//        // 获取键盘弹出或收起的动画时长
 //       let duration = 0.25
//        //计算toolBar的底部偏移量
  //      let offset = keyboardOriginY! - view.bounds.size.height
//        //更新布局
//        toolBar.snp_updateConstraints { (make) -> Void in
//            make.bottom.equalTo(view).offset(offset)
//        }
//        //执行动画
//        UIView.animateWithDuration(duration!) { () -> Void in
//            self.view.layoutIfNeeded()
//        }
    }
    
    
    
    
    
    func setUpRefresh() {
        // MARK:header
        let STHeader = CQRefreshHeader {[unowned self] in
            self.loadGenJinListData(moreData: false)
        }
        // MARK:footer
        let STFooter = CQRefreshFooter {[unowned self] in
            self.loadGenJinListData(moreData: true)
        }
        self.table.mj_header = STHeader
        self.table.mj_footer = STFooter
       
    }
    @objc override func rightItemClick() {
//        //编辑栏使用删除和编辑
//        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 80, height: 135))
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.isScrollEnabled = false
//        self.popover = Popover(options: self.popoverOptions)
//        self.popover.willShowHandler = {
//            print("willShowHandler")
//        }
//        self.popover.didShowHandler = {
//            print("didDismissHandler")
//        }
//        self.popover.willDismissHandler = {
//            print("willDismissHandler")
//        }
//        self.popover.didDismissHandler = {
//            print("didDismissHandler")
//        }
//        let startPoint = CGPoint(x: self.view.frame.width - 60, y: 55)
//        self.popover.show(tableView, point: startPoint)
        initSelectView()
    }
    
    
    func initSelectView()  {
        let selectView = QRPopoverSelectView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight))
        selectView.cqSelectDelegate = self
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.addSubview(selectView)
        
    }
    func loadHeadData()  {
        //crmCustomer/getCrmFollowRecordDetails
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmCustomer/getCrmFollowRecordDetails", type: .get, param: ["followRecordId":followRecordId], successCallBack: { (result) in
            
           let headModel = QRHeadEvaluateModel(jsonData: result["data"])
            self.headModel = headModel
            self.table.reloadData()
            
        }) { (error) in
            
            
        }
    }
    
    
 
    

    func loadGenJinListData(moreData:Bool) {
        if moreData {
            currentPage += 1
        } else {
            currentPage = 1
        }
        //  let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmCustomer/getCrmCommentByPage", type: .get, param:["followRecordId":followRecordId,
                                                                                                                       "currentPage":currentPage,
                                                                                                                       "rows":10], successCallBack: { (result) in
                                                                                                                       var temp = [QRGenZongListModel]()
                                                                                                                       for xx in result["data"].arrayValue{
                                                                                                                            let modal = QRGenZongListModel(jsonData: xx)
                                                                                                                            temp.append(modal!)                                                           }
                                                                                                                       if moreData {
                                                                                                                           self.genzongArr.append(contentsOf: temp)
                                                                                                                        } else {
                                                                                                                            self.genzongArr = temp
                                                                                                                        }
                                                                                                                        
                                                                                                                        //刷新表格
                                                                                                                        self.table.mj_header.endRefreshing()
                                                                                                                        self.table.mj_footer.endRefreshing()
                                                                                                                        self.table.reloadData()
                                                                                                                        //分页控制
                                                                                                                        let total = result["total"].intValue
                                                                                                                        if self.genzongArr.count == total {
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
    
    
    func deleGenZhongList()  {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmCustomer/deleteCrmFollowRecord", type: .post, param: ["followRecordId":followRecordId,
                                                                                                    "userId":userID], successCallBack: { (result) in
             
                                                                                                                    if   result["success"].boolValue{
                                                                                                                        SVProgressHUD.showInfo(withStatus: "删除成功")
                                                                                                                    }
                                                                                                        self.clickClosure!("yes")
               self.navigationController?.popViewController(animated: true)
                                                                                                                    
        }) { (error) in
            
            SVProgressHUD.showInfo(withStatus: "删除失败")
            
            
        }
    }
    
    
    //编辑
    
    
    
}


extension QRGengZongListVC:UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.textView?.resignFirstResponder() 
    }
}


extension QRGengZongListVC:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        self.contens = textView.text
        if contens.count>0 {
            placeHolder?.isHidden = true
        }else{
            placeHolder?.isHidden = false
        }
        
    }
    
}




extension QRGengZongListVC:UITableViewDelegate{
    
}

// Mark:添加按钮代理
extension QRGengZongListVC:QRPopoverSelectViewDelegate{
    func pushToDetailThroughType(btn: UIButton) {
        if 400 == btn.tag{
            //删除
            deleGenZhongList()
            
        }else if 401 == btn.tag{
           //编辑
            let genzong = QRAddGenJinVC()
            genzong.model = headModel
            genzong.businessId = businessid
            genzong.followRecordId = followRecordId
            genzong.customerId = customID
            genzong.clickClosure = {[unowned self] reflash in
                self.loadHeadData()
            }
            self.navigationController?.pushViewController(genzong, animated: true)
            
        }
    }
}



extension QRGengZongListVC:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }else{
           return  genzongArr.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell  = table.dequeueReusableCell(withIdentifier: QRGengZongListVC.CellIdentifier2, for: indexPath)as! QRheadEvaluateCell
            cell.model = headModel
            return cell
        }else{
            let cell  = table.dequeueReusableCell(withIdentifier: QRGengZongListVC.CellIdentifier, for: indexPath)as! QREvaluateCell
            cell.model = genzongArr[indexPath.row]
            return cell
        }
        
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            headTitle.text = "评论"+" \(genzongArr.count)"
            return headListView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1{
            return AutoGetHeight(height: 30)
        }
       
        return 0
    }
    
}

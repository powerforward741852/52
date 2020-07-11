//
//  QRDetailBusinessVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/11.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRDetailBusinessVC: SuperVC {
     static let CellIdentifier = "TrackID";
    
    
    //声明闭包
    typealias clickBtnClosure = (_ text:String ) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    
    
    //合同主键
    var contractid = ""
    //操作类型
    var opt = ""
    var genJinRenArr = [QRGenJinRenModel]()
    var genJinRenArr1 = [CQDepartMentUserListModel]()
    //跟踪列表
    var dataArr = [QRTrackModel]()
    //model
    var model : QRDetailBusinessMdel?
    //
    var editSuccess = false
    
    //跟进记录统计
    var followRecordCount = ""
    //本页
    var currentPage = 1
    //全部页
     var totalPage = 0
    //全部数量
    var total = 0
    //联系人主键
    var  linkPerson = ""
    
    //跟进人主键
    var followPerson = ""
    //可以操作?
    var isCanOperate = 1
    //重要
    var importance = ""
    //商机名
    var businessName = ""
    var businessType = ""
    var closeDate = ""
    //客户主键
    var crmCustomer = ""
    //商机id
    var entityId = ""
    
    var estimatedAmount = ""
    //销售阶段
    var saleStageVar = ""
    
    
    
    //添加跟进按钮
    lazy var genjinBUT : UIButton = {
       let but = UIButton(frame:  CGRect(x: 0, y: kHeight-AutoGetHeight(height: 49)  - CGFloat(SafeAreaBottomHeight), width: kWidth, height: AutoGetHeight(height: 49)))
        but.setTitle("添加跟进记录+", for: UIControlState.normal)
        but.backgroundColor = UIColor.white
        but.setTitleColor(kColorRGB(r: 51, g: 154, b: 253), for: UIControlState.normal)
        but.addTarget(self, action: #selector(addGenJin), for: UIControlEvents.touchUpInside)
        return but
    }()
    
    lazy var bigView :UIView = {
        let big = UIView(frame: CGRect(x: kLeftDis, y: kLeftDis, width: kHaveLeftWidth, height: AutoGetHeight(height: 160)))
//        big.layer.borderColor = kColorRGB(r: 225, g: 225, b: 225).cgColor
//        big.layer.cornerRadius = 6
//        big.clipsToBounds = true
        let img = UIImage(named: "checkOutBg")
        big.layer.contents = img?.cgImage
        
      //  big.layer.borderWidth = 1.2
        big.addSubview(titleName)
        big.addSubview(jinger)
        big.addSubview(end)
        big.addSubview(yang)
        big.addSubview(money)
        big.addSubview(jiantou)
        big.addSubview(endTime)
        big.addSubview(contractBut)
        big.addSubview(lianxiren)
        big.addSubview(saleStage)
        big.addSubview(redImage)
        
        
        return big
    }()
    lazy var titleName :UILabel = {
        let big = UILabel(title: "       ", textColor: UIColor.black, fontSize: 18)
        return big
    }()
    lazy var jinger :UILabel = {
        let big = UILabel(title: "商机金额:", textColor: klightGreyColor, fontSize: 15)
        return big
    }()
    lazy var end :UILabel = {
        let big = UILabel(title: "预计结单时间:", textColor: klightGreyColor, fontSize: 15)
        return big
    }()
    
    lazy var yang :UILabel = {
        let big = UILabel(title: "￥", textColor: korgColor, fontSize: 15)
        big.font = kFontBoldSize17
        return big
    }()
    lazy var money :UILabel = {
        let big = UILabel(title: "   ", textColor: korgColor, fontSize: 15)
        return big
    }()
    lazy var endTime :UILabel = {
        let big = UILabel(title: "2018-01-02", textColor: klightGreyColor, fontSize: 15)
        return big
    }()
    
    lazy var contractBut :UIButton = {
        let big = UIButton(title: "合同")
        big.setBackgroundImage(imageWithColor(color: klightBlueColor, size: CGSize(width: 60, height: 30)), for: .normal)
        big.addTarget(self, action: #selector(JumpContract), for: UIControlEvents.touchUpInside)
        big.setTitleColor(kColorRGB(r: 18, g: 159, b: 252), for: .normal)
        big.layer.cornerRadius  = 5
        big.clipsToBounds = true
        return big
    }()
    lazy var lianxiren :UIButton = {
        let big = UIButton(title:"联系人")
        big.setBackgroundImage(imageWithColor(color: klightBlueColor, size: CGSize(width: 60, height: 30)), for: .normal)
        big.setTitleColor(kColorRGB(r: 18, g: 159, b: 252), for: .normal)
        big.layer.cornerRadius  = 5
        big.clipsToBounds = true
        big.addTarget(self, action: #selector(Jumplianxiren), for: UIControlEvents.touchUpInside)
        return big
    }()
    
    //红点
    let redImage : UIImageView = {
        let image = imageWithColor(color: kredColor, size: CGSize(width: 8, height: 8))
        let red = UIImageView(image: image)
        red.layer.cornerRadius = 4
        red.clipsToBounds = true
        return red
    }()
    
    lazy var saleStage :UIButton = {
        let big = UIButton()
        big.setTitle("审核谈判80%", for: UIControlState.normal)
        big.titleLabel?.font = kFontSize15
        big.addTarget(self, action: #selector(changgeSaleStage), for:.touchUpInside)
        big.setTitleColor( kColorRGB(r: 44, g: 160, b: 255), for: .normal)
        return big
    }()
    lazy var jiantou :UIImageView = {
        let big = UIImageView(image: UIImage(named:"roomClose"))
        return big
    }()
    lazy var genjinren : UILabel = {
        let big = UILabel(title: "跟进人", textColor:UIColor.black , fontSize: 15)
        
        return big
    }()
    lazy var namesLab : UILabel = {
        let big = UILabel(title: "     ", textColor:klightGreyColor , fontSize: 15)
        big.textAlignment = NSTextAlignment.right
        big.numberOfLines = 0
        return big
    }()
    lazy var jiantou2 :UIImageView = {
        let big = UIImageView(image: UIImage(named:"roomClose"))
        return big
    }()
    lazy var big2 :UIView = {
         let big = UIView(frame: CGRect(x: 0, y: bigView.bottom, width: kWidth, height: AutoGetHeight(height: 55)))
        big.addSubview(genjinren)
        big.addSubview(namesLab)
        big.addSubview(jiantou2)
        let ges = UITapGestureRecognizer(target: self, action: #selector(genJingRen))
        big.addGestureRecognizer(ges)
        return big
    }()
    
    lazy var headView :UIView = {
        let head = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 230)))
        head.backgroundColor = UIColor.white
        head.addSubview(big2)
        head.addSubview(bigView)
        
        return head
    }()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight-AutoGetHeight(height: 40) - CGFloat(SafeAreaBottomHeight)), style: UITableViewStyle.grouped)
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
            table.contentInset = UIEdgeInsetsMake(CGFloat(SafeAreaTopHeight), 0, CGFloat(SafeAreaBottomHeight), 0);
            table.scrollIndicatorInsets = table.contentInset;
            
        } else {
            //低于 iOS 9.0
        }
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = kProjectBgColor
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.register(QRTrackerCell.self, forCellReuseIdentifier:QRDetailBusinessVC.CellIdentifier )
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.allowsSelection = false
        table.estimatedRowHeight = 200
        table.rowHeight = UITableViewAutomaticDimension
        return table
    }()
    
    lazy var headTitle :UILabel = {
        let title = UILabel(title: "跟进记录", textColor: UIColor.black, fontSize: 16, alignment: .left, numberOfLines: 1)
        title.frame =  CGRect(x: kLeftDis, y: AutoGetHeight(height: 8), width: 100, height: AutoGetHeight(height: 40))
        return title
    }()
    
    lazy var headListView :UIView = {
        let big = UIView(frame: CGRect(x: 0, y: AutoGetHeight(height: 8), width: kWidth, height: AutoGetHeight(height: 40)))
        
        let grey = UIView(frame:  CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 8)))
        grey.backgroundColor = kProjectBgColor
        big.addSubview(grey)
        big.backgroundColor = UIColor.white
        big.addSubview(headTitle)
        
        return big
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "商机详情"
        view.addSubview(table)
        view.addSubview(genjinBUT)
        table.tableHeaderView = headView
        navigationItem.rightBarButtonItem = rightButtonWithImg(image: UIImage(named:"gd")!)
        
       setUpRefresh()
        //添加通知观察者
        NotificationCenter.default.addObserver(self, selector: #selector(updateImages(notification:)), name: NSNotification.Name(rawValue: "imagsCellID"), object: nil)
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
        loadData()
        setupUI()
        setUpui()
        
    }
    
    
    func initSelectView()  {
        let selectView = QRPopoverSelectView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight))
        selectView.cqSelectDelegate = self
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.addSubview(selectView)
        
    }
    @objc override func rightItemClick() {
        initSelectView()
    }
    
    
    func deleBusiness()  {
        self.loadingPlay()
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmBusiness/operateCrmBusiness", type: .post, param: ["emyeId":userID,
                                                                                                                   "entityId":entityId,"opt":"delete"], successCallBack: { (result) in

                                                                                                                    self.loadingSuccess();                                                  if   result["success"].boolValue{
                                                                                                                                                                               SVProgressHUD.showInfo(withStatus: "删除成功")
                                                                                                                    }
                                                                                                                    self.clickClosure!("yes");                                                      self.navigationController?.popViewController(animated: true)

        }) { (error) in
                self.loadingSuccess()
            SVProgressHUD.showInfo(withStatus: "删除失败")


        }
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
        self.table.mj_header.beginRefreshing()
    }
    func loadData()  {
        
        
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/crmBusiness/operateCrmBusiness" ,
            type: .post,
            param: ["emyeId":userID,
                    "opt":"info",
                    "entityId":entityId],
            successCallBack: { (result) in
                let modal = QRDetailBusinessMdel(jsonData: result["data"])
                self.model = modal
                
                self.titleName.text = modal?.businessName
                self.saleStage.setTitle(modal?.salesStage, for: .normal)
                self.money.text = self.model?.estimatedAmount
                self.endTime.text = modal?.closeDate
                if  let xx =  modal?.contractCount ,xx > 0 {
                    self.contractBut.setTitle("合同\(xx)", for: .normal)
                    
                }else{

                }
                if  let xx = modal?.linkmanCount, xx > 0 {
                    self.lianxiren.setTitle("联系人\(xx)", for: .normal)
                }else{
                    self.lianxiren.isEnabled = false
                }
                //跟进人id
                self.followPerson = result["data"]["followPerson"].stringValue
                let followIDS = result["data"]["followPerson"].stringValue.components(separatedBy: ",")
              // print(followIDS)
                //跟进人数据遍历
                   var temp = [QRGenJinRenModel]()
                   var temp1 = [CQDepartMentUserListModel]()
                    var str = ""
                for (index,xx) in result["data"]["followPersonList"].arrayValue.enumerated(){
                   let modal = QRGenJinRenModel(jsonData :xx)
                    modal?.followEmployeeId = followIDS[index]
                    temp.append(modal!)
                    if let xx = modal?.followEmployeeName{
                        str = str + "\(xx)、"
                    }
                    
                    let mod1 =  CQDepartMentUserListModel.init(uId: followIDS[index], realN: xx["followEmployeeName"].stringValue, headImag: xx["followEmployeeHeadImage"].stringValue)
                    temp1.append(mod1)
                    
                }
                if str.last == "、"{
                    str.removeLast()
                }
                self.namesLab.text = str
                let height = getTextHeight(text: str, font: self.namesLab.font, width: kWidth-AutoGetWidth(width: 110))
                //重设big2的frame//重设head的frame
                self.big2.frame = CGRect(x: 0, y: self.bigView.bottom, width: kWidth, height: AutoGetHeight(height: height + 30))
                self.headView.frame = CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 175 ) + AutoGetHeight(height: height + 30))
                self.table.tableHeaderView = self.headView
                
                self.genJinRenArr = temp
                self.genJinRenArr1 = temp1
                self.linkPerson = result["data"]["linkPerson"].stringValue
                self.crmCustomer = result["data"]["crmCustomer"].stringValue
                
                
                
                if result["data"]["importance"].intValue == 1{
                    self.redImage.isHidden = true
                }else{
                    self.redImage.isHidden = false
                }
                
                if result["data"]["isCanOperate"].boolValue {
                    print(result["data"]["isCanOperate"].boolValue)
                   self.navigationItem.rightBarButtonItem?.isEnabled = true
                }else{
                    
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                }
                
                //合同id
                self.contractid = result["data"]["entityId"].stringValue
                //商机名
                self.businessName = result["data"]["businessName"].stringValue
                self.businessType = result["data"]["businessType"].stringValue
                self.closeDate = result["data"]["closeDate"].stringValue
                self.crmCustomer = result["data"]["crmCustomer"].stringValue
                //商机id
                self.entityId = result["data"]["entityId"].stringValue
                self.estimatedAmount = result["data"]["estimatedAmount"].stringValue
                //销售阶段
                self.saleStageVar = result["data"]["salesStage"].stringValue
                
                
                
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
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmBusiness/getCrmBusinessFollowRecords", type: .get, param:["businessId":entityId,
                                                                                                                       "currentPage":currentPage,
                                                                                                                       "pageSize":10], successCallBack: { (result) in
                                                                                                                        var temp = [QRTrackModel]()
                                                                                                                        for xx in result["data"]["followRecords"].arrayValue{
                                                             let modal = QRTrackModel(jsonData: xx)
                                                                                                                            temp.append(modal!)                                                           }
                                                                                                                        if moreData {
                                                                                                                            self.dataArr.append(contentsOf: temp)
                                                                                                                        } else {
                                                                                                                            self.dataArr = temp
                                                                                                                        }
                                                                                                                        //刷新表格
                                                                                                                        self.table.mj_header.endRefreshing()
                                                                                                                        self.table.mj_footer.endRefreshing()
                                                                                                                        self.table.reloadData()
                                                                                                                        //分页控制
                                                                                                                        let total = result["total"].intValue
                                                                                                                        if self.dataArr.count == total {
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
    //MARK:-编辑商机
    func loadEdite()  {
      //  businessName businessType  closeDate crmCustomer  entityId  estimatedAmount  opt  salesStage
        self.loadingPlay()
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmBusiness/operateCrmBusiness", type: .post, param: ["businessName":businessName,
                                                                                                                "businessType":businessType,
                                                                                                                "closeDate":closeDate,"crmCustomer":crmCustomer,"entityId":entityId,"estimatedAmount":estimatedAmount,"salesStage":saleStageVar,"opt":"editSalesStage","emyeId":userID], successCallBack: { (result) in
              
                                                                                                                    self.loadingSuccess();                                                  if   result["success"].boolValue{
                                                                                                                        SVProgressHUD.showInfo(withStatus: "编辑成功")
                                                        
                                                                                                                        self.saleStage.setTitle(self.saleStageVar, for: .normal)
                                                                                                                    }
                                                                                                                    
                                                                                                                    
                                                                                                                    
        }) { (error) in
            self.loadingSuccess()
            SVProgressHUD.showInfo(withStatus: "编辑失败")
        }
        
        
        
    }
    
    
    
    //MARK:-布局
    func setupUI()  {
        genjinren.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(kLeftDis)
            make?.centerY.mas_equalTo()(big2)
            make?.width.mas_equalTo()(AutoGetWidth(width: 55))
        }
        jiantou2.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(-kLeftDis)
            make?.centerY.mas_equalTo()(big2)
            make?.width.mas_equalTo()(10)
        }
        namesLab.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(jiantou2.mas_left)?.setOffset(-AutoGetWidth(width: 5))
            make?.left.mas_equalTo()(genjinren.mas_right)?.setOffset(AutoGetWidth(width: 10))
            make?.centerY.mas_equalTo()(big2)
        }
        
    }
    
    func setUpui(){
        
        titleName.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(kLeftDis)
            make?.top.mas_equalTo()(kLeftDis)
        }
        jinger.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(titleName)
            make?.top.mas_equalTo()(titleName.mas_bottom)?.setOffset(AutoGetWidth(width: 10))
        }
        yang.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(jinger.mas_right)
            make?.centerY.mas_equalTo()(jinger.mas_centerY)
        }
        money.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(yang.mas_right)
            make?.centerY.mas_equalTo()(jinger.mas_centerY)
        }
        end.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(jinger)
            make?.top.mas_equalTo()(jinger.mas_bottom)?.setOffset(AutoGetHeight(height: 10))
        }
        endTime.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(end.mas_right)
            make?.centerY.mas_equalTo()(end.mas_centerY)
        }
        contractBut.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(end)
            make?.top.mas_equalTo()(end.mas_bottom)?.setOffset(AutoGetHeight(height: 10))
        }
        lianxiren.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contractBut.mas_right)?.setOffset(AutoGetHeight(height: 10))
            make?.centerY.mas_equalTo()(contractBut.mas_centerY)
        }
        jiantou.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(-AutoGetWidth(width: 13))
            make?.top.mas_equalTo()(AutoGetHeight(height: 15))
        }
        saleStage.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(jiantou.mas_left)?.setOffset(-AutoGetWidth(width: 5))
            make?.centerY.mas_equalTo()(jiantou)
            make?.height.mas_equalTo()(AutoGetHeight(height: 15))
        }
        

        redImage.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(saleStage.mas_left)?.setOffset(-AutoGetWidth(width: 10))
            make?.centerY.mas_equalTo()(saleStage)
        }
        
    }
    
}
extension QRDetailBusinessVC:UITableViewDelegate{
    
}
extension QRDetailBusinessVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = QRTrackerCell.init(style: UITableViewCellStyle.default, reuseIdentifier: QRDetailBusinessVC.CellIdentifier)
        cell.rootVc = self
        cell.model = dataArr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return AutoGetHeight(height: 48)
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            headTitle.text = "跟进记录"+" \(dataArr.count)"
            return headListView
        }
        return nil
    }
    
}

extension QRDetailBusinessVC{
    @objc func Jumplianxiren(){
        let lianxiWeb = QRCustomWebVC()
        //传入客户id
        lianxiWeb.customerId = self.crmCustomer
        lianxiWeb.businessModel = self.model
       // lianxiWeb.customer = self.c
        //lianxiWeb.type = 1
        print(self.crmCustomer)
        self.navigationController?.pushViewController(lianxiWeb, animated: true)
    }
    @objc func JumpContract(){
         let contract = QRContractVC()
        //合同id
        contract.businessId = entityId
       self.navigationController?.pushViewController(contract, animated: true)
    }
    
    @objc func changgeSaleStage(){
        //改变销售状态<<弹窗
        let items = ["初步接洽(10%)", "确定需求(30%)","方案/报价(60%)","谈判审核(80%)","完成(100%)"]
        let vProperty = FWSheetViewProperty()
        vProperty.touchWildToHide = "1"
        let sheetView = FWSheetView.sheet(title:"", itemTitles: items, itemBlock: { [unowned self] (popupView, index, title) in
           // print("Sheet：点击了第\(index)个按钮")
            //编辑商机
            if index == 0{
                self.saleStageVar = items[index]
            }else if index == 1{
                self.saleStageVar = items[index]
            }else if index == 2{
                self.saleStageVar = items[index]
            }else if index == 3{
                self.saleStageVar = items[index]
            }else if index == 4{
                self.saleStageVar = items[index]
            }else if index == 5{
                self.saleStageVar = items[index]
            }
            
            self.loadEdite()
           
            
        }, cancenlBlock: {
            print("点击了取消")
        }, property: vProperty)
        sheetView.show()
        
        
        
        
    }
    
    //编辑跟进人
    @objc func genJingRen(){
        let genjin = QRAddTrackBusinessVC()
        genjin.TrackArray = genJinRenArr1
        genjin.businessDetailModel = model
        genjin.clickClosure = {[unowned self] a,b in
            self.genJinRenArr1 = a
            //self.namesLab.text = b
        }
        self.navigationController?.pushViewController(genjin, animated: true)
    }
    
   @objc func addGenJin() {
        let genjin = QRAddGenJinVC()
        genjin.businessId = entityId
        genjin.type = "2"
    genjin.clickClosure = {[unowned self] reflash in
        self.table.mj_header.beginRefreshing()
    }
        self.navigationController?.pushViewController(genjin, animated: true)
    }
}

// Mark:添加按钮代理
extension QRDetailBusinessVC:QRPopoverSelectViewDelegate{
    func pushToDetailThroughType(btn: UIButton) {
        if 400 == btn.tag{
            //删除
         deleBusiness()
            
        }else if 401 == btn.tag{
            //编辑
            let bus = QRAddBusinessVC()
            bus.detailModel = self.model!
            bus.opt = "edit"
            bus.clickClosure = {[unowned self] x in
                 self.table.mj_header.beginRefreshing()
            }
            //编辑商机
            self.navigationController?.pushViewController(bus, animated: true)
            
            
        }
    }
}

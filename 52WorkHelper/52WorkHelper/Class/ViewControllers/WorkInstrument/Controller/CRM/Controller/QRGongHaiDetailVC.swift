//
//  QRGongHaiDetailVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/17.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRGongHaiDetailVC: SuperVC {
    
    static let CellIdentifier = "gonghaiGenjinid"
    //客户模型
    var model = QRKeHuModel()
    
    var dataArr = [QRGongHaiTractModel]()
    var genzonArr = [QRGonghaiGenjinModel]()
    //客户id
    var customerId = ""
    //MARK:-  HEAD
    //商机数量
    var businessNum = ""
    //合同数量
    var contractNum = ""
    //创建人
    var creator = ""
    
    //客户联系人信息
    // var crmLinkmans = []()
    //客户id
    // var customerId = ""
    //跟进记录数量
    var followRecordNum = ""
    //是否下属客户
    var isSubordinates = ""
    //最后跟进时间
    var lastFollowDate = ""
    //负责人
    var principal = ""
    //标的数量
    var sampleAreaNum = ""
    
    //当前页面
    var currentPage = 1
    
    
    lazy var headTitle :UILabel = {
        let title = UILabel(title: "跟进记录", textColor: UIColor.black, fontSize: 15, alignment: .left, numberOfLines: 1)
        title.frame =  CGRect(x: kLeftDis, y: AutoGetHeight(height: 8), width: 100, height: AutoGetHeight(height: 40))
        return title
    }()
    
    lazy var headListView :UIView = {
        let big = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 48)))
        
        let greyline = UIView()
        greyline.backgroundColor = kProjectBgColor
        greyline.frame =  CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 8))
        big.addSubview(greyline)
        let greyline1 = UIView()
        greyline1.backgroundColor = kProjectBgColor
        greyline1.frame =  CGRect(x: 0, y: AutoGetHeight(height: 47), width: kWidth, height: AutoGetHeight(height: 1))
        big.addSubview(greyline1)
        big.addSubview(headTitle)
        
        return big
    }()
    
    
    
    //
    lazy var  bottomBar : UIView = {
        let grey = UIView()
        grey.frame =  CGRect(x: 0, y: 0, width: kWidth, height: 0.5)
        grey.backgroundColor = kProjectBgColor
        
        let bottomBar  =  UIView(frame:  CGRect(x: 0, y: kHeight-AutoGetHeight(height: 49), width: kWidth, height: AutoGetHeight(height: 49)))
        let but1 = UIButton(frame:  CGRect(x: 0, y: 0, width: kWidth/2, height: AutoGetHeight(height: 49)))
        but1.setTitle("写跟进记录", for: .normal)
        but1.setTitleColor(kColorRGB(r: 44, g: 160, b: 255), for: .normal)
        but1.setImage(UIImage(named:"genjjil"), for: .normal)
        but1.backgroundColor = UIColor.white
        but1.addTarget(self, action: #selector(genJinJiLu), for: UIControlEvents.touchUpInside)
        but1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -24, right: (but1.imageView?.frame.width)!/2)
        but1.imageEdgeInsets = UIEdgeInsets(top: 0, left: (but1.titleLabel?.frame.size.width)!/2+(but1.imageView?.frame.origin.x)!, bottom: 20, right: 0)
        but1.titleLabel?.font = kFontSize15
        
        let but2 = UIButton(frame:  CGRect(x: kWidth/2, y: 0, width: kWidth/2, height: AutoGetHeight(height: 49)))
        but2.setTitle("文件柜", for: .normal)
        but2.setTitleColor(kColorRGB(r: 44, g: 160, b: 255), for: .normal)
        but2.setImage(UIImage(named:"wenjg"), for: .normal)
        but2.backgroundColor = UIColor.white
        but2.addTarget(self, action: #selector(wenJianGui), for: UIControlEvents.touchUpInside)
        but2.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -24, right: 0)
        but2.imageEdgeInsets = UIEdgeInsets(top: 0, left: (but2.titleLabel?.frame.size.width)!/2+(but2.imageView?.frame.origin.x)!, bottom: 20, right: 0)
        but2.titleLabel?.font = kFontSize15
        bottomBar.addSubview(but1)
        bottomBar.addSubview(but2)
        bottomBar.addSubview(grey)
        return bottomBar
    }()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.grouped)
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
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
    
    lazy var headView :UIView = {
        let head = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 200)))
        head.addSubview(big2)
        head.addSubview(bigshadowView)
        bigshadowView.addSubview(bigView)
        
        return head
    }()
    lazy var bigshadowView : UIView = {
        let bigshadow = UIView(frame: CGRect(x: kLeftDis, y: kLeftDis, width: kHaveLeftWidth, height: AutoGetHeight(height: 130)))
//        bigshadow.layer.shadowOffset = CGSize(width: 1, height: 1);
//        bigshadow.layer.shadowOpacity = 0.8;
//        bigshadow.layer.shadowColor = kColorRGB(r: 225, g: 225, b: 225).cgColor;
      
        return bigshadow
    }()
    
    lazy var bigView :UIView = {
        let big = UIView(frame: CGRect(x:0 , y: 0, width: kHaveLeftWidth, height: AutoGetHeight(height: 130)))
//        big.layer.borderColor = kColorRGB(r: 225, g: 225, b: 225).cgColor
//        big.layer.cornerRadius = 6
//        big.layer.borderWidth = 0.8
        let img = UIImage(named: "checkOutBg")
        big.layer.contents = img?.cgImage
        big.addSubview(titleName)
        big.addSubview(jinger)
        big.addSubview(end)
        big.addSubview(yang)
        big.addSubview(jiantou)
        big.addSubview(endTime)
        big.addSubview(contractBut)
        big.addSubview(businessBut)
        big.addSubview(BiaoBut)
        big.addSubview(gonghai)
        let tap = UITapGestureRecognizer(target: self, action: #selector(detailCustom))
        big.addGestureRecognizer(tap)
        
        
        return big
    }()
    lazy var big2 :UIView = {
        let big = UIView(frame: CGRect(x: 0, y: bigshadowView.bottom, width: kWidth, height: AutoGetHeight(height: 55)))
        big.addSubview(genjinren)
        big.addSubview(namesLab)
        big.addSubview(jiantou2)
        let ges = UITapGestureRecognizer(target: self, action: #selector(genJingRen))
        big.addGestureRecognizer(ges)
        return big
    }()
    
    
    lazy var titleName :UILabel = {
        //商机名称
        let big = UILabel(title: "     ", textColor: UIColor.black, fontSize: 18)
        big.numberOfLines = 1
        return big
    }()
    lazy var jinger :UILabel = {
        //李明负责
        let big = UILabel(title: "", textColor: klightGreyColor, fontSize: 13)
        return big
    }()
    lazy var end :UILabel = {
        let big = UILabel(title: "最后跟进时间:", textColor: klightGreyColor, fontSize: 13)
        return big
    }()
    
    lazy var yang :UIView = {
        let big = UIView()
        big.backgroundColor = klightGreyColor
        big.frame =  CGRect(x: 0, y: 0, width: 1, height: 10)
        
        return big
    }()
   
    lazy var endTime :UILabel = {
        let big = UILabel(title: "2018-01-02", textColor: klightGreyColor, fontSize: 13)
        return big
    }()
    
    lazy var businessBut :UIButton = {
        let big = UIButton(title: "商机")
        big.setBackgroundImage(imageWithColor(color: kContractBlueColor, size: CGSize(width: 73, height: 34)), for: .normal)
        big.addTarget(self, action: #selector(JumpBusiness), for: UIControlEvents.touchUpInside)
        big.setTitleColor(kColorRGB(r: 44, g: 160, b: 255), for: .normal)
        big.layer.cornerRadius  = 6
        big.titleLabel?.font = kFontSize12
        big.clipsToBounds = true
        return big
    }()
    
    lazy var contractBut :UIButton = {
        let big = UIButton(title: "合同")
        big.setBackgroundImage(imageWithColor(color: kContractBlueColor, size: CGSize(width: 73, height: 34)), for: .normal)
        big.addTarget(self, action: #selector(JumpContract), for: UIControlEvents.touchUpInside)
        big.layer.cornerRadius  = 6
        big.clipsToBounds = true
        big.titleLabel?.font = kFontSize12
        big.setTitleColor(kColorRGB(r: 44, g: 160, b: 255), for: .normal)
        return big
    }()
    lazy var BiaoBut :UIButton = {
        let big = UIButton(title:"标地")
        big.setBackgroundImage(imageWithColor(color: kContractBlueColor, size: CGSize(width: 73, height: 34)), for: .normal)
        big.setTitleColor(kColorRGB(r: 44, g: 160, b: 255), for: .normal)
        big.layer.cornerRadius  = 6
        big.clipsToBounds = true
        big.titleLabel?.font = kFontSize12
        big.addTarget(self, action: #selector(JumpBiao), for: UIControlEvents.touchUpInside)
        return big
    }()
    
    
    lazy var gonghai :UIButton = {
        let big = UIButton()
        big.setTitle("公海", for: UIControlState.normal)
        big.titleLabel?.font = kFontSize15
        big.backgroundColor = kColorRGB(r: 44, g: 160, b: 255)
        big.setTitleColor(UIColor.white, for: UIControlState.normal)
        big.layer.cornerRadius = 12
        big.clipsToBounds = true
      //big.addTarget(self, action: #selector(changgeSaleStage), for:.touchUpInside)
        return big
    }()
    lazy var jiantou :UIImageView = {
        let big = UIImageView(image: UIImage(named:"roomClose"))
        big.isUserInteractionEnabled = true
        
        return big
    }()
    lazy var genjinren : UILabel = {
        let big = UILabel(title: "创建人", textColor:UIColor.black , fontSize: 15)
        return big
    }()
    lazy var namesLab : UILabel = {
        let big = UILabel(title: "    ", textColor:klightGreyColor , fontSize: 15)
        big.textAlignment = NSTextAlignment.right
        big.numberOfLines = 0
        return big
    }()
    lazy var jiantou2 :UIImageView = {
        let big = UIImageView(image: UIImage(named:"roomClose"))
        return big
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(table)
        title = "客户信息"
        table.tableHeaderView = headView
        navigationItem.rightBarButtonItem = rightButtonWithImg(image: UIImage(named:"gd")!)
       // view.addSubview(bottomBar)
        
        self.setUpRefresh()
        self.loadHeadData()
        self.loadGenJinListData(moreData: false)
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
    
    func loadHeadData()  {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmCustomer/getCrmCustomerInfo", type: .get, param: ["customerId":customerId,"userId":userID], successCallBack: { (result) in
            print(result["data"])
            //赋值
            self.titleName.text = result["data"]["name"].stringValue
            self.jinger.text = result["data"]["principal"].stringValue
            self.endTime.text = result["data"]["lastFollowDate"].stringValue
            if result["data"]["businessNum"].intValue > 0 {
              self.businessBut.setTitle("商机(\(result["data"]["businessNum"].stringValue))", for: .normal)
            }
            if result["data"]["contractNum"].intValue > 0 {
                self.contractBut.setTitle("合同(\(result["data"]["contractNum"].stringValue))", for: .normal)
            }
            if result["data"]["sampleAreaNum"].intValue > 0 {
                self.BiaoBut.setTitle("标地(\(result["data"]["sampleAreaNum"].stringValue))", for: .normal)
            }
            
            //跟进人数据加载
             var temp  = [QRGonghaiGenjinModel]()
            var str = " "
            for xx in result["data"]["userData"].arrayValue{
                let mod = QRGonghaiGenjinModel(jsonData: xx)
                
                temp.append(mod!)
                str += "\((mod?.realName)!)、"
            }
            if str.last == "、"{
                str.removeLast()
            }
            self.genzonArr = temp
          //  self.namesLab.text = str
            self.namesLab.text = result["data"]["creator"].stringValue
         
//            let height = getTextHeight(text: str, font: self.namesLab.font, width: kWidth-AutoGetWidth(width: 110))
//            //重设big2的frame//重设head的frame
//            self.big2.frame = CGRect(x: 0, y: self.bigView.bottom, width: kWidth, height: AutoGetHeight(height: height + 20))
//            self.headView.frame = CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 145 ) + AutoGetHeight(height: height + 20))
//            self.table.tableHeaderView = self.headView
            
            
            self.customerId = result["data"]["customerId"].stringValue
            
            let mod = QRKeHuModel(jsonData: result["data"])
            self.model = mod!
            
            
        }) { (error) in
            //显示空白页面
//            self.headView.tz_height = 0
//            self.headView.alpha = 0
//            self.table.tableHeaderView = self.headView
//            self.headListView.alpha = 0
//            self.headListView.tz_height = 0
//            self.table.sectionHeaderHeight = 0
//            self.table.reloadData()
//            self.table.mj_footer.resetNoMoreData()
            //let blankview
            
            self.table.removeFromSuperview()
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    
    }
    
    
    func setUpRefresh() {
        // MARK:header
        let STHeader = CQRefreshHeader {[unowned self] in
            self.loadGenJinListData(moreData: false)
        }
        // MARK:footer
        let STFooter = CQRefreshFooter {[unowned self] in
            self.loadGenJinListData(moreData: false)
        }
        self.table.mj_header = STHeader
        self.table.mj_footer = STFooter
        
    }
    
    //MARK:- 请求
    func loadGenJinListData(moreData:Bool) {
        if moreData {
            currentPage += 1
        } else {
            currentPage = 1
        }
        //  let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmCustomer/getCrmFollowRecordByList", type: .get, param:["customerId":customerId,
                                                                                                                       "currentPage":currentPage,
                                                                                                                       "rows":10], successCallBack: { (result) in
                                                                                                                        var temp = [QRGongHaiTractModel]()
                                                                                                                        for xx in result["data"].arrayValue{
                                                                                                                            let modal = QRGongHaiTractModel(jsonData: xx)
                                                                                                                            temp.append(modal!)                                                           }
                                                                                                                  if moreData {
                                                                                                                            self.dataArr.append(contentsOf: temp)
                                                                                                                        } else {
                                                                                                                            self.dataArr = temp
                                                               self.headTitle.text = "跟进记录" + " \(self.dataArr.count)"                                                            }
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
    
    func loadDeleteCustorm(){
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmCustomer/deleteCrmCustomer", type: .post, param: ["customerId":customerId,
                                                                                                                   "userId":userID], successCallBack: { (result) in
                                                                                                                    
                                                                                                                    if   result["success"].boolValue{
                                                                                                                        SVProgressHUD.showInfo(withStatus: "删除成功")
                                                                                                                    }
                                                                                                                    self.navigationController?.popViewController(animated: true)
                                                                                                                    
        }) { (error) in
            
            SVProgressHUD.showInfo(withStatus: "删除失败")
            
            
        }
        
    }
    
    
    
    
    
    //
    override func rightItemClick() {
        let items = ["历史编辑记录"]
        // let items = ["编辑","删除","历史编辑记录"]
        let vProperty = FWSheetViewProperty()
        vProperty.touchWildToHide = "1"
        let sheetView = FWSheetView.sheet(title:"", itemTitles: items, itemBlock: { [unowned self] (popupView, index, title) in
            let  history = QRHistoryEditeVC()
            history.customerId = self.customerId
            self.navigationController?.pushViewController(history, animated: true)
            
        }, cancenlBlock: {
            print("点击了取消")
        }, property: vProperty)
        sheetView.show()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
        setUpui()
    }
    
    
    
    

    //MARK:-布局
    func setupUI()  {
        genjinren.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(kLeftDis)
            make?.centerY.mas_equalTo()(big2)
            make?.width.mas_equalTo()(55)
        }
        jiantou2.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(-kLeftDis)
            make?.centerY.mas_equalTo()(big2)
            make?.width.mas_equalTo()(8)
            make?.height.mas_equalTo()(14.5)
        }
        namesLab.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(jiantou2.mas_left)?.setOffset(-5)
            make?.left.mas_equalTo()(genjinren.mas_right)?.setOffset(10)
            make?.centerY.mas_equalTo()(big2)
        }
        
    }
    
    func setUpui(){
        
        titleName.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(kLeftDis)
            make?.top.mas_equalTo()(kLeftDis)
            make?.right.mas_lessThanOrEqualTo()(-AutoGetWidth(width: 100))
        }
        jinger.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(titleName)
            make?.top.mas_equalTo()(titleName.mas_bottom)?.setOffset(AutoGetWidth(width: 10))
        }
        yang.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(jinger.mas_right)
            make?.centerY.mas_equalTo()(jinger.mas_centerY)
            make?.width.mas_equalTo()(1)
            make?.height.mas_equalTo()(10)
          //  make?.top.mas_equalTo()(titleName.mas_bottom)?.setOffset(AutoGetWidth(width: 10))
           
        }
       
        end.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(yang.mas_right)?.setOffset(AutoGetWidth(width: 5))
            make?.centerY.mas_equalTo()(yang)
        }
        endTime.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(end.mas_right)
            make?.centerY.mas_equalTo()(end.mas_centerY)
        }
        businessBut.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(titleName)
            make?.top.mas_equalTo()(titleName.mas_bottom)?.setOffset(AutoGetHeight(height: 40))
        }
        
        contractBut.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(businessBut.mas_right)?.setOffset(AutoGetHeight(height: 10))
            make?.top.mas_equalTo()(titleName.mas_bottom)?.setOffset(AutoGetHeight(height: 40))
        }
        BiaoBut.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contractBut.mas_right)?.setOffset(AutoGetWidth(width: 10))
             make?.centerY.mas_equalTo()(contractBut)
        }
        jiantou.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(-AutoGetWidth(width: 15))
            make?.top.mas_equalTo()(kLeftDis)
            //make?.width.mas_offset()(40)
            
        }
        gonghai.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(titleName.mas_right)?.setOffset(AutoGetWidth(width: 10))
            make?.centerY.mas_equalTo()(titleName)
            make?.height.mas_equalTo()(AutoGetWidth(width: 22))
            make?.width.mas_equalTo()(AutoGetWidth(width: 50))
        }
        

    }
    
    
}


extension QRGongHaiDetailVC:UITableViewDelegate{
    
}
extension QRGongHaiDetailVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = QRGonghaiGenjinCell.init(style: UITableViewCellStyle.default, reuseIdentifier: QRGongHaiDetailVC.CellIdentifier)
        cell.rootVC = self
        cell.model = dataArr[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return AutoGetWidth(width: 48)
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            
            return headListView
        }
        return nil
    }
    
}
//MARK:点击事件
extension QRGongHaiDetailVC{
    @objc  func JumpBusiness(){
        let business = QRBusinessVC()
        business.customerId = customerId
        business.addBut.alpha = 0
        self.navigationController?.pushViewController(business, animated: true)
    }
    @objc  func JumpContract(){
        let contract = QRContractVC()
        contract.customerId = customerId
        self.navigationController?.pushViewController(contract, animated: true)
    }
    @objc  func JumpBiao(){
        let biao = QRGoodsVC()
        biao.customerId = customerId
        self.navigationController?.pushViewController(biao, animated: true)
    }
    @objc func genJinJiLu(){
        let  gj = QRAddGenJinVC()
        gj.customerId = customerId
        gj.type = "1"
        gj.clickClosure = {[unowned self] reflash in
            self.loadGenJinListData(moreData: false)
        }
        self.navigationController?.pushViewController(gj, animated: true)
    }
    @objc func wenJianGui(){
        let  wjg = QRWenJianGuiVC()
        wjg.customerId = customerId
//        wjg.type = "1"
        self.navigationController?.pushViewController(wjg, animated: true)
    }
    @objc func detailCustom(){
        let web = QRCustomWebVC()
        web.customerId = customerId
        web.customer = model
        
        self.navigationController?.pushViewController(web, animated: true)
    }
    @objc func genJingRen(){
//        let genjin = QRAddTrackPersonVC()
//        genjin.genJin = genzonArr
//        genjin.kehu = model
//        genjin.type = 1
//        genjin.customerId = customerId
//        genjin.clickClosure = { a,b in
//            self.loadHeadData()
//        }
//        self.navigationController?.pushViewController(genjin, animated: true)
        
    }
    
}



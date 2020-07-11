//
//  QRDetailCustomVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/23.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRDetailCustomVC: SuperVC {
   

    //回调声明闭包刷新
    typealias clickBtnClosure = (_ reflash :String) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    
    static let CellIdentifier = "gonghaiGenjinid"
    //当前页面
    var currentPage = 1
    //客户id
    var customerId = ""
    //
    var rows = 15
    //
    var dataArr = [QRGongHaiTractModel]()
    var genzonArr = [QRGonghaiGenjinModel]()
    
    //选中联系人model
    var overTimeModel:CQDepartMentUserListModel?
    //转移的userid
    var changeUserId = ""
    
    
    var model = QRKeHuModel()
    //var GenJinArr = [QRGonghaiGenjinModel]()
    
    lazy var  bottomBar : UIView = {
        let grey = UIView()
        grey.frame =  CGRect(x: 0, y: 0, width: kWidth, height: 0.5)
        grey.backgroundColor = kProjectDarkBgColor
        
        let bottomBar  =  UIView(frame:  CGRect(x: 0, y: kHeight-AutoGetHeight(height: 64) -  CGFloat(SafeAreaBottomHeight) , width: kWidth, height: AutoGetHeight(height: 64)))
        let but1 = UIButton(frame:  CGRect(x: 0, y: 0.5, width: kWidth/2, height: AutoGetHeight(height: 64)))
        but1.setTitle("写跟进记录", for: .normal)
        but1.setTitleColor(kColorRGB(r: 44, g: 160, b: 255), for: .normal)
        but1.setImage(UIImage(named:"genjjil"), for: .normal)
        but1.backgroundColor = UIColor.white
        but1.addTarget(self, action: #selector(genJinJiLu), for: UIControlEvents.touchUpInside)
        but1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -24, right: (but1.imageView?.frame.width)!/2)
        but1.imageEdgeInsets = UIEdgeInsets(top: 0, left: (but1.titleLabel?.frame.size.width)!/2+(but1.imageView?.frame.origin.x)!, bottom: 20, right: 0)
        but1.titleLabel?.font = kFontSize15
        
        let but2 = UIButton(frame:  CGRect(x: kWidth/2, y: 0.5, width: kWidth/2, height: AutoGetHeight(height: 64)))
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
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight - CGFloat(SafeAreaBottomHeight) ), style: UITableViewStyle.grouped)
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
            table.contentInset = UIEdgeInsetsMake(CGFloat(SafeAreaTopHeight), 0, -CGFloat(SafeAreaBottomHeight), 0);
            table.scrollIndicatorInsets = table.contentInset;
            
        } else {
            //低于 iOS 9.0
            
        }
        
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.register(QRGonghaiGenjinCell.self, forCellReuseIdentifier:QRGongHaiDetailVC.CellIdentifier )
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.allowsSelection = false
        table.estimatedRowHeight = 200
        table.rowHeight = UITableViewAutomaticDimension
        return table
    }()
    
    lazy var headView :UIView = {
        let head = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 295)))
        head.addSubview(big2)
        head.addSubview(bigView)
        head.addSubview(big3)
        head.addSubview(big4)
        return head
    }()
    
    lazy var bigView :UIView = {
        let big = UIView(frame: CGRect(x: kLeftDis, y: kLeftDis, width: kHaveLeftWidth, height: AutoGetHeight(height: 130)))
 //       big.layer.borderColor = kColorRGB(r: 225, g: 225, b: 225).cgColor
//        big.layer.cornerRadius = 6
//        big.clipsToBounds = true
//        big.layer.borderWidth = 1
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
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(detailCustom))
        big.addGestureRecognizer(tap)
        return big
    }()
    lazy var big2 :UIView = {
        let big = UIView(frame: CGRect(x: 0, y: bigView.bottom, width: kWidth, height: AutoGetHeight(height: 50)))
        big.addSubview(genjinren)
        big.addSubview(namesLab)
        big.addSubview(jiantou2)
//        let greyline = UIView()
//        greyline.backgroundColor = kProjectBgColor
//        greyline.frame =  CGRect(x: kLeftDis, y: big.bottom-1, width: kHaveLeftWidth, height: 1)
        big.addSubview(greyLine)
        let ges = UITapGestureRecognizer(target: self, action: #selector(genJingRen))
        big.addGestureRecognizer(ges)
        return big
    }()
    lazy var labKeHuLaiYuan :UILabel = {
        let titleDetail = UILabel(title: "网络渠道", textColor: UIColor.lightGray, fontSize: 14, alignment: .right, numberOfLines: 1)
        titleDetail.frame =  CGRect(x: kWidth-kLeftDis-150, y: AutoGetHeight(height: 0), width: 150, height: AutoGetHeight(height: 54))
        return titleDetail
    }()
    
    lazy var big3 :UIView = {
        let big = UIView(frame: CGRect(x: 0, y: big2.bottom, width: kWidth, height: AutoGetHeight(height: 55)))
        let title = UILabel(title: "客户来源", textColor: UIColor.black, fontSize: 15, alignment: .left, numberOfLines: 1)
        title.frame =  CGRect(x: kLeftDis, y: AutoGetHeight(height: 0), width: 100, height: AutoGetHeight(height: 54))
        let greyline = UIView()
        greyline.backgroundColor = kProjectBgColor
        greyline.frame =  CGRect(x: kLeftDis, y: AutoGetHeight(height: 54), width: kHaveLeftWidth, height: AutoGetHeight(height: 1))
        
        big.addSubview(title)
        big.addSubview(self.labKeHuLaiYuan)
        big.addSubview(greyline)
       
        return big
    }()
    
    lazy var labKeHuJiBie :UILabel = {
        let titleDetail = UILabel(title: "成交客户", textColor: UIColor.lightGray, fontSize: 15, alignment: .right, numberOfLines: 1)
        titleDetail.frame =  CGRect(x: kWidth-kLeftDis-150, y: AutoGetHeight(height: 0), width: 150, height: AutoGetHeight(height: 54))
        return titleDetail
    }()
    lazy var big4 :UIView = {
        let big = UIView(frame: CGRect(x: 0, y: big3.bottom, width: kWidth, height: AutoGetHeight(height: 55)))
        let title = UILabel(title: "客户级别", textColor: UIColor.black, fontSize: 15, alignment: .left, numberOfLines: 1)
        title.frame =  CGRect(x: kLeftDis, y: AutoGetHeight(height: 0), width: 100, height: AutoGetHeight(height: 54))

        let greyline = UIView()
        greyline.backgroundColor = kProjectBgColor
        greyline.frame =  CGRect(x: kLeftDis, y: AutoGetHeight(height: 54), width: kHaveLeftWidth, height: AutoGetHeight(height: 1))
        
        big.addSubview(title)
        big.addSubview(labKeHuJiBie)
       // big.addSubview(greyline)
        
        return big
    }()
    
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
    
    
    lazy var titleName :UILabel = {
        let big = UILabel(title: "我的客户标题", textColor: UIColor.black, fontSize: 18)
        big.numberOfLines = 1
        return big
    }()
    lazy var jinger :UILabel = {
        let big = UILabel(title: "李明负责", textColor: klightGreyColor, fontSize: 13)
        return big
    }()
    lazy var end :UILabel = {
        let big = UILabel(title: "最后跟进时间:", textColor: klightGreyColor, fontSize: 13)
        return big
    }()
    
    lazy var yang : UIView = {
        let big = UIView()
        big.backgroundColor = klightGreyColor
        return big
    }()
    
    lazy var endTime :UILabel = {
        let big = UILabel(title: "2018-01-02", textColor: klightGreyColor, fontSize: 13)
        return big
    }()
    
    lazy var businessBut :UIButton = {
        let big = UIButton(title: "商机")
        big.setBackgroundImage(imageWithColor(color: kfilterBlueColor, size: CGSize(width: AutoGetWidth(width: 73), height: AutoGetWidth(width: 34))), for: .normal)
        big.addTarget(self, action: #selector(JumpBusiness), for: UIControlEvents.touchUpInside)
        big.titleLabel?.font = kFontSize12
        big.setTitleColor(kColorRGB(r: 44, g: 160, b: 255), for: .normal)
        big.layer.cornerRadius  = AutoGetWidth(width: 6)
        big.clipsToBounds = true
        return big
    }()
    
    lazy var contractBut :UIButton = {
        let big = UIButton(title: "合同")
        big.setBackgroundImage(imageWithColor(color: kfilterBlueColor, size: CGSize(width: AutoGetWidth(width: 73), height: AutoGetWidth(width: 34))), for: .normal)
        big.addTarget(self, action: #selector(JumpContract), for: UIControlEvents.touchUpInside)
        big.titleLabel?.font = kFontSize12
        big.layer.cornerRadius  = AutoGetWidth(width: 6)
        big.clipsToBounds = true
        big.setTitleColor(kColorRGB(r: 44, g: 160, b: 255), for: .normal)
        return big
    }()
    lazy var BiaoBut :UIButton = {
        let big = UIButton(title:"标地")
        big.setBackgroundImage(imageWithColor(color: kfilterBlueColor, size: CGSize(width: AutoGetWidth(width: 73), height: AutoGetWidth(width: 34))), for: .normal)
        big.setTitleColor(kColorRGB(r: 44, g: 160, b: 255), for: .normal)
        big.layer.cornerRadius  = AutoGetWidth(width: 6)
        big.titleLabel?.font = kFontSize12
        big.clipsToBounds = true
        big.addTarget(self, action: #selector(JumpBiao), for: UIControlEvents.touchUpInside)
        return big
    }()
    
    
    lazy var jiantou :UIImageView = {
        let big = UIImageView(image: UIImage(named:"roomClose"))
        big.isUserInteractionEnabled = true
       
        return big
    }()
    lazy var genjinren : UILabel = {
        let big = UILabel(title: "跟进人", textColor:UIColor.black , fontSize: 15)
        return big
    }()
    lazy var namesLab : UILabel = {
        let big = UILabel(title: "    ", textColor:klightGreyColor , fontSize: 14)
        big.textAlignment = NSTextAlignment.right
        big.numberOfLines = 0
        
        return big
    }()
    lazy var jiantou2 :UIImageView = {
        let big = UIImageView(image: UIImage(named:"roomClose"))
        
        return big
    }()
    lazy var greyLine : UIView = {
        let greyline = UIView()
        greyline.backgroundColor = kProjectBgColor
//        greyline.frame =  CGRect(x: kLeftDis, y: big.bottom-1, width: kHaveLeftWidth, height: 1)
        return greyline
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "客户信息"
        view.addSubview(table)
        table.tableHeaderView = headView
        navigationItem.rightBarButtonItem = rightButtonWithImg(image: UIImage(named:"gd")!)
        self.view.addSubview(bottomBar)
       
        self.loadHeadData()
        self.setUpRefresh()
        self.loadGenJinListData(moreData: false)
        let NotifMycation2 = NSNotification.Name(rawValue:"refreshAddAddressVC")
        NotificationCenter.default.addObserver(self, selector: #selector(overChange(notif:)), name: NotifMycation2, object: nil)
      
    }
   
    func addobser()  {
        let NotifMycation2 = NSNotification.Name(rawValue:"refreshAddAddressVC")
        NotificationCenter.default.addObserver(self, selector: #selector(overChange(notif:)), name: NotifMycation2, object: nil)
    }
    
      //接受对象
    @objc func overChange(notif: NSNotification) {
        guard let model: CQDepartMentUserListModel = notif.object as? CQDepartMentUserListModel else { return }
        print(model.realName)

        self.overTimeModel = model
        self.changeUserId = model.userId
        loadChange()
        
        
    }
    deinit {
       NotificationCenter.default.removeObserver(self)
    }
    
   
    func loadChange()  {
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmCustomer/distributeOrClaim", type: .post, param: ["customerIds[]":customerId,"mode":"1","userId":changeUserId], successCallBack: {[unowned self] (result) in
            
                SVProgressHUD.dismiss()
                self.clickClosure?("reflash")
                self.navigationController?.popViewController(animated: true)
            
            
        }) { (error) in
            
        }
        
    }
    
    
    
    
    func loadHeadData()  {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmCustomer/getCrmCustomerInfo", type: .get, param: ["customerId":customerId,"userId":userID], successCallBack: { [unowned self](result) in
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
        //    跟进人数据加载
            let mod = QRKeHuModel(jsonData: result["data"])
            self.model = mod!
            var temp  = [QRGonghaiGenjinModel]()
            var str = " "
            var me = self.model.principal!
            for xx in result["data"]["userData"].arrayValue{
                let mod = QRGonghaiGenjinModel(jsonData: xx)
                if mod?.userId == userID{
                    me = ""
                }
                temp.append(mod!)
                str += "\((mod?.realName)!)、"
            }
            
            
            if self.model.creator == self.model.principal{
                str = str + me
            }else{
                if self.model.creator == nil{
                    str = str + me
                }else{
                    str = str + me + "、\(self.model.creator!)"
                }
            }
            
            if str.last == "、"{
                str.removeLast()
            }
            self.genzonArr = temp
            //计算出字符高度,从新设置big2的高度
            self.namesLab.text = str
            let height = getTextHeight(text: str, font: self.namesLab.font, width: kWidth-AutoGetWidth(width: 110))
            //重设big2的frame//重设head的frame
            self.big2.frame = CGRect(x: 0, y: self.bigView.bottom, width: kWidth, height: AutoGetHeight(height: height + 30))
            self.headView.frame = CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 260 ) + AutoGetHeight(height: height + 30))
            self.big3.frame = CGRect(x: 0, y: self.big2.bottom, width: kWidth, height: AutoGetHeight(height: 55))
            self.big4.frame = CGRect(x: 0, y: self.big3.bottom, width: kWidth, height: AutoGetHeight(height: 55))
            self.table.tableHeaderView = self.headView
            
            self.customerId = result["data"]["customerId"].stringValue
            //客户来源
            self.labKeHuJiBie.text = result["data"]["level"].stringValue
            //客户级别
            self.labKeHuLaiYuan.text = result["data"]["message"].stringValue
//             let mod = QRKeHuModel(jsonData: result["data"])
//             self.model = mod!
            
            
        }) { (error) in
            self.table.removeFromSuperview()
            self.bottomBar.removeFromSuperview()
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
                                                                                                                    "rows":rows], successCallBack: {[unowned self] (result) in
                                                                                                                        var temp = [QRGongHaiTractModel]()
                                                                                                                        for xx in result["data"].arrayValue{
                                                                                                                            let modal = QRGongHaiTractModel(jsonData: xx)
                                                                                                                            temp.append(modal!)                                                           }
                                                                                                                        if moreData {
                                                                                                                            self.dataArr.append(contentsOf: temp)
                                                                                                                        } else {
                                                                                                                            self.dataArr = temp
                                                                                                                        }
                                                                                                                        self.headTitle.text = "跟进记录" + " \(self.dataArr.count)"
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
                                                                                                               "userId":userID], successCallBack: { [unowned self](result) in

                                                                                                                if   result["success"].boolValue{
                                                                                                                    SVProgressHUD.showInfo(withStatus: "删除成功")
                                                                                                                }
                                                                                                                self.clickClosure!("reflash");                                                self.navigationController?.popViewController(animated: true)

        }) { (error) in

            SVProgressHUD.showInfo(withStatus: "删除失败")


        }

    }


    
    
    
    
    override func rightItemClick() {
        let items = ["编辑","转移给他人","新建商机","删除","历史编辑记录"]
        let vProperty = FWSheetViewProperty()
        vProperty.touchWildToHide = "1"
        let sheetView = FWSheetView.sheet(title:"", itemTitles: items, itemBlock: {[unowned self] (popupView, index, title) in
            //编辑商机
            if index == 0{
                let editeVC = CQAddCustomerVC()
                editeVC.customerId = self.customerId
                editeVC.model = self.model
                editeVC.clickClosure = {[unowned self] reflash in
                    self.loadHeadData()
                }
                self.navigationController?.pushViewController(editeVC, animated: true)
            }else if index == 1{
                //转移给他人
//                let vc = AddressBookVC.init()
//                vc.toType = .fromContact
//                if self.overTimeModel != nil{
//                    vc.hasSelectModelArr = [self.overTimeModel] as! [CQDepartMentUserListModel]
//                }
                
                
                let vc = QRAddressBookVC.init()
                vc.toType = .fromContact
                if self.overTimeModel != nil{
                    vc.hasSelectModelArr = [self.overTimeModel] as! [CQDepartMentUserListModel]
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if index == 2{
                //新建商机
                let addBus = QRAddBusinessVC()
               // addBus.customerId = self.customerId
                addBus.clickClosure = {[unowned self] a in
                   // self.table.mj_header.beginRefreshing()
                    self.loadHeadData()
                }
                self.navigationController?.pushViewController(addBus, animated: true)
                
            }else if index == 3{
                //删除
                self.loadDeleteCustorm()

            }else{
                let  history = QRHistoryEditeVC()
                history.customerId = self.customerId
                self.navigationController?.pushViewController(history, animated: true)
            }
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
            make?.width.mas_equalTo()(AutoGetWidth(width: 55))
        }
        jiantou2.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(-kLeftDis)
            make?.centerY.mas_equalTo()(big2)
            make?.width.mas_equalTo()(8)
            make?.height.mas_equalTo()(14.5)
        }
        namesLab.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(jiantou2.mas_left)?.setOffset(-AutoGetWidth(width: 5))
            make?.left.mas_equalTo()(genjinren.mas_right)?.setOffset(AutoGetWidth(width: 10))
//            make?.top.mas_equalTo()(big2)?.setOffset(5)
//            make?.bottom.mas_equalTo()(big2)?.setOffset(-5)
            make?.centerY.mas_equalTo()(big2)
        }
        
        greyLine.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(big2)?.setOffset(AutoGetWidth(width: 15))
            make?.right.mas_equalTo()(big2)
            make?.height.mas_equalTo()(AutoGetWidth(width: 1))
            make?.bottom.mas_equalTo()(big2)?.setOffset(-1)
        }
    }
    
    func setUpui(){
        
        titleName.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(AutoGetWidth(width: 15))
            make?.top.mas_equalTo()(AutoGetWidth(width: 15))
            //make?.width.mas_equalTo()(250)
            make?.right.mas_lessThanOrEqualTo()(-AutoGetWidth(width: 10))
        }
        jinger.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(titleName)
            make?.top.mas_equalTo()(titleName.mas_bottom)?.setOffset(AutoGetWidth(width: 10))
        }
        yang.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(jinger.mas_right)?.setOffset(AutoGetWidth(width: 5))
            make?.centerY.mas_equalTo()(jinger)
            make?.width.mas_equalTo()(0.8)
            make?.height.mas_equalTo()(10)
            
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
            make?.top.mas_equalTo()(titleName.mas_bottom)?.setOffset(AutoGetWidth(width: 40))
        }
        
        contractBut.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(businessBut.mas_right)?.setOffset(AutoGetWidth(width: 10))
            make?.top.mas_equalTo()(titleName.mas_bottom)?.setOffset(AutoGetWidth(width: 40))
        }
        BiaoBut.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contractBut.mas_right)?.setOffset(AutoGetWidth(width: 10))
            make?.centerY.mas_equalTo()(contractBut)
        }
        jiantou.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(-AutoGetWidth(width: 15))
            make?.top.mas_equalTo()(AutoGetWidth(width: 15))
        }

        
    }
    
}


//MARK:-TABLE
extension QRDetailCustomVC:UITableViewDelegate{
    
}
extension QRDetailCustomVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      //  var cell = QRGonghaiGenjinCell.init(style: UITableViewCellStyle.default, reuseIdentifier: QRGongHaiDetailVC.CellIdentifier)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: QRGongHaiDetailVC.CellIdentifier, for: indexPath) as! QRGonghaiGenjinCell
        cell.rootVCKeHu = self
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
extension QRDetailCustomVC{
    @objc  func JumpBusiness(){
        let business = QRBusinessVC()
        business.customerId = customerId
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
      //  gj.type = "1"
        gj.clickClosure = {[unowned self] reflash in
            self.loadGenJinListData(moreData: false)
        }
        self.navigationController?.pushViewController(gj, animated: true)
    }
    @objc func wenJianGui(){
        let  wjg = QRWenJianGuiVC()
        wjg.customerId = customerId
        self.navigationController?.pushViewController(wjg, animated: true)
    }
    @objc func detailCustom(){
        let web = QRCustomWebVC()
        web.customerId = customerId
        web.customer = model
        
        self.navigationController?.pushViewController(web, animated: true)
    }
    @objc func genJingRen(){
        let genjin = QRAddTrackPersonVC()
        genjin.kehu = model
        genjin.genJin = genzonArr
        genjin.type = 1
        genjin.customerId = customerId
        genjin.clickClosure = {[unowned self] a,b in
            self.loadHeadData()
        }
        self.navigationController?.pushViewController(genjin, animated: true)
        
    }
    
}




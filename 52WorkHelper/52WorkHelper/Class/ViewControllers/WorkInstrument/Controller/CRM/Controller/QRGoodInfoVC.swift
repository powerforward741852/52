//
//  QRGoodInfoVC.swift
//  test
//
//  Created by 秦榕 on 2018/9/8.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit

class QRGoodInfoVC: SuperVC {
    var goodModel : QRGoodsModel?
    var monthSaleMdel  = [QRSaleModel]()
   // var goodModels = [QRGoodsModel]()
    
    //商品分类
    var commodityCategoryName = ""
    //商品名称
    var commodityName = ""
    //商品价格
    var commodityPrice = ""
    //商品单位名称
    var commodityUnitName = ""
    //总销量
    var  totalNumber = ""
    static let  CellIdentifier = "saleid"
    //员工主键
    var entityId = ""
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        table.register(QRGoodSaleCell.self, forCellReuseIdentifier:QRGoodInfoVC.CellIdentifier )
        //table.separatorStyle = UITableViewCellSeparatorStyle.none
         table.rowHeight =  55
        return table
    }()
    
    lazy var name:UILabel = {
        let tips = UILabel(title: "打印机:", textColor: UIColor.black, fontSize: 18)
        return tips
    }()
    lazy var xiaoshoujia:UILabel = {
        let tips = UILabel(title: "销售价:", textColor: kLyGrayColor, fontSize: 13)
        return tips
    }()
    lazy var fenlei:UILabel = {
        let tips = UILabel(title: "分类:", textColor: kLyGrayColor, fontSize: 13)
        return tips
    }()
    lazy var money:UILabel = {
        let tips = UILabel(title: "55", textColor: kLyGrayColor, fontSize: 13)
        return tips
    }()
    lazy var danwei:UILabel = {
        let tips = UILabel(title: "元/件", textColor: kLyGrayColor, fontSize: 13)
        return tips
    }()
    lazy var cate:UILabel = {
        let tips = UILabel(title: "办公用品", textColor: kLyGrayColor, fontSize: 13)
        return tips
    }()
    lazy var jiantou:UIImageView = {
        let tips = UIImageView(image: UIImage(named: "PersonAddressArrow"))
        return tips
    }()
    
    var allCount = ""
  
    
    lazy var headView:UIView = {
        let head = UIView()
        head.frame =  CGRect(x: kLeftDis, y: 16, width: kHaveLeftWidth, height: AutoGetHeight(height: 110))
//        head.layer.borderColor = kColorRGB(r: 225, g: 225, b: 225).cgColor
//        head.layer.cornerRadius = 8
//        head.clipsToBounds = true
//        head.layer.borderWidth = 1
        let img = UIImage(named: "checkOutBg")
        head.layer.contents = img?.cgImage
        head.backgroundColor = UIColor.white
        let ges = UITapGestureRecognizer(target: self, action: #selector(jump))
        head.addGestureRecognizer(ges)
        return head
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "商品信息"
        view.addSubview(table)
        table.backgroundColor = kProjectBgColor
        
        setupUI()
        setHeadData()
         loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    func loadData()  {
        loadDataStart()
      //  let userid = STUserTool.account().userID
        let year = "\(Date().year)"
        STNetworkTools.requestData(URLString: "\(baseUrl)/crmCommodity/getMonthlySalesOfCommodities", type: .get, param: ["commodityId": entityId,
                                                                                                                    "year":year], successCallBack: { (result) in
                                                                                                                        
                                                                                                                        self.name.text = result ["data"]["commodityInfo"]["commodityName"].stringValue
                                                                                                                        self.money.text = result ["data"]["commodityInfo"]["commodityPrice"].stringValue
                                                                                                                        self.danwei.text = result ["data"]["commodityInfo"]["commodityUnitName"].stringValue
                                                                                                                        self.cate.text = result ["data"]["commodityInfo"]["commodityCategoryName"].stringValue
                                                               
                                                                                                    
                                                                                                                        
                                                                                                                            var tempArray = [QRSaleModel]()
                                                                                                                            for modalJson in result["data"]["allMonthSales"].arrayValue {
                                                                                                                                guard let modal = QRSaleModel(jsonData: modalJson) else {
                                                                                                                                    return
                                                                                                                                }
                                                                                                                                tempArray.append(modal)
                                                                                                                            }
                                                                                                                        self.allCount = result["data"]["commodityInfo"]["allSales"].stringValue
                                                            self.entityId = result["data"]["commodityInfo"]["entityId"].stringValue
                                                                                                            //需要插入全部销量
//                                                         let jsonStr = "{\"monthSaleNumber\":\"wall\",\"monthSales\":\""\(count)"\"}"

                                                                                                                    let first =  QRSaleModel(str: self.allCount, str1: "全部销量")
                                                                                                                        tempArray.insert(first, at: 0)
                                                                                                                              self.monthSaleMdel = tempArray
                                         
                                                                                                                        
                                                                                                                        
                                                                                                                        
                                                                                                                        self.table.reloadData()
             self.loadingDataSuccess()
                                                                                                                        
                                                                                                                            
        }) { (error) in
          
            
        }
        
    }
    
    func setHeadData() {
        name.text = goodModel?.commodityName
        money.text = goodModel?.commodityPrice
        danwei.text = goodModel?.commodityUnitName
        cate.text = goodModel?.commodityCategoryName
    }
    
    func setupUI()  {
        let headBig = UIView()
        headBig.frame =  CGRect(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 140))
        headBig.backgroundColor = UIColor.white
        headBig.addSubview(headView)
        headView.addSubview(name)
        headView.addSubview(xiaoshoujia)
        headView.addSubview(money)
        headView.addSubview(danwei)
        headView.addSubview(fenlei)
        headView.addSubview(cate)
        headView.addSubview(jiantou)
        name.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(headView)?.setOffset(15)
            make?.top.mas_equalTo()(headView)?.setOffset(18)
        }
        xiaoshoujia.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(headView)?.setOffset(15)
            make?.top.mas_equalTo()(name.mas_bottom)?.setOffset(14)
        }
        money.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(xiaoshoujia.mas_right)
            make?.centerY.mas_equalTo()(xiaoshoujia)
        }
        danwei.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(money.mas_right)
            make?.centerY.mas_equalTo()(xiaoshoujia)
        }
        fenlei.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(headView)?.setOffset(15)
            make?.top.mas_equalTo()(xiaoshoujia.mas_bottom)?.setOffset(10)
        }
        cate.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(fenlei.mas_right)
            make?.centerY.mas_equalTo()(fenlei)
        }
        jiantou.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(headView)?.setOffset(-15)
            make?.centerY.mas_equalTo()(name)
        }
        
        table.tableHeaderView = headBig
    }
    
    @objc func jump(){

        
        let gooddetail = QRCustomWebVC()
        gooddetail.comdityId = self.entityId
        gooddetail.goodsModel = self.goodModel
        
        gooddetail.type = 1
        self.navigationController?.pushViewController(gooddetail, animated: true)
        
    }
    
  

}

extension QRGoodInfoVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let goodSaleVc = QRSaleVC()
        goodSaleVc.commodityId = self.entityId
        let mod = monthSaleMdel[indexPath.row]
        let modd = monthSaleMdel[indexPath.row].monthSales
        if indexPath.row == 0 {
            //全年销量
           goodSaleVc.yearMonth = "2018"
           goodSaleVc.yearOrMonth = "year"
           goodSaleVc.title = "全部销量"+"(\(mod.monthSaleNumber))"
            
        }else{
            //当月销量//截取第一个字符
            goodSaleVc.title = "\(mod.monthSales)"+"(\(mod.monthSaleNumber))"
            var str = modd[...modd.startIndex]
            print("xxxxxxx\(str)")
            let month = getMonth()
            let year = getYear()
            var monthStr = ""
            if month<10 {
              monthStr = "0\(month)"
            }else{
              monthStr = "\(month)"
            }
            if str == "本" {
                goodSaleVc.yearMonth = "\(year)-0\(monthStr)"
                goodSaleVc.yearOrMonth = "month"
            }else{
                if Int(str)! < 10{
                    str = "0"+str
                }
                goodSaleVc.yearMonth = "\(year)-0\(str)"
                goodSaleVc.yearOrMonth = "month"
            }
           
        }
        navigationController?.pushViewController(goodSaleVc, animated: true)
        
    }
}
extension QRGoodInfoVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthSaleMdel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QRGoodInfoVC.CellIdentifier, for: indexPath) as! QRGoodSaleCell
        if monthSaleMdel.count == 1{
            cell.bottomView.isHidden = true
        }else{
            cell.bottomView.isHidden = false
        }
        
        if indexPath.row == 0 {
            cell.labNum.text = allCount
            cell.topView.isHidden = true
            
            cell.cir.isHidden = true
        }else if indexPath.row == monthSaleMdel.count-1 {
            cell.bottomView.isHidden = true
            
        }
       
            cell.model = monthSaleMdel[indexPath.row]
        
       
        return cell
}
}

//
//  QRCarTypeTabView.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/4/11.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

enum chooseType {
    case nav
    case detail
}

class QRCarTypeTabView: UIView {
    
    var startDate = "2019-04-11 14:50"
    var endDate = "2019-04-11 17:50"
    var carType : Int = 0
    var carMod : CQCarsModel?
    var dataArray = [CQCarsModel]()
    var pageNum = 1
    
    var table : UITableView!
    //声明闭包
    typealias clickBtnClosure = (_ carId : Int , _ car : CQCarsModel) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    var dataStr : String?
    var type:chooseType = chooseType.nav
    var navArr = ["商务车","货车","客车"]
    var navArrId = [1,2,3]
    
    //返回按钮
    var backBut : UIButton?
    var backView : UIView?
    
    lazy var withOutResultView: UIView = {
        let withOutResultView = UIView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 40), width: AutoGetHeight(height: 280), height: AutoGetHeight(height: 300-40)))
        withOutResultView.backgroundColor = UIColor.init(red: 0.9529, green: 0.9529, blue: 0.9529, alpha: 1)
        let imageV = UIImageView.init(frame: CGRect.init(x: 100, y: AutoGetHeight(height: 40), width: AutoGetHeight(height: 80), height: AutoGetHeight(height: 80)))
        imageV.image = UIImage.init(named: "searchNoResult")
        let lab = UILabel.init(frame: CGRect.init(x: 0, y: imageV.bottom + AutoGetHeight(height: 15), width: AutoGetHeight(height: 280), height: AutoGetHeight(height: 20)))
        lab.textAlignment = .center
        lab.textColor = UIColor.black
        lab.text = "无此类车辆"
        lab.font = UIFont.boldSystemFont(ofSize: 15)
        withOutResultView.addSubview(imageV)
        withOutResultView.addSubview(lab)
        return withOutResultView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func creatCarTypeTabView() -> QRCarTypeTabView {
        let CarTypeTabView = QRCarTypeTabView(frame:  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        CarTypeTabView.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.7)
        CarTypeTabView.setUpUi()
       
        let tapGes = UITapGestureRecognizer(target: CarTypeTabView, action: #selector(closeWindow))
        CarTypeTabView.addGestureRecognizer(tapGes)
        tapGes.delegate = CarTypeTabView
        return CarTypeTabView
    }
    
    
    func setUpUi(){
        //背景
        let backGroundView = UIView(frame:  CGRect(x: 0, y: 0, width: AutoGetHeight(height: 280), height: AutoGetHeight(height: 300)))
        backGroundView.backgroundColor = kBlueC
        backGroundView.center = CGPoint(x: kWidth/2, y: kHeight/2)
        self.addSubview(backGroundView)
        self.backView = backGroundView
        //关闭按钮
//        let closeBtn = UIButton(frame:  CGRect(x: AutoGetHeight(height: 280-31), y: AutoGetHeight(height: 5), width: AutoGetHeight(height: 26), height: AutoGetHeight(height: 26)))
//        closeBtn.setImage(UIImage(named: "guanbi"), for: UIControlState.normal)
//        backGroundView.addSubview(closeBtn)
//        closeBtn.addTarget(self, action: #selector(closeWindow), for: UIControlEvents.touchUpInside)
        
        let lab = UILabel(title: "车辆类型")
        lab.textColor  = UIColor.white
        lab.font = kFontBoldSize18
        lab.frame = CGRect(x: AutoGetHeight(height: 180)/2, y: 5, width: AutoGetWidth(width: 100), height: 31)
        lab.textAlignment = .center
       // lab.st_centerX = self.width/2
        backGroundView.addSubview(lab)
        
       //返回按钮
        let backBtn = UIButton(frame:  CGRect(x: AutoGetHeight(height: 15), y: AutoGetHeight(height: 5), width: AutoGetHeight(height: 26), height: AutoGetHeight(height: 26)))
       // backBtn.setImage(UIImage(named: "guanbi"), for: UIControlState.normal)
        backBtn.setTitle("返回", for: UIControlState.normal)
        backBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        backBtn.titleLabel?.font = kFontSize15
        backBtn.sizeToFit()
        backBtn.isHidden = true
        backGroundView.addSubview(backBtn)
        self.backBut = backBtn
        backBtn.addTarget(self, action: #selector(backWindow), for: UIControlEvents.touchUpInside)
        //滚动选择器

        let table = UITableView.init(frame: CGRect.init(x: AutoGetWidth(width: 0), y: AutoGetHeight(height: 40), width: AutoGetWidth(width: 280), height: AutoGetHeight(height: 260) ), style: UITableViewStyle.plain)
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        if #available(iOS 11.0, *) {
            //            table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
            //            table.contentInset = UIEdgeInsetsMake(CGFloat(SafeAreaTopHeight), 0, CGFloat(SafeAreaBottomHeight), 0);
            //            table.scrollIndicatorInsets = table.contentInset;
        } else {
            //低于 iOS 9.0
         //   self.automaticallyAdjustsScrollViewInsets = false
        }
        table.canCancelContentTouches = false
        table.delaysContentTouches = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "carTypeCellId")
        table.register(UINib.init(nibName: "CQChooseCarCell", bundle: Bundle.init(identifier: "chooseCarCellId")), forCellReuseIdentifier: "CQChooseCarCellId")
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
        table.separatorStyle = .singleLine
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        self.table = table
        backGroundView.addSubview(table)
        
        backGroundView.addSubview(withOutResultView)
        self.withOutResultView.isHidden = true
     
        
    }
    
    
    
    fileprivate func loadCarDatas() {
        SVProgressHUD.show()
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/approval/getAllCars" ,
            type: .get,
            param: ["emyeId":userID,
                    "endDate":endDate,
                    "startDate":startDate,
                    "carType":carType],
            successCallBack: { (result) in
                var tempArray = [CQCarsModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQCarsModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                self.dataArray = tempArray
                //刷新表格
                self.table.reloadData()
                if  self.dataArray.count == 0{
                    self.table.isHidden = true
                    self.withOutResultView.isHidden = false
                }else
                {
                    self.table.isHidden = false
                    self.withOutResultView.isHidden = true
                }
                SVProgressHUD.dismiss()
        }) { (error) in
            SVProgressHUD.dismiss()
          //  self.table.reloadData()
        }
    }
    
    
    
    
    @objc func closeWindow(){
        self.dismissPopView()
    }
    
    @objc func backWindow(){
       self.type = .nav
        self.withOutResultView.isHidden = true
         self.table.isHidden = false
        table.separatorStyle = .singleLine
        self.table.reloadData()
        self.backBut!.isHidden = true
    }
    @objc func buKa(){
        clickClosure!(self.carType , self.carMod!)
    }
    
    func showPopView(){
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.addSubview(self)
    }
    
    func dismissPopView(){
        self.removeFromSuperview()
    }
   
}

extension QRCarTypeTabView:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
      tableView.deselectRow(at: indexPath, animated: true)
        if self.type == .nav{
          table.separatorStyle = .none
          self.type = .detail
          self.carType = navArrId[indexPath.row]
            
            let mod = CQCarsModel()
            clickClosure!(self.carType , mod)
            self.dismissPopView()
         // self.loadCarDatas()
          //  self.backBut!.isHidden = false
        }else{
            let mod = dataArray[indexPath.row]
             clickClosure!(self.carType , mod)
            self.dismissPopView()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.type == .nav{
            return navArr.count
        }else{
            return self.dataArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.type == .nav{
            return  AutoGetHeight(height: 55)
        }else{
            return  158
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if self.type == .nav{
            let cell = tableView.dequeueReusableCell(withIdentifier: "carTypeCellId", for: indexPath)
            cell.textLabel?.text = navArr[indexPath.row]
           // cell.textLabel?.textAlignment = .center
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CQChooseCarCellId") as! CQChooseCarCell
            cell.carModel = self.dataArray[indexPath.row]
            return cell
        }
        
     
    }
    
}
extension QRCarTypeTabView : UIGestureRecognizerDelegate{
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
//
//        return true
//    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.backView!))!{
            return false
        }
        return true
    }
}

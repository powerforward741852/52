//
//  QRTongJiVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/4/20.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRTongJiVC: SuperVC {
    var departmentId = "39"
    var menu : YNDropDownMenu?
    var tongjiView : QRTongjiView?
    //选中联系人model
    var overTimeModel:CQDepartMentUserListModel?
    //请求参数
    var mySearchUserId = ""
    var myStartDate = ""
    var myEndDate = ""
    //选中后的名字以及时间
    var selectName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        title = "工作统计"
        self.view.backgroundColor = kProjectBgColor
        //初始今天,设置参数
//        myStartDate = Date().format(with: "yyyy-MM-dd ") + "00:00:01"
//       myEndDate = Date().format(with: "yyyy-MM-dd ") + "23:59:59"
        let st = CVDate(day: 1, month: Date().month, week: 1, year: Date().year).convertedDate()
        let ed = CVDate(day: Date().daysInMonth, month: Date().month, week: Date().weekOfMonth, year: Date().year).convertedDate()
        myStartDate = st!.format(with: "yyyy-MM-dd") + " " + "00:00:01"
        myEndDate = ed!.format(with: "yyyy-MM-dd") + " " + "23:59:59"
        
        
        //统计列表
        let tongji = Bundle.main.loadNibNamed("QRTongjiView", owner: nil, options: nil) as? [UIView]
        let v = tongji?[0] as! QRTongjiView
        self.tongjiView = v
        v.clickClosure = {[unowned self] type in
            if type == 0{
                //提交天数
            }else if type == 1{
                //未提交
            }else if type == 2{
                //日程数量
                let vc = QRScheduleCountVC()
                //筛选条件
                vc.searchUserId = self.mySearchUserId
                vc.startDate = self.myStartDate
                vc.endDate = self.myEndDate
                self.navigationController?.pushViewController(vc, animated: true)
            }else if type == 3{
                //提交率
            }else{
                
            }
        }
        v.frame =  CGRect(x:15, y: SafeAreaTopHeight + 50 + 15, width: kWidth-30, height: AutoGetHeight(height: 180)+40)
        self.view.addSubview(v)
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        
        
        //下拉菜单
        var dropDownViews = Bundle.main.loadNibNamed("menuView", owner: nil, options: nil) as? [UIView]
        let view1 = dropDownViews?[1] as! QRDropLeftTView
        view1.clickClosure = {[unowned self] type in
            if type == 0{
                //全部成员
                self.mySearchUserId = ""
                self.loadScheduleStatic()
            }else{
                //选择成员
               self.jumpIn()
            }
        }
        let view2 = dropDownViews?[0] as! QRDropRightView
        view2.clickClosure = {[unowned self](startTime,endTime) in
            self.myStartDate = startTime
            self.myEndDate = endTime
            self.loadScheduleStatic()
        }
        let views = [view1,view2]
        
 
        let line = UIView(frame:  CGRect(x: kWidth/2, y: 3, width: 1, height: 44))
        line.backgroundColor = kProjectBgColor
        
        
        
        if selectName==""{
            let DropDownMenu = YNDropDownMenu(frame:CGRect(x: 0, y: SafeAreaTopHeight, width: kWidth, height: 50), dropDownViews: views, dropDownViewTitles: ["全部成员", "本月"])
            
            DropDownMenu.addSubview(line)
            
            let normalImages = [UIImage(named: "j"),
                                UIImage(named: "j")]
            let selectedImages = [UIImage(named: "zkb"),
                                  UIImage(named: "zkb")]
            let disabledImages = [UIImage(named: "j"),
                                  UIImage(named: "j")]
            DropDownMenu.setStatesImages(normalImages: normalImages, selectedImages: selectedImages, disabledImages: disabledImages)
            
            DropDownMenu.setLabelFontWhen(normal: .systemFont(ofSize: 15), selected: .boldSystemFont(ofSize: 15), disabled: .systemFont(ofSize: 15))
            DropDownMenu.setLabelColorWhen(normal: .black, selected: kBlueC, disabled: .gray)
            let backgroundView = UIView()
            backgroundView.backgroundColor = .black
            DropDownMenu.blurEffectView = backgroundView
            DropDownMenu.blurEffectViewAlpha = 0.1
            self.menu = DropDownMenu
            self.view.addSubview(DropDownMenu)
            
            DropDownMenu.alwaysSelected(at: 0)
            DropDownMenu.alwaysSelected(at: 1)

        }else{
            let view = views.first as! QRDropLeftTView
            view.frame =  CGRect(x: 0, y: 0, width: 0, height: 0)
            view.removeAllSubviews()
            let DropDownMenu = YNDropDownMenu(frame:CGRect(x: 0, y: SafeAreaTopHeight, width: kWidth, height: 50), dropDownViews: views, dropDownViewTitles: [selectName, "本月"])
            DropDownMenu.addSubview(line)
            
            let normalImages = [UIImage(named: "j"),
                                UIImage(named: "j")]
            let selectedImages = [UIImage(named: "zkb"),
                                  UIImage(named: "zkb")]
            let disabledImages = [UIImage(named: "j"),
                                  UIImage(named: "j")]
            DropDownMenu.setStatesImages(normalImages: normalImages, selectedImages: selectedImages, disabledImages: disabledImages)
            
            DropDownMenu.setLabelFontWhen(normal: .systemFont(ofSize: 15), selected: .boldSystemFont(ofSize: 15), disabled: .systemFont(ofSize: 15))
            DropDownMenu.setLabelColorWhen(normal: .black, selected: kBlueC, disabled: .gray)
            let backgroundView = UIView()
            backgroundView.backgroundColor = .black
            DropDownMenu.blurEffectView = backgroundView
            DropDownMenu.blurEffectViewAlpha = 0.1
            self.menu = DropDownMenu
            self.view.addSubview(DropDownMenu)
            
            DropDownMenu.alwaysSelected(at: 0)
            DropDownMenu.alwaysSelected(at: 1)

        }
        
        self.loadScheduleStatic()
        let NotifMycation = NSNotification.Name(rawValue:"refreshAddAddressVC")
        NotificationCenter.default.addObserver(self, selector: #selector(overChange(notif:)), name: NotifMycation, object: nil)
        
        //选中状态
//        if selectName==""{
//
//        }else{
//           // self.menu?.changeMenu(title: selectName, at: 0)
//
////            let nameLabel = UILabel(title: selectName, textColor: UIColor.black, fontSize: 16)
////            nameLabel.numberOfLines = 1
////            nameLabel.frame =  CGRect(x: 0, y: 0, width: kWidth/2, height: 50)
////            nameLabel.backgroundColor = UIColor.white
////            nameLabel.textAlignment = .center
////            nameLabel.isUserInteractionEnabled = false
////            menu?.addSubview(nameLabel)
//
//        }
        
    }
    
    
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
     func jumpIn(){
//        let contact = AddressBookVC.init()
//        contact.toType = .fromContact
//        contact.scheduleModel = true
//        if self.overTimeModel != nil{
//            contact.hasSelectModelArr = [self.overTimeModel] as! [CQDepartMentUserListModel]
//        }
//        self.navigationController?.pushViewController(contact, animated: true)
        
        let contact = QRAddressBookVC.init()
        contact.toType = .fromContact
        contact.scheduleModel = true
        if self.overTimeModel != nil{
            contact.hasSelectModelArr = [self.overTimeModel] as! [CQDepartMentUserListModel]
        }
        self.navigationController?.pushViewController(contact, animated: true)
    }
    
    //接收加班人
    @objc func overChange(notif: NSNotification) {
        guard let model: CQDepartMentUserListModel = notif.object as? CQDepartMentUserListModel else { return }
        self.overTimeModel = model
        self.mySearchUserId = model.userId
        self.menu?.changeMenu(title: model.realName, at: 0)
        self.menu?.hideMenu()
        self.loadScheduleStatic()
    }
    
    func loadScheduleStatic(){
        SVProgressHUD.show()
            let userID = STUserTool.account().userID
            STNetworkTools.requestData(URLString:"\(baseUrl)/schedule/getCountSchedule" ,
                type: .get,
                param: ["userId":userID,
                        "endDate":myEndDate,
                        "searchUserId":mySearchUserId,
                        "startDate":myStartDate],
                successCallBack: { (result) in
                    
            
                    var countArr = [String]()
                    countArr.append(result["data"]["dayCount"].stringValue)
                    countArr.append(result["data"]["notSubmitDayCount"].stringValue)
                    countArr.append(result["data"]["sumCount"].stringValue)
                    let donePercent = (result["data"]["dayCount"].floatValue + result["data"]["notSubmitDayCount"].floatValue)
                    let day = result["data"]["dayCount"].floatValue
                    if day == 0 || donePercent == 0{
                        countArr.append( "0%")
                    }else if(day == donePercent){
                        countArr.append( "100%")
                    }else{
                        let done = String(format: "%.1f", day/donePercent*100)
                        countArr.append( "\(done)" + "%")
                    }
                   
                   // countArr.append(result["data"]["submitRate"].stringValue + "%")
                    self.tongjiView?.countArray = countArr
                    self.tongjiView?.collect.reloadData()
                    SVProgressHUD.dismiss()
            }) { (error) in
                    SVProgressHUD.dismiss()
            }
        
    }
    

}

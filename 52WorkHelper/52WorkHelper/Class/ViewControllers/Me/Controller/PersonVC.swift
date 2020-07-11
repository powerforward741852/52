//
//  PersonVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/4/23.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class PersonVC: SuperVC {

    var nameArr = [[String]]()
    
    var imgArr = [[String]]()
    
    var cardName = ""
    
    lazy var headView: UIImageView = {
        let headView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 180)))
        headView.image = UIImage.init(named: "PersonBg")
        headView.isUserInteractionEnabled = true
        return headView
    }()
    
    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView.init(frame: CGRect.init(x: AutoGetWidth(width: 18), y: AutoGetHeight(height: 34)+SafeAreaStateTopHeight, width: AutoGetWidth(width: 72), height: AutoGetWidth(width: 72)))
        iconImg.image = UIImage.init(named: "personDefaultIcon")
        iconImg.layer.cornerRadius = AutoGetWidth(width: 36)
        iconImg.clipsToBounds = true
        iconImg.isUserInteractionEnabled = true
        
        return iconImg
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 13), y: AutoGetHeight(height: 48.5)+SafeAreaStateTopHeight, width: kWidth/7, height: AutoGetHeight(height: 18)))
        nameLab.font = kFontSize18
        nameLab.textColor = UIColor.white
        nameLab.text = ""
        nameLab.textAlignment = .left
        return nameLab
    }()
    
    lazy var sexImg: UIImageView = {
        let sexImg = UIImageView.init(frame: CGRect.init(x:self.nameLab.right + AutoGetWidth(width: 9), y: AutoGetHeight(height: 49.75)+SafeAreaStateTopHeight, width: AutoGetWidth(width: 16.5), height: AutoGetWidth(width: 16.5)))
        sexImg.image = UIImage.init(named: "")
        return sexImg
    }()
    
    lazy var jobLab: UILabel = {
        let jobLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 13), y: self.nameLab.bottom + AutoGetHeight(height: 7), width: kWidth/5 * CGFloat(3), height: AutoGetHeight(height: 14)))
        jobLab.textAlignment = .left
        jobLab.text = ""
        jobLab.textColor = UIColor.white
        jobLab.font = kFontSize14
        return jobLab
    }()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: self.headView.bottom + AutoGetHeight(height: 8), width: kWidth, height: kHeight - AutoGetHeight(height: 188)+20 ), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.backgroundColor = UIColor.white//kProjectBgColor
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var select = false
        let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        if app.mainVC?.selectedIndex == 3 {
            select = true
        }else{
            select = false
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: select)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        self.nameArr = [["我的信息",/*"公司主页",*/"名片"],["设置","帮助与意见反馈"],["我的地址","单位发票抬头"]]
        self.imgArr = [["PersonInfo",/*"PersonCompanyIndex",*/"PersonMp"],
                       ["PersonSet","PersonHelpAndSuggust"],
                       ["PersonLocation","PersonTicket"]]
        
        self.view.backgroundColor = UIColor.white//kProjectBgColor
        self.view.addSubview(self.headView)
        self.headView.addSubview(self.iconImg)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(goToCardAction))
        iconImg.addGestureRecognizer(tap)
        self.headView.addSubview(self.nameLab)
        self.headView.addSubview(self.sexImg)
        self.headView.addSubview(self.jobLab)
        self.view.addSubview(self.table)
        self.table.register(CQPersonCell.self, forCellReuseIdentifier: "CQPersonCellId")
        self.table.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CQPersonFooter")
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeHeaderImg(notification:)), name: NSNotification.Name(rawValue: "changePersonHeaderImg"), object: nil)
        
    }
    
    @objc func goToCardAction()  {
        let vc = CQBusinessCardVC.init()
        vc.title = self.cardName + "的名片"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func changeHeaderImg(notification:Notification)  {
        self.loadData()
        self.updateUserInfo()
    }


}

extension PersonVC{
    func loadData()  {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString:"\(baseUrl)/my/index" ,
            type: .get,
            param: ["emyeId":userID],
            successCallBack: { (result) in
                guard let model = PersonModel.init(jsonData: result["data"]) else {
                    return
                }
                
                let width = self.getTexWidth(textStr: model.realName, font: kFontSize18, height: AutoGetHeight(height: 18))
                self.nameLab.frame =  CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 13), y: AutoGetHeight(height: 48.5)+SafeAreaStateTopHeight, width: width, height: AutoGetHeight(height: 18))
                self.nameLab.text = model.realName
                self.cardName = model.realName
                self.iconImg.sd_setImage(with: URL(string: model.headImage ), placeholderImage:UIImage.init(named: "personDefaultIcon"))
                self.sexImg.frame = CGRect.init(x:self.nameLab.right + AutoGetWidth(width: 9), y: AutoGetHeight(height: 49.75)+SafeAreaStateTopHeight, width: AutoGetWidth(width: 16.5), height: AutoGetWidth(width: 16.5))
                self.jobLab.frame = CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 13), y: self.nameLab.bottom + AutoGetHeight(height: 7), width: kWidth/5 * CGFloat(3), height: AutoGetHeight(height: 14))
                if model.employeeSex == "男"{
                    self.sexImg.image = UIImage.init(named: "PersonSex")
                }else
                {
                    self.sexImg.image = UIImage.init(named: "girl")
                }
                
                
                self.jobLab.text =  model.positionName
                
                UserDefaults.standard.set(result["data"]["headImage"].stringValue, forKey: "headImage")
        }) { (error) in
            self.table.reloadData()
            
        }
    }
    
    func updateUserInfo()  {
        STNetworkTools.requestData(URLString: "\(baseUrl)/mailList/updateUserInfo",
            type: .get,
            param: ["userId":STUserTool.account().userID],
            successCallBack: { (result) in
                NotificationCenter.default.post(name: NSNotification.Name.init("refreshChatInfo"), object: nil)
        }) { (error) in
        }
    }
}

extension PersonVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nameArr[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQPersonCellId") as! CQPersonCell
        cell.accessoryType = .disclosureIndicator
        cell.iconBtn.setImage(UIImage.init(named: self.imgArr[indexPath.section][indexPath.row]), for: .normal)
        cell.nameLab.text = self.nameArr[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if 0 == indexPath.section && 0 == indexPath.row{
            let vc = CQPersonInfoVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if 0 == indexPath.section && 1 == indexPath.row{
            let vc = CQBusinessCardVC.init()
            vc.title = self.cardName + "的名片"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if 1 == indexPath.section && 0 == indexPath.row{
            let vc = CQSetVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if 1 == indexPath.section && 1 == indexPath.row{
            let vc = CQHelperVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if 2 == indexPath.section && 0 == indexPath.row{
            let vc = CQMyAddressVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if 2 == indexPath.section && 1 == indexPath.row{
            let vc = CQInvoiceVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoGetHeight(height: 55)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return AutoGetHeight(height: 13)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        
        footer.backgroundColor = kProjectBgColor
        
        return footer
    }
    
    
}

extension PersonVC{
    //计算宽度
    func getTexWidth(textStr:String,font:UIFont,height:CGFloat) -> CGFloat {
        
        let normalText: String = textStr
        
        let size = CGSize.init(width: 1000, height: height)
        
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context:nil).size
        
        return stringSize.width
        
    }
}

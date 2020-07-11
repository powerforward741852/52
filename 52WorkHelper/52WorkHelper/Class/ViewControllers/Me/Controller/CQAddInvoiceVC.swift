//
//  CQAddInvoiceVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/4.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

/// 发票编辑类型枚举
enum InvoiceFrom {
    case add
    case update
    case del
}

class CQAddInvoiceVC: SuperVC {


    var type:InvoiceFrom?
    var entityId = ""
    var invoiceType = ""
    var rightBtn:UIButton?
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y:0 + AutoGetHeight(height: 13), width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        table.backgroundColor = UIColor.colorWithHexString(hex: "#f7f7f7")
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 0), width: kWidth, height: AutoGetHeight(height: 417)))
        headView.backgroundColor = UIColor.white
        return headView
    }()
    
    lazy var invoiceTypleLab: UILabel = {
        let invoiceTypleLab = UILabel.init(frame: CGRect.init(x:kLeftDis, y: 0, width: AutoGetWidth(width: 65), height: AutoGetHeight(height: 55)))
        invoiceTypleLab.textColor = UIColor.black
        invoiceTypleLab.text = "抬头类型"
        invoiceTypleLab.textAlignment = .left
        invoiceTypleLab.font = kFontSize15
        return invoiceTypleLab
    }()
    
    lazy var invoiceTypleBtn: UIButton = {
        let invoiceTypleBtn = UIButton.init(type: .custom)
        invoiceTypleBtn.frame = CGRect.init(x: self.invoiceTypleLab.right + kLeftDis, y: 0, width: kWidth - AutoGetWidth(width: 110) - AutoGetWidth(width: 38), height: AutoGetHeight(height: 55))
        invoiceTypleBtn.setTitle("个人", for: .normal)
        invoiceTypleBtn.setTitleColor(kLyGrayColor, for: .normal)
        invoiceTypleBtn.titleLabel?.textAlignment = .left
        invoiceTypleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -(kWidth-AutoGetWidth(width: 110)-AutoGetWidth(width: 38))/2 + 20, 0, (kWidth-AutoGetWidth(width: 110)-AutoGetWidth(width: 38))/2 - 20)
        invoiceTypleBtn.titleLabel?.font = kFontSize15
        invoiceTypleBtn.addTarget(self, action: #selector(invoiceClick), for: .touchUpInside)
        return invoiceTypleBtn
    }()
    
    lazy var arrowBtn:UIButton = {
        let arrowBtn = UIButton.init(type: .custom)
        arrowBtn.frame = CGRect.init(x: kWidth-AutoGetWidth(width: 36.5), y: 0, width: AutoGetWidth(width: 36.5), height: AutoGetHeight(height: 55))
        arrowBtn.setImage(UIImage.init(named: "PersonAddressArrow"), for: .normal)
        return arrowBtn
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x:kLeftDis, y: self.invoiceTypleLab.bottom, width: AutoGetWidth(width: 65), height: AutoGetHeight(height: 55)))
        nameLab.textColor = UIColor.black
        nameLab.text = "名称"
        nameLab.textAlignment = .left
        nameLab.font = kFontSize15
        return nameLab
    }()
    
    lazy var nameField: MyTextField = {
        let nameField = MyTextField.init(frame: CGRect.init(x: self.nameLab.right + kLeftDis, y: self.invoiceTypleLab.bottom, width: kWidth - AutoGetWidth(width: 110) - AutoGetWidth(width: 38), height: AutoGetHeight(height: 55)))
        nameField?.delegate = self
        nameField?.clearButtonMode = .never
        nameField?.keyBoardDelegate = self
        nameField?.font = kFontSize15
        nameField?.textColor = UIColor.black
        nameField?.tintColor = UIColor.black
        nameField?.placeholder = " 单位名称（必填）"
        nameField?.keyboardType = .default
        
        return nameField!
    }()
    
    lazy var taxNumLab: UILabel = {
        let taxNumLab = UILabel.init(frame: CGRect.init(x:kLeftDis, y: self.nameLab.bottom, width: AutoGetWidth(width: 65), height: AutoGetHeight(height: 55)))
        taxNumLab.textColor = UIColor.black
        taxNumLab.text = "税号"
        taxNumLab.textAlignment = .left
        taxNumLab.font = kFontSize15
        return taxNumLab
    }()
    
    lazy var taxNumField: MyTextField = {
        let taxNumField = MyTextField.init(frame: CGRect.init(x: self.nameLab.right + kLeftDis, y: self.nameLab.bottom, width: kWidth - AutoGetWidth(width: 110) - AutoGetWidth(width: 38), height: AutoGetHeight(height: 55)))
        taxNumField?.delegate = self
        taxNumField?.clearButtonMode = .never
        taxNumField?.keyBoardDelegate = self
        taxNumField?.font = kFontSize15
        taxNumField?.textColor = UIColor.black
        taxNumField?.tintColor = UIColor.black
        taxNumField?.placeholder = " 纳税人识别号"
        taxNumField?.keyboardType = .default
        
        return taxNumField!
    }()
    
    lazy var telNumLab: UILabel = {
        let telNumLab = UILabel.init(frame: CGRect.init(x:kLeftDis, y: self.taxNumLab.bottom, width: AutoGetWidth(width: 65), height: AutoGetHeight(height: 55)))
        telNumLab.textColor = UIColor.black
        telNumLab.text = "电话号码"
        telNumLab.textAlignment = .left
        telNumLab.font = kFontSize15
        return telNumLab
    }()
    
    lazy var telNumField: MyTextField = {
        let telNumField = MyTextField.init(frame: CGRect.init(x: self.nameLab.right + kLeftDis, y: self.taxNumLab.bottom, width: kWidth - AutoGetWidth(width: 110) - AutoGetWidth(width: 38), height: AutoGetHeight(height: 55)))
        telNumField?.delegate = self
        telNumField?.clearButtonMode = .never
        telNumField?.keyBoardDelegate = self
        telNumField?.font = kFontSize15
        telNumField?.textColor = UIColor.black
        telNumField?.tintColor = UIColor.black
        telNumField?.placeholder = " 电话号码"
        telNumField?.keyboardType = .numberPad
        
        return telNumField!
    }()
    
    lazy var companyLocLab: UILabel = {
        let companyLocLab = UILabel.init(frame: CGRect.init(x:kLeftDis, y: self.telNumLab.bottom, width: AutoGetWidth(width: 65), height: AutoGetHeight(height: 55)))
        companyLocLab.textColor = UIColor.black
        companyLocLab.text = "单位地址"
        companyLocLab.textAlignment = .left
        companyLocLab.font = kFontSize15
        return companyLocLab
    }()
    
    lazy var companyLocTextView: CBTextView = {
        let companyLocTextView = CBTextView.init(frame: CGRect.init(x: self.nameLab.right + kLeftDis, y: self.telNumLab.bottom, width: kWidth - AutoGetWidth(width: 110) - AutoGetWidth(width: 38), height: AutoGetHeight(height: 87)))
        companyLocTextView.aDelegate = self
        companyLocTextView.textView.backgroundColor = UIColor.white
        companyLocTextView.textView.font = UIFont.systemFont(ofSize: 15)
        companyLocTextView.textView.textColor = UIColor.black
        
        companyLocTextView.placeHolder = "单位地址信息"
        companyLocTextView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        
        return companyLocTextView
    }()
    
    lazy var BankNameLab: UILabel = {
        let BankNameLab = UILabel.init(frame: CGRect.init(x:kLeftDis, y: self.companyLocTextView.bottom, width: AutoGetWidth(width: 65), height: AutoGetHeight(height: 55)))
        BankNameLab.textColor = UIColor.black
        BankNameLab.text = "开户银行"
        BankNameLab.textAlignment = .left
        BankNameLab.font = kFontSize15
        return BankNameLab
    }()
    
    lazy var BankNameField: MyTextField = {
        let BankNameField = MyTextField.init(frame: CGRect.init(x: self.nameLab.right + kLeftDis, y: self.companyLocTextView.bottom, width: kWidth - AutoGetWidth(width: 110) - AutoGetWidth(width: 38), height: AutoGetHeight(height: 55)))
        BankNameField?.delegate = self
        BankNameField?.clearButtonMode = .never
        BankNameField?.keyBoardDelegate = self
        BankNameField?.font = kFontSize15
        BankNameField?.textColor = UIColor.black
        BankNameField?.tintColor = UIColor.black
        BankNameField?.placeholder = " 开户银行名称"
        BankNameField?.keyboardType = .default
        
        return BankNameField!
    }()
    
    lazy var BankNumLab: UILabel = {
        let BankNumLab = UILabel.init(frame: CGRect.init(x:kLeftDis, y: self.BankNameLab.bottom, width: AutoGetWidth(width: 65), height: AutoGetHeight(height: 55)))
        BankNumLab.textColor = UIColor.black
        BankNumLab.text = "银行账户"
        BankNumLab.textAlignment = .left
        BankNumLab.font = kFontSize15
        return BankNumLab
    }()
    
    lazy var BankNumField: MyTextField = {
        let BankNumField = MyTextField.init(frame: CGRect.init(x: self.nameLab.right + kLeftDis, y: self.BankNameLab.bottom, width: kWidth - AutoGetWidth(width: 110) - AutoGetWidth(width: 38), height: AutoGetHeight(height: 55)))
        BankNumField?.delegate = self
        BankNumField?.clearButtonMode = .never
        BankNumField?.keyBoardDelegate = self
        BankNumField?.font = kFontSize15
        BankNumField?.textColor = UIColor.black
        BankNumField?.tintColor = UIColor.black
        BankNumField?.placeholder = " 银行账户号码"
        BankNumField?.keyboardType = .numberPad
        
        return BankNumField!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if type == .add{
            self.title = "添加抬头发票"
            rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
            rightBtn?.sizeToFit()
            rightBtn?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
            rightBtn?.setTitle("保存", for: .normal)
            rightBtn?.setTitleColor(UIColor.colorWithHexString(hex: "#20afff"), for: .normal)
            rightBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            rightBtn?.addTarget(self, action: #selector(storeClick), for: .touchUpInside)
            let rightItem = UIBarButtonItem.init(customView: rightBtn!)
            self.navigationItem.rightBarButtonItem = rightItem
        }else if type == .update{
            self.title = "更新抬头发票"
            self.loadDetailDatas()
            rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
            rightBtn?.setTitle("修改", for: .normal)
            rightBtn?.sizeToFit()
            rightBtn?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
            rightBtn?.setTitleColor(UIColor.colorWithHexString(hex: "#20afff"), for: .normal)
            rightBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            rightBtn?.addTarget(self, action: #selector(storeClick), for: .touchUpInside)
            let rightItem = UIBarButtonItem.init(customView: rightBtn!)
            self.navigationItem.rightBarButtonItem = rightItem
        }
//        else{
//            self.title = "删除抬头发票"
//        }
        
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.invoiceTypleLab)
        self.headView.addSubview(self.invoiceTypleBtn)
        self.headView.addSubview(self.arrowBtn)
        self.headView.addSubview(self.nameLab)
        self.headView.addSubview(self.nameField)
        self.headView.addSubview(self.taxNumLab)
        self.headView.addSubview(self.taxNumField)
        self.headView.addSubview(self.telNumLab)
        self.headView.addSubview(self.telNumField)
        self.headView.addSubview(self.companyLocLab)
        self.headView.addSubview(self.companyLocTextView)
        self.headView.addSubview(self.BankNameLab)
        self.headView.addSubview(self.BankNameField)
        self.headView.addSubview(self.BankNumLab)
        self.headView.addSubview(self.BankNumField)
        if  self.invoiceType == "1" {
            self.taxNumLab.isHidden = true
            self.taxNumField.isHidden = true
            self.telNumLab.isHidden = true
            self.telNumField.isHidden = true
            self.companyLocLab.isHidden = true
            self.companyLocTextView.isHidden = true
            self.BankNameLab.isHidden = true
            self.BankNameField.isHidden = true
            self.BankNumLab.isHidden = true
            self.BankNumField.isHidden = true
            self.invoiceTypleBtn.setTitle("个人", for: .normal)
            self.invoiceTypleBtn.setTitleColor(UIColor.black, for: .normal)
            self.invoiceType = "1"
            self.headView.frame = CGRect.init(x: 0, y: AutoGetHeight(height: 0), width: kWidth, height: AutoGetHeight(height: 110))
        }else if self.invoiceType == "2"{
            self.taxNumLab.isHidden = false
            self.taxNumField.isHidden = false
            self.telNumLab.isHidden = false
            self.telNumField.isHidden = false
            self.companyLocLab.isHidden = false
            self.companyLocTextView.isHidden = false
            self.BankNameLab.isHidden = false
            self.BankNameField.isHidden = false
            self.BankNumLab.isHidden = false
            self.BankNumField.isHidden = false
            self.invoiceTypleBtn.setTitle("单位", for: .normal)
            self.invoiceTypleBtn.setTitleColor(UIColor.black, for: .normal)
            self.invoiceType = "2"
            self.headView.frame = CGRect.init(x: 0, y: AutoGetHeight(height: 0), width: kWidth, height: AutoGetHeight(height: 417))
        }else{
            self.taxNumLab.isHidden = true
            self.taxNumField.isHidden = true
            self.telNumLab.isHidden = true
            self.telNumField.isHidden = true
            self.companyLocLab.isHidden = true
            self.companyLocTextView.isHidden = true
            self.BankNameLab.isHidden = true
            self.BankNameField.isHidden = true
            self.BankNumLab.isHidden = true
            self.BankNumField.isHidden = true
            self.invoiceTypleBtn.setTitle("个人", for: .normal)
            self.invoiceType = "1"
            self.headView.frame = CGRect.init(x: 0, y: AutoGetHeight(height: 0), width: kWidth, height: AutoGetHeight(height: 110))
        }
        
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEditChanged(obj:)), name: Notification.Name.UITextViewTextDidChange, object: nil)
    }
    
    @objc func storeClick()  {
        if (self.nameField.text?.count)! > 0{
            self.addInvoiceRequest()
        }else{
            SVProgressHUD.showInfo(withStatus: "请输入单位名称")
        }
      
    }

    @objc func invoiceClick()  {
        let alertVC = UIAlertController.init(title: "选择类别", message: "请选择发票类别", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction.init(title: "个人", style: .default) { (action) in
            self.invoiceTypleBtn.setTitle("个人", for: .normal)
            self.invoiceTypleBtn.setTitleColor(UIColor.black, for: .normal)
            self.nameField.placeholder = "个人名称(必填)"
            self.taxNumLab.isHidden = true
            self.taxNumField.isHidden = true
            self.telNumLab.isHidden = true
            self.telNumField.isHidden = true
            self.companyLocLab.isHidden = true
            self.companyLocTextView.isHidden = true
            self.BankNameLab.isHidden = true
            self.BankNameField.isHidden = true
            self.BankNumLab.isHidden = true
            self.BankNumField.isHidden = true
            self.invoiceType = "1"
            self.headView.frame = CGRect.init(x: 0, y: AutoGetHeight(height: 0), width: kWidth, height: AutoGetHeight(height: 110))
        }
        let okAction = UIAlertAction.init(title: "单位", style: .default) { (action) in
            self.invoiceTypleBtn.setTitle("单位", for: .normal)
            self.invoiceTypleBtn.setTitleColor(UIColor.black, for: .normal)
            self.nameField.placeholder = "单位名称(必填)"
            self.taxNumLab.isHidden = false
            self.taxNumField.isHidden = false
            self.telNumLab.isHidden = false
            self.telNumField.isHidden = false
            self.companyLocLab.isHidden = false
            self.companyLocTextView.isHidden = false
            self.BankNameLab.isHidden = false
            self.BankNameField.isHidden = false
            self.BankNumLab.isHidden = false
            self.BankNumField.isHidden = false
            self.invoiceType = "2"
            self.headView.frame = CGRect.init(x: 0, y: AutoGetHeight(height: 0), width: kWidth, height: AutoGetHeight(height: 417))
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }

}

// Mark :添加发票请求
extension CQAddInvoiceVC{
    func addInvoiceRequest()  {
        SVProgressHUD.show()
        let userID = STUserTool.account().userID
        var opt = ""
        if type == .add {
            opt = "add"
        }else if type == .update{
            opt = "update"
        }
        
        STNetworkTools.requestData(URLString: "\(baseUrl)/my/updateMyInvoice",
            type: .post,
            param: ["emyeId":userID,
                    "accountBank":self.BankNameField.text ?? "",
                    "accountNumber":self.BankNumField.text ?? "",
                    "companyAddress":self.companyLocTextView.prevText ?? "",
                    "invoiceName":self.nameField.text ?? "",
                    "invoiceNumber":self.taxNumField.text ?? "",
                    "invoiceType":self.invoiceType,
                    "opt":opt,
                    "phoneNumber":self.telNumField.text ?? "",
                    "entityId":self.entityId],
            successCallBack: { (result) in
                SVProgressHUD.dismiss()
                SVProgressHUD.showInfo(withStatus: "添加成功")
                self.navigationController?.popViewController(animated: true)
        }) { (error) in
            SVProgressHUD.dismiss()
        }
    }
    
    //编辑
    fileprivate func loadDetailDatas() {
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/my/getMyInvoiceInfo" ,
            type: .get,
            param: ["entityId":self.entityId],
            successCallBack: { (result) in
                guard let model = CQInvoiceModel.init(jsonData: result["data"]) else {
                    return
                }
                self.nameField.text = model.invoiceName
                self.taxNumField.text = model.invoiceNumber
                self.companyLocTextView.prevText = model.companyAddress
                self.telNumField.text = model.phoneNumber
                self.BankNameField.text = model.accountBank
                self.BankNumField.text = model.accountNumber
        }) { (error) in
            
        }
    }
}

extension CQAddInvoiceVC:UITextFieldDelegate,KeyBoardDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    @objc func textFieldEditChanged(obj:Notification)  {
        
    }
    
    
}

extension CQAddInvoiceVC:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
}

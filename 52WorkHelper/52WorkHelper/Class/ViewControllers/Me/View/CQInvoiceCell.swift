//
//  CQInvoiceCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/7/11.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol CQInvoiceEditDelegate : NSObjectProtocol{
    func editWithInvoiceType(index:IndexPath)
}

class CQInvoiceCell: UITableViewCell {

    weak var editingDelegate:CQInvoiceEditDelegate?
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 19), width: kWidth - 2 * kLeftDis, height: AutoGetHeight(height: 15)))
        nameLab.font = kFontSize15
        nameLab.text = ""
        nameLab.textAlignment = .left
        nameLab.textColor = UIColor.black
        return nameLab
    }()
    
    lazy var invoiceLab: UILabel = {
        let invoiceLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.nameLab.bottom + AutoGetHeight(height: 8), width:kWidth - 2 * kLeftDis, height: AutoGetHeight(height: 12)))
        invoiceLab.font = kFontSize12
        invoiceLab.text = ""
        invoiceLab.textAlignment = .left
        invoiceLab.textColor = kLyGrayColor
        return invoiceLab
    }()
    
    lazy var editBtn: UIButton = {
        let editBtn = UIButton.init(type: .custom)
        editBtn.frame = CGRect.init(x: kWidth - AutoGetWidth(width: 48), y: 0, width: AutoGetWidth(width: 48), height: AutoGetHeight(height: 73))
        editBtn.setImage(UIImage.init(named: "PersonAddressEdit"), for: .normal)
        editBtn.addTarget(self, action: #selector(editClick(sender:)), for: .touchUpInside)
        return editBtn
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUp()  {
        self.addSubview(self.nameLab)
        self.addSubview(self.invoiceLab)
        self.addSubview(self.editBtn)
    }
    
    @objc func editClick(sender: AnyObject)  {
        let btn = sender as! UIButton
        let cell = btn.superviewOfClassType(UITableViewCell.self)
        let table:UITableView = self.superviewOfClassType(UITableView.self) as! UITableView
        let indexPath = table.indexPath(for: cell as! UITableViewCell)
        if self.editingDelegate != nil {
            self.editingDelegate?.editWithInvoiceType(index:indexPath!)
        }
    }
    
    
    
    //定义模型属性
    var model: CQInvoiceModel? {
        didSet {
            
            self.nameLab.text = model?.invoiceName
            if  model?.invoiceType == "1" {
                self.invoiceLab.text = "个人"
            }else{
                self.invoiceLab.text = "单位"
            }
        }
    }
}

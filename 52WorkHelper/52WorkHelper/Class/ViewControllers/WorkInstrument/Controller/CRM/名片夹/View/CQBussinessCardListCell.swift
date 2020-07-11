//
//  CQBussinessCardListCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2019/1/11.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

protocol ShowBtnDelegate : NSObjectProtocol{
    func showChooseClick(index:IndexPath ,but: UIButton)
}

class CQBussinessCardListCell: UITableViewCell {

    weak var showDelegate:ShowBtnDelegate?
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var positionLab: UILabel!
    @IBOutlet weak var locationLab: UILabel!
    @IBOutlet weak var chooseBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        iconImg.image = UIImage.init(named: "CQBussDefault")
        locationLab.textColor = UIColor.colorWithHexString(hex: "#515151")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func chooseClick(_ sender: UIButton) {
        let btn = sender
        let cell = superUITableViewCell(of: btn)
        let table = superUITableView(of: btn)
        let index = table?.indexPath(for: cell!)
        DLog(index)
        
        if self.showDelegate != nil{
            self.showDelegate?.showChooseClick(index: index!,but: sender)
        }
    }
    
    //返回button所在的UITableViewCell
    func superUITableViewCell(of: UIButton) -> UITableViewCell? {
        for view in sequence(first: of.superview, next: { $0?.superview }) {
            if let cell = view as? UITableViewCell {
                return cell
            }
        }
        return nil
    }
    
    //返回button所在的UITableView
    func superUITableView(of: UIButton) -> UITableView? {
        for view in sequence(first: of.superview, next: { $0?.superview }) {
            if let table = view as? UITableView {
                return table
            }
        }
        return nil
    }
    
    
    //定义模型属性
    var model: CQBussinessCardListModel? {
        didSet {
            self.iconImg.sd_setImage(with: URL(string: model?.frontPhoto ?? "" ), placeholderImage:UIImage.init(named: "CQBussDefault") )
            self.nameLab.text = model?.realName
            self.positionLab.text = model?.position
            self.locationLab.text = model?.company
            
        }
    }
    //
    var otherModel: QRCardInfoModel? {
        didSet {
            self.iconImg.sd_setImage(with: URL(string: otherModel?.frontPhoto ?? "" ), placeholderImage:UIImage.init(named: "CQBussDefault") )
            self.nameLab.text = otherModel?.realName
            self.positionLab.text = otherModel?.position.first
            self.locationLab.text = otherModel?.company.first
            if let img = otherModel?.frontImg{
                self.iconImg.image = img
            }
        }
    }
}

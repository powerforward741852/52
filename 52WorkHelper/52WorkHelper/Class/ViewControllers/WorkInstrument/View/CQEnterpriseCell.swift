//
//  CQEnterpriseCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/2.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol CQEnterpriseSelectDelegate : NSObjectProtocol{
    func selectIndex(index:IndexPath)
}

class CQEnterpriseCell: UITableViewCell {

    weak var selectDelegate:CQEnterpriseSelectDelegate?
    var selectStatus:Bool?
    
    lazy var chooseBtn: UIButton = {
        let chooseBtn = UIButton.init(type: .custom)
        chooseBtn.frame = CGRect.init(x: 0, y: AutoGetHeight(height: 0), width: AutoGetWidth(width: 55), height: AutoGetWidth(width: 55))
        chooseBtn.setBackgroundImage(UIImage.init(named: ""), for: .normal)
        chooseBtn.addTarget(self, action: #selector(chooseClick(sender:)), for: .touchUpInside)
        return chooseBtn
    }()
    
    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView.init(frame: CGRect.init(x: self.chooseBtn.right + AutoGetWidth(width: 0), y: AutoGetHeight(height: 9), width: AutoGetWidth(width: 30), height: AutoGetHeight(height: 37)))
        iconImg.image = UIImage.init(named: "EnterpriseWord")
        return iconImg
    }()
    
    lazy var docNameLab: UILabel = {
        let docNameLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 5), y: AutoGetHeight(height: 11.5), width: kWidth/2, height: AutoGetHeight(height: 16)))
        docNameLab.text = "公司规则制度.doc"
        docNameLab.textAlignment = .left
        docNameLab.textColor = UIColor.black
        docNameLab.font = kFontSize16
        return docNameLab
    }()
    
    lazy var masterNameAndDateLab: UILabel = {
        let masterNameAndDateLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 5), y:self.docNameLab.bottom + AutoGetHeight(height: 5), width: kWidth/2, height: AutoGetHeight(height: 12)))
        masterNameAndDateLab.text = "王费 2018-03-02"
        masterNameAndDateLab.textAlignment = .left
        masterNameAndDateLab.textColor = kLyGrayColor
        masterNameAndDateLab.font = kFontSize12
        return masterNameAndDateLab
    }()
    
    lazy var sizeLab: UILabel = {
        let sizeLab = UILabel.init(frame: CGRect.init(x: kWidth - AutoGetHeight(height: 85), y: AutoGetHeight(height: 0), width: AutoGetWidth(width: 70), height: AutoGetHeight(height: 64)))
        sizeLab.text = "1.2M"
        sizeLab.textAlignment = .right
        sizeLab.textColor = kLyGrayColor
        sizeLab.font = kFontSize16
        sizeLab.adjustsFontSizeToFitWidth = true
        return sizeLab
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
        self.addSubview(chooseBtn)
        self.addSubview(iconImg)
        self.addSubview(docNameLab)
        self.addSubview(masterNameAndDateLab)
        self.addSubview(sizeLab)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if selectStatus == true{
            self.chooseBtn.setImage(UIImage.init(named: "MessageGroupSelect"), for: .normal)
        }else{
            self.chooseBtn.setImage(UIImage.init(named: "MessageGroupNotSelect"), for: .normal)
        }
    }
    
    @objc func chooseClick(sender:AnyObject)  {
        let btn = sender as! UIButton
        let cell = superUITableViewCell(of: btn)
        let table = superUITableView(of: btn)
        let index = table?.indexPath(for: cell!)
        DLog(index)
        
        if self.selectDelegate != nil {
            self.selectDelegate?.selectIndex(index: index!)
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
    var model: CQEnterpriseInfoModel? {
        didSet {
            self.iconImg.sd_setImage(with: URL(string: model?.suffixImgUrl ?? ""), placeholderImage:UIImage.init(named: "EnterpriseWord") )
            self.docNameLab.text = model?.name
            self.masterNameAndDateLab.text = "" + model!.createDate
            self.sizeLab.text = model?.attachmentSize
        }
    }
    
}

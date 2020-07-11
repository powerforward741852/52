//
//  CQAdressBookCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/2.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol cellSelectDelegate : NSObjectProtocol{
    func pushToTable(index:IndexPath)
}

class CQAdressBookCell: UITableViewCell {

    var selectStatus:Bool?
    
    weak var cellSelDelegate:cellSelectDelegate?
    lazy var selectBtn: UIButton = {
        let selectBtn = UIButton.init(type: .custom)
        selectBtn.frame = CGRect.init(x: AutoGetWidth(width: 5), y: 0, width: AutoGetWidth(width: 39), height: AutoGetHeight(height: 55))
        selectBtn.setImage(UIImage.init(named: ""), for: .normal)
        selectBtn.addTarget(self, action: #selector(selectUser(sender:)), for: .touchUpInside)
        selectBtn.isHidden = true
        return selectBtn
    }()
    
    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 7.5), width: AutoGetWidth(width: 40), height: AutoGetWidth(width: 40)))
        iconImg.image = UIImage.init(named: "personDefaultIcon")
        iconImg.layer.cornerRadius = AutoGetWidth(width: 20)
        iconImg.clipsToBounds = true
        return iconImg
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + kLeftDis, y: AutoGetHeight(height: 11), width: kWidth/2, height: AutoGetHeight(height: 16)))
        nameLab.text = "Alans"
        nameLab.textAlignment = .left
        nameLab.textColor = UIColor.black
        nameLab.font = kFontSize16
        return nameLab
    }()
    
    lazy var jobLab: UILabel = {
        let jobLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + kLeftDis, y:self.nameLab.bottom + AutoGetHeight(height: 5), width: kWidth/2, height: AutoGetHeight(height: 12)))
        jobLab.text = "战略研发部"
        jobLab.textAlignment = .left
        jobLab.textColor = kLyGrayColor
        jobLab.font = kFontSize12
        return jobLab
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if selectStatus == true{
            self.selectBtn.setImage(UIImage.init(named: "MessageGroupSelect"), for: .normal)
        }else{
            self.selectBtn.setImage(UIImage.init(named: "MessageGroupNotSelect"), for: .normal)
        }
    }
    
    func setUp() {
        
        self.addSubview(selectBtn)
        
        self.addSubview(iconImg)
        self.addSubview(nameLab)
        self.addSubview(jobLab)
    }
    
    @objc func selectUser(sender:AnyObject)  {
        let btn = sender as! UIButton
        let cell = superUITableViewCell(of: btn)
        let table = superUITableView(of: btn)
        let index = table?.indexPath(for: cell!)
        DLog(index)
        
        if self.cellSelDelegate != nil {
            self.cellSelDelegate?.pushToTable(index: index!)
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
    var model: CQDepartMentUserListModel? {
        didSet {
            self.iconImg.sd_setImage(with: URL(string: model?.headImage ?? ""), placeholderImage:UIImage.init(named: "personDefaultIcon") )
            self.nameLab.text = model?.realName
            self.jobLab.text = model?.positionName //model?.departmentName
        }
    }
    
    //定义模型属性
    var contactModel: CQTopContactModel? {
        didSet {
            self.iconImg.sd_setImage(with: URL(string: model?.headImage ?? ""), placeholderImage:UIImage.init(named: "personDefaultIcon") )
            self.nameLab.text = model?.realName
            self.jobLab.text = model?.positionName
        }
    }

}

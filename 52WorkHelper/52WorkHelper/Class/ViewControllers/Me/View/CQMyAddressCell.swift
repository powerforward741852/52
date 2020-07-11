//
//  CQMyAddressCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/4.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit
protocol CQEditAddressDelegate : NSObjectProtocol{
    func pushToDetailVC(index:IndexPath)
}


class CQMyAddressCell: UITableViewCell {

    weak var editDelegate:CQEditAddressDelegate?
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 18), width: kWidth/2, height: AutoGetHeight(height: 15)))
        nameLab.font = kFontSize15
        nameLab.textColor = UIColor.black
        nameLab.textAlignment = .left
        nameLab.text = ""
        return nameLab
    }()
    
    lazy var locationImg: UIImageView = {
        let locationImg = UIImageView.init(frame: CGRect.init(x: kLeftDis, y: self.nameLab.bottom + AutoGetHeight(height: 9), width: AutoGetWidth(width: 10.5), height: AutoGetHeight(height: 13.5)))
        locationImg.image = UIImage.init(named: "PersonAddressLocation")
        return locationImg
    }()
    
    lazy var locationLab: UILabel = {
        let locationLab = UILabel.init(frame: CGRect.init(x: self.locationImg.right + AutoGetWidth(width: 7), y:self.nameLab.bottom + AutoGetHeight(height:9.5), width: kWidth/3 * CGFloat(2), height: AutoGetHeight(height: 13)))
        locationLab.font = kFontSize13
        locationLab.textColor = kLyGrayColor
        locationLab.textAlignment = .left
        locationLab.text = "厦门市湖里区金山街道万达广场"
        return locationLab
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
        self.addSubview(self.locationImg)
        self.addSubview(self.locationLab)
        self.addSubview(self.editBtn)
    }
    
    @objc func editClick(sender: AnyObject)  {
        let btn = sender as! UIButton
        let cell = btn.superviewOfClassType(UITableViewCell.self)
        let table:UITableView = self.superviewOfClassType(UITableView.self) as! UITableView
        let indexPath = table.indexPath(for: cell as! UITableViewCell)
        if self.editDelegate != nil {
            self.editDelegate?.pushToDetailVC(index: indexPath!)
        }
    }
    
    
    
    //定义模型属性
    var model: CQAddressModel? {
        didSet {
            
            self.nameLab.text = model?.contactName
            self.locationLab.text = model?.address
        }
    }


}

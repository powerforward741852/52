//
//  CQRankCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/4/27.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit
protocol CQRankZanDelegate : NSObjectProtocol{
    func refreshUIWithZan(index:IndexPath)
}


class CQRankCell: UITableViewCell {

    weak var zanDelegate:CQRankZanDelegate?
    
    lazy var rankLab: UILabel = {
        let rankLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: AutoGetWidth(width: 30), height: AutoGetHeight(height: 55)))
        rankLab.text = "1"
        rankLab.textAlignment = .left
        rankLab.textColor = kLyGrayColor
        rankLab.font = kFontSize17
        rankLab.adjustsFontSizeToFitWidth = true
        return rankLab
    }()
    
    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView.init(frame: CGRect.init(x: self.rankLab.right + AutoGetWidth(width: 7), y: AutoGetHeight(height: 7.5), width: AutoGetWidth(width: 40), height: AutoGetWidth(width: 40)))
        iconImg.image = UIImage.init(named: "personDefaultIcon")
        iconImg.layer.cornerRadius = AutoGetWidth(width: 20)
        iconImg.clipsToBounds = true
        return iconImg
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + kLeftDis, y: 0, width: AutoGetHeight(height: 80), height: AutoGetHeight(height: 55)))
        nameLab.text = "Alans"
        nameLab.textAlignment = .left
        nameLab.textColor = UIColor.black
        nameLab.font = kFontSize16
        return nameLab
    }()
    
    lazy var timeLab: UILabel = {
        let timeLab = UILabel.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 140), y: 0, width: AutoGetWidth(width: 95), height: AutoGetHeight(height: 55)))
        timeLab.textAlignment = .right
        timeLab.textColor = UIColor.colorWithHexString(hex: "#f89800")
        timeLab.font = kFontSize15
        return timeLab
    }()
    
    lazy var zanCountLab: UILabel = {
        let zanCountLab = UILabel.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 45), y: AutoGetHeight(height: 7.5), width: AutoGetWidth(width: 30), height: AutoGetHeight(height: 12)))
        zanCountLab.text = "1"
        zanCountLab.textAlignment = .right
        zanCountLab.textColor = kLyGrayColor
        zanCountLab.font = kFontSize12
        return zanCountLab
    }()
    
    lazy var zanBtn: UIButton = {
        let zanBtn = UIButton.init(type: .custom)
        zanBtn.frame = CGRect.init(x: kWidth - AutoGetWidth(width: 30), y: AutoGetHeight(height: 0) , width: AutoGetWidth(width: 30), height: AutoGetWidth(width: 55))
        zanBtn.imageEdgeInsets = UIEdgeInsets.init(top: AutoGetHeight(height: 23.5), left:  -AutoGetWidth(width: 7.5), bottom: 0, right: 0)
        zanBtn.addTarget(self, action: #selector(zanClick(btn:)), for: .touchUpInside)
        return zanBtn
    }()
    
    lazy var tapImage: UIImageView = {
        let tapImage = UIImageView.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 30), y: 0, width: AutoGetWidth(width: 30), height: AutoGetHeight(height: 55)))
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(zanClick(btn:)))
        tapImage.addGestureRecognizer(tap)
        return tapImage
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    
    func setUp()  {
        self.backgroundColor = UIColor.white
        
        self.addSubview(self.rankLab)
        self.addSubview(self.iconImg)
        self.addSubview(self.nameLab)
        self.addSubview(self.timeLab)
        self.addSubview(self.zanCountLab)
        self.addSubview(self.zanBtn)
        self.addSubview(self.tapImage)
        
    }
    
    @objc func zanClick(btn:UIButton)  {
    let cell = superUITableViewCell(of: btn)
    let table = superUITableView(of: btn)
    let index = table?.indexPath(for: cell!)
    DLog(index)
    
    if self.zanDelegate != nil {
        self.zanDelegate?.refreshUIWithZan(index: index!)
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
    var model: CQRankModel? {
        didSet {
            self.rankLab.text = model?.sort
            self.iconImg.sd_setImage(with: URL(string: model?.headImage ?? ""), placeholderImage:UIImage.init(named: "personDefaultIcon") )
            self.timeLab.font = kFontSize15
            self.nameLab.text = model?.realName
            if !(model?.attendanceTime.isEmpty)! && (model?.attendanceTime.count)! > 4{
                self.timeLab.text = (model?.attendanceTime as NSString?)?.substring(with: NSRange.init(location: 0, length: 5))
            }
            self.zanCountLab.text = model?.likeCount
            
            if (model?.likeSign)! {
                self.zanBtn.setImage(UIImage.init(named: "rankZan"), for: .normal)
                self.timeLab.font = kFontSize15
            }else {
                self.zanBtn.setImage(UIImage.init(named: "rankUnselectZan"), for: .normal)
                self.timeLab.font = kFontSize15
            }
            
            
        }
    }
}

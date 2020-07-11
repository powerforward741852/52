//
//  CQNoticeCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/4.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQNoticeCell: UITableViewCell {

    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 15.5), width: AutoGetWidth(width: 100), height: AutoGetHeight(height: 71)))
        iconImg.image = UIImage.init(named: "PersonNoticBg")
        return iconImg
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 16), y: AutoGetHeight(height: 16), width: kWidth - kLeftDis * 2 - AutoGetWidth(width: 116), height: AutoGetHeight(height: 42)))
        nameLab.font = kFontSize16
        nameLab.textColor = UIColor.black
        nameLab.textAlignment = .left
//        nameLab.adjustsFontSizeToFitWidth = true
        nameLab.numberOfLines = 2
        nameLab.lineBreakMode =  .byTruncatingTail
        nameLab.text = "商会新闻/亚马逊投资10亿"
        return nameLab
    }()
    
    lazy var detailLab: UILabel = {
        let detailLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 16), y:self.nameLab.bottom + AutoGetHeight(height: 0), width: kWidth - kLeftDis * 2 - AutoGetWidth(width: 116), height: AutoGetHeight(height: 14)))
        detailLab.font = kFontSize14
        detailLab.textColor = UIColor.colorWithHexString(hex: "#8b8b8b")
        detailLab.textAlignment = .left
        detailLab.text = "都能拿到等等得的多少圣诞的"
        return detailLab
    }()
    
    lazy var dateLab: UILabel = {
        let dateLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 16), y:self.detailLab.bottom + AutoGetHeight(height: 0), width: kWidth - kLeftDis * 2 - AutoGetWidth(width: 116), height: AutoGetHeight(height: 11)))
        dateLab.font = kFontSize11
        dateLab.textColor = kLyGrayColor
        dateLab.textAlignment = .left
        dateLab.text = ""
        return dateLab
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
    
    func setUp()  {
        self.addSubview(self.iconImg)
        self.addSubview(self.nameLab)
        self.addSubview(self.detailLab)
        self.addSubview(self.dateLab)
    }
    
    //定义模型属性
    var model: CQNoticeModel? {
        didSet {
            
            self.iconImg.sd_setImage(with: URL(string: model?.noticeUrl ?? ""), placeholderImage:UIImage.init(named: "PersonNoticBg") )
            self.nameLab.text = model?.articleTitle
            self.detailLab.text = ""
            self.dateLab.text = model?.createDate
        }
    }
    
    var modelm: CQEnterpriseInfoModel? {
        didSet {
      
//            self.iconImg.sd_setImage(with: URL(string: (modelm?.imgUrl)!), placeholderImage:UIImage.init(named: "PersonNoticBg") )
            if (modelm?.imgUrl)! == "http://192.168.1.33:9093/asst_52/images/web/default.png" {
                self.iconImg.sd_setImage(with: URL(string:"PersonNoticBg" ), placeholderImage: UIImage(named: "PersonNoticBg"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
            }else{
                self.iconImg.sd_setImage(with: URL(string:(modelm?.imgUrl)! ), placeholderImage: UIImage(named: "PersonNoticBg"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
            }
            
//            self.iconImg.sd_setHighlightedImage(with: URL(string:(modelm?.imgUrl)! ), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
            
            self.nameLab.text = modelm?.siteTitle
            self.detailLab.text = ""
            self.dateLab.text = modelm?.siteContent
        }
    }
    
    //定义模型属性
    var webModel: CQSmallWebModel? {
        didSet {
            self.iconImg.sd_setImage(with: URL(string: webModel?.imgUrl ?? ""), placeholderImage:UIImage.init(named: "PersonNoticBg") )
            self.nameLab.text = webModel?.siteTitle
            self.nameLab.frame = CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 16), y: AutoGetHeight(height: 5), width: kWidth - kLeftDis * 2 - AutoGetWidth(width: 116), height: AutoGetHeight(height: 42))
            self.detailLab.text = webModel?.siteContent
            self.detailLab.numberOfLines = 2
//            self.dateLab.text = webModel?.createDate
        }
    }

}

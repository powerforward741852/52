//
//  CQSmallWebCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/4.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQSmallWebCell: UITableViewCell {

    lazy var bgImg: UIImageView = {
        let bgImg = UIImageView.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kHaveLeftWidth, height: AutoGetHeight(height: 64)))
        bgImg.image = UIImage.init(named: "")
        bgImg.backgroundColor = kColorRGB(r: 247, g: 247, b: 247)
        bgImg.layer.cornerRadius = 4
        return bgImg
    }()
    
    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetWidth(width: 9.725), width: AutoGetWidth(width: 45), height:AutoGetWidth(width: 45)))
        iconImg.image = UIImage.init(named: "PersonNoticBg")
        iconImg.layer.cornerRadius = AutoGetWidth(width: 22.5)
        iconImg.clipsToBounds = true
        return iconImg
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 15), y: AutoGetHeight(height: 0), width: kHaveLeftWidth - kLeftDis * 3 - AutoGetWidth(width: 44.5), height: AutoGetHeight(height: 64)))
        nameLab.font = kFontSize16
        nameLab.textColor = UIColor.black
        nameLab.textAlignment = .left
        nameLab.text = "四美达智能导览"
        return nameLab
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
        self.addSubview(self.bgImg)
        self.bgImg.addSubview(self.iconImg)
        self.bgImg.addSubview(self.nameLab)
    }
    
    //定义模型属性
    var model: CQSmallWebModel? {
        didSet {
            if (model?.imgUrl)! == "http://192.168.1.33:9093/asst_52/images/web/default.png" {
                self.iconImg.sd_setImage(with: URL(string:"PersonNoticBg" ), placeholderImage: UIImage(named: "PersonNoticBg"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
            }else{
                self.iconImg.sd_setImage(with: URL(string:(model?.imgUrl)! ), placeholderImage: UIImage(named: "PersonNoticBg"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
            }
//            self.iconImg.sd_setImage(with: URL(string: model?.imgUrl ?? ""), placeholderImage:UIImage.init(named: "PersonNoticBg") )
            self.nameLab.text = model?.siteTitle
        }
    }

}

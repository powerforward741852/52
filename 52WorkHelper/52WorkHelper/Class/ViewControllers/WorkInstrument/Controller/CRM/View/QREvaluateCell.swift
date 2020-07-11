//
//  QREvaluateCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/13.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QREvaluateCell: UITableViewCell {

    var model : QRGenZongListModel?{
        didSet{
            //数据处理
            if let xx = model?.commentTime {
                self.creatTime.text = xx
            }else{
                self.creatTime.text = ""
            }
            if let xx = model?.content {
                self.statusText.text = xx
            }else{
                self.statusText.text = ""
            }
            if let xx = model?.headImage {
                //self.creatTime.text = xx
                iconImageView.sd_setImage(with: URL(string: xx), placeholderImage: UIImage(named: "CQIndexPersonDefault"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
                
            }
            if let xx = model?.realName {
                self.userName.text = xx
            }else{
                self.userName.text = ""
            }
        }
    }
    
    /// 头像
    let iconImageView: UIImageView = UIImageView(image: UIImage(named: "CQIndexPersonDefault"))
    /// 用户名
    let userName: UILabel = UILabel(title: "小明爱睡觉", fontSize: 15)
    /// 发布时间
    let creatTime: UILabel = UILabel(title: "五分钟前", textColor: UIColor.gray, fontSize: 12)
    /// 微博的正文
    let statusText: UILabel = UILabel(title: "xxxxxxxxx", textColor: UIColor.black, fontSize: 14)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUi()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUi()  {
        //添加子视图
        contentView.addSubview(iconImageView)
        contentView.addSubview(userName)
        contentView.addSubview(creatTime)
        contentView.addSubview(statusText)
        iconImageView.layer.cornerRadius = AutoGetWidth(width: 18)
        iconImageView.clipsToBounds = true
        userName.font = kFontBoldSize15
        
        iconImageView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)?.setOffset(15)
            make?.top.mas_equalTo()(contentView)?.setOffset(18)
            make?.width.mas_equalTo()(AutoGetWidth(width: 36))
            make?.height.mas_equalTo()(AutoGetWidth(width: 36))
        }
        userName.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(iconImageView.mas_right)?.setOffset(15)
            make?.top.mas_equalTo()(iconImageView)
        }
        creatTime.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(contentView)?.setOffset(-15)
            make?.top.mas_equalTo()(userName)
        }
        statusText.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(iconImageView.mas_right)?.setOffset(10)
            make?.top.mas_equalTo()(userName.mas_bottom)?.setOffset(12)
            make?.right.mas_equalTo()(contentView)?.setOffset(-kLeftDis)
            make?.bottom.mas_equalTo()(contentView)?.setOffset(-6)
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

}

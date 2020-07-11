//
//  CQMyCustomerCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/8/6.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQMyCustomerCell: UITableViewCell {

    var bottomMargin : MASConstraint?
    
    var model : CQMyCustomerModel?  {
        didSet {
            
            
            if model?.message != "" {
                self.customerFromLab.mas_remakeConstraints({ (make) in
                    make?.left.mas_equalTo()(contentView)?.setOffset(kLeftDis)
                    make?.top.mas_equalTo()(principalLab.mas_bottom)?.setOffset(AutoGetHeight(height: 10))
                    make?.width.mas_equalTo()(80)
                    make?.height.lessThanOrEqualTo()(AutoGetHeight(height: 24))
                    make?.bottom.mas_equalTo()(contentView)?.setOffset(-10)
                })
                self.customerFromLab.setTitle(model?.message, for: UIControlState.normal)
                //self.customerFromLab.text = model?.message
                self.customerFromLab.alpha = 1
                self.customerFromLab.isHidden = false
                
            }else{
                self.customerFromLab.mas_remakeConstraints({ (make) in
                    make?.left.mas_equalTo()(contentView)?.setOffset(0)
                    make?.top.mas_equalTo()(principalLab.mas_bottom)?.setOffset(AutoGetHeight(height: 10))
                    make?.width.mas_equalTo()(0)
                    make?.height.mas_equalTo()(0)
                })

                self.customerFromLab.alpha = 0
                self.customerFromLab.setTitle("", for: UIControlState.normal)
                //self.customerFromLab.text = ""
                self.customerFromLab.isHidden = true
                
            }

            if  model?.level != "" {
                self.customerLevelLab.isHidden = false
//                self.customerLevelLab.text = model?.level
                self.customerLevelLab.setTitle(model?.level, for: .normal)
                self.customerLevelLab.alpha = 1
                self.customerLevelLab.mas_remakeConstraints({ (make) in
                    make?.left.mas_equalTo()(customerFromLab.mas_right)?.setOffset(AutoGetWidth(width: 14))
                    make?.top.mas_equalTo()(lastTimeLab.mas_bottom)?.setOffset(AutoGetHeight(height: 10))
                    make?.width.mas_equalTo()(80)
                    make?.height.lessThanOrEqualTo()(AutoGetHeight(height: 24))
                    make?.bottom.mas_equalTo()(contentView)?.setOffset(-10)
                })
            }else{
                self.customerLevelLab.isHidden = true
                self.customerLevelLab.alpha = 0
                //self.customerLevelLab.text = ""
                self.customerLevelLab.setTitle("", for: .normal)
                self.customerLevelLab.mas_remakeConstraints({ (make) in
                    make?.left.mas_equalTo()(customerFromLab.mas_right)?.setOffset(AutoGetWidth(width: 14))
                    make?.top.mas_equalTo()(lastTimeLab.mas_bottom)?.setOffset(AutoGetHeight(height: 10))
                    make?.width.mas_equalTo()(0)
                    make?.height.lessThanOrEqualTo()(0)
                    make?.bottom.mas_equalTo()(contentView)?.setOffset(0)
                })
            }
            if let mod = model?.lastFollowDate {
                self.lastTimeLab.text = "最后跟进时间:" + mod
            }else{
                self.lastTimeLab.text = ""
            }

            if let mod = model?.principal {
                self.principalLab.text = mod
            }else{
                self.principalLab.text = ""
            }

            if let mod = model?.name {
                self.companyNameLab.text = mod
            }else{
                self.companyNameLab.text = ""
            }

            
            
            
            
        }
    }
    
    
    lazy var companyNameLab: UILabel = {
        let companyNameLab = UILabel(title: "     ", textColor: UIColor.black, fontSize: 16, alignment: NSTextAlignment.left, numberOfLines: 1)
        return companyNameLab
    }()
    
    lazy var principalLab: UILabel = {
        let principalLab = UILabel(title: "   ", textColor: kLyGrayColor, fontSize: 13, alignment: NSTextAlignment.left, numberOfLines: 1)
        return principalLab
    }()
    
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = kLineColor
        return lineView
    }()
    
    lazy var lastTimeLab: UILabel = {
        let lastTimeLab = UILabel(title: "最后跟进时间：", textColor: kLyGrayColor, fontSize: 13, alignment: NSTextAlignment.left, numberOfLines: 1)
        return lastTimeLab
    }()
    
    lazy var customerFromLab: UIButton = {
//        let customerFromLab = UILabel(title: "电话销售：", textColor: UIColor.white, fontSize: 15, alignment: NSTextAlignment.center, numberOfLines: 1)
        let customerFromLab = UIButton()
        customerFromLab.titleLabel?.text = "电话销售："
        customerFromLab.titleLabel?.font = kFontSize13
        customerFromLab.backgroundColor = kLightBlueColor
        customerFromLab.layer.cornerRadius = AutoGetHeight(height: 24)/2
        customerFromLab.clipsToBounds = true
        return customerFromLab
    }()
    
    lazy var customerLevelLab: UIButton = {
       // let customerLevelLab = UILabel(title: "潜在客户：", textColor: UIColor.white, fontSize: 13, alignment: NSTextAlignment.center, numberOfLines: 1)
        let customerLevelLab = UIButton()
        customerLevelLab.titleLabel?.text = "电话销售："
        customerLevelLab.titleLabel?.font = kFontSize13
        customerLevelLab.backgroundColor = kColorRGB(r: 247, g: 160, b: 38)
        customerLevelLab.layer.cornerRadius = AutoGetHeight(height: 24)/2
        customerLevelLab.clipsToBounds = true
        return customerLevelLab
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:style,reuseIdentifier:reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup()  {
        contentView.addSubview(self.companyNameLab)
        contentView.addSubview(self.principalLab)
        contentView.addSubview(self.lineView)
        contentView.addSubview(self.lastTimeLab)
        contentView.addSubview(self.customerFromLab)
        contentView.addSubview(self.customerLevelLab)
        
        companyNameLab.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)?.setOffset(kLeftDis)
            make?.top.mas_equalTo()(contentView)?.setOffset(AutoGetHeight(height: 18))
            make?.right.mas_equalTo()(contentView)?.setOffset(-kLeftDis)
        }
        principalLab.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)?.setOffset(kLeftDis)
            make?.top.mas_equalTo()(companyNameLab.mas_bottom)?.setOffset(AutoGetHeight(height: 10))
        }
        lineView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(principalLab.mas_right)?.setOffset(AutoGetWidth(width: 14))
            make?.centerY.mas_equalTo()(principalLab)
            make?.width.mas_equalTo()(1)
            make?.height.mas_equalTo()(10)
        }
        lastTimeLab.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(lineView.mas_right)?.setOffset(AutoGetWidth(width: 14))
            make?.centerY.mas_equalTo()(lineView)
            
        }
        customerFromLab.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)?.setOffset(kLeftDis)
            make?.top.mas_equalTo()(principalLab.mas_bottom)?.setOffset(AutoGetHeight(height: 10))
            make?.width.mas_equalTo()(80)
            self.bottomMargin = make?.width
            make?.height.lessThanOrEqualTo()(AutoGetHeight(height: 24))
            make?.bottom.mas_equalTo()(contentView)?.setOffset(-10)
        }
        customerLevelLab.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(customerFromLab.mas_right)?.setOffset(AutoGetWidth(width: 14))
            make?.top.mas_equalTo()(lastTimeLab.mas_bottom)?.setOffset(AutoGetHeight(height: 10))
            make?.width.mas_equalTo()(80)
            make?.height.lessThanOrEqualTo()(AutoGetHeight(height: 24))
            make?.bottom.mas_equalTo()(contentView)?.setOffset(-10)
           // self.bottomMargin = make?.bottom
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

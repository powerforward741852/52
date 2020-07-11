//
//  QRDetailHeadView.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/5.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRDetailHeadView: UIView {
    var mod :QRContratctDetailModel?
//var dataArray :QRContractModel?

    var model : QRContratctDetailModel?{
        didSet{
            self.title.text = model?.title
            self.biaohaoNum.text = model?.number
            self.money.text = model?.amount
            self.kaishiDate.text = model?.startDate
            self.jiezhiDate.text = model?.endDate
        }
    }
    
    
  public  lazy var title:UILabel = {
        let lab = UILabel(title: "工作组手合同", textColor: UIColor.black, fontSize: 18,  numberOfLines: 1)
        return lab
    }()
    lazy var bianhao1:UILabel = {
        let lab = UILabel(title: "合同编号:", textColor: kLyGrayColor, fontSize: 12,  numberOfLines: 1)
        return lab
    }()
    lazy var biaohaoNum : UILabel = {
        let lab = UILabel(title: "23432424", textColor: kLyGrayColor, fontSize: 12,  numberOfLines: 1)
        return lab
    }()
    lazy var jine:UILabel = {
        let lab = UILabel(title:"合同金额:", textColor: UIColor.black, fontSize: 14)
        return lab
    }()
    lazy var moneyyang:UILabel = {
        let lab = UILabel(title: " ￥", textColor: kOrangeColor,  numberOfLines: 1)
        lab.font = kFontBoldSize30
        return lab
    }()
    lazy var money:UILabel = {
        let lab = UILabel(title: "2415", textColor: kOrangeColor,  numberOfLines: 1)
        lab.font = kFontBoldSize30
        return lab
    }()
    lazy var kaishi:UILabel = {
        let lab = UILabel(title: "开始", textColor: kLyGrayColor, fontSize: 14,  numberOfLines: 1)
        return lab
    }()
    lazy var jiezhi :UILabel = {
        let lab = UILabel(title: " /  截止", textColor: kLyGrayColor, fontSize: 14,  numberOfLines: 1)
        return lab
    }()
    lazy var kaishiDate:UILabel = {
        let lab = UILabel(title: "2018-02-01", textColor: UIColor.black, fontSize: 14, numberOfLines: 1)
        return lab
    }()
    lazy var jiezhiDate :UILabel = {
        let lab = UILabel(title: "2018-09-01", textColor: UIColor.black, fontSize: 14, numberOfLines: 1)
        return lab
    }()
    
    
    override init(frame:CGRect){
        super.init(frame: frame)
        setupSubViews()
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        
      
        self.addSubview(moneyyang)
        self.addSubview(title)
        self.addSubview(bianhao1)
        self.addSubview(biaohaoNum)
        self.addSubview(jine)
        self.addSubview(money)
        self.addSubview(kaishi)
        self.addSubview(kaishiDate)
        self.addSubview(jiezhi)
        self.addSubview(jiezhiDate)
        
        
        title.mas_makeConstraints({ (make) in
            make?.left.mas_equalTo()(AutoGetWidth(width: 16))
            make?.top.mas_equalTo()(AutoGetWidth(width: 18))
        })
        bianhao1.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(title)
            make?.top.mas_equalTo()(title.mas_bottom)?.setOffset(AutoGetWidth(width: 11))
        }
        biaohaoNum.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(bianhao1.mas_right)
            make?.top.mas_equalTo()(bianhao1)
        }
        
        jine.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(bianhao1.mas_bottom)?.setOffset(AutoGetHeight(height: 24))
            make?.left.mas_equalTo()(bianhao1)
        }
        moneyyang.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(jine.mas_right)
            make?.bottom.mas_equalTo()(jine)?.setOffset(5)
        }
        money.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(moneyyang.mas_right)
            make?.bottom.mas_equalTo()(jine)?.setOffset(5)
        }
       
        kaishi.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(jine)
            make?.top.mas_equalTo()(jine.mas_bottom)?.setOffset(AutoGetWidth(width: 15))
            
        }
        kaishiDate.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(kaishi.mas_right)?.setOffset(5)
            make?.centerY.mas_equalTo()(kaishi)
        }
        
        jiezhi.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(kaishiDate.mas_right)?.setOffset(10)
             make?.centerY.mas_equalTo()(kaishi)
        }
        jiezhiDate.mas_makeConstraints { (make) in
             make?.left.mas_equalTo()(jiezhi.mas_right)?.setOffset(5)
             make?.centerY.mas_equalTo()(kaishi)
        }
        
        
    }

    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    
        
    }

    
}

//
//  QRWaiQinDetailCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/2/19.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRWaiQinDetailCell: UITableViewCell {

    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel(title: "拜访对象:", textColor: UIColor.black, fontSize: 14, alignment: .left, numberOfLines: 1)
        nameLab.isUserInteractionEnabled = true
        return nameLab
    }()
    
    lazy var detailLabs: UILabel = {
        let detailLabs = UILabel(title: "xxx", textColor: UIColor.black, fontSize: 14, alignment: .left, numberOfLines: 0)
        detailLabs.isUserInteractionEnabled = true
        return detailLabs
    }()
    
    lazy var picView :QRPictureView = {
        let pic =  QRPictureView(leftMargin: 0)
        return pic
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(nameLab)
        self.contentView.addSubview(detailLabs)
        self.contentView.addSubview(picView)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI()  {
        
        nameLab.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(self.contentView.mas_top)?.setOffset(AutoGetHeight(height: 15))
            make?.left.mas_equalTo()(self.contentView.mas_left)?.setOffset(AutoGetHeight(height: 15))
            make?.width.mas_equalTo()(AutoGetWidth(width: 70))
          //  make?.height.mas_greaterThanOrEqualTo()(AutoGetWidth(width: 30))
        }
        detailLabs.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(nameLab.mas_top)
            make?.right.mas_equalTo()(self.contentView.mas_right)?.setOffset(AutoGetWidth(width: -15))
            make?.left.mas_equalTo()(nameLab.mas_right)?.setOffset(AutoGetWidth(width: 10))
            make?.bottom.mas_equalTo()(contentView.mas_bottom)?.setOffset(AutoGetWidth(width: -15))
        }
        
        picView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)
            make?.right.mas_equalTo()(contentView)
            make?.top.mas_equalTo()(detailLabs.mas_bottom)?.setOffset(10)
        }
    }
    
    var model: CQFieldPersonalModel? {
        didSet {
            let imgs = model?.picurlData
            picView.imags = imgs
            if let count = imgs?.count, count > 0 {
                detailLabs.mas_remakeConstraints { (make) in
                    make?.top.mas_equalTo()(nameLab.mas_top)
                    make?.right.mas_equalTo()(self.contentView.mas_right)?.setOffset(AutoGetWidth(width: -15))
                    make?.left.mas_equalTo()(nameLab.mas_right)?.setOffset(AutoGetWidth(width: 10))
                }

                let rowNum = (count - 1)/(cellLayout.numOfPerRow) + 1
                let pictureViewHeight = CGFloat(rowNum) * cellLayout.imageHeight + cellLayout.margin * (CGFloat(rowNum)-1)
                //   pictureViewSize = CGSizeMake(cellLayout.pictureViewWith, pictureViewHeight)
                //更新UI
                nameLab.sizeToFit()
                picView.mas_updateConstraints({ (make) in
                    make?.left.mas_equalTo()(contentView)?.setOffset(AutoGetWidth(width: 25)+nameLab.width)
                    make?.right.mas_equalTo()(contentView)?.setOffset(-AutoGetWidth(width: 15))
                    make?.top.mas_equalTo()(detailLabs.mas_bottom)?.setOffset(10)
                    make?.height.mas_equalTo()(pictureViewHeight)
                    make?.width.mas_equalTo()(cellLayout.pictureViewWith)
                    make?.bottom.mas_equalTo()(contentView)?.setOffset(-10)
                })
            }else{
                detailLabs.mas_makeConstraints { (make) in
                    make?.top.mas_equalTo()(nameLab.mas_top)
                    make?.right.mas_equalTo()(self.contentView.mas_right)?.setOffset(AutoGetWidth(width: -15))
                    make?.left.mas_equalTo()(nameLab.mas_right)?.setOffset(AutoGetWidth(width: 10))
                    make?.bottom.mas_equalTo()(contentView.mas_bottom)?.setOffset(AutoGetWidth(width: -15))
                }
                picView.mas_updateConstraints({ (make) in
                    make?.left.mas_equalTo()(contentView)?.setOffset(AutoGetWidth(width: 15))
                    make?.right.mas_equalTo()(contentView)?.setOffset(-AutoGetWidth(width: 15))
                    make?.top.mas_equalTo()(detailLabs.mas_bottom)?.setOffset(1)
                    make?.height.mas_equalTo()(0)
                    make?.bottom.mas_equalTo()(contentView)?.setOffset(-10)
                })
            }
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}

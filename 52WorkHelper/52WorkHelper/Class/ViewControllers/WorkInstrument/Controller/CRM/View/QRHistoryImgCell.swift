//
//  QRHistoryImgCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/10/12.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRHistoryImgCell: UITableViewCell {

    var model :QRHistoryImageModel?{
        didSet{
            
            if let xx = model?.createUserHeadImage  {
                                textview.iconImageView.sd_setImage(with: URL(string: xx), placeholderImage: UIImage(named: "personDefaultIcon"), options: SDWebImageOptions.cacheMemoryOnly, completed: nil)
            }
            
            if let xx = model?.createTime  {
                self.textview.creatTime.text = xx
            }else{
                self.textview.creatTime.text = ""
            }
            
            if let xx = model?.createUserRealName  {
                self.textview.userName.text = xx
            }else{
                self.textview.userName.text = ""
            }
            
            if let xx = model?.evaluate  {
                self.textview.statusText.text = xx
            }else{
                self.textview.statusText.text = ""
            }
            
            
            //图片
            
                        let imgs = model?.picurlData
                        picView.imags = imgs
                        if let count = imgs?.count, count > 0 {
                            let rowNum = (count - 1)/(cellLayout.numOfPerRow) + 1
                            let pictureViewHeight = CGFloat(rowNum) * cellLayout.imageHeight + cellLayout.margin * (CGFloat(rowNum)-1)
                            //更新UI
                            picView.mas_updateConstraints({ (make) in
                                make?.left.mas_equalTo()(contentView)?.setOffset(AutoGetWidth(width: 15))
                                make?.right.mas_equalTo()(contentView)?.setOffset(-AutoGetWidth(width: 15))
                                make?.top.mas_equalTo()(textview.mas_bottom)?.setOffset(10)
                                make?.height.mas_equalTo()(pictureViewHeight)
                                make?.width.mas_equalTo()(cellLayout.pictureViewWith)
                              //   make?.bottom.mas_equalTo()(addressview.top)?.setOffset(-10)
                            })
                        }else{
                            picView.mas_updateConstraints({ (make) in
                                make?.left.mas_equalTo()(contentView)?.setOffset(AutoGetWidth(width: 15))
                                make?.right.mas_equalTo()(contentView)?.setOffset(-AutoGetWidth(width: 15))
                                make?.top.mas_equalTo()(textview.mas_bottom)?.setOffset(10)
                                make?.height.mas_equalTo()(0)
                             //   make?.bottom.mas_equalTo()(addressview.top)?.setOffset(0)
                            })
                        }
            
            
            if let xx = model?.followMethod ,xx == "外勤拜访"  {
                self.addressview.isHidden = false
                addressview.mas_updateConstraints { (make) in
                    make?.top.mas_equalTo()(picView.mas_bottom)
                    make?.height.mas_equalTo()(AutoGetHeight(height: 25))
                    make?.left.mas_equalTo()(picView.mas_left)
                    make?.right.mas_equalTo()(picView.mas_right)
                    make?.bottom.mas_equalTo()(contentView.mas_bottom)?.setOffset(-10)
                }
                self.layoutIfNeeded()
                self.textview.customerFromLab.setTitle(xx, for: UIControlState.normal)
                
                self.addressview.address.text = model?.address
               
            }else if let xx = model?.followMethod {
                addressview.mas_updateConstraints { (make) in
                    make?.top.mas_equalTo()(picView.mas_bottom)
                    make?.height.mas_equalTo()(AutoGetHeight(height: 0))
                    make?.left.mas_equalTo()(picView.mas_left)
                    make?.right.mas_equalTo()(picView.mas_right)
                    make?.bottom.mas_equalTo()(contentView.mas_bottom)?.setOffset(0)
                }
                self.textview.customerFromLab.setTitle(xx, for: UIControlState.normal)
                
                self.addressview.isHidden = true
                self.layoutIfNeeded()
                
            }

      }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
    
    
    
   
   
    

    
    
    lazy var picView :QRPictureView = {
        let pic =  QRPictureView(leftMargin: 0)
        addressview.backgroundColor = UIColor.white
        return pic
    }()
    lazy var textview :QRHistoryView = {
        let pic =  QRHistoryView()
        return pic
    }()
    
    lazy var addressview : QRAddressView = {
        let addressview = QRAddressView()
        return addressview
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textview)
        contentView.addSubview(picView)
        contentView.addSubview(addressview)
       
        setUpUi()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUi(){
   
        textview.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)
            make?.right.mas_equalTo()(contentView)
            make?.top.mas_equalTo()(contentView)
        }
        picView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)
            make?.right.mas_equalTo()(contentView)
            make?.top.mas_equalTo()(textview.mas_bottom)?.setOffset(10)
        }
        addressview.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(picView.mas_bottom)
            make?.height.mas_equalTo()(AutoGetHeight(height: 25))
            make?.left.mas_equalTo()(picView.mas_left)
            make?.right.mas_equalTo()(picView.mas_right)
            make?.bottom.mas_equalTo()(contentView.mas_bottom)?.setOffset(-10)
        }
    }
}

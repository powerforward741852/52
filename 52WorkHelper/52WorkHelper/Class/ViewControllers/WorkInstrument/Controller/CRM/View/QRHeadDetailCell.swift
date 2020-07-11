//
//  QRHeadDetailCell.swift
//  test
//
//  Created by 秦榕 on 2018/9/8.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit

class QRHeadDetailCell: UITableViewCell {

    var model : QRContratctDetailModel?{
        didSet{
         detailView.model = model
         tipslab1.text = model?.remark
           
                        let imgs = model?.attachementUrl
                        picView.imags = imgs
                        if let count = imgs?.count, count > 0 {
                            let rowNum = (count - 1)/(cellLayout.numOfPerRow) + 1
                            let pictureViewHeight = CGFloat(rowNum) * cellLayout.contractPicimageHeight + cellLayout.margin * (CGFloat(rowNum)-1)
                            //   pictureViewSize = CGSizeMake(cellLayout.pictureViewWith, pictureViewHeight)
                            //更新UI
                            picView.mas_updateConstraints({ (make) in
                                make?.left.mas_equalTo()(contentView)?.setOffset(AutoGetWidth(width: 15))
                                make?.right.mas_equalTo()(contentView)?.setOffset(-AutoGetWidth(width: 15))
                                make?.top.mas_equalTo()(tipslab.mas_bottom)?.setOffset(10)
                                make?.height.mas_equalTo()(pictureViewHeight)
                                make?.width.mas_equalTo()(cellLayout.contractPicViewWidth)
                                // make?.bottom.mas_equalTo()(contentView)?.setOffset(-10)
                            })
                        }else{
                            picView.mas_updateConstraints({ (make) in
                                make?.left.mas_equalTo()(contentView)
                                make?.right.mas_equalTo()(contentView)
                                make?.top.mas_equalTo()(tipslab.mas_bottom)?.setOffset(10)
                            })
                        }
            
            
        }
    }
    var modeld : [QRDetailAttachmentModel]?{
        didSet{
//            let imgs = model?.images
//            picView.imags = imgs
//            if let count = imgs?.count, count > 0 {
//                let rowNum = (count - 1)/(cellLayout.numOfPerRow) + 1
//                let pictureViewHeight = CGFloat(rowNum) * cellLayout.imageHeight + cellLayout.margin * (CGFloat(rowNum)-1)
//                //   pictureViewSize = CGSizeMake(cellLayout.pictureViewWith, pictureViewHeight)
//                //更新UI
//                picView.mas_updateConstraints({ (make) in
//                    make?.left.mas_equalTo()(contentView)?.setOffset(cellLayout.margin)
//                    make?.right.mas_equalTo()(contentView)?.setOffset(-cellLayout.margin)
//                    make?.top.mas_equalTo()(statusView.mas_bottom)?.setOffset(10)
//                    make?.height.mas_equalTo()(pictureViewHeight)
//                    make?.width.mas_equalTo()(cellLayout.pictureViewWith)
//                    // make?.bottom.mas_equalTo()(contentView)?.setOffset(-10)
//                })
//            }else{
//                picView.mas_updateConstraints({ (make) in
//                    make?.left.mas_equalTo()(contentView)
//                    make?.right.mas_equalTo()(contentView)
//                    make?.top.mas_equalTo()(statusView.mas_bottom)?.setOffset(10)
//                })
//            }
            
        }
    }
    
  
    
    lazy var blueImg:UIView = {
        let blueImg = UIImageView(image: UIImage(named:"contrantBG"))
        return blueImg
    }()
    
    lazy var detailView:QRDetailHeadView = {
        let detailView = QRDetailHeadView()
        detailView.backgroundColor = UIColor.white
        detailView.layer.cornerRadius = 7
        detailView.clipsToBounds = true
        detailView.layer.shadowColor = UIColor.gray.cgColor
        detailView.layer.shadowOpacity = Float(1.8)
        detailView.layer.shadowOffset = CGSize(width: 1, height: 1)
        detailView.layer.borderWidth = 0.3
        detailView.layer.borderColor = UIColor.gray.cgColor
//        let img = UIImage(named: "checkOutBg")
//        detailView.layer.contents = img?.cgImage
        return detailView
    }()
    
    lazy var tipslab:UILabel = {
        let tips = UILabel(title: "备注:", textColor: kLyGrayColor, fontSize: 15)
        return tips
    }()
    lazy var tipslab1:UILabel = {
        let tips2 = UILabel(title: "内容就开始哭静待花开静待花开", textColor: kLyGrayColor, fontSize: 15, numberOfLines: 0)
        return tips2
    }()
    

    
    
    lazy var picView :QRContractPicView = {
        let pic =  QRContractPicView()
        return pic
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(blueImg)
        contentView.addSubview(detailView)
        contentView.addSubview(tipslab)
        contentView.addSubview(tipslab1)
        contentView.addSubview(picView)
        self.backgroundColor = UIColor.white
//        let imagW = (kWidth-60)/3
//        let imagH = (kWidth-60)/3*84/101
        
        
        
        blueImg.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)
            make?.top.mas_equalTo()(contentView)
            make?.right.mas_equalTo()(contentView)
            make?.height.mas_equalTo()(AutoGetHeight(height: 123))
        }
        detailView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)?.setOffset(kLeftDis)
            make?.top.mas_equalTo()(contentView)?.setOffset(34)
            make?.width.mas_equalTo()(kHaveLeftWidth)
            make?.height.mas_equalTo()(AutoGetHeight(height: 154))
        }
        
       
        tipslab.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(detailView)
            make?.top.mas_equalTo()(detailView.mas_bottom)?.setOffset(13)
            // make?.bottom.mas_equalTo()(contentView)?.setOffset(-10)
        }
        tipslab1.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(tipslab.mas_right)
            make?.centerY.mas_equalTo()(tipslab)
           //  make?.bottom.mas_equalTo()(contentView)?.setOffset(-10)
        }
       
        picView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)
            make?.right.mas_equalTo()(contentView)
            make?.top.mas_equalTo()(tipslab.mas_bottom)?.setOffset(10)
            make?.bottom.mas_equalTo()(contentView)?.setOffset(-10)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

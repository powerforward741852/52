//
//  QRheadEvaluateCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/13.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRheadEvaluateCell: UITableViewCell {

  
    var model :QRHeadEvaluateModel?{
        didSet{
            //根据数组的图片数量来处理图片的高度
            /// 计算配图视图的大小
            let imgs = model?.picurlData
            picView.imags = imgs
            if let count = imgs?.count, count > 0 {
                let rowNum = (count - 1)/(cellLayout.numOfPerRow) + 1
                let pictureViewHeight = CGFloat(rowNum) * cellLayout.imageHeight + cellLayout.margin * (CGFloat(rowNum)-1)
                //   pictureViewSize = CGSizeMake(cellLayout.pictureViewWith, pictureViewHeight)
                //更新UI
                picView.mas_updateConstraints({ (make) in
                    make?.left.mas_equalTo()(contentView)?.setOffset(AutoGetWidth(width: 15))
                    make?.right.mas_equalTo()(contentView)?.setOffset(-AutoGetWidth(width: 15))
                    make?.top.mas_equalTo()(statusView.mas_bottom)?.setOffset(10)
                    make?.height.mas_equalTo()(pictureViewHeight)
                    make?.width.mas_equalTo()(cellLayout.pictureViewWith)
                  //  make?.bottom.mas_equalTo()(contentView)?.setOffset(-10)
                })
            }
            if let name = model?.createUserHeadImage {
                statusView.iconImageView.sd_setImage(with: URL(string: name), placeholderImage:UIImage(named:"cannotSelect0") , options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
            }
            
            if let evaluate = model?.evaluate {
                statusView.statusText.text = evaluate
            }else{
                statusView.statusText.text = ""
            }
            
            if let personName = model?.createUserRealName {
                statusView.userName.text = personName
            }else{
                statusView.creatTime.text = ""
            }
            
            if let followNametime = model?.createTime {
                statusView.creatTime.text = followNametime
            }else{
                statusView.creatTime.text = ""
            }
            
            if let address = model?.address {
                lab.text = address
            }else{
                lab.text = ""
            }
            
        }
        
    }
    
    lazy var statusView :QRStatusView = {
        let status =  QRStatusView()
        return status
    }()
    lazy var picView :QRPictureView = {
        let pic =  QRPictureView(leftMargin: 0)
        return pic
    }()
    
    lazy var bottomView :UIView = {
        let bottom =  UIView()
        bottom.frame =  CGRect(x: 0, y: 0, width: kWidth, height: 40)
        bottom.addSubview(pic)
        bottom.addSubview(lab)
        
        return bottom
    }()
    
    lazy var pic : UIImageView = {
        let pic =  UIImageView()
        pic.frame =  CGRect(x: 15, y: 7, width: 25, height: 16)
        pic.image = UIImage(named: "dd")
        return pic
    }()
    
    lazy var lab : UILabel = {
        let lab =  UILabel(title: "思美达科技", textColor: klightGreyColor, fontSize: 14)
        lab.frame =  CGRect(x: pic.right+5, y: 5, width: 160, height: 20)
        return lab
    }()
    
//    lazy var evaluateBut : UIButton = {
//        let but = UIButton()
//        but.setImage(UIImage(named:"pinglun"), for: .normal)
//        but.setTitle("评论", for: .normal)
//        but.titleLabel?.font = kFontSize16
//        but.addTarget(self, action: #selector(pingLun), for:.touchUpInside)
//        but.setTitleColor(UIColor.black, for: .normal)
//        return but
//    }()
//

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(statusView)
        contentView.addSubview(picView)
        contentView.addSubview(bottomView)
        
        
        
      //  contentView.addSubview(evaluateBut)
        statusView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)
            make?.right.mas_equalTo()(contentView)
            make?.top.mas_equalTo()(contentView)
            //            make?.bottom.mas_equalTo()(contentView)
        }
        picView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)
            make?.right.mas_equalTo()(contentView)
            make?.top.mas_equalTo()(statusView.mas_bottom)?.setOffset(10)
          //   make?.bottom.mas_equalTo()(contentView)?.setOffset(-10)
        }
//        evaluateBut.mas_makeConstraints { (make) in
//             make?.left.mas_equalTo()(contentView)
//             make?.right.mas_equalTo()(contentView)
//            make?.width.mas_equalTo()(100)
//            make?.height.mas_equalTo()(36)
//            make?.right.mas_equalTo()(picView)
//            make?.top.mas_equalTo()(picView.mas_bottom)?.setOffset(10)
//            make?.bottom.mas_equalTo()(contentView)?.setOffset(-10)
//        }
        bottomView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)
            make?.right.mas_equalTo()(contentView)
            make?.width.mas_equalTo()(kWidth)
            make?.height.mas_equalTo()(30)
            make?.top.mas_equalTo()(picView.mas_bottom)?.setOffset(10)
            make?.bottom.mas_equalTo()(contentView)?.setOffset(-10)
        }
        
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

}

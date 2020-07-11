//
//  QRTrackerCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/13.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit


protocol QRTrackerCelldelegate : NSObjectProtocol{
   func  QRTrackerCellPush()
}
class QRTrackerCell: UITableViewCell {
  
    var rootVc = QRDetailBusinessVC()
    
    weak var QRTrackerCelldelelegate :QRTrackerCelldelegate?
    
    var model :QRTrackModel?{
        didSet{
            //根据数组的图片数量来处理图片的高度
            /// 计算配图视图的大小
            let imgs = model?.images
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
                   // make?.bottom.mas_equalTo()(contentView)?.setOffset(-10)
                })
            }else{
                picView.mas_updateConstraints({ (make) in
                    make?.left.mas_equalTo()(contentView)?.setOffset(AutoGetWidth(width: 15))
                    make?.right.mas_equalTo()(contentView)?.setOffset(-AutoGetWidth(width: 15))
                    make?.top.mas_equalTo()(statusView.mas_bottom)?.setOffset(10)
                    make?.height.mas_equalTo()(0)
                })
            }
            if let name = model?.personImage {
                statusView.iconImageView.sd_setImage(with: URL(string: name), placeholderImage:UIImage(named:"cannotSelect0") , options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
            }else{
              //  statusView.creatTime.text = ""
            }
            
            if let evaluate = model?.evaluate {
                  statusView.statusText.text = evaluate
            }else{
                statusView.statusText.text = ""
            }
            
            if let personName = model?.personName {
                statusView.userName.text = personName
            }else{
                statusView.creatTime.text = ""
            }
            
            if let commentCount = model?.commentCount {
               evaluateBut.setTitle("评论\(commentCount)", for: .normal)
            }else{
               // statusView.statusText.text = ""
            }
            
            if let followNametime = model?.followTime {
                statusView.creatTime.text = followNametime
            }else{
                 statusView.creatTime.text = ""
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
    lazy var evaluateBut : UIButton = {
        let but = UIButton()
        but.setImage(UIImage(named:"pinglun"), for: .normal)
        but.setTitle("评论", for: .normal)
        but.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        but.titleLabel?.font = kFontSize15
        but.addTarget(self, action: #selector(pingLun), for:.touchUpInside)
        but.setTitleColor(UIColor.black, for: .normal)
        return but
    }()
    lazy var grey :UIView = {
        let pic =  UIView()
        pic.backgroundColor = kProjectBgColor
        return pic
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
 
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(statusView)
        contentView.addSubview(picView)
        contentView.addSubview(evaluateBut)
        contentView.addSubview(grey)
        statusView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)
            make?.right.mas_equalTo()(contentView)
            make?.top.mas_equalTo()(contentView)
        }
        picView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)
            make?.right.mas_equalTo()(contentView)
            make?.top.mas_equalTo()(statusView.mas_bottom)?.setOffset(10)
        }
        evaluateBut.mas_makeConstraints { (make) in
            make?.width.mas_equalTo()(100)
            make?.height.mas_equalTo()(36)
            make?.right.mas_equalTo()(picView)?.setOffset(10)
            make?.top.mas_equalTo()(picView.mas_bottom)?.setOffset(10)
         //   make?.bottom.mas_equalTo()(contentView)?.setOffset(-10)
        }
        grey.mas_makeConstraints { (make) in
            make?.width.mas_equalTo()(kWidth)
            make?.height.mas_equalTo()(8)
            make?.left.mas_equalTo()(contentView)
            make?.top.mas_equalTo()(evaluateBut.mas_bottom)?.setOffset(0)
            make?.bottom.mas_equalTo()(contentView)?.setOffset(0)
        }
        
        
    }
    
    
    func caculateHight()  {
        
    }
    
  
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension QRTrackerCell{
    @objc func pingLun(){
        print("评论VC")
     let genzong = QRGengZongListVC()
        genzong.followRecordId = (model?.followEntityId)!
        genzong.businessid = rootVc.entityId
        genzong.clickClosure = {[unowned self] reflash in
            self.rootVc.loadGenJinListData(moreData: false)
        }
       rootVc.navigationController?.pushViewController(genzong, animated: true)
    }
}

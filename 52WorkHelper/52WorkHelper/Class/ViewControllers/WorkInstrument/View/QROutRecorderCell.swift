//
//  QROutRecorderCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/5/28.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class QROutRecorderCell: UITableViewCell {
    @IBOutlet weak var startTime: UILabel!

    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var contentL: UILabel!
   
    lazy var picView :QRNetImgPicView = {
        let pic =  QRNetImgPicView(width: kWidth-110)
        return pic
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(picView)
        
    }
    
    var model : QROutRecorderModel?{
        didSet{
            startTime.text = model?.startDate
//            if "" == model?.endDate{
//                endTime.text = model?.endDate
//            }else{
//                endTime.text = model?.endDate
//            }
            
             endTime.text = model?.endDate
            contentL.text = model?.outContent
            contentL.sizeToFit()
            //图片
            let imgs = model?.outImages
            let count = imgs!.count
            var bottoms =  contentL.bottom + 5
            
            if count>0{
                picView.isHidden = false
                picView.imags = imgs
                let rowNum = (count - 1)/(cellLayout.numOfPerRow) + 1
                let pictureViewHeight = CGFloat(rowNum) * cellLayout.imageHeight + cellLayout.margin * (CGFloat(rowNum)-1)
                picView.frame =  CGRect(x: contentL.left, y: bottoms, width: picView.pictureViewWidth, height: pictureViewHeight)
                bottoms = picView.bottom + friendCircle.kPadding
            }else{
                picView.frame =  CGRect(x: contentL.left, y: bottoms, width: picView.pictureViewWidth, height: 0)
                bottoms = picView.bottom + friendCircle.kPadding
                picView.isHidden = true
            }
            
            model?.rowheight = bottoms
        }
    }
    
    
}

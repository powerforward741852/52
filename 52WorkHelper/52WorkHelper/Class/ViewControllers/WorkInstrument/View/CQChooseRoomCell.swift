
//
//  CQChooseRoomCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/7/2.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQChooseRoomCell: UITableViewCell {

    lazy var bgView: UIView = {
        let bgView = UIView.init(frame: CGRect.init(x: AutoGetWidth(width: 10), y: AutoGetWidth(width: 0), width: kWidth - AutoGetWidth(width: 20), height: AutoGetHeight(height: 48)))
        bgView.layer.borderWidth = 0.5
        bgView.layer.borderColor = kLineColor.cgColor
        return bgView
    }()
    
    lazy var timeLab: UILabel = {
        let timeLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:  AutoGetHeight(height: 0), width: kWidth/3, height: AutoGetHeight(height: 48)))
        timeLab.textAlignment = .left
        timeLab.textColor = UIColor.black
        timeLab.text = "08:00"
        timeLab.font = kFontSize15
        return timeLab
    }()
    
    lazy var detailLab: UILabel = {
        let detailLab = UILabel.init(frame: CGRect.init(x: kWidth/2, y:0, width: (kWidth - AutoGetWidth(width: 10))/2 - 2 * kLeftDis, height: AutoGetHeight(height: 48)))
        detailLab.textAlignment = .right
        detailLab.textColor = UIColor.black
        detailLab.text = "空闲"
        detailLab.font = kFontSize15
        return detailLab
    }()
    
   
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    func setup()  {
        addSubview(bgView)
        self.bgView.addSubview(self.timeLab)
        self.bgView.addSubview(self.detailLab)
        
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

    //定义模型属性
    var model: CQChooseRoomModel? {
        didSet {
            self.timeLab.text = model?.dateTime
            if (model?.isOrder)! {
                self.detailLab.text = "空闲"
            }else{
                self.detailLab.text = "已占用"
                self.detailLab.textColor = kLyGrayColor
                self.timeLab.textColor = kLyGrayColor
            }
            
           
        }
    }
    
    
}

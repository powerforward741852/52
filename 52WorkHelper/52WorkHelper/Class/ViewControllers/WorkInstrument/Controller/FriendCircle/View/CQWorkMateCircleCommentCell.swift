//
//  CQWorkMateCircleCommentCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/19.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQWorkMateCircleCommentCell: UITableViewCell {

    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x:  AutoGetWidth(width: 13), y: AutoGetHeight(height: 0), width: self.frame.size.width - AutoGetWidth(width: 26), height: AutoGetHeight(height: 26)))
        nameLab.font = kFontSize14
        nameLab.textColor = UIColor.colorWithHexString(hex: "#1e5f91")
        nameLab.textAlignment = .left
        nameLab.text = ""
        return nameLab
    }()
    
    lazy var contentLab: UILabel = {
        let contentLab = UILabel.init(frame: CGRect.init(x:self.nameLab.right + AutoGetWidth(width: 6), y: AutoGetHeight(height: 0), width: self.frame.size.width - AutoGetWidth(width: 26), height: AutoGetHeight(height: 26)))
        contentLab.font = kFontSize14
        contentLab.textColor = UIColor.black
        contentLab.textAlignment = .left
        contentLab.text = ""
        return contentLab
    }()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor =  UIColor.colorWithHexString(hex: "#f2f6fc")
        setUp()
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
    
    func setUp()  {
        self.addSubview(self.nameLab)
        self.addSubview(self.contentLab)
    }
    
    //定义模型属性
    var model: CQWorkMateCircleModel? {
        didSet {
            if (model?.commentUserTo.count)! > 0 {
                self.nameLab.text = (model?.commentUserFrom)! + "回复" + (model?.commentUserTo)! + ":" + (model?.commentContent)!
            }else{
                self.nameLab.text = model?.commentUserFrom
            }
            
        }
    }

}

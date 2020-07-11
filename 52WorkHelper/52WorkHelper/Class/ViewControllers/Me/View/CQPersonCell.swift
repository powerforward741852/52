//
//  CQPersonCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/3.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQPersonCell: UITableViewCell {

    lazy var iconBtn: UIButton = {
        let iconBtn = UIButton.init(type: .custom)
        iconBtn.frame = CGRect.init(x: 0, y: 0, width: AutoGetWidth(width: 49), height: AutoGetHeight(height: 55))
        iconBtn.setImage(UIImage.init(named: ""), for: .normal)
        return iconBtn
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: self.iconBtn.right, y: 0, width: kWidth/2, height: AutoGetHeight(height: 55)))
        nameLab.font = kFontSize15
        nameLab.text = ""
        nameLab.textAlignment = .left
        nameLab.textColor = UIColor.black
        return nameLab
    }()
    
//    lazy var selectImg: UIImageView = {
//        let selectImg = UIImageView.init(frame: CGRect.init(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>))
//        return <#value#>
//    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUp()  {
        self.addSubview(self.iconBtn)
        self.addSubview(self.nameLab)
    }

}

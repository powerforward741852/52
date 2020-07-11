//
//  CQBCardDTCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2019/1/22.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class CQBCardDTCell: UITableViewCell {

    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x:  AutoGetWidth(width: 32), y:  AutoGetHeight(height: 0), width: AutoGetWidth(width: 60), height: AutoGetHeight(height: 55)))
        nameLab.text = ""
        nameLab.textAlignment = .left
        nameLab.textColor = kLyGrayColor
        nameLab.font = kFontSize15
        return nameLab
    }()
    
    lazy var dtLab: UILabel = {
        let dtLab = UILabel.init(frame: CGRect.init(x: AutoGetWidth(width: 104), y:  AutoGetHeight(height: 0), width: kWidth - kLeftDis - AutoGetWidth(width: 104), height: AutoGetHeight(height: 55)))
        dtLab.text = ""
        dtLab.textAlignment = .left
        dtLab.textColor = UIColor.black
        dtLab.font = kFontSize15
        dtLab.numberOfLines = 0
        return dtLab
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUp()  {
        self.addSubview(self.nameLab)
        self.addSubview(self.dtLab)
    }
    
    func refreshNameWithName(name:String,indexPath:IndexPath)  {
        if indexPath.row == 0{
            self.nameLab.text = name
        }
        
    }

    func countCellHeight(labStr:String) -> CGFloat {
        
        let height = getTextHeight(text: labStr, font: kFontSize15, width: kWidth - kLeftDis - AutoGetWidth(width: 104))
        return height
    }
    
}

//
//  CQBCardSelectCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2019/1/14.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class CQBCardSelectCell: UITableViewCell {

    @IBOutlet weak var nameLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

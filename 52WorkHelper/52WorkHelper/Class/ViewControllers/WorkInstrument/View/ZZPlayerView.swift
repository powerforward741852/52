//
//  ZZPlayerView.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/7/30.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class ZZPlayerView: UIView {
    
    var playerLayer:AVPlayerLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = self.bounds
    }

}

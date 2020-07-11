//
//  CQRefreshHeader.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/7.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQRefreshHeader: MJRefreshNormalHeader {

    override func prepare() {
        super.prepare()
        
        self.isAutomaticallyChangeAlpha = true
        self.lastUpdatedTimeLabel.isHidden = true
        self.stateLabel.font = UIFont.systemFont(ofSize: 12)
        self.setTitle("刷新完成", for: .idle)
        self.setTitle("下拉刷新", for: .pulling)
        self.setTitle("正在刷新..", for: .refreshing)
        
    }

}

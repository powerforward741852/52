//
//  CQRefreshFooter.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/7.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQRefreshFooter: MJRefreshAutoNormalFooter {

    override func prepare() {
        super.prepare()
        
//        self.isAutomaticallyHidden = true
        self.stateLabel.font = UIFont.systemFont(ofSize: 12)
        self.setTitle("没有更多数据了", for: .noMoreData)
    }


}

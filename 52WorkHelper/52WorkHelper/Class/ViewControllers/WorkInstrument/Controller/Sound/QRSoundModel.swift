//
//  QRSoundModel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/4/28.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class QRSoundModel : NSObject {
    var soundFilePath : String!
    var second : Int!
    var audioFiles = [String]()
    
    init?(jsonData: JSON) {
        var tempLink = [String]()
        for xx in jsonData.arrayValue {
            tempLink.append(xx.stringValue)
        }
        self.audioFiles = tempLink
    }
    
    
    //本地新建语音
    override init() {
        
        
    }
}

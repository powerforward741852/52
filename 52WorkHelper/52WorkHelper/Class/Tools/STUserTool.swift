//
//  STUserTool.swift
//  OldFriend
//
//  Created by 浮生若梦 on 2017/6/19.
//  Copyright © 2017年 XMSMART. All rights reserved.
//

import UIKit


private let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/account.archive"

class STUserTool: NSObject {
    /// 保存用户信息
    ///
    /// - Parameter account: 用户模型
    class func saveAccount(account: CQLoginUser) {
        print(path)
        let success = NSKeyedArchiver.archiveRootObject(account, toFile: path)
        if success {
            print("保存成功")
        }
    }
    
    
    /// 得到用户模型
    ///
    /// - Returns: 用户模型
    class func account() -> (CQLoginUser) {
        let loginUser = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? CQLoginUser
        guard let user = loginUser else {
            return CQLoginUser(jsonData: "123")!
        }
        return user
    }

    
    
}

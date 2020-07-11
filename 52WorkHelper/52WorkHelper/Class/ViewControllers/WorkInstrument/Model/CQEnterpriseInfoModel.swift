//
//  CQEnterpriseInfoModel.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/9.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQEnterpriseInfoModel: NSObject {

    //工作台类别主键
    var entityId = ""
    //类别主键
    var typeId = ""
    //类别名称
    var typeName = ""
    // 文件/文件夹名称
    var name = ""
    //文章主键
    var articleId = ""
    //文章标题
    var articleTitle = ""
    //附件主键
    var attachmentId = ""
    //附件名称
    var attachmentName = ""
    //附件大小
    var attachmentSize = ""
    //创建时间
    var createDate = ""
    //是否可以删除(yes,no)
    var isDelete:Bool
    //图标路径
    var suffixImgUrl = ""
    //1文件2文件夹
    var type = ""
    //允许分享
    var allowShare:Bool
    var icon = ""
    
    
    ///媒体报道
    //图片路径
    var imgUrl = ""
    //网站详情
    var siteContent = ""
    //网站名
    var siteTitle = ""
    //网址
    var sitegUrl = ""
 
    //媒体报道文件夹
    //var icon = ""
    //var typeName = ""
    init?(jsonData: JSON) {
        
        imgUrl = jsonData["imgUrl"].stringValue
        siteContent = jsonData["siteContent"].stringValue
        siteTitle = jsonData["siteTitle"].stringValue
        sitegUrl = jsonData["siteUrl"].stringValue
        
        
        
        entityId = jsonData["entityId"].stringValue
        typeId = jsonData["typeId"].stringValue
        typeName = jsonData["typeName"].stringValue
        
        articleId = jsonData["articleId"].stringValue
        articleTitle = jsonData["articleTitle"].stringValue
        attachmentId = jsonData["attachmentId"].stringValue
        attachmentName = jsonData["attachmentName"].stringValue
        attachmentSize = jsonData["attachmentSize"].stringValue
        createDate = jsonData["createDate"].stringValue
        isDelete = jsonData["isDelete"].boolValue
        suffixImgUrl = jsonData["suffixImgUrl"].stringValue
        name = jsonData["name"].stringValue
        type = jsonData["type"].stringValue
        allowShare = jsonData["allowShare"].boolValue
        icon = jsonData["icon"].stringValue
    }
    
}

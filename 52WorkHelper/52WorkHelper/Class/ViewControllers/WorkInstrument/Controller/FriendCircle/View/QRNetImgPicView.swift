//
//  QRNetImgPicView.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/19.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit
//网格的view
class QRNetImgPicView: UIView {
    
    var imags :[String]?{
        didSet{
            if let  img = imags ,img.count > 0 {
                if isShowFour == true{
                    if img.count == 4 {
                        //填充0134个view
                        for i in 0..<5 {
                            let imagev = subviews[i] as! UIImageView
                            if i == 2{
                                imagev.alpha = 0
                            }else{
                                if i>2{
                                    imagev.sd_setImage(with: URL(string: imags![i-1]), placeholderImage: UIImage(named: "demo"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
                                }else{
                                    imagev.sd_setImage(with: URL(string: imags![i]), placeholderImage: UIImage(named: "demo"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
                                }
                                imagev.alpha = 1
                            }
                        }
                        
                    }else{
                        for i in 0..<9 {
                            let imagev = subviews[i] as! UIImageView
                            if i > img.count-1{
                                imagev.alpha = 0
                            }else{
                                imagev.sd_setImage(with: URL(string: imags![i]), placeholderImage: UIImage(named: "demo"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
                                imagev.alpha = 1
                            }
                        }
                    }
                }else{
                    for i in 0..<9 {
                        let imagev = subviews[i] as! UIImageView
                        if i > img.count-1{
                            imagev.alpha = 0
                        }else{
                            imagev.sd_setImage(with: URL(string: imags![i]), placeholderImage: UIImage(named: "demo"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
                            imagev.alpha = 1
                        }
                    }
                }
                
                
            }
            //计算高度
            let rowNum = (imags!.count - 1)/(numOfPerRow) + 1
            let Height = CGFloat(rowNum) * imageHeight + cellLayout.margin * (CGFloat(rowNum)-1)
             pictureViewHeight = Height
        }
    }
    
    
    var margin:CGFloat = 0
    var iconSize: CGSize?
    var numOfPerRow: Int = 3
    var imageHeight:CGFloat = 0
    var imageSize:CGFloat = 0
    
    var pictureViewWidth:CGFloat = 0
    var pictureViewHeight:CGFloat = 0
    
    var isShowFour:Bool = false
    
    init(width:CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        pictureViewWidth =  width
        margin = 8
        imageHeight = (width-16)/3
        //创建9个图片
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        //  backgroundColor = UIColor.yellow
        //加9张图片
        for i in 0..<9 {
            let row = i/3
            let col = i%3
            let stepx: CGFloat = CGFloat(col) * (imageHeight + margin)
            let stepy: CGFloat = CGFloat(row) * (imageHeight + margin)
            let imageRect =  CGRect(x: stepx, y: stepy, width: imageHeight, height: imageHeight)
            let imageView = UIImageView(frame: imageRect)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.backgroundColor = UIColor.white
            imageView.alpha = 0
            
            imageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(clickPic(tap:)))
            imageView.addGestureRecognizer(tap)
            imageView.tag = i
    
            addSubview(imageView)
            //子视图超出父视图的frame时,把超出的部分切掉
            self.clipsToBounds = true
        }
    }
    
    
    @objc func clickPic(tap:UITapGestureRecognizer) {
        //索引
        var inde = tap.view?.tag
        //图片数组
        var imgaArr : [String] = []
        imgaArr = self.imags!
        if imgaArr.count == 4 && inde! >= 3{
            inde = inde! - 1
        }
        
        let userinfo = ["imags" : imgaArr, "index": inde!] as [String : Any]
        //新建通知
        let notification = NSNotification(name: NSNotification.Name(rawValue: "imagsCellID"), object: nil, userInfo: userinfo)
        NotificationCenter.default.post(notification as Notification)
    }
}

//
//  QRContractPicView.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/30.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRContractPicView: UIView {

    
    var imags :[String]?{
        didSet{
            
            
            if let  img = imags ,img.count > 0 {
                
                if img.count == 4 {
                    //填充0134个view
                    for i in 0..<5 {
                        let imagev = subviews[i] as! UIImageView
                        
                        if i == 2{
                            imagev.alpha = 0
                        }else{
                            if i>2{
                                imagev.sd_setImage(with: URL(string: imags![i-1]), placeholderImage: UIImage(named: "cannotSelect0"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
                            }else{
                                imagev.sd_setImage(with: URL(string: imags![i]), placeholderImage: UIImage(named: "cannotSelect0"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
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
                            imagev.sd_setImage(with: URL(string: imags![i]), placeholderImage: UIImage(named: "cannotSelect0"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
                            imagev.alpha = 1
                        }
                    }
                }
                
            }
            
            
            
        }
    }
  
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        //创建9个图片
        setupUI()
    }
    func setupUI(){
        //  backgroundColor = UIColor.yellow
        
        //加9张图片
        for i in 0..<9 {
            let row = i/3
            let col = i%3
            let stepx: CGFloat = CGFloat(col) * (cellLayout.contractPicimageWidth + cellLayout.margin)
            let stepy: CGFloat = CGFloat(row) * (cellLayout.contractPicimageHeight + cellLayout.margin)
            //   let imageRect = CGRectOffset(CGRect(origin: CGPoint(x: 0, y: 0), size: cellLayout.imageSize), stepx, stepy)
            let imageRect =  CGRect(x: stepx, y: stepy, width: cellLayout.contractPicimageWidth, height: cellLayout.contractPicimageHeight)
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
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
extension QRContractPicView{
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

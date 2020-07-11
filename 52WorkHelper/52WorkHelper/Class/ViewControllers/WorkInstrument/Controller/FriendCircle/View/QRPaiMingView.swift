//
//  QRPaiMingView.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/24.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRPaiMingView: UIView {
    
    @IBOutlet weak var yinpImg: UIImageView!
    
    @IBOutlet weak var goldpImg: UIImageView!
    
    @IBOutlet weak var tonPImg: UIImageView!
    
    @IBOutlet weak var yinLabel: UILabel!
    @IBOutlet weak var goldLabel: UILabel!
    
    @IBOutlet weak var tongLabel: UILabel!
 
    
    @IBOutlet weak var yinbg: UIImageView!
    
    @IBOutlet weak var goldbg: UIImageView!
    
    @IBOutlet weak var tongbg: UIImageView!
    
    
    override func awakeFromNib() {
        
    }
    func setData(dataSource:[QRZanlistModel])  {
        for (index,value) in dataSource.enumerated(){
            if index == 0{
                if value.realName == "none"{
                    yinpImg.isHidden = true
                    yinLabel.isHidden = true
                    yinbg.isHidden = true
                }else{
                    yinpImg.isHidden = false
                    yinLabel.isHidden = false
                    yinbg.isHidden = false
                    yinpImg!.sd_setImage(with: URL(string: value.headImage), placeholderImage: UIImage(named: "personDefaultIcon"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
                    yinLabel.text = value.realName
                }
                
            }else if index == 1{
                if value.realName == "none"{
                    goldpImg.isHidden = true
                    goldLabel.isHidden = true
                    goldbg.isHidden = true
                }else{
                    goldpImg.isHidden = false
                    goldLabel.isHidden = false
                    goldbg.isHidden = false
                    goldpImg!.sd_setImage(with: URL(string: value.headImage), placeholderImage: UIImage(named: "personDefaultIcon"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
                    goldLabel.text = value.realName
                }
            }else{
                if value.realName == "none"{
                    tonPImg.isHidden = true
                    tongLabel.isHidden = true
                    tongbg.isHidden = true
                }else{
                    tonPImg.isHidden = false
                    tongLabel.isHidden = false
                    tongbg.isHidden = false
                    tonPImg!.sd_setImage(with: URL(string: value.headImage), placeholderImage: UIImage(named: "personDefaultIcon"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
                    tongLabel.text = value.realName
                }
            }
        }
    }
    
}

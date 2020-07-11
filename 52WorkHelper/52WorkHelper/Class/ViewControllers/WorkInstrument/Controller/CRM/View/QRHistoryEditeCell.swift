//
//  QRHistoryEditeCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/19.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRHistoryEditeCell: UITableViewCell {

    var model :QRHistoryModel?{
        didSet{
            if let xx = model?.createUserHeadImage  {
                self.headImg.sd_setImage(with: URL(string: xx), placeholderImage: UIImage(named: "personDefaultIcon"), options: SDWebImageOptions.cacheMemoryOnly, completed: nil)
            }else{
                self.headImg.image = UIImage(named:"personDefaultIcon")
            }
            
            if let xx = model?.createTime  {
                self.time.text = xx
            }else{
                self.time.text = ""
            }
            
            if let xx = model?.createUserRealName  {
                self.name.text = xx
            }else{
                self.name.text = ""
            }
            
            
//            //添加
//            self.opt.removeAllSubviews()
//            for (index ,value) in (model?.editRecordData.enumerated())!{
//                let vie = QREditView()
//                print(value)
//
//                //从冒号分隔开
//                if  value.contains("："){
//                    let dex = value.index(of: "：")
//                    let st = value.index(after: dex!)
//                    let st1 = value[st...]
//                    let st2 = value[value.startIndex...dex!]
//                    vie.lab1.text = "\(st2)"
//                    vie.lab2.text = "\(st1)"
//                    vie.frame =  CGRect(x: 0, y: 40*index, width: Int(kHaveLeftWidth), height: 40)
//                    opt.addSubview(vie)
//                }else{
//                    vie.lab1.text = "                  "
//                    vie.lab2.text = value
//                    vie.frame =  CGRect(x: 0, y: 40*index, width: Int(kHaveLeftWidth), height: 40)
//                    opt.addSubview(vie)
//                }
//
//              opt.mas_updateConstraints { (make) in
//                make?.left.mas_equalTo()(contentView)?.setOffset(kLeftDis)
//                make?.right.mas_equalTo()(contentView)?.setOffset(-kLeftDis)
//                make?.height.mas_equalTo()(40*(model?.editRecordData.count)!)
//                make?.top.mas_equalTo()(headImg.mas_bottom)?.setOffset(5)
//                make?.bottom.mas_equalTo()(contentView.mas_bottom)?.setOffset(-10)
//            }
//
//
//
//            }
            
             var str = ""
            for (_ ,value) in (model?.editRecordData.enumerated())!{
                str += value + "\n"
            }
            
            self.opt.text = str
            
            
        }
    }
    
    
    lazy var headImg : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named:"personDefaultIcon")
        img.layer.cornerRadius = 15
        img.clipsToBounds = true
        return img
    }()
    lazy var name : UILabel = {
        let lab = UILabel(title: "李明", textColor: UIColor.black, fontSize: 16)
        
        return lab
    }()
    lazy var time : UILabel = {
        let lab = UILabel(title: "2018-01-01 12:00", textColor: UIColor.lightGray, fontSize: 12)
        return lab
    }()
    
    lazy var opt : UILabel = {
        let lab = UILabel(title: "  xxxxx", textColor: UIColor.black, fontSize: 15)
        return lab
    }()
    

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(headImg)
        contentView.addSubview(name)
        contentView.addSubview(time)
        contentView.addSubview(opt)
        setUpUi()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setUpUi(){
        headImg.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)?.setOffset(kLeftDis)
            make?.top.mas_equalTo()(contentView)?.setOffset(kLeftDis)
            make?.width.mas_equalTo()(40)
            make?.height.mas_equalTo()(40)
        }
       
        name.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(headImg.mas_right)?.setOffset(10)
            make?.centerY.mas_equalTo()(headImg)
           
        }
        time.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(contentView)?.setOffset(-kLeftDis)
            make?.centerY.mas_equalTo()(name)
            //make?.bottom.mas_equalTo()(contentView.mas_bottom)?.setOffset(-10)
        }
        opt.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(headImg.mas_right)?.setOffset(kLeftDis)
            make?.right.mas_equalTo()(contentView)?.setOffset(-kLeftDis)
           // make?.height.mas_equalTo()(10)
            make?.top.mas_equalTo()(headImg.mas_bottom)?.setOffset(5)
            make?.bottom.mas_equalTo()(contentView.mas_bottom)?.setOffset(-10)

        }
    }

}

//
//  QRGongHaiCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/16.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol QRGongHaiCellDelegate : NSObjectProtocol {
    
    func fenPeiOrLingQu(index:IndexPath, method:Int )
}

class QRGongHaiCell: UITableViewCell {
    
    weak var gongHaiDelegate :QRGongHaiCellDelegate?

    var model :QRGongHaiModel?  {
        didSet{
            if let name = model?.name {
                self.title.text = name
            }else{
                self.title.text = ""
            }
            if let name = model?.lastFollowDate {
                self.time.text = name
            }else{
                self.time.text = ""
            }
        }
    }
    
    lazy var fenPei :UIButton = {
       let but = UIButton()
        but.setTitle("分配", for: UIControlState.normal)
        but.setTitleColor(kColorRGB(r: 18, g: 159, b: 252), for: .normal)
        let img = imageWithColor(color: kColorRGB(r: 207, g: 237, b: 252), size: CGSize(width: 59, height: 24))
        but.setBackgroundImage(img, for: .normal)
        but.titleLabel?.font = kFontSize12
        but.layer.cornerRadius = 12
        but.clipsToBounds = true
        but.addTarget(self, action: #selector(fenpei(sender:)), for: UIControlEvents.touchUpInside)
        return but
    }()
    
    lazy var lingQu :UIButton = {
        let but = UIButton()
        but.setTitle("领取", for: UIControlState.normal)
        but.setTitleColor(kColorRGB(r: 18, g: 159, b: 252), for: .normal)
        let img = imageWithColor(color: kColorRGB(r: 207, g: 237, b: 252), size: CGSize(width: 59, height: 24))
        but.setBackgroundImage(img, for: .normal)
        but.titleLabel?.font = kFontSize12
        but.layer.cornerRadius = 12
        but.clipsToBounds = true
        but.addTarget(self, action: #selector(lingqu(sender:)), for: UIControlEvents.touchUpInside)
        
        return but
    }()
    
    lazy var title : UILabel = {
       let lab = UILabel(title: "四美达科技发展有限公司", textColor: UIColor.black, fontSize: 16)
        
        lab.numberOfLines = 1
        
        return lab
    }()
    lazy var beginTime : UILabel = {
        let lab = UILabel(title: "最后跟进时间:", textColor: UIColor.lightGray, fontSize: 13)
        lab.numberOfLines = 1
        return lab
    }()
    lazy var time : UILabel = {
        let lab = UILabel(title: "2018-01-01", textColor: UIColor.lightGray, fontSize: 13)
        lab.numberOfLines = 1
        return lab
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(title)
        contentView.addSubview(beginTime)
        contentView.addSubview(time)
        contentView.addSubview(fenPei)
        contentView.addSubview(lingQu)
        
        title.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(contentView)?.setOffset(kLeftDis)
            make?.bottom.mas_equalTo()(contentView.mas_centerY)?.setOffset(-AutoGetHeight(height: 3))
            make?.right.mas_equalTo()(contentView)?.setOffset(-AutoGetWidth(width: 25)-59)
        }
        
        beginTime.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(title)
            make?.top.mas_equalTo()(contentView.mas_centerY)?.setOffset(AutoGetHeight(height: 3))
        }
        time.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(beginTime.mas_right)?.setOffset(5)
            make?.top.mas_equalTo()(beginTime)
        }
        fenPei.mas_makeConstraints { (make) in
            make?.bottom.mas_equalTo()(contentView.mas_centerY)?.setOffset(-AutoGetHeight(height: 3))
            make?.right.mas_equalTo()(contentView)?.setOffset(-kLeftDis)
            make?.width.mas_equalTo()(59)
            make?.height.mas_equalTo()(24)
        }
        lingQu.mas_makeConstraints { (make) in
            make?.right.mas_equalTo()(contentView)?.setOffset(-15)
            make?.top.mas_equalTo()(contentView.mas_centerY)?.setOffset(AutoGetHeight(height: 3))
            make?.width.mas_equalTo()(59)
            make?.height.mas_equalTo()(24)
        }
        
        
        
        
    }
    
    @objc func fenpei(sender:AnyObject){
        let btn = sender as! UIButton
        let cell = superUITableViewCell(of: btn)
        let table = superUITableView(of: btn)
        let index = table?.indexPath(for: cell!)
        DLog(index)
        
        if self.gongHaiDelegate != nil{
            self.gongHaiDelegate?.fenPeiOrLingQu(index: index!, method: 1)
        }
    }
    @objc func lingqu(sender:AnyObject){
                let btn = sender as! UIButton
                let cell = superUITableViewCell(of: btn)
                let table = superUITableView(of: btn)
                let index = table?.indexPath(for: cell!)
                DLog(index)
        
        if self.gongHaiDelegate != nil{
            self.gongHaiDelegate?.fenPeiOrLingQu(index: index!, method: 2)
        }
    }
    
    //返回button所在的UITableViewCell
    func superUITableViewCell(of: UIButton) -> UITableViewCell? {
        for view in sequence(first: of.superview, next: { $0?.superview }) {
            if let cell = view as? UITableViewCell {
                return cell
            }
        }
        return nil
    }
    
    //返回button所在的UITableView
    func superUITableView(of: UIButton) -> UITableView? {
        for view in sequence(first: of.superview, next: { $0?.superview }) {
            if let table = view as? UITableView {
                return table
            }
        }
        return nil
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

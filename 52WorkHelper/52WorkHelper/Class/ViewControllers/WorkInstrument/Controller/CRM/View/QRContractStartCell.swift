
//
//  QRContractStartCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/11.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRContractStartCell: UITableViewCell {

    //属性观察器
    var model: QRContractModel? {
        didSet {
            if model?.title == nil {
                self.nameText.text = ""
            }else{
                self.nameText.text = model?.title
            }
            
            if model?.customerName == nil {
                self.riqi.text = ""
            }else{
                self.people.text = model?.customerName
            }
            if model?.startDate == nil {
                self.riqi.text = ""
            }else{
                self.riqi.text = model?.startDate
            }
            
        }
    }
    //名字
    let nameText : UILabel = {
        let name = UILabel(title: "名称XXX/合同/ MARK", textColor: UIColor.black, fontSize: 16, alignment:.left, numberOfLines: 0)
        return name
    }()
    
    //负责人
    let people : UILabel = {
        let peo = UILabel(title: "思美达科技", textColor: klightGreyColor, fontSize: 13, alignment:.center, numberOfLines: 0)
        return peo
    }()
    let kehu : UILabel = {
        let peo = UILabel(title: "客户:", textColor: klightGreyColor, fontSize: 13, alignment:.center, numberOfLines: 0)
        return peo
    }()
    
    //日期
    let riqi : UILabel = {
        let date = UILabel(title: "2018-01-01", textColor: klightGreyColor, fontSize: 13, alignment:.center, numberOfLines: 0)
        return date
    }()
    //截止日期
    let jiezhi : UILabel = {
        let peo = UILabel(title: "创建日期:", textColor: klightGreyColor, fontSize: 13, alignment:.center, numberOfLines: 0)
        return peo
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameText)
        contentView.addSubview(people)
        contentView.addSubview(riqi)
        contentView.addSubview(kehu)
        contentView.addSubview(jiezhi)
        //布局
        nameText.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(self.contentView)?.setOffset(AutoGetWidth(width: 14))
            make?.top.mas_equalTo()(self.contentView)?.setOffset(AutoGetWidth(width: 18))
            make?.right.mas_equalTo()(self.contentView)?.setOffset(-kLeftDis)
        }
        
        kehu.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(nameText)
            make?.top.mas_equalTo()(nameText.mas_bottom)?.setOffset(AutoGetWidth(width: 9))
        }
        people.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(kehu.mas_right)
            make?.top.mas_equalTo()(kehu.mas_top)
        }
        jiezhi.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(kehu)
            make?.top.mas_equalTo()(kehu.mas_bottom)?.setOffset(AutoGetWidth(width: 7))
            make?.bottom.mas_equalTo()(contentView.bottom)?.setOffset(-AutoGetWidth(width: 20))
        }
        riqi.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(jiezhi.mas_right)
            make?.top.mas_equalTo()(people.mas_bottom)?.setOffset(AutoGetWidth(width: 7))
            // make?.bottom.mas_equalTo()(contentView.bottom)?.setOffset(-20)
        }
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

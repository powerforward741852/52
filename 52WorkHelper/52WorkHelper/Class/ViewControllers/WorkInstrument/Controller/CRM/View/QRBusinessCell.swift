//
//  QRBusinessCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/6.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRBusinessCell: UITableViewCell {
    
    var model : QRBusinessModel?{
        didSet{
//            //商机名字
//            var businessName = ""
//            //预计结单时间
//            var closeDate = ""
//            //主键
//            var entityId = ""
//            //预计金额
//            var estimatedAmount = ""
//            //重要程度 0：重要 1：普通
//            var importance = ""
//            //客户名称
//            var name = ""
//            //客户负责人
//            var personInCharge = ""
//            //销售阶段
//            var salesStage = ""

            if let xx = model?.businessName {
            self.nameText.text = xx
            }else{
             self.nameText.text = ""
            }
            if let xx = model?.personInCharge{
                self.people.text = xx + "负责"
            }else{
                self.people.text = ""
            }
            if let xx = model?.name{
                self.company.text = xx 
            }else{
                self.company.text = ""
            }
            if let xx = model?.importance{
                if  xx == 0 {
                    redImage.isHidden = false
                }else{
                    redImage.isHidden = true
                }
            }
            
            
            
            if let xx = model?.closeDate{
                self.riqi.text = "预计结单日期:\(xx)"
            }
            if let xxx = model?.estimatedAmount{
                self.money.text = "￥\(xxx)"
            }
            if let xxx = model?.salesStage {
                //截取括号内的字符
                let  start = xxx.index(of:"(")
                var st = xxx[start!...]
                st.removeFirst()
                st.removeLast()
                 self.jindu.setTitle(String(st), for: .normal)
            }
            
        }
    }
    
    //名字
    let nameText : UILabel = {
        let name = UILabel(title: "名称XXX// MARK", textColor: UIColor.black, fontSize: 16, alignment:.center, numberOfLines: 1)
        return name
    }()
    //红点
    let redImage : UIImageView = {
        let image = imageWithColor(color: kredColor, size: CGSize(width: 8, height: 8))
        let red = UIImageView(image: image)
        red.layer.cornerRadius = 4
        red.clipsToBounds = true
        return red
    }()
    //负责人
    let people : UILabel = {
        let peo = UILabel(title: "负责人", textColor: klightGreyColor, fontSize: 13, alignment:.center, numberOfLines: 1)
        return peo
    }()
    //
    let sparetorLine : UIView = {
        //let line = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth-20, height: 1))
        let line = UIView()
        line.backgroundColor = klightGreyColor
        return line
    }()
    //公司
    let company : UILabel = {
        let com = UILabel(title: "公司", textColor: klightGreyColor, fontSize: 13, alignment:.left, numberOfLines: 1)
        return com
    }()
    //日期
    let riqi : UILabel = {
        let date = UILabel(title: "预计结算日期:2011-01-01", textColor: klightGreyColor, fontSize: 13, alignment:.center, numberOfLines: 1)
        return date
    }()
    
    let greyLine : UIView = {
        //let line = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth-20, height: 1))
        let line = UIView()
        line.backgroundColor = kProjectBgColor
        return line
    }()
    //money
    let money : UILabel = {
        let str =  OCTool.countNumAndChangeformat("1111111111")
        let mony = UILabel(title: "￥\(str!)", textColor: korgColor, fontSize: 15, alignment:.center, numberOfLines: 1)
        //加粗
        mony.font = UIFont.boldSystemFont(ofSize: 20)
        return mony
    }()
    
    //进度
    let jindu : UIButton = {
        let ima = imageWithColor(color: klightBlueColor, size: CGSize(width: 64, height: 22))
        let but = UIButton(title: "10%", imgName: nil, backgroundImage: nil, titleColor: UIColor.black, fontSize: 14)
        but.setBackgroundImage(ima, for: .normal)
        but.layer.cornerRadius = 11
        but.clipsToBounds = true
        but.isUserInteractionEnabled = false
        but.setTitleColor(kColorRGB(r: 18, g: 159, b: 252), for: .normal)
        but.titleLabel?.font = kFontSize11
        return but
    }()
    //greyLine
    let grey : UIView = {
        let ima = UIView()
        ima.backgroundColor = kProjectBgColor
        return ima
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameText)
        contentView.addSubview(redImage)
        contentView.addSubview(riqi)
        contentView.addSubview(company)
        contentView.addSubview(sparetorLine)
        contentView.addSubview(people)
        contentView.addSubview(greyLine)
        contentView.addSubview(money)
        contentView.addSubview(jindu)
        contentView.addSubview(grey)
        //布局
        nameText.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(self.contentView)?.setOffset(kLeftDis)
            make?.top.mas_equalTo()(self.contentView)?.setOffset(AutoGetWidth(width: 18))
            make?.width.lessThanOrEqualTo()(AutoGetWidth(width: 250))
        }
        redImage.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(nameText.mas_right)?.setOffset(AutoGetWidth(width: 8))
            make?.centerY.mas_equalTo()(nameText)
        }
        people.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(nameText)
            make?.top.mas_equalTo()(nameText.mas_bottom)?.setOffset(AutoGetWidth(width: 11))
            make?.width.lessThanOrEqualTo()(AutoGetWidth(width: 120))
        }
        sparetorLine.mas_makeConstraints { (make) in
            make?.width.mas_equalTo()(1)
            make?.height.mas_equalTo()(10)
            make?.left.mas_equalTo()(people.mas_right)?.setOffset(AutoGetWidth(width: 7))
            make?.centerY.mas_equalTo()(people)
        }
        
        company.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(people.mas_right)?.setOffset(AutoGetWidth(width: 14))
            make?.top.mas_equalTo()(people)
            make?.right.mas_equalTo()(contentView)?.setOffset(-AutoGetWidth(width: 15))
        }
        
        riqi.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(people)
            make?.top.mas_equalTo()(people.mas_bottom)?.setOffset(AutoGetWidth(width: 9))
            
        }
        
        greyLine.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(riqi.mas_bottom)?.setOffset(AutoGetWidth(width: 16))
            make?.left.mas_equalTo()(contentView)?.setOffset(AutoGetWidth(width: 14))
            make?.height.mas_equalTo()(1)
            make?.right.mas_equalTo()(contentView)
        }
        
        money.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(greyLine.mas_bottom)?.setOffset(AutoGetWidth(width: 9))
            make?.left.mas_equalTo()(contentView)?.setOffset(AutoGetWidth(width: 15))
        }
        
        jindu.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(greyLine.mas_bottom)?.setOffset(AutoGetWidth(width: 9))
            make?.right.mas_equalTo()(contentView.mas_right)?.setOffset(-AutoGetWidth(width: 14))
        }
        grey.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(jindu.mas_bottom)?.setOffset(AutoGetWidth(width: 9))
            make?.left.mas_equalTo()(contentView)
            make?.width.mas_equalTo()(contentView)
            make?.height.mas_equalTo()(8)
            make?.bottom.mas_equalTo()(contentView)
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

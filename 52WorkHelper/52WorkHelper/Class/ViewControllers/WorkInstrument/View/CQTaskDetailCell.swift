//
//  CQTaskDetailCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/29.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol CQTaskDetailFinishDelegate : NSObjectProtocol {
    func finishClick(index:IndexPath)
    func commentPeople(comment:QRCommentDataModel ,taskId:String)
    func liuYanPeople(taskId:String)
}

class CQTaskDetailCell: UITableViewCell {

    weak var finishDelegate:CQTaskDetailFinishDelegate?
    
    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 17), width: AutoGetWidth(width: 36), height: AutoGetWidth(width: 36)))
        iconImg.image = UIImage.init(named: "personDefaultIcon")
        iconImg.layer.cornerRadius = AutoGetWidth(width: 18)
        iconImg.clipsToBounds = true
        return iconImg
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + kLeftDis, y: AutoGetHeight(height: 18.5), width: kWidth/3, height: AutoGetHeight(height: 15)))
        nameLab.text = "Alans"
        nameLab.textAlignment = .left
        nameLab.textColor = UIColor.black
        nameLab.font = kFontSize15
        return nameLab
    }()
    
    lazy var contentLab: UILabel = {
        let contentLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + kLeftDis, y:self.nameLab.bottom + AutoGetHeight(height: 5), width: kWidth - AutoGetWidth(width: 77), height: AutoGetHeight(height: 13)))
        contentLab.text = "Alans"
        contentLab.textAlignment = .left
        contentLab.textColor = kLyGrayColor
        contentLab.font = kFontSize13
        return contentLab
    }()
    
    lazy var timeLab: UILabel = {
        let timeLab = UILabel.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 150), y: AutoGetHeight(height: 18), width: AutoGetWidth(width: 135), height: AutoGetHeight(height: 11)))
        timeLab.text = "01-01 08:00"
        timeLab.textAlignment = .right
        timeLab.textColor = kLyGrayColor
        timeLab.font = kFontSize11
        return timeLab
    }()
    
    lazy var agreeBtn: UIButton = {
        let agreeBtn = UIButton.init(type: .custom)
        agreeBtn.frame = CGRect.init(x: kWidth - AutoGetWidth(width: 88), y: AutoGetHeight(height: 18), width: AutoGetWidth(width: 63), height: AutoGetHeight(height: 30))
        agreeBtn.titleLabel?.font = kFontSize16
        agreeBtn.setTitle("完成", for: .normal)
        agreeBtn.layer.cornerRadius = 3
        agreeBtn.setTitleColor(kLightBlueColor, for: .normal)
        agreeBtn.backgroundColor = UIColor.colorWithHexString(hex: "#d7f1fd")
        agreeBtn.addTarget(self, action: #selector(agreeClick(sender:)), for: .touchUpInside)
        return agreeBtn
    }()
    
    lazy var meClickBtn: UIButton = {
        let meClickBtn = UIButton.init(type: .custom)
        meClickBtn.frame = CGRect.init(x: kWidth - AutoGetWidth(width: 30), y:(iconImg.bottom - AutoGetHeight(height: 14))/2, width: AutoGetHeight(height: 14.5), height: AutoGetHeight(height: 14))
      //  meClickBtn.titleLabel?.font = kFontSize16
        meClickBtn.setImage(UIImage(named: "pingl"), for: .normal)
        meClickBtn.addTarget(self, action: #selector(commentClick(sender:)), for: .touchUpInside)
        return meClickBtn
    }()
    
    //评论和点赞人明细
    
    lazy var evaluateBg : UIView = {
        let evaluateBg =  UIView(frame: CGRect.zero)
        evaluateBg.backgroundColor = UIColor.colorWithHexString(hex: "#f7f7f7")
        return evaluateBg
    }()

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    
    func setUp()  {
        self.addSubview(self.iconImg)
        self.addSubview(self.nameLab)
        self.addSubview(self.contentLab)
        self.addSubview(self.timeLab)
        self.addSubview(agreeBtn)
        self.addSubview(meClickBtn)
        self.addSubview(evaluateBg)
        agreeBtn.isHidden = true
    }
    @objc func commentClick(sender:UIButton){
        if self.finishDelegate != nil {
            self.finishDelegate?.liuYanPeople(taskId: model!.partakeId)
        }
    }
    @objc func agreeClick(sender:UIButton)  {
        let btn = sender
        let cell = superUITableViewCell(of: btn)
        let table = superUITableView(of: btn)
        let index = table?.indexPath(for: cell!)
        if self.finishDelegate != nil {
            self.finishDelegate?.finishClick(index:index!)
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
    
    //定义模型属性
    var model: CQTaskUserModel? {
        didSet {
            self.iconImg.sd_setImage(with: URL(string: model?.headImage ?? ""), placeholderImage:UIImage.init(named: "personDefaultIcon") )
            if model?.realName == STUserTool.account().realName {
                self.nameLab.text = "我"
                meClickBtn.isEnabled = false
                meClickBtn.isHidden = true
            }else{
                self.nameLab.text = model?.realName
                meClickBtn.isEnabled = true
                meClickBtn.isHidden = false
            }
            self.timeLab.text = model?.finishTime
            if model?.userId == STUserTool.account().userID {
                if (model?.finishSign)! {
                    self.contentLab.isHidden = false
                    self.contentLab.text =  "已完成"
                    self.timeLab.isHidden = false
                    self.agreeBtn.isHidden = true
                }else{
                    self.contentLab.isHidden = true
                    self.timeLab.isHidden = true
                    self.agreeBtn.isHidden = false
                }
            }else{
                self.contentLab.isHidden = false
                if (model?.finishSign)!{
                    self.contentLab.text =  "已完成"
                }else{
                    self.contentLab.text = "未完成"
                }
                self.timeLab.isHidden = false
                self.agreeBtn.isHidden = true
            }
            
            //评论列表
            //背景高度
            evaluateBg.frame = CGRect.zero
            var rowheights:CGFloat = 0
            var backGroundtop : CGFloat = 0;
            let bgwidth = kWidth - nameLab.left - AutoGetWidth(width: 15)
            evaluateBg.removeAllSubviews()

            if (model?.commentData.count)!>0{
                
                backGroundtop = backGroundtop + 5
                for (_,value) in (model?.commentData.enumerated())!{
                    let lab = creatLable(width: bgwidth, top: backGroundtop, commentData: value)
                    backGroundtop = backGroundtop + lab.height
                    evaluateBg.addSubview(lab)
                }
                backGroundtop = backGroundtop + 5
            }
            
            
            if backGroundtop>0{
                evaluateBg.frame =  CGRect(x: nameLab.left, y: self.contentLab.bottom + 10,width: bgwidth, height: backGroundtop)
                
                rowheights = evaluateBg.bottom + 10
            }else{
                rowheights = contentLab.bottom + 15
            }
           // rowheights = rowheights + 10
            model?.rowHeight = rowheights
            
            
            
        }
    }
    
    
    
    func creatLable(width:CGFloat,top:CGFloat,commentData:QRCommentDataModel)->CommentLabel  {
        let Text = CommentLabel(frame:  CGRect(x: 0, y: top, width: width, height: 0))
        Text.linkLabel?.textColor = UIColor.colorWithHexString(hex: "#737373")
        let linkDict = [NSAttributedStringKey.foregroundColor:UIColor.colorWithHexString(hex: "#0081c8")]
        let activeLinkDict = [NSAttributedStringKey.backgroundColor : kProjectBgColor,NSAttributedStringKey.foregroundColor:klightGreyColor]
        Text.linkLabel!.linkTextAttributes = linkDict
        Text.linkLabel!.activeLinkTextAttributes = activeLinkDict
        Text.setModel(mod: commentData, width: width)
        Text.clickText = {[unowned self]mod in
           //点击文本
            if self.finishDelegate != nil {
                self.finishDelegate?.commentPeople(comment: mod ,taskId:self.model!.partakeId)
            }
        }
        Text.clickLinkName = {mod in
            print(mod.circleCommentId)
        }
        return Text
        
    }
    
}

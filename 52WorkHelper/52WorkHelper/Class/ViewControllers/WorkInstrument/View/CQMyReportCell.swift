//
//  CQMyReportCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/9.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol CQFindMoreClickDelegate : NSObjectProtocol{
    func goToReportFullTextView(index:IndexPath)
}


class CQMyReportCell: UITableViewCell {

    weak var findDelegate:CQFindMoreClickDelegate?
    var viewHeight:CGFloat = AutoGetHeight(height: 74)
    
//    lazy var bgView: UIView = {
//        let bgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 290)))
//        bgView.backgroundColor = UIColor.white
//        return bgView
//    }()
    
    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetWidth(width: 18), width: AutoGetWidth(width: 38), height: AutoGetWidth(width: 38)))
        iconImg.layer.cornerRadius = AutoGetWidth(width: 19)
        iconImg.clipsToBounds = true
        iconImg.image = UIImage.init(named: "personDefaultIcon")
        return iconImg
    }()
    
    lazy var circleLab: UILabel = {
        let circleLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 4), y: AutoGetWidth(width: 24), width: AutoGetWidth(width: 2), height: AutoGetWidth(width: 2)))
        circleLab.backgroundColor = UIColor.red
        circleLab.layer.cornerRadius = AutoGetWidth(width: 1)
        circleLab.clipsToBounds = true
        
        return circleLab
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 12), y: AutoGetWidth(width: 18), width: kWidth/3 * CGFloat(2), height: AutoGetHeight(height: 16)))
        nameLab.font = kFontSize16
        nameLab.textAlignment = .left
        nameLab.textColor = UIColor.black
        nameLab.text = "我的日报"
        return nameLab
    }()
    
    lazy var timeLab: UILabel = {
        let timeLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 12), y:self.nameLab.bottom + AutoGetWidth(width: 6), width: kWidth/3 * CGFloat(2), height: AutoGetHeight(height: 11)))
        timeLab.font = kFontSize11
        timeLab.textAlignment = .left
        timeLab.textColor = kLyGrayColor
        timeLab.text = "2月12日 15:00"
        return timeLab
    }()
    
    lazy var isReadLab: UILabel = {
        let isReadLab = UILabel.init(frame: CGRect.init(x: kWidth/2, y: AutoGetWidth(width: 31), width: kWidth/2 - kLeftDis, height: AutoGetHeight(height: 12)))
        isReadLab.font = kFontSize12
        isReadLab.textAlignment = .right
        isReadLab.textColor = kLyGrayColor
        isReadLab.text = "未读"
        return isReadLab
    }()
    
    lazy var todayFinishWorkLab: UILabel = {
        let todayFinishWorkLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.viewHeight+5, width: kHaveLeftWidth, height: AutoGetHeight(height: 15)))
        todayFinishWorkLab.font = kFontSize15
        todayFinishWorkLab.textAlignment = .left
        todayFinishWorkLab.textColor = kLyGrayColor
        todayFinishWorkLab.text = "今日完成工作"
        return todayFinishWorkLab
    }()
    
    lazy var todayFinishWorkContentLab: UILabel = {
        let todayFinishWorkContentLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: AutoGetHeight(height: 36)))
        todayFinishWorkContentLab.font = kFontSize15
        todayFinishWorkContentLab.textAlignment = .left
        todayFinishWorkContentLab.textColor = UIColor.black
        todayFinishWorkContentLab.text = "我就想写一堆测试文字来看看现在给的还不够吗我去了继续写应该够了吧估计是够了也许够了 够了够了"
        todayFinishWorkContentLab.numberOfLines = 0
        return todayFinishWorkContentLab
    }()
    
    lazy var todayNotFinishWorkLab: UILabel = {
        let todayNotFinishWorkLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.viewHeight+5, width: kHaveLeftWidth, height: AutoGetHeight(height: 15)))
        todayNotFinishWorkLab.font = kFontSize15
        todayNotFinishWorkLab.textAlignment = .left
        todayNotFinishWorkLab.textColor = kLyGrayColor
        todayNotFinishWorkLab.text = "未完成工作"
        return todayNotFinishWorkLab
    }()
    
    lazy var todayNotFinishWorkContentLab: UILabel = {
        let todayNotFinishWorkContentLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: AutoGetHeight(height: 15)))
        todayNotFinishWorkContentLab.font = kFontSize15
        todayNotFinishWorkContentLab.textAlignment = .left
        todayNotFinishWorkContentLab.textColor = UIColor.black
        todayNotFinishWorkContentLab.text = "未完成工作..就是随便瞎写写"
        todayNotFinishWorkContentLab.numberOfLines = 0
        return todayNotFinishWorkContentLab
    }()
    
    lazy var needCoordinateLab: UILabel = {
        let needCoordinateLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.viewHeight+5, width: kHaveLeftWidth, height: AutoGetHeight(height: 15)))
        needCoordinateLab.font = kFontSize15
        needCoordinateLab.textAlignment = .left
        needCoordinateLab.textColor = kLyGrayColor
        needCoordinateLab.text = "需协调工作"
        return needCoordinateLab
    }()
    
    lazy var needCoordinateContentLab: UILabel = {
        let needCoordinateContentLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: AutoGetHeight(height: 15)))
        needCoordinateContentLab.font = kFontSize15
        needCoordinateContentLab.textAlignment = .left
        needCoordinateContentLab.textColor = UIColor.black
        needCoordinateContentLab.text = "需协调工作,定制日志末班，信息收集更准确"
        needCoordinateContentLab.numberOfLines = 0
        return needCoordinateContentLab
    }()
    
    lazy var sumLab: UILabel = {
        let sumLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.viewHeight+5, width: kHaveLeftWidth, height: AutoGetHeight(height: 15)))
        sumLab.font = kFontSize15
        sumLab.textAlignment = .left
        sumLab.textColor = kLyGrayColor
        sumLab.text = "需帮助与支持"
        return sumLab
    }()
    
    lazy var sumDetailLab: UILabel = {
        let sumDetailLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: AutoGetHeight(height: 15)))
        sumDetailLab.font = kFontSize15
        sumDetailLab.textAlignment = .left
        sumDetailLab.textColor = UIColor.black
        sumDetailLab.text = "需协调工作,定制日志末班，信息收集更准确"
        sumDetailLab.numberOfLines = 0
        return sumDetailLab
    }()
    
    lazy var findMoreBtn: UIButton = {
        let findMoreBtn = UIButton.init(type: .custom)
        findMoreBtn.frame = CGRect.init(x: kWidth - AutoGetWidth(width: 85), y: self.viewHeight, width: AutoGetWidth(width: 70), height: AutoGetHeight(height: 24))
        findMoreBtn.setTitle("查看全文>", for: .normal)
        findMoreBtn.addTarget(self, action: #selector(findMoreClick(sender:)), for: UIControlEvents.touchUpInside)
        findMoreBtn.setTitleColor(kLightBlueColor, for: .normal)
        findMoreBtn.titleLabel?.font = kFontSize12
        return findMoreBtn
    }()
    
    lazy var footView: UIView = {
        let footView = UIView.init(frame: CGRect.init(x: 0, y: self.viewHeight, width: kWidth, height: AutoGetHeight(height: 13)))
        footView.backgroundColor = kProjectBgColor
        return footView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        setUp()
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
    
    func setUp()  {
        self.addSubview(self.iconImg)
        self.addSubview(self.nameLab)
        self.addSubview(self.timeLab)
        self.addSubview(self.isReadLab)
        self.addSubview(self.circleLab)
    }
    
    
    @objc func findMoreClick(sender:AnyObject)  {
        let btn = sender as! UIButton
        let cell = superUITableViewCell(of: btn)
        let table = superUITableView(of: btn)
        let index = table?.indexPath(for: cell!)
        DLog(index)
        
        if self.findDelegate != nil {
            self.findDelegate?.goToReportFullTextView(index: index!)
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
    
    func getHeightWithModel(model:CQReportModel) -> CGFloat {
        
        
        if model.reportType == "1"{
            self.addSubview(self.todayFinishWorkLab)
            self.viewHeight += AutoGetHeight(height: 15)
            self.addSubview(self.todayFinishWorkContentLab)
            let firstHeight = getTextHeight(text: model.hasdoWork, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
            self.todayFinishWorkContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: firstHeight)
            self.viewHeight += firstHeight
            self.addSubview(self.todayNotFinishWorkLab)
            self.viewHeight += AutoGetHeight(height: 15)
            self.addSubview(self.todayNotFinishWorkContentLab)
            let secHeight = getTextHeight(text: model.teamWork, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
            self.todayNotFinishWorkContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: secHeight)
            self.viewHeight += secHeight
            self.addSubview(self.needCoordinateLab)
            self.viewHeight += AutoGetHeight(height: 15)
            self.addSubview(self.needCoordinateContentLab)
            let thirdHeight = getTextHeight(text: model.undoWork, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
            self.needCoordinateContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: thirdHeight)
            self.viewHeight += thirdHeight
            self.addSubview(self.findMoreBtn)
            self.viewHeight += AutoGetHeight(height: 25)
            self.addSubview(self.footView)
            self.viewHeight += AutoGetHeight(height: 13)
            
            self.todayFinishWorkLab.text = "今日完成工作"
            self.todayNotFinishWorkLab.text = "未完成工作"
            self.needCoordinateLab.text = "需协调工作"
            self.todayFinishWorkContentLab.text = model.hasdoWork
            self.todayNotFinishWorkContentLab.text = model.undoWork
            self.needCoordinateContentLab.text = model.teamWork
        }else if model.reportType == "2"{
            
            
            self.addSubview(self.todayFinishWorkLab)
            self.viewHeight += AutoGetHeight(height: 15)
            self.addSubview(self.todayFinishWorkContentLab)
            let firstHeight = getTextHeight(text: model.thisWorkContent, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
            self.todayFinishWorkContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: firstHeight)
            self.viewHeight += firstHeight
            self.addSubview(self.todayNotFinishWorkLab)
            self.viewHeight += AutoGetHeight(height: 15)
            self.addSubview(self.todayNotFinishWorkContentLab)
            let secHeight = getTextHeight(text: model.thisWorkSummary, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
            self.todayNotFinishWorkContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: secHeight)
            self.viewHeight += secHeight
            self.addSubview(self.needCoordinateLab)
            self.viewHeight += AutoGetHeight(height: 15)
            self.addSubview(self.needCoordinateContentLab)
            let thirdHeight = getTextHeight(text: model.nextWorkPlan, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
            self.needCoordinateContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: thirdHeight)
            self.viewHeight += thirdHeight
            self.addSubview(self.sumLab)
            self.viewHeight += AutoGetHeight(height: 15)
            self.addSubview(self.sumDetailLab)
            let forHeight = getTextHeight(text: model.needHelp, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
            self.sumDetailLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: forHeight)
            self.viewHeight += forHeight
            self.addSubview(self.findMoreBtn)
            self.viewHeight += AutoGetHeight(height: 25)
            self.addSubview(self.footView)
            self.viewHeight += AutoGetHeight(height: 13)
            
            self.todayFinishWorkLab.text = "本周工作内容"
            self.todayNotFinishWorkLab.text = "本周工作总结"
            self.needCoordinateLab.text = "下周工作计划"
            self.sumLab.text = "需帮助与支持"
            self.todayFinishWorkContentLab.text = model.thisWorkContent
            self.todayNotFinishWorkContentLab.text = model.thisWorkSummary
            self.needCoordinateContentLab.text = model.nextWorkPlan
            self.sumDetailLab.text = model.needHelp
        }else if model.reportType == "3"{
            
            
            self.addSubview(self.todayFinishWorkLab)
            self.viewHeight += AutoGetHeight(height: 15)
            self.addSubview(self.todayFinishWorkContentLab)
            let firstHeight = getTextHeight(text: model.thisWorkContent, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
            self.todayFinishWorkContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: firstHeight)
            self.viewHeight += firstHeight
            self.addSubview(self.todayNotFinishWorkLab)
            self.viewHeight += AutoGetHeight(height: 15)
            self.addSubview(self.todayNotFinishWorkContentLab)
            let secHeight = getTextHeight(text: model.thisWorkSummary, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
            self.todayNotFinishWorkContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: secHeight)
            self.viewHeight += secHeight
            self.addSubview(self.needCoordinateLab)
            self.viewHeight += AutoGetHeight(height: 15)
            self.addSubview(self.needCoordinateContentLab)
            let thirdHeight = getTextHeight(text: model.nextWorkPlan, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
            self.needCoordinateContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: thirdHeight)
            self.viewHeight += thirdHeight
            self.addSubview(self.sumLab)
            self.viewHeight += AutoGetHeight(height: 15)
            self.addSubview(self.sumDetailLab)
            let forHeight = getTextHeight(text: model.needHelp, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
            self.sumDetailLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: forHeight)
            self.viewHeight += forHeight
            self.addSubview(self.findMoreBtn)
            self.viewHeight += AutoGetHeight(height: 25)
            self.addSubview(self.footView)
            self.viewHeight += AutoGetHeight(height: 13)
            
            self.todayFinishWorkLab.text = "本月工作内容"
            self.todayNotFinishWorkLab.text = "本月工作总结"
            self.needCoordinateLab.text = "下月工作计划"
            self.sumLab.text = "需帮助与支持"
            self.todayFinishWorkContentLab.text = model.thisWorkContent
            self.todayNotFinishWorkContentLab.text = model.thisWorkSummary
            self.needCoordinateContentLab.text = model.nextWorkPlan
            self.sumDetailLab.text = model.needHelp
        }
        return self.viewHeight
    }
    
    
    //定义模型属性
    var model: CQReportModel? {
        didSet {
            
            
            self.iconImg.sd_setImage(with: URL(string: model?.createUserHeadImage ?? ""), placeholderImage:UIImage.init(named: "personDefaultIcon") )
            self.nameLab.text = model?.createUserRealName
            self.timeLab.text = model?.createTime
            if (model?.readSign)! {
                self.isReadLab.text = "已读"
                self.isReadLab.textColor = UIColor.black
            }else{
                self.isReadLab.text = "未读"
                self.isReadLab.textColor = kLyGrayColor
            }
            
            
            
            if model?.reportType == "1"{
                self.addSubview(self.todayFinishWorkLab)
                self.viewHeight += AutoGetHeight(height: 15)
                self.addSubview(self.todayFinishWorkContentLab)
                let firstHeight = getTextHeight(text: model!.hasdoWork, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
                self.todayFinishWorkContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: firstHeight)
                self.viewHeight += firstHeight
                self.addSubview(self.todayNotFinishWorkLab)
                self.viewHeight += AutoGetHeight(height: 15)
                self.addSubview(self.todayNotFinishWorkContentLab)
                let secHeight = getTextHeight(text: model!.teamWork, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
                self.todayNotFinishWorkContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: secHeight)
                self.viewHeight += secHeight
                self.addSubview(self.needCoordinateLab)
                self.viewHeight += AutoGetHeight(height: 15)
                self.addSubview(self.needCoordinateContentLab)
                let thirdHeight = getTextHeight(text: model!.undoWork, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
                self.needCoordinateContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: thirdHeight)
                self.viewHeight += thirdHeight
                self.addSubview(self.findMoreBtn)
                self.viewHeight += AutoGetHeight(height: 25)
                self.addSubview(self.footView)
                self.viewHeight += AutoGetHeight(height: 13)
                
                self.todayFinishWorkLab.text = "今日完成工作"
                self.todayNotFinishWorkLab.text = "未完成工作"
                self.needCoordinateLab.text = "需协调工作"
                self.todayFinishWorkContentLab.text = model?.hasdoWork
                self.todayNotFinishWorkContentLab.text = model?.teamWork
                self.needCoordinateContentLab.text = model?.undoWork
            }else if model?.reportType == "2"{
                
                
                self.addSubview(self.todayFinishWorkLab)
                self.viewHeight += AutoGetHeight(height: 15)
                self.addSubview(self.todayFinishWorkContentLab)
                let firstHeight = getTextHeight(text: model!.thisWorkContent, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
                self.todayFinishWorkContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: firstHeight)
                self.viewHeight += firstHeight
                self.addSubview(self.todayNotFinishWorkLab)
                self.viewHeight += AutoGetHeight(height: 15)
                self.addSubview(self.todayNotFinishWorkContentLab)
                let secHeight = getTextHeight(text: model!.thisWorkSummary, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
                self.todayNotFinishWorkContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: secHeight)
                self.viewHeight += secHeight
                self.addSubview(self.needCoordinateLab)
                self.viewHeight += AutoGetHeight(height: 15)
                self.addSubview(self.needCoordinateContentLab)
                let thirdHeight = getTextHeight(text: model!.nextWorkPlan, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
                self.needCoordinateContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: thirdHeight)
                self.viewHeight += thirdHeight
                self.addSubview(self.sumLab)
                self.viewHeight += AutoGetHeight(height: 15)
                self.addSubview(self.sumDetailLab)
                let forHeight = getTextHeight(text: model!.needHelp, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
                self.sumDetailLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: forHeight)
                self.viewHeight += forHeight
                self.addSubview(self.findMoreBtn)
                self.viewHeight += AutoGetHeight(height: 25)
                self.addSubview(self.footView)
                self.viewHeight += AutoGetHeight(height: 13)
                
                self.todayFinishWorkLab.text = "本周工作内容"
                self.todayNotFinishWorkLab.text = "本周工作总结"
                self.needCoordinateLab.text = "下周工作计划"
                self.sumLab.text = "需帮助与支持"
                self.todayFinishWorkContentLab.text = model?.thisWorkContent
                self.todayNotFinishWorkContentLab.text = model?.thisWorkSummary
                self.needCoordinateContentLab.text = model?.nextWorkPlan
                self.sumDetailLab.text = model?.needHelp
            }else if model?.reportType == "3"{
                
                
                self.addSubview(self.todayFinishWorkLab)
                self.viewHeight += AutoGetHeight(height: 15)
                self.addSubview(self.todayFinishWorkContentLab)
                let firstHeight = getTextHeight(text: model!.thisWorkContent, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
                self.todayFinishWorkContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: firstHeight)
                self.viewHeight += firstHeight
                self.addSubview(self.todayNotFinishWorkLab)
                self.viewHeight += AutoGetHeight(height: 15)
                self.addSubview(self.todayNotFinishWorkContentLab)
                let secHeight = getTextHeight(text: model!.thisWorkSummary, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
                self.todayNotFinishWorkContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: secHeight)
                self.viewHeight += secHeight
                self.addSubview(self.needCoordinateLab)
                self.viewHeight += AutoGetHeight(height: 15)
                self.addSubview(self.needCoordinateContentLab)
                let thirdHeight = getTextHeight(text: model!.nextWorkPlan, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
                self.needCoordinateContentLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: thirdHeight)
                self.viewHeight += thirdHeight
                self.addSubview(self.sumLab)
                self.viewHeight += AutoGetHeight(height: 15)
                self.addSubview(self.sumDetailLab)
                let forHeight = getTextHeight(text: model!.needHelp, font: kFontSize15, width: kHaveLeftWidth) + AutoGetHeight(height: 19)
                self.sumDetailLab.frame = CGRect.init(x: kLeftDis, y:self.viewHeight, width: kHaveLeftWidth, height: forHeight)
                self.viewHeight += forHeight
                self.addSubview(self.findMoreBtn)
                self.viewHeight += AutoGetHeight(height: 25)
                self.addSubview(self.footView)
                self.viewHeight += AutoGetHeight(height: 13)
                
                self.todayFinishWorkLab.text = "本月工作内容"
                self.todayNotFinishWorkLab.text = "本月工作总结"
                self.needCoordinateLab.text = "下月工作计划"
                self.sumLab.text = "需帮助与支持"
                self.todayFinishWorkContentLab.text = model?.thisWorkContent
                self.todayNotFinishWorkContentLab.text = model?.thisWorkSummary
                self.needCoordinateContentLab.text = model?.nextWorkPlan
                self.sumDetailLab.text = model?.needHelp
            }
            let isRead:Bool = ((model?.readSign) != nil)
            if isRead {
                self.circleLab.isHidden = true
            }else{
                self.circleLab.isHidden = false
            }
            
        }
    }

}

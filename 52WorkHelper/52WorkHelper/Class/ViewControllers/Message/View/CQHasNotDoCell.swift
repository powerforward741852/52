//
//  CQHasNotDoCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/7/24.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQHasNotDoCell: UITableViewCell {

    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 15.5), width: AutoGetWidth(width: 33), height: AutoGetWidth(width: 33)))
        iconImg.layer.cornerRadius = AutoGetWidth(width: 16.5)
        iconImg.clipsToBounds = true
        return iconImg
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + kLeftDis, y: AutoGetHeight(height: 0), width: kWidth - 2 * kLeftDis - AutoGetWidth(width: 44), height: AutoGetHeight(height: 64)))
        nameLab.text = "Alans"
        nameLab.textAlignment = .left
        nameLab.textColor = UIColor.black
        nameLab.font = kFontSize16
        return nameLab
    }()
    
    lazy var timeLab: UILabel = {
        let timeLab = UILabel.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 200), y: AutoGetHeight(height: 0), width: AutoGetWidth(width: 185), height: AutoGetHeight(height: 30)))
        timeLab.text = "Alans"
        timeLab.textAlignment = .right
        timeLab.textColor = kLyGrayColor
        timeLab.font = kFontSize11
        return timeLab
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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

    
    func setUp() {
        
        
        self.addSubview(iconImg)
        self.addSubview(nameLab)
        self.addSubview(self.timeLab)
    }
    
    //定义模型属性
    var model: CQHasNotHandleModel? {
        didSet {
            if model?.workType == "4"{
                self.iconImg.image = UIImage.init(named: "IndexSchedule")
            }else if model?.workType == "5"{
                self.iconImg.image = UIImage.init(named: "IndexTask")
            }else if model?.workType == "6"{
                self.iconImg.image = UIImage.init(named: "IndexMeeting")
            }else{
                self.iconImg.sd_setImage(with: URL(string: model?.headImage ?? ""), placeholderImage:UIImage.init(named: "CQIndexPersonDefault") )
            }
            
            self.nameLab.text = model?.workName
            
            if model?.publishTime == ""{
               self.timeLab.text = model?.publishTime
            }else{
                let time = updateTimeToCurrennTime(timeStamp: timeToTimeStamp(time: (model?.publishTime)!))
                self.timeLab.text = time
            }
            

            
            
        }
    }
    
    //MARK: -时间转时间戳函数
   
    func timeToTimeStamp(time: String) -> Double {
        let dfmatter = DateFormatter()
        //yyyy-MM-dd HH:mm:ss
        dfmatter.dateFormat="yyyy-MM-dd HH:mm"
        let last = dfmatter.date(from: time)
        let timeStamp = last?.timeIntervalSince1970
        return timeStamp!
    }
    
    //MARK: -时间戳转时间函数
     func timeStampToString(timeStamp: Double)->String {
        //时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
        let timeSta:TimeInterval = TimeInterval(timeStamp )
        let date = NSDate(timeIntervalSince1970: timeSta)
        let dfmatter = DateFormatter()
        //yyyy-MM-dd HH:mm:ss
        dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
        return dfmatter.string(from: date as Date)
    }
    
 
    
    //MARK: -根据后台时间戳返回几分钟前，几小时前，几天前
    func updateTimeToCurrennTime(timeStamp: Double) -> String {
        //获取当前的时间戳
        let currentTime = Date().timeIntervalSince1970
        
        //时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
        let timeSta:TimeInterval = TimeInterval(timeStamp )
        //时间差
        let reduceTime : TimeInterval = currentTime - timeSta
        //时间差小于60秒
        
        //不满足上述条件---或者是未来日期-----直接返回日期
        let date = NSDate(timeIntervalSince1970: timeSta)
        let dfmatter = DateFormatter()
        
//        if reduceTime < 60 {
//            return "刚刚"
//        }
//        //时间差大于一分钟小于60分钟内
//        let mins = Int(reduceTime / 60)
//        if mins < 60 {
//
//            return "\(mins)分钟前"
//        }
        let hours = Int(reduceTime / 3600)
        if hours < 24 {
            dfmatter.dateFormat="HH:mm"
            return dfmatter.string(from: date as Date)
        }
        let days = Int(reduceTime / 3600 / 24)
        if days < 365 {
            dfmatter.dateFormat="MM月dd日"
            return dfmatter.string(from: date as Date)
        }
        
        
       
        
        //yyyy-MM-dd HH:mm:ss
        dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
        return dfmatter.string(from: date as Date)
    }
    
    
}

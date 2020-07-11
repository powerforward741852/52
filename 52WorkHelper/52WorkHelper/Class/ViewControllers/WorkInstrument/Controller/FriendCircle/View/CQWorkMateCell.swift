//
//  CQWorkMateCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/19.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol CQWorkMateCircleDelegate : NSObjectProtocol{
    func zanRequest(index:IndexPath)
    func commentRequest(index:IndexPath)
}

class CQWorkMateCell: UITableViewCell {

    var collectionlayOut:UICollectionViewFlowLayout?
    var collectData = [JSON]()
    var commentData = [CQWorkMateCircleModel]()
    var nameData = [JSON]()
    weak var workmatecircleDeleagate:CQWorkMateCircleDelegate?
    
//    var picDataSource: [JSON]?
    
    
    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetWidth(width: 18), width: AutoGetWidth(width: 32), height:AutoGetWidth(width: 32)))
        iconImg.image = UIImage.init(named: "personDefaultIcon")
        iconImg.layer.cornerRadius = AutoGetWidth(width: 16)
        iconImg.clipsToBounds = true
        return iconImg
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 12), y: AutoGetHeight(height: 19.5), width: kHaveLeftWidth/3 * 2, height: AutoGetHeight(height: 16)))
        nameLab.font = kFontSize16
        nameLab.textColor = UIColor.black
        nameLab.textAlignment = .left
        nameLab.text = "alien"
        return nameLab
    }()
    
    lazy var timeLab: UILabel = {
        let timeLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 12), y:self.nameLab.bottom + AutoGetHeight(height: 5), width: kHaveLeftWidth/3 * 2, height: AutoGetHeight(height: 11)))
        timeLab.font = kFontSize11
        timeLab.textColor = kLyGrayColor
        timeLab.textAlignment = .left
        timeLab.text = "5分钟前"
        return timeLab
    }()
    
    lazy var contentLab: UILabel = {
        let contentLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 12), y:self.timeLab.bottom + AutoGetHeight(height: 15), width: kWidth - 2*kLeftDis - AutoGetWidth(width: 32) - AutoGetWidth(width: 12), height: AutoGetHeight(height: 15)))
        contentLab.font = kFontSize15
        contentLab.textColor = UIColor.black
        contentLab.textAlignment = .left
        contentLab.numberOfLines = 0
        contentLab.text = "随时随地的了解员工工作状况，工作业绩发布周报就像聊天一样简单"
        return contentLab
    }()
    
    lazy var collectionView: UICollectionView = {
        self.collectionlayOut = UICollectionViewFlowLayout.init()
        self.collectionlayOut?.itemSize = CGSize.init(width: AutoGetWidth(width: 180), height: AutoGetWidth(width: 180))
        self.collectionlayOut?.minimumLineSpacing = 5
        self.collectionlayOut?.minimumInteritemSpacing = 5
        self.collectionlayOut?.scrollDirection = UICollectionViewScrollDirection.vertical
//        layOut.headerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 38))
//        layOut.footerReferenceSize = CGSize.init(width: kWidth, height: AutoGetHeight(height: 11))
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 12), y: self.contentLab.bottom + AutoGetHeight(height: 13), width:  kWidth - 2*kLeftDis - AutoGetWidth(width: 32) - AutoGetWidth(width: 12), height: AutoGetWidth(width: 180)), collectionViewLayout: self.collectionlayOut!)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CQWorkMateCircleImageCell.self, forCellWithReuseIdentifier: "CQWorkMateCircleImageCellId")
       
        return collectionView
    }()
    
    lazy var commentBtn: UIButton = {
        let commentBtn = UIButton.init(type: .custom)
        commentBtn.frame = CGRect.init(x: kWidth - AutoGetWidth(width: 129), y: self.collectionView.bottom, width: AutoGetWidth(width: 58), height: AutoGetHeight(height: 31))
        commentBtn.setImage(UIImage.init(named: "CQWorkCircleComment"), for: .normal)
        commentBtn.addTarget(self, action: #selector(commentClick(sender:)), for: .touchUpInside)
        return commentBtn
    }()
    
    lazy var zanBtn: UIButton = {
        let zanBtn = UIButton.init(type: .custom)
        zanBtn.frame = CGRect.init(x: self.commentBtn.right, y: self.collectionView.bottom, width: AutoGetWidth(width: 58), height: AutoGetHeight(height: 31))
        zanBtn.setImage(UIImage.init(named: "CQWorkCircleCancelZan"), for: .normal)
        zanBtn.addTarget(self, action: #selector(zanClick(sender:)), for: .touchUpInside)
        return zanBtn
    }()
    
    
    
    
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 12), y: self.collectionView.bottom + AutoGetHeight(height: 31), width: kWidth - 2*kLeftDis - AutoGetWidth(width: 32) - AutoGetWidth(width: 12), height: AutoGetHeight(height: 26)))
        headView.backgroundColor =  UIColor.colorWithHexString(hex: "#f2f6fc")
        let iconImg = UIImageView.init(frame: CGRect.init(x: AutoGetWidth(width: 13), y: AutoGetHeight(height: 7.5), width: AutoGetWidth(width: 12.5), height: AutoGetHeight(height: 11)))
        iconImg.image = UIImage.init(named: "CQWorkMateCircleHasZan")
        headView.addSubview(iconImg)
        
        
        
        let lab = UILabel.init(frame: CGRect.init(x: iconImg.right + AutoGetWidth(width: 10), y: 0, width: kWidth - 2*kLeftDis - AutoGetWidth(width: 32) - AutoGetWidth(width: 12) - AutoGetWidth(width: 52.5), height: AutoGetHeight(height: 26)))
        lab.tag = 1009
        
        lab.font = kFontSize14
        lab.textColor = UIColor.colorWithHexString(hex: "#1e5f91")
        lab.textAlignment = .left
        headView.addSubview(lab)
        return headView
    }()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 12), y: self.headView.bottom , width: kWidth - 2*kLeftDis - AutoGetWidth(width: 32) - AutoGetWidth(width: 12), height: AutoGetHeight(height: 80)), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        table.backgroundColor = UIColor.colorWithHexString(hex: "#f2f6fc")
        
        table.delegate = self
        table.dataSource = self
        return table
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
    
    @objc func commentClick(sender:UIButton)  {
        let btn = sender
        let cell = superUITableViewCell(of: btn)
        let table = superUITableView(of: btn)
        let index = table?.indexPath(for: cell!)
        DLog(index)
        
        if self.workmatecircleDeleagate != nil {
            self.workmatecircleDeleagate?.commentRequest(index: index!)
        }
    }
    @objc func zanClick(sender:UIButton)  {
        let btn = sender
        let cell = superUITableViewCell(of: btn)
        let table = superUITableView(of: btn)
        let index = table?.indexPath(for: cell!)
        DLog(index)
        
        if self.workmatecircleDeleagate != nil {
            self.workmatecircleDeleagate?.zanRequest(index: index!)
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
    
    func setUp()  {
        self.addSubview(self.iconImg)
        self.addSubview(self.nameLab)
        self.addSubview(self.timeLab)
        self.addSubview(self.contentLab)
        self.addSubview(self.collectionView)
        self.addSubview(self.commentBtn)
        self.addSubview(self.zanBtn)
        
        self.addSubview(self.headView)
        
        self.addSubview(self.table)
        self.table.isHidden = false
        self.table.register(CQWorkMateCircleCommentCell.self, forCellReuseIdentifier: "CQWorkMateCircleCommentCellId")
        
        
    }
    
    //定义模型属性
    var model: CQWorkMateCircleModel? {
        didSet {
            self.iconImg.sd_setImage(with: URL(string: model?.headImage ?? ""), placeholderImage:UIImage.init(named: "personDefaultIcon") )
            self.nameLab.text = model?.realName
            self.timeLab.text = model?.differTime
            self.contentLab.text = model?.articleContent
            let height = self.getTextHeigh(textStr: self.contentLab.text!, font: kFontSize15, width:  kWidth - 2*kLeftDis - AutoGetWidth(width: 32) - AutoGetWidth(width: 12))
            self.contentLab.frame.size.height = height
            if model?.picurlData.count == 0 {
                self.collectionView.frame = CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 12), y: self.contentLab.bottom + AutoGetHeight(height: 13), width:  AutoGetWidth(width: 180), height: AutoGetWidth(width: 0))
                self.collectionlayOut?.itemSize = CGSize.init(width: AutoGetWidth(width: 0), height: AutoGetWidth(width: 0))
                self.commentBtn.frame.origin.y = self.collectionView.bottom
                self.zanBtn.frame.origin.y = self.collectionView.bottom
                self.headView.frame.origin.y = self.collectionView.bottom + AutoGetHeight(height: 31)
                self.table.frame.origin.y = self.headView.bottom
            }else if model?.picurlData.count == 1 {
                self.collectionView.frame = CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 12), y: self.contentLab.bottom + AutoGetHeight(height: 13), width:  AutoGetWidth(width: 180), height: AutoGetWidth(width: 180))
                self.collectionlayOut?.itemSize = CGSize.init(width: AutoGetWidth(width: 180), height: AutoGetWidth(width: 180))
                self.commentBtn.frame.origin.y = self.collectionView.bottom
                self.zanBtn.frame.origin.y = self.collectionView.bottom
                self.headView.frame.origin.y = self.collectionView.bottom + AutoGetHeight(height: 31)
                self.table.frame.origin.y = self.headView.bottom
            }else if model?.picurlData.count == 2 || model?.picurlData.count == 4 {
                self.collectionView.frame = CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 12), y: self.contentLab.bottom + AutoGetHeight(height: 13), width:  AutoGetWidth(width: 163) , height: AutoGetWidth(width: 163))
                if model?.picurlData.count == 2 {
                    self.collectionView.frame.size.height = AutoGetWidth(width: 79)
                }
                self.collectionlayOut?.itemSize = CGSize.init(width: AutoGetWidth(width: 79), height: AutoGetWidth(width: 79))
                self.commentBtn.frame.origin.y = self.collectionView.bottom
                self.zanBtn.frame.origin.y = self.collectionView.bottom
                
                self.headView.frame.origin.y = self.collectionView.bottom + AutoGetHeight(height: 31)
                self.table.frame.origin.y = self.headView.bottom
            }else{
                self.collectionView.frame = CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 12), y: self.contentLab.bottom + AutoGetHeight(height: 13), width:  AutoGetWidth(width: 247), height: AutoGetWidth(width: 79))
                if model?.picurlData.count == 3 {
                    self.collectionView.frame.size.height = AutoGetWidth(width: 79)
                }else if model?.picurlData.count == 5 || model?.picurlData.count == 6 {
                    self.collectionView.frame.size.height = AutoGetWidth(width: 163)
                }else  {
                    self.collectionView.frame.size.height = AutoGetWidth(width: 247)
                }
                self.collectionlayOut?.itemSize = CGSize.init(width: AutoGetWidth(width: 79), height: AutoGetWidth(width: 79))
                self.commentBtn.frame.origin.y = self.collectionView.bottom
                self.zanBtn.frame.origin.y = self.collectionView.bottom
                self.headView.frame.origin.y = self.collectionView.bottom + AutoGetHeight(height: 31)
                self.table.frame.origin.y = self.headView.bottom
            }
            
            var nameArr = [String]()
            let lab:UILabel = self.viewWithTag(1009) as! UILabel
            var textStr = ""
            for i in 0..<self.nameData.count {
                let name = self.nameData[i].stringValue
                nameArr.append(name)
                
                if textStr.count > 1{
                    textStr = textStr + "," + name
                }else{
                    textStr =   name
                }
            }
            lab.text = textStr
            
            if nameArr.count > 0 {
                self.headView.isHidden = false
                let labHeight = self.getTextHeigh(textStr: lab.text!, font: kFontSize14, width: kWidth - 2*kLeftDis - AutoGetWidth(width: 32) - AutoGetWidth(width: 12) - AutoGetWidth(width: 52.5))
                self.headView.frame = CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 12), y: self.collectionView.bottom + AutoGetHeight(height: 31), width: kWidth - 2*kLeftDis - AutoGetWidth(width: 32) - AutoGetWidth(width: 12), height: labHeight + 12)
                self.table.frame = CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 12), y: self.headView.bottom , width: kWidth - 2*kLeftDis - AutoGetWidth(width: 32) - AutoGetWidth(width: 12), height: AutoGetHeight(height: 26) * CGFloat((model?.commentData.count)!))
            }else{
                self.headView.frame.size.height = 0
                self.headView.isHidden = true
                if (model?.commentData.count)! > 0 {
                    self.table.isHidden = false
                    self.table.frame = CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 12), y: self.collectionView.bottom+AutoGetHeight(height: 31) , width: kWidth - 2*kLeftDis - AutoGetWidth(width: 32) - AutoGetWidth(width: 12), height: AutoGetHeight(height: 26) * CGFloat((model?.commentData.count)!))
                }else{
                    self.table.isHidden = true
                    self.table.frame.size.height = 0
                }
            }
            
            
//            if model?.laudStatus == "0" {
//                zanBtn.setImage(UIImage.init(named: "CQWorkCircleCancelZan"), for: .normal)
//            }else{
//                zanBtn.setImage(UIImage.init(named: "CQWorkCircleZan"), for: .normal)
//            }
            
            self.table.reloadData()
            self.collectionView.reloadData()
        }
        
    }
    
    func changeTableHeightWithHeight(height:CGFloat) {
        self.table.frame = CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 12), y: self.collectionView.bottom+AutoGetHeight(height: 31) , width: kWidth - 2*kLeftDis - AutoGetWidth(width: 32) - AutoGetWidth(width: 12), height: AutoGetHeight(height: 26) * CGFloat((model?.commentData.count)!)+height)
        
        self.table.reloadData()
    }
 

}

// MARK: - 代理

extension CQWorkMateCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         DLog(self.collectData.count)
        return self.collectData.count
       
    }
    
    
    
}

extension CQWorkMateCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQWorkMateCircleImageCellId", for: indexPath) as! CQWorkMateCircleImageCell
        cell.img.sd_setImage(with: URL(string: self.collectData[indexPath.row].stringValue ), placeholderImage:UIImage.init(named: "demo") )
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}


// Mark:UItableviewdelegate
extension CQWorkMateCell:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQWorkMateCircleCommentCellId") as! CQWorkMateCircleCommentCell
        cell.model = self.commentData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return AutoGetHeight(height: 26)
    }
    
}

extension CQWorkMateCell{
    //计算高度
    func getTextHeigh(textStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        let normalText: String = textStr
        let size = CGSize.init(width: width, height: 1000)
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context:nil).size
        return stringSize.height
    }
    //计算宽度
    func getTexWidth(textStr:String,font:UIFont,height:CGFloat) -> CGFloat {
        
        let normalText: String = textStr
        
        let size = CGSize.init(width: 1000, height: height)
        
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context:nil).size
        
        return stringSize.width
        
    }
}

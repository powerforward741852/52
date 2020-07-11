//
//  CQFriendCircleTable.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/7/16.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol CQFriendCircleCommentDelegate : NSObjectProtocol{
    func commentForCellClick(uId:String,tag:Int)
}

class CQFriendCircleTable: UITableView {

    weak var commentDelegate:CQFriendCircleCommentDelegate?
    var dataArray = [CQWorkMateCircleModel]()
    var laudUserArray = [JSON]()
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.backgroundColor = UIColor.white
        self.delegate = self
        self.dataSource = self
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        self.tableFooterView = view
        
        self.register(CQWorkMateCircleCommentCell.self, forCellReuseIdentifier: "CQWorkMateCircleCommentCellId")
        self.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CQWorkMateHeaderView")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension CQFriendCircleTable:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQWorkMateCircleCommentCellId") as! CQWorkMateCircleCommentCell
        let model = self.dataArray[indexPath.row]
        if model.commentUserTo.isEmpty {
            cell.nameLab.text = model.commentUserFrom + ":"
        }else{
            let string = model.commentUserFrom + "回复" + model.commentUserTo + ":"
            let ranStr = "回复"
            let attrstring:NSMutableAttributedString = NSMutableAttributedString.init(string: string)
            let str = NSString.init(string: string)
            let theRange = str.range(of: ranStr)
            attrstring.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: theRange)
            cell.nameLab.attributedText = attrstring
        }
        
        let width = self.getTexWidth(textStr: cell.nameLab.text!, font: kFontSize14, height: AutoGetHeight(height: 26))
        cell.nameLab.frame = CGRect.init(x:  AutoGetWidth(width: 13), y: AutoGetHeight(height: 0), width: width, height: AutoGetHeight(height: 26))
        cell.contentLab.frame = CGRect.init(x:cell.nameLab.right + AutoGetWidth(width: 6), y: AutoGetHeight(height: 0), width: cell.frame.size.width - AutoGetWidth(width: 26) - width, height: AutoGetHeight(height: 26))
        cell.contentLab.text = model.commentContent
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataArray[indexPath.row]
        
        if commentDelegate != nil{
            self.commentDelegate?.commentForCellClick(uId: model.circleCommentId, tag: tableView.tag)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return AutoGetHeight(height: 26)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.laudUserArray.count == 0{
            return 0.01
        }
        return AutoGetHeight(height: 26)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth - AutoGetWidth(width: 78), height: AutoGetHeight(height: 26)))
        if self.laudUserArray.count == 0 {
            header.frame = CGRect.init(x: 0, y: 0, width: kWidth - AutoGetWidth(width: 78), height: 0.01)
            header.isHidden = true
        }else{
            header.frame = CGRect.init(x: 0, y: 0, width: kWidth - AutoGetWidth(width: 78), height: AutoGetHeight(height: 26))
            header.isHidden = false
        }
        header.backgroundColor = UIColor.colorWithHexString(hex: "#f2f6fc")
        let img = UIImageView.init(frame: CGRect.init(x: AutoGetWidth(width: 13), y: AutoGetHeight(height: 7.5), width: AutoGetWidth(width: 12.5), height: AutoGetHeight(height: 11)))
        img.image = UIImage.init(named: "CQWorkMateCircleHasZan")
        header.addSubview(img)
        
        let lab = UILabel.init(frame: CGRect.init(x: img.right + AutoGetWidth(width: 10), y: 0, width: (kWidth - AutoGetWidth(width: 78) - AutoGetWidth(width: 26) - AutoGetWidth(width: 22.5)), height: AutoGetHeight(height: 26)))
        var labTxt = ""
        for i in 0..<self.laudUserArray.count{
            if 0 == i{
                labTxt = self.laudUserArray[0].stringValue
            }else{
                labTxt = labTxt + "," + self.laudUserArray[i].stringValue
            }
        }
        lab.text = labTxt
        lab.textAlignment = .left
        lab.textColor = UIColor.colorWithHexString(hex: "#1e5f91")
        lab.font = kFontSize14
        header.addSubview(lab)
        return header
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

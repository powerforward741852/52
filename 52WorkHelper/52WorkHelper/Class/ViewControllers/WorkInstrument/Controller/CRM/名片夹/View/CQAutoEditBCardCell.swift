//
//  CQAutoEditBCardCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2019/1/17.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

protocol CQBCardAutoEditDelegate : NSObjectProtocol{
    func autoEditDelegate(index:IndexPath,text:String)
}

class CQAutoEditBCardCell: UITableViewCell {
    weak var editDelegate:CQBCardAutoEditDelegate?
    var isRequire = false
    
    lazy var xingLab: UILabel = {
        let xingLab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 0), width: AutoGetWidth(width: 15), height: AutoGetHeight(height: 55)))
        xingLab.text = ""
        xingLab.textAlignment = .left
        xingLab.textColor = UIColor.red
        xingLab.font = kFontSize15
        return xingLab
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: AutoGetWidth(width: 15), y:  AutoGetHeight(height: 0), width: AutoGetWidth(width: 80), height: AutoGetHeight(height: 55)))
        nameLab.text = ""
        nameLab.textAlignment = .left
        nameLab.textColor = kLyGrayColor
        nameLab.font = kFontSize15
        return nameLab
    }()
    
    lazy var txtFiled: CBTextView = {
        let textView = CBTextView.init()
        textView.backgroundColor = UIColor.white
        textView.frame = CGRect.init(x: AutoGetWidth(width: 130), y: AutoGetHeight(height: 12), width: kWidth - AutoGetWidth(width: 145), height: AutoGetHeight(height: 43))
        textView.aDelegate = self
        textView.textView.backgroundColor = UIColor.white
        textView.textView.font = kFontSize15
        textView.textView.textColor = UIColor.black
        textView.layer.borderColor = kLyGrayColor.cgColor
        textView.placeHolder = "请输入..."
        textView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        return textView
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

    
    func setUp()  {
        self.addSubview(self.nameLab)
        self.addSubview(self.txtFiled)
    }
    
    func refreshNameWithName(name:String,indexPath:IndexPath)  {
        if indexPath.row == 0{
            self.nameLab.text = name
        }
        
    }
    
    func refreshCellWithRequire(indexPath: IndexPath)  {
        if indexPath.section == 0 || indexPath.section == 1{
            if indexPath.row == 0 {
                self.addSubview(self.xingLab)
                xingLab.text = "*"
                self.nameLab.frame = CGRect.init(x: AutoGetWidth(width: 35), y:  AutoGetHeight(height: 0), width: AutoGetWidth(width: 80), height: AutoGetHeight(height: 55))
            }
        }
    }
}

extension CQAutoEditBCardCell:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let cell = superUITableViewCell(of: textView)
        let table = superUITableView(of: textView)
        let index = table?.indexPath(for: cell!)
        DLog(index)
        if (index != nil){
            if self.editDelegate != nil{
                self.editDelegate?.autoEditDelegate(index: index!, text: textView.text)
            }
        }
    }
    
    //返回button所在的UITableViewCell
    func superUITableViewCell(of: UITextView) -> UITableViewCell? {
        for view in sequence(first: of.superview, next: { $0?.superview }) {
            if let cell = view as? UITableViewCell {
                return cell
            }
        }
        return nil
    }
    
    //返回button所在的UITableView
    func superUITableView(of: UITextView) -> UITableView? {
        for view in sequence(first: of.superview, next: { $0?.superview }) {
            if let table = view as? UITableView {
                return table
            }
        }
        return nil
    }
}

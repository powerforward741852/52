//
//  CQEditBusinessCardCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2019/1/15.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit


protocol CQEdictBusinessCardDelegate : NSObjectProtocol{
    func deleteCellClick(index:IndexPath)
}

protocol CQBCardEditDelegate : NSObjectProtocol{
    func editDelegate(index:IndexPath,text:String)
}


class CQEditBusinessCardCell: UITableViewCell {

    var isRequire = false
    weak var showDelegate:CQEdictBusinessCardDelegate?
    weak var editDelegate:CQBCardEditDelegate?
    
    lazy var xingLab: UILabel = {
        let xingLab = UILabel.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 0), width: AutoGetWidth(width: 45), height: AutoGetHeight(height: 55)))
        xingLab.text = ""
        xingLab.textAlignment = .center
        xingLab.textColor = UIColor.red
        xingLab.font = kFontSize15
        return xingLab
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: AutoGetWidth(width: 45), y:  AutoGetHeight(height: 0), width: AutoGetWidth(width: 80), height: AutoGetHeight(height: 55)))
        nameLab.text = ""
        nameLab.textAlignment = .left
        nameLab.textColor = kLyGrayColor
        nameLab.font = kFontSize15
        return nameLab
    }()
    
    lazy var txtFiled: CBTextView = {
        let textView = CBTextView.init()
        textView.backgroundColor = UIColor.white
        textView.frame = CGRect.init(x: AutoGetWidth(width: 140), y: AutoGetHeight(height: 12), width: kWidth - AutoGetWidth(width: 190), height: AutoGetHeight(height: 43))
        textView.aDelegate = self
        textView.textView.backgroundColor = UIColor.white
        textView.textView.font = kFontSize15
        textView.textView.textColor = UIColor.black
        textView.layer.borderColor = kLyGrayColor.cgColor
        textView.placeHolder = "请输入"
        textView.placeHolderColor = UIColor.colorWithHexString(hex: "#bdbdbd")
        return textView
    }()
    
    lazy var deleteBtn: UIButton = {
        let deleteBtn = UIButton.init(type: .custom)
        deleteBtn.frame = CGRect.init(x: kWidth - AutoGetWidth(width: 45), y: AutoGetHeight(height: 0), width: AutoGetWidth(width: 45), height: AutoGetHeight(height: 55))
//        deleteBtn.setTitle("X", for: .normal)
//        deleteBtn.setTitleColor(kLightBlueColor, for: .normal)
        deleteBtn.setImage(UIImage.init(named: "BCardDelete"), for: .normal)
        deleteBtn.addTarget(self, action: #selector(deleteClick(sender:)), for: .touchUpInside)
        return deleteBtn
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
        
        self.addSubview(self.xingLab)
        self.addSubview(self.nameLab)
        self.addSubview(self.txtFiled)
        self.addSubview(self.deleteBtn)
        self.deleteBtn.isHidden = false
    }

    @objc func deleteClick(sender:UIButton) {
        let btn = sender
        let cell = superUITableViewCell(of: btn)
        let table = superUITableView(of: btn)
        let index = table?.indexPath(for: cell!)
        DLog(index)
        
        if self.showDelegate != nil{
            self.showDelegate?.deleteCellClick(index: index!)
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
    
    
}

extension CQEditBusinessCardCell:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        print(text)
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let cell = superUITableViewCell(of: textView)
        let table = superUITableView(of: textView)
        let index = table?.indexPath(for: cell!)
        DLog(index)
        if self.editDelegate != nil{
            self.editDelegate?.editDelegate(index: index!, text: textView.text)
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


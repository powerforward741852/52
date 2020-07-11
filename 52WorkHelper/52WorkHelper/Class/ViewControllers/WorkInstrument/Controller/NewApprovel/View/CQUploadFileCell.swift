//
//  CQUploadFileCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/11/6.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit

protocol CQUploadFileDeleteDelegate : NSObjectProtocol{
    func deleteFile(index:IndexPath)
}

class CQUploadFileCell: UITableViewCell {

   weak var deleteDelegate:CQUploadFileDeleteDelegate?
    
    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetWidth(width: 7.5), width: AutoGetWidth(width: 40), height: AutoGetWidth(width: 40)))
        iconImg.image = UIImage.init(named: "CQUploadFileCell")
        return iconImg
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + AutoGetWidth(width: 12), y: AutoGetWidth(width: 19.5), width: kWidth/3 * CGFloat(2), height: AutoGetHeight(height: 16)))
        nameLab.font = kFontSize16
        nameLab.textAlignment = .left
        nameLab.textColor = UIColor.black
        nameLab.text = "我的日报"
        return nameLab
    }()
    
    lazy var deleteBtn: UIButton = {
        let deleteBtn = UIButton.init(type: .custom)
        deleteBtn.frame = CGRect.init(x: kWidth - AutoGetWidth(width: 30), y: 0, width: AutoGetWidth(width: 15), height: AutoGetHeight(height: 55))
        deleteBtn.setImage(UIImage.init(named: "CQDeleteBtn"), for: .normal)
        deleteBtn.addTarget(self, action: #selector(deleteClick), for: .touchUpInside)
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

    @objc func deleteClick(sender:UIButton)  {
        let btn = sender
        let cell = superUITableViewCell(of: btn)
        let table = superUITableView(of: btn)
        let index = table?.indexPath(for: cell!)
        DLog(index)
        
        if self.deleteDelegate != nil{
            self.deleteDelegate?.deleteFile(index: index!)
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
        self.addSubview(self.deleteBtn)
    }
}

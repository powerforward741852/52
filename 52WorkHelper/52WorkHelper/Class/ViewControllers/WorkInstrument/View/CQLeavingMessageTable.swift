//
//  CQLeavingMessageTable.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/10.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol CQLeavingMessageDelegate:NSObjectProtocol {
    func pushToDetailVC()
}

class CQLeavingMessageTable: UITableView {

    var dataArr = [CQCommentModel]()
    var typeStr:String?
    var hasLoad:Bool = false
    weak var leavingMessageDelegate:CQLeavingMessageDelegate?
    var commentUserNum = ""
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.backgroundColor = UIColor.white
        self.delegate = self
        self.dataSource = self
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        self.tableFooterView = view
        self.register(CQScheduleDetailCell.self, forCellReuseIdentifier: "CQLYScheduleDetailCellId")
        self.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CQScheduleDetailFooter")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CQLeavingMessageTable:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQLYScheduleDetailCellId") as! CQScheduleDetailCell
        let model = self.dataArr[indexPath.row]
        cell.iconImg.sd_setImage(with: URL(string: model.headImage ), placeholderImage:UIImage.init(named: "personDefaultIcon") )
        cell.nameLab.text = model.realName
        cell.contentLab.text =  model.commentContent
        cell.timeLab.text = model.commentTime
        if model.path == ""{
            cell.soundView.isHidden = true
        }else{
            cell.soundView.isHidden = false
            cell.soundView.frame =  CGRect(x: cell.nameLab.left, y: cell.nameLab.bottom+5, width: 100, height: 35)
            let mod = QRSoundModel()
            mod.soundFilePath = model.path
            cell.soundModel = mod
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if leavingMessageDelegate != nil {
            self.leavingMessageDelegate?.pushToDetailVC()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoGetHeight(height: 70)
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AutoGetHeight(height: 51)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        
        header.backgroundColor = kProjectBgColor
        let bgV = UIView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 13), width: kWidth, height: AutoGetHeight(height: 38)))
        bgV.backgroundColor = UIColor.white
        header.addSubview(bgV)
        let lab = UILabel.init(frame: CGRect.init(x: kLeftDis, y: 0, width: kWidth, height: AutoGetHeight(height: 38)))
        lab.text = "留言 " + self.commentUserNum
        lab.textAlignment = .left
        lab.textColor = UIColor.black
        lab.font = kFontSize15
        bgV.addSubview(lab)
        return header
    }
    
    
}

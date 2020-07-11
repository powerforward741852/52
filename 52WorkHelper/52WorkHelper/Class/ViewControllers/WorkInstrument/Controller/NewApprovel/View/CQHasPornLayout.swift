//
//  CQHasPornLayout.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/11/6.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit

protocol CQHasPornDelegate : NSObjectProtocol{
    func goToWebDetail(model:NCQApprovelDetailModel)
}

class CQHasPornLayout: TGLinearLayout {

    var curName = ""
    var type = ""
    var curTitle = ""
    var prompt = ""
    var required = false
    var dataArray = [NCQApprovelDetailModel]()
    var tableHeight:CGFloat = AutoGetHeight(height: 55)
    weak var goDelegate:CQHasPornDelegate?
    
    convenience init(orientation: TGOrientation,name:String,type:String,title:String,prompt:String,require:Bool,dataArray:[NCQApprovelDetailModel]) {
        self.init(frame: CGRect.zero, orientation: orientation, name: name, type: type, title: title, prompt: prompt, require: require,dataArray:dataArray)
        
    }
    
    init(frame: CGRect, orientation: TGOrientation,name:String,type:String,title:String,prompt:String,require:Bool,dataArray:[NCQApprovelDetailModel]) {
        super.init(frame: frame, orientation: orientation)
        
        self.tg_height.equal(.wrap)
        self.tg_width.equal(kWidth)
        self.curName = name
        self.type = type
        self.curTitle = title
        self.prompt = prompt
        self.required = require
        self.dataArray = dataArray
        self.tableHeight = AutoGetHeight(height: 55) * CGFloat(self.dataArray.count + 1)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()  {
        self.addSubview(self.addTableView(height: AutoGetHeight(height: 55) * CGFloat(self.dataArray.count + 1)))
    }
    
}

// Mark 整个界面可能用到的控件
extension CQHasPornLayout{
    
    @objc internal func addTableView(height:CGFloat) -> UITableView{
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: height), style: UITableViewStyle.plain)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        
        table.tg_width.equal(kWidth)
        table.tg_height.equal(height)
        table.tag = 802
        table.register(CQUploadFileCell.self, forCellReuseIdentifier: "CQUploadFileCellId")
        table.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CQAttachUploadHeadFooterView")
        return table
    }
    
    func reloadDataWithArray() -> CGFloat {
        let table = self.viewWithTag(802) as! UITableView
        table.tg_height.equal(AutoGetHeight(height: 170) + CGFloat(self.dataArray.count) * AutoGetHeight(height: 55))
        self.tableHeight =  CGFloat(self.dataArray.count) * AutoGetHeight(height: 55)
        table.reloadData()
        return self.tableHeight
    }
    
}

extension CQHasPornLayout:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQUploadFileCellId") as! CQUploadFileCell
        cell.deleteBtn.isHidden = true
        cell.nameLab.text = self.dataArray[indexPath.row].name
        cell.iconImg.sd_setImage(with: URL(string: imagePreUrl + self.dataArray[indexPath.row].flieUrl), placeholderImage:UIImage.init(named: "videoDefault") )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let mod = dataArray[indexPath.row]
        if self.goDelegate != nil{
            self.goDelegate?.goToWebDetail(model: mod)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return AutoGetHeight(height: 55)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AutoGetHeight(height: 55)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return AutoGetWidth(width: 0.01)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.white
        let lab = UILabel.init(frame: CGRect.init(x: AutoGetWidth(width: 15), y: 0, width: kWidth - AutoGetWidth(width: 35), height: AutoGetHeight(height: 55)))
        lab.text = self.curTitle
        lab.font = kFontSize15
        lab.textAlignment = .left
        lab.textColor = kLyGrayColor
        header.addSubview(lab)
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = UIColor.white
        return footer
    }
}

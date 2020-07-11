//
//  CQAttachUpLoadLayout.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/11/5.
//  Copyright © 2018 chenqihang. All rights reserved.
//

import UIKit

protocol CQAttachUploadDelegate : NSObjectProtocol{
    func attachUploadAction()
}

class CQAttachUpLoadLayout: TGLinearLayout {

    var curName = ""
    var type = ""
    var curTitle = ""
    var prompt = ""
    var required = false
    var dataArray = [NCQApprovelDetailModel]()
    weak var uploadDelegate:CQAttachUploadDelegate?
    var tableHeight:CGFloat = AutoGetHeight(height: 170)
    var isFix = false
    
    convenience init(orientation: TGOrientation,name:String,type:String,title:String,prompt:String,require:Bool,dataArray: [NCQApprovelDetailModel],isFix:Bool) {
        self.init(frame: CGRect.zero, orientation: orientation, name: name, type: type, title: title, prompt: prompt, require: require,dataArray:dataArray,isFix:isFix)
        
    }
    
    init(frame: CGRect, orientation: TGOrientation,name:String,type:String,title:String,prompt:String,require:Bool,dataArray: [NCQApprovelDetailModel],isFix:Bool) {
        super.init(frame: frame, orientation: orientation)
        
        self.tg_height.equal(.wrap)
        self.tg_width.equal(kWidth)
        self.curName = name
        self.type = type
        self.curTitle = title
        self.prompt = prompt
        self.required = require
        self.dataArray = dataArray
        self.isFix = isFix
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()  {
        if self.dataArray.count > 0{
            self.addSubview(self.addTableView(height:AutoGetHeight(height: 55) * CGFloat(self.dataArray.count) + AutoGetHeight(height: 170) ))
        }else{
            self.addSubview(self.addTableView(height: AutoGetHeight(height: 170)))
        }
        
    }
    
    @objc func upLoadClick() {
        if self.uploadDelegate != nil{
            self.uploadDelegate?.attachUploadAction()
        }
    }
    
}

// Mark 整个界面可能用到的控件
extension CQAttachUpLoadLayout{
    
    @objc internal func addTableView(height:CGFloat) -> UITableView{
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: height), style: UITableViewStyle.plain)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        
        table.tg_width.equal(kWidth)
        table.tg_height.equal(AutoGetHeight(height: 170))
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

extension CQAttachUpLoadLayout:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQUploadFileCellId") as! CQUploadFileCell
        cell.deleteDelegate = self
        if self.dataArray[indexPath.row].fileName.isEmpty{
            cell.nameLab.text = self.dataArray[indexPath.row].name
            cell.iconImg.sd_setImage(with: URL(string:imagePreUrl + self.dataArray[indexPath.row].flieUrl), placeholderImage:UIImage.init(named: "videoDefault") )
        }else{
            cell.nameLab.text = self.dataArray[indexPath.row].fileName
            cell.iconImg.sd_setImage(with: URL(string:imagePreUrl + self.dataArray[indexPath.row].fileUrl), placeholderImage:UIImage.init(named: "videoDefault") )
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return AutoGetHeight(height: 55)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AutoGetHeight(height: 55)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return AutoGetWidth(width: 115)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.white
        let lab = UILabel.init(frame: CGRect.init(x: AutoGetWidth(width: 35), y: 0, width: kWidth - AutoGetWidth(width: 35), height: AutoGetHeight(height: 55)))
        lab.text = self.curTitle
        lab.font = kFontSize15
        lab.textAlignment = .left
        lab.textColor = UIColor.black
        header.addSubview(lab)
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = UIColor.white
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: AutoGetWidth(width: 35), y: AutoGetHeight(height: 5), width: AutoGetWidth(width: 100), height: AutoGetWidth(width: 100))
        btn.addTarget(self, action: #selector(upLoadClick), for: .touchUpInside)
        btn.setBackgroundImage(UIImage.init(named: "WorkOutAddImgBtn"), for: .normal)
        footer.addSubview(btn)
        return footer
    }
}

extension CQAttachUpLoadLayout:CQUploadFileDeleteDelegate{
    func deleteFile(index: IndexPath) {
        self.dataArray.remove(at: index.row)
        NotificationCenter.default.post(name: NSNotification.Name.init("fileDelete"), object: self.dataArray)
    }
}

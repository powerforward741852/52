//
//  CQBussinessBottomSelectV.swift
//  52WorkHelper
//
//  Created by chenqihang on 2019/1/14.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

protocol BCardBottomSelectDelegate : NSObjectProtocol{
    func showChooseClick(index:IndexPath)
}

protocol BCardBottomTelSelectDelegate : NSObjectProtocol{
    func showTelChooseClick(index:IndexPath)
}

protocol BCardBottomCancelDelegate : NSObjectProtocol{
    func cancelAction()
}

class CQBussinessBottomSelectV: UIView {

   weak var showDelegate:BCardBottomSelectDelegate?
   weak var telDelegate:BCardBottomTelSelectDelegate?
   weak var cancelDelegate:BCardBottomCancelDelegate?
    var dataArray = [String]()
    
    var isTel = false
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight ), style: UITableViewStyle.plain)
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = kProjectBgColor
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    
    init(frame:CGRect,dataArray:[String]) {
        super.init(frame: frame)
        self.backgroundColor = kProjectBgColor
        self.dataArray = dataArray
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp()  {
        self.addSubview(self.table)
        self.table.register(UINib.init(nibName: "CQBCardSelectCell", bundle: Bundle.init(identifier: "CQBCardSelectCellId")), forCellReuseIdentifier: "CQBCardSelectCellId")
    }
    
    @objc func cancelClick()  {
        if self.cancelDelegate != nil{
            self.cancelDelegate?.cancelAction()
        }
    }
}

extension CQBussinessBottomSelectV:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "CQBCardSelectCellId", for: indexPath) as! CQBCardSelectCell
        cell.nameLab.text = self.dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.isTel{
            if self.telDelegate != nil{
                self.telDelegate?.showTelChooseClick(index: indexPath)
            }
        }else{
            if self.showDelegate != nil{
                self.showDelegate?.showChooseClick(index: indexPath)
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let foot = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: 60))
        foot.backgroundColor = kProjectBgColor
        
        let lab = UIButton.init(frame: CGRect.init(x: 0, y: 10, width: kWidth, height: 50))
        lab.setTitle("取消", for: .normal)
        lab.backgroundColor = UIColor.white
        lab.setTitleColor(UIColor.red, for: .normal)
        lab.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        lab.titleLabel?.font = kFontSize15
        foot.addSubview(lab)
        return foot
    }
}


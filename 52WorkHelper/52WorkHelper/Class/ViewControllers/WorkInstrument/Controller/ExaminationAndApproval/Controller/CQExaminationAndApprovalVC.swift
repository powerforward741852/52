//
//  CQExaminationAndApprovalVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/28.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQExaminationAndApprovalVC: SuperVC {

    var titleArray = [String]()
    var imgArray = [String]()
    var dataArray = [CQExaModel]()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight-AutoGetHeight(height: 65)), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        table.backgroundColor = UIColor.colorWithHexString(hex: "#f7f7f7")
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight))
        headView.backgroundColor = kProjectBgColor
        return headView
    }()
    
    lazy var mustDoView: UIView = {
        let mustDoView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: AutoGetHeight(height: 113)))
        mustDoView.backgroundColor = UIColor.white
        return mustDoView
    }()
   
    lazy var processView: UIImageView = {
        let value = (self.dataArray.count/4)%4
        var num = 0
        if value == 0 {
            num = 0
        }else{
            num = 1
        }
        let processView = UIImageView.init(frame: CGRect.init(x: AutoGetWidth(width: 13), y: mustDoView.bottom + AutoGetHeight(height: 13), width: kWidth - AutoGetWidth(width: 26), height: CGFloat(self.titleArray.count/4 + num) * AutoGetHeight(height: 84) + AutoGetHeight(height: 54)))
        processView.image = UIImage.init(named: "ExaCollectionBg")
        processView.isUserInteractionEnabled = true
        return processView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width: kHaveLeftWidth/4, height: AutoGetHeight(height: 84))
        layOut.minimumLineSpacing = 0
        layOut.minimumInteritemSpacing = 0
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        layOut.headerReferenceSize = CGSize.init(width: kHaveLeftWidth, height: AutoGetHeight(height: 38))
        
        let value = (self.dataArray.count/4)%4
        var num = 0
        if value == 0 {
            num = 0
        }else{
            num = 1
        }
        let collectionView = UICollectionView.init(frame: CGRect.init(x: AutoGetWidth(width: 2), y: 4, width: kHaveLeftWidth, height: CGFloat(self.titleArray.count/4 + num ) * AutoGetHeight(height: 84) + AutoGetHeight(height: 38)), collectionViewLayout: layOut)
        collectionView.layer.cornerRadius = 3.5
        collectionView.clipsToBounds = true
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(CQExaminationAndApprovalCell.self, forCellWithReuseIdentifier: "CQExaminationAndApprovalCellId")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CQExaminationAndApprovalHeader")
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.titleArray = ["请假","出差","补卡申请","报销","加班","转正","离职","通用"]
//        self.imgArray = ["ExaCollection0","ExaCollection1","ExaCollection2","ExaCollection3","ExaCollection4","ExaCollection5","ExaCollection6","ExaCollection7"]
        self.title = "审批"
        self.loadDeskData()
        
        self.view.backgroundColor = kProjectBgColor
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.mustDoView)
        initMustDoView()
        
        
    }
    
    func initMustDoView()  {
        let tArr = ["我提交的","需要我审批的","抄送给我的"]
        let iArr = ["ExaMustDo0","ExaMustDo1","ExaMustDo2"]
        for i in 0..<tArr.count{
            let btn = UIButton.init(type: .custom)
            btn.frame = CGRect.init(x: kWidth/3 * CGFloat(i), y: 0, width: kWidth/3, height: AutoGetHeight(height: 113))
            btn.tag = 1500 + i
            btn.addTarget(self, action: #selector(mustDoClick(btn:)), for: .touchUpInside)
            self.mustDoView.addSubview(btn)
            
            let imgView = UIImageView.init(frame: CGRect.init(x: (kWidth/3 - AutoGetWidth(width: 53))/2, y: AutoGetHeight(height: 18), width: AutoGetWidth(width: 53), height: AutoGetWidth(width: 53)))
            imgView.image = UIImage.init(named: iArr[i])
            btn.addSubview(imgView)
            
            let lab = UILabel.init(frame: CGRect.init(x: 0, y: imgView.bottom + AutoGetHeight(height: 13), width: kWidth/3, height: AutoGetHeight(height: 11)))
            lab.text = tArr[i]
            lab.font = kFontSize11
            lab.textColor = UIColor.colorWithHexString(hex: "#6a6a6a")
            lab.textAlignment = .center
            btn.addSubview(lab)
        }
    }
    
    @objc func mustDoClick(btn:UIButton)  {
        if 1500 == btn.tag {
            let vc = CQMeSubmitVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if 1501 == btn.tag {
            let vc = CQNeedMeAgreeVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if 1502 == btn.tag {
            let vc = CQCopyToMeVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    

}

extension CQExaminationAndApprovalVC {
    func loadDeskData()  {
        let userID = STUserTool.account().userID
        STNetworkTools.requestData(URLString: "\(baseUrl)/approval/getApprovalList",
            type: .get,
            param: ["emyeId":userID],
            successCallBack: { (result) in

                var tempArray = [CQExaModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = CQExaModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
                
 
                self.dataArray = tempArray
                
                
                for model in self.dataArray {
                    self.titleArray.append(model.businessName)
                    self.imgArray.append(model.businessIcon)
                }
                self.headView.addSubview(self.processView)
                self.processView.addSubview(self.collectionView)
                
        }) { (error) in
            
        }
    }
}

// MARK: - 代理

extension CQExaminationAndApprovalVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    
}

extension CQExaminationAndApprovalVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQExaminationAndApprovalCellId", for: indexPath) as! CQExaminationAndApprovalCell
        cell.img.sd_setImage(with: URL(string: self.imgArray[indexPath.item]), placeholderImage:UIImage.init(named: "ExaCollection0") )
        cell.nameLab.text = self.titleArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        if indexPath.item == 0{
            let model = self.dataArray[indexPath.row]
            let vc = NCQApprovelVC()
            vc.businessCode = model.businessCode
            vc.titleStr = model.businessName
            vc.approvalBusinessId = model.entityId
            self.navigationController?.pushViewController(vc, animated: true)
//        }else{
//            let model = self.dataArray[indexPath.row]
//            let vc = CQSupplyVC()
//            vc.businessCode = model.businessCode
//            vc.titleStr = model.businessName
//            vc.approvalBusinessId = model.entityId
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
    }

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var header:UICollectionReusableView!
        header = collectionView.dequeueReusableSupplementaryView(ofKind:UICollectionElementKindSectionHeader, withReuseIdentifier: "CQExaminationAndApprovalHeader", for: indexPath)
            
        
        let lab = UILabel.init(frame: CGRect.init(x:kLeftDis, y: 0, width: kHaveLeftWidth - 2 * kLeftDis, height: 38))
        lab.text = "流程列表"
        lab.font = kFontSize15
        lab.textColor = UIColor.black
        lab.textAlignment = .left
        header.addSubview(lab)
        return header
    }
}

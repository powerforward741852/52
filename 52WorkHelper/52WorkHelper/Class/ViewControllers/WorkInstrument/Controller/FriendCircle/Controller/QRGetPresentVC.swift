//
//  QRGetPresentVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/15.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRGetPresentVC: SuperVC {
    var dataArray = [QRPresentModel]()
    var pageNum = 1
    lazy var collectionView: UICollectionView = {
        let layOut = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSize.init(width: (kWidth-AutoGetWidth(width: 52+20))/2, height: AutoGetHeight(height: 175))
        layOut.minimumLineSpacing = 24
        layOut.minimumInteritemSpacing = AutoGetWidth(width: 10)
        layOut.scrollDirection = UICollectionViewScrollDirection.vertical
        layOut.sectionInset = UIEdgeInsets(top: AutoGetHeight(height: 20), left: AutoGetWidth(width: 26), bottom: AutoGetHeight(height: 20), right: AutoGetWidth(width: 26))
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), collectionViewLayout: layOut)
        
        collectionView.backgroundColor = UIColor.colorWithHexString(hex: "#f6f3f4")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(QRPressentCell.self, forCellWithReuseIdentifier: "getPresentId")
        return collectionView
    }()
    
    lazy var withOutResultView: UIView = {
        let withOutResultView = UIView.init(frame: CGRect.init(x: 0, y: CGFloat(SafeAreaTopHeight), width: kWidth, height: AutoGetHeight(height: kHeight - CGFloat(SafeAreaTopHeight))))
        withOutResultView.backgroundColor = UIColor.colorWithHexString(hex: "#f6f3f4")
        let imageV = UIImageView.init(frame: CGRect.init(x: (kWidth - imageWidth)/2.0, y: AutoGetHeight(height: 110), width: imageWidth, height: imageWidth))
        imageV.image = UIImage.init(named: "lw")
        let lab = UILabel.init(frame: CGRect.init(x: 0, y: imageV.bottom + AutoGetHeight(height: 25), width: kWidth, height: AutoGetHeight(height: 20)))
        lab.textAlignment = .center
        lab.textColor = UIColor.black
        lab.text = "您还没有可领取的礼物"
        lab.font = UIFont.boldSystemFont(ofSize: 23)
        withOutResultView.addSubview(imageV)
        withOutResultView.addSubview(lab)
        return withOutResultView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "领取礼物"
        view.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        setUpRefresh()
        view.addSubview(withOutResultView)
        withOutResultView.isHidden = true
    }
    deinit {
    }
    func setUpRefresh()  {
        // MARK:header
        let STHeader = CQRefreshHeader {[unowned self] in
            self.loadDatas(moreData: false)
        }
        // MARK:footer
        let STFooter = CQRefreshFooter {[unowned self] in
            self.loadDatas(moreData: true)
        }
        self.collectionView.mj_header = STHeader
        self.collectionView.mj_footer = STFooter
        self.collectionView.mj_header.beginRefreshing()
    }

    func loadDatas(moreData:Bool) {
        
        if moreData {
            pageNum += 1
        } else {
            pageNum = 1
        }
        
        STNetworkTools.requestData(URLString:"\(baseUrl)/birth/getAllGift" ,
            type: .get,
            param: ["currentPage":pageNum,
                    "rows":"10","userId":STUserTool.account().userID],
            successCallBack: { (result) in
                var tempArray = [QRPresentModel]()
                for modalJson in result["data"].arrayValue {
                    guard let modal = QRPresentModel(jsonData: modalJson) else {
                        return
                    }
                    tempArray.append(modal)
                }
              

                if self.pageNum > 1 {
                    self.dataArray.append(contentsOf: tempArray)
                } else {
                    self.dataArray = tempArray
                }
                //刷新表格
                self.collectionView.mj_header.endRefreshing()
                self.collectionView.mj_footer.endRefreshing()
                self.collectionView.reloadData()
                //分页控制
                let total = result["total"].intValue
                if self.dataArray.count == total {
                    self.collectionView.mj_footer.endRefreshingWithNoMoreData()
                }else {
                    self.collectionView.mj_footer.resetNoMoreData()
                }
                if self.dataArray.count == 0{
                   self.withOutResultView.isHidden = false
                }else{
                    self.withOutResultView.isHidden = true
                }
                
        }) { (error) in
            self.collectionView.reloadData()
            self.collectionView.mj_header.endRefreshing()
            self.collectionView.mj_footer.endRefreshing()
        }
    }
    

   

}
extension QRGetPresentVC:UICollectionViewDataSource,UICollectionViewDelegate{
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "getPresentId", for: indexPath)as! QRPressentCell
       // cell.backgroundColor = UIColor.yellow
        cell.rootvc = self
        cell.model = dataArray[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}


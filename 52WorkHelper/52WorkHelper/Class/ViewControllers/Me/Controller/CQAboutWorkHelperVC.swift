//
//  CQAboutWorkHelperVC.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/6/19.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQAboutWorkHelperVC: SuperVC {

    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight), style: UITableViewStyle.plain)
        table.separatorStyle = .none
        //        table.backgroundColor = kProjectBgColor
     
        // 去除多余的分割线
        let view = UIView(frame: CGRect.zero)
        table.tableFooterView = view
        return table
    }()
    
    lazy var headView: UIView = {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight))
        headView.backgroundColor = UIColor.white
        return headView
    }()
    
    lazy var bgImage: UIImageView = {
        let bgImage = UIImageView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 18), width: kWidth - 2*kLeftDis, height: AutoGetHeight(height: 410)))
        bgImage.image = UIImage.init(named: "checkOutBg")
        return bgImage
    }()
    
    lazy var about52Img: UIImageView = {
        let about52Img = UIImageView.init(frame: CGRect.init(x: (kWidth - 2 * kLeftDis - AutoGetWidth(width: 83))/2, y: AutoGetHeight(height: 60), width: AutoGetWidth(width: 83), height: AutoGetWidth(width: 83)))
        //about52Img.image = UIImage.init(named: "newQrcode")  // UIImage.init(named: "downloadIcon")
        about52Img.sd_setImage(with: URL(string: imagePreUrl+"/static/images/download/QRcode.png" ), placeholderImage:UIImage.init(named: "newQrcode") )
        
        about52Img.layer.cornerRadius = 2
        about52Img.clipsToBounds = true
        return about52Img
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: 0, y: self.about52Img.bottom + AutoGetHeight(height: 23), width: kWidth - 2 * kLeftDis, height: AutoGetHeight(height: 22)))
        nameLab.textAlignment = .center
        nameLab.textColor = UIColor.black
        nameLab.font = UIFont.systemFont(ofSize: 22)
        nameLab.text = "52工作助手"
        return nameLab
    }()
    
    lazy var detailLab: UILabel = {
        let detailLab = UILabel.init(frame: CGRect.init(x: 0, y: self.nameLab.bottom + AutoGetHeight(height: 12), width: kWidth - 2 * kLeftDis, height: AutoGetHeight(height: 17)))
        detailLab.textAlignment = .center
        detailLab.textColor = UIColor.colorWithHexString(hex: "#cacaca")
        detailLab.font = kFontSize17
        detailLab.text = "移动办公+智能CRM领导者"
        return detailLab
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView.init(frame: CGRect.init(x: kLeftDis , y: self.detailLab.bottom + AutoGetHeight(height: 67), width: kWidth - 4 * kLeftDis, height: 0.5))
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        
        shapeLayer.bounds = lineView.bounds
        
        shapeLayer.position = CGPoint(x: lineView.frame.width / 2, y: lineView.frame.height / 2)
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = kLineColor.cgColor
        
        shapeLayer.lineWidth = 0.5
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPhase = 0
        shapeLayer.lineDashPattern = [NSNumber(value: 2), NSNumber(value: 4)]
        
        let path:CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 10))
        path.addLine(to: CGPoint(x: lineView.frame.width, y: 10))
        shapeLayer.path = path
        
        lineView.layer.addSublayer(shapeLayer)
        return lineView
    }()
    
    
    lazy var helpLab: UILabel = {
        let helpLab = UILabel.init(frame: CGRect.init(x: 0, y: self.lineView.bottom + AutoGetHeight(height: 40), width: kWidth - 2 * kLeftDis, height: AutoGetHeight(height: 15)))
        helpLab.textAlignment = .center
        helpLab.textColor = UIColor.colorWithHexString(hex: "#8b8b8b")
        helpLab.font = kFontSize15
        helpLab.text = "有任何疑问，请拨打服务电话"
        return helpLab
    }()
    
    lazy var phoneLab: UILabel = {
        let phoneLab = UILabel.init(frame: CGRect.init(x: 0, y: self.helpLab.bottom + AutoGetHeight(height: 20), width: kWidth - 2 * kLeftDis, height: AutoGetHeight(height: 21)))
        phoneLab.textAlignment = .center
        phoneLab.textColor = UIColor.colorWithHexString(hex: "#fea710")
        phoneLab.font = kFontSize21
        phoneLab.text = "400 800 8589"
        return phoneLab
    }()
    
    
    lazy var versionLab: UILabel = {
        let versionLab = UILabel.init(frame: CGRect.init(x: 0, y: self.bgImage.bottom + AutoGetHeight(height: 75), width: kWidth, height: AutoGetHeight(height: 15)))
        versionLab.textAlignment = .center
        versionLab.textColor = UIColor.black
        versionLab.font = kFontSize15
        return versionLab
    }()
    
    lazy var serveBtn: UIButton = {
        let serveBtn = UIButton.init(type: .custom)
        serveBtn.frame = CGRect.init(x: 0, y: self.versionLab.bottom + AutoGetHeight(height: 15), width: kWidth/2 - AutoGetWidth(width: 15), height: AutoGetHeight(height: 12))
        serveBtn.setTitle("服务条款", for: .normal)
        serveBtn.contentHorizontalAlignment = .right
        serveBtn.titleLabel?.font = kFontSize11
        serveBtn.setTitleColor(UIColor.colorWithHexString(hex: "#366a89"), for: .normal)
        
        let line = UIView.init(frame: CGRect.init(x: kWidth/2 - 0.5 , y:self.versionLab.bottom + AutoGetHeight(height: 15) , width: 1, height: AutoGetHeight(height: 12)))
        line.backgroundColor = kLineColor
        self.headView.addSubview(line)
        return serveBtn
    }()
    
    lazy var secrectBtn: UIButton = {
        let secrectBtn = UIButton.init(type: .custom)
        secrectBtn.frame = CGRect.init(x: kWidth/2 + 0.5 + AutoGetWidth(width: 15), y: self.versionLab.bottom + AutoGetHeight(height: 15), width: kWidth/2 - 0.5 - AutoGetWidth(width: 15), height: AutoGetHeight(height: 12))
        secrectBtn.setTitle("保密协议", for: .normal)
        secrectBtn.contentHorizontalAlignment = .left
        secrectBtn.titleLabel?.font = kFontSize11
        secrectBtn.setTitleColor(UIColor.colorWithHexString(hex: "#366a89"), for: .normal)
        return secrectBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "关于52工作助手"
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headView
        self.headView.addSubview(self.bgImage)
        self.bgImage.addSubview(self.about52Img)
        self.bgImage.addSubview(self.nameLab)
        self.bgImage.addSubview(self.detailLab)
        self.bgImage.addSubview(self.lineView)
        self.bgImage.addSubview(self.helpLab)
        self.bgImage.addSubview(self.phoneLab)
        self.headView.addSubview(self.versionLab)
        self.versionLab.text = "52工作助手" + "V" + CQVersion
        self.headView.addSubview(self.serveBtn)
        self.headView.addSubview(self.secrectBtn)
    }

}

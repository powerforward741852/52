//
//  CQChooseCarCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/9/7.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class CQChooseCarCell: UITableViewCell {

    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var carName: UILabel!
    @IBOutlet weak var carNum: UILabel!
    @IBOutlet weak var cardLoad: UILabel!
    @IBOutlet weak var carStatus: UILabel!
    @IBOutlet weak var driverIcon: UIImageView!
    @IBOutlet weak var driver: UILabel!
    
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    var xline : UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.bgImage.layer.borderColor = kLineColor.cgColor
//        self.bgImage.layer.borderWidth = 0.5
//        self.bgImage.layer.cornerRadius = 3
        self.driverIcon.layer.cornerRadius = 24
        self.line1.backgroundColor = kLineColor
        self.line2.backgroundColor = kLineColor
        let line = UIView.init(frame: CGRect.init(x: kLeftDis * 2, y: self.carStatus.bottom + 8, width: self.tz_width - 4 * kLeftDis, height: 0.5))
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        
        shapeLayer.bounds = line.bounds
        
        shapeLayer.position = CGPoint(x: line.frame.width / 2, y: line.frame.height / 2)
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = kLineColor.cgColor
        
        shapeLayer.lineWidth = 0.5
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPhase = 0
        shapeLayer.lineDashPattern = [NSNumber(value: 2), NSNumber(value: 4)]
        
        let path:CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 10))
        path.addLine(to: CGPoint(x: line.frame.width, y: 10))
        shapeLayer.path = path
        
        line.layer.addSublayer(shapeLayer)
        self.addSubview(line)
        xline = line
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
      
//           xline?.frame =  CGRect(x: kLeftDis * 2, y:  self.carStatus.bottom + 8, width: self.tz_width - 4 * kLeftDis, height: 0.5)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //定义模型属性
    var carModel: CQCarsModel? {
        didSet {
            self.carName.text = carModel?.carName
            self.carNum.text = carModel?.carNumber
            self.cardLoad.text = (carModel?.personSize)! + "人"
            self.carStatus.text = carModel?.carCondition
            self.driverIcon.sd_setImage(with: URL(string: carModel?.carDriverHeadImg ?? ""), placeholderImage:UIImage.init(named: "personDefaultIcon") )
           
            let str = " | "
            let attributeText = NSMutableAttributedString.init(string: str)
            attributeText.addAttributes([NSAttributedStringKey.foregroundColor: kLineColor], range: NSRange(location: 0, length: 2))
            let text1 =  NSMutableAttributedString.init(string: (carModel?.carDriver)!)
            let text2 =  NSMutableAttributedString.init(string: (carModel?.carDriverUserName)!)
           // self.driver.text = (carModel?.carDriver)! + str + (carModel?.carDriverUserName)!
            text1.append(attributeText)
            text1.append(text2)
            self.driver.attributedText = text1
        }
    }
    
}

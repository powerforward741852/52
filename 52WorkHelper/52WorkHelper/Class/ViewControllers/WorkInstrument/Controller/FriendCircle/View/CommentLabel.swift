//
//  CommentLabel.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/3/24.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit



class CommentLabel: UIView {
    var linkLabel : MLLinkLabel?
    var model : QRCommentDataModel?
    //声明闭包
    typealias clickCommentClosure = (_ comment:QRCommentDataModel) -> Void
    //把申明的闭包设置成属性
    var clickText : clickCommentClosure?
    var clickLinkName : clickCommentClosure?

    override init(frame: CGRect) {
        super.init(frame: frame)
        let Text = MLLinkLabel()
        Text.font = kFontSize14
        Text.lineBreakMode = NSLineBreakMode.byCharWrapping
        Text.delegate = self
        Text.numberOfLines = 0
        let linkDict = [NSAttributedStringKey.foregroundColor:UIColor.colorWithHexString(hex: "#1e5f91")]
        let activeLinkDict = [NSAttributedStringKey.backgroundColor : kProjectBgColor,NSAttributedStringKey.foregroundColor:klightGreyColor]
        Text.linkTextAttributes = linkDict
        Text.activeLinkTextAttributes = activeLinkDict
        Text.dataDetectorTypes = MLDataDetectorTypes.attributedLink
        Text.lineBreakMode = NSLineBreakMode.byCharWrapping
        linkLabel = Text
        self.addSubview(Text)
        
    }
    func setModel(mod:QRCommentDataModel ,width:CGFloat ){
        model = mod
        //逻辑处理
        let attComment = NSMutableAttributedString(string: "")
        let tempCommentUserFrom = NSMutableAttributedString(string: mod.commentUserFrom)
        //第一人
        let dic = [NSAttributedStringKey.foregroundColor:UIColor.black,NSAttributedStringKey.link : "from"] as [NSAttributedStringKey : Any]
        tempCommentUserFrom.setAttributes(dic, range:(mod.commentUserFrom as NSString).range(of: mod.commentUserFrom))
        attComment.append(tempCommentUserFrom)
        
        if mod.commentUserTo == ""{
            let mao = NSMutableAttributedString(string: ": ")
            attComment.append(mao)
        }else{
            attComment.append(NSAttributedString(string: " 回复 "))
            //第2人
            let tempTo = NSMutableAttributedString(string: mod.commentUserTo)
            let dic = [NSAttributedStringKey.foregroundColor:UIColor.black,NSAttributedStringKey.link : "to"] as [NSAttributedStringKey : Any]
            tempTo.setAttributes(dic, range:(mod.commentUserTo as NSString).range(of:mod.commentUserTo))
            attComment.append(tempTo)
            let mao = NSMutableAttributedString(string: ": ")
            attComment.append(mao)
        }
        attComment.append(NSMutableAttributedString(string: mod.commentContent))
        
        linkLabel?.attributedText = attComment
        let size = linkLabel?.preferredSize(withMaxWidth: width)
        linkLabel?.frame =  CGRect(x: 10, y: 3, width: width-5 - AutoGetWidth(width: 5) - friendCircle.kPadding, height: (size?.height)!)
        self.height = (size?.height)!+6
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.backgroundColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: UInt64(0.15))) {
             self.backgroundColor = UIColor.clear
            self.clickText!(self.model!)
        }
        
        
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.backgroundColor = UIColor.clear
    }

}
extension CommentLabel:MLLinkLabelDelegate{
    func didClick(_ link: MLLink!, linkText: String!, linkLabel: MLLinkLabel!) {
      //  print(link.linkValue)
        self.clickLinkName!(self.model!)
    }
    
    
}

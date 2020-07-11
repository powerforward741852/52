//
//  QRScrollView.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/4/10.
//  Copyright © 2019年 chenqihang. All rights reserved.
//

import UIKit

class QRScrollView: UIScrollView {

    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let view = super .hitTest(point, with: event)
//        if view?.superview is CQHasNotDoCell{
//            self.isScrollEnabled = false
//        }else{
//            self.isScrollEnabled = true
//        }
//        return view
//    }
}
extension QRScrollView : UIGestureRecognizerDelegate{

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer.state.rawValue != 0 ? true : false
    }
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        if (gestureRecognizer.view?.isKind(of: CQHasNotDoCell.self))!{
//            self.canCancelContentTouches = false
//            self.delaysContentTouches = false
//            return false
//        }else{
//
//                self.canCancelContentTouches = true
//                self.delaysContentTouches = true
//            return false
//        }
//    }
    
}

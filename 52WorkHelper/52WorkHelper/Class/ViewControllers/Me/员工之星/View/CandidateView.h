//
//  CandidateView.h
//  smartoa
//
//  Created by 陈昱珍 on 15/12/18.
//  Copyright © 2015年 xmsmart. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CandidateModel;

@interface CandidateView : UIView
@property(nonatomic,strong) CandidateModel *model;
- (instancetype)initCandidateViewWithModel:(CandidateModel *)model;
+ (instancetype)candidateView;
@end

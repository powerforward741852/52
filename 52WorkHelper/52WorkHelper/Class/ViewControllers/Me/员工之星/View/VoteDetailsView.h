//
//  VoteDetailsView.h
//  smartoa
//
//  Created by 熊霖 on 16/1/6.
//  Copyright © 2016年 xmsmart. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PrizeModel;

@interface VoteDetailsView : UIView

@property(nonatomic,strong) PrizeModel *model;

+ (instancetype)voteDetailsView;

@end

//
//  CandidateTableViewCell.h
//  smartoa
//
//  Created by 熊霖 on 15/12/28.
//  Copyright © 2015年 xmsmart. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CandidateModel;
typedef void (^VoteBlock)(NSIndexPath *index);

@interface CandidateTableViewCell : UITableViewCell

@property(nonatomic,strong) CandidateModel *model;
@property(nonatomic,strong) NSIndexPath *index;
@property(nonatomic,strong) VoteBlock voteBlock;
@property(nonatomic,strong) UIButton *heart;/**投票按钮*/



@end

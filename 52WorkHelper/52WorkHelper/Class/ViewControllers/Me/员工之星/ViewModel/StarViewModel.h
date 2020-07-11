//
//  StarViewModel.h
//  smartoa
//
//  Created by 陈昱珍 on 15/12/17.
//  Copyright © 2015年 xmsmart. All rights reserved.
//

#import <Foundation/Foundation.h>
@class StarModel;
@class CandidateModel;
typedef void (^StarBlock)(NSString *msg,StarModel *model);
typedef void (^CandidateBlock)(CandidateModel *model);
typedef void (^SubmitBlock)(BOOL isVoted, NSString *reason);
typedef void (^VoteDetailBlock)(NSString *mag,NSArray * data);
typedef void (^VotetoDetailsBlock)(NSString *mag,NSMutableArray * data);
typedef void (^returenBlock)(NSString *data);


@interface StarViewModel : NSObject
@property (strong,nonatomic) StarBlock starBlock;
@property (strong,nonatomic) CandidateBlock candidateBlock;
@property (strong,nonatomic) SubmitBlock submitBlock;
@property (strong,nonatomic) VoteDetailBlock voteDetailBlack;
@property (strong,nonatomic) VotetoDetailsBlock votetoDetailsBlock;
@property (strong,nonatomic) returenBlock returenBlock;

- (void)getRulesWithModel:(StarModel *)model;
- (void)getCandidatesWithModel:(StarModel *)model;
- (void)getCandidateDetailWithModel:(CandidateModel *)model;
- (void)voteWithString:(NSString *)string Withsname:(NSString *)sname ruleId:(NSString *)ruleid;
-(void)getVoteDetailsWithruleId:(NSString *)ruleId;
/*!投票详情*/
-(void)getVoteDetailsWithvoteID:(NSString *)ruleId;

/*!获取ip地址*/
-(void)getIpWithModel;
@end

//
//  StarModel.h
//  smartoa
//
//  Created by 陈昱珍 on 15/12/18.
//  Copyright © 2015年 xmsmart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StarModel : NSObject
@property(nonatomic,copy) NSString *theme;/*!主题*/
@property(nonatomic,copy) NSString *year;/*!年度*/

@property(nonatomic,copy) NSString *rules;/*!规则*/
@property(nonatomic,copy) NSString *rid;/*!规则id*/
@property(nonatomic,copy) NSString *flow;//流程
@property(nonatomic,copy) NSString *sdate;/*!开始投票时间*/
@property(nonatomic,copy) NSString *edate;/*!结束投票时间*/
@property(nonatomic,copy) NSString *ifVote;/*!是否已经投过票*/
@property(nonatomic,copy) NSString *curDate;/*!当前时间*/
@property(nonatomic,copy) NSArray *list;/*!奖项集合*/
@property(nonatomic,copy) NSString *ifNotice;/*!是否开始公示*/

@property(nonatomic,copy) NSString *remarks;
@property(nonatomic,copy) NSString *ip;
@end

//
//  PrizeModel.h
//  smartoa
//
//  Created by 陈昱珍 on 15/12/23.
//  Copyright © 2015年 xmsmart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrizeModel : NSObject
@property(nonatomic,copy) NSString *priName;/*!奖项名称*/
@property(nonatomic,copy) NSString *priId;/*!奖项id*/
@property(nonatomic,copy) NSString *scount;/*!奖项个数*/
@property(nonatomic,copy) NSString *ccount;/*!候选个数*/
@property(nonatomic,copy) NSArray *pvList;/*!候选人集合*/

@property(nonatomic,assign)int selectedNum;/*!已选人数*/

/*! barChart*/
@property(nonatomic,copy) NSArray *list;/*!参选人数组*/
@property(nonatomic,copy) NSString *cname;/*!参选人姓名*/
@property(nonatomic,copy) NSString *vid;/*!参选人ID*/
@property(nonatomic,copy) NSString *vtotal;/*!参选人获得票数*/
@property(nonatomic,assign) float bHieght;/*!barcell高度*/

/*!votedetails*/
@property(nonatomic,copy) NSString *sname;/*!投票人姓名*/
@property(nonatomic,copy) NSString *cidNo;/*!候选人身份证号*/


@end

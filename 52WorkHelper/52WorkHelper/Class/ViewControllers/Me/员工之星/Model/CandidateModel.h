//
//  CandidateModel.h
//  smartoa
//
//  Created by 陈昱珍 on 15/12/23.
//  Copyright © 2015年 xmsmart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CandidateModel : NSObject
@property(nonatomic,copy) NSString *cno;/*!候选人工号*/
@property(nonatomic,copy) NSString *cname;/*!候选人姓名*/
@property(nonatomic,copy) NSString *cidNo;/*!候选人身份证号*/
@property(nonatomic,copy) NSString *cdept;/*!候选人部门*/
@property(nonatomic,copy) NSString *vid;/*!候选人id*/
@property(nonatomic,copy) NSString *wisdom;/*!竞选宣言*/
@property(nonatomic,copy) NSString *ctype;/*!奖项类型*/

@property(nonatomic,copy) NSString *apName;/*!奖项名称*/
@property(nonatomic,copy) NSString *cdName;/*!部门名称*/
@property(nonatomic,copy) NSString *cpName;/*!岗位名称*/
@property(nonatomic,copy) NSString *etime;/*!入职时间*/
@property(nonatomic,copy) NSString *introduce;/*!自评*/
@property(nonatomic,copy) NSString *vtotal;/*!票数*/
@property(nonatomic,copy) NSString *constells;/*!星座*/
@property(nonatomic,copy) NSString *hobbys;/*!爱好*/
@property(nonatomic,copy) NSString *achieves;/*!成就*/
@property(nonatomic,copy) NSString *manaviews;/*!经理意见*/
@property(nonatomic,copy) NSString *rsViews;/*!人事意见*/

@property(nonatomic,assign) BOOL selected;//是否选中
@end

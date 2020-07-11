//
//  ReturnModel.h
//  smartoa
//
//  Created by 熊霖 on 15/11/19.
//  Copyright © 2015年 xmsmart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReturnModel : NSObject

@property(nonatomic,copy) NSString *msg;/*!返回值*/

@property(nonatomic,copy) NSString *reason;/*!请求失败原因*/

@property(nonatomic,copy) id data;/*!返回值*/

@property(nonatomic,copy) NSString *list;/*!返回list*/

@property (nonatomic, copy) NSString *errorMsg;
@end

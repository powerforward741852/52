//
//  OCTool.h
//  test
//
//  Created by 秦榕 on 2018/9/4.
//  Copyright © 2018年 qq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCTool : NSObject

+ (NSString *)countNumAndChangeformat:(NSString *)num;

#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;
#pragma 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password;
#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *) userName;
#pragma 正则匹配用户身份证号
+ (BOOL)checkUserIdCard: (NSString *) idCard;
#pragma 正则匹配URL
+ (BOOL)checkURL : (NSString *) url;
#pragma 固定电话
+ (BOOL)checkOfficeTel:(NSString *) telNumber;

+(NSString *)arrayToJSONString:(NSArray *)array;
+(NSString *)randomData;
@end

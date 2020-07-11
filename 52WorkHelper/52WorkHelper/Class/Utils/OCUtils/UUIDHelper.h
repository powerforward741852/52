//
//  UUIDHelper.h
//  USGOU
//
//  Created by weibin on 15/6/8.
//  Copyright (c) 2015年 cwb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUIDHelper : NSObject

+ (UUIDHelper *)sharedInstance;

@property (nonatomic, strong, readonly) NSString *uuid;
//唯一字符串
+ (NSString *)generateUUID;

+ (NSString *)getUUID;

//+ (void)saveUUID:(NSString *)UUID;

@end

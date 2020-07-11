//
//  UUIDHelper.m
//  USGOU
//
//  Created by weibin on 15/6/8.
//  Copyright (c) 2015年 cwb. All rights reserved.
//

#import "UUIDHelper.h"
@import SSKeychain;
//#import "SSKeychain.h"
static  NSString *const UUIDService = @"UUIDService";
static  NSString *const UUIDAccount = @"UUIDAccount";
static NSString *const Key_UUID = @"唯一是别的Key_UUID";

@implementation UUIDHelper

+ (UUIDHelper *)sharedInstance
{
    static UUIDHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSString *)uuid
{
    NSString *str = [SSKeychain passwordForService:UUIDService account:UUIDAccount];
    
    if (str == nil || str.length == 0) {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        NSString *uuid = (__bridge NSString *)CFUUIDCreateString (kCFAllocatorDefault,uuidRef);
//        BOOL rs = [SSKeychain setPassword:uuid forService:UUIDService account:UUIDAccount];
//        assert(rs != NO);
        return uuid;
    } else {
        return str;
    }
}

+ (NSString *)generateUUID
{
    CFUUIDRef uuid;
    CFStringRef uuidString;
    NSString *result;
    
    uuid = CFUUIDCreate(NULL);
    uuidString = CFUUIDCreateString(NULL, uuid);
    result = [NSString stringWithFormat:@"%@",uuidString];
    
    CFRelease(uuidString);
    CFRelease(uuid);
    
    return result;
}

static NSString *uuid = nil;
+ (NSString *)getUUID
{
    if (uuid) {
        return uuid;
    }
    uuid = [SSKeychain passwordForService:@"WorkHelperServiceName" account:@"workhelperuuid"];
    if (!uuid) {
        uuid = [self generateUUID];
        [SSKeychain setPassword:uuid forService:@"WorkHelperName" account:@"workhelperuuid"];
    }
    return uuid;
}



@end

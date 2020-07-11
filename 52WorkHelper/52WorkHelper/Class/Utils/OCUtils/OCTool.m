//
//  OCTool.m
//  test
//
//  Created by 秦榕 on 2018/9/4.
//  Copyright © 2018年 qq. All rights reserved.
//

#import "OCTool.h"
@interface OCTool ()

@end
@implementation OCTool

+ (NSString *)randomData{
   NSArray *arr1 = @[@"沈",@"秦",@"云",@"唐",@"高",@"裴",@"萧",@"上官",@"慕容",@"司徒",@"南宫",@"百里",@"北宫",@"月",@"楚",@"言",@"琴",@"古",@"镜",@"龙",@"冷",@"叶",@"北冥",@"公孙",@"独孤",@"皇甫",@"尚",@"闻人",@"苍羽",@"轩辕",@"南风",@"即墨"];
   NSArray *arr2 = @[@"浩",@"凌风",@"绝尘",@"文昭",@"阳城",@"文",@"奇",@"华晨",@"鹤城",@"袁也",@"成飞",@"哲七",@"鸿远",@"正",@"心池",@"池",@"心",@"阅",@"光",@"水",@"翰",@"和",@"清",@"易",@"宣",@"德",@"茂",@"明",@"纬",@"寺",@"明",@"晖",@"飞语",@"文哲",@"真",@"嘉",@"一",@"",@"寒",@"亦凌",@"宇",@"莫离",@"陵",@"宇轩",@"晨浩",@"痕",@"渊",@"尚城",@"离",@"陌",@"渡",@"陌然"];
    int name_value = arc4random()%arr1.count;
    int secondname_value = arc4random()%arr2.count;
    
    NSString * arr1_str = arr1[name_value];
    NSString * arr2_str = arr2[secondname_value];
    
    NSString *all_str = [[NSString alloc]initWithFormat:@"%@%@",arr1_str,arr2_str];
    
    return all_str;
    
}

//数字逗号分隔

+ (NSString *)countNumAndChangeformat:(NSString *)num{
    
    int count = 0;
    
    long long int a = num.longLongValue;
    
    while (a != 0){
        
        count++;
        
        a /= 10;
        
    }
    
    NSMutableString *string = [NSMutableString stringWithString:num];
    
    NSMutableString *newstring = [NSMutableString string];
    
    while (count > 3) {
        
        count -= 3;
        
        NSRange rang = NSMakeRange(string.length - 3, 3);
        
        NSString *str = [string substringWithRange:rang];
        
        [newstring insertString:str atIndex:0];
        
        [newstring insertString:@"," atIndex:0];
        
        [string deleteCharactersInRange:rang];
        
    }
    
    [newstring insertString:string atIndex:0];
    
    return newstring;
}


#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber
{
    NSString *pattern = @"^1+[3578]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}


#pragma 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}

//NSString * PHS = @"^(0[0-9]{2})\\d{8}$|^(0[0-9]{3}(\\d{7,8}))$";
#pragma 固定电话组合
+ (BOOL)checkOfficeTel:(NSString *) telNumber
{
    NSString *pattern = @"^(0[0-9]{2})\\d{8}$|^(0[0-9]{3}(\\d{7,8}))$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
    
}

#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *) userName
{
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5]{1,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
    
}


#pragma 正则匹配用户身份证号15或18位
+ (BOOL)checkUserIdCard: (NSString *) idCard
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}

#pragma 正则匹员工号,12位的数字
+ (BOOL)checkEmployeeNumber : (NSString *) number
{
    NSString *pattern = @"^[0-9]{12}";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
    
}

#pragma 正则匹配URL
+ (BOOL)checkURL : (NSString *) url
{
    NSString *pattern = @"^[0-9A-Za-z]{1,50}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:url];
    return isMatch;
}

+(NSString *)arrayToJSONString:(NSArray *)array
{
    NSError *error = nil;
    //    NSMutableArray *muArray = [NSMutableArray array];
    //    for (NSString *userId in array) {
    //        [muArray addObject:[NSString stringWithFormat:@"\"%@\"", userId]];
    //    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *jsonResult = [jsonTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    NSLog(@"json array is: %@", jsonResult);
    return jsonResult;
}



@end

//
//  NSString+LXLGetCGSize.m
//  QQ
//
//  Created by 林希良 on 15/5/7.
//  Copyright (c) 2015年 lxl. All rights reserved.
//  返回文字的高度和宽度

#import "NSString+LXLGetCGSize.h"

@implementation NSString (LXLGetCGSize)
/**
 *  计算文字占用屏幕的尺寸,利用NSString里面的text去调用此方法
 */
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    //1设定字体的大小
    NSDictionary *attrs = @{NSFontAttributeName : font};
    //2返回size
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin  attributes:attrs context:nil].size;
}
@end

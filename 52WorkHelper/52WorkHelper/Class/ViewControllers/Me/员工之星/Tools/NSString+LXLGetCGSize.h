//
//  NSString+LXLGetCGSize.h
//  QQ
//
//  Created by 林希良 on 15/5/7.
//  Copyright (c) 2015年 lxl. All rights reserved.
//  返回文字的宽度和高度

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (LXLGetCGSize)
/**
 *  计算文字占用屏幕的尺寸,利用NSString里面的text去调用此方法
 */
-(CGSize) sizeWithFont:(UIFont *) font maxSize:(CGSize) maxSize;
@end

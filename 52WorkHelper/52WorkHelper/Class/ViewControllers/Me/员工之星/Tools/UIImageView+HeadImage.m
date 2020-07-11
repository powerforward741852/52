//
//  UIImageView+HeadImage.m
//  smartoa
//
//  Created by 邱仙凯 on 15/10/26.
//  Copyright © 2015年 xmsmart. All rights reserved.
//

#import "UIImageView+HeadImage.h"
//#import "SDImageCache.h"
#import "UIImageView+WebCache.h"

//userdefault
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
@implementation UIImageView (HeadImage)

-(void)setSmartHeadImageWithIDnum:(NSString *)idNum
{
    NSString *imageStrPath = [NSString stringWithFormat:@"%@photo/%@.jpg",[USER_DEFAULT objectForKey:@"baseIP"],idNum];
    NSURL *imageUrl = [NSURL URLWithString:imageStrPath];
    [self sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"user_iconPP"] options:SDWebImageRefreshCached];
}

-(void)setSmartHeadImageWithvID:(NSString *)vid WithcId:(NSString *)cid
{
    __weak typeof(self)wSelf = self;
    
    NSString *imagecIdPath = [NSString stringWithFormat:@"%@photo/%@.jpg",[USER_DEFAULT objectForKey:@"baseIP"],cid];
    NSString *imagevIdPath = [NSString stringWithFormat:@"%@prizePhoto/%@.jpg",[USER_DEFAULT objectForKey:@"baseIP"],vid];
    
    NSURL *imgcUrl = [NSURL URLWithString:imagecIdPath];
    NSURL *imgvUrl = [NSURL URLWithString:imagevIdPath];
    
    [self sd_setImageWithURL:imgvUrl placeholderImage:[UIImage imageNamed:@"user_iconPP"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            
        }else{
            [wSelf sd_setImageWithURL:imgcUrl placeholderImage:[UIImage imageNamed:@"user_iconPP"] options:SDWebImageRefreshCached];
        }
    }];
    
    
//    [self setImageWithURL:imgvUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user_iconPP"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//        if (image) {
//            NSLog(@"有图片");
//        }else{
//            NSLog(@"无图片");
//            [wSelf setImageWithURL:imgcUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user_iconPP"] options:SDWebImageRefreshCached];
//            
//        }
//        
//    }];
    
}

@end

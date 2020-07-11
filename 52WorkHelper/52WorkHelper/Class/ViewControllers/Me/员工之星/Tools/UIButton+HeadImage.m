//
//  UIButton+HeadImage.m
//  smartoa
//
//  Created by 邱仙凯 on 15/10/26.
//  Copyright © 2015年 xmsmart. All rights reserved.
//

#import "UIButton+HeadImage.h"
#import "SDImageCache.h"
#import "UIButton+WebCache.h"
//userdefault
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
@implementation UIButton (HeadImage)
-(void)setSmartIconWithIDnum:(NSString *)idNum
{
    NSString *imageStrPath = [NSString stringWithFormat:@"%@photo/%@.jpg",[USER_DEFAULT objectForKey:@"baseIP"],idNum];
    NSURL *imageUrl = [NSURL URLWithString:imageStrPath];
    [self sd_setImageWithURL:imageUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user_iconPP"] options:SDWebImageRefreshCached];
}



-(void)setSmartHeadImageWithvID:(NSString *)vid WithcId:(NSString *)cid
{
    __weak typeof(self)wSelf = self;
    
    NSString *imagecIdPath = [NSString stringWithFormat:@"%@photo/%@.jpg",[USER_DEFAULT objectForKey:@"baseIP"],cid];
    NSString *imagevIdPath = [NSString stringWithFormat:@"%@prizePhoto/%@.jpg",[USER_DEFAULT objectForKey:@"baseIP"],vid];
    
    NSURL *imgcUrl = [NSURL URLWithString:imagecIdPath];
    NSURL *imgvUrl = [NSURL URLWithString:imagevIdPath];

    [self sd_setImageWithURL:imgvUrl forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            NSLog(@"有图片");
        }else{
            NSLog(@"无图片");
            [wSelf sd_setImageWithURL:imgcUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user_iconPP"] options:SDWebImageRefreshCached];
            
        }
    }];
    
}

-(void)setCustomerHeadImageWithcustomerID:(NSString *)cid{
    NSString *imageStrPath = [NSString stringWithFormat:@"%@photo/customer/%@.jpg",[USER_DEFAULT objectForKey:@"baseIP"],cid];
    NSURL *imageUrl = [NSURL URLWithString:imageStrPath];
//    [self setImageWithURL:imageUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user_iconPP"] options:SDWebImageRefreshCached];
    [self sd_setImageWithURL:imageUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user_iconPP"]];
}


@end

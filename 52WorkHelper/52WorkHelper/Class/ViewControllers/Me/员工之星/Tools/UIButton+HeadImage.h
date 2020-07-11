//
//  UIButton+HeadImage.h
//  smartoa
//
//  Created by 邱仙凯 on 15/10/26.
//  Copyright © 2015年 xmsmart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (HeadImage)
-(void)setSmartIconWithIDnum:(NSString *)idNum;

-(void)setSmartHeadImageWithvID:(NSString *)vid WithcId:(NSString *)cid;/*!vid获取头像*/


-(void)setCustomerHeadImageWithcustomerID:(NSString *)cid;/*!cid获取客户头像*/

@end

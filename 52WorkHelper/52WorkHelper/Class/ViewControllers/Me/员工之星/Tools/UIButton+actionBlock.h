//
//  UIButton+actionBlock.h
//  smartoa
//
//  Created by 邱仙凯 on 15/11/16.
//  Copyright © 2015年 xmsmart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

//Block
typedef void(^VoidBlock)(void);

@interface UIButton (actionBlock)
//@property (readonly) NSMutableDictionary *event;

//- (void) handleControlEvent:(UIControlEvents)controlEvent withBlock:(VoidBlock)action;
-(void)addAcionBlock:(VoidBlock)action;
@end

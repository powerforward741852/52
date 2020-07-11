//
//  UIButton+actionBlock.m
//  smartoa
//
//  Created by 邱仙凯 on 15/11/16.
//  Copyright © 2015年 xmsmart. All rights reserved.
//

#import "UIButton+actionBlock.h"



@implementation UIButton (actionBlock)

static char overviewKey;

//@dynamic event;

//- (void)handleControlEvent:(UIControlEvents)event withBlock:(VoidBlock)block {
//    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
//    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
//}
- (void)addAcionBlock:(VoidBlock)action
{
    objc_setAssociatedObject(self, &overviewKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)callActionBlock:(id)sender {
    VoidBlock block = (VoidBlock)objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block();
    }
}

@end

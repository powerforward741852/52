//
//  LoadingAndRefreshView.h
//  CarpFinancial
//
//  Created by weibin on 15/12/11.
//  Copyright © 2015年 cwb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoadingAndRefreshViewDelegate <NSObject>

//点击刷新
- (void)refreshClick;

@end

@interface LoadingAndRefreshView : UIView

@property(weak,  nonatomic) id<LoadingAndRefreshViewDelegate>delegate;
@property(copy, nonatomic) void (^refleshBlock) (void);

- (void)setLoadingState;
- (void)setSuccessState;
- (void)setFailedState;

@end

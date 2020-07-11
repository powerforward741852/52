//
//  MyTextField.h
//  CarpFinancial
//
//  Created by weibin on 15/12/11.
//  Copyright © 2015年 cwb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyBoardDelegate <NSObject>

@optional

- (void)deleteBackward;

@end

@interface MyTextField : UITextField 

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, assign) id<KeyBoardDelegate> keyBoardDelegate;

@end

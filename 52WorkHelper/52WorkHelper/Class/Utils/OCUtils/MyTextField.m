//
//  MyTextField.m
//  CarpFinancial
//
//  Created by weibin on 15/12/11.
//  Copyright © 2015年 cwb. All rights reserved.
//

#import "MyTextField.h"



@implementation MyTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return self;
}

- (void)deleteBackward
{
    [super deleteBackward];
    
    if (_keyBoardDelegate && [_keyBoardDelegate respondsToSelector:@selector(deleteBackward)])
    {
        [_keyBoardDelegate deleteBackward];
    }
}


@end

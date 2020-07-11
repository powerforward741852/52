//
//  CBTextView.h
//  KinHop
//
//  Created by weibin on 14/11/26.
//  Copyright (c) 2014年 cwb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBTextView : UIView
{
    UIColor *defaultTextColor;
}

@property (strong, nonatomic) UITextView *textView;

@property (assign, nonatomic) BOOL isSupportEmoji;

@property (strong, nonatomic) NSString *prevText;

@property (strong, nonatomic) NSString *placeHolder;

@property (strong, nonatomic) UIColor *placeHolderColor;

@property (weak, nonatomic) id<UITextViewDelegate> aDelegate;



@end

//
//  SSSearchBar.m
//  Demo
//
//  Created by xk jiang on 2017/10/10.
//  Copyright © 2017年 xk jiang. All rights reserved.
//

#import "SSSearchBar.h"
#import "UIImage+Tool.h"

@interface SSSearchBar () <UITextFieldDelegate>

// placeholder 和icon 和 间隙的整体宽度
@property (nonatomic, assign) CGFloat placeholderWidth;

@end

// icon宽度
static CGFloat const searchIconW = 20.0;
// icon与placeholder间距
static CGFloat const iconSpacing = 10.0;
// 占位文字的字体大小
static CGFloat const placeHolderFont = 14.0;
@interface SSSearchBar ()
@property (nonatomic,strong)  UITextField* myField;
@property (nonatomic,strong)  UIButton* mycancel;

@end
@implementation SSSearchBar

- (void)layoutSubviews {
    [super layoutSubviews];
    // 设置背景图片
    UIImage *backImage = [UIImage imageWithColor:[UIColor whiteColor]];
    [self setBackgroundImage:backImage];
    for (UIView *view in [self.subviews lastObject].subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *field = (UITextField *)view;
            // 重设field的frame
            field.frame = CGRectMake(15.0, 7.5, self.frame.size.width-30.0, self.frame.size.height-15.0);
            _myField = field;
            [field setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:240/255.0 alpha:1]];
            field.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
            
            field.borderStyle = UITextBorderStyleNone;
            field.layer.cornerRadius = 8.0f;
            field.layer.masksToBounds = YES;
            field.clearButtonMode = UITextFieldViewModeNever;
            // 设置占位文字字体颜色
            [field setValue:[UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
            [field setValue:[UIFont systemFontOfSize:placeHolderFont] forKeyPath:@"_placeholderLabel.font"];
            UIButton *cancel = [self valueForKey:@"_cancelButton"];
            cancel.titleLabel.font = [UIFont systemFontOfSize:14];
            
           // cancel.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
            if (@available(iOS 11.0, *)) {
                // 先默认居中placeholder
                [self setPositionAdjustment:UIOffsetMake((field.frame.size.width-self.placeholderWidth)/2, 0) forSearchBarIcon:UISearchBarIconSearch];
            }
        }
    }
}

- (void)changeFrame{
    self.myField.frame = CGRectMake(15.0, 7.5, self.frame.size.width-60.0, self.frame.size.height-15.0);
    if (_mycancel) {
        _mycancel.alpha = 1;
    }else{
        UIButton*cancel = [[UIButton alloc] init];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        cancel.frame = CGRectMake(self.frame.size.width-45.0, 7.5, 45, self.frame.size.height-15.0);
        cancel.titleLabel.font = [UIFont systemFontOfSize:14];
        [cancel setTitleColor: [UIColor colorWithRed:60/255.0 green:174/255.0  blue:254/255.0  alpha:1] forState:UIControlStateNormal];
        
        [self addSubview:cancel];
        [cancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        self.mycancel = cancel;
        _mycancel.alpha = 1;
    }

    
}
- (void)cancelClick{
    [self changeHideFrame];
    [self.myField resignFirstResponder];
}
- (void)changeHideFrame{
    self.myField.frame = CGRectMake(15.0, 7.5, self.frame.size.width-30.0, self.frame.size.height-15.0);
    self.mycancel.alpha = 0;
}

// 开始编辑的时候重置为靠左
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // 继续传递代理方法
    
    if ([self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        [self.delegate searchBarShouldBeginEditing:self];
        
    }
    if (@available(iOS 11.0, *)) {
        [self setPositionAdjustment:UIOffsetZero forSearchBarIcon:UISearchBarIconSearch];
    }
    
    [self changeFrame];
    //self.showsCancelButton = YES;
    return YES;
}
// 结束编辑的时候设置为居中
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
        [self.delegate searchBarShouldEndEditing:self];
    }
    if (@available(iOS 11.0, *)) {
        [self setPositionAdjustment:UIOffsetMake((textField.frame.size.width-self.placeholderWidth)/2, 0) forSearchBarIcon:UISearchBarIconSearch];
    }
    [self changeHideFrame];
   // self.showsCancelButton = NO;
    return YES;
}

// 计算placeholder、icon、icon和placeholder间距的总宽度
- (CGFloat)placeholderWidth {
    if (!_placeholderWidth) {
        CGSize size = [self.placeholder boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:placeHolderFont]} context:nil].size;
        _placeholderWidth = size.width + iconSpacing + searchIconW;
    }
    return _placeholderWidth;
}


@end

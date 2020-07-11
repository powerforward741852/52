//
//  CBTextView.m
//  KinHop
//
//  Created by weibin on 14/11/26.
//  Copyright (c) 2014年 cwb. All rights reserved.
//

#import "CBTextView.h"
#import "SVProgressHUD.h"
#define SHOW_DEBUG_VIEW     0

#define RGBAlphaColor(r, g, b, a) \
[UIColor colorWithRed:(r/255.0)\
green:(g/255.0)\
blue:(b/255.0)\
alpha:(a)]

#define OpaqueRGBColor(r, g, b) RGBAlphaColor((r), (g), (b), 1.0)

@interface CBTextView () <UITextViewDelegate>


@end

@implementation CBTextView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self addSubview:self.textView];
    self.isSupportEmoji = false;
    self.placeHolderColor = OpaqueRGBColor(199, 200, 201);
    self.textView.delegate = self;
    
#if SHOW_DEBUG_VIEW
    self.textView.backgroundColor = DEBUG_VIEW_ITEM_COLOR;
    self.backgroundColor = DEBUG_VIEW_CONTAINER_COLOR;
#endif
}

#pragma mark - Layout
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGRect aFrame = CGRectZero;
    aFrame.origin = self.bounds.origin;
    aFrame.size = frame.size;
    self.textView.frame = aFrame;
}

#pragma mark - Accessor

-(void)setPrevText:(NSString *)prevText{
    _prevText=prevText;
    self.textView.text=_prevText;
    self.textView.textColor = defaultTextColor;
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    self.textView.text = placeHolder;
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    _placeHolderColor = placeHolderColor;
    self.textView.textColor = placeHolderColor;
}

- (void)setTextColor:(UIColor *)textColor
{
    defaultTextColor = self.textView.textColor;
    self.textView.textColor = textColor;
}

- (void)setADelegate:(id)aDelegate
{
    _aDelegate = aDelegate;
}

- (UITextView *)textView
{
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        _textView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    return _textView;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.aDelegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        return [self.aDelegate textViewShouldBeginEditing:textView];
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([self.aDelegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        return [self.aDelegate textViewShouldEndEditing:textView];
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.textView.text = _prevText;
    self.textView.textColor = defaultTextColor;
    
    if ([self.aDelegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [self.aDelegate textViewDidBeginEditing:textView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    _prevText = self.textView.text;
    if (!_prevText || [_prevText length]==0) {
        self.textView.text = self.placeHolder;
        self.textView.textColor = self.placeHolderColor;
    }
    
    if ([self.aDelegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [self.aDelegate textViewDidEndEditing:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text] == YES) {
//        [textView resignFirstResponder];
        return YES;
    }
    
    if (_isSupportEmoji == true) {
        
        
        
    }else{
        if ([textView isFirstResponder]) {
            if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
                [SVProgressHUD showInfoWithStatus:@"不支持emoji表情"];
                return NO;
            }
            //判断键盘是不是九宫格键盘
            if ([self isNineKeyBoard:text] ){
                return YES;
            }else{
                if ([self hasEmoji:text] || [self stringContainsEmoji:text]){
                    [SVProgressHUD showInfoWithStatus:@"不支持emoji表情"];
                    return NO;
                }
            }
        }
    }
    
    
    if ([self.aDelegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        return [self.aDelegate textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    
    return YES;
}

/**
 *  判断字符串中是否存在emoji
 * @param string 字符串
 * @return YES(含有表情)
 */
- (BOOL)stringContainsEmoji:(NSString *)string {
    
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

/**
 *  判断字符串中是否存在emoji
 * @param string 字符串
 * @return YES(含有表情)
 */
- (BOOL)hasEmoji:(NSString*)string;
{
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

/**
 判断是不是九宫格
 @param string  输入的字符
 @return YES(是九宫格拼音键盘)
 */
-(BOOL)isNineKeyBoard:(NSString *)string
{
    NSString *other = @"➋➌➍➎➏➐➑➒";
    int len = (int)string.length;
    for(int i=0;i<len;i++)
    {
        if(!([other rangeOfString:string].location != NSNotFound))
            return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([self.aDelegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.aDelegate textViewDidChange:textView];
    }
    
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if ([self.aDelegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [self.aDelegate textViewDidChangeSelection:textView];
    }
}

#pragma mark - Actions
- (BOOL)resignFirstResponder
{
    return [self.textView resignFirstResponder];
}

@end

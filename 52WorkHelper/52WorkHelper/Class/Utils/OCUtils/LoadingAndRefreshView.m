//
//  LoadingAndRefreshView.m
//  CarpFinancial
//
//  Created by weibin on 15/12/11.
//  Copyright © 2015年 cwb. All rights reserved.
//

#import "LoadingAndRefreshView.h"

#define SizeImageWidth AutoWHGetWidth(72.0)

@interface LoadingAndRefreshView()

@property (nonatomic, strong) UIImageView *imageview;
@property (nonatomic, strong) NSMutableArray *imageviewArr;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *label;

@end

@implementation LoadingAndRefreshView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView:frame];
    }
    return self;
}

- (void)initView:(CGRect)frame
{
    self.backgroundColor = [UIColor whiteColor];
    
    CGRect rect = frame;
    self.frame = rect;
    
    self.imageview = [[UIImageView alloc] initWithFrame:CGRectMake((self.window.screen.bounds.size.width - 113.0) / 2.0, 140, 113.0, 118.0)];
    [self addSubview:self.imageview];
    self.imageview.contentMode = UIViewContentModeScaleAspectFit;
    self.imageview.image = [UIImage imageNamed:@"webChange"];
    self.imageview.backgroundColor = [UIColor clearColor];
    
    _label = [[UILabel alloc] initWithFrame: CGRectMake(0, self.imageview.frame.size.height + self.imageview.frame.origin.y + 24, self.window.screen.bounds.size.width, 15)];
    _label.textColor = [UIColor colorWithRed:208 green:207 blue:207 alpha:1];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"亲,您的手机网络不太顺畅喔~";
    _label.font = [UIFont systemFontOfSize:15];
    [self addSubview:_label];
    
    // 重新加载按钮
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake((self.window.screen.bounds.size.width - 120)/2, _label.frame.origin.y + _label.frame.size.height + 16, 120, 39);
    [self.button setTitle:@"重新加载" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(refreshClick) forControlEvents:(UIControlEventTouchUpInside)];
    self.button.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button setBackgroundColor:[UIColor redColor]];
    self.button.layer.cornerRadius = 6.0;
    self.button.clipsToBounds = YES;
}

//刷新
-(void)refreshClick
{
    [self setLoadingState];
    
    if (_refleshBlock) {
        _refleshBlock();
    }
    if (_delegate && [_delegate respondsToSelector:@selector(refreshClick)]) {
        [_delegate refreshClick];
    }
}

- (void)setLoadingState
{
//    self.backgroundColor = kColorClear;
    _imageview.hidden = YES;
    _button.hidden = YES;
    _label.hidden = YES;
    [_imageview startAnimating];
}

- (void)setSuccessState
{
    [self removeFromSuperview];
    [_imageview stopAnimating];
}

- (void)setFailedState
{
    self.backgroundColor = [UIColor whiteColor];
    _imageview.hidden = NO;
    _button.hidden = NO;
    _label.hidden = NO;
    [_imageview stopAnimating];
    [_imageview setImage:[UIImage imageNamed:@"webChange"]];
}

//播放动画
- (void)runAnimation
{
    _imageview.animationImages = _imageviewArr;
    _imageview.animationDuration = 1 ;
    _imageview.animationRepeatCount = 0;
}

@end

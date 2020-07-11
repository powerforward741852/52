//
//  ConfirmCollectionViewCell.m
//  smartoa
//
//  Created by 熊霖 on 16/1/8.
//  Copyright © 2016年 xmsmart. All rights reserved.
//

#import "ConfirmCollectionViewCell.h"
#import "CandidateModel.h"
#import "UIImageView+HeadImage.h"

#import "SVProgressHUD.h"
#import "Masonry.h"
#import "UIButton+actionBlock.h"
#import "NSString+LXLGetCGSize.h"
#import "MJExtension.h"
#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//屏幕尺寸
#define mIPHONE_W ([UIScreen mainScreen].bounds.size.width)
#define mIPHONE_H ([UIScreen mainScreen].bounds.size.height)
#define RGB(r, g, b)             [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

#define LABELHIGHT 30
#define Color(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:0.2]
#define FONTSIZE 20


@interface ConfirmCollectionViewCell ()

@property(nonatomic,strong) UIView * bgView;/*!背景View（透明）*/
@property(nonatomic,strong) UIImageView *portrait;/**头像*/

@property(nonatomic,strong) UILabel *dept;/**部门*/
@property(nonatomic,strong) UILabel *name;/**姓名*/

@end


@implementation ConfirmCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
       
        [self addTheCell];
        
    }
    return self;
}

-(void)addTheCell{
    
    // __weak typeof(self)weakSelf = self;
    
    //底层View
    UIView * bgView = [[UIView alloc]init];
    bgView.backgroundColor = Color(194, 210, 229);
    bgView.layer.borderWidth = 0.5;
    bgView.layer.borderColor = RGB(59, 160, 207).CGColor;
    self.bgView = bgView;
    
    [self addSubview:bgView];
    
    //头像
    UIImageView * portrait = [[UIImageView alloc]init];
    portrait.backgroundColor = [UIColor clearColor];
    
    self.portrait = portrait;
    [bgView addSubview:portrait];
    
    //姓名
    UILabel * name = [[UILabel alloc]init];
    name.font = [UIFont boldSystemFontOfSize:15];
    name.backgroundColor = [UIColor clearColor];
    name.textColor = [UIColor whiteColor];
    
    self.name = name;
    [bgView addSubview:name];
    
    
    //部门
    UILabel * dept = [[UILabel alloc]init];
    dept.font = [UIFont systemFontOfSize:12];
    dept.textColor = [UIColor whiteColor];
    dept.backgroundColor = [UIColor clearColor];
    
    
//    [dept setNumberOfLines:0];
//    dept.lineBreakMode =NSLineBreakByWordWrapping;
    
    
  

    
    self.dept = dept;
    [bgView addSubview:dept];


    
    
    
}


- (void)layoutSubviews
{
    __weak typeof(self)weakSelf = self;
    
//    CGSize size = [weakSelf.dept sizeThatFits:CGSizeMake(CGRectGetWidth(weakSelf.dept.frame), MAXFLOAT)];
//    CGRect frame = weakSelf.dept.frame;
//    frame.size.height = size.height;
//    weakSelf.dept.frame = frame;
    
    //底层View
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(0);
        make.bottom.equalTo(weakSelf).offset(0);
        make.right.equalTo(weakSelf).offset(10);
        make.width.equalTo(weakSelf).offset(10);
    }];
    
    
    //头像
    [self.portrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView).offset(10);
        make.top.equalTo(weakSelf.bgView).offset(10);
        make.width.height.mas_equalTo(60);
    }];
    
    //部门
    [self.dept mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).offset(-15);
        make.left.equalTo(weakSelf.name);
        
    }];
    
    //姓名
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.dept.mas_top).offset(-15);
        make.left.equalTo(weakSelf.portrait.mas_right).offset(10);
    }];
    
   

    [super layoutSubviews];
    
}

-(void)setModel:(CandidateModel *)model
{
    _model = model;
    self.dept.text = _model.cdept;
    self.name.text = _model.cname;

    [self.portrait setSmartHeadImageWithvID:model.vid WithcId:model.cidNo];
    
    
    
    
}


@end

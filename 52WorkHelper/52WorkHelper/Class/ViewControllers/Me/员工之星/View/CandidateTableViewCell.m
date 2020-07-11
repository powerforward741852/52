//
//  CandidateTableViewCell.m
//  smartoa
//
//  Created by 熊霖 on 15/12/28.
//  Copyright © 2015年 xmsmart. All rights reserved.
//

#import "CandidateTableViewCell.h"
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
#define FONTSIZE 12

@interface CandidateTableViewCell ()
@property(nonatomic,strong) UIView * bgView;/*!背景View（透明）*/
@property(nonatomic,strong) UIImageView *portrait;/**头像*/
@property(nonatomic,assign) CGFloat picW;/**头像宽度*/
@property(nonatomic,strong) UILabel *dept;/**部门*/
@property(nonatomic,strong) UILabel *name;/**姓名*/
@property(strong,nonatomic) UILabel *declaration;/**宣言*/

@end


@implementation CandidateTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initView];
    }
    return self;
}
/*
 * - 添加视图
 */
-(void)initView
{
    __weak typeof(self)weakSelf = self;
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
    portrait.contentMode = UIViewContentModeScaleAspectFill;
    portrait.layer.masksToBounds = YES;
    portrait.layer.cornerRadius = 8.0;
    self.portrait = portrait;
    [bgView addSubview:portrait];
    
    //姓名
    UILabel * name = [[UILabel alloc]init];
    name.font = [UIFont systemFontOfSize:FONTSIZE];
    name.backgroundColor = [UIColor clearColor];
    name.textColor = [UIColor whiteColor];
    self.name = name;
    [bgView addSubview:name];
    
    
    //部门
    UILabel * dept = [[UILabel alloc]init];
    dept.font = [UIFont systemFontOfSize:FONTSIZE];
    dept.textColor = [UIColor whiteColor];
    dept.backgroundColor = [UIColor clearColor];
    self.dept = dept;
    [bgView addSubview:dept];
    
    
    //宣言
    UILabel * declaration = [[UILabel alloc]init];
    declaration.font = [UIFont systemFontOfSize:FONTSIZE];
    declaration.textColor = [UIColor whiteColor];
    declaration.backgroundColor = [UIColor clearColor];
    self.declaration = declaration;
    [bgView addSubview:declaration];
    
    //选择按钮
    _heart = [UIButton buttonWithType:UIButtonTypeCustom];
    _heart.backgroundColor = [UIColor clearColor];
//    _heart.imageEdgeInsets = UIEdgeInsetsMake(111-15, 10, 150, 10);
    [_heart setImage:[UIImage imageNamed:@"selectNo"] forState:UIControlStateNormal];
    [_heart setImage:[UIImage imageNamed:@"selectYes"] forState:UIControlStateSelected];
   

    [_heart addAcionBlock:^{
     
        weakSelf.voteBlock(weakSelf.index);
        
    }];
    [bgView addSubview:_heart];
    
}

- (void)layoutSubviews
{
    __weak typeof(self)weakSelf = self;
    
    //底层View
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(0);
        make.bottom.equalTo(weakSelf).offset(0);
        make.right.equalTo(weakSelf).offset(15);
        make.width.equalTo(weakSelf).offset(15);
    }];
    
    
    //头像
    [self.portrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView).offset(15);
        make.top.equalTo(weakSelf.bgView).offset(15);
        make.width.height.mas_equalTo(60);
    }];
    
    //姓名
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.portrait);
        make.left.equalTo(weakSelf.portrait.mas_right).offset(10);
    }];
    
    //部门
    [self.dept mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.name.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.name);
    }];
    
    //宣言
    [self.declaration mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.dept.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.name);
//        make.width.mas_equalTo(240);
    }];
    
    //选着按钮
    [self.heart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgView).offset(35.5);
        make.right.equalTo(weakSelf.bgView).offset(-35);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(19);
    }];
    
    
    [super layoutSubviews];
}


-(void)setModel:(CandidateModel *)model
{
    _model = model;
    self.dept.text = _model.cdept;
    self.name.text = _model.cname;
    self.declaration.text = _model.wisdom;
    self.heart.selected = _model.selected;
//    [self.portrait setSmartHeadImageWithIDnum:_model.cidNo];
    [self.portrait setSmartHeadImageWithvID:model.vid WithcId:model.cidNo];
    
  
    
    
}

@end

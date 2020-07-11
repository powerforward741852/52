//
//  CandidateView.m
//  smartoa
//
//  Created by 陈昱珍 on 15/12/18.
//  Copyright © 2015年 xmsmart. All rights reserved.
//

#import "CandidateView.h"
#import "CandidateModel.h"
//#import "UIButton+HeadImage.h"
#import "UIButton+HeadImage.h"

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

#define SafeAreaTopHeight  ( mIPHONE_H == 812.0 || mIPHONE_H == 896 ? 88 : 64)

@interface CandidateView ()
@property (strong, nonatomic) UIImageView *cover;/**封面*/
@property(nonatomic,strong) UIImageView *circle;/**头像后面的圈圈*/
@property (strong, nonatomic) UIButton *portrait;/**头像*/
@property(nonatomic,strong) UIButton *heart;/**投票爱心按钮*/
@property (strong, nonatomic) UILabel *name;/**姓名*/
@property (strong,nonatomic) UILabel *department;/*!部门*/
@property(nonatomic,strong) UIButton *motto;//座右铭
@property(nonatomic,strong) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *achieveTitle;/**宣言标题*/
@property (strong, nonatomic) UILabel *achieve;/**竞选宣言*/
@property (strong, nonatomic) UILabel *introduceTitle;/**宣言标题*/
@property (strong, nonatomic) UILabel *introduce;/**竞选宣言*/
@property (strong, nonatomic) UILabel *managerTitle;/**宣言标题*/
@property (strong, nonatomic) UILabel *managerView;/**竞选宣言*/
@end

@implementation CandidateView
- (instancetype)initCandidateViewWithModel:(CandidateModel *)model {
    if (self = [super init]) {
        [self initViewWithModel:model];
    }
    return self;
}

+ (instancetype)candidateView {
    return [[CandidateView alloc] initCandidateViewWithModel:nil];
}

- (void)initViewWithModel:(CandidateModel *)model
{
    self.backgroundColor = HexRGB(0x0c1634);
    //缓存渲染，保证帧数
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    //背景
    self.cover = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star_cover"]];
    [self addSubview:self.cover];
    
    //头像
    self.portrait = [UIButton buttonWithType:UIButtonTypeCustom];
    self.portrait.userInteractionEnabled = NO;
    self.portrait.imageView.contentMode = UIViewContentModeScaleAspectFill;
    _portrait.layer.masksToBounds = YES;
    _portrait.layer.cornerRadius =  40;
    [self addSubview:self.portrait];
    
    self.circle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"work_start_detail_icon"]];
    [self addSubview:self.circle];
    
    //姓名
    self.name = [[UILabel alloc] init];
    self.name.font = [UIFont boldSystemFontOfSize:20];
    self.name.textColor = [UIColor whiteColor];
    [self addSubview:self.name];

    //部门
    self.department = [[UILabel alloc] init];
    self.department.font = [UIFont systemFontOfSize:18];
    self.department.textColor = [UIColor whiteColor];
    [self addSubview:self.department];
    
    self.motto = [UIButton buttonWithType:UIButtonTypeCustom];
    self.motto.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.motto.titleLabel.font = [UIFont systemFontOfSize:17];
    self.motto.titleLabel.numberOfLines = 0;
    self.motto.userInteractionEnabled = NO;
    [self.motto setTitleColor:HexRGB(0x2a8fff) forState:UIControlStateNormal];
    [self.motto setBackgroundImage:[UIImage imageNamed:@"motto"] forState:UIControlStateNormal];
    [self addSubview:self.motto];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.scrollView];
    
    //竞选宣言标题
    self.achieveTitle = [[UILabel alloc] init];
    self.achieveTitle.font = [UIFont boldSystemFontOfSize:18];
    self.achieveTitle.textColor = HexRGB(0xf6ce11);
    [self.scrollView addSubview:self.achieveTitle];
    
    //竞选宣言
    self.achieve = [[UILabel alloc] init];
    self.achieve.numberOfLines = 0;
    self.achieve.textColor = HexRGB(0x2c8fff);
    self.achieve.font = [UIFont systemFontOfSize:17];
    [self.scrollView addSubview:self.achieve];

    //竞选宣言标题
    self.introduceTitle = [[UILabel alloc] init];
    self.introduceTitle.font = [UIFont boldSystemFontOfSize:18];
    self.introduceTitle.textColor = HexRGB(0xf6ce11);
    [self.scrollView addSubview:self.introduceTitle];
    
    //竞选宣言
    self.introduce = [[UILabel alloc] init];
    self.introduce.numberOfLines = 0;
    self.introduce.textColor = HexRGB(0x2c8fff);
    self.introduce.font = [UIFont systemFontOfSize:17];
    [self.scrollView addSubview:self.introduce];

    //竞选宣言标题
    self.managerTitle = [[UILabel alloc] init];
    self.managerTitle.font = [UIFont boldSystemFontOfSize:18];
    self.managerTitle.textColor = HexRGB(0xf6ce11);
    [self.scrollView addSubview:self.managerTitle];
    
    //竞选宣言
    self.managerView = [[UILabel alloc] init];
    self.managerView.numberOfLines = 0;
    self.managerView.textColor = HexRGB(0x2c8fff);
    self.managerView.font = [UIFont systemFontOfSize:17];
    [self.scrollView addSubview:self.managerView];
}

- (void)layoutSubviews
{
    __weak typeof(self)wSelf = self;
    [self.portrait mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wSelf);
        make.top.equalTo(wSelf).offset(SafeAreaTopHeight + 20);
        make.height.width.mas_equalTo(80);
    }];
    
    [self.circle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(wSelf.portrait);
        make.width.mas_equalTo(100);
        make.height.equalTo(wSelf.circle.mas_width);
    }];
    
    //姓名
    [self.name mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wSelf.portrait);
        make.top.equalTo(wSelf.circle.mas_bottom).offset(15);
    }];
    
    //部门
    [self.department mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wSelf.portrait);
        make.top.equalTo(wSelf.name.mas_bottom).offset(10);
    }];
    
    CGFloat mottoH = [self.motto.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(mIPHONE_W - 80, MAXFLOAT)].height + 30;
    [self.motto mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wSelf.portrait);
        make.left.equalTo(wSelf).offset(40);
        make.top.equalTo(wSelf.department.mas_bottom).offset(5);
        make.height.mas_equalTo(mottoH);
    }];
    
    CGFloat coverH;
    if (self.department.text.length) {
        coverH = 200 + mottoH;
    }else{
        coverH = 170 + mottoH;
    }
    [self.cover mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.equalTo(wSelf);
        make.bottom.equalTo(wSelf.motto);
        make.height.mas_equalTo(coverH);
    }];
    
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.motto.mas_bottom);
        make.left.right.bottom.equalTo(wSelf);
    }];
    
    [self.achieveTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.scrollView).offset(25);
        make.centerX.equalTo(wSelf.scrollView);
    }];
    
    CGFloat achieveH = [self.achieve.text sizeWithFont:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(mIPHONE_W - 108, MAXFLOAT)].height + 10;
    [self.achieve mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.achieveTitle.mas_bottom).offset(20);
        make.left.equalTo(wSelf).offset(63);
        make.right.equalTo(wSelf).offset(-45);
        make.height.mas_equalTo(achieveH);
    }];

    [self.introduceTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.achieve.mas_bottom).offset(20);
        make.centerX.equalTo(wSelf.scrollView);
    }];
    
    CGFloat introduceH = [self.introduce.text sizeWithFont:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(mIPHONE_W - 108, MAXFLOAT)].height + 10;
    [self.introduce mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.introduceTitle.mas_bottom).offset(20);
        make.left.right.equalTo(wSelf.achieve);
        make.height.mas_equalTo(introduceH);
    }];
    
    [self.managerTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.introduce.mas_bottom).offset(20);
        make.centerX.equalTo(wSelf.scrollView);
    }];
    
    CGFloat managerH = [self.managerView.text sizeWithFont:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(mIPHONE_W - 108, MAXFLOAT)].height + 10;
    [self.managerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.managerTitle.mas_bottom).offset(20);
        make.left.right.equalTo(wSelf.achieve);
        make.height.mas_equalTo(managerH);
    }];
    
    [super layoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(mIPHONE_W, 180 + achieveH + introduceH + managerH + 100);

}

- (void)setModel:(CandidateModel *)model
{
    _model = model;

    [self.portrait setSmartHeadImageWithvID:model.vid WithcId:model.cidNo];
    self.name.text = model.cname;
    if (model.cdName.length) {
        self.department.text = [NSString stringWithFormat:@"%@ / %@", model.cdName, model.cpName];
        self.achieveTitle.text = @"个人成就";
        self.introduceTitle.text = @"个人自评";
    }else{
        self.achieveTitle.text = @"团队成就";
        self.introduceTitle.text = @"团队自评";
    }
    [self.motto setTitle:[NSString stringWithFormat:@"座右铭 : %@", model.wisdom] forState:UIControlStateNormal];

    self.achieve.text = model.achieves;
    self.introduce.text = model.introduce;
    self.managerView.text = model.manaviews;
    self.managerTitle.text = @"经理意见";

}
@end

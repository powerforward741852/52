//
//  VoteDetailsView.m
//  smartoa
//
//  Created by 熊霖 on 16/1/6.
//  Copyright © 2016年 xmsmart. All rights reserved.
//

#import "VoteDetailsView.h"
#import "PrizeModel.h"
#import "VoteDetailsCollectionViewCell.h"
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

#define COLOR_LABEL_YELLOW HexRGB(0xFFD92F)

#define SafeAreaTopHeight  ( mIPHONE_H == 812.0 || mIPHONE_H == 896 ? 88 : 64)

@interface VoteDetailsView () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) UIButton *portrait;/**头像*/
@property(nonatomic,strong) UIImageView *circle;/**头像后面的圈圈*/
@property (weak, nonatomic) UILabel *name;/**姓名*/
@property (weak, nonatomic) UILabel *collTitle;/**标题文字*/
@property (weak,nonatomic) UICollectionView * voteCollection;/*!投票人*/

@property (nonatomic,strong) NSMutableArray * collArr;/*!投票人Arr*/

@end

@implementation VoteDetailsView

- (instancetype)initVotedateViewWithModel:(PrizeModel *)model {
    if (self = [super init]) {
        [self initViewWithModel:model];
    }
    return self;
}

+ (instancetype)voteDetailsView {
    return [[VoteDetailsView alloc] initVotedateViewWithModel:nil];
}

- (void)initViewWithModel:(PrizeModel *)model
{
    //背景
    UIImageView * bgV = [[UIImageView alloc]init];
    bgV.image = [UIImage imageNamed:@"CandidateViewBg"];
    bgV.userInteractionEnabled = NO;
    [self addSubview:bgV];
    
    __weak typeof(self)wSelf = self;
    [bgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf).offset(0);
        make.left.equalTo(wSelf).offset(0);
        make.right.equalTo(wSelf).offset(0);
        make.bottom.equalTo(wSelf).offset(0);
    }];
    
    
    //头像
    self.portrait = [UIButton buttonWithType:UIButtonTypeCustom];
    self.portrait.userInteractionEnabled = NO;
    _portrait.layer.cornerRadius =  30;
    _portrait.layer.masksToBounds = YES;
    [self addSubview:self.portrait];
    
    self.circle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"work_start_detail_icon"]];
    [self addSubview:self.circle];
    
    //姓名
    UILabel * name = [[UILabel alloc] init];
    name.font = [UIFont boldSystemFontOfSize:15];
    name.textColor = [UIColor whiteColor];
    self.name = name;
    [self addSubview:name];
    
    
    //coll标题
    UILabel *collTitle = [[UILabel alloc] init];
//    collTitle.font = [UIFont boldSystemFontOfSize:20];
    collTitle.textColor = COLOR_LABEL_YELLOW;
    collTitle.font = [UIFont fontWithName:@"Verdana-Bold" size:15];
    collTitle.text = @"参与投票人员";
    self.collTitle = collTitle;
    [self addSubview:collTitle];
    
    
    //背景2
    UIImageView * collBgV = [[UIImageView alloc]init];
    collBgV.image = [UIImage imageNamed:@"voteDetailsViewBg"];
    collBgV.userInteractionEnabled = NO;
    [self addSubview:collBgV];
    
    [collBgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.circle.mas_bottom).offset(10);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-34);
    }];
    
    //创建布局
    UICollectionViewFlowLayout * mylayout = [[UICollectionViewFlowLayout alloc]init];
    
    //设置cell的尺寸
    [mylayout setItemSize:CGSizeMake((mIPHONE_W-100)/3, 30)];
    
    [mylayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向

    //设置间距
    mylayout.minimumLineSpacing = 0;
    mylayout.minimumInteritemSpacing = 0;
    mylayout.sectionInset = UIEdgeInsetsMake(0,0, 0, 0);//设置其边界
    
    UICollectionView * collView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0 ,mIPHONE_H-90, collBgV.frame.size.height) collectionViewLayout:mylayout];
//    UICollectionView * collView = [[UICollectionView alloc]init];
//    collView.collectionViewLayout = mylayout;
    
    collView.alwaysBounceVertical =YES;
    collView.scrollEnabled = YES;

    
    //添加代理
    collView.delegate = self;
    collView.dataSource = self;
    //注册单元格
    [collView registerClass:[VoteDetailsCollectionViewCell class] forCellWithReuseIdentifier:@"colCell"];
    //
    collView.backgroundColor = [UIColor clearColor];
    self.voteCollection = collView;
    [self addSubview:collView];
    
    [collView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(collBgV);
        make.top.equalTo(collBgV).offset(20);
        make.bottom.equalTo(collBgV).offset(-20);
    }];
}

//九宫格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _collArr.count;
}

//布置套餐数据九宫格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    VoteDetailsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"colCell" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        if (view) {
            [view removeFromSuperview];
        }
    }
    
    //获取cell内容model
    PrizeModel * detailMode = [[PrizeModel alloc]init];
    detailMode = self.collArr[indexPath.row];

    
    cell.voteName = detailMode.sname;

    [cell addTheCell];

    return cell;
}


- (void)layoutSubviews
{
    __weak typeof(self)wSelf = self;
    
    
    //头像
    
    
//    [self.circle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(wSelf).offset([SmartTool heightForImageHeight:81]);
//        make.left.equalTo(wSelf).offset([SmartTool widthForImageWidth:71]);
//        make.width.height.mas_equalTo([SmartTool widthForImageWidth:288]);
//
//    }];
    [self.portrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf).offset(SafeAreaTopHeight + 20);
        make.left.equalTo(wSelf).offset(15);
        make.width.mas_equalTo(60);
        make.height.equalTo(wSelf.portrait.mas_width);
    }];
    
    [self.circle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(wSelf.portrait);
        make.width.mas_equalTo(80);
        make.height.equalTo(wSelf.circle.mas_width);
    }];
    
    //名字
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf).offset(SafeAreaTopHeight + 25);
        make.left.equalTo(wSelf.circle.mas_right).offset(15);
    }];
    
    //coll标题
    [self.collTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.name.mas_bottom).offset(15);
        make.left.equalTo(wSelf.name);
    }];
 
    [super layoutSubviews];
    
}


- (void)setModel:(PrizeModel *)model
{
    _model = model;
    

    
    [self.portrait setSmartHeadImageWithvID:model.vid WithcId:model.cidNo];
    self.name.text = _model.cname;
    _collArr = [NSMutableArray arrayWithArray:model.list];

    [self.voteCollection reloadSections:[NSIndexSet indexSetWithIndex:0]];

}


- (NSArray *)collArr
{
    if (_collArr == nil) {
        _collArr = [NSMutableArray array];
    }
    return _collArr;
}

@end

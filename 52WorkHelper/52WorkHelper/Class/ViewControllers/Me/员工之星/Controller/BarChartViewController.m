//
//  BarChartViewController.m
//  smartoa
//
//  Created by 陈昱珍 on 15/12/25.
//  Copyright © 2015年 xmsmart. All rights reserved.
//

#import "BarChartViewController.h"
#import "myBarChart.h"
#import "StarViewModel.h"
#import "PrizeModel.h"

#import "ChartTableViewCell.h"
#import "StarHomeViewController.h"
#import "CandidateViewController.h"
#import "CandidateModel.h"
#import "VoteDetailsViewController.h"


#import "SVProgressHUD.h"
#import "Masonry.h"
#import "UIButton+actionBlock.h"
#import "NSString+LXLGetCGSize.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//屏幕尺寸
#define mIPHONE_W ([UIScreen mainScreen].bounds.size.width)
#define mIPHONE_H ([UIScreen mainScreen].bounds.size.height)
#define RGB(r, g, b)             [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define mIMAGE_W 1248.00
#define FONTTITLE 22
#define FONTSIZE 12
#define COLOR_LABEL_YELLOW HexRGB(0xFFD92F)

#define SafeAreaTopHeight  ( mIPHONE_H == 812.0 || mIPHONE_H == 896 ? 88 : 64)

@interface BarChartViewController () <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) StarViewModel *viewModel;
@property (nonatomic,strong) NSMutableArray * priArr;/*!奖项*/

@property (nonatomic,strong) UITableView * priTableView;
@property(nonatomic,weak) UILabel *labelShow;/**跑马灯*/

@end

@implementation BarChartViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self initMarquee];//初始化跑马灯
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.labelShow removeFromSuperview];//移除跑马灯
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"投票详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    __weak typeof(self)wSelf = self;
    
    //背景图片
    UIImageView * starView = [[UIImageView alloc]init];
    starView.image = [UIImage imageNamed:@"barCharViewBg"];
    starView.userInteractionEnabled = NO;
    [self.view addSubview:starView];
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.view).offset(SafeAreaTopHeight);
        make.left.equalTo(wSelf.view).offset(0);
        make.right.equalTo(wSelf.view).offset(0);
        make.bottom.equalTo(wSelf.view).offset(0);
    }];
    

    [self initViewModel];
    [self initView];
    
    
}

- (void)initMarquee
{
    UILabel *labelShow = [[UILabel alloc] init];
    self.labelShow = labelShow;
    [self.view addSubview:labelShow];
    
    NSString * showStr = @"温馨提示：点击可以查看个人信息和个人投票结果";
    labelShow.font = [UIFont systemFontOfSize:16];
    labelShow.text = showStr;
    CGSize size = [labelShow.text sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    labelShow.frame = CGRectMake(20, SafeAreaTopHeight, size.width, 30);
    labelShow.textColor = HexRGB(0x44a5ff);
    labelShow.backgroundColor = [UIColor clearColor];
    
    CGRect frame = labelShow.frame;
    frame.origin.x = mIPHONE_W;
    labelShow.frame = frame;
    
    [UIView beginAnimations:@"testAnimation" context:NULL];
    [UIView setAnimationDuration:8.0f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:999999];
    
    frame = labelShow.frame;
    frame.origin.x = -frame.size.width;
    labelShow.frame = frame;
    [UIView commitAnimations];
}

- (void)initViewModel
{
    __weak typeof(self)weakSelf = self;
    self.viewModel = [[StarViewModel alloc] init];
    [self.viewModel getVoteDetailsWithruleId:self.ruleId];
    self.viewModel.voteDetailBlack = ^(NSString * msg,NSArray * data){
         [weakSelf.priTableView.mj_header endRefreshing];
        if ([msg isEqualToString:@"1"]) {
            weakSelf.priArr = [NSMutableArray arrayWithArray:data];
            PrizeModel * pModel = [[PrizeModel alloc]init];
            pModel = [PrizeModel mj_objectWithKeyValues:self.priArr[0]];
            [weakSelf.priTableView reloadData];
        }else{
            
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
    };
}

- (void)initView
{
    
    
    
    UITableView * priTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30 + SafeAreaTopHeight, mIPHONE_W, mIPHONE_H- SafeAreaTopHeight -30) style:UITableViewStyleGrouped];
    priTableView.delegate = self;
    priTableView.dataSource = self;
    priTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    priTableView.backgroundColor = [UIColor clearColor];
    [priTableView.mj_header setRefreshingTarget:self refreshingAction:@selector(arrangementHeaderRereshing)];
     self.priTableView = priTableView;
    [self.view addSubview:priTableView];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return self.priArr.count;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    PrizeModel * pModel = [PrizeModel mj_objectWithKeyValues:self.priArr[section]];
    return pModel.priName;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    PrizeModel * pModel = [PrizeModel mj_objectWithKeyValues:self.priArr[section]];
    UIView * titleV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mIMAGE_W, 44)];
    titleV.backgroundColor = [UIColor clearColor];
    UILabel * titleL = [[UILabel alloc]init];
    titleL.text = pModel.priName;
    titleL.textColor = COLOR_LABEL_YELLOW;
    titleL.backgroundColor = [UIColor clearColor];
    titleL.font = [UIFont systemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    [titleV addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(titleV);
    }];
    
    return titleV;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PrizeModel * pModel = [PrizeModel mj_objectWithKeyValues:self.priArr[indexPath.section]];
    
    CGFloat heiht = pModel.list.count*(50)+FONTSIZE*2;
    
    
    return heiht;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    NSString *CellIdentifier = @"barCell";
    
    ChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[ChartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.backgroundColor = [UIColor clearColor];
    PrizeModel * pModel = [PrizeModel mj_objectWithKeyValues:self.priArr[indexPath.section]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.priModel = pModel;
    cell.index = indexPath;
    cell.barCharBlock = ^(NSIndexPath *choose,NSInteger select){
        
      PrizeModel * pModel = [PrizeModel mj_objectWithKeyValues:self.priArr[indexPath.section]];
        NSArray * canArr = pModel.list;
        CandidateModel * canModel = [CandidateModel mj_objectWithKeyValues:canArr[select]];
        CandidateViewController *candidateVC = [[CandidateViewController alloc] init];
        candidateVC.model = canModel;
        [self.navigationController pushViewController:candidateVC animated:YES];
        [SVProgressHUD showInfoWithStatus:@"加载中..."];

    };
    cell.barCharttoViewBlock = ^(NSIndexPath *choose,NSInteger select){
        
        PrizeModel * pModel = [PrizeModel mj_objectWithKeyValues:self.priArr[indexPath.section]];
        NSArray * canArr = pModel.list;
        PrizeModel * vModel = [PrizeModel mj_objectWithKeyValues:canArr[select]];
        VoteDetailsViewController *voteVC = [[VoteDetailsViewController alloc] init];
        voteVC.model = vModel;
        [self.navigationController pushViewController:voteVC animated:YES];
        [SVProgressHUD showInfoWithStatus:@"加载中..."];
        
    };
    
    return cell;
}

- (void)arrangementHeaderRereshing
{
    [self.viewModel getVoteDetailsWithruleId:self.ruleId];
}


/*
 * - 懒加载
 */
-(NSMutableArray *)priArr{
    if (!_priArr) {
        _priArr = [[NSMutableArray alloc]init];
        
    }
    return _priArr;
}

@end

//
//  StarViewController.m
//  smartoa
//
//  Created by 陈昱珍 on 15/12/17.
//  Copyright © 2015年 xmsmart. All rights reserved.
//

#import "StarViewController.h"

#import "VoteViewController.h"
#import "StarViewModel.h"
#import "StarModel.h"
#import "BarChartViewController.h"
#import "SVProgressHUD.h"
#import "Masonry.h"
#import "UIButton+actionBlock.h"
#import "NSString+LXLGetCGSize.h"
#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define COLOR_LABEL_DBULE HexRGB(0x82C5FF)
#define COLOR_LABEL_YELLOW HexRGB(0xFFD92F)
//屏幕尺寸
#define mIPHONE_W ([UIScreen mainScreen].bounds.size.width)
#define mIPHONE_H ([UIScreen mainScreen].bounds.size.height)
#define SafeAreaTopHeight  ( mIPHONE_H == 812.0 || mIPHONE_H == 896 ? 88 : 64)

@interface StarViewController (){
    
    NSMutableArray *_data1;
    NSInteger _currentData1Index;
    
}
@property(nonatomic,strong) StarViewModel *viewModel;
@property(nonatomic,strong) StarModel *model;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UILabel *ruleTitle;
@property(nonatomic,strong) UILabel *rule;
@property(nonatomic,strong) UIButton *voteBtn;
@property(nonatomic,strong) UILabel *flowTitle;
@property(nonatomic,strong) UILabel *flow;
@end

@implementation StarViewController
- (void)viewDidLoad {

    [super viewDidLoad];
    self.title = @"员工之星";
    __weak typeof(self)wSelf = self;
    //背景图片
    UIImageView * starView = [[UIImageView alloc]init];
    starView.image = [UIImage imageNamed:@"CandidateViewBg"];
    starView.userInteractionEnabled = NO;
    [self.view addSubview:starView];
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.view).offset(SafeAreaTopHeight);
        make.left.equalTo(wSelf.view).offset(0);
        make.right.equalTo(wSelf.view).offset(0);
        make.bottom.equalTo(wSelf.view).offset(0);
    }];
    
    //统一设置返回按钮没有文字
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mIPHONE_W, mIPHONE_H )];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.contentSize = CGSizeMake(mIPHONE_W, mIPHONE_H );
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.scrollEnabled = YES;

    [self.view addSubview:self.scrollView];

}

- (void)initViewWithifVote:(StarModel *)starModel;
{
    self.model = starModel;
    
    __weak typeof(self)wSelf = self;
    //参与投票按钮
    self.voteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([starModel.ifVote isEqualToString:@"1"]) {
        [self.voteBtn setTitle:@"查看结果" forState:UIControlStateNormal];
    }else{
        [self.voteBtn setTitle:@"参与投票" forState:UIControlStateNormal];
    }
    [self.voteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.voteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    self.voteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.voteBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [self.voteBtn setBackgroundImage:[UIImage imageNamed:@"icon_go_work_star"] forState:UIControlStateNormal];
    [self.voteBtn addAcionBlock:^{
        if ([wSelf.voteBtn.titleLabel.text isEqualToString:@"参与投票"]) {
            if ([starModel.ifNotice isEqualToString:@"1"]) {
                //跳转投票界面
                VoteViewController *voteVC = [[VoteViewController alloc] init];
                voteVC.model = wSelf.model;//传参数
                [wSelf.navigationController pushViewController:voteVC animated:YES];
                [SVProgressHUD showInfoWithStatus:@"加载中..."];
            }else{
                [SVProgressHUD showErrorWithStatus:@"暂未公示"];
            }
        }else{
            //跳转结果柱状图
            BarChartViewController *barVC = [[BarChartViewController alloc] init];
            barVC.ruleId = starModel.rid;
            [wSelf.navigationController pushViewController:barVC animated:YES];
        }
    }];
    [self.view addSubview:self.voteBtn];
    [self.voteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wSelf.view);
        make.bottom.equalTo(wSelf.view).offset(-64);
        make.size.mas_equalTo(CGSizeMake(110,40));
    }];
    
    //活动规则标题
    self.ruleTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, SafeAreaTopHeight + 10, mIPHONE_W - 30, 30)];
    self.ruleTitle.font = [UIFont boldSystemFontOfSize:18];
    self.ruleTitle.textColor = COLOR_LABEL_YELLOW;
    self.ruleTitle.text = @"活动规则 : ";
    [self.scrollView addSubview:self.ruleTitle];

    
    //活动规则详细
     CGFloat ruleH = [starModel.rules sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(mIPHONE_W - 30, MAXFLOAT)].height;
    
    self.rule = [[UILabel alloc] initWithFrame:CGRectMake(15, self.ruleTitle.frame.origin.y + self.ruleTitle.frame.size.height + 10, mIPHONE_W - 30, ruleH)];
    self.rule.numberOfLines = 0;
    self.rule.textColor = COLOR_LABEL_DBULE;
    self.rule.backgroundColor = [UIColor clearColor];
    self.rule.font = [UIFont systemFontOfSize:13];
    self.rule.text = starModel.rules;
    [self.scrollView addSubview:self.rule];
    

    //活动流程标题
    self.flowTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, self.rule.frame.origin.y + self.rule.frame.size.height + 20, mIPHONE_W - 30, 30)];
    self.flowTitle.font = [UIFont boldSystemFontOfSize:18];
    self.flowTitle.textColor = COLOR_LABEL_YELLOW;
    self.flowTitle.text = @"活动流程 : ";
    [self.scrollView addSubview:self.flowTitle];
    
    //活动流程详细
    CGFloat flowH = [starModel.flow sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(mIPHONE_W - 30, MAXFLOAT)].height;
    self.flow = [[UILabel alloc] initWithFrame:CGRectMake(15, self.flowTitle.frame.origin.y + self.flowTitle.frame.size.height + 10, mIPHONE_W - 30, flowH)];
    self.flow.numberOfLines = 0;
    self.flow.textColor = COLOR_LABEL_DBULE;
    self.flow.backgroundColor = [UIColor clearColor];
    self.flow.font = [UIFont systemFontOfSize:13];
    self.flow.text = starModel.flow;
    [self.scrollView addSubview:self.flow];

}

- (void)initViewModel
{
    self.viewModel = [[StarViewModel alloc] init];
    __weak typeof(self)wSelf = self;
    self.viewModel.starBlock = ^(NSString *msg,StarModel *model){
        wSelf.model = model;
        wSelf.rule.text = model.rules;
        
    [wSelf.voteBtn setTitle:@"查看结果" forState:UIControlStateNormal];

    };
}

-(void)viewDidAppear:(BOOL)animated
{

//    self.scrollView.contentSize = CGSizeMake(0, self.flow.frame.origin.y+self.flow.frame.size.height+25);
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([self.voteSuccess isEqualToString:@"1"]) {
        [self.voteBtn setTitle:@"查看结果" forState:UIControlStateNormal];
    }
}


@end

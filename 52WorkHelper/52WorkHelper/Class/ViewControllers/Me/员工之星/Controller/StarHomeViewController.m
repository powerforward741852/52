//
//  StarHomeViewController.m
//  smartoa
//
//  Created by 熊霖 on 15/12/29.
//  Copyright © 2015年 xmsmart. All rights reserved.
//

#import "StarHomeViewController.h"
#import "VoteViewController.h"
#import "StarViewModel.h"
#import "StarModel.h"
#import "BarChartViewController.h"
#import "StarViewController.h"
#import "BarChartViewController.h"
#import "UIImageView+WebCache.h"
#import "UIButton+actionBlock.h"
#import "SVProgressHUD.h"
#import "Masonry.h"

#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define COLOR_LABEL_DBULE HexRGB(0x82C5FF)
#define COLOR_LABEL_YELLOW HexRGB(0xFFD92F)
#define mIPHONE_H ([UIScreen mainScreen].bounds.size.height)
//userdefault
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
#define SafeAreaTopHeight  ( mIPHONE_H == 812.0 || mIPHONE_H == 896 ? 88 : 64)

@interface StarHomeViewController ()

@property(nonatomic,strong) StarViewModel *viewModel;
@property(nonatomic,strong) StarModel *model;
@property(nonatomic,strong) UITextView *stateText;/*!说明文字*/
@property(nonatomic,strong) UIButton *voteBtn;/*!投票按钮*/
@property(nonatomic,strong) UIButton *detailsBtn;/*!查看详情*/
@property(nonatomic,strong) UIImageView * starView;/*!背景图片*/

@end

@implementation StarHomeViewController
    


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"员工之星";
    
    [self initView];
//    [self initViewModel];
    
}

- (void)initView
{
     __weak typeof(self)wSelf = self;
    
    //背景图片 startViewBg
    self.starView = [[UIImageView alloc]init];
//    [self.starView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@activityImg/activity_poster.png",@"http://59.57.246.72:81/smart_hr/"]] placeholderImage:[UIImage imageNamed:@"startViewBg"]];
    
    [self.starView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@activityImg/activity_poster.png",@"http://59.57.246.72:81/smart_hr/"]] placeholderImage:[UIImage imageNamed:@"starBg"] options:SDWebImageAllowInvalidSSLCertificates];
//    SDWebImageOptions
    
    self.starView.userInteractionEnabled = NO;
    [self.view addSubview:self.starView];
    
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.view).offset(SafeAreaTopHeight);
        make.left.equalTo(wSelf.view).offset(0);
        make.right.equalTo(wSelf.view).offset(0);
        make.bottom.equalTo(wSelf.view).offset(0);
    }];
    
    //参与投票按钮
    self.voteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.voteBtn setTitle:@"参与投票" forState:UIControlStateNormal];
    [self.voteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.voteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    self.voteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.voteBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [self.voteBtn setBackgroundImage:[UIImage imageNamed:@"icon_go_work_star"] forState:UIControlStateNormal];
    [self.voteBtn addAcionBlock:^{
    if ([wSelf.voteBtn.titleLabel.text isEqualToString:@"参与投票"]) {
        if ([wSelf.model.ifNotice isEqualToString:@"1"]) {
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
        barVC.ruleId = wSelf.model.rid;
        [wSelf.navigationController pushViewController:barVC animated:YES];
    }
    }];
    [self.view addSubview:self.voteBtn];
    [self.voteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wSelf.view);
        make.bottom.equalTo(wSelf.view).offset(-60);
        make.size.mas_equalTo(CGSizeMake(110,40));
        
    }];
    
    self.detailsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.detailsBtn setTitle:@"查看详情 >>" forState:UIControlStateNormal];
    [self.detailsBtn setTitleColor:COLOR_LABEL_YELLOW forState:UIControlStateNormal];
    self.detailsBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [self.detailsBtn addAcionBlock:^{
        //跳转说明界面
        StarViewController *starVC = [[StarViewController alloc] init];
        [starVC initViewWithifVote:wSelf.model];
        [wSelf.navigationController pushViewController:starVC animated:YES];

    }];
    [self.view addSubview:self.detailsBtn];
    [self.detailsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.voteBtn.mas_right).offset(18.5);
        make.centerY.equalTo(wSelf.voteBtn);
    }];
    
    //活动规则详细
    self.stateText = [[UITextView alloc] init];
    self.stateText.editable = NO;
    self.stateText.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.stateText];
    [self.stateText mas_makeConstraints:^(MASConstraintMaker *make) {
        if (mIPHONE_H == 812.0 || mIPHONE_H == 896){
            make.top.equalTo(wSelf.view).offset(430);
        }else{
            make.top.equalTo(wSelf.view).offset(330);
        }
        make.left.equalTo(wSelf.view).offset(0);
        make.right.equalTo(wSelf.view).offset(0);
        make.bottom.equalTo(wSelf.voteBtn.mas_top).offset(-20);
    }];
    
}

- (void)initViewModel
{
    StarModel *model = [[StarModel alloc] init];
    self.viewModel = [[StarViewModel alloc] init];
    [self.viewModel getRulesWithModel:model];

    __weak typeof(self)wSelf = self;
    [SVProgressHUD showInfoWithStatus:@"加载中"];
    self.viewModel.starBlock = ^(NSString *msg,StarModel *model){
        [SVProgressHUD dismiss];
        wSelf.model = model;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 13;// 字体的行间距
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:16],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        wSelf.stateText.attributedText = [[NSAttributedString alloc] initWithString:model.remarks attributes:attributes];
        wSelf.stateText.textColor = COLOR_LABEL_DBULE;
        wSelf.voteBtn.userInteractionEnabled = YES;
        wSelf.detailsBtn.userInteractionEnabled = YES;

        //当前服务器时间
        NSString * nowStr = [NSString stringWithFormat:@"%ld",[wSelf changeTimeToTimeSp:model.edate]];
        NSDate *enddate = [wSelf zoneChange:nowStr];
        NSDate * nowDate = [wSelf zoneChange:model.curDate];
        
        
        //投票开始时间
        NSString * startStr = [NSString stringWithFormat:@"%ld",[wSelf changeTimeToTimeSp:wSelf.model.sdate]];
        NSDate *startdate = [wSelf zoneChange:startStr];

        
        
        //比较时间是否在可以投票时间内
        if ([nowDate timeIntervalSinceDate:enddate] > 0) {
            [wSelf.voteBtn setTitle:@"查看结果" forState:UIControlStateNormal];
            wSelf.model.ifVote = @"1";
        }
        if ([msg isEqualToString:@"1"]) {
            if ([model.ifVote isEqualToString:@"1"]) {
                [wSelf.voteBtn setTitle:@"查看结果" forState:UIControlStateNormal];
                wSelf.model.ifVote = @"1";
                return ;
            }
        }else if ([msg isEqualToString:@"2"]){
//            [KitMBProgressHUD showError:@"你不是四美达员工，无法参与投票。"];
//            wSelf.detailsBtn.hidden = YES;
            if ([wSelf.model.ifNotice isEqualToString:@"1"]){
            if ([nowDate timeIntervalSinceDate:startdate] > 0.0 ) {
                 [wSelf.voteBtn setTitle:@"查看结果" forState:UIControlStateNormal];
                wSelf.model.ifVote = @"1";
                }
            }
        };
    };
    self.viewModel.returenBlock = ^(NSString * data){
        [SVProgressHUD showInfoWithStatus:data];
        wSelf.voteBtn.userInteractionEnabled = NO;
        wSelf.detailsBtn.userInteractionEnabled = NO;

    };
}

//将yyyy-MM-dd HH:mm:ss格式时间转换成时间戳
-(long)changeTimeToTimeSp:(NSString *)timeStr
{
    long time;
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate=[format dateFromString:timeStr];
    time= (long)[fromdate timeIntervalSince1970];
    return time;
}

//将时间戳转换成NSDate,加上时区偏移。这个转换之后是北京时间
-(NSDate*)zoneChange:(NSString*)spString
{
    if (spString.length == 13) {
        spString = [spString substringToIndex:[spString length] - 3];
    }
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[spString intValue]];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:confromTimesp];
    NSDate *localeDate = [confromTimesp  dateByAddingTimeInterval: interval];
    
    return localeDate;
}
    
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //统一设置返回按钮没有文字
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    self.hidesBottomBarWhenPushed = true;
    
    [self initViewModel];
}
-(void)viewWillDisappear:(BOOL)animated
    {
        [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
        
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

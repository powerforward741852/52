//
//  VoteViewController.m
//  smartoa
//
//  Created by 陈昱珍 on 15/12/18.
//  Copyright © 2015年 xmsmart. All rights reserved.
//

#import "VoteViewController.h"

#import "StarModel.h"
#import "CandidateViewController.h"
#import "StarViewModel.h"
#import "PrizeModel.h"
#import "CandidateModel.h"
#import "BarChartViewController.h"
#import "CandidateTableViewCell.h"

#import "ConfirmVoteViewController.h"

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

@interface VoteViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) StarViewModel *viewModel;
@property(nonatomic,strong) UITableView * candidatesTableView;/*!候选人列表*/
@property(nonatomic,strong) UIButton *submitBtn;/**确认提交按钮*/
@property(nonatomic,copy) NSArray *collectionArray;
@property(nonatomic,copy) NSArray *prizeArray;
@property(nonatomic,copy) NSMutableArray *candidatesID;/**接口上传所有候选人ID*/
@property(nonatomic,weak) UILabel *labelShow;/**跑马灯*/
@end

@implementation VoteViewController
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
    self.title = @"员工之星";

    [self initView];
    [self initViewModel];
}

- (void)initView
{
    UIImageView * bgV = [[UIImageView alloc]init];
    bgV.image = [UIImage imageNamed:@"CandidateViewBg"];
    bgV.userInteractionEnabled = NO;
    [self.view addSubview:bgV];

    [bgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //统一设置返回按钮没有文字
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    self.candidatesTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, SafeAreaTopHeight + 30, mIPHONE_W-40, mIPHONE_H - 64) style:UITableViewStyleGrouped];
    self.candidatesTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.candidatesTableView.delegate = self;
    self.candidatesTableView.dataSource = self;
    UIView  * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mIPHONE_W, 400)];
    footerView.backgroundColor = [UIColor clearColor];
    self.candidatesTableView.tableFooterView = footerView;
    self.candidatesTableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.candidatesTableView];
    
    
    __weak typeof(self)wSelf = self;
    //提交按钮
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitBtn setImage:[UIImage imageNamed:@"voteBtn"] forState:UIControlStateNormal];
    [self.submitBtn addAcionBlock:^{
        //提交投票结果
        int j = 0;
        NSString *name;
        for (PrizeModel *prize in wSelf.prizeArray) {
            if(prize.selectedNum != 0){
                j++;
                if (j == 1) {
                    name = prize.priName;
                }
            }
        }
        if (j == 0) {
            [SVProgressHUD showErrorWithStatus:@"您未给任何人投票"];
        }else{

            //跳转确认投票界面
            ConfirmVoteViewController *conVC = [[ConfirmVoteViewController alloc] init];
            conVC.ruleId = wSelf.model.rid;
            conVC.confirmArr = wSelf.candidatesID;
            conVC.prizeArray = wSelf.prizeArray;
            [wSelf.navigationController pushViewController:conVC animated:YES];

        }

    }];
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wSelf.view);
        make.bottom.equalTo(wSelf.view).offset(-49);
        make.size.mas_equalTo(CGSizeMake(110,40));
    }];
    
   
    
}

- (void)initMarquee
{
    UILabel *labelShow = [[UILabel alloc] init];
    self.labelShow = labelShow;
    [self.view addSubview:labelShow];

    NSString * startStr =  [self.model.sdate substringWithRange:NSMakeRange(0, [self.model.sdate length] - 6)];
    NSString * endStr =  [self.model.edate substringWithRange:NSMakeRange(0, [self.model.edate length] - 6)];
    
    NSString * showStr = [NSString stringWithFormat:@"投票开始时间从%@时 到 %@时",startStr,endStr];
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
    self.viewModel = [[StarViewModel alloc] init];
    [self.viewModel getCandidatesWithModel:self.model];
    __weak typeof(self)wSelf = self;
    self.viewModel.starBlock = ^(NSString *msg,StarModel *model){
        //判断时间
        wSelf.prizeArray = [PrizeModel mj_objectArrayWithKeyValuesArray:model.list];
        NSMutableArray *allCandidatesArray = [NSMutableArray array];
        for (PrizeModel *prize in wSelf.prizeArray) {
            prize.selectedNum = 0;//初始选中人数为0
            NSArray *candidates = [CandidateModel mj_objectArrayWithKeyValuesArray:prize.pvList];
            [allCandidatesArray addObject:candidates];
        }
        wSelf.collectionArray = [allCandidatesArray copy];
//        [wSelf.candidatesCV reloadData];
        [wSelf.candidatesTableView reloadData];
        [SVProgressHUD dismiss];
    };
    
    self.viewModel.submitBlock = ^(BOOL isVoted, NSString *reason){
        if (isVoted) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"投票成功"];
            //跳转结果柱状图
            BarChartViewController *barVC = [[BarChartViewController alloc] init];
            barVC.ruleId = wSelf.model.rid;

            [wSelf.navigationController pushViewController:barVC animated:YES];
            NSMutableArray *navigationarray = [NSMutableArray arrayWithArray:wSelf.navigationController.viewControllers];

            [navigationarray removeObjectAtIndex:navigationarray.count -2];
            wSelf.navigationController.viewControllers = navigationarray;

        }else{
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:reason];
        }
    };
    
}

#pragma tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.collectionArray[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return self.prizeArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    PrizeModel *prize = self.prizeArray[section];
    UIView * titleV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mIPHONE_W, 60)];
    titleV.backgroundColor = [UIColor clearColor];
    //奖项名称
    UILabel * titleL = [[UILabel alloc]init];
    titleL.text = prize.priName;
    titleL.textColor = RGB(244, 224, 40);
    titleL.backgroundColor = [UIColor clearColor];
    titleL.font = [UIFont fontWithName:@"Courier-BoldOblique" size:15];
    titleL.textAlignment = NSTextAlignmentCenter;
    [titleV addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleV).offset(5);
        make.left.equalTo(titleV);
    }];
    //文字说明
    UILabel * stateL = [[UILabel alloc]init];
    stateL.text = [NSString stringWithFormat:@"最多可选%d候选人", [prize.scount intValue]];
    stateL.textColor = RGB(244, 224, 40);
    stateL.backgroundColor = [UIColor clearColor];
    stateL.font = [UIFont fontWithName:@"Courier-Oblique" size:13];
    stateL.textAlignment = NSTextAlignmentCenter;
    [titleV addSubview:stateL];
    [stateL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleL.mas_bottom).offset(7);
        make.left.equalTo(titleL);
    }];

    return titleV;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSString *CellIdentifier = [NSString stringWithFormat:@"deCell%d%d", [indexPath section], [indexPath row]];//以indexPath来唯一确定cell

    NSString *CellIdentifier = @"barCell";
    
    CandidateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[CandidateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
 
   
    
    

    

    //投票开始时间
    NSString * startStr = [NSString stringWithFormat:@"%ld",[self changeTimeToTimeSp:self.model.sdate]];
    
    NSDate *startdate = [self zoneChange:startStr];
     //当前服务器时间
    NSDate * nowDate = [self zoneChange:self.model.curDate];
    
   
   

    
    if ([nowDate timeIntervalSinceDate:startdate] < 0.0 ) {
        cell.heart.hidden = YES;
      self.submitBtn.hidden = YES;
    }else{
        cell.heart.hidden = NO;
        self.submitBtn.hidden = NO;
    }

    
    
    CandidateModel *model = self.collectionArray[indexPath.section][indexPath.row];
    cell.model = model;
    cell.index = indexPath;
    cell.model.vid = model.vid;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];

    __weak typeof(cell)wCell = cell;
    __weak typeof(self)wSelf = self;
    cell.voteBlock = ^(NSIndexPath *index){
        PrizeModel *prize = self.prizeArray[index.section];
        CandidateModel *candidate = self.collectionArray[index.section][index.row];
        candidate.apName = prize.priName;
        if (!wCell.heart.isSelected) {
            if (prize.selectedNum == [prize.scount intValue]) {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"该奖最多只能选%d人哦", [prize.scount intValue]]];
                return;
            }
            prize.selectedNum ++;
            [wSelf.candidatesID addObject:candidate];
        }else{
            prize.selectedNum --;
            [wSelf.candidatesID removeObject:candidate];
        }
        if ([wCell.model.vid isEqualToString:candidate.vid]) {
            wCell.heart.selected = !wCell.heart.selected;
        }
        candidate.selected = wCell.heart.selected;

    };
    
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CandidateViewController *candidateVC = [[CandidateViewController alloc] init];
    candidateVC.model = self.collectionArray[indexPath.section][indexPath.row];
    [self.navigationController pushViewController:candidateVC animated:YES];
    [SVProgressHUD showInfoWithStatus:@"加载中..."];
}



//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return  CGSizeMake(mIPHONE_W, 60);
}

#pragma mark - AlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        NSString *str = [self.candidatesID componentsJoinedByString:@","];
        [SVProgressHUD showInfoWithStatus:@"投票提交中"];
        [self.viewModel voteWithString:str Withsname:@"" ruleId:self.model.rid];
    }
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

#pragma mark - 懒加载
- (NSArray *)collectionArray
{
    if (_collectionArray == nil) {
        _collectionArray = [NSArray array];
    }
    return _collectionArray;
}

- (NSArray *)prizeArray
{
    if (_prizeArray == nil) {
        _prizeArray = [NSArray array];
    }
    return _prizeArray;
}

- (NSMutableArray *)candidatesID
{
    if (_candidatesID == nil) {
        _candidatesID = [NSMutableArray array];
    }
    return _candidatesID;
}
@end

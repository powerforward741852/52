//
//  ConfirmVoteViewController.m
//  smartoa
//
//  Created by 熊霖 on 16/1/8.
//  Copyright © 2016年 xmsmart. All rights reserved.
//

#import "ConfirmVoteViewController.h"
#import "StarViewModel.h"
#import "ConfirmCollectionViewCell.h"
#import "CandidateModel.h"
#import "StarViewController.h"
#import "BarChartViewController.h"
#import "PrizeModel.h"
#define COLOR_LABEL_BULE HexRGB(0x50C8FF)
#define COLOR_LABEL_YELLOW HexRGB(0xFFD92F)
#define FONTSIZE 17

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

@interface ConfirmVoteViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong) StarViewModel *viewModel;

@property (strong, nonatomic) UIButton *anonymous;/**匿名提交*/
@property (strong, nonatomic) UIButton *autonym;/**实名提交*/
@property (strong, nonatomic) UIButton *again;/**重新选择*/
@property (strong, nonatomic) UILabel *warning;/**警告文字说明*/

@property (strong,nonatomic) NSMutableArray * apNameArr;
@property (weak,nonatomic) UICollectionView * confirmCollection;/*!确认投票collection*/
@end

@implementation ConfirmVoteViewController



- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"投票预览";
    
    [self initView];
    [self initViewModel];
    
}


-(void)initView
{
    __weak typeof(self)wSelf = self;
    for (PrizeModel *pModel in self.prizeArray)
    {
        
        NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
        for (CandidateModel * cMdeol in self.confirmArr)
        {

                if ([cMdeol.apName isEqualToString:pModel.priName]) {
                    [tempArr addObject:cMdeol];
                }
        }
        if (tempArr.count > 0) {
            [self.apNameArr addObject:tempArr];
        }
    }
    
    UIImageView * bgV = [[UIImageView alloc]init];
    bgV.image = [UIImage imageNamed:@"CandidateViewBg"];
    bgV.userInteractionEnabled = NO;
    [self.view addSubview:bgV];
    
    [bgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    //创建布局
    UICollectionViewFlowLayout * mylayout = [[UICollectionViewFlowLayout alloc]init];
    
    //设置cell的尺寸
    [mylayout setItemSize:CGSizeMake((mIPHONE_W-20 - 30)/2, 80)];
    
    [mylayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
    
    //设置间距
    mylayout.minimumLineSpacing = 30;
    mylayout.minimumInteritemSpacing = 10;
    mylayout.sectionInset = UIEdgeInsetsMake(0,0, 0, 0);//设置其边界
    
    UICollectionView * collView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0 ,mIPHONE_W, mIPHONE_H/4 * 3 + 80 ) collectionViewLayout:mylayout];

    collView.alwaysBounceVertical =YES;
    collView.scrollEnabled = YES;
    
    
    //添加代理
    collView.delegate = self;
    collView.dataSource = self;
    //注册单元格
    [collView registerClass:[ConfirmCollectionViewCell class] forCellWithReuseIdentifier:@"colCell"];
    
    //
     [collView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    collView.backgroundColor = [UIColor clearColor];
    self.confirmCollection = collView;
    [self.view addSubview:collView];

    
    
    
    //警告文字
    UILabel * warming = [[UILabel alloc]init];
    warming.textColor = COLOR_LABEL_BULE;
    warming.text = @" 投票结果不能进行修改，请谨慎投票。";
    warming.textAlignment = NSTextAlignmentCenter;
    warming.font = [UIFont systemFontOfSize:14];
    self.warning = warming;
    
    [self.view addSubview:warming];

    
    //匿名投票按钮
    self.anonymous = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.anonymous setBackgroundImage:[UIImage imageNamed:@"anonymousBtn"] forState:UIControlStateNormal];
    [self.anonymous addAcionBlock:^{
        wSelf.anonymous.userInteractionEnabled = NO;
        NSMutableArray * cidArr = [[NSMutableArray alloc]init];
        for (CandidateModel * cMdeol in wSelf.confirmArr) {
            [cidArr addObject:cMdeol.vid];
        }
        NSString *str = [cidArr componentsJoinedByString:@","];
        
         [wSelf.viewModel voteWithString:str Withsname:@"匿名" ruleId:wSelf.ruleId];
        
    }];
    [self.view addSubview:self.anonymous];
    
    //实名投票
    /*
    self.autonym = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.autonym setBackgroundImage:[UIImage imageNamed:@"autonymBtn"] forState:UIControlStateNormal];
    [self.autonym addAcionBlock:^{
        wSelf.autonym.userInteractionEnabled = NO;
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray * cidArr = [[NSMutableArray alloc]init];
        for (CandidateModel * cMdeol in wSelf.confirmArr) {
            [cidArr addObject:cMdeol.vid];
        }
        NSString *str = [cidArr componentsJoinedByString:@","];
        
        [wSelf.viewModel voteWithString:str Withsname:[defaults objectForKey:@"personnelName"] ruleId:wSelf.ruleId];
        
    }];
    [self.view addSubview:self.autonym];
    */
     
    //重新选择按钮
    self.again = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.again setTitle:@"重新选择 >>" forState:UIControlStateNormal];
    [self.again setTitleColor:COLOR_LABEL_YELLOW forState:UIControlStateNormal];
    self.again.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.again addAcionBlock:^{
        //跳转说明界面
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self.view addSubview:self.again];
    

    
    //重新选择
    [self.again mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(wSelf.autonym.mas_bottom).offset([SmartTool heightForImageHeight:60]);
        make.bottom.equalTo(wSelf.view).offset(-40);
        make.right.equalTo(wSelf.view).offset(-50);
        
    }];
    
    //匿名投票
    [self.anonymous mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(wSelf.warning.mas_bottom).offset([SmartTool heightForImageHeight:177]);
        make.bottom.equalTo(wSelf.again.mas_top).offset(-20);
        make.centerX.equalTo(wSelf.view);
        make.width.mas_equalTo((mIPHONE_W - 90)/2);
        make.height.mas_equalTo(40);
    }];
    
    
    
    //实名投票
//    [self.autonym mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(wSelf.again.mas_top).offset(-20);
//        make.right.equalTo(wSelf.view).offset(-30);
//        make.width.mas_equalTo((mIPHONE_W - 90)/2);
//        make.height.mas_equalTo(40);
//    }];
    
    //警告文字
    [warming mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(wSelf.anonymous).offset(-48.5);
        make.centerX.equalTo(wSelf.view);
        
    }];
    
    //列表
    [collView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(wSelf.view).offset(0);
        make.left.equalTo(wSelf.view).offset(10);
        make.right.equalTo(wSelf.view).offset(0);
        make.bottom.equalTo(warming).offset(-20);
    }];

}


- (void)initViewModel
{
    self.viewModel = [[StarViewModel alloc] init];

    __weak typeof(self)wSelf = self;
  
    
    self.viewModel.submitBlock = ^(BOOL isVoted, NSString *reason){
        if (isVoted) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"投票成功"];

            int indexInNavi =0;
            for (int i = 0; i<wSelf.navigationController.viewControllers.count; i++) {
                UIViewController *vc = wSelf.navigationController.viewControllers[i];
                if ([vc isMemberOfClass:[StarViewController class]]) {
                   indexInNavi = i;
                    StarViewController *starVC = [[wSelf.navigationController viewControllers] objectAtIndex:indexInNavi];
                    starVC.voteSuccess = @"1";
                    break;
                }
            }
            
            
            //跳转结果柱状图
            BarChartViewController *barVC = [[BarChartViewController alloc] init];
//            barVC.ruleId = wSelf.model.rid;
            barVC.ruleId = wSelf.ruleId;
            
            [wSelf.navigationController pushViewController:barVC animated:YES];
            NSMutableArray *navigationarray = [NSMutableArray arrayWithArray:wSelf.navigationController.viewControllers];
            
            [navigationarray removeObjectAtIndex:navigationarray.count -2];
            [navigationarray removeObjectAtIndex:navigationarray.count -2];
            wSelf.navigationController.viewControllers = navigationarray;
            
        }else{
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:reason];
        }
        wSelf.anonymous.userInteractionEnabled = YES;
//        wSelf.autonym.userInteractionEnabled = YES;

    };

    
}

#pragma mark - collectionView代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
{
    return self.apNameArr.count;
}
//九宫格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self.apNameArr objectAtIndex:section]count];
}

//布置套餐数据九宫格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ConfirmCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"colCell" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        if (view) {
            [view removeFromSuperview];
        }
    }
    //获取cell内容model
    CandidateModel * cModel = [[CandidateModel alloc]init];
    cModel = self.apNameArr[indexPath.section][indexPath.row];
    
    cell.model = cModel;
    

    
    return cell;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier;
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader)
    {
        reuseIdentifier = @"header";
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        for (UIView *view in headerView.subviews) {
            if (view) {
                [view removeFromSuperview];
            }
        }
        
        headerView.backgroundColor = [UIColor clearColor];
        
        UILabel *title = [[UILabel alloc]init];
        title.textColor = COLOR_LABEL_YELLOW;
        title.font = [UIFont systemFontOfSize:FONTSIZE];
        [headerView addSubview:title];
        
        [title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(headerView);
        }];
        
        CandidateModel * cModel = self.apNameArr[indexPath.section][indexPath.row];
        title.text = cModel.apName;
        reusableview = headerView;

    }
    
    return reusableview;
    
}

//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
        CGSize size = {mIPHONE_W, 30};
        return size;
 
}





- (NSMutableArray *)confirmArr
{
    if (_confirmArr == nil) {
        _confirmArr = [NSMutableArray array];
    }
    return _confirmArr;
}

- (NSMutableArray *)apNameArr
{
    if (_apNameArr == nil) {
        _apNameArr = [NSMutableArray array];

    }
    return _apNameArr;
}


@end

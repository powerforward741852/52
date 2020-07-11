//
//  ChartTableViewCell.m
//  smartoa
//
//  Created by 熊霖 on 15/12/31.
//  Copyright © 2015年 xmsmart. All rights reserved.
//

#import "ChartTableViewCell.h"

#import "PrizeModel.h"
#import "myBarChart.h"

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

#define FONTSIZE 12
#define BASE 5

@interface ChartTableViewCell () <UIAlertViewDelegate>

@property (nonatomic,strong) myBarChart * myBC;
@property (nonatomic,weak) UIButton * sender;
@property (nonatomic,weak) UIView * barBgView;
@property (nonatomic,weak) UIView * barView;
@property (nonatomic,strong) UIView * bgView;

@end


@implementation ChartTableViewCell

@synthesize barChartBgColor;

@synthesize maxValue;/*!最大值。根据BASE与X轴最大值确认*/
@synthesize valueArray;/*!X轴*/
@synthesize titleArray;/*!Y轴*/
@synthesize colorArray;/*!颜色数组*/

@synthesize barBetweenWidth,barWidth,barHeight;/*!间距，宽，高*/
@synthesize barBgColor,barColor;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
//        [self initViewWithWidth:self.frame.size.width-30];
    }
    return self;
}

- (void)initView
{
    //    self.backgroundColor = [UIColor brownColor];
    barChartBgColor=[UIColor clearColor];
    colorArray = [NSMutableArray arrayWithObjects:
                  HexRGB(0xD94F4C),
                  HexRGB(0xD9834D),
                  HexRGB(0xEBA693),
                  HexRGB(0xA6A537),
                  HexRGB(0x87AB66),
                  HexRGB(0x87ACAD),
                  HexRGB(0x4BC4D2),
                  nil];
    
    
    barColor=[UIColor greenColor];
    
    UIView * bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor clearColor];
    self.bgView = bgView;
    [self addSubview:bgView];
}

/*
 * - 添加视图
 */


-(void)initViewWithWidth:(CGFloat )bWidth;
{
    for (UIView *subview in self.bgView.subviews) {
        [subview removeFromSuperview];
    }
    
    NSInteger max = [[valueArray valueForKeyPath:@"@max.intValue"] integerValue];
    maxValue=[self munber:max With:BASE]*BASE;
    
    for(int i=0;i<[valueArray count];i++)
    {
        UIView *barView=[[UIView alloc] initWithFrame:CGRectMake(5+4*FONTSIZE,barBetweenWidth+i*(barHeight+barBetweenWidth) , 0, barHeight)];
        barView.backgroundColor=colorArray[i%colorArray.count];
        barView.alpha=1;
        self.barView = barView;
        [self.bgView addSubview:barView];
        
        
        //点击事件
        UIButton * checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        checkBtn.frame = CGRectMake(5+4*FONTSIZE,barBetweenWidth+i*(barHeight+barBetweenWidth) , barWidth, barHeight);
        checkBtn.backgroundColor = [UIColor clearColor];
        checkBtn.tag = i;
        checkBtn.enabled = YES;
        [checkBtn addTarget:self action:@selector(showPeople:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.bgView addSubview:checkBtn];
        
        //Y轴
        UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(0, barBetweenWidth+i*(barHeight+barBetweenWidth), 4*FONTSIZE, barHeight)];

        title.font = [UIFont systemFontOfSize:FONTSIZE];
        title.text=[titleArray objectAtIndex:i];
        title.textColor=colorArray[i%colorArray.count];
        title.alpha=1;
        title.textAlignment=NSTextAlignmentLeft;
        
        [title setNumberOfLines:0];
        title.lineBreakMode =NSLineBreakByWordWrapping;
        
        
        CGSize size = [title sizeThatFits:CGSizeMake(CGRectGetWidth(title.frame), MAXFLOAT)];
        CGRect frame = title.frame;
        frame.size.height = size.height;
        title.frame = frame;
        
        CGPoint titCent = title.center;
        titCent.y = barView.center.y;
        title.center = titCent;
        
        [self.bgView addSubview:title];
        
        
        //X轴
        UILabel *word=[[UILabel alloc] initWithFrame:CGRectMake(5+4*FONTSIZE+5+barWidth/maxValue*[[valueArray objectAtIndex:i] floatValue], barBetweenWidth+i*(barHeight+barBetweenWidth),50, barHeight)];
        word.text=[valueArray objectAtIndex:i];
        word.font = [UIFont systemFontOfSize:FONTSIZE];
        
        word.textColor=colorArray[i%colorArray.count];
        word.alpha=0;
        word.textAlignment=NSTextAlignmentLeft;
        [self.bgView addSubview:word];
        
        
        
        [UIView beginAnimations:nil context:nil]; //标记动画的开始
        //持续时间
        [UIView setAnimationDuration:1.2f];  //动画的持续时间
        
        barView.frame=CGRectMake(5+4*FONTSIZE,barBetweenWidth+i*(barHeight+barBetweenWidth) ,barWidth/maxValue*[[valueArray objectAtIndex:i] floatValue] ,barHeight );
        title.alpha=1;
        word.alpha=1;

        [UIView commitAnimations];//标记动画的结束
        self.bgView.frame = CGRectMake(15, 0, bWidth, barBetweenWidth+valueArray.count*(barHeight+barBetweenWidth));
    }
    
    UIView *yline=[[UIView alloc] initWithFrame:CGRectMake(5+4*FONTSIZE, 0, 1, barBetweenWidth+valueArray.count*(barHeight+barBetweenWidth))];
    yline.backgroundColor=[UIColor grayColor];
    yline.alpha = 0.6;
    [self.bgView addSubview:yline];
    
    UIView *xline=[[UIView alloc] initWithFrame:CGRectMake(5+4*FONTSIZE, barBetweenWidth+valueArray.count*(barHeight+barBetweenWidth), barWidth+15, 0.5)];
    xline.backgroundColor=[UIColor grayColor];
    xline.alpha = 0.6;
    [self.bgView addSubview:xline];
    
    for (int a = 0; a < 6; a++) {
        UILabel * numLabel = [[UILabel alloc]initWithFrame:CGRectMake(5+4*FONTSIZE+barWidth/5*a, barBetweenWidth+valueArray.count*(barHeight+barBetweenWidth)+FONTSIZE/2, FONTSIZE*2, FONTSIZE)];
        CGPoint numCent = numLabel.center;
        numCent.x = 5+4*FONTSIZE+barWidth/5*a;
        numLabel.center = numCent;
        numLabel.textColor = colorArray[a%colorArray.count];
        numLabel.text = [NSString stringWithFormat:@"%.0f",maxValue/5*a];
        numLabel.font = [UIFont systemFontOfSize:FONTSIZE-3];
        numLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.bgView addSubview:numLabel];
        
    }
    
}



-(void)showPeople:(UIButton *)sender
{
    sender.backgroundColor = [UIColor grayColor];
    //    sender.frame = self.barView.frame;
    sender.alpha = 0.5;
    self.sender = sender;
    NSString *myMessage = [NSString stringWithFormat:@"%@获得%@票", titleArray[sender.tag], valueArray[sender.tag]];
    
    
    NSString *myTitle = @"个人详细";
    
    UIAlertView *alert = [[UIAlertView alloc]
                          
                          initWithTitle: myTitle
                          
                          message: myMessage
                          
                          delegate: self
                          
                          cancelButtonTitle: @"取消"
                          
                          otherButtonTitles: @"个人信息",nil];
    
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.sender.backgroundColor = [UIColor clearColor];
    
    if (buttonIndex == 1) {
        
        self.barCharBlock(self.index,self.sender.tag);
        
    }
//    else if (buttonIndex == 2){
//        
//        self.barCharttoViewBlock(self.index,self.sender.tag);
//    }
//    
    //    self.sender.frame = self.barBgView.frame;
    
    
}


/*
 * - 获得最大数值
 */
-(NSInteger)munber:(NSInteger)munberEx With:(int)munberDi;
{
    NSInteger intEx = munberEx/munberDi;
    int intDi = munberEx%munberDi;
    if (intDi > 0) {
        intEx = intEx+1;
    }
    if (intEx < 1) {
        intEx = 1;
    }
    
    return intEx;
}


-(void)setPriModel:(PrizeModel *)priModel{
    NSMutableArray * priArr = [PrizeModel mj_objectArrayWithKeyValuesArray:priModel.list];
    NSMutableArray * nameArr = [[NSMutableArray alloc]init];
    NSMutableArray * vtotalArr = [[NSMutableArray alloc]init];
    for (int a = 0; a < priArr.count; a++) {
        PrizeModel * pModel = priArr[a];
        [nameArr addObject:pModel.cname];
        [vtotalArr addObject:pModel.vtotal];
    }
    self.titleArray = nameArr;
    self.valueArray = vtotalArr;
    self.barHeight = 40;
    self.barWidth = mIPHONE_W - 100;
    self.barBetweenWidth = 10;
    self.barBgColor = [UIColor whiteColor];
    
    CGFloat heiht = 15+priModel.list.count*(30+15)+FONTSIZE*2;
    self.bgView.frame = CGRectMake(15, 0, self.frame.size.width-30, heiht);
    [self initViewWithWidth:self.frame.size.width-30];
}

@end


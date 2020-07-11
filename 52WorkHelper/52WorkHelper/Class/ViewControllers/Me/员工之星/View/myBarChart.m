//
//  myBarChart.m
//  view
//
//  Created by ren on 14-7-30.
//  Copyright (c) 2014年 ren. All rights reserved.
//

#import "myBarChart.h"
#import "Masonry.h"

#define FONTSIZE 12
#define BASE 50

@interface myBarChart ()<UIAlertViewDelegate>

@property (nonatomic,weak) UIButton * sender;
@property (nonatomic,weak) UIView * barBgView;
@property (nonatomic,weak) UIView * barView;

@end


@implementation myBarChart

@synthesize barChartBgColor;

@synthesize maxValue;/*!最大值。根据BASE与X轴最大值确认*/
@synthesize valueArray;/*!X轴*/
@synthesize titleArray;/*!Y轴*/
@synthesize colorArray;/*!颜色数组*/

@synthesize barBetweenWidth,barWidth,barHeight;/*!间距，宽，高*/
@synthesize barBgColor,barColor;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
  
//        
//        myBarChart *mybarchart=[[myBarChart alloc] initWithFrame:CGRectMake(10,150, 300, 300)];
//        mybarchart.backgroundColor=[UIColor clearColor];
//        NSInteger max = [[valueArray valueForKeyPath:@"@max.intValue"] integerValue];
//        maxValue=[self munber:max With:BASE]*BASE;
//        NSInteger maxV = max%50;
        
//        mybarchart.titleArray=dataTitleArray;
//        mybarchart.valueArray=dataArray;
//        mybarchart.barChartBgColor=[UIColor whiteColor];
//        barHeight=30;
//        barBetweenWidth=5;
//        mybarchart.barHeight=150;
//        mybarchart.barBgColor=[UIColor lightGrayColor];
//        mybarchart.barColor=[UIColor purpleColor];
//        [mybarchart initWithView];
//        [self.view addSubview:mybarchart];
        
    }
    return self;
}

-(void)initViewWithWidth:(CGFloat )bWidth;
{
    barChartBgColor=[UIColor whiteColor];
    colorArray = [NSMutableArray arrayWithObjects:
                  
                  [UIColor colorWithRed:1.000 green:0.010 blue:0.000 alpha:1.000],
                  [UIColor colorWithRed:0.510 green:1.000 blue:0.021 alpha:1.000],
                  [UIColor colorWithRed:0.947 green:1.000 blue:0.000 alpha:1.000],
                  [UIColor colorWithRed:1.000 green:0.528 blue:0.000 alpha:1.000],
                  [UIColor colorWithRed:1.000 green:0.000 blue:0.514 alpha:1.000],
                  [UIColor colorWithRed:1.000 green:0.000 blue:0.986 alpha:1.000],
                  [UIColor colorWithRed:0.510 green:0.021 blue:1.000 alpha:1.000],
                  [UIColor colorWithRed:0.098 green:0.000 blue:1.000 alpha:1.000],
                  [UIColor colorWithRed:0.000 green:0.436 blue:1.000 alpha:1.000],
                  [UIColor colorWithRed:0.000 green:0.950 blue:1.000 alpha:1.000],
                  [UIColor colorWithRed:0.000 green:1.000 blue:0.391 alpha:1.000],
                  [UIColor colorWithRed:0.152 green:1.000 blue:0.000 alpha:1.000],nil];
    
    
    barColor=[UIColor greenColor];
    
    NSInteger max = [[valueArray valueForKeyPath:@"@max.intValue"] integerValue];
    maxValue=[self munber:max With:BASE]*BASE;
    float scrollViewWidth=4*FONTSIZE+barWidth+15;
    float scrollViewHeight=barBetweenWidth+valueArray.count*(barHeight+barBetweenWidth)+FONTSIZE*2;
    scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, bWidth, self.frame.size.height)];
    scrollView.directionalLockEnabled=YES;
    scrollView.pagingEnabled=NO;
    scrollView.backgroundColor=barChartBgColor;
    scrollView.showsHorizontalScrollIndicator=YES;
    scrollView.indicatorStyle=UIScrollViewIndicatorStyleWhite;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate=self;
    scrollView.contentSize=CGSizeMake(scrollViewWidth, scrollViewHeight);
    [self addSubview:scrollView];
    
    for(int i=0;i<[valueArray count];i++)
    {
        UIView *barBgView=[[UIView alloc] initWithFrame:CGRectMake(5+4*FONTSIZE,barBetweenWidth+i*(barHeight+barBetweenWidth) ,barWidth, barHeight )];
        barBgView.backgroundColor=barBgColor;
        barBgView.alpha=0.3;
        self.barBgView = barBgView;
        [scrollView addSubview:barBgView];
        
        UIView *barView=[[UIView alloc] initWithFrame:CGRectMake(5+4*FONTSIZE,barBetweenWidth+i*(barHeight+barBetweenWidth) , 0, barHeight)];
        barView.backgroundColor=colorArray[i];
        barView.alpha=0.5;
        self.barView = barView;
        [scrollView addSubview:barView];
        
        //Y轴
        UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(0, barBetweenWidth+i*(barHeight+barBetweenWidth), 4*FONTSIZE, barHeight)];
        title.font = [UIFont systemFontOfSize:FONTSIZE];
        title.text=[titleArray objectAtIndex:i];
        title.textColor=[UIColor blackColor];
        title.alpha=0;
        title.textAlignment=NSTextAlignmentLeft;
        
        [title setNumberOfLines:0];
        title.lineBreakMode =NSLineBreakByWordWrapping;

        
        CGSize size = [title sizeThatFits:CGSizeMake(CGRectGetWidth(title.frame), MAXFLOAT)];
        CGRect frame = title.frame;
        frame.size.height = size.height;
        title.frame = frame;
        
        [scrollView addSubview:title];

        
        //X轴
        UILabel *word=[[UILabel alloc] initWithFrame:CGRectMake(5+4*FONTSIZE+5+barWidth/maxValue*[[valueArray objectAtIndex:i] floatValue], barBetweenWidth+i*(barHeight+barBetweenWidth),50, barHeight)];
        word.text=[valueArray objectAtIndex:i];
        word.font = [UIFont systemFontOfSize:FONTSIZE];

        word.textColor=[UIColor redColor];
        word.alpha=0;
        word.textAlignment=NSTextAlignmentLeft;
        [scrollView addSubview:word];
        
        //点击事件
        UIButton * checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        checkBtn.frame = barBgView.frame;
        checkBtn.backgroundColor = [UIColor clearColor];
        checkBtn.tag = i;
        [checkBtn addTarget:self action:@selector(showPeople:) forControlEvents:UIControlEventTouchUpInside];
        
        [scrollView addSubview:checkBtn];
        
        
        [UIView beginAnimations:nil context:nil]; //标记动画的开始
        //持续时间
        [UIView setAnimationDuration:1.5f];  //动画的持续时间
        
        barView.frame=CGRectMake(5+4*FONTSIZE,barBetweenWidth+i*(barHeight+barBetweenWidth) ,barWidth/maxValue*[[valueArray objectAtIndex:i] floatValue] ,barHeight );
        title.alpha=1;
        word.alpha=1;
        if(barWidth/maxValue*[[valueArray objectAtIndex:i] floatValue]<=barWidth)
        {
//            word.frame=CGRectMake(barBetweenWidth+i*(barWidth+barBetweenWidth), barWidth,barWidth, barWidth);
        }
        else
        {
//           word.frame=CGRectMake(barBetweenWidth+i*(barWidth+barBetweenWidth), barWidth/100.0*[[valueArray objectAtIndex:i] floatValue],barWidth, barWidth); 
        }
        
        
        
        
        [UIView commitAnimations];//标记动画的结束
        
    }
    
    UIView *yline=[[UIView alloc] initWithFrame:CGRectMake(5+4*FONTSIZE, 0, 1, barBetweenWidth+valueArray.count*(barHeight+barBetweenWidth))];
    yline.backgroundColor=[UIColor grayColor];
    yline.alpha = 0.6;
    [scrollView addSubview:yline];
    
    UIView *xline=[[UIView alloc] initWithFrame:CGRectMake(5+4*FONTSIZE, barBetweenWidth+valueArray.count*(barHeight+barBetweenWidth), barWidth+15, 0.5)];
    xline.backgroundColor=[UIColor grayColor];
    xline.alpha = 0.6;
    [scrollView addSubview:xline];
    
    for (int a = 0; a < 5; a++) {
        UILabel * numLabel = [[UILabel alloc]initWithFrame:CGRectMake(5+4*FONTSIZE+barWidth/4*a, barBetweenWidth+valueArray.count*(barHeight+barBetweenWidth)+FONTSIZE/2, FONTSIZE*2, FONTSIZE)];
        CGPoint numCent = numLabel.center;
        numCent.x = 4*FONTSIZE+barWidth/4*a;
        numLabel.center = numCent;
//        numLabel.textColor = [UIColor grayColor];
        numLabel.text = [NSString stringWithFormat:@"%.0f",maxValue/4*a];
        numLabel.font = [UIFont systemFontOfSize:FONTSIZE-3];
        numLabel.textAlignment = NSTextAlignmentCenter;
        
        [scrollView addSubview:numLabel];
        
    }
    
}



-(void)showPeople:(UIView *)sender
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
                          
                          otherButtonTitles: @"个人信息",@"投票详细",nil];

    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self chooseNumber:buttonIndex];
    
    self.sender.backgroundColor = [UIColor clearColor];
//    self.sender.frame = self.barBgView.frame;
    

}

-(void)chooseNumber:(int) num{
    
//    self.barChartBlock([NSString stringWithFormat:@"%d",num]);
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



@end

//
//  myBarChart.h
//  view
//
//  Created by ren on 14-7-30.
//  Copyright (c) 2014年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface myBarChart : UIView <UIScrollViewDelegate>
{
    UIScrollView *scrollView;
}

@property (nonatomic,retain) UIColor *barChartBgColor;

@property (nonatomic) float maxValue;
@property (nonatomic,retain) NSMutableArray *valueArray;
@property (nonatomic,retain) NSMutableArray *titleArray;
@property (nonatomic, retain) NSMutableArray *colorArray;

@property (nonatomic) float barWidth,barBetweenWidth,barHeight;
@property (nonatomic,retain) UIColor *barBgColor,*barColor;



-(void)initViewWithWidth:(CGFloat )bHieght;

@end

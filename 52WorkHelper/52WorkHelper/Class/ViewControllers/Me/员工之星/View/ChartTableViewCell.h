//
//  ChartTableViewCell.h
//  smartoa
//
//  Created by 熊霖 on 15/12/31.
//  Copyright © 2015年 xmsmart. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PrizeModel;

typedef void (^barChartBlock)(NSIndexPath *choose,NSInteger select);
typedef void (^barCharttoViewBlock)(NSIndexPath *choose,NSInteger select);


@interface ChartTableViewCell : UITableViewCell

@property (nonatomic,strong) PrizeModel * priModel;
@property (nonatomic,strong) NSIndexPath *index;
@property (nonatomic,strong) barChartBlock barCharBlock;
@property (nonatomic,strong) barCharttoViewBlock barCharttoViewBlock;

@property (nonatomic,retain) UIColor *barChartBgColor;

@property (nonatomic) float maxValue;
@property (nonatomic,retain) NSMutableArray *valueArray;
@property (nonatomic,retain) NSMutableArray *titleArray;
@property (nonatomic, retain) NSMutableArray *colorArray;

@property (nonatomic) float barWidth,barBetweenWidth,barHeight;
@property (nonatomic,retain) UIColor *barBgColor,*barColor;

@end

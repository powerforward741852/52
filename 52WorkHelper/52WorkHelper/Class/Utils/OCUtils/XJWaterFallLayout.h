//
//  XJWaterFallLayout.h
//  CangKeV1.0
//
//  Created by xujian on 16/6/15.
//  Copyright © 2016年 赵晨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XJWaterFallLayout;

@protocol XJWaterFallLayoutDelegate <NSObject>

@required
//计算item高度的代理方法，将item的高度与indexPath传递给外界
- (CGFloat)waterfallLayout:(XJWaterFallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath;

@end

@interface XJWaterFallLayout : UICollectionViewLayout
//列数
@property (nonatomic,assign)NSInteger columnCount;
//横向间距
@property (nonatomic,assign)NSInteger columnSpacing;
//纵向间距
@property (nonatomic,assign)NSInteger rowSpacing;
//item间距
@property (nonatomic,assign)UIEdgeInsets sectionInset;
//同时设置以上属性
-(void)setColumnSpacing:(NSInteger)columnSpacing rowSpacing:(NSInteger)rowSepacing sectionInset:(UIEdgeInsets)sectionInset;

//代理
@property (nonatomic,weak)id<XJWaterFallLayoutDelegate>water_delegate;
//计算item高度的block，将item的高度与indexPath传递给外界
@property (nonatomic, strong) CGFloat(^itemHeightBlock)(CGFloat itemHeight,NSIndexPath *indexPath);
//构造方法
+ (instancetype)waterFallLayoutWithColumnCount:(NSInteger)columnCount;
- (instancetype)initWithColumnCount:(NSInteger)columnCount;

@end

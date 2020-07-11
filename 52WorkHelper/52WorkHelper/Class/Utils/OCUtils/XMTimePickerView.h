//
//  XMTimePickerView.h
//  XMTimePickerView
//
//  Created by min on 2017/11/17.
//  Copyright © 2017年 min. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMTimePickerView;
@protocol XMTimePickerViewDelegate <NSObject>

/** 选中的时间 */
- (void)xm_didSelectTimePickerView:(XMTimePickerView *)pickerView andTime:(NSString *)time andRow:(NSInteger)selectRow andComp:(NSInteger)selectComp;

@end

@interface XMTimePickerView : UIView

/** 是否显示今天 */
@property (nonatomic, assign) BOOL isShowToday;

/** 最小时间 */
@property (nullable, weak, nonatomic) NSDate *minimumDate;

/** 代理 */
@property (nonatomic, assign) id<XMTimePickerViewDelegate> delegate;

/** 显示 */
- (void)show;

+ (UIColor *)colorWithHexString:(NSString *)color;

//当前已选月份
@property (nonatomic, assign) NSInteger curSelectRow;
//当前选择年份
@property (nonatomic, assign) NSInteger curSelectComp;
@end

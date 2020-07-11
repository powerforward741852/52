//
//  StarViewController.h
//  smartoa
//
//  Created by 陈昱珍 on 15/12/17.
//  Copyright © 2015年 xmsmart. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StarModel;

@interface StarViewController : UIViewController

/*!是否投过票*/
@property(nonatomic,strong) NSString * voteSuccess;

- (void)initViewWithifVote:(StarModel *)starModel;

@end

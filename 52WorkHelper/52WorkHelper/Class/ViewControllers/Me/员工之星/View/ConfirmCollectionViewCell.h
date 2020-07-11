//
//  ConfirmCollectionViewCell.h
//  smartoa
//
//  Created by 熊霖 on 16/1/8.
//  Copyright © 2016年 xmsmart. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CandidateModel;

@interface ConfirmCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong) CandidateModel *model;

-(void)addTheCell;

@end

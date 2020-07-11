//
//  VoteDetailsCollectionViewCell.m
//  smartoa
//
//  Created by 熊霖 on 16/1/6.
//  Copyright © 2016年 xmsmart. All rights reserved.
//

#import "VoteDetailsCollectionViewCell.h"
#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define COLOR_LABEL_BLUE HexRGB(0x2898FF)

@implementation VoteDetailsCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        
//        [self addTheCell];
        
    }
    return self;
}

-(void)addTheCell
{
    UILabel * nameLabel = [[UILabel alloc]init];
    nameLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    nameLabel.text = self.voteName;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = COLOR_LABEL_BLUE;
    nameLabel.font = [UIFont systemFontOfSize:14];
    
    [self.contentView addSubview:nameLabel];
    
//    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
    
}


@end

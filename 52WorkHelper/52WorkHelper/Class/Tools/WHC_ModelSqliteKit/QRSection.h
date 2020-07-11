//
//  QRSection.h
//  52WorkHelper
//
//  Created by 秦榕 on 2020/3/24.
//  Copyright © 2020 chenqihang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WHC_ModelSqlite.h"
#import "Item.h"
@interface QRSection : NSObject<WHC_SqliteInfo>
@property (nonatomic, assign) NSInteger workId;   /// 主键
@property (nonatomic, assign) NSInteger funcId;   /// 主键



@property (nonatomic, assign)  int lookTimeCount;
@property (nonatomic, assign)  long long lookTime;

@property (nonatomic, copy)  NSString * code;
@property (nonatomic, copy)  NSString * ind;
@property (nonatomic, copy)  NSString * name;
@property (nonatomic, strong) NSArray * items;

+ (NSString *)whc_SqliteVersion;
@end



//
//  Item.h
//  52WorkHelper
//
//  Created by 秦榕 on 2020/3/24.
//  Copyright © 2020 chenqihang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+WHC_Model.h"
#import "WHC_ModelSqlite.h"
@interface Item : NSObject<NSCoding>

@property (nonatomic, assign) NSInteger  workId;
@property (nonatomic, assign)  int lookTimeCount;
@property (nonatomic, assign)  long long lookTime;

@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * ind;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * icon;
@property (nonatomic, copy) NSString * itemId;
+ (NSString *)whc_SqliteVersion;
@end





//
//  StarViewModel.m
//  smartoa
//
//  Created by 陈昱珍 on 15/12/17.
//  Copyright © 2015年 xmsmart. All rights reserved.
//

#import "StarViewModel.h"
#import "StarModel.h"
#import "CandidateModel.h"
#import "ReturnModel.h"
#import "PrizeModel.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "SVProgressHUD.h"
//userdefault
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
@implementation StarViewModel
/*!获取活动规则*/
- (void)getRulesWithModel:(StarModel *)model
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *urlTask = [NSString stringWithFormat:@"%@activityVoteServlet",[USER_DEFAULT valueForKey:@"baseIP"]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"methodType"] = @"0";
    params[@"pno"] = [defaults objectForKey:@"personnelNo"];
    NSLog(@"----data--%@,%@",urlTask,params);
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    manage.requestSerializer = [AFJSONRequestSerializer serializer];
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manage GET:urlTask parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----data--%@",responseObject);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSString *msg = [dict objectForKey:@"msg"];
        if ([msg isEqualToString:@"0"]) {
            //错误信息
            NSLog(@"%@", [dict objectForKey:@"data"]);
            self.returenBlock([dict objectForKey:@"data"]);
        } else {
            NSDictionary *data = [dict objectForKey:@"data"];
            StarModel *model = [StarModel mj_objectWithKeyValues:data];
            self.starBlock(msg,model);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.returenBlock(@"网络请求失败");
        NSLog(@"error-------%@",error);
    }];
    
}

/*!获取候选人列表*/
- (void)getCandidatesWithModel:(StarModel *)model
{
    NSString *urlTask = [NSString stringWithFormat:@"%@activityVoteServlet",[USER_DEFAULT valueForKey:@"baseIP"]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = model.rid;
    params[@"methodType"] = @"1";
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    manage.requestSerializer = [AFJSONRequestSerializer serializer];
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manage GET:urlTask parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSString *msg = [dict objectForKey:@"msg"];
        
        if ([msg isEqualToString:@"0"]) {
            //错误信息
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"data"]];
        } else {
            NSDictionary *data = [dict objectForKey:@"data"];
            StarModel *model = [StarModel mj_objectWithKeyValues:data];
            self.starBlock(msg,model);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络请求失败"];
        NSLog(@"error-------%@",error);
    }];

}

/*!获取候选详情*/
- (void)getCandidateDetailWithModel:(CandidateModel *)model
{
    NSString *urlTask = [NSString stringWithFormat:@"%@activityVoteServlet",[USER_DEFAULT valueForKey:@"baseIP"]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"vid"] = model.vid;
    params[@"methodType"] = @"3";
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    manage.requestSerializer = [AFJSONRequestSerializer serializer];
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manage GET:urlTask parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSString *msg = [dict objectForKey:@"msg"];
        
        if ([msg isEqualToString:@"0"]) {
            //错误信息
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"data"]];
        } else {
            NSDictionary *data = [dict objectForKey:@"data"];
            CandidateModel *model = [CandidateModel mj_objectWithKeyValues:data];
            self.candidateBlock(model);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络请求失败"];
        NSLog(@"error-------%@",error);
    }];
    
}

/*!参与投票*/
- (void)voteWithString:(NSString *)string Withsname:(NSString *)sname ruleId:(NSString *)ruleid
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *urlTask = [NSString stringWithFormat:@"%@activityVoteServlet",[USER_DEFAULT valueForKey:@"baseIP"]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"vids"] = string;
    params[@"methodType"] = @"2";
    params[@"pno"] = [defaults objectForKey:@"personnelNo"];
    params[@"pname"] = [defaults objectForKey:@"personnelName"];
    params[@"sname"] = sname;
    params[@"ruleId"] = ruleid;

    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    manage.requestSerializer = [AFJSONRequestSerializer serializer];
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manage GET:urlTask parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSString *msg = [dict objectForKey:@"msg"];
        
        if ([msg isEqualToString:@"0"]) {
            //错误信息
            self.submitBlock(NO, [dict objectForKey:@"data"]);
        } else {
            //投票id
            self.submitBlock(YES, [dict objectForKey:@"data"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.submitBlock(NO, @"网络请求失败");
        NSLog(@"error-------%@",error);
    }];
}



/*!投票结果*/
-(void)getVoteDetailsWithruleId:(NSString *)ruleId{
    
    NSString *urlTask = [NSString stringWithFormat:@"%@activityVoteServlet",[USER_DEFAULT valueForKey:@"baseIP"]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"methodType"] = @"5";
    params[@"rid"] = ruleId;
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    manage.requestSerializer = [AFJSONRequestSerializer serializer];
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manage GET:urlTask parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        ReturnModel * returnModel = [ReturnModel mj_objectWithKeyValues:dict];
        NSString *msg = [dict objectForKey:@"msg"];
        
        if ([msg isEqualToString:@"1"]) {
            //投票详情
            self.voteDetailBlack(returnModel.msg, returnModel.data);
        } else {
            //错误信息
            self.voteDetailBlack(returnModel.data, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络请求失败"];
        NSLog(@"error-------%@",error);
    }];
}

/*!投票详情*/
-(void)getVoteDetailsWithvoteID:(NSString *)voteId{
    NSString *urlTask = [NSString stringWithFormat:@"%@activityVoteServlet",[USER_DEFAULT valueForKey:@"baseIP"]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"methodType"] = @"6";
    params[@"vid"] = voteId;
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    manage.requestSerializer = [AFJSONRequestSerializer serializer];
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manage GET:urlTask parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        ReturnModel * returnModel = [ReturnModel mj_objectWithKeyValues:dict];
        NSString *msg = [dict objectForKey:@"msg"];
        
        if ([msg isEqualToString:@"1"]) {
            //投票详情
            NSMutableArray *info = [PrizeModel mj_objectArrayWithKeyValuesArray:returnModel.data];
            self.votetoDetailsBlock(returnModel.msg, info);
        } else {
            //错误信息
            self.votetoDetailsBlock(returnModel.data, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error-------%@",error);
    }];

}

/*!获取活动规则*/
- (void)getIpWithModel
{
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    manage.requestSerializer = [AFJSONRequestSerializer serializer];
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manage GET:@"http://www.xmsmart.com/52/ip.php" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----data--%@",responseObject);
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *msg = [json objectForKey:@"msg"];
        if ([msg isEqualToString:@"0"]) {
            //错误信息
            NSLog(@"%@", [json objectForKey:@"data"]);
            self.returenBlock([json objectForKey:@"data"]);
        } else {
            NSString *url = [json objectForKey:@"ip"];
            [USER_DEFAULT setObject:url forKey:@"baseIP"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        self.returenBlock(@"网络请求失败");
        [SVProgressHUD showErrorWithStatus:@"网络请求失败"];
        NSLog(@"error-------%@",error);
    }];
    
}

@end

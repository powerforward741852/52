//
//  VoteDetailsViewController.m
//  smartoa
//
//  Created by 熊霖 on 16/1/6.
//  Copyright © 2016年 xmsmart. All rights reserved.
//

#import "VoteDetailsViewController.h"
#import "VoteDetailsView.h"
#import "PrizeModel.h"
#import "StarViewModel.h"
#import "SVProgressHUD.h"
@interface VoteDetailsViewController ()

@property(nonatomic,strong) VoteDetailsView *voteDetailsView;

@end

@implementation VoteDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投票详情";
    
    self.voteDetailsView = [VoteDetailsView voteDetailsView];
    self.voteDetailsView.frame = self.view.bounds;
    [self.view addSubview:self.voteDetailsView];
    
    [self initViewModel];
    

}

-(void)initViewModel{
    StarViewModel *viewModel = [[StarViewModel alloc] init];
    [viewModel getVoteDetailsWithvoteID:self.model.vid];
    __weak typeof(self)wSelf = self;
    viewModel.votetoDetailsBlock = ^(NSString *mag,NSArray * data){
        
        wSelf.model.list = data;
        self.voteDetailsView.model = wSelf.model;
        [SVProgressHUD dismiss];
    };
    
}



@end

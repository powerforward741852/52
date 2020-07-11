//
//  CandidateViewController.m
//  smartoa
//
//  Created by 陈昱珍 on 15/12/18.
//  Copyright © 2015年 xmsmart. All rights reserved.
//

#import "CandidateViewController.h"
#import "CandidateView.h"
#import "CandidateModel.h"
#import "StarViewModel.h"
#import "SVProgressHUD.h"
@interface CandidateViewController ()
@property(nonatomic,strong) CandidateView *candidateDetailView;
@end
@implementation CandidateViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"候选人信息";
    
    self.candidateDetailView = [CandidateView candidateView];
    self.candidateDetailView.frame = self.view.bounds;
    [self.view addSubview:self.candidateDetailView];
    
    [self initViewModel];

}

- (void)initViewModel
{
    StarViewModel *viewModel = [[StarViewModel alloc] init];
    [viewModel getCandidateDetailWithModel:self.model];
    __weak typeof(self)wSelf = self;
    viewModel.candidateBlock = ^(CandidateModel *model){
//        wSelf.model = model;
        model.vid = wSelf.model.vid;
        self.candidateDetailView.model = model;
        [SVProgressHUD dismiss];
    };
    
}
@end

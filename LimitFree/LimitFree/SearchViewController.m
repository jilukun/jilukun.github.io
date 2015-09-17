//
//  SearchViewController.m
//  LimitFree
//
//  Created by LZXuan on 15-7-24.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //不适合当前子类界面的都要重写
    [self addTitleViewWithName:@"搜索结果"];
    //没有左右按钮
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    //没有搜索条
    self.tableView.tableHeaderView = nil;
    //调用子类重写的
    [self firstDownload];
    [self createRefreshView];
}
//重写
- (void)firstDownload {
    self.currentPage = 1;
    self.isRefreshing = NO;
    self.isLoadMore = NO;
    //获取url
    NSString *url = [NSString stringWithFormat:self.url,self.currentPage,self.searchKey];
    //增加下载任务
    [self addTaskWithUrl:url isRefresh:YES];
}
- (void)createRefreshView {
    __weak typeof(self)weakSelf = self;
    //下拉刷新
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.isRefreshing = YES;
        weakSelf.currentPage = 1;
        
        NSString *url = [NSString stringWithFormat:weakSelf.url,weakSelf.currentPage,weakSelf.searchKey];
        //增加下载任务
        [weakSelf addTaskWithUrl:url isRefresh:YES];
        
    }];
    
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isLoadMore) {
            return ;
        }
        weakSelf.isLoadMore = YES;
        weakSelf.currentPage++;
        
        NSString *url = [NSString stringWithFormat:weakSelf.url,weakSelf.currentPage,weakSelf.searchKey];
        //增加下载任务
        [weakSelf addTaskWithUrl:url isRefresh:YES];
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

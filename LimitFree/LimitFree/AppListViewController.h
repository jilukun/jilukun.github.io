//
//  AppListViewController.h
//  LimitFree
//
//  Created by LZXuan on 15-7-23.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "BaseViewController.h"
#import "AFNetworking.h"
#import "AppCell.h"
#import "AppModel.h"
#import "JHRefresh.h"

@interface AppListViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    
    NSInteger _currentPage;
    BOOL _isRefreshing;
    BOOL _isLoadMore;
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic, strong)UITableView *   tableView;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic)        NSInteger currentPage;
@property (nonatomic)        BOOL  isRefreshing;
@property (nonatomic)        BOOL isLoadMore;
@property (nonatomic, strong)AFHTTPRequestOperationManager *manager;

@property (nonatomic, copy) NSString *requestUrl;
@property (nonatomic, copy) NSString *categoryType;

@property (nonatomic, copy) NSString *categoryId;//分类id

#pragma mark - 下面的方法 如果满足不了子类 可以重写
//左右按钮事件函数
- (void)leftClick:(UIButton *)button ;
- (void)rightClick:(UIButton *)button;
//增加任务
- (void)addTaskWithUrl:(NSString *)url isRefresh:(BOOL)isRefresh;
//第一次下载
- (void)firstDownload;
//创建 刷新视图
- (void)createRefreshView ;
//结束刷新
- (void)endRefreshing;

@end






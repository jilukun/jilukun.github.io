//
//  BaseViewController.h
//  Connotation
//
//  Created by LZXuan on 15-5-25.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "JHRefresh.h"

@interface BaseViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    AFHTTPRequestOperationManager *_manager;
    
    NSInteger _currentPage;//当前页
    BOOL _isRefreshing;//是否是下拉刷新
    BOOL _isLoadMore;//是否上拉加载
    
}

@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) BOOL isRefreshing;
@property (nonatomic,assign) BOOL isLoadMore;
//记录最后一个数据的更新时间 (-1)表示刷新
@property (nonatomic,copy) NSString *max_timestamp;
//分类 区分 界面
@property (nonatomic,copy) NSString *category;

@property (nonatomic,retain) NSMutableArray *dataArr;

//刷新
- (void)creatRefreshView ;
//结束刷新
- (void)endRefreshing;


//按页加载数据
- (void)loadDataPage:(NSInteger)page count:(NSInteger)count;

@end





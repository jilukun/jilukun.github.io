//
//  AppListViewController.m
//  LimitFree
//
//  Created by LZXuan on 15-7-23.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "AppListViewController.h"
#import "DetailViewController.h"
#import "CategoryViewController.h"
#import "SearchViewController.h"
#import "SettingsViewController.h"


#define kCellId  @"AppCell"

@interface AppListViewController () <UISearchBarDelegate>

@end

@implementation AppListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationInit];
    self.automaticallyAdjustsScrollViewInsets = NO;//取消半透明的条 对 滚动视图的影响
    [self createTableView];
    [self createAFHttpRequest];
    
    //第一次下载 应该由子类调用
    
}
#pragma mark - 初始化导航
- (void)navigationInit {
    //导航条的背景
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"navigationbar"] forBarMetrics:UIBarMetricsDefault];
    //导航标题
    [self addTitleViewWithName:self.title];
    [self addItemWithName:@"分类" target:self action:@selector(leftClick:) isLeft:YES];
    [self addItemWithName:@"设置" target:self action:@selector(rightClick:) isLeft:NO];
}
- (void)leftClick:(UIButton *)button {
    CategoryViewController *category = [[CategoryViewController alloc] init];
    //跳转之前传入 block
    [category setMyBlock:^(NSString *categoryId) {
       //内部选中cell 回调这个block
        //重新下载第一页的数据 根据 最新的categoryId
        self.currentPage = 1;
        self.categoryId = categoryId;
        
        
        NSString *url = nil;
        if ([self.categoryType isEqualToString:kHotType]) {
            //热榜接口和其他接口不一样
            url = [NSString stringWithFormat:kHotUrl,self.currentPage];
        }else{
            url = [NSString stringWithFormat:self.requestUrl,self.currentPage,self.categoryId];
        }
        //增加下载任务
        [self addTaskWithUrl:url isRefresh:YES];
        //滚动到表视图的 第0分区 第0行
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
    
    
    
    [self.navigationController pushViewController:category animated:YES];
    
}
- (void)rightClick:(UIButton *)button {
    //设置
    SettingsViewController *settings = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:settings animated:YES];
}
- (void)createTableView {
    self.dataArr = [[NSMutableArray alloc] init];
    if (!self.tableView) {//懒加载
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,kScreenSize.width, kScreenSize.height-64-49) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.view addSubview:self.tableView];
        //注册cell
        [self.tableView registerNib:[UINib nibWithNibName:@"AppCell" bundle:nil] forCellReuseIdentifier:kCellId];
        
        //创建 searchBar 作为 tableView的头视图
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 44)];
        searchBar.placeholder = @"60万应用等你搜搜看";
        //设置代理
        searchBar.delegate = self;
        self.tableView.tableHeaderView = searchBar;
    }
}
#pragma mark - -UISearchBarDelegate
//将要进入编辑模式调用
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    //显示cancel 按钮
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
//将要退出编辑模式调用
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    //隐藏cancel 按钮
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}
//点击cancel 被调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //清空内容
    searchBar.text = @"";
    [searchBar resignFirstResponder];//收键盘
}
// 点击 搜索按钮的时候调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //界面跳转
    SearchViewController *search = [[SearchViewController alloc] init];
   //搜索关键字 和url
    search.searchKey = searchBar.text;
    if ([self.categoryType isEqualToString:kLimitType]) {
        search.url = SEARCH_LIMIT_URL;
    }else if ([self.categoryType isEqualToString:kReduceType]) {
        search.url = SEARCH_REDUCE_URL;
    }else if ([self.categoryType isEqualToString:kFreeType]) {
        search.url = SEARCH_FREE_URL;
    }else {
        search.url = SEARCH_HOT_URL;
    }
    [self.navigationController pushViewController:search animated:YES];
    
    
}


- (void)createAFHttpRequest {
    self.manager = [AFHTTPRequestOperationManager manager];
    //返回二进制不解析
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

#pragma mark - 下面的方法 子类可以重写
- (void)addTaskWithUrl:(NSString *)url isRefresh:(BOOL)isRefresh {
    //弱引用指针 防止 block 中 两个强引用 导致死锁而内存泄露
    __weak typeof(self) weakSelf = self;
    
    //下载之前 设置特效
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleDrop];
    //设置 标题
    [MMProgressHUD showWithTitle:@"下载应用" status:@"loading...."];
    //下载完成 、失败 要关闭特效
    
    //加上缓存,有些时候我们的app界面 希望在离线情况下，浏览一页以前的数据，这时我们可以对这个界面把第一页数据做本地存储(不同需求做好可能一样)，这样的话可以节省流量，提高用户体验。
    //走本地满足3个条件 1.缓存文件存在2.不是刷新 3.没有超时
    
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:[LZXHelper getFullPathWithFile:url]];
    //文件是否超时 1小时
    BOOL isTimerOut = [LZXHelper isTimeOutWithFile:[LZXHelper getFullPathWithFile:url] timeOut:60*60];
    if ((isExist == YES)&&(isRefresh == NO)&&(isTimerOut == NO)) {
        //满足三个条件走本地
        
        //读缓存
        NSData *data = [NSData dataWithContentsOfFile:[LZXHelper getFullPathWithFile:url]];
        
        //json 解析
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *appArr = dict[@"applications"];
        for (NSDictionary *appDict in appArr) {
            AppModel *model = [[AppModel alloc] init];
            //kvc 赋值
            [model setValuesForKeysWithDictionary:appDict];
            [weakSelf.dataArr addObject:model];
        }
        //数据源数组变了 刷新表格
        [weakSelf.tableView reloadData];
        //关闭下载特效
        [MMProgressHUD dismissWithSuccess:@"ok" title:@"下载本地数据完成"];
        return;
    }
    
    
    //下载走的是网络请求下载
    
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            
            if(weakSelf.currentPage == 1) {
                [weakSelf.dataArr removeAllObjects];
                //只缓存 第一页数据 保存到本地
                //普通文件缓存
                [[NSFileManager defaultManager] createFileAtPath:[LZXHelper getFullPathWithFile:url] contents:responseObject attributes:nil];
            }
            
            
            //json 解析
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *appArr = dict[@"applications"];
            for (NSDictionary *appDict in appArr) {
                AppModel *model = [[AppModel alloc] init];
                //kvc 赋值
                [model setValuesForKeysWithDictionary:appDict];
                [weakSelf.dataArr addObject:model];
            }
            //数据源数组变了 刷新表格
            [weakSelf.tableView reloadData];
        }
        //结束刷新
        [weakSelf endRefreshing];
        //关闭特效
        [MMProgressHUD dismissWithSuccess:@"OK" title:@"下载网络数据"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
        //结束刷新
        [weakSelf endRefreshing];
        //关闭
        [MMProgressHUD dismissWithError:@"Error" title:@"下载数据"];
    }];
}
//界面第一次下载  -》子类调用
- (void)firstDownload {
    self.isRefreshing = NO;
    self.isLoadMore = NO;
    self.currentPage = 1;
    self.categoryId = @"0";
    
    NSString *url = nil;
    if ([self.categoryType isEqualToString:kHotType]) {
        //热榜接口和其他接口不一样
        url = [NSString stringWithFormat:kHotUrl,self.currentPage];
    }else{
        url = [NSString stringWithFormat:self.requestUrl,self.currentPage,self.categoryId];
    }
    //增加下载任务
    [self addTaskWithUrl:url isRefresh:NO];
}
#pragma mark - 刷新
//刷新   子类调用
- (void)createRefreshView {
    //增加下拉刷新
    
    //下面使用block 如果内部对self 进行操作 会存在 两个强引用 这样两个对象都不会释放导致内存泄露 (或者死锁就是两个对象不释放)
    //只要出现了循环引用 必须一强一弱 这样用完之后才会释放
    //arc 用 __weak  mrc __block
    
    __weak typeof (self) weakSelf = self;//弱引用
    
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //重新下载数据
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.isRefreshing = YES;//标记正在刷新
        weakSelf.currentPage = 1;
        
        NSString *url = nil;
        //注意 热榜接口和其他接口不一样
        if ([weakSelf.categoryType isEqualToString:kHotType]) {
            
            url = [NSString stringWithFormat:weakSelf.requestUrl,weakSelf.currentPage];
        }else {
            url = [NSString stringWithFormat:weakSelf.requestUrl,weakSelf.currentPage,weakSelf.categoryId];
        }
        
        [weakSelf addTaskWithUrl:url isRefresh:YES];
        
    }];
    
    //上拉加载更多
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //重新下载数据
        if (weakSelf.isLoadMore) {
            return ;
        }
        weakSelf.isLoadMore = YES;//标记正在刷新
        weakSelf.currentPage ++;//页码加1
        
        NSString *url = nil;
        //注意 热榜接口和其他接口不一样
        if ([weakSelf.categoryType isEqualToString:kHotType]) {
            
            url = [NSString stringWithFormat:weakSelf.requestUrl,weakSelf.currentPage];
        }else {
            url = [NSString stringWithFormat:weakSelf.requestUrl,weakSelf.currentPage,weakSelf.categoryId];
        }
        
        
        [weakSelf addTaskWithUrl:url isRefresh:YES];
    }];
    
}
- (void)endRefreshing {
    if (self.isRefreshing) {
        self.isRefreshing = NO;//标记刷新结束
        //正在刷新 就结束刷新
        [self.tableView headerEndRefreshingWithResult:JHRefreshResultNone];
    }
    if (self.isLoadMore) {
        self.isLoadMore = NO;
        [self.tableView footerEndRefreshing];
    }
}


#pragma mark - UITableView协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    //填充cell
    AppModel *model = self.dataArr[indexPath.row];
    //先传值
    cell.categoryType = self.categoryType;
    
    [cell showDataWithModel:model indexPath:indexPath];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
#pragma mark - 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //界面跳转
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    AppModel *model  = self.dataArr[indexPath.row];
    //传值
    detailVC.applicationId = model.applicationId;
    
    
    //push
    [self.navigationController pushViewController:detailVC animated:YES];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

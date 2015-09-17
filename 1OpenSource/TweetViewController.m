//
//  TweetViewController.m
//  OpenSource
//
//  Created by LZXuan on 15-4-9.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

#import "TweetViewController.h"

#import "GDataXMLNode.h"
#import "TweetCell.h"
#import "TweetModel.h"
#import "EGORefreshTableHeaderView.h"
#import "AFNetworking.h"
//ego 刷新

@interface TweetViewController () <UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    NSInteger _currentPage;
    BOOL _isRefreshing;
    BOOL _isLoadMore;
    EGORefreshTableHeaderView *_headerView;
    
    AFHTTPRequestOperationManager *_manager;
   
}
@property (nonatomic,retain)EGORefreshTableHeaderView *headerView;
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,assign)BOOL isRefreshing;
@property (nonatomic,assign)BOOL isLoadMore;
@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,retain) NSMutableArray *dataArr;
@end

@implementation TweetViewController
- (void)dealloc {
    [_manager release];
    self.headerView = nil;
    self.tableView = nil;
    [_dataArr release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatAF];
    [self creatTableView];
    
    //再创建刷新
    [self creatRefreshView];
    //点击 加载更多
    [self upPullView];
    
    _isLoadMore = NO;
    _isRefreshing = NO;
    _currentPage = 0;
    [self loadDataPage:_currentPage count:20];
    
}

#pragma mark - 刷新
- (void)creatRefreshView {
    self.headerView = [[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -self.tableView.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height)] autorelease];
    
    self.headerView.delegate = self;
    //获取最后一次 刷新时间
    [self.headerView refreshLastUpdatedDate];
    //粘贴到tableView
    [self.tableView addSubview:self.headerView];
    
}
- (void)upPullView {
    _isLoadMore = NO;
    //给tableView增加一个按钮尾视图
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 44);
    [button setTitle:@"点击加载更多..." forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = button;
}
- (void)btnClick:(UIButton *)button {
    if (_isLoadMore) {
        return;
    }
    _currentPage ++;
    _isLoadMore = YES;
    [self loadDataPage:_currentPage count:20];
}

#pragma mark - 滚动视图协议
//停止拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.headerView egoRefreshScrollViewDidEndDragging:scrollView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.headerView egoRefreshScrollViewDidScroll:scrollView];
}
#pragma mark - ego协议
//是否正在刷新
//yes表示正在刷新 返回yes 不能刷新
//                  NO 可以刷新
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {
    return _isRefreshing;
}
//开始刷新 如果上面的方法 返回no 才调用
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {
    _isRefreshing = YES;
    _currentPage = 0;

    [self loadDataPage:_currentPage count:20];
}
- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view {
    return [NSDate date];
}

- (void)creatTableView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64-49) style:UITableViewStylePlain] autorelease];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
}
#pragma mark - 创建af
- (void)creatAF {
    _manager = [[AFHTTPRequestOperationManager alloc] init];
    //返回格式 二进制 不解析
    _manager.responseSerializer  = [AFHTTPResponseSerializer serializer];
    
    _dataArr = [[NSMutableArray alloc] init];
}

- (void)loadDataPage:(NSInteger)page count:(NSInteger)count {
    NSString *url = [NSString stringWithFormat:kTweetUrl,page,count];
    
    __block typeof(self)mySelf = self;
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (mySelf.currentPage == 0) {
                [mySelf.dataArr removeAllObjects];
            }
            //因为返回数据格式是XML
            //1.创建文档树
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseObject encoding:NSUTF8StringEncoding error:nil];
            //2.xpath 找文档树下面的所有 tweet
            NSArray *tweetArr = [doc nodesForXPath:@"//tweet" error:nil];
            for (GDataXMLElement *tweetNode in tweetArr) {
                //获取里面的子节点的值
                TweetModel *model = [[TweetModel alloc] init];
                /*
                model.author = [tweetNode stringValueByName:@"author"];
                model.portrait = [tweetNode stringValueByName:@"portrait"];
                model.commentCount = [tweetNode stringValueByName:@"commentCount"];
                model.body = [tweetNode stringValueByName:@"body"];
                model.imgSmall = [tweetNode stringValueByName:@"imgSmall"];
                model.imgBig = [tweetNode stringValueByName:@"imgBig"];
                model.pubDate = [tweetNode stringValueByName:@"pubDate"];
                 */
                //可以用封装的方法 返回一个字典
                NSDictionary *dict = [tweetNode subDictWithArray:@[@"author",@"portrait",@"commentCount",@"body",@"imgSmall",@"imgBig",@"pubDate"]];
                //kvc
                [model setValuesForKeysWithDictionary:dict];
                [mySelf.dataArr addObject:model];
                [model release];
            }
            //刷新表格
            [mySelf.tableView reloadData];
            _isLoadMore = NO;
            _isRefreshing = NO;
            //停止刷新
            [mySelf.headerView egoRefreshScrollViewDataSourceDidFinishedLoading:mySelf.tableView];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
        _isLoadMore = NO;
        _isRefreshing = NO;
        //停止刷新
        [mySelf.headerView egoRefreshScrollViewDataSourceDidFinishedLoading:mySelf.tableView];
    }];
    
}
#pragma mark - tableView协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"TweetCell";
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TweetCell" owner:self options:nil] lastObject];
    }
    TweetModel *model = _dataArr[indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}
//动态算行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetModel *model = _dataArr[indexPath.row];
    CGFloat h = 34;
    h += [LZXHelper textHeightFromTextString:model.body width:235 fontSize:14];
    
    if (model.imgSmall.length) {
        //有图片
        h += 5 + 72;
    }
    h += 5+21+5;//最后一个5距离cell 下边界

    return h;
}

@end

//
//  BaseViewController.m
//  Connotation
//
//  Created by LZXuan on 15-5-25.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "BaseViewController.h"
#import "ConnotationModel.h"
#import "PicCell.h"
#import "CommentViewController.h"



@interface BaseViewController ()

@end

@implementation BaseViewController
- (void)dealloc {
    self.dataArr = nil;
    self.category = nil;
    self.tableView = nil;
    self.max_timestamp = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    self.isLoadMore = NO;
    self.isRefreshing = NO;
    self.currentPage = 0;
    //创建表格视图
    [self creatTableView];
    //创建 下载对象 af
    [self creatHttpRequest];
    
    self.max_timestamp = @"-1";//-1表示刷新
    //按页加载 第一次下载
    [self loadDataPage:self.currentPage count:30];
    //刷新视图
    [self creatRefreshView];
}


#pragma mark - 创建表格视图
- (void)creatTableView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"bg_navbar_blue"] forBarMetrics:UIBarMetricsDefault];
    
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64-49) style:UITableViewStylePlain] autorelease];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    if ([self.category isEqualToString:VIDEOS]) {
        [self.tableView registerNib:[UINib nibWithNibName:@"VideoCell" bundle:nil] forCellReuseIdentifier:@"VideoCell"];
    }else{
    //注册cell //段子 趣图 美女
        [self.tableView registerNib:[UINib nibWithNibName:@"PicCell" bundle:nil] forCellReuseIdentifier:@"PicCell"];
    }
    
    [self.view addSubview:self.tableView];
    
}
//创建下载对象
- (void)creatHttpRequest {
    _manager = [[AFHTTPRequestOperationManager alloc] init];
    
    //设置返回的格式 不让af 自动解析 返回二进制
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //创建数据源
    _dataArr = [[NSMutableArray alloc] init];
}

#pragma mark - 刷新
- (void)creatRefreshView {
    //非arc 写__block arc __weak解决 block 中的两个强引用导致的死锁
    
    __block typeof (self) mySelf = self;
    
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //下拉刷新
        if (mySelf.isRefreshing) {
            //正在刷新
            return ;
        }
        mySelf.isRefreshing = YES;//记录下拉刷新
        mySelf.max_timestamp = @"-1";
        mySelf.currentPage = 0;//刷新第一页
        //发送下载请求
        [mySelf loadDataPage:mySelf.currentPage count:30];
    }];
    
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //上拉加载更多
        if (mySelf.isLoadMore) {
            return ;
        }
        mySelf.isLoadMore = YES;
        mySelf.currentPage ++;//页码++
        id model = mySelf.dataArr.lastObject;
        //视频的model 和 其他的model 都有update_time
        //记录一下最后 一个model的刷新时间 这样才可以做上拉加载
        mySelf.max_timestamp = [model update_time];
        //下载数据
        [mySelf loadDataPage:mySelf.currentPage count:15];
        
    }];
}

//结束刷新(下载之后)
- (void)endRefreshing {
    if (self.isRefreshing) {
        self.isRefreshing = NO;
        [self.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    if (self.isLoadMore) {
        self.isLoadMore = NO;
        [self.tableView footerEndRefreshing];
    }
}



#pragma mark - 按页加载数据
//视频接口需要重写
- (void)loadDataPage:(NSInteger)page count:(NSInteger)count {
    //获取url
    NSString *newUrl = [NSString stringWithFormat:CONTENTS_URL,self.category,self.currentPage,count,self.max_timestamp];
   
    //typeof(self)获取self 的类型
    
    __block typeof(self) mySelf =self;
    
    //af get请求下载
    [_manager GET:newUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //responseObject下载下来的数据
        //json数据
        if (responseObject) {
            
            //如果下拉刷新要把 之前都要删除
            if (mySelf.currentPage == 0) {
                [mySelf.dataArr removeAllObjects];
            }
            
            
            //json解析 最外层是字典
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *itemArr = dict[@"items"];
            //遍历数组
            //数组中是字典
            for (NSDictionary *itemDict in itemArr) {
                ConnotationModel *model = [[ConnotationModel alloc]init];
                //kvc赋值 ->字典中的key 对应的就是 model 的属性 value 就是属性的值
                [model setValuesForKeysWithDictionary:itemDict];
                /*
                 等价于 下面 一大堆属性赋值
                model.update_time = dict[@"update_time"];
                model.wbody = dict[@"wbody"];
                 ...
                 
                 */
                [mySelf.dataArr addObject:model];
                [model release];
            }
            //下载完成之后刷新
            [mySelf.tableView reloadData];
            
        }
        //结束刷新
        [mySelf endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
        //结束刷新
        [mySelf endRefreshing];//下载失败也要加结束刷新
    }];
    
}
#pragma mark - TableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
//视频接口要重写这个方法
//创建获取cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取注册的cell
    PicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PicCell" forIndexPath:indexPath];
    ConnotationModel *model = _dataArr[indexPath.row];
    //传入分类
    cell.catetory = self.category;

    //填充cell
    [cell showDataWithModel:model];
    
    __block typeof(self)mySelf = self;
    //把block 传入
    [cell setMyBlock:^(ConnotationModel *model) {
        //这个block cell 点击评论按钮的时候调用
        CommentViewController *comment = [[CommentViewController alloc] init];
        comment.url = [NSString stringWithFormat:COMMENTS_URL,model.wid,mySelf.category];
        [mySelf.navigationController pushViewController:comment animated:YES];
        [comment release];
    }];
    
    
    return cell;
}
//视频接口重写
//动态计算cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConnotationModel *model = _dataArr[indexPath.row];
    //动态计算每一个cell的高度
    CGFloat height = 22;
    //动态算高
    height += [LZXHelper textHeightFromTextString:model.wbody width:kScreenSize.width-40 fontSize:14];
    if (model.wpic_middle) {
        //有图片算图片
        height +=5+ (kScreenSize.width-40)*model.wpic_m_height.doubleValue/model.wpic_m_width.doubleValue;
    }
    //算出button 的
    height += 5 + 30 +5;//第一个5是button和上面的视图间隔最后一个5是button 和cell 下边界的间隔
    return height;
    
}

/*
 如果除数为0
 程序会崩溃
 信息
 Terminating app due to uncaught exception 'CALayerInvalidGeometry', reason: 'CALayer position contains NaN: [160 nan]'
 
 */




@end

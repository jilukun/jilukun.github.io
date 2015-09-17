//
//  SubjectViewController.m
//  LimitFree
//
//  Created by LZXuan on 15-7-23.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "SubjectViewController.h"
#import "SubjectCell.h"
#import "SubjectModel.h"
#import "DetailViewController.h"


@interface SubjectViewController ()

@end

@implementation SubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //专题界面和其他界面 都不一样 所有很多操作要重写设置
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    self.tableView.tableHeaderView = nil;
    //注册 cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SubjectCell" bundle:nil] forCellReuseIdentifier:@"SubjectCell"];
    
    [self firstDownload];
    [self createRefreshView];
}
#pragma mark - 重写 父类 不适合子类的方法
- (void)firstDownload {
    self.currentPage = 0;//
    self.isRefreshing = NO;
    self.isLoadMore = NO;
    NSString *url = [NSString stringWithFormat:kSubjectUrl,self.currentPage];
    
    [self addTaskWithUrl:url isRefresh:YES];
}

- (void)createRefreshView {
    //增加下拉刷新

    __weak typeof (self) weakSelf = self;//弱引用
    
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //重新下载数据
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.isRefreshing = YES;//标记正在刷新
        weakSelf.currentPage = 0;
        
        NSString *url = [NSString stringWithFormat:kSubjectUrl,weakSelf.currentPage];
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
        NSString *url = [NSString stringWithFormat:kSubjectUrl,weakSelf.currentPage];
        [weakSelf addTaskWithUrl:url isRefresh:YES];
    }];
}
- (void)addTaskWithUrl:(NSString *)url isRefresh:(BOOL)isRefresh {
    __weak typeof(self)weakSelf = self;
    
    //下载之前 设置特效
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleDrop];
    //设置 标题
    [MMProgressHUD showWithTitle:@"下载专题" status:@"loading...."];
    //下载完成 、失败 要关闭特效
    
    
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            //最外层是数组
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            //遍历数组
            for (NSDictionary *subjectDict in arr) {
                SubjectModel *subjectModel = [[SubjectModel alloc] init];
                [subjectModel setValuesForKeysWithDictionary:subjectDict];
                //专门给 SubjectModel 中数组 赋值为 AppModel 对象地址
                NSMutableArray *appArr = [[NSMutableArray alloc] init];
                
                //appArr 存放AppModel
                NSArray *applications = subjectDict[@"applications"];
                for (NSDictionary *appDict in applications) {
                    AppModel *appModel = [[AppModel alloc] init];
                    [appModel setValuesForKeysWithDictionary:appDict];
                    [appArr addObject:appModel];
                }
                //修改 subJectModel 中数组
                subjectModel.applications = appArr;
                //把专题model 存放在 数据源数组
                [weakSelf.dataArr addObject:subjectModel];
            }
            //刷新表格
            [weakSelf.tableView reloadData];
            [MMProgressHUD dismissWithSuccess:@"ok" title:@"下载数据"];
        }
        [weakSelf endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"专题下载失败");
        [weakSelf endRefreshing];
        [MMProgressHUD dismissWithError:@"Error" title:@"下载数据"];
    }];
}
#pragma mark - 重写tableView协议

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubjectCell" forIndexPath:indexPath];
    //填充cell
    SubjectModel *model = self.dataArr[indexPath.row];
    [cell showDataWithSubjectModel:model jumpBlock:^(NSString *appId) {
        //传block 进行回调
        //这个block 实现界面跳转
        //点击 右侧 四个小AppView 要回调block  进行界面跳转
        DetailViewController *detail = [[DetailViewController alloc] init];
        //传值
        detail.applicationId = appId;
        
        //跳转
        [self.navigationController pushViewController:detail animated:YES];
        
    }];
    return cell;
}
//重写父类的这个选中方法 子类 cell 选中之后什么都不能做
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}



/*
 [
 {
 "title": "休假前的悠闲时光",
 "date": "2013-09-27",
 "desc": "小编mm推荐：时间过的好快啊，听说马上就要放个小长假啦！看什么看，还不快赶紧准备点儿“精神食粮”。",
 "desc_img": "http://special.candou.com/2a59c03fa326fc427e58909436d1b8b4.jpg",
 "img": "http://special.candou.com/050ba3ea655e0bbaf8e9f71986113e7f.jpg",
 "applications": [
 {
 "applicationId": "493901993",
 "downloads": "8669",
 "iconUrl": "http://photo.candou.com/i/114/4a6eac8ddc276494f2b0d28ce82c48e6",
 "name": "节奏大师",
 "ratingOverall": "21475",
 "starOverall": "2.5"
 }
 ]
 },
 {
 */




@end
